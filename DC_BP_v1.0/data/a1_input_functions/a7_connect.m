function [bp] = a7_connect(bp, Nbu, fmean, fvari)
    




%-----------------------Columns od Zeros-----------------------------------
 zero_colum = find(all([bp.A_ang; bp.A] == 0, 1));  

 if ~isempty(zero_colum)
     g = sprintf('%d ', zero_colum);
     warning('The graph is not connected. Disconnected variable nodes: %s', g)
 end
%--------------------------------------------------------------------------


%---------------------Single Connected Node--------------------------------
 one_colum_A     = find(sum(bp.A,1) == 1);
 one_colum_Ang = find(all(bp.A_ang == 0, 1)); 
 one = intersect(one_colum_A, one_colum_Ang);
 
 if ~isempty(one)
     g = sprintf('%d ', one);
     fprintf('The single connected nodes: %s\n', g)
     
     b = zeros(size(one,2), Nbu);
     indices = sub2ind(size(b), 1:size(one,2), one);
     b(indices) = 1;
     
     oc = size(b,1);
 
     bp.mean_ang = [bp.mean_ang fmean * ones(1,oc);];
     bp.vari_ang = [bp.vari_ang fvari * ones(1,oc)];
     bp.factor   = bp.factor + oc;
     bp.direc    = bp.direc + oc;
     bp.A_ang    = [bp.A_ang; b];
 end
%--------------------------------------------------------------------------