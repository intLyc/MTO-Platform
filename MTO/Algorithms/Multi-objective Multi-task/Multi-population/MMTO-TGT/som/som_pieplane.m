function h=som_pieplane(varargin)

%SOM_PIEPLANE Visualize the map prototype vectors as pie charts
%
% h=som_pieplane(lattice, msize, data, [color], [s], [pos])
% h=som_pieplane(topol, data, [color], [s], [pos])
%
%  som_pieplane('hexa',[5 5], rand(25,4), jet(4), rand(25,1)) 
%  som_pieplane(sM, sM.codebook);
%
% Input and output arguments ([]'s are optional):
%  lattice   (string) grid 'hexa' or 'rect'
%  msize     (vector) size 1x2, defines the grid, M=msize(1)*msize(2)
%            (matrix) size Mx2, gives explicit coordinates for each node: in 
%             this case the lattice does not matter.
%  topol     (struct) map or topology struct
%  data      (matrix) size Mxd, Mth row is the data for Mth pie. The 
%             values will be normalized to have unit sum in each row.
%  [color]   (matrix) size dx3, RGB triples. The first row is the
%             color of the first slice in each pie etc. Default is hsv(d).
%            (string) ColorSpec or 'none' gives the same color for each slice.
%  [s]       (matrix) size Mx1,  gives an individual size scaling for each node. 
%            (scalar) gives the same size for each node. Default is 0.8. 
%  [pos]     (vectors) a 1x2 vector that determines position for the
%              origin, i.e. upper left corner. Default is no translation.
%
%  h         (scalar) the object handle to the PATCH object
%
% The data will be linearly scaled so that its sum is 1 in each unit.
% Negative values are invalid. Axis are set as in som_cplane.
%
% For more help, try 'type som_pieplane' or check out online documentation.
% See also SOM_CPLANE, SOM_PLOTPLANE, SOM_BARPLANE

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_pieplane
%
% PURPOSE
% 
% Visualizes the map prototype vectors as pie charts.
%
% SYNTAX
%
%  h = som_pieplane(topol, data)
%  h = som_pieplane(lattice, msize, data)
%  h = som_pieplane(..., color)
%  h = som_pieplane(..., color, s)
%  h = som_pieplane(..., color, s, pos)
%
% DESCRIPTION
%
%  Visualizes the map prototype vectors as pie charts.
%
% KNOWN BUGS
%
% It is not possible to specify explicit coordinates for map
% consisting of just one unit as then the msize is interpreted as
% map size.
%
%  FEATURES
% 
%  - negative values in data cause an error
%
%  - the colors are fixed: changing colormap in the figure (see help
%    colormap) will not affect the coloring of the slices.
%
%  - if input variable s has size Nxd it gives each slice an individual
%    scaling factor. This may be used to create a glyph where
%    the radius of the slice, not the angle, shows the variable
%    try, e.g., som_pieplane('rect',[5 4],ones(20,4),'w',rand(20,4));
%
% REQUIRED INPUT ARGUMENTS
% 
% lattice  The basic shape of the map units 
%         
%    (string) 'hexa' or 'rect' positions the pies according to hexagonal or 
%             rectangular map lattice.
%
% msize    The size of the map grid     
%
%    (vector) [n1 n2] vector defines the map size (height n1 units,
%             width n2 units, total M=n1xn2 units). The units will 
%             be placed to their topological locations to form a
%             uniform hexagonal or rectangular grid.
%    (matrix) Mx2 matrix defines arbitary coordinates for the M units. In 
%             this case the argument 'lattice' has no effect.
%
% topol    Topology of the map grid
%
%   (struct) map or topology struct from which the topology is taken
%
% data     The data to be visualized
%
%    (matrix) Mxd matrix of data vectors. Negative values are invalid.
%
% OPTIONAL INPUT ARGUMENTS
%
% If value is unspecified or empty ([] or ''), the default values
% are used for optional input arguments.
%
% s       The size scaling factors for the units
%
%    (scalar) gives each unit the same size scaling: 
%             0   unit disappears (edges can be seen as a dot)
%             ... default size is 0.8
%             >1  unit overlaps others          
%    (matrix) Mx1 double: each unit gets individual size scaling 
%
% color   The color of the slices in each pie
%
%    (string) ColorSpec or 'none' gives the same color for each slice
%    (matrix) dx3 matrix assigns an RGB color determined by the dth row of
%             the matrix to the dth slice (variable) in each pie plot
%
% pos    Position of origin       
% 
%    (vector) size 1x2: this is meant for drawing the plane in arbitary 
%             location in a figure. Note the operation: if this argument is
%             given, the axis limits setting part in the routine is skipped and 
%             the limits setting will be left to be done by
%             MATLAB's defaults. Default is no translation.
%
% OUTPUT ARGUMENTS
%
%  h (scalar)  Handle to the created patch object.
%
% OBJECT TAGS     
%
% One object handle is returned: field Tag is set to 'planePie'       
% 
% EXAMPLES
%
% %%% Create the data and make a map 
%    
% data=rand(100,5); map=som_make(data);
% 
% %%% Create a 'jet' colormap that has as many rows as the data has variables
%    
% colors=jet(5);
% 
% %%% Draw pies
%    
% som_pieplane(map, map.codebook, colors);
% 
% %%% Calculate the hits of data on the map and normalize them between [0,1]
%  
% hit=som_hits(map,data); hit=hit./max(max(hit));
% 
% %%% Draw the pies so that their size tells the hit count
%
% som_pieplane(map, map.codebook, colors, hit);
% 
% %%% Try this! (see section FEATURES) 
%
% som_pieplane('rect',[5 4],ones(20,4),'w',rand(20,4));
%
% SEE ALSO
%
% som_cplane     Visualize a 2D component plane, u-matrix or color plane
% som_barplane   Visualize the map prototype vectors as bar diagrams
% som_plotplane  Visualize the map prototype vectors as line graphs

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Johan 140799 juuso 310300 070600

%%% Check & Init arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nargin, lattice, msize, data, color, s, pos] = vis_planeGetArgs(varargin{:});
error(nargchk(3, 6, nargin));  % check no. of input args is correct

