 function [sys] = a2_pi_model(sys)



%--------------------PI model of Transmission Line-------------------------
 zli = complex(sys.line(:,3), sys.line(:,4));                               % transmission line impedance 
 yli = 1 ./ zli;                                                            % transmission line admittance
%--------------------------------------------------------------------------


%------------------------PI model of Transformer---------------------------
 if isfield(sys, 'transformer')                                             % if the transformer data exists
    ytr = 1 ./ complex(sys.transformer(:,3), sys.transformer(:,4));         % transformer admittance  
    ali = 1 ./ sys.transformer(:,5);
    ali(~isfinite(ali)) = 0; 

    ytrs  = ali .* ytr;                                                     % transformer series admittance (admittance over tap position)
  
    Tr = [sys.transformer(:,1:2) ytrs];                                      % transformer data matrix    
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


%-------------------------Parameters of System-----------------------------
 sys.Nbu = size(sys.bus, 1);                                                % number of buses
%--------------------------------------------------------------------------