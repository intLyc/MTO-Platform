function [V,I]=som_divide(sMap, D, inds, mode)

%SOM_DIVIDE Divides a dataset according to a given map.
%
% [V,I]=som_divide(sMap, sData, [inds], [mode])
%
% ARGUMENTS ([]'s are optional) 
%
%  sMap     (struct or matrix) map struct or codebook (size munits x dim)
%  sData    (struct or matrix) data struct or matrix (size N x dim )
%  [inds]            From which map units should the local data sets
%                    be constructed. Interpretation depends on mode
%                    argument. By default [1:munits].
%           'class': (vector) munits x 1 matrix of class numbers
%           'index': (vector) K x 1 vector of map node indexes 
%           'index': (matrix) K x k matrix of map node subscripts
%  [mode]   (string) 'index' or 'class', if inds is a vector of length 
%                    munits, default is 'class', otherwise 'index'.
% RETURNS
%  
% If mode == 'index' 
%  V        (matrix) data vectors hitting the specified nodes (size K x dim)                   
%  I        (vector) corresponding data row indexes (size K x 1)
%   
% If mode == 'class' (this can be used after using som_select)
%  V        (cell array) V{K} includes vectors whose BMU has class number 
%                        K in the input matrix 'coord'. Note that 
%                        values of K below 1 are ignored. 
%  I        (cell array) corresponding data indexes in the cell array                        
%
% NOTE: if the same node is specified multiple times, only one
%       set of hits is returned.
%
% See also SOM_BMU, SOM_HITS, SOM_SELECT.

% Version 1.0beta 260997 Johan 
% Version 2.0beta 230300 juuso

% Contributed to SOM Toolbox vs2, Mar 23rd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

%%%% Init & Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

error(nargchk(0, 4, nargin)) % check if no. of input args is correct

% map
if isstruct(sMap), 
  msize = sMap.topol.msize;     
  dim = size(sMap.codebook,2); 
else
  msize = [size(sMap,1) 1];
  dim = size(sMap,2); 
end
munits = prod(msize);

% data
if isstruct(D), D=D.data; end

% inds
if nargin<3, inds = 1:munits; end
isvec = numel(inds)==length(inds);

% mode
if nargin<4, 
  if isvec && length(inds)==munits, 
    mode = 'class'; 
  else
    mode = 'index'; 
  end
end

%%% Action & Build output according to the mode string output

if ~isvec, inds = som_sub2ind(msize,inds); end

bmus=som_bmus(sMap,D); 

switch mode
 case 'index'
  I=find(ismember(bmus,inds));         
  V=D(I,:);
 case 'class'   
  K=max(inds); % classes  
  V = cell(K,1); 
  I = cell(K,1);
  for i=1:K,
    N_ind=find(inds == i);           % indexes of the units of class i
    I{i}=find(ismember(bmus,N_ind)); % data indexes       
    V{i}=D(I{i},:);
  end
end





