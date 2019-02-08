 function [wls, bp] = c2_evaluation(wls, bp)

 
%------------------State Estimation WLS Evaluation-------------------------
 z = [bp.zdir; bp.zind];
 v = [bp.vdir; bp.vind];
 f = [bp.Adir; bp.Jind] * wls.T; 
 
 wls.MAE  = sum(abs(z - f)) / bp.Nfac ; 
 wls.RMSE = ((sum(z - f).^2) / bp.Nfac )^(1/2);    
 wls.WRSS = sum(((z - f).^2) ./ (v.^2));
 
 f = [bp.Adir; bp.Jind] * bp.mean;
 bp.MAE  = sum(abs(z - f)) / bp.Nfac ; 
 bp.RMSE = ((sum(z - f).^2) / bp.Nfac )^(1/2);    
 bp.WRSS =  sum(((z - f).^2) ./ (v.^2));
%-------------------------------------------------------------------------- 


