 function [sys] = a3_ybus(sys)
    


%----------------------------Preallocate-----------------------------------
 Yij = sparse(sys.Nbu, sys.Nbu);
%--------------------------------------------------------------------------


%--------------------------Linear Indexing---------------------------------
 ijY = sub2ind(size(Yij), sys.Br(:,1), sys.Br(:,2));                        % linear indexing of "ij" elements
 jiY = sub2ind(size(Yij), sys.Br(:,2), sys.Br(:,1));                        % linear indexing of "ji" elements
%--------------------------------------------------------------------------


%-----------------Nondiagonal Elements of Bus Matrix-----------------------
 Yij(ijY) = -sys.Br(:,3);                                                   % admittance of branches on "ij" position
 Yij(jiY) = -sys.Br(:,3);                                                   % admittance of branches on "ji" position
%--------------------------------------------------------------------------


%--------------------Diagonal Elements of Bus Matrix-----------------------
 Yii = spdiags(sum(-Yij, 2), 0, sys.Nbu, sys.Nbu);                          % diagonal elements
%--------------------------------------------------------------------------


%---------------------------Full Y Bus Matrix------------------------------                                                  
 sys.Ybu = -imag(Yij + Yii);                                                % full Y bus matrix (including the slack bus)                                            
%--------------------------------------------------------------------------