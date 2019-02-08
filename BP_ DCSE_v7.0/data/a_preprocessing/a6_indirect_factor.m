 function [bp] = a6_indirect_factor(sys, leg, bp)
 


%------------------Indirect Power Injection Measurements-------------------
 Jinj = sys.Ybu(bp.inj,:);
 Ainj = Jinj ~= 0;

 zinj = leg.injection(bp.inj,2);
 vinj = leg.injection(bp.inj,4).^2;
%--------------------------------------------------------------------------


%---------------------Indirect Power Flow Measurements---------------------
 flow = leg.flow(bp.flo,:);
 Np   = sum(bp.flo);

 o = (1:Np)';
 c = [o; o];                               
 r = [flow(:,1); flow(:,2)];
 
 coef = imag(sys.LiTr(bp.flo,3));
 Jflo = sparse(c, r, [-coef; coef], Np, sys.Nbu);
 Aflo = Jflo ~= 0;
 
 zflo = flow(:,3);
 vflo = flow(:,5).^2;
%--------------------------------------------------------------------------


%--------------------------Indirect Factor Nodes---------------------------
 bp.Aind = [Ainj; Aflo];
 bp.Jind = [Jinj; Jflo];
 
 bp.zind = [zinj; zflo];
 bp.vind = [vinj; vflo];
%--------------------------------------------------------------------------