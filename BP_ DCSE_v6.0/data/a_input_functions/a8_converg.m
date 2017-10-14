 function [bp] = a8_converg(user, bp)
    


%-----------------------Randomized Damping Messages------------------------
 idx     = find(bp.Aind);
 bp.Nmsg = length(idx);
 temp    = ones(bp.Nmsg, 1);
 mix     = logical(binornd(temp, user.prob));
 
 bp.wow = idx(mix);
%--------------------------------------------------------------------------
