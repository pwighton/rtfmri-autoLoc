% 'ground truth' vox2ras data (rot_test_20130319)
% ---------------------------------
%  Parameters constant across all these acks:
numvox = [64,64,4,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
offset = [0,0,0,1]';   
patient = 'hfs';
ack2D = true;
S = [3.0,0,0,0;0,3.0,0,0;0,0,3.75,0;0,0,0,1];

% Determining the native orientations for sag,cor and trans
% ---------------------------------------------------------------------
% ---------------------------------------------------------------------

%./002/ep2d_bold__iso__sag__A-P_0.nii.gz
% --------------------------------------
sag_v2r = [-0.00000   -0.00000   -3.75000    5.62500;-3.00000   -0.00000   -0.00000   96.00000;0.00000   -3.00000    0.00000   96.00000;0.00000    0.00000    0.00000    1.00000];
%./010/ep2d_bold__iso__cor__R-L_0.nii.gz
% --------------------------------------
cor_v2r = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -0.00000   -3.75000    5.62500; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
% ./023/ep2d_bold__iso__tra__R-L_0.nii.gz
% --------------------------------------
tra_v2r = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -3.00000   -0.00000   96.00000; 0.00000    0.00000    3.75000   -5.62500; 0.00000    0.00000    0.00000    1.00000];

% Convert vox2ras matrices to grad2ras
% --------------------------------------
sag_g2r = sag_v2r * inv(S);
sag_g2r(1:4,4) = offset;

cor_g2r = cor_v2r * inv(S);
cor_g2r(1:4,4) = offset;

tra_g2r = tra_v2r * inv(S);
tra_g2r(1:4,4) = offset;

% Convert vox2ras matrices to grad2lps (siemens patient coord system)
% --------------------------------------
lps2ras = [-1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,1];

sag_g2l = inv(lps2ras) * sag_v2r * inv(S);
sag_g2l(1:4,4) = offset;

cor_g2l = inv(lps2ras) * cor_v2r * inv(S);
cor_g2l(1:4,4) = offset;

tra_g2l = inv(lps2ras) * tra_v2r * inv(S);
tra_g2l(1:4,4) = offset;

% Convert vox2ras matrices to grad2world (must undo patient orientation
% which is almost always head-first supine)
% ---------------------------------------------------------------------
hfs = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1];

sag_g2w = inv(hfs) * inv(lps2ras) * sag_v2r * inv(S);
sag_g2w(1:4,4) = offset;

cor_g2w = inv(hfs) * inv(lps2ras) * cor_v2r * inv(S);
cor_g2w(1:4,4) = offset;

tra_g2w = inv(hfs) * inv(lps2ras) * tra_v2r * inv(S);
tra_g2w(1:4,4) = offset;

Vsag = genFOV2(numvox, voxdim, 'sag', [0,0,0], offset, 'hfs', true);
Vcor = genFOV2(numvox, voxdim, 'cor', [0,0,0], offset, 'hfs', true);
Vtra = genFOV2(numvox, voxdim, 'tra', [0,0,0], offset, 'hfs', true);

% Convert vox2ras matrices to grad2master
% --------------------------------------
sag_g2m = inv(Vsag.F) * inv(hfs) * inv(lps2ras) * sag_v2r * inv(S);
sag_g2m(1:4,4) = offset;

cor_g2w = inv(Vcor.F) * inv(hfs) * inv(lps2ras) * cor_v2r * inv(S);
cor_g2w(1:4,4) = offset;

tra_g2w = inv(Vtra.F) * inv(hfs) * inv(lps2ras) * tra_v2r * inv(S);
tra_g2w(1:4,4) = offset;


% Determining In plane rotations
% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
%./003/ep2d_bold__iso__sag__A-P_10.nii.gz
sag_v2r_ap10 = [-0.00000   -0.00000   -3.75000    5.62500;-2.95442    0.52094   -0.00000   77.87132;-0.52094   -2.95442    0.00000  111.21178;0.00000    0.00000    0.00000    1.00000];
%./011/ep2d_bold__iso__cor__R-L_10.nii.gz
cor_v2r_rl10 = [-2.95442   -0.52094   -0.00000  111.21178; -0.00000   -0.00000   -3.75000    5.62500; 0.52094   -2.95442    0.00000   77.87132; 0.00000    0.00000    0.00000    1.00000];
% ./024/ep2d_bold__iso__tra__A-P_10.nii.gz
tra_v2r_ap10 = [-2.95442   -0.52094   -0.00000  111.21177;0.52094   -2.95442   -0.00000   77.87133;0.00000    0.00000    3.75000   -5.62500;0.00000    0.00000    0.00000    1.00000];

% Convert vox2ras matrices to grad2master
% --------------------------------------
sag_g2m_ap10 = inv(Vsag.F) * inv(hfs) * inv(lps2ras) * sag_v2r_ap10 * inv(S);
sag_g2m_ap10(1:4,4) = offset;

cor_g2w_rl10 = inv(Vcor.F) * inv(hfs) * inv(lps2ras) * cor_v2r_rl10 * inv(S);
cor_g2w_rl10(1:4,4) = offset;

tra_g2w_ap10 = inv(Vtra.F) * inv(hfs) * inv(lps2ras) * tra_v2r_ap10 * inv(S);
tra_g2w_ap10(1:4,4) = offset;


% Verify
% --------------------------------------
Vsag_ap10 = genFOV2(numvox, voxdim, 'sag', [0,0,10], [0,0,0], 'hfs', true);
Vcor_rl10 = genFOV2(numvox, voxdim, 'cor', [0,0,10], [0,0,0], 'hfs', true);
Vtra_ap10 = genFOV2(numvox, voxdim, 'tra', [0,0,10], [0,0,0], 'hfs', true);


