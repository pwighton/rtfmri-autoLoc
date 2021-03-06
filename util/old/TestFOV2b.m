% 'ground truth' vox2ras data (rot_test_20130319)
% ---------------------------------
%  Parameters constant across all these acks:
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';      
patient = 'hfs';
ack2D = true;
S = [3.0,0,0,0;0,3.0,0,0;0,0,3.75,0;0,0,0,1];


offset = [0,0,0,1]';
theta = [0,0,0];


%  sag:  ./002/ep2d_bold__iso__sag__A-P_0.nii.gz
% --------------------------------------
sag = [-0.00000   -0.00000   -3.75000    5.62500;-3.00000   -0.00000   -0.00000   96.00000;0.00000   -3.00000    0.00000   96.00000;0.00000    0.00000    0.00000    1.00000];
Vsag = genFOV2(numvox, voxdim, 'sag', [0,0,0], offset, 'hfs', true);

% sag_ap10:  ./003/ep2d_bold__iso__sag__A-P_10.nii.gz
%---------------------------------------------------------------------
sag_ap10 = [-0.00000   -0.00000   -3.75000    5.62500;-2.95442    0.52094   -0.00000   77.87132;-0.52094   -2.95442    0.00000  111.21178;0.00000    0.00000    0.00000    1.00000];

% t3_8: ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_8 = [  -0.69459   -0.00000   -3.93923   51.77119; -3.93923   -0.00000    0.69459  120.84595; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% t3_14: ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_14 = [  -0.00000    0.69459   -3.93923    7.31727; -4.00000   -0.00000   -0.00000  128.00000; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
% t3_10: ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_10 = [  -0.69459    0.34333   -3.92424   40.67232; -3.93923   -0.06054    0.69195  122.80298; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
% t3_16:  ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_16 = [-0.35396    0.68924   -3.92424   18.70299; -3.98431   -0.06123    0.34862  126.84258; 0.00000   -3.93970   -0.69195  131.25987; 0.00000    0.00000    0.00000    1.00000];
