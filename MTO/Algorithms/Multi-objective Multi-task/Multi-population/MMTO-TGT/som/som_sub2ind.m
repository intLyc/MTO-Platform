function inds = som_sub2ind(msize,Subs)

%SOM_SUB2IND Linear index from map grid subscripts.
%
% ind = som_sub2ind(msize,Subs)
%
%  ind = som_sub2ind([10 15],[4 5]);
%  ind = som_sub2ind(sMap,[4 5]);
%  ind = som_sub2ind(sMap.msize,[4 5]);
%  inds = som_sub2ind([10 15],[4 5; 3 2; 1 10]);
%
%  Input and output arguments: 
%   msize  (struct) map or topology struct
%          (vector) size 1 x m, specifies the map grid size
%   Subs   (matrix) size n x m, the subscripts of n vectors
%
%   inds   (vector) size n x 1, corresponding linear indeces
%
% See also SOM_IND2SUB.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% juuso 300798

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(msize), 
  if strcmp(msize.type,'som_map'), msize = msize.topol.msize; 
  elseif strcmp(msize.type,'som_topol'), msize = msize.msize;
  else error('Invalid first argument.'); end
end

% check off-limits
[n d] = size(Subs);
offl = find(Subs < 1 | Subs > msize(ones(n,1),1:d)); 
Subs(offl) = NaN;

% indexes
k = [1 cumprod(msize(1:end-1))]';
inds = 1 + (Subs-1)*k;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
