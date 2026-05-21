function [cPCAarg, Pdata, Pproto] = som_projections(D,sM,bmus)

% SOM_PROJECTIONS Makes different kinds of projections for the data and the prototypes.
%
% [cPCAarg, Pdata, Pproto] = som_projections(D,sM,[bmus])
%
%      sD      (struct) data struct
%              (matrix) size dlen x dim
%      sM      (struct) map struct
%              (matrix) size munits x dim: prototype vectors
%      [bmus]  (vector) BMU for each data vector (calculated if not specified)
%
%      cPCAarg (cell array) PCA arguments: {V, me, l} from pcaproj function
%      Pdata   (matrix) size dlen x 7, consisting of 3 projection coordinates from PCA, 
%                       1 residual from the rest of the PCA-projection coordinates, 
%                       and 3 color components 
%      Pproto  (matrix) size dlen x 7, consisting of 3 projection coordinates from PCA, 
%                       1 residual from the rest of the PCA-projection coordinates, 
%                       3 color components, and 3 projection coordinates from CCA
%
% See also  PCAPROJ, CCA, SAMMON, SOM_PROJECTIONS_PLOT, SOM_COLORING, SOM_COLORCODE, 
%           SOM_CLUSTERCOLOR, SOM_KMEANCOLOR.

if isstruct(D), 
    cn = D.comp_names;
    D = D.data; 
end
[dlen dim] = size(D);
if nargin<3, bmus = som_bmus(sM,D); end

% projection of data

[P0,V,me,l] = pcaproj(D,dim);
D1 = som_fillnans(D,sM); 
P1 = pcaproj(D1,V,me); 
Res4 = zeros(dlen,1); 
if dim<=3, 
    Res4 = zeros(dlen,1); 
else
    Res4 = sqrt(sum(P1(:,4:end).*P1(:,4:end),2));
end
P1 = P1(:,1:min(3,dim)); 
if dim<3, P1 = [P1, zeros(dlen,3-dim)]; end

% projection of codebook vectors

P1_m = pcaproj(sM,V,me); 
Res4_m = zeros(dlen,1); 
if dim<=3, 
    Res4_m = zeros(dlen,1); 
else
    Res4_m = sum(P1_m(:,4:end).*P1_m(:,4:end),2);
end
P1_m = P1_m(:,1:min(3,dim)); 
if dim<3, P1_m = [P1_m, zeros(size(P1_m,1),3-dim)]; end

P2_m = cca(sM,P1_m,20); 

PCol_m = som_coloring(sM); 

PCol = PCol_m(bmus,:); 

% output

cPCAarg = {V,me,l};
Pdata = [P1, Res4, PCol]; 
Pproto = [P1_m, Res4_m, PCol_m, P2_m]; 
 
return;
 