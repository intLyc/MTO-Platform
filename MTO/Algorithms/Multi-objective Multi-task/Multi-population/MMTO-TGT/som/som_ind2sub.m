function Subs = som_ind2sub(msize,inds)

%SOM_IND2SUB Map grid subscripts from linear index.
%
% Subs = som_ind2sub(msize,inds)
%
%  sub = som_ind2sub([10 15],44);
%  sub = som_ind2sub(sMap,44);
%  sub = som_ind2sub(sMap.msize,44);
%  Subs = som_ind2sub([10 15],[44 13 91]');
%
%  Input and output arguments: 
%   msize  (struct) map or topology struct
%          (vector) size 1 x m, specifies the map grid size
%   inds   (vector) size n x 1, linear indeces of n map units
% 
%   Subs   (matrix) size n x m, the subscripts
%
% See also SOM_SUB2IND.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 300798

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(msize), 
  if strcmp(msize.type,'som_map'), msize = msize.topol.msize; 
  elseif strcmp(msize.type,'som_topol'), msize = msize.msize;
  else error('Invalid first argument.'); end
end

n = length(msize); 
k = [1 cumprod(msize(1:end-1))]; 
inds = inds - 1;
for i = n:-1:1, 
  Subs(:,i) = floor(inds/k(i))+1; 
  inds = rem(inds,k(i)); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
