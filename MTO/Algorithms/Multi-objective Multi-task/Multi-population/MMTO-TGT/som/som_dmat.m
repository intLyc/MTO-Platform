function dmat = som_dmat(sM,Ne,mode)

%SOM_DMAT Find distance to neighbors for each map unit.
%
% dmat = som_dmat(sM,[Ne],[mode])
%
%  Input and output arguments ([]'s are optional):
%   sM         (struct) map or data struct 
%              (matrix) data matrix, size n x dim
%   [Ne]       (matrix) neighborhood connections matrix 
%              (string) 'Nk' (on map) or 'kNN' (any vector set)
%                       where k = some number, e.g. 'N1' or '10NN'
%              (empty)  use default 
%   [mode]     (string) 'min', 'median', 'mean', 'max', or 
%                       some arbitrary scalar function of 
%                       a set of vectors
%
%   dmat       (vector) size n x 1, distance associated with each vector
%   
% See also KMEANS_CLUSTERS, SOM_CLLINKAGE, SOM_CLSTRUCT.

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on June 16th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 220800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% map 
if isstruct(sM), 
  switch sM.type, 
   case 'som_map',  M = sM.codebook; mask = sM.mask; 
   case 'som_data', M = sM.data; mask = ones(size(M,2),1);
  end
else
  M = sM; mask = ones(size(M,2),1);
end
[n dim] = size(M);

% neighborhoods 
if nargin<2 || isempty(Ne), Ne = som_neighbors(sM); 
elseif ischar(Ne), Ne = som_neighbors(sM,Ne); 
end
l = size(Ne,1); Ne([0:l-1]*l+[1:l]) = 0; % set diagonal elements = 0

% mode
if nargin<3 || isempty(mode), mode = 'median'; end
calc = sprintf('%s(x)',mode); 

% distances
dmat = zeros(n,1); 
for i=1:n, 
  ne = find(Ne(i,:));
  if any(ne), 
    [dummy,x] = som_bmus(M(ne,:),M(i,:),[1:length(ne)],mask); 
    dmat(i) = eval(calc); 
  else 
    dmat(i) = NaN; 
  end
end

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  

