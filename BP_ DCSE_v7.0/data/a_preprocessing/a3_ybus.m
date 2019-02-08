 function [sys] = a3_ybus(sys)
    


%-----------------Nondiagonal Elements of Bus Matrix-----------------------
 Yij = sparse(sys.Br(:,1), sys.Br(:,2), -sys.Br(:,3), sys.Nbu,sys.Nbu);     % admittance of branches on "ij" positions 
 Yji = sparse(sys.Br(:,2), sys.Br(:,1), -sys.Br(:,3), sys.Nbu,sys.Nbu);     % admittance of branches on "ji" positions
 Yij = Yij+ Yji;                                                            % non-diagonal elements
%--------------------------------------------------------------------------


%--------------------Diagonal Elements of Bus Matrix-----------------------
 Yii = spdiags(sum(-Yij, 2), 0, sys.Nbu, sys.Nbu);                          % diagonal elements
%--------------------------------------------------------------------------


%---------------------------Full Y Bus Matrix------------------------------                                                  
 sys.Ybu = -imag(Yij + Yii);                                                % full Y bus matrix (including the slack bus)                                            
%--------------------------------------------------------------------------

sys.Yij = Yij;