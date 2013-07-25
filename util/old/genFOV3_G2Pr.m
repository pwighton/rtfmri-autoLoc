% Given:
%   numvox: number of voxels in the read/phase/slice directions
%   voxdim: voxel dimensions  in the read/phase/slice directions
%   patient: 
%   G2Pr: a gradient to patient (ras) matrix
%   
% Returns:
%   Stuff

function V = genFOV3_G2Pr(numvox, voxdim, patient, G2Pr)

    V.numvox = numvox;
    V.voxdim = voxdim;
    V.fov = voxdim .* numvox;
    V.patient = patient;
    % Convert lps 2 ras
    V.L2R = [-1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1];
    
    % The scaling matrix to go from mm-->vox
    V.S = eye(4);
	V.S(1,1) = voxdim(1);
	V.S(2,2) = voxdim(2);
	V.S(3,3) = voxdim(3);
        
    switch patient
		case 'hfs'
			V.PO = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
		case 'hfp'
			V.PO = [-1,0,0,0;0,1,0,0;0,0,-1,0;0,0,0,1];
		case 'hfr'
			V.PO = [0,1,0,0;1,0,0,0;0,0,-1,0;0,0,0,1];
		case 'hfl'
			V.PO = [0,-1,0,0;-1,0,0,0;0,0,-1,0;0,0,0,1];
		case 'ffs'
			V.PO = [-1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1];
		case 'ffp'
			V.PO = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
		otherwise
			warning('Unrecognized patient orientation. Hope you like eye(4)');
			V.PO = eye(4);   
    end
    
    % The 'master' space.  All rotations happen in this space
    % The master space is rtansformed to 'native' space based on slice
    % orientation
    %  N = F M
    %  M = inv(F) N
    %  Where F is the transformation defined by the fov (sag,cor,tra,etc)
    V.M = eye(4);
    
    % The grad2ras matrix    
    V.Pr = G2Pr;
   
    V.offset = inv(V.Pr) * [0,0,0,1]';
    
    % Now start 'working backwards'       
    % V.Pr = V.L2R * V.Pl;
    V.Pl = inv(V.L2R) * V.Pr;
    
    % V.Pl = V.PO * V.W;
    V.W = inv(V.PO) * V.Pl;

    % Calculate offset to iso center (in gradient coords)
    V.offset_w = inv(V.W) * [0,0,0,1]';
    
    % The vox2ras matrix V.offset_w = inv(V.W) * [0,0,0,1]';
    V.V = V.Pr * V.S;      
    fovcorner_r = V.Pr * ([V.fov(1),V.fov(2),V.fov(3)-voxdim(3),0]'./-2) - V.offset_w;    
    V.V(:,4) = fovcorner_r;
    V.V(4,4) = 1;

    % Now lets decompose the world matrix to find slice orientation and
    % euler angles.  We will do so for every possible orientation
    % Recall: 
    %   1) V.W = V.F * V.R1 * V.R2 * V.R3 * V.M;
    
    %   2) R1 = | cos  0  -sin |
    %           |  0   1    0  |
    %           | sin  0   cos |
    
    %      R2 = |  0   0    0  |
    %           |  0  cos  sin |
    %           |  0 -sin  cos |
    
    %      R3 = | cos sin   0  |
    %           |-sin cos   0  |
    %           |  0   0    1  |
    
    % R1 * R2 * R3 = | -sin(t1)sin(t2)sin(t3)  sin(t1)sin(t2)cos(t3) -sin(t1)cos(t2) |
    %                |        -cos(t2)sin(t3)         cos(t2)cos(t3)         sin(t2) |
    %                |  cos(t1)sin(t2)sin(t3) -cos(t1)sin(t2)cos(t3)  cos(t1)cos(t2) |
        
    V.perm{1}.orient = 'sc';
    V.perm{1}.F = [0,0,1,0;-1,0,0,0;0,1,0,0;0,0,0,1];
    V.perm{1}.R1R2R3 = inv(V.perm{1}.F) * V.W;    
    V.perm{1}.theta(2) = asind(V.perm{1}.R1R2R3(2,3));
    V.perm{1}.theta(1) = acosd(V.perm{1}.R1R2R3(3,3)./cosd(V.perm{1}.theta(2)));
    V.perm{1}.theta(3) = acosd(V.perm{1}.R1R2R3(2,2)./cosd(V.perm{1}.theta(2)));    
    if (abs(V.perm{1}.theta(2))>abs(V.perm{1}.theta(1)))
        V.perm{1}.orient = 'st';
        temp = V.perm{1}.theta(2);
        V.perm{1}.theta(2) = V.perm{1}.theta(1);
        V.perm{1}.theta(1) = temp;         
    end
    V.perm{1}.theta_neg = V.perm{1}.theta;
    V.perm{1}.theta_neg(3) = -V.perm{1}.theta_neg(3);

    V.perm{2}.orient = 'cs';
    V.perm{2}.F = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
    V.perm{2}.R1R2R3 = inv(V.perm{2}.F) * V.W;
    V.perm{2}.theta(2) = asind(V.perm{2}.R1R2R3(2,3));
    V.perm{2}.theta(1) = acosd(V.perm{2}.R1R2R3(3,3)./cosd(V.perm{2}.theta(2)));    
    V.perm{2}.theta(3) = acosd(V.perm{2}.R1R2R3(2,2)./cosd(V.perm{2}.theta(2)));
    if (abs(V.perm{2}.theta(2))>abs(V.perm{2}.theta(1)))
        V.perm{2}.orient = 'ct';
        temp = V.perm{2}.theta(2);
        V.perm{2}.theta(2) = V.perm{2}.theta(1);
        V.perm{2}.theta(1) = temp;         
    end
    V.perm{2}.theta_neg = V.perm{2}.theta;

    V.perm{3}.orient = 'ts';
    V.perm{3}.F = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
    V.perm{3}.R1R2R3 = inv(V.perm{3}.F) * V.W;
    V.perm{3}.theta(2) = -asind(V.perm{3}.R1R2R3(2,3));
    V.perm{3}.theta(1) = acosd(V.perm{3}.R1R2R3(3,3)./cosd(V.perm{3}.theta(2)));    
    V.perm{3}.theta(3) = acosd(V.perm{3}.R1R2R3(2,2)./cosd(V.perm{3}.theta(2)));
    V.perm{3}.theta_neg = V.perm{3}.theta;
    V.perm{3}.theta_neg(2) = -V.perm{3}.theta_neg(2);
    if (abs(V.perm{3}.theta(2))>abs(V.perm{3}.theta(1)))
        V.perm{3}.orient = 'tc';
        temp = V.perm{3}.theta(2);
        V.perm{3}.theta(2) = V.perm{3}.theta(1);
        V.perm{3}.theta(1) = temp;
        temp = V.perm{3}.theta_neg(2);
        V.perm{3}.theta_neg(2) = V.perm{3}.theta_neg(1);
        V.perm{3}.theta_neg(1) = temp;
    end
    
    % We choose the permutation that minimzes abs(theta1 + theta2)..
    theta_temp(1,:) = V.perm{1}.theta(1:2);
    theta_temp(2,:) = V.perm{2}.theta(1:2);
    theta_temp(3,:) = V.perm{3}.theta(1:2);
    [~,chosen_perm] = min(sum(abs(theta_temp),2));
    
    temp = V;       
    V = genFOV3(V.numvox, V.voxdim, V.perm{chosen_perm}.orient, V.perm{chosen_perm}.theta, V.offset, V.patient);
    V.perm = temp.perm;
    V.theta_neg = temp.perm{chosen_perm}.theta_neg;
end

