#! /usr/bin/octave -qf

function rtFouseLoc_genFBParams(infile, ffa_mask, ppa_mask)
	% Generates Feedback bar parameters (max/min/0) from the rtFouseLoc
	% run

	% Localtion of MRIread
	addpath('/home/rtfmri/freesurfer/matlab')

	faceTRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	faceTRidx = find(faceTRs==1);

	sceneTRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	sceneTRidx = find(sceneTRs==1);

	face50TRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
	face50TRidx = find(face50TRs==1);

	scene50TRs = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	scene50TRidx = find(scene50TRs==1);

	vol = MRIread(infile);

	ffa_mask = MRIread('/home/rtfmri/AutoReg/subjects/rtFouse00_test/autoreg_data/ffa_rtFouseLoc01.nii.gz');

	ppa_mask = MRIread('/home/rtfmri/AutoReg/subjects/rtFouse00_test/autoreg_data/ppa_rtFouseLoc01.nii.gz');

	[Nx Ny Nz Nt] = size(vol.vol);
	[ffaNx, ffaNy, ffaNz] = size(ffa_mask.vol);
	[ppaNx, ppaNy, ppaNz] = size(ppa_mask.vol);

	if (ffaNx~=Nx)|(ffaNy~=Ny)|(ffaNz~=Nz)
		printf('Dimension mismatch between timeseries and FFA mask\n');
		exit();
	end


	if (ppaNx~=Nx)|(ppaNy~=Ny)|(ppaNz~=Nz)
		printf('Dimension mismatch between timeseries and FFA mask\n');
		exit();
	end

	ppa_idx = find(ppa_mask.vol(:)==1);
	ffa_idx = find(ffa_mask.vol(:)==1);

	Nv = Nx.*Ny.*Nz;

	% The measured bold signal of the GLM
	Y = reshape(vol.vol, Nv, Nt)';

	% Just do a 0th and 1st order subtraction
	X = horzcat(ones(Nt,1),(1:Nt)');

	Beta = pinv(X)*Y;
	epsilon = Y - X*Beta;
	real_std = std(epsilon);

	% Calculate the murfi 'baseline variance' (first 15trS)
	murfi_std = std(Y(1:15,:));

	murfi_signal = (epsilon./repmat(murfi_std,Nt,1))./repmat(real_std,Nt,1);

	%v1 = mean(mean(murfi_signal(faceTRidx,ffa_idx))-murfi_signal(faceTRidx,ppa_idx))

	v1 = mean(mean(murfi_signal(faceTRidx,ffa_idx),2) - mean(murfi_signal(faceTRidx,ppa_idx),2));
	v2 = mean(mean(murfi_signal(sceneTRidx,ffa_idx),2) - mean(murfi_signal(sceneTRidx,ppa_idx),2));
	v3 = mean(mean(murfi_signal(face50TRidx,ffa_idx),2) - mean(murfi_signal(face50TRidx,ppa_idx),2));
	v4 = mean(mean(murfi_signal(scene50TRidx,ffa_idx),2) - mean(murfi_signal(scene50TRidx,ppa_idx),2));

	printf('v1: %f\nv2: %f\nv3: %f\nv4: %f\n',v1,v2,v3,v4)
end

function usage() 
	printf('Here is how to use myAmazingFunction!!\n');
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

