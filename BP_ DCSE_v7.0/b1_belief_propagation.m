 function [bp] = b1_belief_propagation(bp, user)
 


%------------------------Indirect Factor Nodes-----------------------------
 mind = spdiags(bp.zind, 0, bp.Nind, bp.Nind) * bp.Aind;
 vind = spdiags(bp.vind, 0, bp.Nind, bp.Nind) * bp.Aind;
 
 mind = full(mind(bp.idx));
 vind = full(vind(bp.idx));
%--------------------------------------------------------------------------

 
%-------------------Messages v -> f Initialization-------------------------
 m_vf = bp.Aind * spdiags(bp.zloc, 0, bp.Nvar, bp.Nvar);                                                 
 v_vf = bp.Aind * spdiags(bp.vloc, 0, bp.Nvar, bp.Nvar);
 
 m_vf = full(m_vf(bp.idx));
 v_vf = full(v_vf(bp.idx));
%--------------------------------------------------------------------------


%-----------------------Parameters Initialization-------------------------- 
 J  = full(bp.Jind(bp.idx));
 J2 = J.^2;
 
 m_fvp = [];
 stopi = m_vf;
 
 bp.pre_time = toc;
%-------------------------------------------------------------------------- 


%======================Belief Propagation Algorithm========================
 tic
 for k = 1:user.maxi

     
%------------Messages f -> v - from Indirected Factor Nodes----------------
 cm   = J .* m_vf;
 m_fv = (mind - accumarray(bp.rowi, cm(bp.rowe))) ./ J;
  
 cv    = J2 .* v_vf;
 v_fvi = J2 ./ (vind + accumarray(bp.rowi, cv(bp.rowe))); 
%--------------------------------------------------------------------------

 
%---------------------------Convergence Fix--------------------------------
 [m_fv] = b1_converg_fix(k, m_fv, m_fvp, user.alph, bp.wow);
 m_fvp = m_fv;
%-------------------------------------------------------------------------- 
 

%-----------------------------Stopping-------------------------------------
 if all(abs(stopi - m_fv) < user.stop)
    break
 end
 stopi = m_fv;
%--------------------------------------------------------------------------


%-----------------Messages v -> f - to Indirected Nodes--------------------
 v_vf = 1 ./ (accumarray(bp.coli, v_fvi(bp.cole)) + bp.Lv_fv);
 
 cmv  = m_fv .* v_fvi;
 m_vf = (accumarray(bp.coli, cmv(bp.cole)) + bp.Lm_fv) .* v_vf;
%--------------------------------------------------------------------------

 end
%==========================================================================


%---------------------------Iteration Time---------------------------------
 bp.iter_time = toc; 
 tic
%-------------------------------------------------------------------------- 


%------------------------------Marginal------------------------------------
 varii = accumarray(bp.col, v_fvi) + 1 ./ bp.vloc;
 cmv   = m_fv .* v_fvi;
 
 vari    = 1 ./ varii;
 bp.mean = (accumarray(bp.col, cmv) + bp.zloc ./ bp.vloc) .* vari;
 
 bp.v_fvi = v_fvi;
 bp.k     = k;
%--------------------------------------------------------------------------

 

