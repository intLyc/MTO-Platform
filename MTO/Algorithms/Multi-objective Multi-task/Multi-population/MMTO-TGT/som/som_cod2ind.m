function ind = som_cod2ind(msize,cind)

%SOM_COD2IND Matlab linear index from SOM_PAK style linear indeces.
%
% ind = som_cod2ind(msize,cind)
%
%  ind = som_cod2ind([10 15],44);
%  ind = som_cod2ind(sMap,44);
%  ind = som_cod2ind(sMap.msize,44);
%  ind = som_cod2ind([10 15],[44 13 91]');
%
%  Input and output arguments: 
%   msize  (struct) map or topology struct
%          (vector) size 1 x m, specifies the map grid size
%   cind   (vector) size n x 1, SOM_PAK style linear indeces for n map units
%                   (row first, then column)
% 
%   ind    (vector) size n x 1, Matlab linear indeces
%
% See also SOM_IND2COD.

% Contributed to SOM Toolbox vs2, January 14th, 2002 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 140102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(msize), 
  if strcmp(msize.type,'som_map'), msize = msize.topol.msize; 
  elseif strcmp(msize.type,'som_topol'), msize = msize.msize;
  else error('Invalid first argument.'); end
end

if nargin<2, cind = 1:prod(msize); end

I2C = som_ind2cod(msize,[1:prod(msize)]); 
[~,C2I] = sort(I2C); 
ind = C2I(cind); 

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
