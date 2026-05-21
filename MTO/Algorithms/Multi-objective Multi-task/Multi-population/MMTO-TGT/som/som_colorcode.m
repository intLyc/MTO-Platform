function colors=som_colorcode(m, colorcode, scaling)

%SOM_COLORCODE Calculates a heuristic color coding for the SOM grid
%
% colors = som_colorcode(m, colorcode, scaling) 
%
%  Input and output arguments ([]'s are optional):
%   m           (struct) map or topol struct
%               (cell array) of form {str,[m1 m2]} where 
%                        str = 'hexa' or 'rect' and [m1 m2] = msize
%               (matrix) size N x 2, unit coordinates 
%   [colorcode] (string) 'rgb1' (default),'rgb2','rgb3','rgb4','hsv'  
%   [scaling]   (scalar) 1=on (default), 0=off. Has effect only
%                        if m is a Nx2 matrix of coordinates: 
%                        controls whether these are scaled to 
%                        range [0,1] or not.
%
%   colors      (matrix) size N x 3, RGB colors for each unit (or point)
%
% The function gives a color coding by location for the map grid 
% (or arbitrary set of points). Map grid coordinates are always linearly 
% normalized to a unit square (x and y coordinates between [0,1]), except
% if m is a Nx2 matrix and scaling=0. In that case too, the coordinates
% must be in range [0,1].
% 
% Following heuristic color codings are available:
%
%  'rgb1' slice of RGB-cube so that       green - yellow
%         the corners have colors:          |       |
%                                         blue  - magenta
%
%  'rgb2' slice of RGB-cube so that       red   - yellow
%         the corners have colors:          |       |
%                                         blue  - cyan   
%
%  'rgb3' slice of RGB-cube so that   mixed_green - orange
%         the corners have colors:          |        |
%                                     light_blue  - pink 
%
%  'rgb4' has 'rgb1' on the diagonal + additional colors in corners
%         (more resolution but visually strongly discontinuous) 
%
%  'hsv'  angle and radius from map centre are coded by hue and 
%         intensity (more resoluton but visually discontinuous)
%
% See also SOM_CPLANE, SOM_SHOW, SOM_CLUSTERCOLOR, SOM_KMEANSCOLOR, 
%          SOM_BMUCOLOR.

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0 Johan 140799 

%%% Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(1, 3, nargin));   % check no. of input args is correct

%% Check m: map, topol, cell or data?

if vis_valuetype(m,{'nx2'}),
  p=m;  % explicit coordinates
  
else
  
  % map, topol, cell
  
  [tmp,ok,tmp]=som_set(m);
  if isstruct(m) && all(ok)
    switch m.type
    case 'som_topol'              % topol 
      msize=m.msize;
      lattice=m.lattice;
    case 'som_map'   
      msize=m.topol.msize;        % map
      lattice=m.topol.lattice;
    otherwise
      error('Invalid map or topol struct.');
    end

  % cell  
    
  elseif iscell(m) && vis_valuetype(size(m),{[1 2]}),
    if vis_valuetype(m{2},{[1 2]}) && vis_valuetype(m{1},{'string'}),
      lattice=m{1};    
      msize=m{2}; 
    else
      error('Invalid map size information.');
    end
  end

  %% Check map parameters
 
  switch lattice                   % lattice  
  case 'hexa' 
  case 'rect'
  otherwise
    error('Unknown lattice type');
  end
  
  if length(msize)>2                % dimension
    error('Only 2D maps allowed!');
  end
  
                                     
  % Calculate coordinates 
  p=som_unit_coords(msize,lattice,'sheet');

  % Set scaling to 1 as it is done always in this case
  scaling=1;   
end

% Check colorcode

if nargin < 2 || isempty(colorcode),
  colorcode='rgb1';
end
if ~ischar(colorcode)
  error('String value for colorcode mode expected.');
else
 switch colorcode
 case { 'rgb1', 'rgb2', 'rgb3' , 'rgb4' ,'hsv'}
  otherwise
    error([ 'Colorcode mode ' colorcode ' not implemented.']);
  end
end

% Check scaling

if nargin < 3 || isempty(scaling) 
  scaling=1;
end

if ~vis_valuetype(scaling,{'1x1'})
  error('Scaling should be 0 (off) or 1 (on).');
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% scale coordintes between [0,1]

if scaling  
  n=size(p,1);
  mn=min(p);
  e=max(p)-mn;
  p=(p-repmat(mn,n,1))./repmat(e,n,1);
