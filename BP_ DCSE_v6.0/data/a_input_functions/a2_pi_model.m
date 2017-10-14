 function [sys] = a2_pi_model(sys)



%--------------------PI model of Transmission Line-------------------------
 zli = complex(sys.line(:,3), sys.line(:,4));                               % transmission line impedance 
 yli = 1 ./ zli;                                                            % transmission line admittance
%--------------------------------------------------------------------------


%------------------------PI model of Transformer---------------------------
 if isfield(sys, 'transformer')                                             % if the transformer data exists
    ztr = complex(sys.transformer(:,3), sys.transformer(:,4));              % transformer series impedance 
    ytr = (1 ./ ztr) ./ sys.transformer(:,5);                               % transformer series admittance (admittance over tap position)
    ytr(~isfinite(ytr)) = 0;    
   
    Tr = [sys.transformer(:,1:2) ytr];                                      % transformer data matrix    
 else
    Tr = [];                                                                % if the transformer data not exist
 end
%--------------------------------------------------------------------------


%--------------------More Branches Between Two Buses-----------------------
 sys.LiTr = [[sys.line(:,1:2) yli]; Tr];                                    % full branch data matrix 
 ft       = sys.LiTr(:,1:2);                                                % branch matrix from bus, to bus
 ft       = sort(ft, 2);                                                    % sort the matrix
  
 [a,~,i] = unique(ft, 'rows');                                              % find unique conection between two buses
 sys.Br  = [a, accumarray(i, sys.LiTr(:,3))];                               % branch data matrix (transmission line and transformer)
%--------------------------------------------------------------------------