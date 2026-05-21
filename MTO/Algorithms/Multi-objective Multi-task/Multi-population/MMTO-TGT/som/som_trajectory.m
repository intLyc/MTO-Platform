function som_trajectory(bmus,varargin)

%SOM_TRAJECTORY Launch a "comet" trajectory visualization GUI.
%
%  som_show(sM,'umat','all')
%  bmus = som_bmus(sM,sD);
%  som_trajectory(bmus)
%  som_trajectory(bmus, 'data1', sD, 'trajsize', [12 6 3 1]')
%  som_trajectory(bmus, 'data1', sD.data(:,[1 2 3]), 'name1', {'fii' 'faa' 'foo'})
%
% Input arguments ([]'s are optional):
%   bmus      (matrix) size Nx1, vector of BMUS
%   ['argID', (string) Other arguments can be given as 'argID', value   
%    value]   (varies) pairs. See list below for valid values.
%
% NOTE: the GUI only works on a figure which has been made with SOM_SHOW.
%
% Here are the valid argument IDs (case insensitive) and associated values: 
%  'color'      string 'xor' or ColorSpec, default: 'xor'. 
%               (default: according to lattice as in som_cplane)
%  'TrajSize'   vector of size Nx1 to define the length of comet
%               (N) and size of the comet dots in points. 
%               default: [16 12 10 8 6 4]' 
%  'Data1'      SOM Toolbox data struct or matrix. The size of
%               data matrix (in data struct the field .data) is
%               Nxd, where N must be the same as the amount of
%               BMUS given in the first input argument 'bmus'
%               This data is shown in a new window in d subplots.
%               Default: BMU indices (first input argument)
%  'Name1'      cell array of d strings which contains names
%               for the components in 'Data1'. If 'Data1' is a SOM
%               Toolbox data struct, the existing component names 
%               are overdone.                 
%  'Figure'     scalar that must be a handle to an existing figure
%               which has been made using SOM_SHOW function.
%               Default: current active figure (gcf).
%
% The following tools can be found in the 'Tools' -menu.
%
%  Remove Trajectory: removes trajectory from the map.
%  Dye Nodes        : opens GUI for selecting color for the nodes
%                     and points selected.
%  Clear Markers    : removes markers from map and data figure.
%  Save             : saves the current situation as a struct.
%  Load             : loads the struct from workspace and draws markers.
%
% Mouse operation
%
%  In data window: Left button is used to drag the operation point ruler  
%                  if left button is on blank area, it starts 
%  In map window : Left button starts a polygon; right button
%                  finishes; middle button toggles a unit.
%
% SOM_TRAJECTORY is an application for observing trajectory behavior.
%
% Using mouse the line in data figure can be dragged and the
% trajectory moves in the SOM SHOW figure. It is also possible to move
% trajectory by pressing keys '>' and '<' when mouse pointer is above
% data figure.
% 
% Regions can be chosen from the data and the points in that region
% are mapped to the component planes. Regions can be chosen also in
% the map.  In this situation data points and map nodes are also
% marked (Left mouse button adds point to the polygon indicating the
% region and right button finals the polygon). By clicking a node (the
% middle button) that node is either added or removed from selection.
% 
% It should be noticed that choosing intervals from data may cause
% situations that seem to be bugs. If there exisist marks of different
% color, removing them by clicking the map may left some marks in the
% data, because more than one point in the data is mapped to the same
% node in the map and the removing operation depends on the color of
% the marks. However, all the marks can be removed by using the 'Clear
% Markers' -operation.
%
% FEATURES
%
% The first input argument 'bmus' may also be a munits x N matrix
% In this case each column defines a "fuzzy response". That is,
% each column defines a hit histogram function). The element
% bmus(i,t) sets the size of marker on unit i at time t. 
% NOTE: - in this case no regions can be selcted on the map!
%       - only > and < keys can be used to move the operation point
%         line: it can't be dragged
%       - "fuzzy response is always black (hope this will be fixed) 
%       
% It is possible to open a second data window showing different data:
% use indetifiers 'Data2' (and 'Name2'). The argument syntax is
% identical to 'Data1' (and 'Name1').
%
% See also SOM_SHOW, SOM_SHOW_ADD, SOM_BMUS. 

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Johan
% Himberg and Juha Parhankangas
% Copyright (c) 2000 by the Johan Himberg and Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/        

% Check arguments

error(nargchk(1,Inf,nargin)); % Check no. of input arguments

%% Init input argument struct (see subfunction)
Traj=iniTraj(bmus);

% Check tentative BMU input validity

if ~vis_valuetype(bmus,{'nxm'}),
  error(['First input should be a vector of BMU indices or' ...
	 ' a "response matrix"']);
end

%% Check optional arguments
for i=1:2:length(varargin)
  identifier=lower(varargin{i});
  value=varargin{i+1};

  % Trajectory color
  switch identifier  
   case 'color'
    if isempty(value)
      value='xor';
    end
    if vis_valuetype(value,{'colorstyle','xor'})
      Traj.color=value;
    else
      error('''Color'' has to be ColorSpec or string ''xor''.');
    end
   
   % 1st data  
   case 'data1'
    if isempty(value),
      value=[];
    elseif vis_valuetype(value,{'nxm'})
      Traj.primary_data=value;
    elseif isstruct(value) && isfield(value,'type') && ...
	  ischar(value.type) && strcmp(value.type,'som_data'),
      Traj.primary_data=value.data;
      if isempty(Traj.primary_names),
	Traj.primary_names=value.comp_names;
      end
    end
   
    % 2nd data
   case 'data2'
    if isempty(value),
      value=[];
    elseif vis_valuetype(value,{'nxm'})
      Traj.secondary_data=value;
    elseif isstruct(value) && isfield(value,'type') && ...
	  ischar(value.type) && strcmp(value.type,'som_data'),
      Traj.secondary_data=value.data;
      if isempty(Traj.secondary_names),
	Traj.secondary_names=value.comp_names;
      end
     end
   
   % Trajectory length & size
   case 'trajsize'
    if isempty(value),
      Traj.size=[16 12 10 8 6 4]';
    end
    if vis_valuetype(value,{'nx1'})
      Traj.size=value
    else
      error('''TrajSize'' has to be a nx1 vector.');
    end
   
   % Names for first data variables
   case 'name1'
    if isempty(value),
      Traj.primary_names=[];
    elseif ~vis_valuetype(value,{'cellcolumn_of_char'}),
      error('''Name1'': variable names must be in a cell column array.') 
    else
      Traj.primary_names = value;
    end
   % Names for 2nd data variables
   case 'name2'
    if isempty(value),
      Traj.secondary_names=[];
    elseif ~vis_valuetype(value,{'cellcolumn_of_char'}),
      error('''Name2'': variable names must be in a cell column array.') 
    else
      Traj.secondary_names = value;
    end
   
   % Figure number
   case 'figure'
    if isempty(value)
      Traj.figure='gcf';
    end
    if vis_valuetype(value,{'1x1'})
      Traj.figure=value;
    else
      error('''Figure'' should be number of an existing figure.')
    end
  end
end

%% Get SOM data from figure
[h,msg,lattice,msize,dim]=vis_som_show_data('all',Traj.figure);

%% Not a SOM_SHOW figure?
if ~isempty(msg);
  error('Figure is invalid: use SOM_SHOW to draw the figure.');
end

% Get map size from figure data
Traj.lattice=lattice; 
Traj.msize=msize;  
if length(msize)>2,
  error(['This function works only with 2D maps: figure contains' ...
	 ' something else.']);
end
munits=prod(msize);

% Check BMU (or response) and map match 

if vis_valuetype(bmus,{'nx1'});
  if max(bmus)>prod(msize) || min(bmus) <1
    error('BMU indexes out of range.')
  elseif any(round(bmus)~=bmus)
    error('BMU indexes must be integer.');
  elseif isempty(Traj.primary_data),
    Traj.primary_data=bmus;
  end
elseif size(bmus,1) ~= munits 
  error(['Response matrix column number must match with the number of' ...
	 ' map units.']);
else
  bmus=bmus';
  if isempty(Traj.primary_data),
    Traj.primary_data=[1:size(bmus,1)]';
    Traj.primary_names={'BMU Index'};
  end
end

size1=size(Traj.primary_data);
size2=size(Traj.secondary_data);

% Data2 must not be defined alone

if isempty(Traj.primary_data)&&~isempty(Traj.secondary_data),
  error('If ''Data2'' is specified ''Data1'' must be specified, too.');
elseif ~isempty(Traj.secondary_data) ...
      && size1~= size2
  % If data1 and data2 exist both, check data1 and data2 match
  error('''Data1'' and ''Data2'' have different amount of data vectors.')
end

% Check BMU and data1 match (data2 matches with 1 anyway)

if ~isempty(Traj.primary_data) && size(bmus,1) ~= size1,
  error(['The number of data vectors in ''data1'' must match with' ...
	 ' the number of rows in the first input argument (bmus).']);
end

% Check that number of names and data dimension is consistent

if ~isempty(Traj.primary_names) && (size1(2)~=length(Traj.primary_names)),
  error('Number of component names and ''Data1'' dimension mismatch.');
end
if ~isempty(Traj.secondary_names) && ...
      (size2(2)~=length(Traj.secondary_names)),
  error('Number of component names and ''Data2'' dimension mismatch.');
end

%% Call the function that does the job
vis_trajgui(Traj);

%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Traj=iniTraj(bmus)

Traj.figure=gcf;
Traj.primary_data=[];
Traj.secondary_data=[];
Traj.primary_names = [];  
Traj.secondary_names = [];  
Traj.size=[16 12 10 8 6 4]';
Traj.bmus=bmus;
Traj.color='xor';
Traj.msize=[];
Traj.lattice=[];