% Determining In SC/ST Orientations
% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_8 = [  -0.69459   -0.00000   -3.93923   51.77119; -3.93923   -0.00000    0.69459  120.84595; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_14 = [  -0.00000    0.69459   -3.93923    7.31727; -4.00000   -0.00000   -0.00000  128.00000; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
% ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_10 = [  -0.69459    0.34333   -3.92424   40.67232; -3.93923   -0.06054    0.69195  122.80298; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
% ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_16 = [-0.35396    0.68924   -3.92424   18.70299; -3.98431   -0.06123    0.34862  126.84258; 0.00000   -3.93970   -0.69195  131.25987; 0.00000    0.00000    0.00000    1.00000];

v2p_sc10 = t3_8;
v2p_st10 = t3_14;
v2p_sc10t5 = t3_10;
v2p_st10c5 = t3_16;

% Convert vox2ras matrices to grad2world
% --------------------------------------
M = eye(4);
Vsag = genFOV2(numvox, voxdim, 'sag', [0,0,0], [0,0,0], 'hfs', true);

sc10_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_sc10 * inv(Vsag.S);
sc10_g2w(1:4,4) = offset;

Vsc10 = genFOV2(numvox, voxdim, 'sc', [10,0,0], [0,0,0], 'hfs', true);

st10_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_st10 * inv(Vsag.S);
st10_g2w(1:4,4) = offset;

Vst10 = genFOV2(numvox, voxdim, 'st', [10,0,0], [0,0,0], 'hfs', true);


sc10t5_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_sc10t5 * inv(Vsag.S);
sc10t5_g2w(1:4,4) = offset;

% Now see what the rotation matrix looks like after 'unapplying' the 10 deg
% rotation
inv(Vsc10.R1) * inv(Vsc10.F) * sc10t5_g2w

Vsc10t5 = genFOV2(numvox, voxdim, 'sc', [10,5,0], [0,0,0], 'hfs', true);



Vst10 = genFOV2(numvox, voxdim, 'st', [10,0,0], [0,0,0], 'hfs', true);

st10c5_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_st10c5 * inv(Vsag.S);
st10c5_g2w(1:4,4) = offset;

% Now see what the rotation matrix looks like after 'unapplying' the 10 deg
% rotation
inv(Vst10.R1) * inv(Vst10.F) * st10c5_g2w;


Vst10c5 = genFOV2(numvox, voxdim, 'st', [10,5,0], [0,0,0], 'hfs', true);


% Test S-aligned orientations with 3 rotations
%---------------------------------------------------------------------
%---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
%---------------------------------------------------------------------
t3_12 = [  -0.53528    0.56019   -3.92424   28.63478; -3.72237    1.29041    0.69195   72.63316; -1.36287   -3.74447   -0.34862  166.04961; 0.00000    0.00000    0.00000    1.00000];
% ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
%---------------------------------------------------------------------
t3_18 = [  -0.09688    0.76873   -3.92424    7.93262; -3.76497    1.30518    0.34862   76.09865; -1.34746   -3.70210   -0.69195  166.77550; 0.00000    0.00000    0.00000    1.00000];

v2p_sc10t5ap20 = t3_12;
v2p_st10c5ap20 = t3_18;

Vsc10t5ap20 = genFOV2(numvox, voxdim, 'sc', [10,5,20], [0,0,0,1]', 'hfs', true);
Vst10c5ap20 = genFOV2(numvox, voxdim, 'st', [10,5,20], [0,0,0,1]', 'hfs', true);


% Determining In CT/CS Orientations
%---------------------------------------------------------------------
%---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./026/t1_fl3d_iso_CT-10_RL-0.nii.gz
%---------------------------------------------------------------------
t3_26 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000    0.69459   -3.93923    7.31727; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
% ./032/t1_fl3d_iso_CS-10_RL-0.nii.gz
%---------------------------------------------------------------------
t3_32 = [  -3.93923   -0.00000    0.69459  120.84595; -0.69459   -0.00000   -3.93923   51.77120; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];

v2p_ct10 = t3_26;
v2p_cs10 = t3_32;

% Convert vox2ras matrices to grad2world
% --------------------------------------
M = eye(4);
Vcor = genFOV2(numvox, voxdim, 'cor', [0,0,0], [0,0,0], 'hfs', true);

ct10_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_ct10 * inv(Vcor.S);
ct10_g2w(1:4,4) = offset;
Vct10 = genFOV2(numvox, voxdim, 'ct', [10,0,0], [0,0,0], 'hfs', true);

cs10_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_cs10 * inv(Vcor.S);
cs10_g2w(1:4,4) = offset;
Vcs10 = genFOV2(numvox, voxdim, 'cs', [10,0,0], [0,0,0], 'hfs', true);

% ./028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz
%---------------------------------------------------------------------
t3_28 = [  -3.98431   -0.06123    0.34862  126.84256; -0.35396    0.68924   -3.92424   18.70298; -0.00000   -3.93970   -0.69195  131.25990; 0.00000    0.00000    0.00000    1.00000];
% ./034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz
%---------------------------------------------------------------------
t3_34 = [-3.93923   -0.06054    0.69195  122.80298; -0.69459    0.34333   -3.92424   40.67233; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];

v2p_ct10s5 = t3_28;
v2p_cs10t5 = t3_34;

ct10s5_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_ct10s5 * inv(Vcor.S);
ct10s5_g2w(1:4,4) = offset;
inv(Vct10.R1) * inv(Vct10.F) * ct10s5_g2w;

Vct10s5 = genFOV2(numvox, voxdim, 'ct', [10,5,0], [0,0,0], 'hfs', true);
Vcs10t5 = genFOV2(numvox, voxdim, 'cs', [10,5,0], [0,0,0], 'hfs', true);

cs10t5_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_cs10t5 * inv(Vcor.S);
cs10t5_g2w(1:4,4) = offset;

% Test C-aligned orientations with 3 rotations
%---------------------------------------------------------------------
%---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz
%---------------------------------------------------------------------
t3_30 = [  -3.72308   -1.42025    0.34862  161.97202; -0.56835    0.52661   -3.92424   30.76740; 1.34746   -3.70210   -0.69195   80.53835; 0.00000    0.00000    0.00000    1.00000];
% ./036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz
%---------------------------------------------------------------------
t3_36 = [  -3.68096   -1.40418    0.69195  157.53500; -0.77013    0.08506   -3.92424   51.35410; 1.36287   -3.74447   -0.34862   78.82564; 0.00000    0.00000    0.00000    1.00000];

v2p_ct10s5rl20 = t3_30;
v2p_cs10t5rl20 = t3_36;

Vct10s5rl20 = genFOV2(numvox, voxdim, 'ct', [10,5,20], [0,0,0], 'hfs', true);
Vcs10t5rl20 = genFOV2(numvox, voxdim, 'cs', [10,5,20], [0,0,0], 'hfs', true);


% Determining In TS/TC Orientations
%---------------------------------------------------------------------
%---------------------------------------------------------------------
numvox = [64,64,16,1]';
offset = [0,0,0,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
%---------------------------------------------------------------------
t3_46 = [  -3.93923   -0.00000    0.69459  120.84595; -0.00000   -4.00000   -0.00000  128.00000; 0.69459    0.00000    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];
% ./054/t1_fl3d_iso_TC-10_AP-0.nii.gz
%---------------------------------------------------------------------
t3_54 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000   -3.93923    0.69459  120.84595; 0.00000    0.69459    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];

v2p_ts10 = t3_46;
v2p_tc10 = t3_54;

% Convert vox2ras matrices to grad2world
% --------------------------------------
M = eye(4);
Vtra = genFOV2(numvox, voxdim, 'tra', [0,0,0], [0,0,0], 'hfs', true);

ts10_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_ts10 * inv(Vcor.S);
ts10_g2w(1:4,4) = offset;
inv([1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1])*ts10_g2w

Vts10 = genFOV2(numvox, voxdim, 'ts', [10,0,0], [0,0,0], 'hfs', true);

tc10_g2w = inv(Vcor.PO) * inv(Vcor.L2R) * v2p_tc10 * inv(Vcor.S);
tc10_g2w(1:4,4) = offset;
inv([1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,1])*tc10_g2w

Vtc10 = genFOV2(numvox, voxdim, 'tc', [10,0,0], [0,0,0], 'hfs', true);

% ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
%---------------------------------------------------------------------
t3_50 = [-3.87984   -0.68412    0.69195  140.85724; 0.75217   -3.91315    0.34862   98.53660; 0.61730    0.46827    3.92424  -64.16991; 0.00000    0.00000    0.00000    1.00000 ];
% ./058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz
%---------------------------------------------------------------------
t3_58 = [  -3.74447   -1.36287    0.34862  160.82027; 1.40418   -3.68096    0.69195   67.66727; 0.08506    0.77013    3.92424  -56.79773; 0.00000    0.00000    0.00000    1.00000];

v2p_ts10c5ap10 = t3_50;
v2p_tc10s5ap20 = t3_58;

Vts10c5ap10 = genFOV2(numvox, voxdim, 'ts', [10,5,10], [0,0,0], 'hfs', true);
Vtc10s5ap20 = genFOV2(numvox, voxdim, 'ts', [10,5,20], [0,0,0], 'hfs', true);

Dealing with offsets
%---------------------------------------------------------------------
numvox = [64,64,4,1]';
voxdim = [3.0,3.0,3.75,1]';
patient = 'hfs';
offset = [-10,-20,-30,1]';
theta = [20,10,5];

%./017/ep2d_bold__iso__C-S_20_T_10__R-L_5.nii.gz
t17 = [-2.79282   -0.42319    1.26309  101.01788; -1.06482    0.39824   -3.47031   26.53613; 0.25749   -2.94318   -0.65118   86.91872; 0.00000    0.00000    0.00000    1.00000];
%./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
t18 = [-2.79282   -0.42319    1.26309  111.01788; -1.06482    0.39824   -3.47031   46.53613; 0.25749   -2.94318   -0.65118  116.91872; 0.00000    0.00000    0.00000    1.00000];

Vcs20t10rl15_iso = genFOV2(numvox, voxdim, 'cs', [20,10,5], [0,0,0,1]', 'hfs', true);
Vcs20t10rl15_r10a20h30 = genFOV2(numvox, voxdim, 'cs', [20,10,5], offset, 'hfs', true);

%---------------------------------------------------------------------
%---------------------------------------------------------------------
%---------------------------------------------------------------------
%---------------------------------------------------------------------
%---------------------------------------------------------------------
% Old, yo
%---------------------------------------------------------------------

st10t5_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_st10t5 * inv(Vsag.S);
st10t5_g2w(1:4,4) = offset;

Vst10 = genFOV2(numvox, voxdim, 'st', [10,0,0], [0,0,0], 'hfs', true);




sc10t5_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_sc10t5 * inv(Vsag.S);
sc10t5_g2w(1:4,4) = offset;

st10c5_g2w = inv(Vsag.PO) * inv(Vsag.L2R) * v2p_st10c5 * inv(Vsag.S);
st10c5_g2w(1:4,4) = offset;







% ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,5,20];
v2p_ans = t3_12;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
V.v2p
v2p_ans

% ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,5,0];
v2p_ans = t3_16;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
V.v2p
v2p_ans
R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
% WRONG





cor_g2w_rl10 = inv(Vcor.F) * inv(hfs) * inv(lps2ras) * cor_v2r_rl10 * inv(S);
cor_g2w_rl10(1:4,4) = offset;

tra_g2w_ap10 = inv(Vtra.F) * inv(hfs) * inv(lps2ras) * tra_v2r_ap10 * inv(S);
tra_g2w_ap10(1:4,4) = offset;



fov_orient = 'sc';
theta = [10,0,0];

ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);

fov_orient = 'st';
theta = [10,0,0];

ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);




















%./004/ep2d_bold__iso__S-C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,0,0];
v2p_ans = t2_4;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
%abs(V.v2p - v2p_ans)<0.0001

%./005/ep2d_bold__iso__S-T_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,0,0];
v2p_ans = t2_5;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001


