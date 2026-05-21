function sC = som_cllinkage(sM,varargin)

%SOM_CLLINKAGE Make a hierarchical linkage of the SOM map units.
%
% sC = som_cllinkage(sM, [[argID,] value, ...])
%  
%  sC = som_cllinkage(sM);
%  sC = som_cllinkage(D,'complete');
%  sC = som_cllinkage(sM,'single','ignore',find(~som_hits(sM,D)));
%  sC = som_cllinkage(sM,pdist(sM.codebook,'mahal'));
%  som_clplot(sC); 
%
%  Input and output arguments ([]'s are optional):
%   sM       (struct) map or data struct to be clustered
%            (matrix) size dlen x dim, a data set: the matrix must not
%                     contain any NaN's!
%   [argID,  (string) See below. The values which are unambiguous can 
%    value]  (varies) be given without the preceeding argID.
%
%   sC       (struct) a clustering struct with e.g. the following fields
%                     (for more information see SOMCL_STRUCT)
%     .base  (vector) if base partitioning is given, this is a newly 
%                     coded version of it so that the cluster indices
%                     go from 1 to the number of clusters. 
%     .tree  (matrix) size clen-1 x 3, the linkage info
%                     Z(i,1) and Z(i,2) hold the indeces of clusters 
%                     combined on level i (starting from bottom). The new
%                     cluster has index dlen+i. The initial cluster 
%                     index of each unit is its linear index in the 
%                     original data matrix. Z(i,3) is the distance
%                     between the combined clusters. See LINKAGE
%                     function in the Statistics Toolbox.
%     
% Here are the valid argument IDs and corresponding values. The values 
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%   'topol'   *(struct) topology struct
%   'connect' *(string) 'neighbors' or 'any' (default), whether the
%                       connections should be allowed only between 
%                       neighbors or between any vectors
%              (matrix) size dlen x dlen indicating the connections
%                       between vectors
%   'linkage' *(string) the linkage criteria to use: 'single' (the
%                       default), 'average', 'complete', 'centroid', or 'ward' 
%   'dist'     (matrix) size dlen x dlen, pairwise distance matrix to 
%                       be used instead of euclidian distances
%              (vector) as the output of PDIST function
%              (scalar) distance norm to use (default is euclidian = 2)
%   'mask'     (vector) size dim x 1, the search mask used to 
%                       weight distance calculation. By default 
%                       sM.mask or a vector of ones is used.
%   'base'     (vector) giving the base partitioning of the data: 
%                       base(i) = j denotes that vector i belongs to
%                       base cluster j, and base(i) = NaN that vector
%                       i does not belong to any cluster, but should be
%                       ignored. At the beginning of the clustering, the 
%                       vector of each cluster are averaged, and these
%                       averaged vectors are then clustered using 
%                       hierarchical clustering.
%   'ignore'   (vector) units to be ignored (in addition to those listed
%                       in base argument)
%   'tracking' (scalar) 1 or 0: whether to show tracking bar or not (default = 0)
%
% Note that if 'connect'='neighbors' and some vector are ignored (as denoted
% by NaNs in the base vector), there may be areas on the map which will
% never be connected: connections across the ignored map units simply do not
% exist. In such a case, the neighborhood is gradually increased until 
% the areas can be connected.
%
% See also KMEANS_CLUSTERS, LINKAGE, PDIST, DENDROGRAM. 

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 160600 250800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

% the data
if isstruct(sM), 
  switch sM.type, 
   case 'som_map', M = sM.codebook; sT = sM.topol; mask = sM.mask; data_name = sM.name; sTr = sM.trainhist(end); 
   case 'som_data', M = sM.data; sT = []; mask = []; data_name = sM.name; sTr = [];
   case 'som_topol', M = []; sT = sM; mask = []; data_name = inputname(1); 
                     sTr = som_set('som_train','neigh','gaussian','radius_fin',1);
   otherwise, error('Bad first argument');
  end
else M = sM; sT = []; mask = []; data_name = inputname(1); sTr = []; 
end
[dlen dim] = size(M);
if isempty(mask), mask = ones(dim,1); end
if any(isnan(M(:))), error('Data matrix must not have any NaNs.'); end

% varargin
q = 2; 
Md = []; 
linkage = 'single';
ignore = []; 
Ne = 'any';
base = []; 
tracking = 0; 
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
      % argument IDs
     case {'topol','som_topol','sTopol'}, i=i+1; sT = varargin{i};
     case 'connect', i=i+1; Ne = varargin{i};
     case 'ignore',  i=i+1; ignore = varargin{i}; 
     case 'dist',    i=i+1; Md = varargin{i};
     case 'linkage', i=i+1; linkage = varargin{i};
     case 'mask',    i=i+1; mask = varargin{i};
     case 'tracking',i=i+1; tracking = varargin{i}; 
     case 'base',    i=i+1; base = varargin{i};
      % unambiguous values
     case 'neighbors', Ne = varargin{i};
     case 'any',       Ne = varargin{i};
     case {'single','average','complete','neighf','centroid','ward'}, linkage = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
     case 'som_topol', sT = varargin{i}; 
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, disp(['(som_cllinkage) Ignoring invalid argument #' num2str(i+1)]); end
  i = i+1; 
end

% check distance metric
if numel(Md)==1, q = Md; Md = []; end
if ~isempty(Md) && numel(Md)<dlen^2, Md = squareform(Md); end    
if numel(Md)>0 && any(strcmp(linkage,{'ward','centroid'})),
  warning(['The linkage method ' linkage ' cannot be performed with precalculated distance matrix.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% distance matrix and connections between units

% base partition 
if isempty(base), base = 1:dlen; end
if ~isempty(ignore), base(ignore) = NaN; end
cid = unique(base(isfinite(base))); 
nc = length(cid); 
if max(cid)>nc || min(cid)<1, 
  b = base; for i=1:nc, base(find(b==cid(i))) = i; end
end

% initial clusters
clinds = cell(nc,1); 
for i=1:nc, clinds{i} = find(base==i); end

% neighborhood constraint (calculate connection matrix Ne)
if ischar(Ne),
  switch Ne, 
   case 'any', Ne = []; 
   case 'neighbors', if ischar(Ne), Ne = som_unit_neighs(sT); end  
   otherwise, error(['Unrecognized connection mode ' Ne]);
  end
end
if ~isempty(Ne), l = size(Ne,1); Ne([0:l-1]*l+[1:l]) = 1; end % diagonal=1
if all(Ne(:)>0), Ne = []; end

% neighborhood function values
if strcmp(linkage,'neighf') 
  if isempty(sTr), error('Cannot use neighf linkage.'); end
  q = som_unit_dists(sT).^2; 
  r = sTr.radius_fin^2; 
  if isnan(r) || isempty(r), r = 1; end 
  switch sTr.neigh,
   case 'bubble',   q = (q <= r);
   case 'gaussian', q = exp(-q/(2*r));
   case 'cutgauss', q = exp(-q/(2*r)) .* (q <= r);
   case 'ep',       q = (1-q/r) .* (q <= r);
  end
end

% mutual distances and initial cluster distances
Cd = []; 
if any(strcmp(linkage,{'single','average','complete','neighf'})), 
  M = som_mdist(M,2,mask,Ne); 
  if (nc == dlen && all(base==[1:dlen])), Cd = M; end
end 
if isempty(Cd), Cd = som_cldist(M,clinds,[],linkage,q,mask); end
Cd([0:nc-1]*nc+[1:nc]) = NaN; % NaNs on the diagonal
			      
% check out from Ne which of the clusters are not connected
if ~isempty(Ne) && any(strcmp(linkage,{'centroid','ward'})),
  Clconn = sparse(nc); 
  for i=1:nc-1, 
    for j=i+1:nc, Clconn(i,j) = any(any(Ne(clinds{i},clinds{j}))); end
    Clconn(i+1:nc,i) = Clconn(i,i+1:nc)'; 
  end
  Cd(Clconn==0) = Inf; 
else
  Clconn = []; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% construct dendrogram

clen = nc; 
cid = 1:clen; 
Z = zeros(nc-1,3)+NaN;     % merged clusters and distance for each step
if tracking, h = waitbar(0,'Making hierarchical clustering'); end

for i=1:clen-1,
  if tracking, waitbar(i/clen,h); end
  
  % find two closest clusters and combine them
  [d,c1] = min(min(Cd));          % cluster1
  [d,c2] = min(Cd(:,c1));         % cluster2
  i1 = clinds{c1};                % vectors belonging to c1
  i2 = clinds{c2};                % vectors belonging to c2
  clinds{c1} = [i1; i2];          % insert clusters to c1 
  Z(i,:) = [cid(c1), cid(c2), d]; % update tree info   
  
  % remove cluster c2
  notc2 = [1:c2-1,c2+1:nc]; 
  nc = nc-1; if nc<=1, break; end
  if c1>c2, c1=c1-1; end 
  clinds = clinds(notc2); 
  Cd = Cd(notc2,notc2);
  cid = cid(notc2);
  if ~isempty(Clconn), Clconn = Clconn(notc2,notc2); end
  
  % update cluster distances
  notc1 = [1:c1-1,c1+1:nc];   
  Cd(c1,notc1) = som_cldist(M,clinds(c1),clinds(notc1),linkage,q,mask); 
  Cd(notc1,c1) = Cd(c1,notc1)'; 
  if ~isempty(Clconn), 
    for j=notc1, Clconn(c1,j) = any(any(Ne(clinds{c1},clinds{j}))); end
    Clconn(notc1,c1) = Clconn(c1,notc1)'; 
    Cd(Clconn==0) = Inf; 
  end
  
end

if tracking, close(h); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% return values

% to maintain compatibility with Statistics Toolbox, the values in 
% Z must be yet transformed so that they are similar to the output
% of LINKAGE function

clen = size(Z,1)+1; 
Zs = Z;
current_cluster = 1:clen;
for i=1:size(Z,1),
  Zs(i,1) = current_cluster(Z(i,1));
  Zs(i,2) = current_cluster(Z(i,2));
  current_cluster(Z(i,[1 2])) = clen+i;  
end
Z = Zs;

% make a clustering struct
name = sprintf('Clustering of %s at %s',data_name,datestr(datenum(now),0)); 
sC = som_clstruct(Z,'base',base,'name',name); 

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

