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
    
    numvox;
    voxdim;
    r2r;    
    G2P_m;
    Vnew = genFOV3_G2Pr(numvox, voxdim, 'hfs', inv(r2r) * G2P_m);
    printFOV(Vnew);
end

