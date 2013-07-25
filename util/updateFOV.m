function Vnew = updateFOV(lta_filename)

    [status, output] = system(['cat ', lta_filename]);
    temp = textscan(output, '%s');
    cells = temp{1};
        
    for ii=33:48
        r2r(ii-32) = str2num(cells{ii});
    end
    r2r = reshape(r2r,4,4)';
    
    for ii=64:66
        numvox(ii-63) = str2num(cells{ii});
    end
    numvox(4) = 1;
    
    for ii=69:71
        voxdim(ii-68) = str2num(cells{ii});
    end
    voxdim(4) = 1;
    
    for ii=74:76
        G2P_m(ii-73) = str2num(cells{ii});
    end
    for ii=79:81
        G2P_m(ii-78+4) = str2num(cells{ii});
    end
    for ii=84:86
        G2P_m(ii-83+8) = str2num(cells{ii});
    end
    for ii=89:91
        G2P_m(ii-88+12) = str2num(cells{ii});
    end
    G2P_m(16) = 1;
    G2P_m = reshape(G2P_m,4,4);

    for ii=117:119
        G2P_d(ii-116) = str2num(cells{ii});
    end
    for ii=122:124
        G2P_d(ii-121+4) = str2num(cells{ii});
    end
    for ii=127:129
        G2P_d(ii-126+8) = str2num(cells{ii});
    end
    for ii=132:134
        G2P_d(ii-131+12) = str2num(cells{ii});
    end
    G2P_d(16) = 1;
    G2P_d = reshape(G2P_d,4,4);

    numvox;
    voxdim;
    r2r;    
    G2P_m;
    G2P_d;
    
    % consistent
    Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', inv(r2r) * G2P_d);
    printFOV(Vnew);
    %Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', G2P_d * r2r);
    %printFOV(Vnew);
    %Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', inv(G2P_d) * r2r);
    %printFOV(Vnew);

    % inconsistent
    %Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', inv(r2r) * G2P_m);
    %Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', r2r * G2P_m);
    %Vnew = genFOV_G2Pr(numvox, voxdim, 'hfs', inv(G2P_d) * r2r * G2P_m);
end

