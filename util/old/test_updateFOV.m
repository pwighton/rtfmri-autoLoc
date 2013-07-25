% 'ground truth' vox2ras data (rot_test_20130319)
% ---------------------------------
%  Parameters constant across all these acks:
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
theta = [0,0,0];
offset = [0,0,0,1]';   

patient = 'hfs';
ack2D = true;
S = [3.0,0,0,0;0,3.0,0,0;0,0,3.75,0;0,0,0,1];

% Testing sag/cor/tra, no rotations, no offsets
% ---------------------------------------------------------------------
% sag_v2r:  ./002/ep2d_bold__iso__sag__A-P_0.nii.gz
Vsag = genFOV3(numvox, voxdim, 'sag', theta, offset, patient);
Vsag.V - sag_v2r

% cor_v2r:  ./010/ep2d_bold__iso__cor__R-L_0.nii.gz
Vcor = genFOV3(numvox, voxdim, 'cor', theta, offset, patient);
Vcor.V - cor_v2r

% tra_v2r: ./023/ep2d_bold__iso__tra__R-L_0.nii.gz
Vtra = genFOV3(numvox, voxdim, 'tra', theta, offset, patient);
Vtra.V - tra_v2r
% ---------------------------------------------------------------------

% Testing sag/cor/tra, in plane rotations
% ---------------------------------------------------------------------
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
patient = 'hfs';

% t3: ./003/ep2d_bold__iso__sag__A-P_10.nii.gz
Vt3 = genFOV3(numvox, voxdim, 'sag', [0,0,10], offset, patient);
Vt3.V - t3

% t12: ./012/ep2d_bold__iso__cor__R-L_20.nii.gz
Vt12 = genFOV3(numvox, voxdim, 'cor', [0,0,20], offset, patient);
Vt12.V - t12

% t24: ./024/ep2d_bold__iso__tra__A-P_10.nii.gz
Vt24 = genFOV3(numvox, voxdim, 'tra', [0,0,10], offset, patient);
Vt24.V - t24


% ---------------------------------------------------------------------

Vd = Vsag;
Vm = Vt3;

% simulate registering Vm to Vd
%   Pd = Vd.Pr * G
%   Pm = Vm.Pr * G
%   Pd = R2R * Pm
%   R2R = Pd * inv(Pm)

% Random point in gradient space
G = [rand(3,1);1];

Pd = Vd.Pr * G;
Pm = Vd.Pr * G;

R2R = Pd * pinv(Pm);

Vr = genFOV3_G2Pr(Vd.numvox, Vd.voxdim, Vd.patient, inv(R2R) * Vd.Pr);


