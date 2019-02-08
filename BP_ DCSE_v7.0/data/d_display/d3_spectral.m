 function [] = d3_spectral(bp)

 
 
%%
 disp(' ')
 disp('  __________________________________________________________________') 
 disp('                           Spectral Radius                          ')
 disp('  ------------------------------------------------------------------') 
 fprintf('  \t Synchronous Scheduling            %12.4f \t  \n', bp.rho_syn)
 fprintf('  \t Randomized Damping Scheduling     %12.4f \t  \n', bp.rho_rda)
 disp(' ')
 fprintf('  \t Number of Indirect Messages       %12.0f \t  \n', bp.Nmsg)
 fprintf('  \t Number of Randomized Messages     %12.0f \t  \n', nnz(bp.wow))
 disp('  __________________________________________________________________')
 