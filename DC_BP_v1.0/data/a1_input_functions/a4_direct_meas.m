function  [bp, in] = a4_direct_meas(in, fmean, fvari)
 


%---------------Initial Voltage and Voltage of Slack Bus-------------------
 in.Angle(in.slack(1), 3) = 1;
 in.Angle(in.slack(1), 2) = in.slack(2);
 in.Angle(in.slack(1), 4) = 10^-30;
%--------------------------------------------------------------------------


%----------------------Directed Measurements-------------------------------
 on = in.Angle(:,3) == 1;
 
 bp.A_ang = diag(on);
 bp.A_ang(all(bp.A_ang == 0, 2), :) = [];
  
 bp.mean_ang = (in.Angle(on,2)*pi/180)';
 bp.vari_ang = (in.Angle(on,4)*pi/180).^2';
 
 bp.mean_ini     = fmean * ones(1,in.Nbu);
 bp.mean_ini(on) = bp.mean_ang;
 bp.vari_ini     = fvari * ones(1,in.Nbu);
 bp.vari_ini(on) = bp.vari_ang;
 
 in.sl_loc = find(in.Angle(on,1) == in.slack(1));
%--------------------------------------------------------------------------
