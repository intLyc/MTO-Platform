function h=som_cplane(varargin) 

%SOM_CPLANE Visualize one 2D component plane, U-matrix or color plane.
%
% h=som_cplane(lattice, msize, color, [s], [pos]) 
% h=som_cplane(topol, color, [s], [pos]) 
%
%  som_cplane('hexa', [10 5], 'none');
%  som_cplane('rect', [10 5], 'r');
%  som_cplane(sM.topol, sM.codebook(:,1));
%  U = som_umat(sM); som_cplane('hexaU',sM.topol.msize,U(:));
%
%  Input and output arguments ([]'s are optional): 
%   lattice   (string) 'hexa', 'rect' (component planes)
%                      'hexaU', 'rectU' (corresponding U-matrices)
%             (matrix) defines the patch (see function VIS_PATCH).
%   msize     (vector) 1x2 vector defines grid size (M=prod(msize))
%             (matrix) Mx2 matrix gives explicit coordinates for each node
%   topol     (struct) map or topology struct
%   color              color for the nodes
%             (matrix) Mx1 matrix gives indexed colors for the units
%                      Mx3 matrix of RGB triples gives explicit
%                      color for each unit
%                      (Note: in case of U-matrix, the number of color
%                      values is 4*prod(msize)-2*sum(msize)+1, not prod(msize))
%             (string) ColorSpec gives the same color for each node
%                      'none' draws black edges only.              
%   [s]       (matrix) size Mx1, gives individual size scaling for each node 
%             (scalar) gives the same size for each node, default=1.
%                      Additional features: see 'type som_cplane' 
%                      This argument is ignored if the lattice is 'rectU' or 'hexaU'.
%   [pos]     (vector) a 1x2 vector that determines position of origin, 
%                      default is [1 1].
%
%   h         (scalar) the object handle for the PATCH object
%
% Axis are set to the 'ij' mode with equal spacing and turned off if
% 'pos' is not given. If 'lattice' is 'rect', 'hexa', 'rectU' or
% 'hexaU' the node (a,b) has coordinates (a,b) (+pos), except on the
% even numbered rows on the 'hexa' and 'hexaU' grids where the
% coordinates are (a,b+0.5) (+pos).
%
% For more help, try 'type som_cplane' or check out online documentation.
% See also SOM_PIEPLANE, SOM_PLOTPLANE, SOM_BARPLANE, VIS_PATCH,
%          SOM_VIS_COORDS

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_cplane
%
% PURPOSE
% 
% Visualizes a 2D component plane or u-matrix
%
% SYNTAX
%
%  h = som_cplane(topol, color)
%  h = som_cplane(lattice, msize, color)
%  h = som_cplane(lattice, msize, color)
%  h = som_cplane(..., size) 
%  h = som_cplane(..., size, pos) 
%
% DESCRIPTION
%
% Creates some basic visualizations of the SOM grid: the component plane and
% the unified distance matrix. The routine draws the SOM grid as a patch
% object according to the specifications given in the input arguments and
% returns its object handle.
% 
% Each unit of the map is presented by a polygon whose color, size, shape
% and location can be specified in various ways. The usual procedure 
% is to choose the lattice and map size used in the map training. Then
% the function creates the standard sheet shaped topological 
% representation of the map grid with hexagonal or rectangular units.
% When the values from a map codebook component (or from SOM_UMAT) 
% are given to the function it produces an indexed coloring for the 
% units (as in SURF command). Another possibility is to give a fixed 
% RGB color for each unit explicitly.
% 
% Special effects (variable unit size, location or shape) can be produced
% giving different types of input variables.
%
% KNOWN BUGS
%
% Using 1x3 or 3x1 grids causes problem, as the MATLAB will treat the color 
% information vector 1x3 or 3x1 as a single RGB triple. So, using indexed 
% colors is not possible for this particular map size.
%
% It is not possible to specify explicit coordinates for map
% consistig of just one unit as then the msize is interpreted as
% map size.
%
% REQUIRED INPUT ARGUMENTS
% 
% Note: M is the number of map units
%
% lattice  The basic shape of the map units 
%
%   (string) 'hexa' or 'rect' creates standard component plane; 
%            'hexaU' or 'rectU' creates standard u-matrix.
%   (matrix) Lx2 matrix defines the cornes of an arbitary polygon to be used
%            as the unit marker. (L is the number of patch vertex: L=6 for 
%            'hexa' and L=4 for 'rect') 
%
% msize    The size of the map grid     
%         
%   (vector) [n1 n2] vector defines the map size (height n1 units, width 
%            n2 units, total M=n1 x n2 units). The units will be placed to their 
%            topological locations to form a uniform hexagonal or rectangular grid.
%   (matrix) Mx2 matrix defines arbitrary coordinates for the M units
%            In this case the argument 'lattice' defines the unit form only. 
%
% topol    Topology of the map grid
%
%   (struct) map or topology struct from which the topology is taken
% 
% color    Unit colors
%           
%   (string) (ColorSpec) gives the same color for each unit, 'none'
%            draws black unit edges only.
%   (vector) Mx1 column vector gives indexed color for each unit using the 
%            current colormap (see help colormap).   
%   (matrix) Mx3 matrix of RGB triples as rows gives each unit a fixed color.
%
% OPTIONAL INPUT ARGUMENTS
%
% Note: M is the number of map units. 
% Note: if unspecified or given empty values ('' or []) default
% values are used for optional input arguments.
% 
% s        The size scaling factors for the units
% 
%   (scalar) scalar gives each unit the same size scaling: 
%            0   unit disappears (edges can be seen as a dot).
%            1   by default unit has its normal size (ie. no scaling)
%            >1  unit overlaps others      
%   (matrix) Mx1 double: each unit gets individual size scaling
%
% pos      Position of origin          
% 
%   (vector) This argument exists to be able drawing component planes
%            in arbitrary locations in a figure. Note the operation:
%            if this argument is given, the axis limits setting
%            part in the routine is skipped and the limits setting
%            will be left to be done by MATLAB's default
%            operation. 
%
% OUTPUT ARGUMENTS
%
% h (scalar) handle to the created patch object
% 
% OBJECT TAGS     
%
% One object handle is returned: field Tag is set to
%  'planeC'  for component plane     
%  'planeU'  for U-matrix
%
% FEATURES
%
% There are some extra features in following arguments
%
% size
%  - MxL matrix: radial scaling: the distance between 
%    the center of node m and its kth vertex is scaled by
%    s(m,k).
%  - Mx1x2 matrix: the uniform scaling is done separately for
%    x- and y-directions
%  - MxLx2 matrix: the scaling is done separately to x- and y-
%    directions for each vertex.
%
% color
%    Each vertex may be given individual color. 
%    The PATCH object interpolates the colors on the 
%    face if shading is turned to interp. 
%  - 1xMxL matrix: colormap index for each vertex
%  - LxMx3 matrix: RGB color for each vertex
%
% Note: In both cases (size and color) the ordering of the patch
% vertices in the "built-in" patches is the following
%
%          'rect'      'hexa'
%            1 3          1 
%            2 4         5 2
%                        6 3
%                         4
%
% The color interpolation result seem to depend on the order 
% in which the patch vertices are defined. Anyway, it gives 
% unfavourable results in our case especially with hexa grid: 
% this is a MATLAB feature.
%
% EXAMPLES
%
% m=som_make(rand(100,4),'msize',[6 5])         % make a map
% 
% % show the first variable plane using indexed color coding
%          
% som_cplane(m.topol.lattice,m.topol.msize,m.codebook(:,1));  
% or som_cplane(m.topol,m.codebook(:,1));  
% or som_cplane(m,m.codebook(:,1));  
%
% % show the first variable using different sized black units
%  
% som_cplane(m,'k',m.codebook(:,1));
% 
% % Show the u-matrix. First we have to calculate it. 
% % Note: som_umat returns a matrix therefore we write u(:) to get 
% % a vector which contains the values in the proper order.
% 
% u=som_umat(m); 
% som_cplane('hexaU', m.topol.msize, u(:)); 
%
% % Show three first variables coded as RGB colors
% % and turn the unit edges off
% 
% h=som_cplane(m, m.codebook(:,1:3),1)
% set(h,'edgecolor','none');
%
% % Try this! (see section FEATURES)
% 
% som_cplane('rect',[5 5],'none',rand(25,4));
% som_cplane('rect',[5 5],rand(1,25,4));
%
% SEE ALSO
%
% som_barplane   Visualize the map prototype vectors as bar diagrams
% som_plotplane  Visualize the map prototype vectors as line graphs
% som_pieplane   Visualize the map prototype vectors as pie charts
% som_umat       Compute unified distance matrix of self-organizing map
% vis_patch      Define the basic patches used in som_cplane
% som_vis_coords The default 'hexa' and 'rect' coordinates in visualizations

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Johan 061099 juuso 151199 juuso 070600

%%% Check & Init  arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nargin, lattice, msize, color, s, pos]=vis_planeGetArgs(varargin{:});
error(nargchk(3, 5, nargin));  % check no. of input args is correct

