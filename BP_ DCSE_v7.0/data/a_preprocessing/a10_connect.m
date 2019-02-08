 function [bp] = a10_connect(bp)
    


%----------------------Disconnected Node-----------------------------------
 zero_col = find(all([bp.Adir; bp.Aind] == 0, 1));  

 if ~isempty(zero_col)
    g = sprintf('%d ', zero_col);
    warning('The graph is not connected. Disconnected variable nodes: %s', g)
 end
%--------------------------------------------------------------------------

