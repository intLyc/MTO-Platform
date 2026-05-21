function minima = som_dmatminima(sM,U,Ne)

%SOM_DMATMINIMA Find clusters based on local minima of U-matrix.
%
% minima = som_dmatminima(sM,[U],[Ne])
%
%  Input and output arguments ([]'s are optional):
%   sM         (struct) map struct
%   U          (matrix) the distance matrix from which minima is
%                       searched from 
%                       size msize(1) x ... x msize(end) or 
%                            2*msize(1)-1 x 2*msize(2)-1 or 
%                            munits x 1
%   Ne         (matrix) neighborhood connections matrix
%
%   minima     (vector) indeces of the map units where locla minima of
%                       of U-matrix (or other distance matrix occured)
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
[munits dim] = size(M);

% distances between map units
if nargin<2, U = []; end

% neighborhoods 
if nargin<3, Ne = som_neighbors(sM); end

% distance matrix
if nargin<2 || isempty(U), U = som_dmat(sM,Ne,'median'); end
if numel(U)>munits, U = U(1:2:size(U,1),1:2:size(U,2)); end
U = U(:); 
if length(U) ~= munits, error('Distance matrix has incorrect size.'); end

% find local minima
minima = []; 
for i=1:munits, 
  ne = find(Ne(i,:));
  if all(U(i)<=U(ne)) && ~anycommon(ne,minima), minima(end+1)=i; end
end

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function t = anycommon(i1,i2)
  if isempty(i1) || isempty(i2), t = 0; 
  else 
    m = max(max(i1),max(i2));
    t = any(sparse(i1,1,1,m,1) & sparse(i2,1,1,m,1)); 
  end
  return;   