%% Translation?

if nargin < 5 || isempty(pos)
  pos=NaN;              % "no translation" flag
elseif ~vis_valuetype(pos,{'1x2'}),
  error('Position of origin has to be given as an 1x2 vector.');
end

%% Patchform %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch class(lattice)
case 'char'             % built-in patchforms
  pos=pos-1;
  switch lattice
  case {'hexa', 'hexaU'}
    patchform=vis_patch('hexa');
  case {'rect', 'rectU'}
    patchform=vis_patch('rect');
  otherwise
    error([ 'Lattice ' lattice ' not implemented!']);
  end
case { 'double', 'sparse'}
  if vis_valuetype(lattice,{'nx2'}),
    patchform=lattice; % users patchform
    lattice='rect';    
  else
    error('Patchform matrix has wrong size');
  end
otherwise
  error('String or matrix expected for lattice.');
end

l=size(patchform,1);     % number of vertices    
planeType=lattice(end);  % 'U' if umatrix otherwise something else

if ~vis_valuetype(msize,{ '1x2', 'nx2'}),
  error('msize has to be given as 1x2 or nx2 vectors.');
end

%% msize or coordinates %%%%%%%%%%%%%%%%%%%%%%%

if size(msize,1)>1 
  % msize is coordinate matrix Nx2?
  
  if planeType == 'U',  % don't accept u-matrix
    error('U-matrix visualization doesn''t work with free coordinates.');
  end
  
  % set number of map unit and unit coordinates 
  munits=size(msize,1);
  unit_coords=msize; msize=[munits 1];
  
  if isnan(pos),         % no translation is done here 
    pos=[0 0];           % using [0 0] in order to prevent 
  end	                 % axis tightening in
                         % vis_PlaneAxisProperties (arbitary coords!) 
