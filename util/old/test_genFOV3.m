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

% Testing SC, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
ori = 'sc';
patient = 'hfs';
ack2D = false;

% t3_8:   ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
Vt3_8 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_8.V - t3_8

% t3_10:  ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
Vt3_10 = genFOV3(numvox, voxdim, ori, [10,5,0], offset, patient);
Vt3_10.V - t3_10

% t3_12:  ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
Vt3_12 = genFOV3(numvox, voxdim, ori, [10,5,20], offset, patient);
Vt3_12.V - t3_12

% Testing ST, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
ori = 'st';
patient = 'hfs';

% t3_14:  ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
Vt3_14 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_14.V - t3_14

% t3_16:  ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
Vt3_16 = genFOV3(numvox, voxdim, ori, [10,5,0], offset, patient);
Vt3_16.V - t3_16
% !! precision lacking here ??

% t3_18:  ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
Vt3_18 = genFOV3(numvox, voxdim, ori, [10,5,20], offset, patient);
Vt3_18.V - t3_18
% !! precision lacking here ??


% Testing CT, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ori = 'ct';

% t3_26  ./026/t1_fl3d_iso_CT-10_RL-0.nii.gz
Vt3_26 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_26.V - t3_26

% t3_28  ./028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz
Vt3_28 = genFOV3(numvox, voxdim, ori, [10,5,0], offset, patient);
Vt3_28.V - t3_28

% t3_30  ./030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz
Vt3_30 = genFOV3(numvox, voxdim, ori, [10,5,20], offset, patient);
Vt3_30.V - t3_30


% Testing CS, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ori = 'cs';

% t3_32  ./032/t1_fl3d_iso_CS-10_RL-0.nii.gz
Vt3_32 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_32.V - t3_32

% t3_34  ./034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz
Vt3_34 = genFOV3(numvox, voxdim, ori, [10,5,0], offset, patient);
Vt3_34.V - t3_34

% t3_36  ./036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz
Vt3_36 = genFOV3(numvox, voxdim, ori, [10,5,20], offset, patient);
Vt3_36.V - t3_36

% Testing TC, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ori = 'tc';

% t3_54:  ./054/t1_fl3d_iso_TC-10_AP-0.nii.gz
Vt3_54 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_54.V - t3_54

% t3_58:  ./058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz
Vt3_58 = genFOV3(numvox, voxdim, ori, [10,5,20], offset, patient);
Vt3_58.V - t3_58
% !! precision lacking here ??

% Testing TS, no offsets
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ori = 'ts';

% t3_46:  ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
Vt3_46 = genFOV3(numvox, voxdim, ori, [10,0,0], offset, patient);
Vt3_46.V - t3_46

% t3_50:  ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
Vt3_50 = genFOV3(numvox, voxdim, ori, [10,5,10], offset, patient);
Vt3_50.V - t3_50
% !! precision lacking here ??

% Testing offsets
% ---------------------------------------------------------------------
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
patient = 'hfs';

% t18:  ./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
Vt18 = genFOV3(numvox, voxdim, 'cs', [20,10,5], [-10,-20,-30,1]', patient);
Vt18.V - t18

% t21:  ./021/ep2d_bold__R10P20H30__S-T_20_C_10__A-P_5.nii.gz
Vt21 = genFOV3(numvox, voxdim, 'st', [20,10,5], [-10,-20,-30,1]', patient);
Vt21.V - t21

% t22: ./022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz
Vt22 = genFOV3(numvox, voxdim, 'st', [20,10,5], [10,-20,30,1]', patient);
Vt22.V - t22

% Now test 'working backwards'
%---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% 'sc'
%---------------------------------------------------------------------
ori = 'sc';

% t3_8:   ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
Vt3_8 = genFOV3(numvox, voxdim, 'sc', [10,0,0], offset, patient);
Vt3_8b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_8.Pr);

% t3_10:  ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
Vt3_10 =  genFOV3(numvox, voxdim, 'sc', [10,5,0], offset, patient);
Vt3_10b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_10.Pr);

% t3_12:  ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
Vt3_12 = genFOV3(numvox, voxdim, 'sc', [10,5,20], offset, patient);
Vt3_12b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_12.Pr);

% 'st'
%---------------------------------------------------------------------
ori = 'st';

% t3_14:  ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
Vt3_14 = genFOV3(numvox, voxdim, 'st', [10,0,0], offset, patient);
Vt3_14b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_14.Pr);

% t3_16:  ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
Vt3_16 = genFOV3(numvox, voxdim, 'st', [10,5,0], offset, patient);
Vt3_16b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_16.Pr);
% !! precision lacking here ??

% t3_18:  ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
Vt3_18 = genFOV3(numvox, voxdim, 'st', [10,5,20], offset, patient);
Vt3_18b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_18.Pr);
% !! precision lacking here ??

% 'cs'
% ---------------------------------------------------------------------
ori = 'cs';

% t3_32  ./032/t1_fl3d_iso_CS-10_RL-0.nii.gz
Vt3_32 = genFOV3(numvox, voxdim, 'cs', [10,0,0], offset, patient);
Vt3_32b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_32.Pr);

% t3_34  ./034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz
Vt3_34 = genFOV3(numvox, voxdim, 'cs', [10,5,0], offset, patient);
Vt3_34b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_34.Pr);

% t3_36  ./036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz
Vt3_36 = genFOV3(numvox, voxdim, 'cs', [10,5,20], offset, patient);
Vt3_36b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_36.Pr);

% 'ct'
% ---------------------------------------------------------------------
ori = 'ct';

% t3_26  ./026/t1_fl3d_iso_CT-10_RL-0.nii.gz
Vt3_26 = genFOV3(numvox, voxdim, 'ct', [10,0,0], offset, patient);
Vt3_26b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_26.Pr);

