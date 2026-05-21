function h=som_plotplane(varargin)

%SOM_PLOTPLANE  Visualize the map prototype vectors as line graphs
%
% h=som_plotplane(lattice, msize, data, [color], [scaling], [pos])
% h=som_plotplane(topol, data, [color], [scaling], [pos])
%
%  som_plotplane('hexa',[5 5], rand(25,4), jet(25)) 
%  som_plotplane(sM, sM.codebook)
%
% Input and output arguments ([]'s are optional)
%  lattice   (string) grid 'hexa' or 'rect'
%  msize     (vector) size 1x2, defines the grid size 
%            (matrix) size Mx2, defines explicit coordinates: in 
%             this case the first argument does not matter 
%  topol     (struct) map or topology struct
%  data      (matrix) Mxd matrix, M=prod(msize) 
%  [color]   (matrix) size Mx3, gives an individual color for each graph
%            (string) ColorSpec gives the same color for each
%             graph, default is 'k' (black)
%  [scaling] (string) 'on' or 'off', default is 'on' 
%  [pos]     (vector) 1x2 vector that determines translation. 
%             Default is no translation.
%
%  h         (vector) the object handles for the LINE objects
%
%  If scaling is set on, the data will be linearly scaled in each
%  unit so that min and max values span from lower to upper edge
%  in each unit. If scaling is 'off', the proper scaling is left to 
%  the user: values in range [-.5,.5] will be plotted within the limits of the 
%  unit while values exceeding this range will be out of the unit. 
%  Axis are set as in SOM_CPLANE.
%
% For more help, try 'type som_plotplane' or check out online documentation.
% See also SOM_PLANE, SOM_PIEPLANE, SOM_BARPLANE

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_plotplane
%
% PURPOSE
% 
% Visualizes the map prototype vectors as line graph
%
% SYNTAX
%
%  h = som_plotplane(topol, data)
%  h = som_plotplane(lattice, msize, data)
%  h = som_plotplane(..., color)
%  h = som_plotplane(..., color, scaling)
%  h = som_plotplane(..., color, scaling, pos)
%
% DESCRIPTION
%
%  Visualizes the map prototype vectors as line graph
%
% KNOWN BUGS
%
%  It is not possible to specify explicit coordinates for map
%  consistig of just one unit as then the msize is interpreted as
%  map size.
%
% FEATURES
%
%  - the colors are fixed: changing colormap in the figure (see
%    COLORMAP) will not affect the coloring of the plots
%
% REQUIRED INPUT ARGUMENTS
% 
% lattice  The basic topology
%
%   (string) 'hexa' or 'rect' positions the plots according to hexagonal or 
%            rectangular map lattice.
%
% msize    The size of the map grid     
%         
%   (vector) [n1 n2] vector defines the map size (height n1 units, width n2 
%            units, total M=n1 x n2 units). The units will be placed to their 
%            topological locations in order to form a uniform hexagonal or 
%            rectangular grid.   
%   (matrix) Mx2 matrix defines arbitary coordinates for the M units.
%            In this case the argument 'lattice' has no effect.
% 
% topol    Topology of the map grid
%
%   (struct) map or topology struct from which the topology is taken
% 
% data     The data to be visualized
%
%   (matrix) Mxd matrix of data vectors. 
% 
% OPTIONAL INPUT ARGUMENTS
%
% If unspecified or given empty values ('' or []), default values
% will be used for optional input arguments.
% 
% color    The color of the plots
%
%    (string) Matlab's ColorSpec (see help plot) string gives the same color 
%             for each line.
%
%    (matrix) Mx3 matrix assigns an RGB color determined by the Nth row of
%             the matrix to the Nth plot. 
%
%    (vector) 1x3 RGB vector gives the same color for each line.
%
% scaling  The data scaling mode
%
%    (string) 'on or 'off': if scaling is set on, the data will be
%             linearly scaled in each unit so that min and max values span from 
%             lower to upper edge in each unit. If scaling is 'off', the proper 
%             scaling is left to the user: values in range [-.5,.5] will be plotted 
%             within the limits of the unit while values exceeding this
%             range will be out of the unit.
%
% pos      Position of the origin          
%
%    (vector) This is meant for drawing the plane in arbitary location in a 
%             figure. Note the operation: if this argument is given, the
%             axis limits setting part in the routine is skipped and the limits
%             setting will be left to be done by MATLAB's
%             defaults. By default no translation is done.
%
% OUTPUT ARGUMENTS
%
%  h (scalar)  Handle to the created patch object
%
% OBJECT TAG     
%
% Object property 'Tag' is set to 'planePlot'.       
%
% EXAMPLES
%
% %%% Create the data and make a map 
%    
% data=rand(1000,20); map=som_make(data);
% 
% %%% Create a 'gray' colormap that has 64 levels
%    
% color_map=gray(64);
% 
% %%% Draw plots using red color
%    
% som_plotplane(map, map.codebook,'r');
%
% %%% Calculate hits on the map and calculate colors so that
%     black = min. number of hits and white = max. number of hits
%
% hit=som_hits(map,data); color=som_normcolor(hit(:),color_map);
%
% %%% Draw plots again. Now the gray level indicates the number of hits to 
%     each node
%
% som_plotplane(map, map.codebook, color);
%
% SEE ALSO  
%
% som_cplane     Visualize a 2D component plane, u-matrix or color plane
% som_barplane   Visualize the map prototype vectors as bar diagrams.
% som_pieplane   Visualize the map prototype vectors as pie charts

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Johan 160799 juuso 151199 070600

%%% Init & Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nargin, lattice, msize, data, color, scaling, pos] = vis_planeGetArgs(varargin{:});
error(nargchk(3, 5, nargin));  % check no. of input args is correct

