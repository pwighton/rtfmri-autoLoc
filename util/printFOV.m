function printFOV(V)
    fprintf('Enter the following values on the console:\n');
    fprintf('              NumVox: %3d %3d %3d\n', V.numvox(1), V.numvox(2), V.numvox(3));
    fprintf('              VoxDim: %1.2f %1.2f %1.2f\n', V.voxdim(1), V.voxdim(2), V.voxdim(3));
    fprintf('                 fov: %3.1f %3.1f %3.1f\n', V.fov(1), V.fov(2), V.fov(3));
    fprintf('    Patient position: %s\n', V.patient);
    offset = V.Pl * [0,0,0,1]';
    fprintf('*test* Offset to iso: %3.1f %3.1f %3.1f\n', offset(1), offset(2), offset(3));        
    fprintf('   Off to iso (grad): %3.1f %3.1f %3.1f\n', V.offset(1), V.offset(2), V.offset(3));
    fprintf('   Slice orientation: %s\n', V.slice_orient);
    fprintf('           Rotations: %3.2f %3.2f %3.2f\n', V.theta(1),V.theta(2),V.theta(3));
    %fprintf('   Rotations (neg): %3.2f %3.2f %3.2f\n', V.theta_neg(1),V.theta_neg(2),V.theta_neg(3));
end
