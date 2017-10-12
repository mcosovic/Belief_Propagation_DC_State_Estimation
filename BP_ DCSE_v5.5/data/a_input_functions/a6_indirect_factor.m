 function [bp] = a6_indirect_factor(sys, ana, bp)
 


%------------------Indirect Power Injection Measurements-------------------
 Jinj = sys.Ybu(bp.inj,:);
 Ainj = Jinj ~= 0;

 zinj = ana.injection(bp.inj,2);
 vinj = ana.injection(bp.inj,4).^2;
%--------------------------------------------------------------------------


%---------------------Indirect Power Flow Measurements---------------------
 flow = ana.flow(bp.flo,:);
 Np   = sum(bp.flo);
 Jflo = sparse(Np, sys.Nbu);  
 
 or  = (1:Np)';
 c   = [or; or];                               
 r   = [flow(:,1); flow(:,2)];
 idx = sub2ind([Np sys.Nbu], c, r);
 
 Jflo(idx) = [-imag(sys.LiTr(bp.flo,3)); imag(sys.LiTr(bp.flo,3))];
 Aflo      = Jflo ~= 0;

 zflo = flow(:,3);
 vflo = flow(:,5).^2;
%--------------------------------------------------------------------------


%--------------------------Indirect Factor Nodes---------------------------
 bp.Aind = [Ainj; Aflo];
 bp.Jind = [Jinj; Jflo];
 
 bp.zind = [zinj; zflo];
 bp.vind = [vinj; vflo];
%--------------------------------------------------------------------------
