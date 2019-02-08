 function [] = d1_disp(bp, wls, user)

 
 
%------------------------Estimation Terminal-------------------------------
 d2_estimation(bp, wls, user.stop)
%-------------------------------------------------------------------------- 


%---------------------Spectral Radius Terminal-----------------------------
 if user.radius == 1
    d3_spectral(bp)
 end
%-------------------------------------------------------------------------- 


%-------------------State Estimation Evaluation Terminal--------------------
 if user.evaluation == 1
    d4_evaluation(wls, bp)
 end
%-------------------------------------------------------------------------- 