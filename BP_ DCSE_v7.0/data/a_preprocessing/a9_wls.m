 function [wls] = a9_wls(sys, pmu, bp)
  

 
%------------Set Mesurments According to Slack Bus and Vectors-------------
 sl = sys.slack(2) * ones(bp.Ndir, 1);
 z  = [bp.zdir - sl; bp.zind];
 
 H = [bp.Adir; bp.Jind];
 C = [bp.vdir; bp.vind];
%-------------------------------------------------------------------------- 
 

%------------------Remove Data According to Slack Bus----------------------
 sl_loc = find(pmu.voltage(bp.vol,1) == sys.slack(1));

 H(sl_loc,:) = [];
 z(sl_loc)   = [];
 C(sl_loc)   = [];
 
 H(:, sys.slack(1)) = [];
%--------------------------------------------------------------------------


%-----------------Vector of Estimated State Variable-----------------------
 tic
 C = spdiags(C, 0, bp.Nfac - 1, bp.Nfac - 1);
 E = speye(bp.Nfac - 1, bp.Nfac - 1);
 W = C.^(1/2) \ E;

 Hti = W * H;                                                     
 rti = W * z;     

 [Q,R,P] = qr(Hti);                                                         
 r       = sprank(Hti);                                                       
 Qn      = Q(:,1:r);                                                           
 U       = R(1:r,1:r);    

 Ts = P * [U \ (Qn' * rti); sparse(bp.Nvar - 1 - r, 1)]; 
 
 wls.time = toc; 
%--------------------------------------------------------------------------


%--------------------Voltage Angles with Slack Bus-------------------------
 ins   = @(a, x, n) cat(1, x(1:n), a, x(n + 1:end));                       
 wls.T = ins(0, Ts, sys.slack(1) - 1);                                
 wls.T = sys.slack(2) * ones(sys.Nbu, 1) + wls.T;                      
 
 wls.Tdeg = wls.T * 180/pi;
%--------------------------------------------------------------------------