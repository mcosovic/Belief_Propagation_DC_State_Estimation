 function [wls] = a9_wls(sys, bp)
  


%-----------------Vector of Estimated State Variable-----------------------
 bp.Adir(sys.sl_loc,:) = [];
 
 H = [bp.Adir; bp.Jind];
 H(:,sys.slack(1)) = [];

 valsl = sys.slack(2) * ones(bp.Ndir, 1);

 z = [bp.zdir - valsl; bp.zind];
 C = [bp.vdir; bp.vind];
 
 z(sys.sl_loc) = [];
 C(sys.sl_loc) = [];
 
 C = spdiags(C, 0, bp.Nfac - 1, bp.Nfac - 1);

 Hti = (C.^(1/2) \ speye(size(C))) * H;                                                     
 rti = (C.^(1/2) \ speye(size(C))) * z;     
    
 [Q,R,P] = qr(Hti);                                                         
 [~,n]   = size(Hti);
 r       = sprank(Hti);                                                       
 Qn      = Q(:,1:r);                                                           
 U       = R(1:r,1:r);    

 Ts = P * [U \ (Qn' * rti); zeros(n - r, 1)];   
%--------------------------------------------------------------------------


%--------------------Voltage Phases with Slack Bus-------------------------
 ins      = @(a, x, n) cat(2, x(1:n), a, x(n + 1:end));                        
 wls.Twls = (ins(0, Ts', sys.slack(1) - 1))';                                
 wls.Twls = sys.slack(2) * ones(sys.Nbu, 1) + wls.Twls;                      
 
 wls.Twls_deg = wls.Twls * 180/pi;
%--------------------------------------------------------------------------
