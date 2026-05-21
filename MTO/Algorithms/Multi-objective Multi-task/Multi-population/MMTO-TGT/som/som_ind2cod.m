function cind = som_ind2cod(msize,ind)

%SOM_IND2COD SOM_PAK style linear indeces from Matlab linear index.
%
% Cind = som_ind2cod(msize,inds)
%
%  cind = som_ind2cod([10 15],44);
%  cind = som_ind2cod(sMap,44);
%  cind = som_ind2cod(sMap.msize,44);
%  Cind = som_ind2cod([10 15],[44 13 91]');
%
%  Input and output arguments: 
%   msize  (struct) map or topology struct
%          (vector) size 1 x m, specifies the map grid size
%   ind    (vector) size n x 1, linear indeces of n map units
% 
%   cind   (matrix) size n x 1, SOM_PAK style linear indeces
%                   (row first, then column)
%
% See also SOM_COD2IND.

% Contributed to SOM Toolbox vs2, January 14th, 2002 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 140102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(msize), 
  if strcmp(msize.type,'som_map'), msize = msize.topol.msize; 
  elseif strcmp(msize.type,'som_topol'), msize = msize.msize;
  else error('Invalid first argument.'); end
end

if nargin<2, ind = 1:prod(msize); end

Co = som_unit_coords(msize,'rect','sheet');

switch size(Co,2),
case 1, I2C = [1:prod(msize)]; 
case 2, I2C = 1 + Co(:,1) + Co(:,2)*msize(2); 
case 3, I2C = 1 + Co(:,1) + Co(:,2)*msize(2) + Co(:,3)*msize(1)*msize(2); % ?????
end

cind = I2C(ind); 
return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