% check pos

if nargin < 6 || isempty(pos)
  pos=NaN;                            % default value for pos (no translation) 
elseif ~vis_valuetype(pos,{'1x2'})
  error('Position of origin has to be given as an 1x2 vector');
end

% check msize

if ~vis_valuetype(msize,{'1x2','nx2'}),
  error('msize has to be 1x2 grid size vector or a Nx2 coordinate matrix.');
end

% check data

if ~isnumeric(data),
  error('Data matrix must be numeric.');
elseif length(size((data)))>2
  error('Data matrix has too many dimensions!');
else
  d=size(data,2);
  N=size(data,1);
end

if any(data(:)<0)
  error('Negative data values not allowed in pie plots!');
end

% Check lattice
if ~ischar(lattice) || ~any(strcmp(lattice,{'hexa','rect'})),
  error('Invalid lattice.');
end

%% Calculate patch coordinates for slices

for i=1:N,                            
  [nx,ny]=vis_piepatch(data(i,:));    
  piesx(:,(1+(i-1)*d):(i*d))=nx;
  piesy(:,(1+(i-1)*d):(i*d))=ny;
end
l=size(piesx,1);

if size(msize,1) == 1,
  if prod(msize) ~= N 
    error('Data matrix has wrong size.');
  else
    coord=som_vis_coords(lattice, msize);
  end
else
  if N ~= size(msize,1),
    error('Data matrix has wrong size.');
  end
  coord=msize; 
  % This turns the axis tightening off,
  % as now we don't now the limits (no fixed grid)
  if isnan(pos); pos=[0 0]; end
end
x=reshape(repmat(coord(:,1),1,l*d)',l,d*N);
y=reshape(repmat(coord(:,2),1,l*d)',l,d*N);

% Check size

if nargin < 5 || isempty(s),  
  s=0.8;                              % default value for scaling
elseif ~vis_valuetype(s, {'1x1', [N 1], [N d]}),
  error('Size matrix does not match with the data matrix.');
elseif size(s) == [N 1],
  s=reshape(repmat(s,1,l*d)',l,d*N);
elseif all(size(s) ~= [1 1]),
  s=reshape(repmat(reshape(s',d*N,1),1,l)',l,d*N);
end

% Check color
% C_FLAG is a flag for color 'none' 

if nargin < 4 || isempty(color)
  color=hsv(d); C_FLAG=0;       % default n hsv colors
end

if ~(vis_valuetype(color, {[d 3], 'nx3rgb'},'all')) && ...
      ~vis_valuetype(color,{'colorstyle','1x3rgb'}), 
  error('The color matrix has wrong size or contains invalid values.');
elseif ischar(color) && strcmp(color,'none'), 
  C_FLAG=1;        % check for color 'none'
  color='w';    
else
  C_FLAG=0;        % valid color string or colormap
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size zero would cause division by zero. eps is as good (node disappears)
% The edge may be visible, though. (NaN causes some other problems)

s(s==0)=eps;                    

%% 1. Scaling
x=(x./s+piesx).*s; y=(y./s+piesy).*s;      

%% 2. Translation  
if ~isnan(pos)
  x=x+pos(1);y=y+pos(2);               
end

%% 3. Rearrange dx3 color matrix

if ~ischar(color) && size(color,1)~=1,
  color=reshape(repmat(color,N,1),[1 N*d 3]);
end

%% Set axes properties  
ax=newplot;                            % get current axis
vis_PlaneAxisProperties(ax,lattice, msize, pos);                         

%% Draw the plane! 

h_=patch(x,y,color);

if C_FLAG
  set(h_,'FaceColor','none');
end

set(h_,'Tag','planePie');              % tag the object 

%%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout>0, h=h_; end                % Set h only if 
                                       % there really is output
%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y]=vis_piepatch(v)

% Do a pie (see e.g. the MathWorks function PIE). 
% Origin is at (0,0) and the radius is .5.

N=25;

if sum(v)==0, v_is_zero = 1; v(1) = 1; else v_is_zero = 0; end

v(v==0) = eps; % Matlab 5.2 version of linspace doesn't work otherwise

phi=[0 2*pi*cumsum(v./sum(v))];

for i=2:length(phi),
  [xi,yi]=pol2cart(linspace(phi(i-1),phi(i),N),0.5);
  x(:,i-1)=[0 xi 0]';
  y(:,i-1)=[0 yi 0]';
end

if v_is_zero, x = x*0; y = y*0; end

