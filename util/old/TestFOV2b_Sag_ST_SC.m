% 'ground truth' vox2ras data (rot_test_20130319)
% ---------------------------------
%  Parameters constant across all these acks:
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';      
patient = 'hfs';
ack2D = true;
S = [3.0,0,0,0;0,3.0,0,0;0,0,3.75,0;0,0,0,1];


sagGT;
% sag:       ./002/ep2d_bold__iso__sag__A-P_0.nii.gz
%---------------------------------------------------------------------
offset = [0,0,0,1]';
theta = [0,0,0];
ori = 'sag';
Vsag = genFOV2_old(numvox, voxdim, ori, theta, [0,0,0], patient);
sag - Vsag.V	
% sag_ap10:  ./003/ep2d_bold__iso__sag__A-P_10.nii.gz
%---------------------------------------------------------------------
offset = [0,0,0];
theta = [0,0,10];
ori = 'sag';
Vsag_ap10 = genFOV2_old(numvox, voxdim, ori, theta, offset, patient);
sag_ap10 - Vsag_ap10.V	
% t3_8:      ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
%---------------------------------------------------------------------
offset = [0,0,0,1]';
theta = [10,0,0];
ori = 'sc';
Vt3_8 = genFOV2_old(numvox, voxdim, ori, theta, [0,0,0], patient);
t3_8 - Vt3_8.V	

% t3_14:     ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
%---------------------------------------------------------------------
offset = [0,0,0,1]';
theta = [10,0,0];
ori = 'st';
Vt3_14 = genFOV2(numvox, voxdim, ori, theta, offset, patient);
t3_14 - Vt3_14.V	

% t3_10:     ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
%---------------------------------------------------------------------
% t3_16:     ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
% t3_12:     ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
%---------------------------------------------------------------------
% t3_18:     ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
%---------------------------------------------------------------------

