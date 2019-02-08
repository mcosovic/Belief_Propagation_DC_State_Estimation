 function [bp] = a7_converg(user, bp)
    


%-----------------------Randomized Damping Messages------------------------
 bp.idx  = find(bp.Aind);
 bp.Nmsg = length(bp.idx);
 temp    = ones(bp.Nmsg, 1);
 bp.wow  = logical(binornd(temp, user.prob));
%--------------------------------------------------------------------------
