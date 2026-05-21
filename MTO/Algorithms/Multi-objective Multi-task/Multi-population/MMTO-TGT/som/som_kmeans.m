function [codes,clusters,err] = som_kmeans(method, D, k, epochs, verbose)

% SOM_KMEANS K-means algorithm.
%
% [codes,clusters,err] = som_kmeans(method, D, k, [epochs], [verbose])
%
%  Input and output arguments ([]'s are optional):  
%    method     (string) k-means algorithm type: 'batch' or 'seq'
%    D          (matrix) data matrix
%               (struct) data or map struct
%    k          (scalar) number of centroids
%    [epochs]   (scalar) number of training epochs
%    [verbose]  (scalar) if <> 0 display additonal information
%
%    codes      (matrix) codebook vectors
%    clusters   (vector) cluster number for each sample
%    err        (scalar) total quantization error for the data set
%
% See also KMEANS_CLUSTERS, SOM_MAKE, SOM_BATCHTRAIN, SOM_SEQTRAIN.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function has been renamed by Kimmo Raivio, because matlab65 also have 
% kmeans function 1.10.02
%% input arguments

if isstruct(D), 
    switch D.type, 
    case 'som_map', data = D.codebook; 
    case 'som_data', data = D.data; 
    end 
else 
    data = D; 
end
[l dim]   = size(data);

if nargin < 4 || isempty(epochs) || isnan(epochs), epochs = 100; end
if nargin < 5, verbose = 0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

rand('state', sum(100*clock)); % init rand generator

lr = 0.5;                      % learning rate for sequential k-means
temp      = randperm(l);
centroids = data(temp(1:k),:);
res       = zeros(k,l);
clusters  = zeros(1, l);

if dim==1, 
    [codes,clusters,err] = scalar_kmeans(data,k,epochs); 
    return; 
end

switch method
 case 'seq',
  len = epochs * l;
  l_rate = linspace(lr,0,len);
  order  = randperm(l);
  for iter = 1:len
    x  = D(order(rem(iter,l)+1),:);                   
    dx = x(ones(k,1),:) - centroids; 
    [dist nearest] = min(sum(dx.^2,2)); 
    centroids(nearest,:) = centroids(nearest,:) + l_rate(iter)*dx(nearest,:);
  end
  [dummy clusters] = min(((ones(k, 1) * sum((data.^2)', 1))' + ...
			 ones(l, 1) * sum((centroids.^2)',1) - ...
			 2.*(data*(centroids')))');

 case 'batch',
  iter      = 0;
  old_clusters = zeros(k, 1);
  while iter<epochs
    
    [dummy clusters] = min(((ones(k, 1) * sum((data.^2)', 1))' + ...
			   ones(l, 1) * sum((centroids.^2)',1) - ...
			   2.*(data*(centroids')))');

    for i = 1:k
      f = find(clusters==i);
      s = length(f);
      if s, centroids(i,:) = sum(data(f,:)) / s; end
    end

    if iter
      if sum(old_clusters==clusters)==0
	if verbose, fprintf(1, 'Convergence in %d iterations\n', iter); end
	break; 
      end
    end

    old_clusters = clusters;
    iter = iter + 1;
  end
  
  [dummy clusters] = min(((ones(k, 1) * sum((data.^2)', 1))' + ...
			  ones(l, 1) * sum((centroids.^2)',1) - ...
			  2.*(data*(centroids')))');
 otherwise,
  fprintf(2, 'Unknown method\n');
end

err = 0;
for i = 1:k
  f = find(clusters==i);
  s = length(f);
  if s, err = err + sum(sum((data(f,:)-ones(s,1)*centroids(i,:)).^2,2)); end
end

codes = centroids;
return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,bm,qe] = scalar_kmeans(x,k,maxepochs)

    nans = ~isfinite(x);
    x(nans) = []; 
    n = length(x); 
    mi = min(x); ma = max(x)
    y = linspace(mi,ma,k)'; 
    bm = ones(n,1); 
    bmold = zeros(n,1); 
    i = 0; 
    while ~all(bm==bmold) && i<maxepochs, 
        bmold  = bm;  
        [c bm] = histc(x,[-Inf; (y(2:end)+y(1:end-1))/2; Inf]);
        y      = full(sum(sparse(bm,1:n,x,k,n),2));
        zh     = (c(1:end-1)==0);
        y(~zh) = y(~zh)./c(~zh);
        inds   = find(zh)';
        for j=inds, if j==1, y(j) = mi; else y(j) = y(j-1) + eps; end, end         
        i=i+1;
    end
    if i==maxepochs, [c bm] = histc(x,[-Inf; (y(2:end)+y(1:end-1))/2; Inf]); end
    if nargout>2, qe = sum(abs(x-y(bm)))/n; end
    if any(nans),
        notnan = find(~nans); n = length(nans);
        y  = full(sparse(notnan,1,y ,n,1)); y(nans)  = NaN;  
        bm = full(sparse(notnan,1,bm,n,1)); bm(nans) = NaN;
        if nargout>2, qe = full(sparse(notnan,1,qe,n,1)); qe(nans) = NaN; end
    end 
       
    return; 

