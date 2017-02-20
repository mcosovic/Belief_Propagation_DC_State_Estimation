 function [bp] = a5_indirect_meas(in, bp)
 


%----------------------Indirect Measurements-------------------------------
 on = in.Injection(:,3) == 1;

 A_inj = in.Ybus(on,:);
 A_inj(A_inj~=0) = 1;
 J_inj = in.Ybus(on,:);
 
 mean_inj = in.Injection(on,2)./in.baseMVA;
 vari_inj = (in.Injection(on,4)./in.baseMVA).^2;
 
 on   = in.Flow(:,4) == 1;
 flow = in.Flow(on,:);
 
 Np       = sum(on);
 A_flo = zeros(Np, in.Nbu);
 J_flo = zeros(Np, in.Nbu); 
 
 c   = [(1:Np)'; (1:Np)'];                               
 r   = [flow(:,1); flow(:,2)];
 px  = sub2ind(size(J_flo), c, r);
 J_flo(px) = [-imag(in.Br_f(on,3)); imag(in.Br_f(on,3))];

 A_flo(J_flo~=0) = 1;
 
 mean_flo = flow(:,3)./in.baseMVA;
 vari_flo = (flow(:,5)./in.baseMVA).^2;
 
 bp.A = [A_inj; A_flo];
 bp.J = [J_inj; J_flo];
 
 bp.mean = [mean_inj; mean_flo];
 bp.vari = [vari_inj; vari_flo];
%--------------------------------------------------------------------------