%./005/ep2d_bold__iso__S-C_10__A-P_0.nii.gz
t5 = [-0.52094   -0.00000   -3.69303   22.20977;-2.95442   -0.00000    0.65118   93.56478;0.00000   -3.00000    0.00000   96.00000;0.00000    0.00000    0.00000    1.00000];
%./002/ep2d_bold__iso__sag__A-P_0.nii.gz
t2 = [-0.00000   -0.00000   -3.75000    5.62500;-3.00000   -0.00000   -0.00000   96.00000;0.00000   -3.00000    0.00000   96.00000;0.00000    0.00000    0.00000    1.00000];
% ./004/ep2d_bold__iso__sag__A-P_20.nii.gz
t4 = [-0.00000    0.00000   -3.75000    5.62500;-2.81908    1.02606   -0.00000   57.37656;-1.02606   -2.81908    0.00000  123.04443;0.00000    0.00000    0.00000    1.00000];
%./006/ep2d_bold__iso__S-C_20__A-P_0.nii.gz
t6 = [-1.02606   -0.00000   -3.52385   38.11971; -2.81908   -0.00000    1.28258   88.28662; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./007/ep2d_bold__iso__S-C_10_T_5__A-P_0.nii.gz
t7 = [-0.52094    0.25749   -3.67898   13.94885; -2.95442   -0.04540    0.64870   95.02139; 0.00000   -2.98858   -0.32683   96.12494; 0.00000    0.00000    0.00000    1.00000];
%./008/ep2d_bold__iso__S-C_20_T_10__A-P_0.nii.gz
t8 = [-1.02606    0.48953   -3.47031   22.37451; -2.81908   -0.17817    1.26309   94.01741; 0.00000   -2.95442   -0.65118   95.51832; 0.00000    0.00000    0.00000    1.00000];
%./009/ep2d_bold__iso__S-C_20_T_10__A-P_15.nii.gz
t9 = [-0.86440    0.73841   -3.47031    9.23707; -2.76913    0.55753    1.26309   68.87676; -0.76466   -2.85375   -0.65118  116.76604; 0.00000    0.00000    0.00000    1.00000];
%./012/ep2d_bold__iso__cor__R-L_20.nii.gz
t12 = [-2.81908   -1.02606   -0.00000  123.04443; -0.00000   -0.00000   -3.75000    5.62500; 1.02606   -2.81908    0.00000   57.37656; 0.00000    0.00000    0.00000    1.00000];
%./013/ep2d_bold__iso__C-T_10__R-L_0.nii.gz
t13 = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000    0.52094   -3.69303  -11.13068; 0.00000   -2.95442   -0.65118   95.51832; 0.00000    0.00000    0.00000    1.00000];
%./014/ep2d_bold__iso__C-T_20_S_10__R-L_0.nii.gz
t14 = [-2.94854   -0.18636    0.65118   99.33990; -0.55327    0.99314   -3.47031   -8.87023; 0.00000   -2.82470   -1.26309   92.28513; 0.00000    0.00000    0.00000    1.00000];
%./015/ep2d_bold__iso__C-S_10__R-L_0.nii.gz
t15 = [-2.95442   -0.00000    0.65118   93.56478; -0.52094   -0.00000   -3.69303   22.20977; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./016/ep2d_bold__iso__C-S_20_T_10__R-L_0.nii.gz
t16 = [-2.81908   -0.17817    1.26309   94.01741; -1.02606    0.48953   -3.47031   22.37452; 0.00000   -2.95442   -0.65118   95.51832; 0.00000    0.00000    0.00000    1.00000];
%./017/ep2d_bold__iso__C-S_20_T_10__R-L_5.nii.gz
t17 = [-2.79282   -0.42319    1.26309  101.01788; -1.06482    0.39824   -3.47031   26.53613; 0.25749   -2.94318   -0.65118   86.91872; 0.00000    0.00000    0.00000    1.00000];
%./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
t18 = [-2.79282   -0.42319    1.26309  111.01788; -1.06482    0.39824   -3.47031   46.53613; 0.25749   -2.94318   -0.65118  116.91872; 0.00000    0.00000    0.00000    1.00000];
%./019/ep2d_bold__iso__S-T_10_C_5__A-P_0.nii.gz
t19 = [-0.26547    0.51693   -3.67898   -2.52815; -2.98823   -0.04592    0.32683   96.60268; 0.00000   -2.95477   -0.64870   95.52576; 0.00000    0.00000    0.00000    1.00000];
%./020/ep2d_bold__iso__S-T_20_C_10__A-P_5.nii.gz
t20 = [-0.46461    1.03758   -3.47031  -13.12959; -2.95356    0.07134    0.65118   91.25448; -0.24619   -2.81395   -1.26309   99.81921; 0.00000    0.00000    0.00000    1.00000];
%./021/ep2d_bold__R10P20H30__S-T_20_C_10__A-P_5.nii.gz
t21 = [-0.46461    1.03758   -3.47031   -3.12959; -2.95356    0.07134    0.65118   71.25447; -0.24619   -2.81395   -1.26309  129.81921; 0.00000    0.00000    0.00000    1.00000];
%./022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz
t22 = [-0.46461    1.03758   -3.47031  -23.12959; -2.95356    0.07134    0.65118  111.25447; -0.24619   -2.81395   -1.26309   69.81921; 0.00000    0.00000    0.00000    1.00000];
%./025/ep2d_bold__iso__tra__A-P_-10.nii.gz
t25 = [-2.95442    0.52094   -0.00000   77.87133; -0.52094   -2.95442   -0.00000  111.21177; 0.00000    0.00000    3.75000   -5.62500; 0.00000    0.00000    0.00000    1.00000];
%./026/ep2d_bold__iso__T-S_10__A-P_0.nii.gz
t26 = [-2.95442   -0.00000    0.65118   93.56478; -0.00000   -3.00000   -0.00000   96.00000; 0.52094    0.00000    3.69303  -22.20977; 0.00000    0.00000    0.00000    1.00000];
%./027/ep2d_bold__iso__T-S_20_C_10__A-P_0.nii.gz
t27 = [-2.82470    0.00000    1.26309   88.49585; 0.18636   -2.94854    0.65118   87.41312; 0.99314    0.55327    3.47031  -54.69068; 0.00000    0.00000    0.00000    1.00000];
%./028/ep2d_bold__iso__T-S_20_C_10__A-P_-5.nii.gz
t28 = [-2.81395    0.24619    1.26309   80.27383; -0.07134   -2.95356    0.65118   95.81995; 1.03758    0.46461    3.47031  -53.27559; 0.00000    0.00000    0.00000    1.00000];
%./029/ep2d_bold__iso__T-C_10__A-P_0.nii.gz
t29 = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -2.95442    0.65118   93.56478; 0.00000    0.52094    3.69303  -22.20977; 0.00000    0.00000    0.00000    1.00000];
%./030/ep2d_bold__iso__T-C_20_S_10__A-P_0.nii.gz
t30 = [-2.95442    0.00000    0.65118   93.56478; 0.17817   -2.81908    1.26309   82.61430; 0.48953    1.02606    3.47031  -53.70429; 0.00000    0.00000    0.00000    1.00000];
%./031/ep2d_bold__iso__T-C_20_S_10__A-P_-5.nii.gz
t31 = [-2.94318    0.25749    0.65118   84.96518; -0.06820   -2.82388    1.26309   90.65200; 0.57709    0.97949    3.47031  -55.01612; 0.00000    0.00000    0.00000    1.00000];
%./032/ep2d_bold__R10P20F30__T-C_20_S_10__A-P_-5.nii.gz
t32 = [-2.94318    0.25749    0.65118   94.96518; -0.06820   -2.82388    1.26309   70.65199; 0.57709    0.97949    3.47031  -85.01613; 0.00000    0.00000    0.00000    1.00000];

