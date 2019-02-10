 function [wls, bp] = c2_evaluation(wls, bp)

 
 
%------------------------------System Data---------------------------------
 z = [bp.zdir; bp.zind];
 v = [bp.vdir; bp.vind];
 A = [bp.Adir; bp.Jind]; 
%-------------------------------------------------------------------------- 
 

%--------------------State Estimation WLS Evaluation-----------------------
 f = A * wls.T; 
 
 wls.mae  = sum(abs(z - f)) / bp.Nfac; 
 wls.rmse = ((sum(z - f).^2) / bp.Nfac)^(1/2);    
 wls.wrss = sum(((z - f).^2) ./ (v));
%--------------------------------------------------------------------------
 

%--------------------State Estimation BP Evaluation------------------------
 f = A * bp.mean;
 
 bp.mae  = sum(abs(z - f)) / bp.Nfac; 
 bp.rmse = ((sum(z - f).^2) / bp.Nfac)^(1/2);    
 bp.wrss = sum(((z - f).^2) ./ (v));
%-------------------------------------------------------------------------- 