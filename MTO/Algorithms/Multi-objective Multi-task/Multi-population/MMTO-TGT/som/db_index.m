function [t,r] = db_index(D, cl, C, p, q)
 
% DB_INDEX Davies-Bouldin clustering evaluation index.
%
% [t,r] = db_index(D, cl, C, p, q)
%
%  Input and output arguments ([]'s are optional):  
%    D     (matrix) data (n x dim)
%          (struct) map or data struct
%    cl    (vector) cluster numbers corresponding to data samples (n x 1)
%    [C]   (matrix) prototype vectors (c x dim) (default = cluster means)
%    [p]   (scalar) norm used in the computation (default == 2)
%    [q]   (scalar) moment used to calculate cluster dispersions (default = 2)
% 
%    t     (scalar) Davies-Bouldin index for the clustering (=mean(r))
%    r     (vector) maximum DB index for each cluster (size c x 1)    
% 
% See also  KMEANS, KMEANS_CLUSTERS, SOM_GAPINDEX.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if isstruct(D), 
    switch D.type,
    case 'som_map', D = D.codebook; 
    case 'som_data', D = D.data; 
    end
end

% cluster centroids
[~, dim] = size(D);
u = unique(cl); 
c = length(u); 
if nargin <3, 
  C = zeros(c,dim); 
  for i=1:c, 
      me = nanstats(D(cl==u(i),:));
      C(i,:) = me';
  end 
end

u2i = zeros(max(u),1); u2i(u) = 1:c; 
D = som_fillnans(D,C,u2i(cl)); % replace NaN's with cluster centroid values

if nargin <4, p = 2; end % euclidian distance between cluster centers
if nargin <5, q = 2; end % dispersion = standard deviation
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% dispersion in each cluster
S = zeros(1, c);
for i = 1:c
  ind = find(cl==u(i)); % points in this cluster
  l   = length(ind);
  if l > 0
    S(i) = (mean(sqrt(sum((D(ind,:) - ones(l,1) * C(i,:)).^2,2)).^q))^(1/q);
  else
    S(i) = NaN;
  end
end
 
% distances between clusters
%for i = 1:c
%  for j = i+1:c
%    M(i,j) = sum(abs(C(i,:) - C(j,:)).^p)^(1/p);
%  end
%end
M = som_mdist(C,p); 

% Davies-Bouldin index
R = NaN * zeros(c);
r = NaN * zeros(c,1);
for i = 1:c
  for j = i+1:c
    R(i,j) = (S(i) + S(j))/M(i,j);
  end
  r(i) = max(R(i,:));
end
 
t = mean(r(isfinite(r)));
 
return;                                                                                                     

