
%v1 = 1
%v2 = 5

%r2r = testset{v1}.V.Pr * inv (testset{v2}.V.Pr);

% Should give theta/offset of v2
%V = genFOV_G2Pr(testset{v2}.numvox, testset{v2}.voxdim, testset{v2}.patient, testset{v2}.V.Pr);
%V.theta - testset{v2}.theta
%V.offset - testset{v2}.offset

% Should give theta/offset of v1
%V = genFOV_G2Pr(testset{v2}.numvox, testset{v2}.voxdim, testset{v2}.patient, r2r * testset{v2}.V.Pr);
%V.theta - testset{v1}.theta
%V.offset - testset{v1}.offset

% --------------------

ii = 1;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './002/ep2d_bold__iso__sag__A-P_0.nii.gz';
testset{ii}.orient = 'sag';
testset{ii}.v2r = [-0.00000   -0.00000   -3.75000    5.62500;-3.00000   -0.00000   -0.00000   96.00000;0.00000   -3.00000    0.00000   96.00000;0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 2;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './010/ep2d_bold__iso__cor__R-L_0.nii.gz';
testset{ii}.orient = 'cor';
testset{ii}.v2r = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -0.00000   -3.75000    5.62500; 0.00000   -3.00000    0.00000   96.00000; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 3;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './023/ep2d_bold__iso__tra__R-L_0.nii.gz';
testset{ii}.orient = 'tra';
testset{ii}.v2r = [-3.00000   -0.00000   -0.00000   96.00000; -0.00000   -3.00000   -0.00000   96.00000; 0.00000    0.00000    3.75000   -5.62500; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 4;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,10];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './003/ep2d_bold__iso__sag__A-P_10.nii.gz';
testset{ii}.orient = 'sag';
testset{ii}.v2r = [-0.00000   -0.00000   -3.75000    5.62500;-2.95442    0.52094   -0.00000   77.87132;-0.52094   -2.95442    0.00000  111.21178;0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 5;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './012/ep2d_bold__iso__cor__R-L_20.nii.gz';
testset{ii}.orient = 'cor';
testset{ii}.v2r = [-2.81908   -1.02606   -0.00000  123.04443; -0.00000   -0.00000   -3.75000    5.62500; 1.02606   -2.81908    0.00000   57.37656; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 6;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [0,0,10];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './024/ep2d_bold__iso__tra__A-P_10.nii.gz';
testset{ii}.orient = 'tra';
testset{ii}.v2r = [-2.95442   -0.52094   -0.00000  111.21177;0.52094   -2.95442   -0.00000   77.87133;0.00000    0.00000    3.75000   -5.62500;0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 7;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './008/t1_fl3d_iso_SC-10-T-0_AP_0.nii.gz';
testset{ii}.orient = 'sc';
testset{ii}.v2r = [  -0.69459   -0.00000   -3.93923   51.77119; -3.93923   -0.00000    0.69459  120.84595; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 8;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './014/t1_fl3d_iso_ST-10-C-0_AP_0.nii.gz';
testset{ii}.orient = 'st';
testset{ii}.v2r = [  -0.00000    0.69459   -3.93923    7.31727; -4.00000   -0.00000   -0.00000  128.00000; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 9;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './010/t1_fl3d_iso_SC-10-T-5_AP_0.nii.gz';
testset{ii}.orient = 'sc';
testset{ii}.v2r = [  -0.69459    0.34333   -3.92424   40.67232; -3.93923   -0.06054    0.69195  122.80298; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 10;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './016/t1_fl3d_iso_ST-10-C-5_AP_0.nii.gz';
testset{ii}.orient = 'st';
testset{ii}.v2r = [-0.35396    0.68924   -3.92424   18.70299; -3.98431   -0.06123    0.34862  126.84258; 0.00000   -3.93970   -0.69195  131.25987; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 11;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './012/t1_fl3d_iso_SC-10-T-5_AP_20.nii.gz';
testset{ii}.orient = 'sc';
testset{ii}.v2r = [  -0.53528    0.56019   -3.92424   28.63478; -3.72237    1.29041    0.69195   72.63316; -1.36287   -3.74447   -0.34862  166.04961; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 12;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './018/t1_fl3d_iso_ST-10-C-5_AP_20.nii.gz';
testset{ii}.orient = 'st';
testset{ii}.v2r = [  -0.09688    0.76873   -3.92424    7.93262; -3.76497    1.30518    0.34862   76.09865; -1.34746   -3.70210   -0.69195  166.77550; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 13;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './026/t1_fl3d_iso_CT-10_RL-0.nii.gz';
testset{ii}.orient = 'ct';
testset{ii}.v2r = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000    0.69459   -3.93923    7.31727; 0.00000   -3.93923   -0.69459  131.26483; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 14;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './032/t1_fl3d_iso_CS-10_RL-0.nii.gz';
testset{ii}.orient = 'cs';
testset{ii}.v2r = [  -3.93923   -0.00000    0.69459  120.84595; -0.69459   -0.00000   -3.93923   51.77120; 0.00000   -4.00000    0.00000  128.00000; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 15;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './028/t1_fl3d_iso_CT-10-S-5_RL-0.nii.gz';
testset{ii}.orient = 'ct';
testset{ii}.v2r = [  -3.98431   -0.06123    0.34862  126.84256; -0.35396    0.68924   -3.92424   18.70298; -0.00000   -3.93970   -0.69195  131.25990; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 16;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './034/t1_fl3d_iso_CS-10-T-5_RL-0.nii.gz';
testset{ii}.orient = 'cs';
testset{ii}.v2r = [-3.93923   -0.06054    0.69195  122.80298; -0.69459    0.34333   -3.92424   40.67233; 0.00000   -3.98478   -0.34862  130.12759; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 17;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './030/t1_fl3d_iso_CT-10-S-5_RL-20.nii.gz';
testset{ii}.orient = 'ct';
testset{ii}.v2r = [  -3.72308   -1.42025    0.34862  161.97202; -0.56835    0.52661   -3.92424   30.76740; 1.34746   -3.70210   -0.69195   80.53835; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 18;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './036/t1_fl3d_iso_CS-10-T-5_RL-20.nii.gz';
testset{ii}.orient = 'cs';
testset{ii}.v2r = [  -3.68096   -1.40418    0.69195  157.53500; -0.77013    0.08506   -3.92424   51.35410; 1.36287   -3.74447   -0.34862   78.82564; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 19;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './046/t1_fl3d_iso_TS-10_AP-0.nii.gz';
testset{ii}.orient = 'ts';
testset{ii}.v2r = [  -3.93923   -0.00000    0.69459  120.84595; -0.00000   -4.00000   -0.00000  128.00000; 0.69459    0.00000    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 20;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,0,0];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './054/t1_fl3d_iso_TC-10_AP-0.nii.gz';
testset{ii}.orient = 'tc';
testset{ii}.v2r = [  -4.00000   -0.00000   -0.00000  128.00000; -0.00000   -3.93923    0.69459  120.84595; 0.00000    0.69459    3.93923  -51.77120; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 21;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,10];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './050/t1_fl3d_iso_TS-10-C-5_AP-10.nii.gz';
testset{ii}.orient = 'ts';
testset{ii}.v2r = [-3.87984   -0.68412    0.69195  140.85724; 0.75217   -3.91315    0.34862   98.53660; 0.61730    0.46827    3.92424  -64.16991; 0.00000    0.00000    0.00000    1.00000 ];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 22;
testset{ii}.numvox = [64,64,16,1]';
testset{ii}.voxdim = [4.0, 4.0, 4.0, 1]';
testset{ii}.offset = [0,0,0,1]';   
testset{ii}.theta = [10,5,20];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './058/t1_fl3d_iso_TC-10-S-5_AP-20.nii.gz';
testset{ii}.orient = 'tc';
testset{ii}.v2r = [  -3.74447   -1.36287    0.34862  160.82027; 1.40418   -3.68096    0.69195   67.66727; 0.08506    0.77013    3.92424  -56.79773; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 23;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [-10,-20,-30,1]';   
testset{ii}.theta = [20,10,5];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './018/ep2d_bold__R10A20H30__C-S_20_T_10__R-L_5.nii.gz';
testset{ii}.orient = 'cs';
testset{ii}.v2r = [-2.79282   -0.42319    1.26309  111.01788; -1.06482    0.39824   -3.47031   46.53613; 0.25749   -2.94318   -0.65118  116.91872; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 24;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [-10,20,-30,1]';   
testset{ii}.theta = [20,10,5];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './021/ep2d_bold__R10P20H30__S-T_20_C_10__A-P_5.nii.gz';
testset{ii}.orient = 'st';
testset{ii}.v2r = [-0.46461    1.03758   -3.47031   -3.12959; -2.95356    0.07134    0.65118   71.25447; -0.24619   -2.81395   -1.26309  129.81921; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

ii = 25;
testset{ii}.numvox = [64,64,4,1]';
testset{ii}.voxdim = [3.0, 3.0, 3.75, 1]';   
testset{ii}.offset = [10,-20,30,1]';   
testset{ii}.theta = [20,10,5];
testset{ii}.patient = 'hfs';
testset{ii}.desc = './022/ep2d_bold__L10A20F30__S-T_20_C_10__A-P_5.nii.gz';
testset{ii}.orient = 'st';
testset{ii}.v2r = [-0.46461    1.03758   -3.47031  -23.12959; -2.95356    0.07134    0.65118  111.25447; -0.24619   -2.81395   -1.26309   69.81921; 0.00000    0.00000    0.00000    1.00000];
testset{ii}.V = genFOV(testset{ii}.numvox, testset{ii}.voxdim, testset{ii}.orient, testset{ii}.theta, testset{ii}.offset, testset{ii}.patient);

%testset{ii}.V.V - testset{ii}.v2r


