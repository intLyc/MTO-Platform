function [centers,clusters,errors,ind] = kmeans_clusters(sD, n_max, c_max, verbose)

% KMEANS_CLUSTERS Clustering with k-means with different values for k.
%
% [c, p, err, ind] = kmeans_clusters(sD, [n_max], [c_max], [verbose])
%
%   [c, p, err, ind] = kmeans_clusters(sD);
%  
%  Input and output arguments ([]'s are optional):
%   D         (struct) map or data struct
%             (matrix) size dlen x dim, the data 
%   [n_max]   (scalar) maximum number of clusters, default is sqrt(dlen)
%   [c_max]   (scalar) maximum number of k-means runs, default is 5
%   [verbose] (scalar) verbose level, 0 by default
%
%   c         (cell array) c{i} contains cluster centroids for k=i
%   p         (cell array) p{i} contains cluster indeces for k=i
%   err       (vector) squared sum of errors for each value of k
%   ind       (vector) Davies-Bouldin index value for each clustering
%
% Makes a k-means to the given data set with different values of
% k. The k-means is run multiple times for each k, and the best of
% these is selected based on sum of squared errors. Finally, the
% Davies-Bouldin index is calculated for each clustering. 
%
% For example to cluster a SOM: 
%    [c, p, err, ind] = kmeans_clusters(sM); % find clusterings
%    [dummy,i] = min(ind); % select the one with smallest index
%    som_show(sM,'color',{p{i},sprintf('%d clusters',i)}); % visualize
%    colormap(jet(i)), som_recolorbar % change colormap
%  
% See also SOM_KMEANS.

% References: 
%   Jain, A.K., Dubes, R.C., "Algorithms for Clustering Data", 
%   Prentice Hall, 1988, pp. 96-101.
%
%   Davies, D.L., Bouldin, D.W., "A Cluster Separation Measure", 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, 
%   vol. PAMI-1, no. 2, 1979, pp. 224-227.
%
%   Vesanto, J., Alhoniemi, E., "Clustering of the Self-Organizing
%   Map", IEEE Transactions on Neural Networks, 2000.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Esa Alhoniemi
% Copyright (c) by Esa Alhoniemi
% http://www.cis.hut.fi/projects/somtoolbox/

% ecco 301299 juuso 020200 211201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments and initialization

if isstruct(sD), 
  if isfield(sD,'data'), D = sD.data; 
  else D = sD.codebook; 
  end
else D = sD; 
end
[dlen dim] = size(D);

if nargin < 2 || isempty(n_max) || isnan(n_max), n_max = ceil(sqrt(dlen)); end
if nargin < 3 || isempty(c_max) || isnan(c_max), c_max = 5; end
if nargin < 4 || isempty(verbose) || isnan(verbose), verbose = 0; end

centers   = cell(n_max,1); 
clusters  = cell(n_max,1);
ind       = zeros(1,n_max)+NaN;
errors    = zeros(1,n_max)+NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% the case k=1 is trivial, but Davies-Boulding index cannot be evaluated
m = zeros(1,dim);
for i=1:dim, m(i)=mean(D(isfinite(D(:,i)),i)); end
centers{1} = m;
clusters{1} = ones(dlen,1);
[~, qerr] = som_bmus(m,D);
errors(1) = sum(qerr.^2);
ind(1) = NaN; 

if verbose, fprintf(2,'Doing k-means for 2-%d clusters\n',n_max); end

for i = 2:n_max, % number of clusters

  % make k-means with k=i for c_max times and select the best based
  % on sum-of-squared errors (SSE)
  best = realmax;  
  for j = 1:c_max     % run number j for cluster i      
    if verbose,
      fprintf('%d/%d clusters, k-means run %d/%d\r', i, n_max,j, c_max);
    end      
    [c, k, err] = som_kmeans('batch', D, i, 100, 0);
    if err < best, k_best = k'; c_best = c; best = err; end
    % ' added in k_best = k'; by kr 1.10.02
  end
  if verbose, fprintf(1, '\n');  end

  % store the results  
  centers{i}  = c_best;
  clusters{i} = k_best;
  errors(i)   = best;
%  ind(i)      = db_index(D, c_best, k_best, 2); wrong version in somtbx ??
  ind(i)      = db_index(D, k_best, c_best, 2); % modified by kr 1.10.02

  % if verbose mode, plot the index & SSE
  if verbose
    subplot(2,1,1), plot(ind), grid
    title('Davies-Bouldin''s index')
    subplot(2,1,2), plot(errors), grid
    title('SSE')
    drawnow
  end
end

return; 



