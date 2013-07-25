% returns the scanner prefix for offset coords (L/R, A/P, H/F)
function c = offSign(offset, dim)
    switch dim
        case 1
            if offset>0
                c='L';
            else
                c='R';
            end            
        case 2
            if offset>0
                c='P';
            else
                c='A';
            end                        
        case 3
            if offset>0
                c='H';
            else
                c='F';
            end            
    end    
end
