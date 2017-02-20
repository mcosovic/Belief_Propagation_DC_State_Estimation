 function [wls] = a6_wls(bp, in)
  


%-----------------Vector of estimated state variable-----------------------
 A_ang = bp.A_ang;
 A_ang(in.sl_loc,:) = [];
 H = [A_ang; bp.J];
 H(:,in.slack(1)) = [];
 
 valsl  = in.slack(2) * pi/180;
 vec_sl = repmat(valsl, bp.direc-1, 1);
 mean_ang = bp.mean_ang;
 mean_ang(in.sl_loc) = [];
 z = [mean_ang' - vec_sl; bp.mean];

 vari_ang = bp.vari_ang;
 vari_ang(in.sl_loc) = [];
 C = [vari_ang'; bp.vari];
 C = diag(C);
 
 Hti = (C^(1/2) \ eye(size(C))) * H;                                                      
 rti = (C^(1/2) \ eye(size(C))) * z;     
    
 [Q,R,P] = qr(Hti);                                                         
 [~,n]   = size(Hti);
 r       = rank(Hti);                                                       
 Qn = Q(:,1:r);                                                           
 U  = R(1:r,1:r);    

 Tetas = P * [U \ (Qn' * rti); zeros(n - r, 1)];   
%--------------------------------------------------------------------------


%-----------------------Voltage Phases with Slack Bus----------------------
 insert   = @(a, x, n) cat(2, x(1:n), a, x(n + 1:end));                     % insert the slack bus voltage angle    
 wls.Teta = (insert(0, Tetas', in.slack(1) - 1))';                          % the bus voltage angle vector
 wls.Teta = repmat(in.slack(2) * pi/180, in.Nbu, 1) + wls.Teta;             % solution acording to the slack bus
 
 wls.Teta_deg = wls.Teta * 180/pi;
%--------------------------------------------------------------------------
