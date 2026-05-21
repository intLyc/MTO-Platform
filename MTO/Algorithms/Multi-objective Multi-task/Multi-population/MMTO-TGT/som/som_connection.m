function C=som_connection(S)

%SOM_CONNECTION Connection matrix for 'hexa' and 'rect' lattices
%
% C=som_connection(S)
%
%  C=som_connection(sMap);
%  C=som_connection(sTopol);
%  C=som_connection({'hexa', [6 5], 'sheet'});
%
% Input and output arguments:
%  S    (struct) map or topol struct
%       (cell array) a cell array of form {lattice, msize, shape}, where
%                lattice: 'hexa' or 'rect'
%                msize  : 1x2 vector
%                shape  : 'sheet', 'cyl or 'toroid' 
%
%  C    (sparse) An NxN connection matrix, N=prod(msize)
%
% The function returns a connection matrix, e.g., for drawing
% connections between map units in the function som_grid. Note that
% the connections are defined only in the upper triangular part to
% save some memory!! Function SOM_UNIT_NEIGHS does the same thing, 
% but also has values in the lower triangular. It is also slower.
%
% For more help, try 'type som_connection' or check out online documentation.
% See also SOM_GRID, SOM_UNIT_NEIGHS.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_connection
%
% PURPOSE
% 
%  To create a connection matrix of SOM 'hexa' and 'rect' negihborhoods
%
% SYNTAX
%
%  C = som_connection(S)
%
% DESCRIPTION
%
%  Creates a connection matrix of SOM 'hexa' and 'rect'
%  neighborhoods. The connections are defined only in the upper
%  triangular part to save some memory.
%  
%  Function SOM_UNIT_NEIGHS does the same thing, but also has values
%  in the lower triangular. It is also slower, except for 
%  'toroid' shape because in that case this function calls 
%  SOM_UNIT_NEIGHS...
%
% REQUIRED INPUT ARGUMENTS
%  
%  S                 map topology 
%    (map struct)    S.topol is used to build the matrix
%    (topol struct)  topology information is used to build the matrix
%    (cell array)    of form {lattice, msize, shape}, where
%                     lattice: 'hexa' or 'rect'
%                     msize  : 1x2 vector
%                     shape  : 'sheet', 'cyl or 'toroid' 
%
% OUTPUT ARGUMENTS
%
%  C (sparse)        munits x munits sparse matrix which describes 
%                    nearest neighbor connections between units
%
% EXAMPLE 
%
% C = som_connection('hexa',[3 4],'sheet');
% full(C)
% ans =
%
%      0     1     0     1     0     0     0     0     0     0     0     0
%      0     0     1     1     1     1     0     0     0     0     0     0
%      0     0     0     0     0     1     0     0     0     0     0     0
%      0     0     0     0     1     0     1     0     0     0     0     0
%      0     0     0     0     0     1     1     1     1     0     0     0
%      0     0     0     0     0     0     0     0     1     0     0     0
%      0     0     0     0     0     0     0     1     0     1     0     0
%      0     0     0     0     0     0     0     0     1     1     1     1
%      0     0     0     0     0     0     0     0     0     0     0     1
%      0     0     0     0     0     0     0     0     0     0     1     0
%      0     0     0     0     0     0     0     0     0     0     0     1
%      0     0     0     0     0     0     0     0     0     0     0     0
%
% SEE ALSO
% 
% som_grid         Visualization of a SOM grid
% som_unit_neighs  Units in 1-neighborhood for all map units.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0alpha Johan 061099 juuso 151199 170400

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check arguments

error(nargchk(1, 1, nargin));   % check number of input arguments

[tmp,ok,tmp]=som_set(S);
if isstruct(S) && all(ok),       % check m type
  switch S.type
  case 'som_topol' 
    msize=S.msize;
    lattice=S.lattice;
    shape=S.shape;
  case 'som_map'  
    msize=S.topol.msize;
    lattice=S.topol.lattice;
    shape=S.topol.shape;
  otherwise
    error('Invalid map or topol struct.');
  end
elseif iscell(S),
  if vis_valuetype(S,{'topol_cell'}),
    lattice=S{1};
    msize=S{2}; 
    shape=S{3}; 
  else
    error('{lattice, msize, shape} expected for cell input.')
  end
else
  error('{lattice, msize, shape}, or map or topol struct expected.')
end

if ~vis_valuetype(msize,{'1x2'})
  error('Invalid map size: only 2D maps allowed.')
end  

%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=msize(1)*msize(2);

%% Action & Build output arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lattice
case 'hexa'
  l1=ones(N,1); l1((msize(1)+1):msize(1):end)=0;
  l2=zeros(msize(1),1); l3=l2;
  l2(1:2:end-1)=1; l3(3:2:end)=1;
  l2=repmat(l2,msize(2),1); 
  l3=repmat(l3,msize(2),1);
  C= ...
    spdiags([l1 l2 ones(N,1) l3], [1 msize(1)-1:msize(1)+1],N,N);
case 'rect'
  l1=ones(N,1);l1((msize(1)+1):msize(1):end)=0;
  C=spdiags([l1 ones(N,1)],[1 msize(1)],N,N);
otherwise
  error('Unknown lattice.')
end

switch shape
case 'sheet'
case 'cyl'
  C=spdiags(ones(N,1),msize(1)*(msize(2)-1),C);
case 'toroid'
  %warning('Toroid not yet implemented: using ''cyl''.');
  %C=spdiags(ones(N,1),msize(1)*(msize(2)-1),C);
  %l=zeros(N,1); l(1:msize(2):end)=1;
  %C=spdiags(l,msize(1),C);

  % use som_unit_neighs to calculate these
  C = som_unit_neighs(msize,lattice,'toroid');
  % to be consistent, set the lower triangular values to zero
  munits = prod(msize);
  for i=1:(munits-1), C((i+1):munits,i) = 0; end
otherwise
  error('Unknown shape.');
end


