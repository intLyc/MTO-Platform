function Ne1 = som_unit_neighs(topol,lattice,shape)

%SOM_UNIT_NEIGHS Matrix indicating units in 1-neighborhood for each map unit.
%
% Ne1 = som_unit_neighs(topol,[lattice],[shape])
% 
%  Ne1 = som_unit_neighs(sTopol);
%  Ne1 = som_unit_neighs(sMap.topol);
%  Ne1 = som_unit_neighs([10 4], 'hexa', 'cyl');
%  Ne1 = som_unit_neighs(msize, 'rect', 'toroid');
%
%  Input and output arguments ([]'s are optional): 
%   topol              topology of the SOM grid
%             (struct) topology or map struct
%             (vector) the 'msize' field of topology struct
%   [lattice] (string) map lattice, 'rect' by default
%   [shape]   (string) map shape, 'sheet' by default
%
%   Ne1       (matrix, size [munits munits]) a sparse matrix
%                      indicating the map units in 1-neighborhood
%                      by value 1 (note: the unit itself also has value 0)
%
% For more help, try 'type som_unit_neighs' or check out online documentation.
% See also SOM_NEIGHBORHOOD, SOM_UNIT_DISTS, SOM_UNIT_COORDS, SOM_CONNECTION.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_unit_neighs
%
% PURPOSE
%
% Find the adjacent (in 1-neighborhood) units for each map unit of a SOM
% based on given topology.
%
% SYNTAX
%
%  Ne1 = som_unit_neighs(sMap);
%  Ne1 = som_unit_neighs(sM.topol);
%  Ne1 = som_unit_neighs(msize);
%  Ne1 = som_unit_neighs(msize,'hexa');
%  Ne1 = som_unit_neighs(msize,'rect','toroid');
%
% DESCRIPTION
%
% For each map unit, find the units the distance of which from 
% the map unit is equal to 1. The distances are calculated
% along the map grid. Consider, for example, the case of a 4x3 map. 
% The unit ('1' to 'C') positions for 'rect' and 'hexa' lattice (and
% 'sheet' shape) are depicted below: 
% 
%   'rect' lattice           'hexa' lattice
%   --------------           --------------
%      1  5  9                  1  5  9
%      2  6  a                   2  6  a
%      3  7  b                  3  7  b
%      4  8  c                   4  8  c
%
% The units in 1-neighborhood (adjacent units) for unit '6' are '2','5','7'
% and 'a' in the 'rect' case and '5','2','7','9','a' and 'b' in the 'hexa'
% case. The function returns a sparse matrix having value 1 for these units.  
% Notice that not all units have equal number of neighbors. Unit '1' has only 
% units '2' and '5' in its 1-neighborhood. 
% 
% REQUIRED INPUT ARGUMENTS
% 
%  topol          Map grid dimensions.
%        (struct) topology struct or map struct, the topology 
%                 (msize, lattice, shape) of the map is taken from 
%                 the appropriate fields (see e.g. SOM_SET)
%        (vector) the vector which gives the size of the map grid
%                 (msize-field of the topology struct).
%  
% OPTIONAL INPUT ARGUMENTS 
% 
%  lattice (string) The map lattice, either 'rect' or 'hexa'. Default
%                   is 'rect'. 'hexa' can only be used with 1- or 
%                   2-dimensional map grids.
%  shape   (string) The map shape, either 'sheet', 'cyl' or 'toroid'. 
%                   Default is 'sheet'. 
%
% OUTPUT ARGUMENTS
%
%  Ne1   (matrix) sparse matrix indicating units in 1-neighborhood
%                 by 1, all others have value 0 (including the unit itself!),
%                 size is [munits munits]
%
% EXAMPLES
%
% Simplest case:
%  Ne1 = som_unit_neighs(sTopol);
%  Ne1 = som_unit_neighs(sMap.topol);
%  Ne1 = som_unit_neighs(msize);
%  Ne1 = som_unit_neighs([10 10]);
%
% If topology is given as vector, lattice is 'rect' and shape is 'sheet'
% by default. To change these, you can use the optional arguments:
%  Ne1 = som_unit_neighs(msize, 'hexa', 'toroid');
%
% The neighbors can also be calculated for high-dimensional grids:
%  Ne1 = som_unit_neighs([4 4 4 4 4 4]);
%
% SEE ALSO
% 
%  som_neighborhood  Calculate N-neighborhoods of map units.
%  som_unit_coords   Calculate grid coordinates.
%  som_unit_dists    Calculate interunit distances.
%  som_connection    Connection matrix.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 141097
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check arguments 

error(nargchk(1, 3, nargin));

% default values
sTopol = som_set('som_topol','lattice','rect');

% topol
if isstruct(topol), 
  switch topol.type, 
  case 'som_map', sTopol = topol.topol;
  case 'som_topol', sTopol = topol;
  end
elseif iscell(topol), 
  for i=1:length(topol), 
    if isnumeric(topol{i}), sTopol.msize = topol{i}; 
    elseif ischar(topol{i}),  
      switch topol{i}, 
      case {'rect','hexa'}, sTopol.lattice = topol{i}; 
      case {'sheet','cyl','toroid'}, sTopol.shape = topol{i}; 
      end
    end
  end
else
  sTopol.msize = topol;
end
if prod(sTopol.msize)==0, error('Map size is 0.'); end

% lattice
if nargin>1 && ~isempty(lattice) && ~isnan(lattice), sTopol.lattice = lattice; end

% shape 
if nargin>2 && ~isempty(shape) && ~isnan(shape), sTopol.shape = shape; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

% distances between each map unit
Ud = som_unit_dists(sTopol);

% 1-neighborhood are those units the distance of which is equal to 1
munits = prod(sTopol.msize);
Ne1 = sparse(zeros(munits));
for i=1:munits, 
  inds = find(Ud(i,:)<1.01 & Ud(i,:)>0); % allow for rounding error
  Ne1(i,inds) = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
