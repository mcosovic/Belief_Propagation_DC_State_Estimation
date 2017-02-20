 function [in] = a3_ybus(in)
 
 

%----------------------------Preallocate-----------------------------------
 [Y_ij, Y_ii_bt] = deal(zeros(in.Nbu, in.Nbu));
%--------------------------------------------------------------------------


%--------------------------Linear Indexing---------------------------------
 ijY = sub2ind(size(Y_ij), in.fromBus, in.toBus);                           % a linear indexing of "ij" elements
 jiY = sub2ind(size(Y_ij), in.toBus, in.fromBus);                           % a linear indexing of "ji" elements
%--------------------------------------------------------------------------


%-----------------Nondiagonal Elements of Bus Matrix-----------------------
 Y_ij(ijY) = - in.Br(:,3);                                                  % the admittance of branches on "ij" position
 Y_ij(jiY) = - in.Br(:,3);                                                  % the admittance of branches on "ji" position
%--------------------------------------------------------------------------


%--------------------Diagonal Elements of Bus Matrix-----------------------
 for i = 1:in.Nbu;                                                          % count buses
     for j = 1:in.Nbr;                                                      % count branches
         if in.Br(j,1) == i                                                 % if a branch incidents with from bus
            Y_ii_bt(i,i) = Y_ii_bt(i,i) + in.Br(j,3);                       % the branch admittance (Y_ii_bt(i,i) + in.Br(j,3)) "plus" shunt susceptance (in.Br(j,4)) 
         end
         if in.Br(j,2) == i                                                 % if a branch incidents with to bus
            Y_ii_bt(i,i) = Y_ii_bt(i,i) + in.Br(j,3);                       % the branch admittance (Y_ii_bt(i,i) + in.Br(j,3)) "plus" shunt susceptance (in.Br(j,5))  
         end
     end
 end
%--------------------------------------------------------------------------

%---------------------------Full Y Bus Matrix------------------------------                                                  
 in.Ybus = - imag(Y_ij + Y_ii_bt);                                                 % a full Y bus matrix (including the slack bus)                                            
%--------------------------------------------------------------------------


% %-------------------------Y bus with Slack Bus-----------------------------                                                  
%  in.BB     = - imag(in.Y_bus);
% %--------------------------------------------------------------------------

