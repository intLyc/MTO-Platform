function h=som_show(sMap, varargin)

% SOM_SHOW Basic SOM visualizations: component planes, u-matrix etc.
%
% h = som_show(sMap, ['argID', value, ...])
% 
%  som_show(sMap);
%  som_show(sMap,'bar','none');
%  som_show(sMap,'comp',[1:3],'umat','all');
%  som_show(sMap,'comp',[1 2],'umat',{[1 2],'1,2 only'},'comp',[3:6]);   
%  som_show(sMap,'size',m,'bar','vert','edge','off');
%
% Input and output arguments ([]'s are optional):
%  sMap        (struct) map struct
%  [argID,     (string) Additional parameters are given as argID, value
%    value]    (varies) pairs. See below for list of valid IDs and values.
%
%  h           (struct) struct with the following fields:
%   .plane     (vector) handles to the axes objecets (subplots)
%   .colorbar  (vector) handles to the colorbars. Colorbars for empty
%                       grids & RGB color planes do not exist: the
%                       value for them in the vector is -1.
%   .label     (vector) handles to the axis labels
%
% Here are the valid argument IDs and corresponding values. M is
% the number of map units
%  'comp'               Which component planes to draw, title is
%                       the name of the component (from sMap.comp_names) 
%              (vector) a vector of component indices
%              (string) 'all' (or '' or []) for all components
%  'compi'              as 'comp' but uses interpolated shading
%  'umat'               Show u-matrix calculated using specified 
%                       components 
%              (vector) a vector of component indeces
%              (string) 'all' (or '' or []) to use all components
%              (cell)   of form {v, str} uses v as the vector, and put
%                       str as title instead of the default 'U-matrix'
%  'umati'              as 'umat' but uses interpolated shading of colors 
%  'empty'     (string) Make an empty plane using given string as title
%  'color'              Set arbitrary unit colors explicitly  
%              (matrix) size Mx1 or Mx3, Mx1 matrix uses indexed
%                       coloring;  Mx3 matrix (RGB triples as rows)
%                       defines fixed unit colors
%              (cell)   of from {color, str}. 'color' is the Mx1
%                       or Mx3 RGB triple matrix and 'str' is title 
%                       string
%  'colori'             as 'color' but uses interpolated shading of colors 
%  'norm'      (string) 'n' or 'd': Whether to show normalized 'n' or 
%                       denormalized 'd' data values on the
%                       colorbar. By default denormalized values are used.
%  'bar'       (string) Colorbar direction: 'horiz', 'vert' (default)
%                       or 'none'
%  'size'               size of the units
%              (scalar) same size for each unit, default is 1
%              (vector) size Mx1, individual size for each unit
%  'edge'      (string) Unit edges on component planes 'on'
%                       (default) or 'off'
%  'footnote'  (string) Footnote string, sMap.name by default
%  'colormap'  (matrix) user defined colormap 
%  'subplots'  (vector) size 1 x 2, the number of subplots in y- and
%                       and x-directions (as in SUBPLOT command)
%
% If identifiers 'comp', 'compi', 'umat', 'umati', 'color', 'colori'
% or 'empty' are not specified at all, e.g. som_show(sMap) or
% som_show(sMap,'bar','none'), the U-matrix and all component planes
% are shown.
%
% For more help, try 'type som_show' or check out online documentation. 
% See also SOM_SHOW_ADD, SOM_SHOW_CLEAR, SOM_UMAT, SOM_CPLANE, SOM_GRID.

%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_show
%
% PURPOSE 
%
% Shows basic visualizations of SOM: component planes, unified distance
% matrices as well as empty planes and fixed color planes.
%
% SYNTAX
%
%  h = som_show(sMap)
%  h = som_show(sMap, 'argID', value, ...)
%
% DESCRIPTION 
%
% This function is used for basic visualization of the SOM. Four
% kinds of SOM planes can be shown: 
%
%  1. U-matrix (see SOM_UMAT) which shows clustering structure of
%     the SOM. Either all or just part of the components can 
%     be used in calculating the U-matrix.
%  2. component planes: each component plane shows the values of
%     one variable in each map unit
%  3. an empty plane which may be used as a base for, e.g., hit 
%     histogram visualization or labeling (see SOM_SHOW_ADD)
%  4. a fixed or indexed color representation for showing color coding or 
%     clustering
%
% The component planes and u-matrices may have colorbars showing the
% scale for the variable. The scale shows by default the values that
% variables have in the map struct. It may be changed to show the
% original data values (estimated by SOM_DENORMALIZE). In this case a
% small 'd' appears below the colorbar. The orientation of these
% colorbars may be changed, or they can be removed.
%
% By default the u-matrix - calculated using all variables - and all
% component planes are shown. This is achieved by giving command
% som_show(sMap) without any further arguments
%
% REQUIRED INPUT ARGUMENTS
%
% sMap  (struct) Map to be shown. If only this argument is
%                specified, the function draws first the u-matrix 
%                calculated using all the variables followed by all
%                the component planes.
%
% OPTIONAL INPUT ARGUMENTS
% 
% (M is the number of map units)
%
% Optional arguments must be given as 'argID',value -pairs
% 
% 'comp'      Defines the variabels to be shown as component planes.
%    (vector) 1xN or Nx1 vector with integer positive numbers ranging 
%             from 1 to the number of variables in the map codebook
%             (dim). This vector determines the variables to be show
%             as component planes and their order. Note that the same
%             component plane (the same variable index) is allowed to
%             occur several times.
%    (string) 'all' or '' or []. This uses all variables, that is, it's
%             the same that using value [1:dim] where dim is the
%             number of variables in the codebook.
%       
% 'compi'     Same as 'comp' but uses a Gouraud shaded color plane 
%             (made using SOM_GRID function) instead of the cell-like
%             visualization of 'comp' (made using SOM_CPLANE). Note
%             that the color interpolation doesn't work strictly
%             correctly on 'hexa' grid, as it uses rectangular grid
%             (see SURF).
% 
% 'umat'      Show U-matrix: value defines the variables to be used
%             for calculating a u-matrix.
%    (vector) as in 'comps'. However, multiple occurences of the
%             same variable (same variable index) are ignored. 
%    (string) 'all' or '' or []. This uses all variables, that is, 
%             is the same as using value [1:dim] where dim is the
%             number of variables in the codebook. 
%    (cell)   of form {v, str} where v is a valid index vector for 'umat' 
%             (see above) and str is a string that is used as a title 
%             for the u-matrix instead of the default title
%             'U-matrix'. This may be useful if several u-matrices
%             are shown in the same figure. 
% 
% 'umati'     Same as 'umat' but uses shaded color plane (see 'compi').
%
% 'empty'     Show an empty plane (patch edges only)
%    (string) value is used as title
% 
% 'color'     Define fixed RGB colors for the map units
%    (matrix) a Mx3 matrix of RGB triples as rows             
%    (vector) a Mx1 vector of any values: sets indexed coloring using
%             the current colormap (as SURF does)  
%    (matrix) a Mx3xN matrix of RGB triples as rows. This gives N
%             color planes.
%    (matrix) a Mx1xN matrix of any values: sets indexed coloring using
%             the current colormap (as SURF does). This gives N
%             color planes.
%    (cell)   of form {rgb, str} where rgb is a Mx3 (xN) matrix of RGB
%             triples as rows and str is a string that is used as
%             title(s).  
%    (cell)   of form {v, str} where v is a Mx1(xN) matrix of values
%             and str is a string that is used as title(s). 
%
% 'colori'    Same as 'color' but uses shaded color plane (see 'compi').
%
% 'norm'      Defines whether to use normalized or denormalized
%             values in the colorbar. If denormalized values are
%             used, they are acquired from SOM_DENORMALIZE function 
%             using sMap.comp_norm field.
%    (string) 'd' (default) for denormalized values and 'n' for
%             normalized values. The corresponding letter appears
%             below the colorbar.
%   
% 'bar'       Define the direction of the colorbars for component planes 
%             and U-matrices or turn them completely off.
%    (string) 'vert' (default), 'horiz' or 'none'. 'vert' gives
%             vertical and 'horiz' horizontal colorbars. 'none'
%             shows no colorbars at all. 
%
% 'size'      Define sizes of the units. 
%    (scalar) all units have the same size (1 by default)
%    (vector) size Mx1, each unit gets individual size scaling 
%             (as in SOM_CPLANE)
%
% 'edge'      Unit edges on component plane visualizations.
%    (string) 'on' or 'off' determines whether the unit edges on component 
%             planes ('comp') are shown or not. Default is 'off'. Note that
%             U-matrix and color planes are _always_ drawn without edges.
%
% 'footnote'  Text on the figure
%    (string) is printed as a movable text object on the figure
%             where it may be moved using mouse. Default value is the
%             string in the sMap.name field. Note: value [] gives the
%             string, but input value '' gives no footnote a all. 
%             See VIS_FOOTNOTE for more information on the text object 
%             and ways to change its font size.
% 
% 'colormap'  som_show ghages the colormap by default to a gray-level map
%    (matrix) This argument is used to set some other colormap. 
%
% 'subplots'  the number of subplots in y- and x-directions, as in 
%    (vector) command SUBPLOT
% 
% OUTPUT ARGUMENTS
%
% h (struct)
%    .plane         (vector) handles to the axes objects (subplots)
%    .colorbar      (vector) handles to the colorbars. Colorbars of empty
%                            & color planes do not exist: the corresponding
%                            value in the vector is -1
%    .label         (vector) handles to the axis labels
%
% OBJECT TAGS
%
% The property field 'Tag' of the axis objects created by this function 
% are set to contain string 'Cplane' if the axis contains component plane
% ('comp'), color plane ('color') or empty plane ('empty') and string
% 'Uplane' if it contains a u-matrix ('umat'). The tag is set to 
% 'CplaneI' for planes created using 'compi' and 'colori', and 
% 'UplaneI' for 'umati'.
%
% FEATURES
%
% Note that when interpolated shading is used in coloring ('compi' and
% 'colori') the standard built-in bilinear Gouraud interpolation for a 
% SURF object is used. If the lattice is hexagonal - or anything else than 
% rectangular in general - the result is not strictly what is looked 
% for, especially if the map is small. 
%
% EXAMPLES
%
%% Make random data, normalize it, and give component names
%% Make a map
%
%   data=som_data_struct(rand(1000,3),'comp_names',{'One','Two','Three'});
%   data=som_normalize(data,'var');
%   map=som_make(data);
%
%% Do the basic visualization with som_show: u-matrix and all
%% component planes
%
%   som_show(map);   
%
%% The values shown in the colorbar are denormalized codebook values 
%% (if denormalization is possible). To view the actual values, use
%% the ..., 'norm', 'n' argument pair.
%
%   som_show(map,'norm','n')
%
%% Something more complex:
%% Show 1-2. Component planes 1 and 2 (variables 'One' and 'Two')
%%        3. U-matrix that is calculated only using variables
%%           'One' and 'Two' 
%%           with title '1,2 only'
%%        4. U-matrix that is calculated using all variables with the 
%%           deafult title 'U-matrix'
%%        5. The color code (in c) with title 'Color code'
%%        6. Component plane 3 (variable 'Three')
%% and  use vertical colorbars and and the values      
%% But first: make a continuous color code (see som_colorcode)
%
% c=som_colorcode(map,'rgb1');
% 
% som_show(map,'comp',[1 2],'umat',{1:2,'1,2 only'},'umat','all', ...
%  'color',{c,'Color code'},'bar','vert','norm','n','comp',3)
%
%  SEE ALSO
%
% som_show_add   Show hits, labels and trajectories on SOM_SHOW visualization.
% som_show_clear Clear hit marks, labels or trajectories from current figure. 
% som_umat       Compute unified distance matrix of self-organizing map.
% som_grid       Visualization of a SOM grid.
% som_cplane     Visualization of component, u-matrix and color planes.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 1.0beta johan 100298 
% Version 2.0beta johan 201099 juuso 181199 johan 011299-100200
%                 juuso 130300 190600

%% Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,Inf)     % check no. of input args

