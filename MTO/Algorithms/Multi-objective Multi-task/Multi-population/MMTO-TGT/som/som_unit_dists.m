function Ud = som_unit_dists(topol,lattice,shape)

%SOM_UNIT_DISTS Distances between unit-locations on the map grid.
%
% Ud = som_unit_dists(topol,[lattice],[shape])
% 
%  Ud = som_unit_dists(sMap);
%  Ud = som_unit_dists(sMap.topol);
%  Ud = som_unit_dists(msize, 'hexa', 'cyl');
%  Ud = som_unit_dists([10 4 4], 'rect', 'toroid');
%
%  Input and output arguments ([]'s are optional): 
%   topol              topology of the SOM grid
%             (struct) topology or map struct
%             (vector) the 'msize' field of topology struct
%   [lattice] (string) map lattice, 'rect' by default
%   [shape]   (string) map shape, 'sheet' by default
%
%   Ud        (matrix, size [munits munits]) distance from each map unit 
%                      to each map unit
%
% For more help, try 'type som_unit_dists' or check out online documentation.
% See also SOM_UNIT_COORDS, SOM_UNIT_NEIGHS.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_unit_dists
%
% PURPOSE
%
% Returns interunit distances between the units of a Self-Organizing Map
% along the map grid.
%
% SYNTAX
%
%  Ud = som_unit_dists(sTopol);
%  Ud = som_unit_dists(sM.topol);
%  Ud = som_unit_dists(msize);
%  Ud = som_unit_dists(msize,'hexa');
%  Ud = som_unit_dists(msize,'rect','toroid');
%
% DESCRIPTION
%
% Calculates the distances between the units of a SOM based on the 
% given topology. The distance are euclidian and they are measured
% along the map grid (in the output space). 
%
% In case of 'sheet' shape, the distances can be measured directly
% from the unit coordinates given by SOM_UNIT_COORDS. 
%
% In case of 'cyl' and 'toroid' shapes this is not so. In these cases
% the coordinates are calculated as in the case of 'sheet' shape and
% the shape is then taken into account by shifting the map grid into
% different positions. 
%
% Consider, for example, a 4x3 map. The basic position of map units 
% is shown on the left (with '1' - 'C' each denoting one map unit). 
% In case of a 'cyl' shape, units on the left and right edges are
% neighbors, so for this purpose the map is copied on the left and
% right sides of the map, as on right. 
%
%    basic               left     basic    right
%    -------             -------  -------  -------
%    1  5  9             1  5  9  1  5  9  1  5  9
%    2  6  a             2  6  a  2  6  a  2  6  a  
%    3  7  b             3  7  b  3  7  b  3  7  b 
%    4  8  c             4  8  c  4  8  c  4  8  c 
% 
% For the 'toroid' shape a similar trick is done, except that the 
% copies are placed all around the basic position:
%
%             1  5  9  1  5  9  1  5  9
%             2  6  a  2  6  a  2  6  a  
%             3  7  b  3  7  b  3  7  b 
%             4  8  c  4  8  c  4  8  c 
%             1  5  9  1  5  9  1  5  9
%             2  6  a  2  6  a  2  6  a  
%             3  7  b  3  7  b  3  7  b 
%             4  8  c  4  8  c  4  8  c 
%             1  5  9  1  5  9  1  5  9
%             2  6  a  2  6  a  2  6  a  
%             3  7  b  3  7  b  3  7  b 
%             4  8  c  4  8  c  4  8  c 
%
% From this we can see that the distance from unit '1' is 1 to units
% '9','2','4' and '5', and sqrt(2) to units 'C','A','8' and '6'. Notice 
% that in the case of a 'hexa' lattice and 'toroid' shape, the size
% of the map in y-direction should be even. The reason can be clearly
% seen from the two figures below. On the left the basic positions for
% a 3x3 map. If the map is copied above itself, it can be seen that the
% lattice is broken (on the right):
%
%     basic positions                 example of broken lattice
%     ---------------                 -------------------------
%                                     1  4  7 
%                                      2  5  8
%                                     3  6  9
%     1  4  7                         1  4  7 
%      2  5  8                         2  5  8
%     3  6  9                         3  6  9
%
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
%  Ud   (matrix) distances from each map unit to each other map unit,
%                size is [munits munits]
%
% EXAMPLES
%
% Simplest case:
%  Ud = som_unit_dists(sTopol);
%  Ud = som_unit_dists(sMap.topol);
%  Ud = som_unit_dists(msize);
%  Ud = som_unit_dists([10 10]);
%
% If topology is given as vector, lattice is 'rect' and shape is 'sheet'
% by default. To change these, you can use the optional arguments:
%  Ud = som_unit_dists(msize, 'hexa', 'toroid');
%
% The distances can also be calculated for high-dimensional grids:
%  Ud = som_unit_dists([4 4 4 4 4 4]);
%
% SEE ALSO
% 
%  som_unit_coords   Calculate grid coordinates.
%  som_unit_neighs   Calculate neighborhoods of map units.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 110997
% Version 2.0beta juuso 101199 170400 070600 130600

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

msize = sTopol.msize;
lattice = sTopol.lattice;
shape = sTopol.shape;

munits = prod(msize);
Ud = zeros(munits,munits);

% free topology
if strcmp(lattice,'free'),
  N1 = sTopol.connection; 
  Ud = som_neighborhood(N1,Inf);
end

% coordinates of map units when the grid is spread on a plane
Coords = som_unit_coords(msize,lattice,'sheet');

% width and height of the grid
dx = max(Coords(:,1))-min(Coords(:,1));
if msize(1)>1, dx = dx*msize(1)/(msize(1)-1); else dx = dx+1; end
dy = max(Coords(:,2))-min(Coords(:,2));
if msize(2)>1, dy = dy*msize(2)/(msize(2)-1); else dy = dy+1; end

% calculate distance from each location to each other location
switch shape, 
case 'sheet',
  for i=1:(munits-1), 
    inds = [(i+1):munits]; 
    Dco = (Coords(inds,:) - Coords(ones(munits-i,1)*i,:))'; 
    Ud(i,inds) = sqrt(sum(Dco.^2));
  end

case 'cyl', 
  for i=1:(munits-1), 
    inds = [(i+1):munits]; 
    Dco  = (Coords(inds,:) - Coords(ones(munits-i,1)*i,:))'; 
    dist = sum(Dco.^2);
    % The cylinder shape is taken into account by adding and substracting
    % the width of the map (dx) from the x-coordinate (ie. shifting the
    % map right and left).
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) + dx;  %East (x+dx)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) - dx;  %West (x-dx)
    dist = min(dist,sum(DcoS.^2));
    Ud(i,inds) = sqrt(dist);
  end

