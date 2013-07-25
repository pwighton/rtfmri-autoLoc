% Given:
%   orient: slice orientation (sag,cor,tra,sc,st,ct,cs,ts,tc)
%   theta:  rotations in 'native' space
%   numvox: number of voxels in the read/phase/slice directions
%   voxdim: voxel dimensions  in the read/phase/slice directions
%   patient: patient orientation (hfs,hfp,hfr,hfl,ffs,ffp)
%   
% Returns:
%   V.numvox
%   V.voxdim
%   V.fov
%   V.theta
%   V.offset
%   V.patient
%   V.L2R
%   V.S
%   V.PO
%   V.M
%   V.N
%   V.F
%   V.R1
%   V.R2
%   V.R3
%   V.W
%   V.Pl
%   V.Pr
%   V.V



function V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient)

    V.numvox = numvox;
    V.voxdim = voxdim;
    V.fov = voxdim .* numvox;
    V.theta = theta;
    V.offset = offset;
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
    
    % Set the 'native' direction cosines
	switch fov_orient
		case 'sag'
            V.slice_orient = 'sag';
            V.N = [0,0,1,0;-1,0,0,0;0,1,0,0;0,0,0,1];
            %V.N = [0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation
            % we negate theta(3) so that the euler angle is consistent with
            % others..
            V.R3 = [cosd(-theta(3)),sind(-theta(3)),0,0;-sind(-theta(3)),cosd(-theta(3)),0,0;0,0,1,0;0,0,0,1];
        case 'sc'
            V.slice_orient = 'sc';
            V.F = [0,0,1,0;-1,0,0,0;0,1,0,0;0,0,0,1];
            V.N = V.F * V.M;
            % R1 and R2 are the inverse of what they are for st            
            V.R1 = [cosd(theta(1)),0,-sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(2)),sind(theta(2)),0;0,-sind(theta(2)),cosd(theta(2)),0;0,0,0,1];
            % In plane rotation
            % we negate theta(3) so that the euler angle is consistent with
            % others..
            V.R3 = [cosd(-theta(3)),sind(-theta(3)),0,0;-sind(-theta(3)),cosd(-theta(3)),0,0;0,0,1,0;0,0,0,1];
        case 'st'
            % Precision isn't the best here (?)
            V.slice_orient = 'st';
            V.F = [0,0,1,0;-1,0,0,0;0,1,0,0;0,0,0,1];
            V.N = V.F * V.M;
            % R1 and R2 are the inverse of what they are for sc
            V.R2 = [1,0,0,0;0,cosd(theta(1)),sind(theta(1)),0;0,-sind(theta(1)),cosd(theta(1)),0;0,0,0,1];
            V.R1 = [cosd(theta(2)),0,-sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];
            % In plane rotation
            % we negate theta(3) so that the euler angle is consistent with
            % others..
            V.R3 = [cosd(-theta(3)),sind(-theta(3)),0,0;-sind(-theta(3)),cosd(-theta(3)),0,0;0,0,1,0;0,0,0,1];
		case 'cor'
            V.slice_orient = 'cor';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation (transpose of sag rotation)            
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
		case 'ct'
             % Precision isn't the best here (?)
            V.slice_orient = 'ct';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for cs
            V.R2 = [1,0,0,0;0,cosd(theta(1)),sind(theta(1)),0;0,-sind(theta(1)),cosd(theta(1)),0;0,0,0,1];
            V.R1 = [cosd(theta(2)),0,-sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)                        
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
		case 'cs'
            V.slice_orient = 'cs';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            % R1 and R2 are the inverse of what they are for ct
            V.R1 = [cosd(theta(1)),0,-sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(2)),sind(theta(2)),0;0,-sind(theta(2)),cosd(theta(2)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)            
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];            
        case 'tra'            
            V.slice_orient = 'tra';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
        case 'ts'
            % Precision isn't the best here (?)
            V.slice_orient = 'ts';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for tc
            V.R1 = [cosd(theta(1)),0,-sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];            
            % Here we negate theta(2) to make the euler angle consistent
            V.R2 = [1,0,0,0;0,cosd(-theta(2)),sind(-theta(2)),0;0,-sind(-theta(2)),cosd(-theta(2)),0;0,0,0,1];            
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
        case 'tc'
            % Precision is downright awful here (?)
            V.slice_orient = 'tc';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for ts
            V.R1 = [cosd(theta(2)),0,-sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];            
            % Here we negate theta(1) to make the euler angles consistent
            V.R2 = [1,0,0,0;0,cosd(-theta(1)),sind(-theta(1)),0;0,-sind(-theta(1)),cosd(-theta(1)),0;0,0,0,1];
            
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),sind(theta(3)),0,0;-sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
        otherwise
			warning('Unrecognized FOV. Hope you like eye(4)');
			V.N = eye(4);            
    end
    
    % The grad2world matrix
    V.W = V.F * V.R1 * V.R2 * V.R3 * V.M;
    V.W(:,4) = V.F * V.R1 * V.R2 * V.R3 * V.M * -offset;
    V.W(4,4) = 1;
    
    % The grad2lps matrix
    V.Pl = V.PO * V.W;
    
    % The grad2ras matrix
    V.Pr = V.L2R * V.Pl;
    
    % The vox2ras matrix
    V.V = V.Pr * V.S;      
    fovcorner_r = V.Pr * ([V.fov(1),V.fov(2),V.fov(3)-voxdim(3),0]'./-2) - offset;    
    V.V(:,4) = fovcorner_r;
    V.V(4,4) = 1;
end

