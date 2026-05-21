function h = som_barplane(varargin)

%SOM_BARPLANE Visualize the map prototype vectors as bar charts
%
% h = som_barplane(lattice, msize, data, [color], [scaling], [gap], [pos])
% h = som_barplane(topol, data, [color], [scaling], [gap], [pos])
%
%  som_barplane('hexa',[5 5], rand(25,4), jet(4)) 
%  som_barplane(sM, sM.codebook,'none')
% 
%  Input and output argumetns ([]'s are optional):
%   lattice   (string) grid 'hexa' or 'rect'
%   msize     (vector) size 1x2, defines the map grid size msize, M=prod(msize)
%             (matrix) size Mx2, gives explicit coordinates for each node:
%                      in this case the first argument does not matter.
%   topol     (struct) map or topology struct
%   data      (matrix) size Mxd, each row defines heights of the bars
%   [color]   (matrix) size dx3, of RGB triples. The rows define colors 
%                      for each bar in a node. Default is hsv(d). A ColorSpec or
%             (string) A ColorSpec or 'none' gives each bar the same color.       
%   [scaling] (string) 'none', 'unitwise' or 'varwise'. The scaling
%                      mode for the values. Default is 'varwise'.
%   [gap]     (scalar) Defines the gap between bars, limits: 0 <= gap <= 1 
%                      where 0=no gap, 1=bars are thin lines. Default is 0.25.
%   [pos]     (vector) 1x2 vector defines the position of origin.
%                      Default is [1 1].
%
%   h         (scalar) the object handle to the PATCH object
% 
% Axis are set as in SOM_CPLANE.
%
% For more help, try 'type som_barplane' or check out online documentation.
% See also SOM_CPLANE, SOM_PLOTPLANE, SOM_PIEPLANE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_barplane
%
% PURPOSE
% 
% Visualizes the map prototype vectors as bar charts.
%
% SYNTAX
%
%  h = som_barplane(topol, data)
%  h = som_barplane(lattice, msize, data)
%  h = som_barplane(..., color)
%  h = som_barplane(..., color, scaling)
%  h = som_barplane(..., color, scaling, gap)
%  h = som_barplane(..., color, scaling, gap, pos)
%
% DESCRIPTION
%
% Visualizes the map prototype vectors as bar charts.
%
% REQUIRED INPUT ARGUMENTS
% 
% lattice     The basic shape of the map units 
%    (string) 'hexa' or 'rect' positions the bar charts according to
%             hexagonal or rectangular map lattice
%
% msize       The size of the map grid     
%    (vector) [n1 n2] vector defines the map size (height: n1 units widht: n2
%             units, total: M=n1xn2 units). The units will be placed to their
%             topological locations in order to form a uniform hexagonal or 
%             rectangular grid.
%    (matrix) Mx2 matrix defines arbitary coordinates for the N units. In 
%             this case the argument 'lattice' has no effect
%
% topol    Topology of the map grid
%
%   (struct) map or topology struct from which the topology is taken
%
% data        The data to use when constructing the bar charts.
%             Typically, the map codebook or some of its components.
%    (matrix) Mxd matrix. A row defines heights of the bars.
%
% OPTIONAL INPUT ARGUMENTS
%
% Note: if unspecified or given an empty value ('' or []), default
% values are used for optional input arguments.
%
% color       The color of the bars in each pie
%    (ColorSpec) or (string) 'none' gives the same color for each slice.
%    (matrix) dx3 matrix assigns an RGB color determined by the dth row of
%             the matrix to the dth bar (variable) in each bar plot. 
%             Default value is hsv(d).
%
% scaling     How to scale the values  
%    (string) 'none', 'unitwise' or 'varwise'. This determines the 
%             scaling of codebook values when drawing the bars.  
%
%             'none' don't scale at all. The bars are not limited
%              to remain inside he units' area: That is, if value of
%              some variable exceeds [-.625,.625] for 'rect' (and
%              in "worst case" [-.5,-.5] for 'hexa') the bars may
%              overlap other units. 
%             
%              Base line (zero value line) 
%              - is in the middle of the unit if data (codebook) contains both 
%                negative and positive values (or is completely zero).
%              - is in the top the unit if data (codebook) contains only
%                non-positive values (everything <=0).
%              - is in the bottom the unit if data (codebook) contains only
%                non-negative values (everything >=0).
% 
%             'varwise' scales values so that each variable is scaled separately 
%              so that when it gets its overall maximum value, the
%              corresponding bar gets maximum range and for minimum value
%              it gets the minimum range. Baseline: see scaling 'none' 
%              This is the default.
%             
%             'unitwise' scales values in each unit individually so that the 
%              bars for variables having minimum and maximum values have minimum 
%              and maximum range inside each unit, respectively. 
%              In this case the zero value line may move depending on the values. 
% 

% gap         The gap between bars        
%    (scalar) 0: no gap: bars are glued together 
%             ... default value is 0.25       
%             1: maximum gap: bars are thin lines 
% 
% pos         Position of origin          
%    (vector) size 1x2. This is meant for drawing the plane in arbitrary 
%             location in a figure. Note the operation: if this argument is
%             given, the axis limits setting part in the routine is skipped and 
%             the limits setting will be left to be done by MATLAB's defaults. 
%             Default is [1 1].
%
% OUTPUT ARGUMENTS
%
%  h (scalar) handle to the created patch object
%
% OBJECT TAGS     
%
%  One object handle is returned: field Tag is set to 'planeBar'       
%
% FEATURES
%
%  - The colors are fixed: changing colormap in the figure (see help
%    colormap) will not change the coloring of the bars.
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
% %%% Draw bars
%    
% som_barplane(map.topol.lattice, map.topol.msize, map.codebook, colors);
% or som_barplane(map.topol, map.codebook, colors);
% or som_barplane(map, map.codebook, colors);
% 
% %%% Draw the bars so that the gap between the bars is bigger and all 
%     bars are black
%
% som_barplane(map, map.codebook, 'k', '', 0.6);
% 
% SEE ALSO
%
% som_cplane     Visualize a 2D component plane, u-matrix or color plane
% som_plotplane  Visualize the map prototype vectors as line graphs
% som_pieplane   Visualize the map prototype vectors as pie charts

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Juha P 110599, Johan 140799, juuso 151199 140300 070600

%%% Check & Init arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nargin, lattice, msize, data, color, scaling, gap, pos] = vis_planeGetArgs(varargin{:});
error(nargchk(3, 7, nargin))   % check that no. of input args is correct

