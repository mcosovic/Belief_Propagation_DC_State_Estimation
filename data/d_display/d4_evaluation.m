 function [] = d4_evaluation(wls, bp)
 
 
 %%
 disp(' ')
 disp('  __________________________________________________________________') 
 disp('    State Estimation Evaluation - Measurements and Estimate Values  ')
 disp('  ------------------------------------------------------------------') 
 disp('      Measure                                BP            WLS       ')
 disp('  ------------------------------------------------------------------') 
 fprintf('  \t Mean Absolute Error               %12.4e %13.4e \n', [bp.mae wls.mae])
 fprintf('  \t Root Mean Square Error            %12.4e %13.4e \n', [bp.rmse wls.rmse])
 fprintf('  \t Weighted Residual Sum of Squares  %12.4e %13.4e \n', [bp.wrss wls.wrss])
 disp('  __________________________________________________________________') 