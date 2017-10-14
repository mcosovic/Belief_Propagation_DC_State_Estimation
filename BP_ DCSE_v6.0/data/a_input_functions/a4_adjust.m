 function [bp, dataSE] = a4_adjust(sys, dataSE)
    

 
%--------------------------Voltage of Slack Bus----------------------------
 dataSE.pmu.voltage(sys.slack(1), 2:4) = [sys.slack(2) 1 10^-30];
%--------------------------------------------------------------------------
 
  
%------------------------Measurements Turn On------------------------------
 bp.vol = dataSE.pmu.voltage(:,3) == 1;
 bp.inj = dataSE.analog.injection(:,3) == 1;
 bp.flo = dataSE.analog.flow(:,4) == 1;
%--------------------------------------------------------------------------


%------------------Number of Variables and Factor Nodes--------------------
 bp.Nvar = sys.Nbu;
 
 bp.Ndir = sum(bp.vol); 
 bp.Nfac = sum([bp.inj; bp.flo]) + bp.Ndir;
 bp.Nvir = bp.Nvar - bp.Ndir;
 bp.Nind = bp.Nfac - bp.Ndir;
%--------------------------------------------------------------------------