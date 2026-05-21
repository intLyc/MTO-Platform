function Coords = som_unit_coords(topol,lattice,shape)

%SOM_UNIT_COORDS Locations of units on the SOM grid. 
%
% Co = som_unit_coords(topol, [lattice], [shape])
% 
%  Co = som_unit_coords(sMap);
%  Co = som_unit_coords(sMap.topol);
%  Co = som_unit_coords(msize, 'hexa', 'cyl');
%  Co = som_unit_coords([10 4 4], 'rect', 'toroid');
%
%  Input and output arguments ([]'s are optional): 
%   topol              topology of the SOM grid
%             (struct) topology or map struct
%             (vector) the 'msize' field of topology struct
%   [lattice] (string) map lattice, 'rect' by default
%   [shape]   (string) map shape, 'sheet' by default
%
%   Co        (matrix, size [munits k]) coordinates for each map unit    
%
% For more help, try 'type som_unit_coords' or check out online documentation.
% See also SOM_UNIT_DISTS, SOM_UNIT_NEIGHS.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_unit_coords
%
% PURPOSE
%
% Returns map grid coordinates for the units of a Self-Organizing Map.
%
% SYNTAX
%
%  Co = som_unit_coords(sTopol);
%  Co = som_unit_coords(sM.topol);
%  Co = som_unit_coords(msize);
%  Co = som_unit_coords(msize,'hexa');
%  Co = som_unit_coords(msize,'rect','toroid');
%
% DESCRIPTION
%
% Calculates the map grid coordinates of the units of a SOM based on 
% the given topology. The coordinates are such that they can be used to
% position map units in space. In case of 'sheet' shape they can be 
% (and are) used to measure interunit distances. 
%
% NOTE: for 'hexa' lattice, the x-coordinates of every other row are shifted 
% by +0.5, and the y-coordinates are multiplied by sqrt(0.75). This is done 
% to make distances of a unit to all its six neighbors equal. It is not 
% possible to use 'hexa' lattice with higher than 2-dimensional map grids.
%
% 'cyl' and 'toroid' shapes: the coordinates are initially determined as 
% in case of 'sheet' shape, but are then bended around the x- or the 
% x- and then y-axes to get the desired shape. 
% 
% POSSIBLE BUGS
%
% I don't know if the bending operation works ok for high-dimensional
% map grids. Anyway, if anyone wants to make a 4-dimensional
% toroid map, (s)he deserves it.
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
%  Co   (matrix) coordinates for each map units, size is [munits k] 
%                where k is 2, or more if the map grid is higher
%                dimensional or the shape is 'cyl' or 'toroid'
%
% EXAMPLES
%
% Simplest case:
%  Co = som_unit_coords(sTopol);
%  Co = som_unit_coords(sMap.topol);
%  Co = som_unit_coords(msize);
%  Co = som_unit_coords([10 10]);
%
% If topology is given as vector, lattice is 'rect' and shape is 'sheet'
% by default. To change these, you can use the optional arguments:
%  Co = som_unit_coords(msize, 'hexa', 'toroid');
%
% The coordinates can also be calculated for high-dimensional grids:
%  Co = som_unit_coords([4 4 4 4 4 4]);
%
% SEE ALSO
% 
%  som_unit_dists    Calculate interunit distance along the map grid.
%  som_unit_neighs   Calculate neighborhoods of map units.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 110997
% Version 2.0beta juuso 101199 070600

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
if nargin>1 && ~isempty(lattice) && any(~isnan(lattice)), sTopol.lattice = lattice; end

% shape 
if nargin>2 && ~isempty(shape) && any(~isnan(shape)), sTopol.shape = shape; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

msize = sTopol.msize;
lattice = sTopol.lattice;
shape = sTopol.shape;

% init variables

if length(msize)==1, msize = [msize 1]; end
munits = prod(msize);
mdim = length(msize);
Coords = zeros(munits,mdim);

% initial coordinates for each map unit ('rect' lattice, 'sheet' shape)
k = [1 cumprod(msize(1:end-1))]; 
inds = [0:(munits-1)]';
for i = mdim:-1:1, 
  Coords(:,i) = floor(inds/k(i)); % these are subscripts in matrix-notation
  inds = rem(inds,k(i)); 
end
% change subscripts to coordinates (move from (ij)-notation to (xy)-notation)
Coords(:,[1 2]) = fliplr(Coords(:,[1 2])); 

% 'hexa' lattice
if strcmp(lattice,'hexa'), 
  % check
  if mdim > 2, 
    error('You can only use hexa lattice with 1- or 2-dimensional maps.');
  end
  % offset x-coordinates of every other row 
  inds_for_row = (cumsum(ones(msize(2),1))-1)*msize(1); 
  for i=2:2:msize(1), 
    Coords(i+inds_for_row,1) = Coords(i+inds_for_row,1) + 0.5; 
  end
end

% shapes
switch shape, 
case 'sheet', 
  if strcmp(lattice,'hexa'), 
    % this correction is made to make distances to all 
    % neighboring units equal
    Coords(:,2) = Coords(:,2)*sqrt(0.75); 
  end

case 'cyl', 
  % to make cylinder the coordinates must lie in 3D space, at least
  if mdim<3, Coords = [Coords ones(munits,1)]; mdim = 3; end

  % Bend the coordinates to a circle in the plane formed by x- and 
  % and z-axis. Notice that the angle to which the last coordinates
  % are bended is _not_ 360 degrees, because that would be equal to 
  % the angle of the first coordinates (0 degrees).

  Coords(:,1)     = Coords(:,1)/max(Coords(:,1));
  Coords(:,1)     = 2*pi * Coords(:,1) * msize(2)/(msize(2)+1);
  Coords(:,[1 3]) = [cos(Coords(:,1)) sin(Coords(:,1))];
                    
case 'toroid', 

  % NOTE: if lattice is 'hexa', the msize(1) should be even, otherwise 
  % the bending the upper and lower edges of the map do not match 
  % to each other
  if strcmp(lattice,'hexa') && rem(msize(1),2)==1, 
    warning('Map size along y-coordinate is not even.');
  end

  % to make toroid the coordinates must lie in 3D space, at least
  if mdim<3, Coords = [Coords ones(munits,1)]; mdim = 3; end

  % First bend the coordinates to a circle in the plane formed
  % by x- and z-axis. Then bend in the plane formed by y- and
  % z-axis. (See also the notes in 'cyl').

  Coords(:,1)     = Coords(:,1)/max(Coords(:,1));
  Coords(:,1)     = 2*pi * Coords(:,1) * msize(2)/(msize(2)+1);
  Coords(:,[1 3]) = [cos(Coords(:,1)) sin(Coords(:,1))];

  Coords(:,2)     = Coords(:,2)/max(Coords(:,2));
  Coords(:,2)     = 2*pi * Coords(:,2) * msize(1)/(msize(1)+1);
  Coords(:,3)     = Coords(:,3) - min(Coords(:,3)) + 1;
  Coords(:,[2 3]) = Coords(:,[3 3]) .* [cos(Coords(:,2)) sin(Coords(:,2))];
  
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function C = bend(cx,cy,angle,xishexa)

  dx = max(cx) - min(cx);
  if dx ~= 0, 
    % in case of hexagonal lattice it must be taken into account that
    % coordinates of every second row are +0.5 off to the right
    if xishexa, dx = dx-0.5; end
    cx = angle*(cx - min(cx))/dx; 
  end    
  C(:,1) = (cy - min(cy)+1) .* cos(cx);
  C(:,2) = (cy - min(cy)+1) .* sin(cx);

% end of bend

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

