 function [bp] = a8_expand_sum(bp)
    

 
%------------------------Expand - Initialization---------------------------
 [row, col] = find(bp.Aind);
 
 row_un  = unique(row);
 counts  = hist(row, row_un);
 row_di  = sum(counts .* (counts - 1));
 bp.rowi = zeros(row_di, 1);
 row_idx = zeros(row_di, 1);
 
 col_un  = unique(col);
 counts  = hist(col, col_un);
 col_di  = sum(counts .* (counts - 1));
 bp.coli = zeros(col_di,1);
 col_idx = zeros(col_di,1);
 
 loc_idx = zeros(bp.Nmsg, 1);
 bp.col  = col;
 bp.row  = row;
%-------------------------------------------------------------------------- 
 

%------------------------Expand for BP Summation---------------------------
sr = 0;
sc = 0;
tr = row;
tc = col;

for kk = 1:bp.Nmsg 
    r = row(kk);
    c = col(kk);
    
    tr(kk) = 0;
    tc(kk) = 0;
    
    br = tr == r;
    bc = tc == c;
    
    tr = row;
    tc = col; 
    
    nr = length(bp.idx(br));
    nc = length(bp.idx(bc));
     
    bp.rowi(sr + 1: sr + nr) = kk * ones(nr, 1);
    row_idx(sr + 1: sr + nr) = bp.idx(br);
    
    bp.coli(sc + 1: sc + nc) = kk * ones(nc, 1);
    col_idx(sc + 1: sc + nc) = bp.idx(bc);
    loc_idx(kk) = c;
     
    sr = sr + nr;
    sc = sc + nc;
end
 
 [~, bp.rowe] = ismember(row_idx, bp.idx);
 [~, bp.cole] = ismember(col_idx, bp.idx);
%--------------------------------------------------------------------------


%-----------------------Expand Local Factor Nodes---------------------------
 C     = 1 ./ bp.vloc;
 bp.Lv_fv = C(loc_idx);
 
 Lm_fv = bp.zloc .* C;
 bp.Lm_fv = Lm_fv(loc_idx);
 
 bp.pre_time = toc;
%--------------------------------------------------------------------------

