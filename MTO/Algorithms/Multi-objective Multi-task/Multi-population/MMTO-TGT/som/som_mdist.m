function Md = som_mdist(D,q,mask,Ne)

% SOM_MDIST Mutual (or pairwise) distance matrix for the given data.
% 
%   Md = som_mdist(D,[q],[mask],[Ne])
%
%    Md = som_mdist(D); 
%    Md = som_mdist(D,Inf); 
%    Md = som_mdist(D,2,Ne); 
%
%  Input and output arguments ([]'s are optional):
%   D        (matrix) size dlen x dim, the data set
%            (struct) map or data struct
%   [q]      (scalar) distance norm, default = 2
%   [mask]   (vector) size dim x 1, the weighting mask
%   [Ne]     (matrix) size dlen x dlen, sparse matrix 
%                     indicating which distances should be 
%                     calculated (ie. less than Infinite) 
%
% See also PDIST. 

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 220800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mask
if nargin<3, mask = []; end

% the data
if isstruct(D), 
  switch D.type, 
   case 'som_map', if isempty(mask), mask = D.mask; end, D = D.codebook; 
   case 'som_data', D = D.data; 
   otherwise, error('Bad first argument');
  end
end
nans = sum(isnan(D),2);
if any(nans>0), 
  D(find(nans>0),:) = 0; 
  warning('Distances of vectors with NaNs are not calculated.'); 
end
[dlen dim] = size(D);

% distance norm
if nargin<2 || isempty(q) || isnan(q), q = 2; end

% mask
if isempty(mask), mask = ones(dim,1); end

% connections 
if nargin<4, Ne = []; end
if ~isempty(Ne), 
  l = size(Ne,1); Ne([0:l-1]*l+[1:l]) = 1; % set diagonal elements = 1
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = mask; 
o = ones(dlen,1); 
l = dlen; 
Md = zeros(dlen);
calculate_all = isempty(Ne); 

if ~calculate_all, Md(Ne==0) = Inf; end

for i=1:l-1,
  j=(i+1):l; 
  if ~calculate_all, j=find(Ne(i,j))+i; end
  C=D(j,:)-D(i*o(1:length(j)),:);
  switch q, 
   case 1,    Md(j,i)=abs(C)*m;
   case 2,    Md(j,i)=sqrt((C.^2)*m);  
   case Inf,  Md(j,i)=max(diag(m)*abs(C),[],2);
   otherwise, Md(j,i)=((abs(C).^q)*m).^(1/q);
  end   
  Md(i,j) = Md(j,i)';
end

Md(find(nans>0),:) = NaN; 
Md(:,find(nans>0)) = NaN; 

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

