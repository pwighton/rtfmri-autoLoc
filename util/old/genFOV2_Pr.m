% Given:
%   Gradient to patient matrix 
%   numvox: number of voxels in the read/phase/slice directions
%   voxdim: voxel dimensions  in the read/phase/slice directions
%   patient: patient orientation (hfs,hfp,hfr,hfl,ffs,ffp)
%   
% Returns:
%   V.native -- the unroated direction cosines in 'native' space
%   V.g2n -- matrix to convert gradient coords to 'native' space
%   V.Rn2n -- matrix to convert unrotated fov to rotated fov (using theta)
%      V.g2n = R_n2n * V.native
%   V.g2w -- matrix to convert gradient coords to world
%   V.fov_pre -- pre-multiply to convert g2n --> g2w
%   V.fov_post -- post-multiple to convert g2n --> g2w
%      V.g2w = V.fov_pre * V.g2n * V.fov_post
%   V.g2p -- matrix to convert gradient coords to patient (ras)
%   V.po -- patient orientation to convert g2w --> g2p
%      V.g2p = V.g2w * V.po
%   V.v2p -- matrix to convert voxel coords to patient (also known as
%   vox2ras)


function V = genFOV2(numvox, voxdim, patient, Pr)

    V.numvox = numvox;
    V.voxdim = voxdim;
    V.fov = voxdim .* numvox;
       
    % Convert lps 2 ras
    V.L2R = [-1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1];
    
    % The scaling matrix to go from mm-->vox
    V.S = eye(4);
	V.S(1,1) = voxdim(1);
	V.S(2,2) = voxdim(2);
	V.S(3,3) = voxdim(3);
    
    % The translation matrix
    %V.T = zeros(4);
    %V.T(1:3,4) = offset;
    
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
    V.Pr = Pr;
    
    % Calculate the offset to isocenter in gradient coords
    offset_g = inv(Vcs20t10rl15_r10a20h30.Pr)*[0,0,0,1]'

    % The vox2ras matrix
    V.V = V.Pr * V.S;
    fovcorner_r = V.Pr * ([V.fov(1),V.fov(2),V.fov(3)-voxdim(3),0]'./-2) - offset_g;
    V.V(:,4) = fovcorner_r;
    V.V(4,4) = 1;   

    % Now work backwards...
    
    % The grad2lps matrix
    % V.Pr = V.L2R * V.Pl;
    V.Pl = inv(V.L2R) * V.Pr;

    % The grad2world matrix
    % V.Pl = V.PO * V.W;
    V.W = inv(V.PO) * V.Pl;

    % Try all permutations
    % recall: V.W = V.F * V.R1 * V.R2 * V.R3 * V.M;
    V.perm{1}.slice_orient = 'sc'
    V.perm{1}.N = [0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
    V.perm{1}.F = V.perm{1}.N * inv(V.M);
    V.perm{1}.R = inv(V.perm{1}.F) * V.W;
    V.perm{1}.theta(1) = atand(V.perm{1}.R(1,3)./V.perm{1}.R(3,1)) %???

    % Set the 'native' direction cosines
	switch fov_orient
		case 'sag'
            V.slice_orient = 'sag';
            V.N = [0,0,1,0;-1,0,0,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];            
        case 'sc'
            V.slice_orient = 'sc';
            V.F = [0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
            V.N = V.F * V.M;
            % R1 and R2 are the inverse of what they are for st
            V.R1 = [-cosd(theta(1)),0,sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(2)),sind(theta(2)),0;0,-sind(theta(2)),cosd(theta(2)),0;0,0,0,1];
            % In plane rotation
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
        case 'st'
            % Precision isn't the best here (?)
            V.slice_orient = 'st';
            V.F = [0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
            V.N = V.F * V.M;
            % R1 and R2 are the inverse of what they are for sc
            V.R2 = [1,0,0,0;0,cosd(theta(1)),sind(theta(1)),0;0,-sind(theta(1)),cosd(theta(1)),0;0,0,0,1];
            V.R1 = [-cosd(theta(2)),0,sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];
            % In plane rotation
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1];
		case 'cor'
            V.slice_orient = 'cor';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';
		case 'ct'
             % Precision isn't the best here (?)
            V.slice_orient = 'ct';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for cs
            V.R2 = [1,0,0,0;0,cosd(theta(1)),sind(theta(1)),0;0,-sind(theta(1)),cosd(theta(1)),0;0,0,0,1];
            V.R1 = [cosd(theta(2)),0,-sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';            
		case 'cs'
            V.slice_orient = 'cs';
            V.N = [1,0,0,0;0,0,-1,0;0,1,0,0;0,0,0,1];
            V.F = V.N * inv(V.M);            
            % R1 and R2 are the inverse of what they are for ct
            V.R1 = [cosd(theta(1)),0,-sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(2)),sind(theta(2)),0;0,-sind(theta(2)),cosd(theta(2)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';            
        case 'tra'            
            V.slice_orient = 'tra';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            V.R1 = eye(4);
            V.R2 = eye(4);
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';
        case 'ts'
            % Precision isn't the best here (?)
            V.slice_orient = 'ts';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for tc
            V.R1 = [cosd(theta(1)),0,-sind(theta(1)),0;0,1,0,0;sind(theta(1)),0,cosd(theta(1)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(2)),-sind(theta(2)),0;0,sind(theta(2)),cosd(theta(2)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';
        case 'tc'
            % Precision is downright awful here (?)
            V.slice_orient = 'tc';
            V.N = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];
            V.F = V.N * inv(V.M);
            % R1 and R2 are the inverse of what they are for ts
            V.R1 = [cosd(theta(2)),0,-sind(theta(2)),0;0,1,0,0;sind(theta(2)),0,cosd(theta(2)),0;0,0,0,1];
            V.R2 = [1,0,0,0;0,cosd(theta(1)),-sind(theta(1)),0;0,sind(theta(1)),cosd(theta(1)),0;0,0,0,1];
            % In plane rotation (transpose of sag rotation)
            V.R3 = [cosd(theta(3)),-sind(theta(3)),0,0;sind(theta(3)),cosd(theta(3)),0,0;0,0,1,0;0,0,0,1]';            
        otherwise
			warning('Unrecognized FOV. Hope you like eye(4)');
			V.N = eye(4);            
    end
    

    
     
end