% Check pos

if nargin < 7 || isempty(pos)
  pos=NaN;                            % default value for pos (no translation) 
elseif ~vis_valuetype(pos,{'1x2'})
  error('Position of origin has to be given as an 1x2 vector');
end

% Check gap

if nargin < 6 || isempty(gap),  
  gap=0.25;                           % default value for gap
elseif ~vis_valuetype(gap, {'1x1'}),
  error('Gap value must be scalar.');
elseif ~(gap >= 0 && gap<=1) 
  error('Gap value must be in interval [0,1].')
end

% Check scaling

if nargin < 5 || isempty(scaling),
  scaling='varwise';
elseif ~vis_valuetype(scaling,{'string'}) || ... 
      ~any(strcmp(scaling,{'none','unitwise','varwise'})),
  error('scaling sholud be ''none'', ''unitwise'' or ''varwise''.');
end
  
% Check msize

if ~vis_valuetype(msize,{'1x2','nx2'}),
  error('msize has to be 1x2 grid size vector or a Nx2 coordinate matrix.');
end

% Check data

if ~isnumeric(data),
  error('Data matrix has to be numeric.');
elseif length(size((data)))>2
  error('Data matrix has too many dimensions!');
else
  d=size(data,2);
  N=size(data,1);
end

s=.8;                                 % patch size scaling factor

switch scaling,
case 'none'  
  % no scaling: don't scale
  % Check data max and min values
  positive=any(data(:)>0); negative=any(data(:)<0);
  if (positive && negative) || (~positive && ~negative),
    % Data contains both negative and positive values (or is
    % completely zero) baseline to centre
    zeroline='zero';
  elseif positive && ~negative
    % Data contains only positive values: baseline to bottom
    zeroline='bottom';
  elseif ~positive && negative
    % Data contains only negative values: baseline to top
    zeroline='top';
  end
case 'unitwise'
  % scale the variables so that the bar for variable with the maximum 
  % value in the unit spans to the upper edge of the unit
  % and the bar for the variable with minimum value spans to the lower edge,
  % respectively.
  zeroline='moving';
 case 'varwise'
  % Check data max and min values
  positive=any(data(:)>0); negative=any(data(:)<0);
  if (positive && negative) || (~positive && ~negative),
    % Data contains both negative and positive values (or is
    % completely zero) baseline to
    % centre, scale data so that it doesn't overflow
    data=data./repmat(max(abs([max(data); min(data)])),N,1)*.5;
    zeroline='zero';
  elseif positive && ~negative
    % Data contains only positive values: baseline to
    % bottom, scale data so that it doesn't overflow
    data=data./repmat(max(abs([max(data); min(data)])),N,1)*.5;
    zeroline='bottom';
  elseif ~positive && negative
    % Data contains only negative values: baseline to
    % top, scale data so that it doesn't overflow
    zeroline='top';
    data=data./repmat(max(abs([max(data); min(data)])),N,1)*.5;
  end