else
  % msize is built-in lattice
  
  unit_coords=som_vis_coords(lattice,msize);
  
  % Calculate matrices x and y which 'moves' nodes 
  % to the correct positions:
  % For U-matrix, the size has to be recalculated
  if planeType == 'U',
    xdim=2*msize(1)-1;ydim=2*msize(2)-1;
  else
    xdim=msize(1);ydim=msize(2);
  end
  munits=xdim*ydim;
  
  % Feature warning
  if munits == 3  
    warning('SOMTOOLBOX:warning', 'Problems with 1x3 and 3x1 maps. See documentation.');
  end
end

%% Color matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isnumeric(color) && ~ischar(color),
  error('Color matrix is invalid.');
else
  d=size(color);           
  switch length(d)       
  case 2   %% Flat colors
    if ischar(color) % Check for string 'none'
      if strcmp(color,'none'), 
	color=NaN;
      end
    else               
      if ~(d(1)== 1 && d(2) == 3) && ...
	    ~(d(1) == munits && (d(2)==1 || d(2)==3))
	error('Color data matrix has wrong size.');
      elseif d(1)~=1 && d(2)==3 
	if any(color>1 | color<0)
	  error('Color data matrix has invalid RGB values.');
	end
	color=reshape(color,[1 munits 3]);  % RGB colors
      elseif d(2)==1
	color=color';                       % indexed
      end
    end
  case 3   %% Interpolated colors
    if d(1) == 1 && d(2) == munits && d(3) == l,  
      color=reshape(color, l, munits);
    elseif ~(d(1) == l && d(2) == munits && d(3) == 3) 
      error('Color data matrix has wrong size.');
    end
  otherwise
    error('Color data matrix has too many dimensions.');
  end