%./002/ep2d_bold__iso__sag__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,0];
offset = [0,0,0];
v2p_ans = t2;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./003/ep2d_bold__iso__sag__A-P_10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,10];
v2p_ans = t3;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

% ./004/ep2d_bold__iso__sag__A-P_20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,20];
v2p_ans = t4;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./005/ep2d_bold__iso__S-C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,0,0];
v2p_ans = t5;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./006/ep2d_bold__iso__S-C_20__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [20,0,0];
v2p_ans = t6;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./007/ep2d_bold__iso__S-C_10_T_5__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,5,0];
v2p_ans = t7;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./008/ep2d_bold__iso__S-C_20_T_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [20,10,0];
v2p_ans = t8;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./009/ep2d_bold__iso__S-C_20_T_10__A-P_15.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [20,10,15];
v2p_ans = t9;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./010/ep2d_bold__iso__cor__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,0];
v2p_ans = t10;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./011/ep2d_bold__iso__cor__R-L_10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,10];
v2p_ans = t11;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./012/ep2d_bold__iso__cor__R-L_20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,20];
v2p_ans = t12;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./013/ep2d_bold__iso__C-T_10__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ct';
theta = [10,0,0];
v2p_ans = t13;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./014/ep2d_bold__iso__C-T_20_S_10__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ct';
theta = [20,-10,0];
v2p_ans = t14;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001
% !!WRONG!! %%
% inv(V.fov_pre) * v2p_ans * inv(V.S_native) * inv(V.fov_post) * inv(V.po) * inv(V.native)

