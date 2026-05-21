function base = som_clspread(sM,base,cldist,Ne,verbosity)

% SOM_CLSPREAD Partition the given data by flooding.
%
%  part = som_clspread(sM,part,cldist,[Ne],[verbos])
%
%  Input and output arguments ([]'s are optional):
%   sM       (struct) map or data struct
%            (matrix) size dlen x dim, the data set            
%   base     (vector) initial partition, where if base(i) is
%                      0         i should be assigned to some cluster
%                      NaN       i should not be assigned to any cluster
%                      otherwise i belongs to cluster base(i)
%   cldist   (string) cluster distance measure: 'single', 'average',
%                     'complete', 'neighf', 'ward', 'centroid', 'BMU'  
%   [Ne]     (scalar) 0 = not constrined to neighborhood
%                     1 = constrained   
%            (matrix) size dlen x dlen, indicating possible connections
%   [verbos] (scalar) 1 (default) = show status bar
%                     0  = don't
%
% See also SOM_CLDIST. 

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 220800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

q = 2; 

% map/data
if isstruct(sM), 
  switch sM.type, 
   case 'som_map',  M = sM.codebook; mask = sM.mask; sT = sM.topol; 
   case 'som_data', M = sM.data; mask = []; sT = []; 
  end
else M = sM; mask = []; sT = []; 
end
[dlen dim] = size(M); 
if isempty(mask), mask = ones(dim,1); end

% simple option
if any(strcmp(cldist,{'closest','BMU'})), 
  i0 = find(base==0);
  i1 = find(base>0);
  bmus = som_bmus(M(i1,:),M(i0,:));
  base(i0) = base(i1(bmus));
  return; 
end

% constrained clustering
if nargin<4, Ne = []; end
if numel(Ne)==1,  
  if Ne && isempty(sT),
    warning('Cannot use constrained clustering.'); Ne = 0; 
  end
  if Ne, Ne = som_unit_neighs(sT); else Ne = []; end
end
if ~isempty(Ne), 
  Ne([0:dlen-1]*dlen+[1:dlen]) = 1; % set diagonal elements = 1
  if all(Ne(:)>0), Ne = []; end
end

if nargin<5, verbosity = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize

if size(base,1)==1, base = base'; end

cid = unique(base(isfinite(base) & base~=0)); % cluster IDs
nc = length(cid);    
uind = find(base==0); % unclustered points
nu = length(uind); 
if nu==0, return; end

% initial clusters
clinds = cell(nc,1); for i=1:nc, clinds{i} = find(base==i); end
clinds2 = cell(nu,1); for i=1:nu, clinds2{i} = uind(i); end

% neighborhood function values
if strcmp(cldist,'neighf')   
  if isempty(sT), error('Cannot use neighf linkage.'); end
  q = som_unit_dists(sT).^2; 
  r = sM.trainhist(end).radius_fin^2; 
  if isnan(r) || isempty(r), r = 1; end 
  switch sM.neigh,
   case 'bubble',   q = (q <= r);
   case 'gaussian', q = exp(-q/(2*r));
   case 'cutgauss', q = exp(-q/(2*r)) .* (q <= r);
   case 'ep',       q = (1-q/r) .* (q <= r);
  end
end

% distance of each cluster to the unclustered points
if any(strcmp(cldist,{'single','average','complete','neighf'})), 
  M = som_mdist(M,2,mask,Ne); 
end 
Cd = som_cldist(M,clinds,clinds2,cldist,q,mask); 
			      
% check out from Ne which of the clusters are not connected
if ~isempty(Ne) && any(strcmp(cldist,{'centroid','ward'})),
  Clconn = sparse(nc,nu);   
  for i=1:nc, for j=1:nu, Clconn(i,j) = any(any(Ne(clinds{i},uind(j)))); end, end
  Cd(Clconn==0) = Inf; 
else
  Clconn = []; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

if verbosity,
  nu0 = nu; 
  h = waitbar(1-nu/nu0,'Assigning unclustered points'); % tracking
end

while 1, 

  % find closest unclustered point
  [dk,k] = min(Cd,[],2);  % min distance from each unclustered point
  [d,c]  = min(dk);       % cluster to which it is assigned  
  k = k(c); 

  if ~isfinite(d), 
    break; 
  end

  % add k to cluster c
  base(uind(k)) = cid(c);   
  clinds{c} = [clinds{c}; uind(k)];
  
  % remove point k
  notk = [1:k-1,k+1:nu]; 
  nu = nu-1; if nu<=0, break; end  
  Cd = Cd(:,notk); 
  uind = uind(notk); 
  clinds2 = clinds2(notk); 
  if ~isempty(Clconn), Clconn = Clconn(:,notk); end

  % update cluster distances to c
  Cd(c,:) = som_cldist(M,clinds(c),clinds2,cldist,q,mask); 
  if ~isempty(Clconn), 
    for j=1:nu, Clconn(c,j) = any(any(Ne(clinds{c},uind(j)))); end
    Cd(c,find(Clconn(c,:)==0)) = Inf; 
  end
  
  if verbosity, waitbar(1-nu/nu0,h); end % tracking

end
if verbosity, close(h); end

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


