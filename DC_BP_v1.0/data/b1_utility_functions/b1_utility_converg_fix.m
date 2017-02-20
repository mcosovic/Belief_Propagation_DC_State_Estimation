 function  [vari_fv, mean_fv] = b1_utility_converg_fix(k, bp, vari_fv, mean_fv, mean_fv_pre, vari_fv_pre, user)

 

%---------------------------Convergence Fix-------------------------------- 
 if k > 2
    a   = bp.idx';
    n   = length(a);
    nr  = round(user.prob * n);
    wow = a(randperm(n, nr));

    vari_fv(wow) = user.alp1 * vari_fv(wow) + user.alp2 * vari_fv_pre(wow);
    mean_fv(wow) = user.alp1 * mean_fv(wow) + user.alp2 * mean_fv_pre(wow);
 end
%--------------------------------------------------------------------------