%./015/ep2d_bold__iso__C-S_10__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [10,0,0];
v2p_ans = t15;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./016/ep2d_bold__iso__C-S_20_T_10__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [20,10,0];
v2p_ans = t16;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001


%./017/ep2d_bold__iso__C-S_20_T_10__R-L_5.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [20,10,-5];
% --- NOTE THE NEGATIVE!
v2p_ans = t17;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001


%./018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [20,10,-5];
% --- NOTE THE NEGATIVE!
offset = [10, 20, -30];
v2p_ans = t18;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001
% OFFSET NOT WORKING

%---------------------------------------------------------------------
%./019/ep2d_bold__iso__S-T_10_C_5__A-P_0.nii.gz
fov_orient = 'st';
theta = [10,5,0];
v2p_ans = t19;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.1
% WRONG

%---------------------------------------------------------------------
%./020/ep2d_bold__iso__S-T_20_C_10__A-P_5.nii.gz
fov_orient = 'st';
theta = [20,10,5];
v2p_ans = t20;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.1
% ACCURATE to 1 sigfig

%---------------------------------------------------------------------
%./021/ep2d_bold__R10P20H30__S-T_20_C_10__A-P_5.nii.gz

%---------------------------------------------------------------------
%./022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz
%---------------------------------------------------------------------

% ./023/ep2d_bold__iso__tra__R-L_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'tra';
theta = [0,0,0];
offset = [0,0,0];
v2p_ans = t23;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001
% inv(V.fov_pre) * v2p_ans * inv(V.S_native) * inv(V.fov_post) * inv(V.po) * inv(V.native)

% ./024/ep2d_bold__iso__tra__A-P_10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'tra';
theta = [0,0,10];
offset = [0,0,0];
v2p_ans = t24;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001

%./025/ep2d_bold__iso__tra__A-P_-10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'tra';
theta = [0,0,-10];
offset = [0,0,0];
v2p_ans = t25;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./026/ep2d_bold__iso__T-S_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ts';
theta = [10,0,0];
offset = [0,0,0];
v2p_ans = t25;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001
% WORKS!!! (with odd euler angle)

%./027/ep2d_bold__iso__T-S_20_C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ts';
theta = [20,10,0];
offset = [0,0,0];
v2p_ans = t27;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001



%./028/ep2d_bold__iso__T-S_20_C_10__A-P_-5.nii.gz
%---------------------------------------------------------------------
%./029/ep2d_bold__iso__T-C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
%./030/ep2d_bold__iso__T-C_20_S_10__A-P_0.nii.gz
%---------------------------------------------------------------------
%./031/ep2d_bold__iso__T-C_20_S_10__A-P_-5.nii.gz
%---------------------------------------------------------------------
%./032/ep2d_bold__R10P20F30__T-C_20_S_10__A-P_-5.nii.gz
%---------------------------------------------------------------------



