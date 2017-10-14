 function [bp, wls, mean] = b1_belief_propagation(bp, user, wls)
 


 tic
%--------------------Direct and Virtual Factor Nodes-----------------------
 mdir = spdiags(bp.zdir, 0, bp.Ndir, bp.Ndir) * bp.Adir;  
 mvir = spdiags(bp.zvir, 0, bp.Nvir, bp.Nvir) * bp.Avir;
 
 vdir_inv = spdiags(1 ./ bp.vdir, 0, bp.Ndir, bp.Ndir) * bp.Adir; 
 vvir_inv = spdiags(1 ./ bp.vvir, 0, bp.Nvir, bp.Nvir) * bp.Avir;
%-------------------------------------------------------------------------- 
  
 
%------------------------Indirect Factor Nodes-----------------------------
 mind = spdiags(bp.zind, 0, bp.Nind, bp.Nind) * bp.Aind;
 vind = spdiags(bp.vind, 0, bp.Nind, bp.Nind) * bp.Aind;
%--------------------------------------------------------------------------
 
 
%-----------------Messages v -> f Initialization---------------------------
 m_vf = bp.Aind * spdiags(bp.zini, 0, bp.Nvar, bp.Nvar);                                                 
 v_vf = bp.Aind * spdiags(bp.vini, 0, bp.Nvar, bp.Nvar);   
%--------------------------------------------------------------------------


%-----------------------Parameters Initialization--------------------------
 idx    = find(bp.Aind);
 [i, j] = find(bp.Aind);
 
 J_idx    = bp.Jind(idx);
 mind_idx = mind(idx);
 vind_idx = vind(idx);
 
 m_fvp  = [];
 stopi  = bp.zini';
 
 bp.pre_time = toc + bp.pre_time;
%-------------------------------------------------------------------------- 


 tic
 for k = 1:user.maxi

     
%------------Messages f -> v - from Indirected Factor Nodes---------------- 
 m_fv_sum = bp.Jind .* m_vf * bp.Hm;
 m_fv_res = mind_idx - m_fv_sum(idx);
 m_fv     = sparse(i,j, m_fv_res ./ J_idx, bp.Nind, bp.Nvar);

 v_fv_sum = bp.Jind.^2 .* v_vf * bp.Hm;
 v_fv_res = vind_idx + v_fv_sum(idx); 
 v_fv     = sparse(i,j, v_fv_res ./ J_idx.^2, bp.Nind, bp.Nvar);
%--------------------------------------------------------------------------
 

%---------------------------Convergence Fix--------------------------------
 [m_fv] = b1_converg_fix(k, m_fv, m_fvp, user.alph, bp.wow);
 m_fvp = m_fv;
%-------------------------------------------------------------------------- 


%------------------------------Marginal------------------------------------
 v_fv_inv = sparse(i,j, 1 ./ v_fv(idx), bp.Nind, bp.Nvar);
 
 v_fvd_inv = [v_fv_inv; vdir_inv];
 m_fvd     = [m_fv; mdir];
 
 vari = 1 ./ sum(v_fvd_inv, 1);
 mean = sum(m_fvd .* v_fvd_inv, 1) .* vari; 
%--------------------------------------------------------------------------


%-----------------------------Stopping-------------------------------------
 if all(abs(stopi - mean) < user.stop)
    break
 end
 stopi = mean;
%--------------------------------------------------------------------------

 
%-----------------Messages v -> f - to Indirected Nodes--------------------
 v_fvdv_inv     = [v_fvd_inv; vvir_inv];
 v_fvdv_inv_sum = bp.Fm * v_fvdv_inv;

 v_fv_inv_sum = v_fvdv_inv_sum(1:bp.Nind, :); 
 v_vf         = sparse(i,j, 1 ./ v_fv_inv_sum(idx), bp.Nind, bp.Nvar);

 m_fvdv = [m_fvd; mvir];

 m_vdfv_sum = bp.Fm * (v_fvdv_inv .* m_fvdv);
 m_vf_sum   = m_vdfv_sum(1:bp.Nind, :);

 m_vf = m_vf_sum .* v_vf;
%--------------------------------------------------------------------------

 end

 
%---------------------------Iteration Time---------------------------------
 bp.iter_time = toc; 
%-------------------------------------------------------------------------- 
 
 
%--------------------------Spectral Radius---------------------------------
 [bp] = b2_spectral_rad(user, bp, v_fv_inv);
%-------------------------------------------------------------------------- 

 
%-------------------------------Display------------------------------------
 c1_disp(mean, bp, k, wls, user.stop);
%--------------------------------------------------------------------------