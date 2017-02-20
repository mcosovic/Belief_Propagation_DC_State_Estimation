 function [in] = a2_pi_model(in)
    


%------------------------PI Model of Branches------------------------------
 z_li = 1i * in.Line(:,4);                                                  % a transmission line impedance 
 y_li = 1 ./ z_li;                                                          % a transmission line admittance
%--------------------------------------------------------------------------

%------------------------PI model of Transformer---------------------------
 if isfield(in, 'Transformer')                                              % if the transformer data exists
    z_tr = complex(in.Transformer(:,3), in.Transformer(:,4));               % a transformer series impedance 
    y_tr = (1 ./ z_tr) ./ in.Transformer(:,5);                              % a transformer series admittance (admittance over tap position)
    y_tr(~isfinite(y_tr)) = 0;    
    
    Tr = [in.Transformer(:,1:2) y_tr];                                      % the transformer data matrix    
 else
    Tr = [];                                                                % if the transformer data not exist
 end
%--------------------------------------------------------------------------


%--------------------More Branches Between Two Buses-----------------------
 in.Br_f = [[in.Line(:,1:2) y_li]; Tr];                                     % the full branch data matrix 
 ft      = in.Br_f(:,1:2);                                                  % the branch matrix from bus, to bus
 ft      = sort(ft, 2);                                                     % sort the matrix
 B       = in.Br_f(:, 3:end);                                               % the admittance and susceptance matrix                                                   
  
 [same,~,idx] = unique(ft, 'rows');                                         % find unique conection between two buses
 num_s        = size(same, 1);                                              % the number of unique conections
 Br_un        = zeros(num_s, size(B,2));                                    % preallocation

 for i = 1:num_s                
     Br_un(i,:) = sum(B(idx == i, :), 1);                                   % the admittance and susceptance sum between two buses
 end
%--------------------------------------------------------------------------

%--------------------More Branches Between Two Buses-----------------------
 in.Br_f = [[in.Line(:,1:2) y_li]; Tr];                                     % the full branch data matrix 
 ft      = in.Br_f(:,1:2);                                                  % the branch matrix from bus, to bus
 ft      = sort(ft, 2);                                                     % sort the matrix
 B       = in.Br_f(:, 3:end);                                               % the admittance and susceptance matrix                                                   
  
 [same,~,idx] = unique(ft, 'rows');                                         % find unique conection between two buses
 num_s        = size(same, 1);                                              % the number of unique conections
 Br_un        = zeros(num_s, size(B,2));                                    % preallocation

 for i = 1:num_s                
     Br_un(i,:) = sum(B(idx == i, :), 1);                                   % the admittance and susceptance sum between two buses
 end
%--------------------------------------------------------------------------


%-------------------------Parameters of System-----------------------------
 in.fromBus = same(:,1);                                                    % branch goes from buses                                                            
 in.toBus   = same(:,2);                                                    % branch goes to buses
 in.Br      = [same Br_un];                                                 % the branch data matrix (transmission line and transformer)

 in.Nli = size(in.Line, 1);                                                 % the number of transmission lines
 in.Ntr = size(Tr, 1);                                                      % the number of transformers
 in.Nbr = num_s;                                                            % the number of branches
%--------------------------------------------------------------------------