end

%% Size matrix? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 4 || isempty(s),  
   s=1;      % default value for s (no scaling)
elseif ~isnumeric(s)
  error('Size matrix is not numeric.');
end

%%Determine the type of size matrix
d=size(s);                  
switch length(d)
case 2  
  if (d(1)==1 && d(2)==1),
    % Each node gets the same, uniform scaling.
    s=s'; sx=s; sy=s;	
  elseif (d(1)==munits && d(2)==l),
    % Each vertex is scaled radially respetc to the 
    % node center.
    s=s'; sx=s; sy=s;          
  elseif d(1)==munits && d(2)==1  
    % Each node gets an individual uniform scaling.
    sx=repmat(s',l,1); sy=sx;
  else
    error('Size matrix has wrong size.');
  end
case 3  
  if d(1)==munits && d(2)==1 && d(3)==2,     
    % Each node is individually and uniformly 
    % scaled separately to x- and y-directions.
    sx=repmat(shiftdim(s(:,:,1))',l,1);   
    sy=repmat(shiftdim(s(:,:,2))',l,1);   
  elseif d(1)==munits && d(2)==l && d(3)==2,
    % Each vertex is scaled separately to x- and y-directions
    % with respect to the node center.
    sx=shiftdim(s(:,:,1))';                
    sy=shiftdim(s(:,:,2))';              
  else
    error('Size matrix has wrong size.');
  end
otherwise 
  error('Size matrix has too many dimensions.');
end

% Size zero would cause division by zero. eps is as good (node disappears)
% I tried first NaN, it works well otherwise, but the node is 
% then not on the axis and some commands may the work oddly. 
% The edge may be visible, though.

sx(sx==0)=eps;                    
sy(sy==0)=eps;                

% Rescale sizes for u-matrix
if planeType=='U', 
   sx=sx/2;sy=sy/2; 
end

%%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Making grid. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Translation for each patch

x=repmat(unit_coords(:,1)',l,1);
y=repmat(unit_coords(:,2)',l,1);

% patch vertex coordiantes 

nx=repmat(patchform(:,1),1,munits); 
ny=repmat(patchform(:,2),1,munits); 

% NB: The hexagons are not uniform in order to get even  
% y-coordinates for the nodes. This is handled by setting _axis scaling_ 
% so that the hexa-nodes look like uniform hexagonals. See 
% vis_PlaneAxisProperties

%% Make and scale the final input for PATCH:

% 1: combine translation and scaling of each patch 
x=(x./sx+nx).*sx; y=(y./sy+ny).*sy;  

%% 2: translation of origin (pos)
if ~isnan(pos)
   x=x+pos(1);y=y+pos(2);    % move upper left corner 
end                         % to pos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set axes properties  
%% Command view([0 90]) shows the map in 2D properly oriented

ax=newplot;                               % set new plot
vis_PlaneAxisProperties(ax,lattice,msize,pos);

%% Draw the map! 

if ~isnan(color)
   h_=patch(x,y,color);         
else
   h_=patch(x,y,'k');                     % empty grid 
   set(h_,'FaceColor','none');
end

%% Set object tag

if planeType=='U'
   set(h_,'Tag','planeU');                      
else
   set(h_,'Tag','planeC');
end	

%%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout>0, h=h_; end                   % Set h only, 
                                          % if there really is output