% more 'ground truth' vox2ras data (rot_test_20130321)
%---------------------------------------------------------------------

%  Parameters constant across all these acks:
numvox = [64,64,5,1]';
voxdim = [3.0, 3.0, 3.75, 1]';   
patient = 'hfs';
ack2D = true;

% ./002/ep2d_bold__iso__sag__A-P_0.nii.gz
%---------------------------------------------------------------------
t2_2 = [-0.00000   -0.00000   -3.75000    7.50000;-3.00000   -0.00000   -0.00000   96.00000; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./003/ep2d_bold__iso__sag__H-F_0.nii.gz
%---------------------------------------------------------------------
t2_3 = [-0.00000   -0.00000   -3.75000    7.50000; -3.00000   -0.00000   -0.00000   96.00000; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./004/ep2d_bold__iso__S-C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
t2_4 = [-0.52094   -0.00000   -3.69303   24.05628; -2.95442   -0.00000    0.65118   93.23919; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./005/ep2d_bold__iso__S-T_10__A-P_0.nii.gz
%---------------------------------------------------------------------
t2_5 = [-0.00000    0.52094   -3.69303   -9.28416; -3.00000   -0.00000   -0.00000   96.00000; 0.00000   -2.95442   -0.65118   95.84391; 0.00000    0.00000    0.00000    1.00000];
%./006/ep2d_bold__iso__S-C_10_T_5__A-P_0.nii.gz
%---------------------------------------------------------------------
t2_6 = [-0.52094    0.25749   -3.67898   15.78833; -2.95442   -0.04540    0.64870   94.69704; 0.00000   -2.98858   -0.32683   96.28836; 0.00000    0.00000    0.00000    1.00000];
%./007/ep2d_bold__iso__S-T_10_C_5__A-P_0.nii.gz
%---------------------------------------------------------------------
t2_7 = [-0.26547    0.51693   -3.67898   -0.68866; -2.98823   -0.04592    0.32683   96.43927; 0.00000   -2.95477   -0.64870   95.85011; 0.00000    0.00000    0.00000    1.00000];
%./008/ep2d_bold__iso__cor__R-L_0.nii.gz
%---------------------------------------------------------------------
t2_8 = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -0.00000   -3.75000    7.50000; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./009/ep2d_bold__iso__C-T_10__R-L_0.nii.gz
%---------------------------------------------------------------------
t2_9 = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000    0.52094   -3.69303   -9.28416; 0.00000   -2.95442   -0.65118   95.84391; 0.00000    0.00000    0.00000    1.00000];
%./010/ep2d_bold__iso__C-S_10__R-L_0.nii.gz
%---------------------------------------------------------------------
t2_10 = [-2.95442   -0.00000    0.65118   93.23919; -0.52094   -0.00000   -3.69303   24.05629; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
%./011/ep2d_bold__iso__C-T_10_S_5__R-L_0.nii.gz
%---------------------------------------------------------------------
t2_11 = [-2.98823   -0.04592    0.32683   96.43926; -0.26547    0.51693   -3.67898   -0.68867; -0.00000   -2.95477   -0.64870   95.85012; 0.00000    0.00000    0.00000    1.00000];
%./012/ep2d_bold__iso__C-S_10_T_5__R-L_0.nii.gz
%---------------------------------------------------------------------
t2_12 = [-2.95442   -0.04540    0.64870   94.69704; -0.52094    0.25749   -3.67898   15.78834; 0.00000   -2.98858   -0.32683   96.28836; 0.00000    0.00000    0.00000    1.00000];

% ./002/ep2d_bold__iso__sag__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,0];
v2p_ans = t2_2;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./003/ep2d_bold__iso__sag__H-F_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,0];
v2p_ans = t2_3;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001

%./004/ep2d_bold__iso__S-C_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,0,0];
v2p_ans = t2_4;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
%abs(V.v2p - v2p_ans)<0.0001

%./005/ep2d_bold__iso__S-T_10__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,0,0];
v2p_ans = t2_5;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.0001

%./006/ep2d_bold__iso__S-C_10_T_5__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,5,0];
v2p_ans = t2_6;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
% abs(V.v2p - v2p_ans)<0.0001
% v2p_ans
% native_unrotated = inv(V.r3_n2n) * inv(V.r2_n2n) * inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native)
% r1 = inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native) * inv(V.r3_n2n) * inv(V.r2_n2n)
% r2 = inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native) * inv(V.r3_n2n)
% r3 = inv(V.r2_n2n) * inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
% R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);

%./007/ep2d_bold__iso__S-T_10_C_5__A-P_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,5,0];
v2p_ans = t2_7;
ack2D = true;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.1



fov_pre = perms(1:3);
fov_post = perms(1:3);
neg_pre = 0:7;
neg_post = 0:7;
for f_pre = fov_pre'
    for f_post = fov_post'
        for neg_pre = 0:7
            for neg_post = 0:7
                [V.fov_pre V.fov_post] = bruteFOV(f_pre, f_post, neg_pre, neg_post);
                vx2ras = V.fov_pre * V.Rn2n * V.native * V.S_native * V.fov_post * V.po;
                if all(all(abs(vx2ras(1:3,1:3) - v2p_ans(1:3,1:3))<0.1))
                    V.fov_pre
                    V.fov_post
                    vx2ras
                end                
            end
        end
    end
end

% native_unrotated = inv(V.r3_n2n) * inv(V.r2_n2n) * inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native)
% r1 = inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native) * inv(V.r3_n2n) * inv(V.r2_n2n)
% r2 = inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native) * inv(V.r3_n2n)
% r3 = inv(V.r2_n2n) * inv(V.r1_n2n) * inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
% R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
       

% even more 'ground truth' vox2ras data (rot_test_20130327b)
%---------------------------------------------------------------------

