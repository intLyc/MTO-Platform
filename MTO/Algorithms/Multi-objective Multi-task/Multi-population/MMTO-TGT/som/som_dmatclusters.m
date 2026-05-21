function [base,seed] = som_dmatclusters(sM,linkage,neigh,ignore)

% SOM_DMATCLUSTERS Cluster map based on neighbor distance matrix.
%
% base = som_dmatclusters(sM,linkage,neigh,ignore)
%
% sM        (struct) map or data struct
%           (matrix) data matrix, size n x dim
% [linkage] (string) 'closest', 'single', 'average', 'complete', 
%                    'centroid', 'ward', and 'neighf' (last for SOM only)
%                    default is 'centroid'
% [neigh]   (string) 'kNN' or 'Nk' (which is valid for a SOM only)
%                    for example '6NN' or 'N1'
%                    default is '10NN' for a data set and 'N1' for SOM
%           (matrix) 0/1 matrix of size size n x n, 1=connection exists
% [ignore]  (vector) indeces of vectors to be ignored in the spreading
%                    phase, empty vector by default
%
% base      (vector) size n x 1, cluster indeces (1...c)
% seed      (vector) size c x 1, indeces of seed units for the clusters
%
% See also  SOM_NEIGHBORS, KMEANS_CLUSTERS, SOM_DMATMINIMA.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if nargin<2 || isempty(linkage), linkage = 'centroid'; end

if nargin<3 || isempty(neigh),
  if isstruct(sM) && strcmp(sM.type,'som_map'),
    neigh = 'N1';
  else
    neigh = '10NN';
  end
end

if nargin<4, ignore = []; end
n = size(sM.codebook,1);

% neighborhoods
if ischar(neigh),
  Ne = som_neighbors(sM,neigh);
else
  Ne = neigh;
end

% find seed points
seed = som_dmatminima(sM,[],Ne);

% make partition
base = zeros(n,1);
base(seed) = 1:length(seed);
if any(ignore), base(ignore) = NaN; end
base = som_clspread(sM,base,linkage,Ne,0);

% assign the ignored units, too
base(isnan(base)) = 0;
if any(base==0), base = som_clspread(sM,base,linkage,Ne,0); end

return;