s=0.8; % size of plot

if nargin < 6 || isempty(pos)
  pos=NaN; 
end

if nargin < 5 || isempty(scaling)
  scaling='on'; 
elseif ~vis_valuetype(scaling,{'string'}) || ...
      ~any(strcmp(scaling,{'on','off'})),
  error('Scaling should be string ''on'' or ''off''.');
end

l=size(data,2);

if ~isnumeric(msize) || ndims(msize) ~= 2 || size(msize,2)~=2, 
  error('msize has to be 1x2 grid size vector or a Nx2 coordinate matrix.');
elseif size(msize,1) == 1,
   xdim=msize(2);
   ydim=msize(1);
   N=xdim*ydim;
   y=repmat(repmat([1:ydim]',xdim,1),1,l);
   x=reshape(repmat([1:xdim],ydim*l,1),l,N)';
else
   x=repmat(msize(:,1),1,l);y=repmat(msize(:,2),1,l);
   N=size(msize,1);
   lattice='rect'; 
   if isnan(pos),
      pos=[0 0];
   end
end

switch lattice
case {'hexa', 'rect'}
otherwise
  error(['Lattice' lattice ' not implemented!']);
end  

if ~isnumeric(data) || size(data,1) ~= N
  error('Data matrix is invalid or has wrong size!');
end

if nargin < 4 || isempty(color),
  color='k';
elseif vis_valuetype(color, {'colorstyle',[N 3]}),
  if ischar(color) && strcmp(color,'none'),
    error('Colorstyle ''none'' not allowed in som_plotplane.');
  end
elseif vis_valuetype(color,{'1x3rgb'})
elseif ~vis_valuetype(color,{'nx3rgb',[N 3]},'all'), 
  error('The color matrix has wrong size or contains invalid RGB values or colorstyle.');
end

[linesx, linesy]=vis_line(data,scaling);

%%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Making the lattice.
% Command view([0 90]) shows the map in 2D properly oriented

switch lattice
case 'hexa'
  t=find(rem(y(:,1),2));                  % move even rows by .5
  x(t,:)=x(t,:)-.5; 
  x=(x./s+linesx).*s+.5; y=(y./s+linesy).*s;      % scale with s
case 'rect' 
  x=(x./s+linesx).*s; y=(y./s+linesy).*s;         % scale with s
end

%% Draw the map! ...

h_=plot(x',y');

if size(color,1) == 1
  set(h_,'Color',color);
else
  for i=1:N,
    set(h_(i,:),'Color',color(i,:));
  end
end

if ~isnan(pos)
  x=x+pos(1);y=y+pos(2);                    % move upper left corner 
end                                         % to pos(1),pos(2)

%% Set axes properties  

ax=gca;           
vis_PlaneAxisProperties(ax, lattice, msize, pos);

%%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(h_,'Tag','planePlot');                % tag the lineobject 

if nargout>0, h=h_; end                   % Set h only, 
                                          % if there really is output
                                          
%% Subfuntion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                          
function [x,y]=vis_line(data, scaling)

s=size(data);
% normalization between [0,1] if scaling is on
if strcmp(scaling,'on')
  mn=repmat(min(data,[],2),1,s(2));  
  mx=repmat(max(data,[],2),1,s(2));
  y=-((data-mn)./(mx-mn))+.5;        
else                       % -sign is beacuse we do axis ij
  y=-data;
end

x=repmat(linspace(-.5, .5, size(data,2)), size(data,1),1);