%  Parameters constant across all these acks:
numvox = [64,64,16,1]';
voxdim = [4.0, 4.0, 4.0, 1]';   
patient = 'hfs';
ack2D = false;

% ./002/t1_fl3d_iso_sag_AP_0.nii.gz
%---------------------------------------------------------------------
t3_2 = [-0.00000   -0.00000   -4.00000   30.00000; -4.00000   -0.00000   -0.00000  128.00000; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% ./004/t1_fl3d_iso_sag_AP_10.nii.gz
%---------------------------------------------------------------------
t3_4 = [-0.00000   -0.00000   -4.00000   30.00000; -3.93923    0.69459   -0.00000  103.82843; -0.69459   -3.93923    0.00000  148.28236; 0.00000    0.00000    0.00000    1.00000];
% ./006/t1_fl3d_iso_sag_HF_100.nii.gz
%---------------------------------------------------------------------
t3_6 = [  -0.00000   -0.00000   -4.00000   30.00000; -3.93923    0.69459   -0.00000  103.82842; -0.69459   -3.93923    0.00000  148.28236; 0.00000    0.00000    0.00000    1.00000];
% ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_8 = [  -0.69459   -0.00000   -3.93923   51.77119; -3.93923   -0.00000    0.69459  120.84595; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_10 = [  -0.69459    0.34333   -3.92424   40.67232; -3.93923   -0.06054    0.69195  122.80298; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
% ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
%---------------------------------------------------------------------
t3_12 = [  -0.53528    0.56019   -3.92424   28.63478; -3.72237    1.29041    0.69195   72.63316; -1.36287   -3.74447   -0.34862  166.04961; 0.00000    0.00000    0.00000    1.00000];
% ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
%---------------------------------------------------------------------
t3_14 = [  -0.00000    0.69459   -3.93923    7.31727; -4.00000   -0.00000   -0.00000  128.00000; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
% ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
t3_16 = [-0.35396    0.68924   -3.92424   18.70299; -3.98431   -0.06123    0.34862  126.84258; 0.00000   -3.93970   -0.69195  131.25987; 0.00000    0.00000    0.00000    1.00000];
% ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
%---------------------------------------------------------------------
t3_18 = [  -0.09688    0.76873   -3.92424    7.93262; -3.76497    1.30518    0.34862   76.09865; -1.34746   -3.70210   -0.69195  166.77550; 0.00000    0.00000    0.00000    1.00000];
% ./020/t1_fl3d_iso_cor_RL-0.nii.gz
%---------------------------------------------------------------------
t3_20 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000   -0.00000   -4.00000   30.00000; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% ./022/t1_fl3d_iso_cor_RL-10.nii.gz
%---------------------------------------------------------------------
t3_22 = [  -3.93923   -0.69459   -0.00000  148.28236; -0.00000   -0.00000   -4.00000   30.00000; 0.69459   -3.93923    0.00000  103.82842; 0.00000    0.00000    0.00000    1.00000];
% ./024/t1_fl3d_iso_cor_FH-100.nii.gz
%---------------------------------------------------------------------
t3_24 = [  -3.93923   -0.69459   -0.00000  148.28236; -0.00000   -0.00000   -4.00000   30.00000; 0.69459   -3.93923    0.00000  103.82843; 0.00000    0.00000    0.00000    1.00000];
% ./026/t1_fl3d_iso_CT-10_RL-0.nii.gz
%---------------------------------------------------------------------
t3_26 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000    0.69459   -3.93923    7.31727; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
% ./028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz
%---------------------------------------------------------------------
t3_28 = [  -3.98431   -0.06123    0.34862  126.84256; -0.35396    0.68924   -3.92424   18.70298; -0.00000   -3.93970   -0.69195  131.25990; 0.00000    0.00000    0.00000    1.00000];
% ./030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz
%---------------------------------------------------------------------
t3_30 = [  -3.72308   -1.42025    0.34862  161.97202; -0.56835    0.52661   -3.92424   30.76740; 1.34746   -3.70210   -0.69195   80.53835; 0.00000    0.00000    0.00000    1.00000];
% ./032/t1_fl3d_iso_CS-10_RL-0.nii.gz
%---------------------------------------------------------------------
t3_32 = [  -3.93923   -0.00000    0.69459  120.84595; -0.69459   -0.00000   -3.93923   51.77120; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
% ./034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz
%---------------------------------------------------------------------
t3_34 = [-3.93923   -0.06054    0.69195  122.80298; -0.69459    0.34333   -3.92424   40.67233; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
% ./036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz
%---------------------------------------------------------------------
t3_36 = [  -3.68096   -1.40418    0.69195  157.53500; -0.77013    0.08506   -3.92424   51.35410; 1.36287   -3.74447   -0.34862   78.82564; 0.00000    0.00000    0.00000    1.00000];
% ./038/t1_fl3d_iso_CS-10-T-5_FH-100.nii.gz
%---------------------------------------------------------------------
t3_38 = [  -3.86887   -0.74366    0.69195  142.41136; -0.74366    0.21750   -3.92424   46.26900; 0.69195   -3.92424   -0.34862  106.04800; 0.00000    0.00000    0.00000    1.00000];
% ./040/t1_fl3d_iso_tra_AP-0.nii.gz
%---------------------------------------------------------------------
t3_40 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000   -4.00000   -0.00000  128.00000; 0.00000    0.00000    4.00000  -30.00000; 0.00000    0.00000    0.00000    1.00000];
% ./042/t1_fl3d_iso_tra_AP-10.nii.gz
%---------------------------------------------------------------------
t3_42 = [  -3.93923   -0.69459   -0.00000  148.28235; 0.69459   -3.93923   -0.00000  103.82843; 0.00000    0.00000    4.00000  -30.00000; 0.00000    0.00000    0.00000    1.00000];
% ./044/t1_fl3d_iso_tra_RL-100.nii.gz
%---------------------------------------------------------------------
t3_44 = [  -3.93923   -0.69459   -0.00000  148.28236; 0.69459   -3.93923   -0.00000  103.82842; 0.00000    0.00000    4.00000  -30.00000; 0.00000    0.00000    0.00000    1.00000];
% ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
%---------------------------------------------------------------------
t3_46 = [  -3.93923   -0.00000    0.69459  120.84595; -0.00000   -4.00000   -0.00000  128.00000; 0.69459    0.00000    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];
% ./048/t1_fl3d_iso_TS-10-C-5_AP-0.nii.gz
%---------------------------------------------------------------------
t3_48 = [  -3.93970    0.00000    0.69195  120.88065; 0.06123   -3.98431    0.34862  122.92382; 0.68924    0.35396    3.92424  -62.81403; 0.00000    0.00000    0.00000    1.00000];
% ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
%---------------------------------------------------------------------
t3_50 = [-3.87984   -0.68412    0.69195  140.85724; 0.75217   -3.91315    0.34862   98.53660; 0.61730    0.46827    3.92424  -64.16991; 0.00000    0.00000    0.00000    1.00000 ];
% ./052/t1_fl3d_iso_TS-10-C-5_RL-100.nii.gz
%---------------------------------------------------------------------
t3_52 = [ -3.87984   -0.68412    0.69195  140.85724; 0.75217   -3.91315    0.34862   98.53659; 0.61730    0.46827    3.92424  -64.16991; 0.00000    0.00000    0.00000    1.00000 ];
% ./054/t1_fl3d_iso_TC-10_AP-0.nii.gz
%---------------------------------------------------------------------
t3_54 = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000   -3.93923    0.69459  120.84595; 0.00000    0.69459    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];
% ./056/t1_fl3d_iso_TC-10-S-5_AP-0.nii.gz
%---------------------------------------------------------------------
t3_56 = [-3.98478   -0.00000    0.34862  124.89825; 0.06054   -3.93923    0.69195  118.92856; 0.34333    0.69459    3.92424  -62.64523; 0.00000    0.00000    0.00000    1.00000];
% ./058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz
%---------------------------------------------------------------------
t3_58 = [  -3.74447   -1.36287    0.34862  160.82027; 1.40418   -3.68096    0.69195   67.66727; 0.08506    0.77013    3.92424  -56.79773; 0.00000    0.00000    0.00000    1.00000];
% ./060/t1_fl3d_iso_TC-10-S-5_RL-100.nii.gz
%---------------------------------------------------------------------
t3_60 = [-3.92424   -0.69195    0.34862  145.10342; 0.74366   -3.86887    0.69195   94.81725; 0.21750    0.74366    3.92424  -60.18874; 0.00000    0.00000    0.00000    1.00000];


% ./002/t1_fl3d_iso_sag_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,0];
v2p_ans = t3_2;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./004/t1_fl3d_iso_sag_AP_10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,10];
v2p_ans = t3_4;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./006/t1_fl3d_iso_sag_HF_100.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sag';
theta = [0,0,100];
v2p_ans = t3_6;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
% !!! WRONG

% ./008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,0,0];
v2p_ans = t3_8;
ack2D = false;
V = genFOV2_old(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
%abs(V.v2p - v2p_ans)<0.001

% ./010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,5,0];
v2p_ans = t3_10;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'sc';
theta = [10,5,20];
v2p_ans = t3_12;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
V.v2p
v2p_ans


% ./014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,0,0];
v2p_ans = t3_14;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
%abs(V.v2p - v2p_ans)<0.001
% r1 =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);

