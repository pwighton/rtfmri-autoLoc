#! /usr/bin/octave -qf

function usage() 
	printf('Here is how to use myAmazingFunction!!\n');
end

% -------------------------------------
% Main
% -------------------------------------

% Prepend the contents of this directory to the path
%addpath(pwd,'-begin')
addpath('/home/rtfmri/AutoReg/util','-begin')
minargs = 1;

% Get the command line arguments
args = argv();
numargs = size(args,1);

if numargs<minargs
	usage();
	exit();
end

% There's some odd behaviour here that if you call the
% script with no command line arguments, then:
%   args{1}='-qf'
if minargs > 0
	if (strcmp(args{1},"-qf"))
		usage();
		exit();
	end

end

infile = args{1};

updateFOV(infile);



