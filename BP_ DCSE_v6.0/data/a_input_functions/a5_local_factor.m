 function [bp] = a5_local_factor(pmu, bp, user)


 
%-------------------------Directed Factor Nodes---------------------------- 
 bp.Adir      = sparse(bp.Ndir, bp.Nvar);
 idx          = sub2ind([bp.Ndir bp.Nvar], (1:bp.Ndir)', find(bp.vol));
 bp.Adir(idx) = 1;
 
 bp.zdir = pmu.voltage(bp.vol,2);
 bp.vdir = pmu.voltage(bp.vol,4).^2;
%-------------------------------------------------------------------------- 


%--------------------------Virtual Factor Nodes----------------------------
 bp.Avir      = sparse(bp.Nvir, bp.Nvar);
 idx          = sub2ind([bp.Nvir bp.Nvar], (1:bp.Nvir)', find(~bp.vol));
 bp.Avir(idx) = 1;

 bp.zvir = user.mean * ones(bp.Nvir, 1);
 bp.vvir = user.vari * ones(bp.Nvir, 1);
%--------------------------------------------------------------------------


%---------------------Initialize Local Factor Nodes------------------------
 bp.zini = user.mean * ones(bp.Nvar, 1);
 bp.vini = user.vari * ones(bp.Nvar, 1);
 
 bp.zini(bp.vol) = bp.zdir; 
 bp.vini(bp.vol) = bp.vdir;
%--------------------------------------------------------------------------