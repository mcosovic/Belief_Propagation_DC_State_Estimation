 function [bp] = a5_local_factor(pmu, bp, user)



%-------------------------Directed Factor Nodes---------------------------- 
 bp.Adir = sparse((1:bp.Ndir)', find(bp.vol), 1, bp.Ndir, bp.Nvar);

 bp.zdir = pmu.voltage(bp.vol,2);
 bp.vdir = pmu.voltage(bp.vol,4).^2;
%-------------------------------------------------------------------------- 


%--------------------------Local Factor Nodes------------------------------ 
 bp.zloc = bp.xin;
 bp.vloc = user.vari * ones(bp.Nvar, 1);
 
 bp.zloc(bp.vol) = bp.zdir; 
 bp.vloc(bp.vol) = bp.vdir;
%-------------------------------------------------------------------------- 