if isstruct(sMap),               % check map
  [~,ok,~]=som_set(sMap);
  if all(ok) && strcmp(sMap.type,'som_map') 
  else
    error('Map struct is invalid!');
  end
else
  error('Requires a map struct!')
end

munits=size(sMap.codebook,1); % numb. of map units
d=size(sMap.codebook,2);      % numb. of components
msize=sMap.topol.msize;       % size of the map
lattice=sMap.topol.lattice;   % lattice

if length(msize)>2 
  error('This visualizes only 2D maps!')
end

if rem(length(varargin),2)
  error('Mismatch in identifier-value  pairs.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  read in optional arguments
 
if isempty(varargin),
  varargin = { 'umat','all','comp','all'};
end

%% check the varargin and build visualization infostrcuts
% Vis:       what kind of planes, in which order, what are the values in
%            the units
% Vis_param: general properties
% see subfunction

% The try-catch construction is here just for avoiding the
% possible termination to happen in subfunction because an error
% message containing subfunction line numbers etc. might be confusing, as
% there probably is nothing wrong with the subfunction but with the 
% input. Ok, this isn't proper programming sytle... 

try       
  [Plane, General]= check_varargin(varargin, munits, d, sMap.name);
catch err
  error(err);
end

% Set default values for missing ones

% No planes at all (only general properties given in varargin):
% set default visualization

if isempty(Plane)
  varargin = [varargin, { 'umat','all','comp','all'}];
  % and again we go...
  try
    [Plane, General]= check_varargin(varargin, munits, d, sMap.name);
  catch err
    error(err);
  end
end

% set defaults for general properties

if isempty(General.colorbardir)
  General.colorbardir='vert';
end

if isempty(General.scale)
  General.scale='denormalized';
end

if isempty(General.size)
  General.size=1;
end

if isempty(General.edgecolor)
  General.edgecolor='none';
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get rid of an annoying warning: "RGB color data not yet supported in
% Painter's mode."
%set(gcf, 'renderer','zbuffer'); 
%% -> a much more annoying thing results: the output to PostScript is 
%%    as bitmap, making the files over 6MB in size... 

n=length(Plane);                     % the number of subfigures

% get the unique component indices
c=General.comp(General.comp>0);
c=setdiff(unique(c),[0 -1]); 
c=c(~isnan(c));                   

% estimate the suitable dimension for
if isempty(General.subplots), 
  y=ceil(sqrt(n));                   % subplots
  x=ceil(n/y);
else
  y = General.subplots(2); 
  x = General.subplots(1); 
  if y*x<n, 
    error(['Given subplots grid size is too small: should be >=' num2str(n)]); 
  end    
end

clf;                               % clear figure

for i=1:n,                         % main loop
  h_axes(i,1)=subplot(x,y,i);      % open a new subplot
  
  % Main switch: select function according to the flags set in comps  

  switch Plane{i}.mode
  
  case 'comp'
    %%% Component plane

    tmp_h=som_cplane(lattice,msize, sMap.codebook(:,General.comp(i)), ...
		     General.size);
    set(tmp_h,'EdgeColor', General.edgecolor);
    set(h_axes(i),'Tag','Cplane');
    h_label(i,1)=xlabel(sMap.comp_names{General.comp(i)});
    

  case 'compi'
    %%% Component plane (interpolated shading)
    
    tmp_h=som_grid(lattice, msize, 'surf', sMap.codebook(:,Plane{i}.value), ...
	'Marker', 'none', 'Line', 'none');
    set(h_axes(i),'Tag','CplaneI');
    h_label(i,1)=xlabel(sMap.comp_names(Plane{i}.value));
    vis_PlaneAxisProperties(gca,lattice,msize,NaN);
  
  case 'color'
    %%% Color plane

    tmp_h=som_cplane(lattice,msize,Plane{i}.value,General.size);
    set(tmp_h,'EdgeColor','none');
    set(h_axes(i),'Tag','Cplane');
    h_label(i,1)=xlabel(Plane{i}.name);
    
      
  case 'colori'
    %%% Color plane (interpolated shading)
    
    tmp_h=som_grid(lattice, msize, 'surf', Plane{i}.value, 'Marker', 'none', ...
	'Line', 'none');
    set(h_axes(i),'Tag','CplaneI');
    h_label(i,1)=xlabel(Plane{i}.name);
    vis_PlaneAxisProperties(gca,lattice,msize,NaN);
  
  case 'empty'      
    %%% Empty plane
    
    tmp_h=som_cplane(lattice,msize,'none');
    h_label(i,1)=xlabel(Plane{i}.name);
    set(h_axes(i),'Tag','Cplane');
    
  case 'umat'
    %%% Umatrix  
    
    u=som_umat(sMap.codebook(:,Plane{i}.value),sMap.topol,'median',...
	'mask',sMap.mask(Plane{i}.value)); u=u(:);
    tmp_h=som_cplane([lattice 'U'],msize,u);
    set(tmp_h,'EdgeColor','none');
    set(h_axes(i),'Tag','Uplane');
    h_label(i,1)=xlabel(Plane{i}.name);

  case 'umati'
    %%% Umatrix (interpolated shading) 
    
    u=som_umat(sMap.codebook(:,Plane{i}.value),sMap.topol,'mean',...
	'mask',sMap.mask(Plane{i}.value)); u=u(1:2:end,1:2:end);
    u=u(:);
    tmp_h=som_grid('rect', msize, 'surf', u, ...
	'Marker', 'none', 'Line', 'none', ...
	'coord', som_vis_coords(lattice,msize));
    set(h_axes(i),'Tag','UplaneI');
    h_label(i,1)=xlabel(Plane{i}.name);
    vis_PlaneAxisProperties(gca,lattice,msize,NaN);
    
  otherwise
    error('INTERNAL ERROR: unknown visualization mode.');
  end

  %%% Adjust axis ratios to optimal (only 2D!) and put the
  %%% title as close to axis as possible

  set(h_label,'Visible','on','verticalalignment','top');
  set(gca,'plotboxaspectratio',[msize(2) msize(1) msize(1)]);
  
  %%% Draw colorbars if they are turned on and the plane is umat or c-plane

  if General.comp(i)> -1 && ~strcmp(General.colorbardir,'none'),
    h_colorbar(i,1)=colorbar(General.colorbardir);           % colorbars
  else
    %COMPATIBILITY HACK: This if...else... structure fixes a compatibility
    %problem. In versions of MATLAB prior to 2014b colorbars returned a
    %numeric handle. From 2014b onwards they return a structure, and they
    %break backwards compatibility. At some point the numeric compatibility
    %should be dropped, but for the time being this is a necessary small hack.
    if verLessThan('matlab','8.4')
        h_colorbar(i,1)=-1;
    else
        h_colorbar(i,1)=colorbar(General.colorbardir);           % colorbars
        h_colorbar(i,1).Visible='off';
    end
    %END OF COMPATIBILITY HACK
    General.comp(i)=-1;
  end
end         %% main loop ends
  
% Set window name

set(gcf,'Name',[ 'Map name: ' sMap.name]);

%% Set axes handles to the UserData field (for som_addxxx functions
%% and som_recolorbar) 
%% set component indexes and normalization struct for som_recolorbar

SOM_SHOW.subplotorder=h_axes;
SOM_SHOW.msize=msize;
SOM_SHOW.lattice=lattice;
SOM_SHOW.dim=d;
SOM_SHOW.comps=General.comp;
SOM_SHOW.comp_norm=sMap.comp_norm; %(General.comp(find(General.comp>0)));

set(gcf,'UserData', SOM_SHOW);

% Set text property 'interp' to 'none' in title texts

set(h_label,'interpreter','none');

h_colorbar=som_recolorbar('all', 3, General.scale);   %refresh colorbars

% Set a movable text to lower corner pointsize 12.

vis_footnote(General.footnote);  vis_footnote(12);  

% set colormap
colormap(General.colormap);

%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

if nargout > 0
  h.plane=h_axes; h.colorbar=h_colorbar; h.label=h_label;
end


%%%%%% SUBFUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Plane, General]=check_varargin(args, munits, dim, name)