% t3_28  ./028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz
Vt3_28 = genFOV3(numvox, voxdim, 'ct', [10,5,0], offset, patient);
Vt3_28b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_28.Pr);

% t3_30  ./030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz
Vt3_30 = genFOV3(numvox, voxdim, 'ct', [10,5,20], offset, patient);
Vt3_30b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_30.Pr);

% 'ts'
% ---------------------------------------------------------------------
ori = 'ts';

% t3_46:  ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
Vt3_46 = genFOV3(numvox, voxdim, 'ts', [10,0,0], offset, patient);
Vt3_46b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_46.Pr);

% t3_50:  ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
Vt3_50 = genFOV3(numvox, voxdim, 'ts', [10,5,10], offset, patient);
Vt3_50b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_50.Pr);
% !! precision lacking here ??

% 'tc'
% ---------------------------------------------------------------------
ori = 'tc';

% t3_54:  ./054/t1_fl3d_iso_TC-10_AP-0.nii.gz
Vt3_54 = genFOV3(numvox, voxdim, 'tc', [10,0,0], offset, patient);
Vt3_54b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_54.Pr);

% t3_58:  ./058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz
Vt3_58 = genFOV3(numvox, voxdim, 'tc', [10,5,20], offset, patient);
Vt3_58b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_58.Pr);

% Now test 'working backwards' with offsets..
%---------------------------------------------------------------------
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
patient = 'hfs';

% t18:  ./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
Vt18 = genFOV3(numvox, voxdim, 'cs', [20,10,5], [-10,-20,-30,1]', patient);
Vt18b = genFOV3_G2Pr(numvox, voxdim, patient, Vt18.Pr);

% t21:  ./021/ep2d_bold__R10P20H30__S-T_20_C_10__A-P_5.nii.gz
Vt21 = genFOV3(numvox, voxdim, 'st', [20,10,5], [-10,-20,-30,1]', patient);
Vt21b = genFOV3_G2Pr(numvox, voxdim, patient, Vt21.Pr);

% t22: ./022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz
Vt22 =  genFOV3(numvox, voxdim, 'st', [20,10,5], [10,-20,30,1]', patient);
Vt22b = genFOV3_G2Pr(numvox, voxdim, patient, Vt22.Pr);


% Now test the whole she-bang
%---------------------------------------------------------------------

numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% mov:  t3_50:  ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
% dest: t3_46:  ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
Vt3_46 = genFOV3(numvox, voxdim, 'ts', [10,0,0], offset, patient);
Vt3_46b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_46.Pr);
Vt3_50 = genFOV3(numvox, voxdim, 'ts', [10,5,10], offset, patient);
Vt3_50b = genFOV3_G2Pr(numvox, voxdim, patient, Vt3_50.Pr);

Vm = Vt3_46;
Vd = Vt3_50;

% compute ras2ras to go from mov to dst
% Pm = Gm2Pm * Gm
% Pd = Gd2Pd * Gd
% Registering gives:
%   Pm2Pd
% We want our fov to be:
%   Gm2Pd
%
%   Pd = inv(Pm2Pd) * Gd2Pd * Gd
%   Gm2Pd = inv(Pm2Pd) * Gd2Pd

% 1) Find Pm2Pd

Rd = Vd.R1*Vd.R2*Vd.R3;
Rm = Vm.R1*Vm.R2*Vm.R3;

% Rd = R2R * Rm
R2R = Rd*inv(Rm);

% convert R2R to world coords
% V.W =  V.F * V.R1 * V.R2 * V.R3 * V.M;
Gm2W = Vd.F * R2R * Rm;

% Find new offset to iso-center (in grad coords)
%offset = inv(Gm2W) * [0,0,0,1]';

% convert R2R to patient coords (RAS)
% V.Pr = V.L2R * V.PO * V.F * V.R1 * V.R2 * V.R3 * V.M;
Gm2Pd = Vd.L2R * Vd.PO *Gm2W;

Vr = genFOV3_G2Pr(Vd.numvox, Vd.voxdim, Vd.patient, Gm2Pd);
printFOV(Vr);

% Now test the whole she-bang with offsets
%---------------------------------------------------------------------
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
patient = 'hfs';

% t22: ./022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz
Vt22 =  genFOV3(numvox, voxdim, 'st', [20,10,5], [10,-20,30,1]', patient);
Vt22b = genFOV3_G2Pr(numvox, voxdim, patient, Vt22.Pr);

% t18:  ./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
Vt18 = genFOV3(numvox, voxdim, 'cs', [20,10,5], [-10,-20,-30,1]', patient);
Vt18b = genFOV3_G2Pr(numvox, voxdim, patient, Vt18.Pr);


Vm = Vt22;
off_m = [10,-20,30,1]';
Vd = Vt18;
off_d = [-10,-20,-30,1]';

Rd = Vd.R1*Vd.R2*Vd.R3;
Rm = Vm.R1*Vm.R2*Vm.R3;

% Rd = R2R * Rm
R2R_w = Vd.F * Rd * inv(Rm);
%offset = inv(R2R_w) * [0,0,0,1]';

% Gradient movable --> world destination
Gm2Wd = R2R_w * Vm.W;
V
%offset = inv(Gm2Wd) * [0,0,0,1]';
%Gm2Wd(:,4) = offset;

Gm2Pd = Vd.L2R * Vd.PO * Gm2Wd;
%offset = inv(Gm2Pd) * [0,0,0,1]';
%Gm2Pd(:,4) = offset;

Vr = genFOV3_G2Pr(Vd.numvox, Vd.voxdim, Vd.patient, Gm2Pd);
printFOV(Vr);

Vm.offset