% ./016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'st';
theta = [10,5,0];
v2p_ans = t3_16;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
V.v2p
v2p_ans
R =  inv(V.fov_pre) * v2p_ans * inv(V.po) * inv(V.fov_post) * inv(V.S_native) * inv(V.native);
% WRONG

% ./018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz
%---------------------------------------------------------------------

% ./020/t1_fl3d_iso_cor_RL-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,0];
v2p_ans = t3_20;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./022/t1_fl3d_iso_cor_RL-10.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,10];
v2p_ans = t3_22;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./024/t1_fl3d_iso_cor_FH-100.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cor';
theta = [0,0,100];
v2p_ans = t3_24;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
% !! WRONG !!


% ./026/t1_fl3d_iso_CT-10_RL-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ct';
theta = [10,0,0];
v2p_ans = t3_26;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ct';
theta = [10,5,0];
v2p_ans = t3_28;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
% !! WRONG !!

% ./030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'ct';
theta = [10,5,20];
v2p_ans = t3_30;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
% !! WRONG !!

% ./032/t1_fl3d_iso_CS-10_RL-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [10,0,0];
v2p_ans = t3_32;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [10,5,0];
v2p_ans = t3_34;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [10,5,-20];
% NOTE THE NEGATIVE ?!?!?
v2p_ans = t3_36;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001

% ./038/t1_fl3d_iso_CS-10-T-5_FH-100.nii.gz
%---------------------------------------------------------------------
fov_orient = 'cs';
theta = [10,5,100];
v2p_ans = t3_36;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001
% ------------ WRONG


% ./040/t1_fl3d_iso_tra_AP-0.nii.gz
%---------------------------------------------------------------------
fov_orient = 'tra';
theta = [0,0,0];
v2p_ans = t3_40;
ack2D = false;
V = genFOV(numvox, voxdim, fov_orient, theta, offset, patient, ack2D);
abs(V.v2p - v2p_ans)<0.001


% ./042/t1_fl3d_iso_tra_AP-10.nii.gz
% ./044/t1_fl3d_iso_tra_RL-100.nii.gz
% ./046/t1_fl3d_iso_TS-10_AP-0.nii.gz
% ./048/t1_fl3d_iso_TS-10-C-5_AP-0.nii.gz
% ./050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz
% ./052/t1_fl3d_iso_TS-10-C-5_RL-100.nii.gz
% ./054/t1_fl3d_iso_TC-10_AP-0.nii.gz
% ./056/t1_fl3d_iso_TC-10-S-5_AP-0.nii.gz
% ./058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz
% ./060/t1_fl3d_iso_TC-10-S-5_RL-100.nii.gz