otherwise
  error('Unknown scaling mode?');
end

for i=1:N,                            % calculate patch coordinates for
  v=data(i,:);
  [nx,ny]=vis_barpatch(v,gap,zeroline); % bars
  barx(:,(1+(i-1)*d):(i*d))=s*nx;
  bary(:,(1+(i-1)*d):(i*d))=s*ny;        
end
l=size(barx,1);

if size(msize,1) == 1,
  xdim=msize(2);
  ydim=msize(1);
  if xdim*ydim~=N 
    error('Data matrix has wrong size.');
  else
    y=reshape(repmat(1:ydim,d,1),1,d*ydim); y=repmat(repmat(y,l,1),1,xdim);
    x=reshape(repmat(1:xdim,l*ydim*d,1),l,N*d);  
  end
else
  x=reshape(repmat(msize(:,1),1,l*d)',l,d*N);
  y=reshape(repmat(msize(:,2),1,l*d)',l,d*N);
  if N ~= size(msize,1),
    error('Data matrix has wrong size.');
  else
    lattice='rect'; 
    if isnan(pos),
      pos=[0 0];
    end
  end
end

% Check lattice

if ~ischar(lattice)
  error('Invalid lattice.');
end

switch lattice                      
case {'hexa','rect'}
  pos=pos-1;
otherwise
  error([ 'Lattice' lattice ' not implemented!']);
end  

% Check color
% C_FLAG is for color 'none'

if nargin < 4 || isempty(color)
  color=hsv(d);                       % default n hsv colors
end
if ~vis_valuetype(color, {[d 3],'nx3rgb'},'all') && ...
  ~vis_valuetype(color,{'colorstyle','1x3rgb'})
error('The color matrix has wrong size or has invalid values.');
elseif ischar(color) && strcmp(color,'none')
  C_FLAG=1;
  color='w';
else
  C_FLAG=0;
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Making lattice.
% Command view([0 90]) shows the map in 2D properly oriented

switch lattice
  case 'hexa'
   t=find(rem(y(1,:),2));                        % move even rows by .5
   x(:,t)=x(:,t)-.5; 
   x=x+barx+.5; 
   y=y+bary;   
  case 'rect' 
   x=x+barx; 
   y=y+bary;         
end

% NB: The coordinates in hexa are not uniform in order to get even  
% y-coordinates for the nodes. This is handled by setting _axis scaling_ 
% so that the hexa-nodes look like uniform hexagonals. See 
% vis_PlaneAxisProperties

if ~isnan(pos)
  x=x+pos(1);y=y+pos(2);               % move upper left corner 
end                                    % to pos

%% Set axes properties  

ax=newplot;                            % get current axis
vis_PlaneAxisProperties(ax,lattice, msize, pos);                         

%% Rearrange dx3 color matrix

if ~ischar(color) && size(color,1)~=1,
  color=reshape(repmat(color,N,1),[1 N*d 3]);
end

%% Draw the plane! 

if isnumeric(color), 
  % explicit color settings by RGB-triplets won't work with 
  % patch in 'painters' mode, unless there only a single triplet
  si = size(color); 
  if length(si)~=2 || any(si==[1 3]), set(gcf,'renderer','zbuffer'); end
end

h_=patch(x,y,color);

if C_FLAG
  set(h_,'FaceColor','none');
end

set(h_,'Tag','planeBar');              % tag the object 

%%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout>0, h=h_; end                % Set h only if 
                                       % there really is output

%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xcoord,ycoord]=vis_barpatch(y,gap,zeroline)

x = length(y);
d = gap/(2*(x-1)+2);
step= -.5:1/x:.5;

miny=min(y);
maxy=max(y);

switch(zeroline)
 case 'moving'
  if miny < 0 
    if maxy > 0
      zl = .5 - (abs(miny)/(maxy-miny));    %reverse mode
      y= .5 - ((y-miny*ones(1,x))./(maxy-miny));
    else
      zl = -.5;
      y=-.5+abs(y./miny);
    end
  else
    zl = .5;    %reverse mode
    y=.5-y./maxy;
  end
 case 'moveNotScale'
  if miny < 0
    if maxy > 0
      zl = 0.5+miny;
      y = zl - y; 
    else
      zl=-.5;
      y=-.5+abs(y);
    end
  else
    zl=.5;
    y =.5-y;
  end
 case 'zero'
  zl=0; y=zl-y; 
 case 'top'
  zl=-.5; y=zl-2*y; 
 case 'bottom'
  zl=.5; y=zl-2*y; 
end

for i=1:x
  xcoord(:,i) = [d+step(i);d+step(i);step(i+1)-d;step(i+1)-d;d+step(i)];
  ycoord(:,i) = [zl;y(i);y(i);zl;zl];
end





