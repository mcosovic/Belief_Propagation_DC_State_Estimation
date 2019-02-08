 function [] = d4_evaluation(wls, bp)
 
 disp(' ')
 disp('  __________________________________________________________________') 
 disp('    State Estimation Evaluation - Measurements and Estimate Values  ')
 disp('  ------------------------------------------------------------------') 
 disp('      Measure                               WLS            BP       ')
 disp('  ------------------------------------------------------------------') 
 fprintf('  \t Mean Absolute Error               %12.4e %13.4e \n', [wls.MAE bp.MAE ])
 fprintf('  \t Root Mean Square Error            %12.4e %13.4e \n', [wls.RMSE bp.RMSE])
 fprintf('  \t Weighted Residual Sum of Squares  %12.4e %13.4e \n', [wls.WRSS bp.WRSS])
 disp('  __________________________________________________________________') 
 
 
 