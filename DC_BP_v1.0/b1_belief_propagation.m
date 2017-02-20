 function [] = b1_belief_propagation(bp, user, wls)


 
%-----------------------Indirected Measurements----------------------------
 mean_angle = repmat(bp.mean_ang', 1, bp.variable) .* bp.A_ang;
 vari_angle = repmat(bp.vari_ang', 1, bp.variable) .* bp.A_ang;
%-------------------------------------------------------------------------- 
 

%------------------------Directed Measurements----------------------------- 
 mean_factor = repmat(bp.mean, 1, bp.variable);
 vari_factor = repmat(bp.vari, 1, bp.variable);
%--------------------------------------------------------------------------
 

%--------------Messages v -> f Initialization (All)------------------------
 mean_vf = repmat(bp.mean_ini, bp.indir, 1);                                
 mean_vf = mean_vf .* bp.A;                                                 

 vari_vf = repmat(bp.vari_ini, bp.indir, 1);                                
 vari_vf = vari_vf .* bp.A;    
%--------------------------------------------------------------------------


%-----------------------------Initialization-------------------------------  
 mean_fv_pre = [];
 vari_fv_pre = [];
 stopi       = bp.mean_ini;
%-------------------------------------------------------------------------- 

 for k = 1:user.maxi
  
%------------Messages f -> v - from Indirected Factor Nodes---------------- 
 mean_fv = -(bp.J  .* mean_vf * bp.Hm - mean_factor) ./ bp.J ;
 mean_fv(~isfinite(mean_fv)) = 0;

 vari_fv = (bp.J .^2 .* vari_vf * bp.Hm + vari_factor) ./ bp.J .^2;
 vari_fv(~isfinite(vari_fv)) = 0; 
%--------------------------------------------------------------------------
 
 
%---------------------------Convergence Fix--------------------------------
 [Fvari_fv, Fmean_fv] = b1_utility_converg_fix(k, bp, vari_fv, mean_fv, ...
                                           mean_fv_pre, vari_fv_pre, user);
 mean_fv_pre = mean_fv;
 vari_fv_pre = vari_fv;
%--------------------------------------------------------------------------


%-----------------Messages v -> f - to Indirected Nodes--------------------
 vari_fv_fi = 1 ./ [vari_angle; Fvari_fv];
 vari_fv_fi(~isfinite(vari_fv_fi)) = 0;
 
 kk = bp.Fm * vari_fv_fi;
 vari_vf = 1 ./ kk(bp.direc + 1:end,:);  
 vari_vf(~isfinite(vari_vf)) = 0;

 mean_fv_f = [mean_angle; Fmean_fv];
 mfv = bp.Fm * (vari_fv_fi .* mean_fv_f);
 mean_vf_sum = mfv(bp.direc + 1:end,:);

 mean_vf = mean_vf_sum .* vari_vf;
%--------------------------------------------------------------------------


%------------------------------Marginal------------------------------------
 var_fv = 1 ./ [vari_angle; Fvari_fv];
 var_fv(~isfinite(var_fv)) = 0;

 mea_fv = [mean_angle; Fmean_fv];
 vari= 1./sum(var_fv,1);

 mean = (sum(mea_fv .* var_fv,1)) .* vari;
%--------------------------------------------------------------------------


%-----------------------------Stopping-------------------------------------
 if all(abs(stopi - mean) < user.stop)
    break
 end
 stopi = mean;
%--------------------------------------------------------------------------

 end

  
%-------------------------------Display------------------------------------
 c1_final_disp(mean, bp, k, wls);
%--------------------------------------------------------------------------