 function [m_fv] = b1_converg_fix(k, m_fv, m_fvp, alph, wow)

 

%---------------------------Convergence Fix-------------------------------- 
 if k > 2  
    m_fv(wow) = (1 - alph) * m_fv(wow) + alph * m_fvp(wow);
 end
%--------------------------------------------------------------------------