elseif sum(p(:,1)>1+p(:,1)<0+p(:,2)>1+p(:,2)<0),  
  error('Coordinates out of range [0,1].');
end

switch colorcode 
case 'rgb1'
  h(:,1)=p(:,1);
  h(:,2)=1-p(:,2);
  h(:,3)=p(:,2);
case 'rgb2'
  h(:,1)=p(:,1);
  h(:,2)=1-p(:,2);
  h(:,3)=1-p(:,1);
case 'rgb3'
  h(:,1)=p(:,1);
  h(:,2)=.5;
  h(:,3)=p(:,2);
case 'rgb4'  
 p=rgb4(p);
 h(:,1)=p(:,1);
 h(:,2)=1-p(:,2);
 h(:,3)=p(:,3);
case 'hsv'
  munits = n;
  Hsv = zeros(munits,3);
  for i=1:n, 
    dx = .5-p(i,1);
    dy = .5-p(i,2);
    r = sqrt(dx^2+dy^2);
    if r==0, 
      h=1; 
    elseif dx==0, 
      h=.5; %h=ay; 
    elseif dy==0, 
      h=.5; %h=ax; 
    else 
      h = min(abs(.5/(dx/r)),abs(.5/(dy/r))); 
    end
    
    if r==0, 
      angle = 0; 
    else 
      angle = acos(dx/r); 
      if dy<0, 
	angle = 2*pi-angle; 
      end
    end
    
    Hsv(i,1) = 1-sin(angle/4);
    Hsv(i,2) = 1;
    Hsv(i,3) = r/h; 
    h = hsv2rgb(Hsv);
  end
end


%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colors=h;

%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% juha %%%%

function p=rgb4(coord)

for i=1:size(coord,1);
 p(i,:)=get_coords(coord(i,:))';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coords=get_coords(coords)

%GET_COORDS
%
% get_coords(coords)
%
% ARGUMENTS
%
% coords (1x2 or 2x1 vector) coords(1) is an x-coordinate and coords(2)
%                            y-coordinate.
%
%
% RETURNS
%
% coords (3x1 vector) x,y and z-coordinates.
%

if ~(all(size(coords) == [1 2]) || all(size(coords) == [2 1]))
  error('Argument ''coords'' must be an 2x1 or 1x2 vector.');
end

if all(size(coords) == [1 2])
  coords=coords';
end

if any(coords > 1) any(coords < 0)
  error('Coordinates must lay inside the interval [0,1].');
end

if coords(1) <= 1/(sqrt(2)+1),
  if coords(2) <= line3(coords(1))
    coords=coords_in_base(4,coords);
  elseif coords(2) <= line2(coords(1))
    coords=coords_in_base(1,coords);
  else
    coords=coords_in_base(2,coords);
  end
elseif coords(1) <= sqrt(2)/(sqrt(2)+1)
  if coords(2) <= line1(coords(1))
    coords=coords_in_base(3,coords);
  elseif coords(2) <= line2(coords(1))
    coords=coords_in_base(1,coords);
  else
    coords=coords_in_base(2,coords);
  end
else
  if coords(2) <= line1(coords(1)),
    coords=coords_in_base(3,coords);
  elseif coords(2) <= line4(coords(1))
    coords=coords_in_base(1,coords);
  else
    coords=coords_in_base(5,coords);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coords=coords_in_base(base_no,coords)

A=[0;1/(sqrt(2)+1)];
E=[1;1];
F=[0;0];
G=[1;0];
H=[0;1];

const=1+1/sqrt(2);

switch base_no
  case 1
    x=(coords-A)*const;
    coords=[(1/sqrt(2))*(x(1)-x(2));0.5*(x(1)+x(2));0.5*(x(1)+x(2))];
  case 2
    x=(coords-H)*const;
    coords=[0;x(1);1+x(2)];
  case 3
    x=(coords-G)*const;
    coords=[1;1+x(1);x(2)];
  case 4
    x=(coords-F)*const;
    coords=[0.5+(1/sqrt(2))*(x(1)-x(2));...
            0.5-(1/sqrt(2))*(x(1)+x(2));... 
            0];
  case 5
    x=(coords-E)*const;
    coords=[0.5+(1/sqrt(2))*(x(1)-x(2));...
            0.5-(1/sqrt(2))*(x(1)+x(2));...      
            1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=line1(x)
  
y = x-1/(sqrt(2)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=line2(x)

y = x+1/(sqrt(2)+1);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=line3(x)

y = -x+1/(sqrt(2)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y= line4(x)

y = -x+(2*sqrt(2)+1)/(sqrt(2)+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