case 'toroid', 
  for i=1:(munits-1), 
    inds = [(i+1):munits]; 
    Dco  = (Coords(inds,:) - Coords(ones(munits-i,1)*i,:))'; 
    dist = sum(Dco.^2); 
    % The toroid shape is taken into account as the cylinder shape was 
    % (see above), except that the map is shifted also vertically.
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) + dx;  %East (x+dx)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) - dx;  %West (x+dx)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(2,:) = DcoS(2,:) + dy;  %South (y+dy)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(2,:) = DcoS(2,:) - dy;  %North (y-dy)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) + dx; DcoS(2,:) = DcoS(2,:) - dy; %NorthEast (x+dx, y-dy)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) + dx; DcoS(2,:) = DcoS(2,:) + dy; %SouthEast (x+dx, y+dy)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) - dx; DcoS(2,:) = DcoS(2,:) + dy; %SouthWest (x-dx, y+dy)
    dist = min(dist,sum(DcoS.^2));
    DcoS = Dco; DcoS(1,:) = DcoS(1,:) - dx; DcoS(2,:) = DcoS(2,:) - dy; %NorthWest (x-dx, y-dy)
    dist = min(dist,sum(DcoS.^2));
    Ud(i,inds) = sqrt(dist);
  end

otherwise, 
  error (['Unknown shape: ', shape]);

end

Ud = Ud + Ud';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
