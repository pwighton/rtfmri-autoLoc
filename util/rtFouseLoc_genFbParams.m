#! /usr/bin/octave -qf

function rtFouseLoc_genFBParams(infile, ffa_mask, ppa_mask)
	% Generates Feedback bar parameters (max/min/0) from the rtFouseLoc
	% run

	% Localtion of MRIread
	addpath('/home/rtfmri/freesurfer/matlab');
	% Location of wmean.m
	addpath('/home/rtfmri/AutoReg/util');

        faceTRs =  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	faceTRidx = find(faceTRs==1);

        sceneTRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	sceneTRidx = find(sceneTRs==1);

	face50TRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	face50TRidx = find(face50TRs==1);

	scene50TRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
	scene50TRidx = find(scene50TRs==1);

	vol = MRIread(infile);

	ffa_vol = MRIread(ffa_mask);

	ppa_vol = MRIread(ppa_mask);

	[Nx Ny Nz Nt] = size(vol.vol);
	[ffaNx, ffaNy, ffaNz] = size(ffa_vol.vol);
	[ppaNx, ppaNy, ppaNz] = size(ppa_vol.vol);

	if (ffaNx~=Nx)|(ffaNy~=Ny)|(ffaNz~=Nz)
		printf('Dimension mismatch between timeseries and FFA mask\n');
		exit();
	end


	if (ppaNx~=Nx)|(ppaNy~=Ny)|(ppaNz~=Nz)
		printf('Dimension mismatch between timeseries and FFA mask\n');
		exit();
	end

	ppa_idx = find(ppa_vol.vol(:)==1);
	ffa_idx = find(ffa_vol.vol(:)==1);

	Nv = Nx.*Ny.*Nz;

	% The measured bold signal of the GLM
	Y = reshape(vol.vol, Nv, Nt)';

	% Just do a 0th and 1st order subtraction
	% X = horzcat(ones(Nt,1),(1:Nt)');

	% Do a full model
	X = horzcat(faceTRs',sceneTRs',face50TRs',scene50TRs',ones(Nt,1),(1:Nt)');
	Beta = pinv(X)*Y;
	
	% The 'murfi signal' is the BOLD signal, minus known nuiscance regressors.
        % Since experimental vectors are orthogonal, this is equivalent to subtracting the zero and
        % first order linear regressors	
	
	nuisBeta = Beta; nuisBeta(1:4,:)=0;
	epsilon = Y - X*nuisBeta;

	% But the real_std is the residual after the whole fit
	real_std = std(Y - X*Beta);

	% Calculate the murfi 'baseline variance' (first 15trS)
	murfi_std = std(Y(1:15,:));

        % Murfi z-score
	z = (epsilon./repmat(murfi_std,Nt,1));

        % Weighted z-scores from ffa
        ffa_wz = sum(z(:,ffa_idx).*repmat(real_std(ffa_idx),Nt,1),2) ./ sum( repmat(real_std(ffa_idx),Nt,1),2 );
        
        % Weighted z-scores from ppa  
        ppa_wz = sum(z(:,ppa_idx).*repmat(real_std(ppa_idx),Nt,1),2) ./ sum( repmat(real_std(ppa_idx),Nt,1),2 );
     
        v1 = mean( ffa_wz(faceTRidx)  - ppa_wz(faceTRidx));
        v2 = mean( ffa_wz(sceneTRidx) - ppa_wz(sceneTRidx));
        v3 = mean( ffa_wz(face50TRidx)  - ppa_wz(face50TRidx));
        v4 = mean( ffa_wz(scene50TRidx) - ppa_wz(scene50TRidx));

	printf('v1: %f\nv2: %f\nv3: %f\nv4: %f\n',v1,v2,v3,v4)
end

function usage() 
	printf('Here is how to use myAmazingFunction!!\n');
end

function mn = wmean(A, w, dim)
	% WMEAN Weighted mean of array

	if nargin < 3, dim = 1; end

	n = size(A, dim);
	d = ndims(A);

	% Construct expression
	str = 'A(';
	for i = 1:dim-1, str = [str ':,']; end
	str = [str 'i,'];
	if dim < d
	  for i = dim+1:d, str = [str ':,']; end
	end
	str = [str(1:end-1) ')'];

	% Calculate mean
	mn = 0;
	for i = 1:n
	  mn = mn + eval(str) * w(i);
	end
	mn = mn ./ sum(w);
end

minargs = 1;

% Get the command line arguments
args = argv();
numargs = size(args,1);

if numargs<minargs
	usage();
	exit();
end

#infile = '/home/rtfmri/AutoReg/subjects/rtFouse00_test/feat_data/fouseFunLoc01_184TR.feat/filtered_func_data.nii.gz';
#ffa_mask = '/home/rtfmri/AutoReg/subjects/rtFouse00_test/autoreg_data/ffa_rtFouseLoc01.nii.gz';
#ppa_mask = '/home/rtfmri/AutoReg/subjects/rtFouse00_test/autoreg_data/ppa_rtFouseLoc01.nii.gz';

infile = args{1};
ffa_mask = args{2};
ppa_mask = args{3};

rtFouseLoc_genFBParams(infile, ffa_mask, ppa_mask)