% args: varargin of the main function
% munits: number of map units
% dim: map codebook dimension
% name: map name
% Define some variables (they must exist later)

Plane={};           % stores the visualization data for each subplot
General.comp=[];    % information stored on SOM_SHOW figure (which component)
General.size=[];            % unit size
General.scale=[];           % normalization
General.colorbardir=[];     % colorbar direction
General.edgecolor=[];       % edge colors
General.footnote=name;      % footnote text
General.colormap=colormap;  % default colormap (used to be gray(64).^.5;)
General.subplots=[];        % number of subplots in y- and x-directions

for i=1:2:length(args),
  %% Check that all argument types are strings
  
  if ~ischar(args{i}),
    error('Invalid input identifier names or input argument order.');
  end
  
  %% Lower/uppercase in identifier types doesn't matter: 
  
  identifier=lower(args{i});     % identifier (lowercase)
  value=args{i+1};
  
  %%% Check first the identifiers that define planes and get values
  %%% to the visualization data struct array Plane.
  %%% (comps,compi,umat,color,empty) Note that name, value and comp_
  %%% must be specified in these cases 
  %%% comp_ are collected to comp in order. This is stored to the
  %%% SOM_SHOW user property field to give information for SOM_RECOLROBAR
  %%% how to operate, i.e., which component is in which subplot:
  %%% comp(i)=0: draw colorbar, but no normalization (umat) 
  %%% comp(i)=1...N: a component plane of variable comp(i)
  %%% comp(i)=-1: no colorbar (color or empty plane)    
  
  switch identifier  
   case {'comp','compi'}
    %%% Component planes: check values & set defaults
    
    if ~vis_valuetype(value,{'nx1','1xn','string'}) && ~isempty(value),
      error([ 'A vector argument or string ''all'' expected for ''' ...
	      identifier '''.'])
    end
    if isempty(value) 
      value=1:dim;
    elseif ischar(value), 
      if ~strcmp(value,'all')
	error([ 'Only string value ''all'' is valid for ''' ...
		identifier '''.']);
      else
	value=1:dim;
      end
    else
      value=round(value);
      if min(value)<1 || max(value)>dim,
	error([ 'Component indices out of range in ''' identifier '''.']) 
      end
    end
    if size(value,1)==1, value=value';end
    comp_=value; 
    name=[]; % name is taken form sMap by index in main loop 
    
  case {'umat','umati'}
    %%% Check first the possible cell input
    
    if iscell(value),
      if ~ismatrix(value) || any(size(value) ~= [1 2]) || ...
	    ~vis_valuetype(value{2},{'string'}),
	error('Cell input for ''umat'' has to be of form {vector, string}.');
      else
	name=value{2}; value=value{1};
      end
    else 
      name='U-matrix'; % no cell: default title is set
    end
    if ~vis_valuetype(value,{'nx1','1xn','string'}) && ~isempty(value),
      error('Vector, string ''all'', or cell {vector, string} expected for ''umat''.')
    end
    if isempty(value)
      value=1:dim;
    elseif ischar(value), 
      if ~strcmp(value,'all')
	error('Only string value ''all'' is valid for ''umat''.')
      else
	value=1:dim;
      end
    else
      value=unique(round(value));
    end
    if min(value)<1 || max(value)>dim,
      error('Component indices out of range in ''umat''.') 
    end
    
    if size(value,1)==1, value=value';end
    comp_=0;
    
  case 'empty'
    %%% Empty plane: check values & set defaults
    
    if ~vis_valuetype(value,{'string'}), 
      error('A string value for title name expected for ''empty''.');
    end
    name=value;
    comp_=-1;
    
  case { 'color','colori'}
    %%% Color plane: check values & set defaults
    
    % Check first the possible cell input
    if iscell(value),
      if ~ismatrix(value) || any(size(value) ~= [1 2]) || ...
	    ~vis_valuetype(value{2},{'string'}),
	error([ 'Cell input for ''' identifier ...
	      ''' has to be of form {M, string}.']);
      else
	name=value{2}; value=value{1};
      end
    else 
      name='Color code'; % no cell: default title is set
    end
    if size(value,1)~=munits || ...
	  (~vis_valuetype(value,{'nx3rgb'}) && ... 
	   ~vis_valuetype(value,{'nx1'}) && ...
	   ~vis_valuetype(value,{'nx1xm'}) && ...
	   ~vis_valuetype(value,{'nx3xdimrgb'})),
      error(['Mx3 or Mx3xN RGBmatrix, Mx1 or Mx1xN matrix, cell '...
	     '{RGBmatrix, string},' ...
	     ' or {matrix, string} expected for ''' identifier '''.']);
    end

    % if colormap is fixed, we don't draw colorbar (comp_ flag is -1)
    % if colormap is indexed, we draw colorbar as in umat (comp_=0)

    if size(value,2)==3
      comp_=-1;
    else
      comp_=0;
    end
    
    %%%% The next things are general properties of the visualization---
    %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  case 'size'
    %%% Unit size: check & set
  
    if ~vis_valuetype(value,{'1x1',[munits 1]})
      error('A munits x 1 vector or a scalar expected for ''size''.')
    end
    if isempty(value),
      General.size=1;
    else
      General.size=value;
    end
    
   case 'bar'
    %%% Colorbar existence & direction: check & set
    
    if ~vis_valuetype(value,{'string'})
      error('String value expected for ''bar''.')
    elseif isempty(value)
      value='vert';
    end
    if any(strcmp(value,{'vert','horiz','none'})),
      General.colorbardir=value;
    else
      error('String ''vert'', ''horiz'' or ''none'' expected for ''bar''.');
    end
    
  case 'norm' 
    %%% Value normalization: check & set
    
    if ~vis_valuetype(value,{'string'})
      error('String ''n'' or ''d'' expected for ''norm''.');
    elseif isempty(value)
      value='n';
    end
    if strcmp(value(1),'n'), 
      General.scale='normalized';
    elseif strcmp(value(1),'d'),
      General.scale='denormalized';
    else
      error('String ''n(ormalized)'' or ''d(enormalized)'' expected for ''norm''.');
    end
    
  case 'edge'
    %%% Edge on or off : check % set 
    
    if ~vis_valuetype(value,{'string'}) && ~isempty(value),
      error('String value expected for ''edge''.')
    elseif ~isempty(value),
      switch value
      case 'on'
	General.edgecolor='k';
      case 'off' 
	General.edgecolor='none';
      otherwise
	error('String value ''on'' or ''off'' expected for ''edge''.')  
      end
    end
    
  case 'footnote'
    %%% Set the movable footnote text  
    
    if ~vis_valuetype(value,{'string'}) 
      if ~isempty(value),
	error('String value expected for ''footnote''.');
      else
	General.footnote=sMap.name;
      end
    else
      General.footnote=value;
    end

   case 'colormap'
    %%% Set the colormap
    if isempty(value)
      General.colormap=gray(64).^2;
    elseif ~vis_valuetype(value,{'nx3rgb'})
      error('Colormap is invalid!');
    else
      General.colormap=value;
    end
    
   case 'subplots'
    %%% set the number of subplots
    if ~vis_valuetype(value,{'1x2'}) && ~vis_valuetype(value,{'2x1'})
      error('Subplots grid size is invalid!');
    else
      General.subplots=value; 
    end
    
  otherwise
    %%% Unknown identifier
    
    error(['Invalid argument identifier ''' identifier '''!']);
  end
  
  %%% Set new entry to the Plane array if the indentifier means 
  %%% making a new plane/planes
  
  tail=length(Plane);
  switch identifier
  case {'comp','compi'}
    for i=1:length(value)
      Plane{tail+i}.mode=identifier;
      Plane{tail+i}.value=value(i);
      Plane{tail+i}.name=name; % not used actually
    end
    General.comp = [General.comp; comp_];
   case {'umat','umati','empty'}
    Plane{tail+1}.mode=identifier;
    Plane{tail+1}.value=value;
    Plane{tail+1}.name=name;
    General.comp = [General.comp; comp_];
  case {'color','colori'},
    for i=1:size(value,3),
      Plane{tail+i}.mode=identifier;
      Plane{tail+i}.name=[name '_' num2str(i)];
      Plane{tail+i}.value=value(:,:,i);
      General.comp = [General.comp; comp_];
    end
    if size(value,3)==1,
      Plane{tail+1}.name=name;
    end
  otherwise
    % do nothing
  end
end
