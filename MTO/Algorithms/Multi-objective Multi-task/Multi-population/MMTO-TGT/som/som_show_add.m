function h=som_show_add(mode,D,varargin)

%SOM_SHOW_ADD Shows hits, labels and trajectories on SOM_SHOW visualization
%
% h = som_show_add(mode, D, ['argID',value,...])
%
%  som_show_add('label',sMap)
%  som_show_add('hit',som_hits(sMap,sD))
%  som_show_add('traj',som_bmus(sMap,sD))
%  som_show_add('comet',som_bmus(sMap,sD))
%  som_show_add('comet',inds, 'markersize', [1 0.2])
% 
%  Input and output arguments ([]'s are optional): 
%   mode    (string) operation mode 'label', 'hit', 'traj', 'comet'
%   D       (varies) depending on operation mode
%      In 'label' mode gives the labels  
%           (struct) map struct, the .labels field of which is used
%           (cell array of strings) size munits x number_of_labels
%      In 'hit' mode gives the hit histogram(s)
%           (matrix) size munits x k, if k>1, D gives hit histograms 
%                    for k different sets of data (e.g. k classes).     
%      In 'traj' and 'comet' modes gives the trace of the trajectory
%           (vector) size N x 1, D(1) is the current and D(end) 
%                    is oldest item of the trajectory
%   [argID, (string) Additional arguments are given as argID, value
%    value] (varies) pairs. Depend on the operation mode (see below).                   
%
%   h    (vector)    handles to the created objects
%
% Here are the valid argument IDs and corresponding values. Most of 
% them depend on the operation mode: 
%
% all modes
%   'SubPlot'   (vector) which subplots are affected (default: current)
%               (string) 'all': all subplots are affected 
% mode = 'label'
%   'TextSize'  (scalar) text size in points
%   'TextColor' (string) ColorSpec, 'xor' or 'none': label color 
%
% mode = 'hit'
%   'EdgeColor'  (string) ColorSpec, 'none' 
%   'MarkerSize' (scalar) maximum marker size
%  if k == 1, 
%   'Marker'     (string) 'lattice', Matlab's built-in markerstyles, 'none'
%   'MarkerColor'(string) Colorspec, 'none': fill color for markers
%   'Text'       (string) 'on', 'off':  whether to write the number of hits
%   'TextColor'  (string) ColorSpec, 'xor': text color if Text is 'on'
%   'TextSize'   (scalar) text font size in points if Text is 'on'
%  if k > 1, 
%   'SizeFactor' (string) 'common', 'separate': size scaling
%   'Marker'     (string) 'lattice', Matlab's built-in markerstyles, 'pie', 'none' 
%                (cell array) size k x 1, marker style for each histogram
%   'MarkerColor'(string) Colorspec, 'none': fill color for markers
%                (matrix) size k x 3, color for each histogram
%
% mode = 'traj'
%   'TrajWidth'  (scalar) basic trajectory line width in points
%   'WidthFactor'(string) 'hit' or 'equal': effect of hits on line width 
%   'TrajColor'  (string) ColorSpec, 'xor': color for trajectory line
%   'Marker'     (string) 'lattice', Matlab's built-in markerstyles, 'none'
%   'MarkerSize' (scalar) basic marker size (in points)
%   'SizeFactor' (string) 'equal', 'hit' (equal size/size depends on freq.) 
%   'MarkerColor'(string) Colorspec, 'none': color of markers
%   'EdgeColor'  (string) ColorSpec, 'none': edgecolor of markers 
%
% mode = 'comet'
%   'Marker'     (string) 'lattice', Matlab's built-in markerstyles
%   'MarkerColor'(string) ColorSpec, 'none': color for the markers
%                (matrix) size N x 3, RGB color for each step 
%   'EdgeColor'  (string) ColorSpec, 'none': edgecolor for markers
%   'MarkerSize' (vector) size 1 x 2, size of comet core and tail
% 
% For more help, try 'type som_show_add' or check out online documentation.
% See also SOM_SHOW.

%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_show_add 
%
% PURPOSE 
%
%  Shows hits, labels and trajectories on SOM_SHOW visualization
%
% SYNTAX
%
%  h = som_show_add(mode, D); 
%  h = som_show_add(..., 'argID', value);
%
% DESCRIPTION 
%
% The SOM_SHOW function makes the basic visualization of the SOM.
% With SOM_SHOW_ADD one can set labels, hit histogarms or different 
% trajectories on this visualization.
%
%  labels (mode = 'label')
%
% Labels are strings describing the units. They may be, e.g., a result
% of SOM_AUTOLABEL function. Labels are centered on the unit so that
% multiple labels are in a column.
%
%  hit histograms (mode = 'hit')
%
% Hit histograms indicate how the best matching units of a data
% set/some data sets are distribited on a SOM. The hit histogram can
% be calculated using function SOM_HITS.
%
%  trajectories (mode = 'traj' or mode = 'comet')
%
% Trajectories show the best matching units for a data set that is
% time (or any ordered) series. It may be either a line connecting the
% consecutive best matching units ('traj' mode) or a "comet"
% trajectory where the current (first sample in D) best matching unit
% has biggest marker and the oldest (last sample) has smallest
% marker ('comet' mode).
%
% NOTE: that the SOM_SHOW_ADD function can only be applied to
% figures that have been drawn by SOM_SHOW.
% 
% KNOWN BUGS
%
% for 'hit' mode, if the given hit matrix is all zeros, a series of 
% error messages is generated
% 
% REQUIRED INPUT ARGUMENTS
%
% mode     (string) Visuzalization mode 
%                   'label'  map labeling
%                   'hit'    hit histograms
%                   'traj'   line style trajectory
%                   'comet'  comet style trajectory 
%
% D (vector, map struct, cell array of strings) Data
%
% The valid value of D depends on the visualization mode:
%
%  Mode       Valid D
%  'label'    map struct or Mxl cell array of strings, where
%              M is number of map units and l maximum numer of
%              labels in unit.
%
%  'hit'      Mx1 vector or MxK matrix, where M is number of map
%             units and K is number of hit histograms (of K
%             different classes of data) to be shown
%
%  'comet'    Lx1 vector of best matchig unit indices that have to
%  'traj'     be in range of the map that is in the figure. L is 
%             the length of trajectory
%             
% OPTIONAL INPUT ARGUMENTS
%
% Optional arguments must be given as 'argument identifier', value
% -pairs. This section is divided in four parts because each mode
% functions in a different way, though they may have same identifier
% names.
%
% If user specifies an identifier that is not operational in the
% specified mode, the functions gives a warning message. If the
% identifier does not exist in any mode the execution is terminated
% and an error message is returned.
%
% GENERAL OPTIONAL INPUT ARGUMENTS (in all modes)
%
% 'SubPlot'     Target subplots in the figure    
%      (vector) Subplots' ordinal numbers in a vector. By default
%               the target is the current subplot (see GCA).
%      (string) String 'all' means all subplots. 
%
% 'Marker'      Data marker (not in use in 'label' mode)
%      (string) 'none': sets the markers off
%               'lattice': sets the marker shape according to the
%                lattice of the underlying map, i.e. it gives
%                rectangles if underlying map lattice is 'rect' and
%                hexagons for 'hexa', respectively
%               any of the Matlab's built-in marker styles: 'o', 's',
%               'd', 'v', '^', '<' ,'> ', 'p', 'h', 'x', '.', '*', '+'
%      
%               NOTE that '.','x','+' or '*' are not recommended since
%               they have only edgecolor and many visualizations are 
%               based on _face_ color. 
%
%               NOTE there is an important difference between built-in
%               markers. If figure size is changed the 'lattice'
%               markers are rescaled but the built-in markers stay at
%               fixed size, and consequently, the size unit for
%               'lattice' markers is normalized but for built-in
%               markers the size is given in points. For 'lattice'
%               markers size 1 means the size of the map unit.
%
%               NOTE that in 'hit' mode there are some additional features.
%
% 'EdgeColor'   Sets edgecolor for the markers (not in use in 'label' mode)
%      (string) ColorSpec, e.g. 'r',  gives each edge the specified color
%               'none': sets markers edges invisible 
%               Default is 'none' - except if MarkerColor is set to 'none' the
%               defaults is 'black'.
%
% OPTIONAL INPUT ARGUMENTS mode 'label'
%
% Labels are centered on the unit so that multiple labels are in
% a single column.
%
% 'SubPlot'     see General Optional Input Arguments 
%
% 'TextSize'    Text size for labels
%      (scalar) Text size in points. Default is 10.
%
% 'TextColor'   Text color
%      (string) ColorSpec specifies the text color for all labels 
%               'xor': gives Matlab's "xor" text color mode where the 
%                label color depends on background color     
%               'none': sets labels invisble (but creates the objects)
%
% OPTIONAL INPUT ARGUMENTS mode 'hit'
%
% The function in mode 'hit' depends on the input argument size. If
% only one hit histogram is drawn (K==1), it is possible to show the
% hits using numbers. This is not possible for multiple hit
% histograms (K>1).
%
% 'SubPlot'     see General Optional Input Arguments 
%        
% 'Marker'      Marker style(s)
%      (string) As in General Optional Input Arguments. In addition 
%               'pie': sets pie charts for markers. The size of the
%                pie in each unit describes the number of total hits in the
%                unit and the share of each sector is the relative amount of
%                hits in each class (requires multiple histograms). Color for
%                each class is set by MarkerColor. Default coloring 
%                is hsv(K), where K is the number of hit histograms (classes).
%      (cell array) size K x 1, of built-in marker style characters. K is
%               number of histograms (classes), i.e., same as size(D,2)
%               where D is the second input argument. Cell value is
%               valid only if multiple histograms are specified (K>1). 
% 
%               NOTE if multiple histograms (classes) are specified
%               and Marker is one of the built-in marker styles or
%               'lattice', the markers are drawn in size order from
%               largest to smallest. This insures that all markers are
%               visible (or at least their edges are). But if two
%               markers for different classes in the same node were of
%               same size, the other would be totally hidden. In order
%               to prevent this, the markers for different classes are
%               shifted different amounts from the exact centre of the
%               unit. (Evidently, if Marker is 'pie' this problem does
%               not exist.)
%
%               Default marker is 'lattice' for one histogram and
%               'pie' for multiple histograms.
%
% 'MarkerColor' Marker color(s) 
%      (string) ColorSpec gives all markers the same color
%               'none': leaves the markes transparent (only edges are visible)
%      (matrix) size K x 3, RGB triples for each histogram class
%               giving each hit histogram an own color
%
%               NOTE that markers '*','+','x', or '.' cannot use 
%               MarkerColor since these objects have no face (fill)
%               color. For them only EdgeColor matters.
% 
% 'MarkerSize'  Maximum size for marker
%      (scalar) set the _maximum_ marker size that corresponds to
%               maximum hit count. If Marker is 'pie' or 'lattice' the 
%               MarkerSize is in normalized scale: 1 correspons to unit size.
%               If Marker is one of the built-in styles, MarkerSize is given
%               in points.  
%               
%               Marker        Default MarkerSize  
%               'lattice'      1 (normalized units)
%               'pie'          1 (normalized units) 
%               'o','s', etc.  6 (points)
%
% 'SizeFactor'  Defines the scaling of the marker sizes in multiple
%               histogram case (when Marker is one of the built-in marker 
%               styles or 'lattice').
%      (string) 'separate' (the default) means that marker size shows 
%                the share of the data which hits the unit compared to 
%                amount of data in that class. That is, the size of
%                markers show the relative distribution of data on the map 
%                in each class separately. The maximum size is SizeFactor.       
%               'common' means that marker size shows the distribution of
%                the data in the different classes compared to 
%                _the total amount of data_. 
%
% 'EdgeColor'   Sets edgecolor for the markers, see General
%               Optional Input Arguments. Default is 'none' -
%               except if MarkerColor is 'none' or Marker is
%               'x','*,'x', or '.'. In these cases default EdgeColor is 'black'. 
%
% 'Text'        Write/don't write the number of hits on the
%               units. This option is not in use for multiple histograms.
%      (string) 'on' or 'off' (the default)
%
% 'TextColor'   Text color 
%      (string) ColorSpec gives each letter the same color
%               'xor' gives a "xor" coloring for the text
%
% 'TextSize'    Text size (in points)    
%      (scalar) text size in points, default is 10
%
% OPTIONAL INPUT ARGUMENTS mode 'traj'
%
% Input D is a Nx1 vector of N BMU indices that describe the trace of the 
% comet. First element D(1) is "newest" and D(end) "oldest". Note
% that at least two indeces are expected: size of D must be at
% least 2x1.
%
% 'SubPlot'     see General Optional Input Arguments
%
% 'TrajColor'   Color for trajectory line
%      (string) ColorSpec gives each marker the same color, 'w' by default
%               'none' sets the marker fill invisible: only edges are shown
%
% 'TrajWidth'   Maximum width of trajectory line
%      (scalar) width in points. Default is 3.
%
% 'WidthFactor' Shows how often edge between two units has been traversed.
%      (string) 'hit': the size of the marker shows how frequent the
%                trajectory visits the unit (TrajWidth sets the
%                maximum size). This is the default.
%               'equal': all lines have the same width (=TrajWidth)
%
% 'Marker'      Marker style, see General Optional Input
%               Arguments. Default is 'o'.
%    
%               NOTE Marker style 'lattice' is not valid in mode 'traj'.
%               NOTE Markers can be turned off by setting MarkerSize to zero.
%
% 'MarkerSize'  Maximum size of markers
%      (scalar) Default is 12 (points).
%
% 'SizeFactor'  Sets the frequency based marker size or constant marker size.                  
%      (string) 'hit': the size of the marker shows how frequent the
%                trajectory visits the unit (MarkerSize sets the
%                maximum size). This is the default.
%               'equal': all markers have th esame size (=MarkerSize)
%
% 'MarkerColor' The fill color(s) for hit markers
%      (string) ColorSpec gives each marker the same color, default is 'w'
%               'none' sets the marker fill invisible: only edges are shown
%
%               NOTE markers '*','+','x', or '.' can't use MarkerColor since
%               these objects have no face (fill) color: only EdgeColor
%               matters for these markers.
% 
% 'EdgeColor'   see General Optional Input Arguments. Default is
%               'none' - except if MarkerColor is 'none' or Marker
%               is 'x','*','x', or '.'. In these cases default
%               EdgeColor is 'white'. 
%
% OPTIONAL INPUT ARGUMENTS mode 'comet'
%
% Input D is a Nx1 vector of N BMU indices that describe the trace of
% the comet. First element D(1) is "newest" and D(end) "oldest". Note
% that at least two indeces are expected: size of D must be at least
% 2x1.
%
% 'SubPlot'     see General Optional Input Arguments 
%
% 'Marker'      Marker style, see General Optional Input
%               Arguments. Default is 'lattice'.
%
% 'MarkerColor' The fill color(s) for comet markers
%      (string) ColorSpec gives each marker the same color, default is 'w'
%               'none' sets the marker fill invisible: only edges are shown 
%      (matrix) size N x 3, consisting of RGB triples as rows 
%               sets different color for each marker. This may be
%               used to code the time series using color/grayscale.
%
%               NOTE Markers '*','+','x', or '.' can't use MarkerColor
%               since these objects have no face (fill) color: only 
%               EdgeColor matters for these markers.
% 
% 'EdgeColor'   see General Optional Input Arguments. Default is
%               'none' - except if MarkerColor is 'none' or Marker
%               is 'x','*,'x', or '.'. In these cases default 
%               EdgeColor is 'white'. 
%
% 'MarkerSize'  The size of "comet core" and tail 
%      (vector) size 1 x 2: first element sets the size for the marker
%               representing D(1) and the second set size for D(end)
%               the size (area) of the markes between these changes linearly.
%               Note that size units for 'lattice' marker style are
%               normalized so that 1 means map unit size but for built-in
%               marker styles the size is given points.
%
%               Marker          default value
%               'lattice'        [0.8 0.1]
%               'o','v', etc.    [20 4]
%
% OUTPUT ARGUMENTS
%
% h (vector) handles to all objects created by the function
% 
% OBJECT TAGS
%
%  Field Tag in every object is set to
%
%   'Lab'  for objects created in mode 'label'
%   'Hit'                -"-           'hit'
%   'Traj'               -"-           'traj'
%   'Comet'              -"-           'comet'
%
% EXAMPLES
%
% Not yet ready
%
% SEE ALSO
%             
%  som_show       Basic map visualization
%  som_show_clear Clear hit marks, labels or trajectories from current figure. 

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Johan 131199

%% Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(2,Inf,nargin))     % check no. of input args

% Get data from the SOM_SHOW figure, exit if error

[handles,msg,lattice,msize,dim]=vis_som_show_data('all',gcf);    
error(msg);                    

munits=prod(msize);
% Initialize some variables: these must exist later; 
% the default values are set by subfunctions

Property=init_properties;
Property.handles=handles; 

%%% Check mode and that D is of right type & size for that mode 
% mode has to be string
if ~vis_valuetype(mode,{'string'}),
  error('String value expected for first input argument (mode).');
else                
  mode=lower(mode); % case insensitive
  mode_=mode;       % 'mode' is internal variable; 
                    % for program constructs 'mode_' is shown to
                    % user in some error messags
end

switch mode         % check mode
 case 'hit'
  %%% Hit histogram visualization: vector [msize k]
 
  if ~vis_valuetype(D,{'nxm'}),
    error('Hit visualization: a matrix expected for data input.');
  elseif size(D,1) ~= prod(msize)
    error('Hit visualization: data and map size do not match.');
  end
  % Multiple hit histograms
  if size(D,2)>1
    mode='mhit';
    % Hit count musn't be negative
    if any(D(:)<0),
      error('Hit visualization: negative hit count in data not allowed!');
    end
  end
 
 case {'traj','comet'}
  %%% Trajectory like visualizations
  
  if ~vis_valuetype(D,{'nx1'}),
    error('Trajectory/Comet: a Nx1 vector expected for data input.');
  elseif any(D>prod(msize)) || any(D<1),
    error('Trajectory/Comet: BMU indices out of range in data input.');
  elseif any(fix(D)~=D),
    warning('Trajectory/Comet: BMU indices not integer. Rounding...');
  elseif size(D,1)<2
    error('At least two BMU indexes expected.');
  end
  
 case  'label' 
  %%% Label visualizations
  
  if isstruct(D),                  % check if D is a map
    [tmp,ok,tmp]=som_set(D);
    if all(ok) && strcmp(D.type,'som_map') 
    else
      error('Map struct is invalid!');
    end
    % Size check
    if length(msize) ~= length(D.topol.msize) || ...
	  munits ~= prod(D.topol.msize),
      error(['The size of the input map and the map in the figure' ...
	     ' do not match.']);
    end
    D=D.labels;
    % Cell input  
  elseif vis_valuetype(D,{'2Dcellarray_of_char'}) 
    % Char input   
  elseif vis_valuetype(D,{'char_array'}),
    D=cellstr(D);
  else
    error(['Labels has to be in a map struct or in a cell array' ...
	   ' of strings']);
  end
  if size(D,1) ~= munits
    error(['The number of labels does not match the size of the map' ...
	   ' in the figure.']);
  end
 otherwise
  error('Invalid visualization mode.');
end  

if rem(length(varargin),2)
  error('Mismatch in identifier-value pairs or wrong input argument order.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  read in optional arguments

for i=1:2:length(varargin),
  %% Check that all argument types are strings
  
  if ~ischar(varargin{i})
    error('Invalid identifier name or input argument order.');
  end
  
  %% Lower/uppercase in identifier types doesn't matter: 
  
  identifier=lower(varargin{i});     % identifier (lowercase)
  value=varargin{i+1};
  
  % Check property identifiers and values and store the values.
  % Struct used_in is set to initiate warning messages:
  % if a don't care propersty is set, the user is warned.
  
  switch identifier  
   case 'marker'
    %%% Marker for hits or trajectories
    switch mode
     case 'mhit'
      if vis_valuetype(value,{'markerstyle'}) || ...
	    (vis_valuetype(value,{'string'}) && ...
	     any(strcmp(value,{'lattice','pie'}))),
	  % ok
      elseif vis_valuetype(value,{'cellcolumn_of_char'}),
	if size(value,1) ~= size(D,2)
	  error([' If a cell of Markers is specified its size must be' ...
		 ' number_of_hit_histograms x 1.']);
	else
	  for i=1:size(D,2),
	    if ~vis_valuetype(value{i},{'markerstyle'})
	      error('Cell input for ''Marker'' contains invalid styles.')
	    end
	  end
	end
      else
	error([' Invalid ''Marker'' in case of multiple hit histograms.' ...
	       char(10) ' See detailed documentation.'])
      end
     case {'comet','hit'}
      if vis_valuetype(value,{'markerstyle'}) || isempty(value),
	% ok;
      elseif ischar(value) && strcmp(value,'lattice'),
	% ok;
      else
	error(['Marker must be Matlab''s marker style, or string' ...
	       ' ''lattice''.']);
      end
     case 'traj'
      if ~vis_valuetype(value,{'markerstyle'}) && ~isempty(value),
	error('In mode ''traj'' Marker must be one of Matlab''s built-in marker styles');
      end
    end
    used_in.comet=1;           % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=1;
    used_in.mhit=1;
    
   case 'markersize'
    %%% Marker for hits or trajectories
    switch mode 
     case 'comet'
      if ~vis_valuetype(value,{'1x2'}) && ~isempty(value), 
	error('In mode ''comet'' MarkerSize'' must be a 1x2 vector.');
      end
     case {'hit','traj'}
      if ~vis_valuetype(value,{'1x1'}) && ~isempty(value), 
	error(['In mode ''' mode_ ...
	       ''' ''MarkerSize'' must be a scalar.']);
      end
    end
    used_in.comet=1;           % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=1;
    used_in.mhit=1;
    
   case 'sizefactor'   
    %%% Hit dependent size factor
    switch mode
     case 'traj'
      if ~vis_valuetype(value,{'string'}) || ...
	    ~any(strcmp(value,{'hit', 'equal'})),
	error(['In mode ''traj'' ''SizeFactor'' must be ' ...
	       'string ''equal'' or ''hit''.']);
      end
     case 'mhit'
      if ~vis_valuetype(value,{'string'}) || ...
	    ~any(strcmp(value,{'common', 'separate'})),
	error(['In mode ''hit'' ''SizeFactor'' must be ' ...
	       'string ''common'' or ''separate''.']);
      end
    end
    used_in.comet=0;           % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=0;
    used_in.mhit=1;
    
   case 'markercolor'
    %%% Markercolor
    switch mode
     case 'comet' 
      if ~vis_valuetype(value,{'colorstyle','1x3rgb'}) && ...
	    ~vis_valuetype(value,{'nx3rgb',[size(D,1) 3]},'all') && ...
	    ~isempty(value),
	error(['MarkerColor in mode ''comet'' must be a ColorSpec,' ...
	       ' string ''none'' or Mx3 matrix of RGB triples.']);
      end
     case 'mhit'
      if ~vis_valuetype(value,{[size(D,2) 3],'nx3rgb'},'all') && ...
	    ~vis_valuetype(value,{'colorstyle','1x3rgb'}),
	error([' If multiple hit histograms in mode ''hit'' are' ...
	       char(10) ...
	       ' given MarkerColor must be ColorSpec or a Kx3 matrix' ...
	       char(10)...
	       ' of RGB triples where K is the number of histograms.']);
      end
     case 'hit'
      if ~vis_valuetype(value,{'colorstyle','1x3rgb'}) && ...
	    ~isempty(value),
	error(['MarkerColor in mode ''hit'' ' ...
	       'must be a ColorSpec or string ''none''.']);
      end
     case 'traj'
      if ~vis_valuetype(value,{'colorstyle','1x3rgb'}) && ...
	    ~isempty(value),
	error(['MarkerColor in mode ''traj'' ' ...
	       'must be a ColorSpec or string ''none''.']);
      end
    end
    
    used_in.comet=1;           % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=1;
    used_in.mhit=1;
    
   case 'edgecolor'
    %%% Color for marker edges
    if ~vis_valuetype(value,{'colorstyle','1x3rgb'}) && ~isempty(value),
      error('''EdgeColor'' must be a ColorSpec or string ''none''.')
    end
    
    used_in.comet=1;           % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=1;
    used_in.mhit=1;
    
   case 'text'
    %%% Labeling for trajectories/hits
    switch mode
     case 'hit'
      %%% Hit count using numbers?
      if isempty(value),
	value='off';
      elseif vis_valuetype(value,{'string'}) && ...
	    ~any(strcmp(value,{'on','off'})),
	error('Value for Text in mode ''hit'' should be ''on'' or ''off''.');
      else
	  % ok
      end
     %case 'traj','comet'
     % if ~vis_valuetype(value,{'char_array','cellcolumn_of_char'}) & ...
     %	    ~isempty(value)
     %	 error('Value for Text is of wrong type or size.')
     % elseif ischar(value)
     %	value=strcell(value) % ok, convert to cell
     % end
     % if size(traj_label,1)~=size(D,1)
     %	error(['The number of labels in Text and the length of the' ...
     % 	       ' trajectory do not match.']);
     % end
     case 'label'
      % not used
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=0;
    used_in.label=0;
    used_in.hit=1;
    used_in.mhit=0;
    
   case 'textsize'
    %%% Text size for labels
    
    if ~vis_valuetype(value,{'1x1'}) && ~isempty(value), 
      error('TextSize must be scalar.');
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=0;
    used_in.label=1;
    used_in.hit=1;
    used_in.mhit=0;
    
   case 'textcolor'
    %%% Color for labels
    
    if ~vis_valuetype(value,{'colorstyle','1x3rgb','xor'}) && ~isempty(value),
      error('''TextColor'' must be ColorSpec, ''xor'' or ''none''.')
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=0;
    used_in.label=1;
    used_in.hit=1;
    used_in.mhit=0;
    
   case 'trajwidth'
    %%% Basic line width for a line trajectory
    if ~vis_valuetype(value,{'1x1'}) && ~isempty(value), 
      error('TrajWidth must be a scalar.');
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=1; 
    used_in.label=0;
    used_in.hit=0;
    used_in.mhit=0;
    
   case 'widthfactor'
    %%% Hit factor for a line trajectory
    if ~vis_valuetype(value,{'string'}) || ...
	  ~any(strcmp(value,{'hit', 'equal'})),
      error(['In mode ''traj'' ''WidthFactor'' must be ' ...
	     'string ''equal'' or ''hit''.']);
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=0;
    used_in.mhit=0;
    
   case 'trajcolor'
    %%% Color for trajectory line
    
    if ~vis_valuetype(value,{'colorstyle','1x3rgb','xor'}) && ~isempty(value),
      error('''TrajColor'' must be a ColorSpec or string ''xor''.')
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=1;
    used_in.label=0;
    used_in.hit=0;
    used_in.mhit=0;
    
   case 'uselabel' 
    %%% Which labels to show
    error('Not yet implemented.');
   
   case 'shift'
    if ~vis_valuetype(value,{'1x1'}) || ((value < 0) || (value > 1)),
      error('''Shift'' must be a scalar in range [0,1].')
    end
    used_in.comet=0;            % Set relevance flags
    used_in.traj=0;
    used_in.label=0;
    used_in.hit=0;
    used_in.mhit=1;
    
   case 'subplot'
    %%% The subplots which are affected 
    
    if vis_valuetype(value,{'1xn','nx1','string'}), 
      if ischar(value),
	if ~strcmp(value,'all'),
	  error('Only valid string value for subplot indices is ''all''.');
	else
	  value=1:length(handles);
	end
      elseif any(value<1) || any(value>length(handles)),
	error('Subplot indices must be in range 1...number_of_subplots!');
      end
    elseif ~isempty(value)
      error('Invalid subplot indices!');
    end
    used_in.comet=1;              % Set relevance flags
    used_in.traj=1;
    used_in.label=1;
    used_in.hit=1;
    used_in.mhit=1;
    
   otherwise
    error([ 'Unknown identifier ''' identifier '''.']);
  end
  
  % Warn user if the property that was set has no effect in the 
  % selected visuzlization mode

  if ~getfield(used_in, mode),
    warning(['Property ''' identifier ''' has no effect in mode ''' ...
	       mode_ '''.']);
  else 
    Property=setfield(Property,identifier,value);
  end
end

% set default subplot
if isempty(Property.subplot)
  % search the subplot number for current axis
  value=find(gca==handles);    
  if isempty(value) || value>length(handles) 
    error('SubPlot default value setting: current axis is not in the figure!');
  else
    Property.subplot=value;
  end
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Main switch: select the right subfunction %%%%%%%%%%%%%%%%%%%

switch mode
 case 'hit'
  h_=hit(D, lattice, msize, Property);  
 case 'mhit'
  h_=mhit(D, lattice, msize, Property);  
 case 'label'
  h_=label(D, lattice, msize, Property);
 case 'traj'
  h_=traj(D, lattice, msize, Property);
 case 'comet'
  %error('Not yet implemented.'); 
  h_=comet(D, lattice, msize, Property);
 otherwise
  error('Whoops! Internal error: unknown mode!');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build output if necessary %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout>0
  h=h_;
end

%%%% SUBFUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h_=hit(Hits, lattice, msize, Property)  

% number of map units
munits=prod(msize);

% subplots
p=Property.subplot;
handles=Property.handles;

% Set default marker
if isempty(Property.marker),
  if strcmp(Property.text,'on')
    Property.marker='none';
  else
    Property.marker='lattice';
  end
end

% Set default markersize
if isempty(Property.markersize)
  if strcmp(Property.marker,'none'),
    warning('MarkerSize is not meaningful since Marker is set to ''none''.');
  elseif strcmp(Property.marker,'lattice'),
    Property.markersize=1; % normalized size
  else
    Property.markersize=12; % points
  end
end

% Set default colors
if ~isempty(Property.markercolor),
  if strcmp(Property.marker,'none')
    warning('MarkerColor is not used since Marker is set to ''none''.');
    Property.markercolor=[]; % not used
  else
    % ok
  end
elseif any(strcmp(Property.marker,{'+','*','.','x'})),
  % these don't use fill color: 'none' will cause default
  % edgecolor to be 'k'.
  Property.markercolor='none'; 
else
  Property.markercolor='k';
end

if ~isempty(Property.edgecolor),
  if strcmp(Property.marker,'none')
    warning(['EdgeColor is not used since Marker is set to' ...
	     ' ''none''.']);
  else
    %ok 
  end
elseif ~strcmp(Property.markercolor,'none'),
  Property.edgecolor='none';
else
  Property.edgecolor='k';
end

% Set default text
if isempty(Property.text),
  Property.text='off';
end

% Set default textsize
if isempty(Property.textsize)
  Property.textsize=10;
elseif strcmp(Property.text,'off')  
  warning('TextSize not used as hits are not set to be shown as numbers.');
end

% Set default textcolor
if isempty(Property.textcolor)
  Property.textcolor='w';
elseif strcmp(Property.text,'off')  
  warning('TextColor not used as hits are not set to be shown as numbers.');
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h_=[];          % this variable is for collecting the object handles

% Select the drawing mode 

if ~strcmp(Property.marker,'none') 
  
  %%%%% Draw spots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % unit coordinates 
  coord=som_vis_coords(lattice,msize);
  
  % Calculate the size of the spots
  mx=max(Hits);
  
  if mx==0,
    % nothing to draw!
    h_=[]; 
    return
  else
    Size=sqrt(Hits./mx);      
  end
  % coordinates for non-zero hits (only those are drawn)
  coord=coord(Size~=0,:);
  Size=Size(Size~=0);
  N=size(Size,1);
  
  % som_cplane can't draw one unit with arbitrary
  % coordinates as it its mixed with msize:
  if size(coord,1)==1 && strcmp(Property.marker,'lattice'),
    Size=[Size;Size];
    coord=[coord;coord];
  end
  
  for i=1:length(p),
    % Set axes
    axes(handles(p(i)));
    % Get hold state and caxis
    memhold=ishold; cax=caxis;     
    hold on;
    
    switch Property.marker
     case 'lattice'
      h_(i,1)=som_cplane(lattice, coord, Property.markercolor, ...
			 Property.markersize*Size);
     otherwise  
      [S,m]=som_grid(lattice, [N 1],...
		     'Coord',coord, ...
		     'Line','none',...
		     'Marker',Property.marker,...
		     'MarkerColor',Property.markercolor,...
		     'MarkerSize', Size*Property.markersize);
      h_=[h_;m(:)];
    end
    
    % Restore hold state
    if ~memhold         
      hold off;
    end
  end
  
  % Set edgecolor
  if strcmp(Property.marker,'lattice')
    set(h_,'edgecolor',Property.edgecolor);
  else
    set(h_,'markeredgecolor',Property.edgecolor);
  end
end
  
if strcmp(Property.text,'on'),
  %%%%% Draw numbers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

  % Do numbers
  Hits=reshape(Hits,[munits 1]);
  labels=cell([munits 1]);
  for i=1:length(Hits)
    if Hits(i)              % zero hit won't be shown
      labels(i)={num2str(Hits(i))};
    end
  end

  for i=1:length(p),
    axes(handles(p(i)));    % Set axes
    memhold=ishold;         % Get hold state
    hold on;
    [S,m,l,t]=som_grid(lattice, msize, ...
		       'Line','none',...
		       'Marker','none', ...
		       'Label',labels, ...
		       'LabelColor', Property.textcolor, ...
		       'LabelSize', Property.textsize);
    % Get handles
    h_=[h_;t(:)];
    
    % Restore hold state and caxis
    if ~memhold     
      hold off;
    end
    caxis(cax);
  end

  % Remove zero object handles (missing objects)
  h_=setdiff(h_,0);
end

%% Set object tags (for som_show_clear) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(h_,'Tag','Hit')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h_=mhit(Hits, lattice, msize, Property)  

% number of map units
munits=prod(msize);

% subplots
p=Property.subplot;
handles=Property.handles;


% Set default marker
if isempty(Property.marker),
  Property.marker=lattice;
end

% variable 'mode' indicates which kind of markers are used:

if iscell(Property.marker),
  mode='marker';
elseif vis_valuetype(Property.marker,{'markerstyle'}),
  mode='marker';
elseif strcmp(Property.marker,'pie'),
  mode='pie';
else
  mode='lattice';
end

% Set default size scaling
if isempty(Property.sizefactor)
  Property.sizefactor='separate';
end

% Set default markersize 
if isempty(Property.markersize)
  if any(strcmp(mode,{'lattice','pie'})),
    Property.markersize=1; % normalized
  else
    Property.markersize=12;  % points
  end
end

% Set default colors

if isempty(Property.markercolor),
  Property.markercolor=hsv(size(Hits,2));
end

if isempty(Property.edgecolor),
  if vis_valuetype(Property.markercolor,{'none'}),
    Property.edgecolor='k';
  else
    Property.edgecolor='none';
  end
end

% Set default shift
if isempty(Property.shift)
  Property.shift=0;
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h_=[];          % this variable is for collecting the object handles

switch mode
  case {'marker','lattice'}
   % Number of hits histograms
   n_Hits=size(Hits,2);
   % Calculate the size of the spots
   
   if strcmp(Property.sizefactor,'common')
     mx=max(max(Hits));
     if mx==0 % nothing to draw!
       h_=[]; return
     end
     spotSize=sqrt(Hits./mx);
   else
     mx=repmat(max(Hits),munits,1);
     mx(mx==0)=1; % Prevent division by zero
     spotSize=sqrt(Hits./mx);
   end
   
   %%% Make spotSize
   
   %reshape Size to a vector [spotSizeforHist(:,1); spotSizeforHist(:,2);...]
   spotSize=spotSize(:);
   
   % indices for non-zero hits (only those are drawn)
   notZero=find(spotSize ~= 0);
   
   % Drop zeros away from spotSize
   spotSize=spotSize(notZero);
   
   % Order spots so that bigger will be drawn first, so that they 
   % won't hide smaller ones
   [dummy, sizeOrder]=sort(spotSize); sizeOrder=sizeOrder(end:-1:1);
   spotSize=spotSize(sizeOrder);
   
   %%% Make unit coordinates 
   coord=som_vis_coords(lattice,msize);
   
   move=repmat(linspace(-.1,.1,n_Hits),size(coord,1),1)*Property.shift;
   move=repmat(move(:),1,2);
   
   % do n_Hits copies of unit coordinates so that they match spotSize
   coord=repmat(coord,n_Hits,1)+move;
   
   % Drop zeros away from coords and order
   coord=coord(notZero,:);
   coord=coord(sizeOrder,:);
   
   %%% Make unit colors
   
   if vis_valuetype(Property.markercolor,{'nx3'}),
     % If multiple colors Copy unit colors so that they match spotSize
     color=Property.markercolor(reshape(repmat([1:n_Hits]',1,munits)',...
					munits*n_Hits,1),:);
     % drop zeros away & order
     color=color(notZero,:);
     color=color(sizeOrder,:);
   else
     % only on color
     color=Property.markercolor;
   end
   
   %%% Make unit markers
   
   if iscell(Property.marker),
     %marker shows class: 
     marker=char(Property.marker);
     marker=marker(reshape(repmat([1:n_Hits]',1,munits)',...
			   munits*n_Hits,1),:);
     % Drop zeros, order & make to cell array (for som_grid)
     marker=marker(notZero,:);
     marker=cellstr(marker(sizeOrder,:));
   else
     marker=Property.marker;
   end

   % som_cplane can't draw one unit with arbitrary
   % coordinates as it its mixed with msize:
   if size(coord,1)==1 && strcmp(mode,'lattice'),
     spotSize = [spotSize; spotSize];
     coord = [coord; coord];
   end

   N=length(notZero); % for som_grid visuzalization routine
 case 'pie'
  % marker 'pie' requires size parameter totHits
  if strcmp(mode,'pie')
    coord=som_vis_coords(lattice, msize);
    notZero=sum(Hits,2)>0;
    Hits=Hits(notZero,:);
    coord=coord(notZero,:);
    N=size(notZero,1);
    totHits=sqrt(sum(Hits,2)./max(sum(Hits,2)));
  end
  
  % som_pieplane can't draw one unit with arbitrary
  % coordinates as it its mixed with msize:
  if size(coord,1)==1,
    Hits= [Hits; Hits];
    coord = [coord; coord];
  end
 otherwise
  error('Whoops: internal error. Bad mode in subfunction mhit');
end

for i=1:length(p),    %%% Main loop begins
  % Set axis
  axes(handles(p(i)));
  % Get hold state and caxis 
  memhold=ishold; cax=caxis;
  hold on;
  
  switch mode
   case 'lattice'
    h_(i,1)=som_cplane(lattice, coord, color, spotSize*Property.markersize);
   case 'marker'
    [S,m]=som_grid(lattice, [N 1],...
		   'Coord',coord, ...
		   'Line','none',...
		   'Marker',marker,...
		   'MarkerColor',color,...
		   'MarkerSize', spotSize*Property.markersize);
    h_=[h_;m(:)];
   case 'pie'
    h_(i)=som_pieplane(lattice, coord, ...
		       Hits, Property.markercolor, ...
		       totHits*Property.markersize);
  end
  
  % Restore hold state and caxis
  if ~memhold         
    hold off;
  end
  caxis(cax);
end

% Set edgecolor
if any(strcmp(mode,{'lattice','pie'})),
  set(h_,'edgecolor',Property.edgecolor);
else
  set(h_,'markeredgecolor',Property.edgecolor);
end

%% Set object tags (for som_show_clear) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(h_,'Tag','Hit')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h_=label(Labels, lattice, msize, Property)

% number of map units
munits=prod(msize);

% subplots and handles
p=Property.subplot;
handles= Property.handles;

% Set default text size
if isempty(Property.textsize)   % default point size
  Property.textsize=10;
end

% Check color/set default
if isempty(Property.textcolor),                   
  Property.textcolor='k';
end

% handles will be collected in h_ for output
h_=[];                            

%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(p);
  % set axes
  axes(handles(p(i)));
  % store hold state and caxis (for some reason matlab may 
  % change caxis(!?)
  memhold=ishold;
  hold on;
  cax=caxis;
  
  % Write labels
  [S,m,l,t]=som_grid(lattice, msize, ...
		     'Line','none', ...
		     'Marker', 'none', ...
		     'Label', Labels, ...
		     'LabelColor', Property.textcolor,  ...
		     'LabelSize', Property.textsize);
  % Get handles
  h_=[h_;m(:);l(:);t(:)];
  
  % reset hold state and caxis
  if ~memhold
    hold off;
  end
  caxis(cax);
end

%%% Set object tags %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(h_,'Tag','Lab');
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h_=traj(bmu, lattice, msize, Property)

% number of map units
munits=prod(msize);

% subplots and handles
p=Property.subplot;
handles=Property.handles;

% Set default text color
%if isempty(Property.textcolor),                   
%  Property.textcolor='k';
%end

% Set default text size
%if isempty(Property.textsize)
%  Property.textsize=10;
%end

% Set default marker
if isempty(Property.marker)
  Property.marker='o';
end

% Set default markersize
if isempty(Property.markersize)
  Property.markersize=10;
end

% Set default markercolor
if isempty(Property.markercolor)
  Property.markercolor='w';
end

% Set default sizefactor
if isempty(Property.sizefactor)
  %Property.sizefactor=0;
  Property.sizefactor='hit';
end

% Set default trajwidth
if isempty(Property.trajwidth)
  Property.trajwidth=3;
end

% Set default widthfactor
if isempty(Property.widthfactor)
  Property.widthfactor='hit';
end

% Set default trajcolor
if isempty(Property.trajcolor)
  Property.trajcolor='w';
end

% if no labels, do a empty cell array for syntax reasons
%if isempty(Property.text),
%  Property.text=cell(munits,1);
%end

h_=[];                    % handles will be collected in h_ for output    
l=length(bmu);            % length of trajectory
C=sparse(munits, munits); % init a connection matrix

%%%%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the connection matrix that describes the trajectory
for i=1:l-1,
  % The following if structure removes the possible redundancy due
  % to travels in both directions between two nodes of trajectory 
  % (i.e. reflexivity) 
  I=bmu(i+1);J=bmu(i);
  %if bmu(i)>bmu(i+1)
  
  %else 
  %  I=bmu(i);J=bmu(i+1);
  %end
  C(I,J)=C(I,J)+1;
end

% transitive connections are equal
C=C+C';
% drop reflexive conncetions away
C=spdiags(zeros(munits,1),0,C);

% Do labels of trajectory nodes

%traj_lab=cell(munits,1);
hits=zeros(munits,1);

for i=1:l,
%  traj_lab{bmu(i)}=strvcat(traj_lab{bmu(i)},Property.text{i});
  hits(bmu(i))=(hits(bmu(i))+1);
end

% Calculate unit coordinates
unit_coord=som_vis_coords(lattice, msize);

% Calculate line width
if strcmp(Property.widthfactor,'equal')
  TrajWidth=(C>0)*Property.trajwidth;
else
  TrajWidth=Property.trajwidth.*sqrt(C./max(max(C)));
end

% Calculate marker sizes
if strcmp(Property.sizefactor,'hit')
  MarkerSize=Property.markersize*sqrt(hits/max(hits));
else
  MarkerSize=Property.markersize*(hits>0);
end

for i=1:length(p),
  axes(handles(p(i)));
  % Get hold state and caxis
  memhold=ishold; cax=caxis;
  hold on;

  	%'Label', traj_lab, ...
	%'LabelColor', Property.textcolor, ...
	%'LabelSize', Property.textsize, ...

  % Draw
  [S,m,l,t,s]=som_grid(C,msize,'coord',unit_coord,...
	'Line','-', ...
	'LineColor', Property.trajcolor, ...
	'LineWidth', TrajWidth, ...
	'Marker', Property.marker, ...
	'MarkerColor', Property.markercolor, ...
	'MarkerSize', MarkerSize);
  
  % Restore hold state and caxis
  if ~memhold   
    hold off;
  end
  caxis(cax);
  % Get handles
  h_=[h_;m(:);l(:);t(:);s(:)];
end

%% Set object tags %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

set(h_,'Tag','Traj');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h_=comet(bmu, lattice, msize, Property)

% number of map units
munits=prod(msize);

% subplots and handles
p=Property.subplot;
handles=Property.handles;

% Set default text color
%if isempty(Property.textcolor),                   
%  Property.textcolor='k';
%end

%% Set default text size
%if isempty(Property.textsize)
%  Property.textsize=10;
%end

% Set default marker
if isempty(Property.marker)
  Property.marker='o';
end

% Set default markersize
if isempty(Property.markersize),
  if strcmp(Property.marker,'lattice'),
    Property.markersize=linspace(0.8,0.1,length(bmu))';
  else 
    Property.markersize=sqrt(linspace(400,16,length(bmu)))';
  end
else
  if strcmp(Property.marker,'lattice'),
    Property.markersize=linspace(Property.markersize(1),...
				 Property.markersize(2), ...
				 length(bmu))';
  else
    Property.markersize=sqrt(linspace(Property.markersize(1).^2,...
				      Property.markersize(2).^2, ...
				      length(bmu)))';

  end
end

% Set default markercolor
if isempty(Property.markercolor)
  Property.markercolor='w';
end

% Set default edgecolor
if isempty(Property.edgecolor),
  if vis_valuetype(Property.markercolor,{'nx3rgb'}),
    Property.edgecolor='none';
  else
    Property.edgecolor=Property.markercolor;
  end
end

h_=[];l_=[];              % handles will be collected in h_ for output       
N_bmus=length(bmu);       % length of trajectory

% if no labels, do a empty cell array for syntax reasons
%if isempty(Property.text),
%  Property.text=cell(N_bmus,1);
%end

%%%%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate unit coordinates for trajectory points
unit_coord=som_vis_coords(lattice, msize);
coord=unit_coord(bmu,:);

% Make labels for the _unique_ units that the comet hits

unique_bmu=unique(bmu);               % count units
%N_labels=length(unique_bmu);    
%traj_lab=cell(N_labels,1);            % cell for labels
%label_coord=unit_coord(unique_bmu,:); % label coordinates

% Make labels
%for i=1:N_bmus,
%  index=find(unique_bmu==bmu(i));
%  traj_lab{index}=strvcat(traj_lab{index},Property.text{i});
%end

%Main loop for drawing comets
for i=1:length(p),
  % set axis
  axes(handles(p(i)));

  % Get hold state and caxis
  memhold=ishold; cax=caxis;
  hold on;
  
  if strcmp(Property.marker,'lattice'),
    % Draw: marker is a patch ('hexa','rect')
     l_=som_cplane(lattice, coord, Property.markercolor, ...
		  Property.markersize);
     
     % Set edgecolor
     set(l_,'edgecolor',Property.edgecolor);
  else
    % Draw: other markers than 'hexa' or 'rect'
     [S,m,l,t,s]=som_grid(lattice, [N_bmus 1], 'coord', coord,...
			  'Line','none', ...
			  'Marker', Property.marker, ...
			  'MarkerColor', Property.markercolor, ...
			  'MarkerSize',Property.markersize);
     
     % Set edgecolor
     set(m, 'markeredgecolor', Property.edgecolor);
     
     % Get handles from markers
     h_=[h_;l_(:);m(:);l(:);t(:);s(:)];
  end
  
  % Set labels
  %[S,m,l,t,s]=som_grid(lattice, [N_labels 1], 'coord', label_coord,...
  %		       'Marker','none','Line','none',...
  %		       'Label', traj_lab, ...
  %		       'LabelColor', Property.textcolor, ...
  %		       'LabelSize', Property.textsize);
  % Get handles from labels
  %h_=[h_;m(:);l(:);t(:);s(:)];

  % Restore hold state and caxis
  if ~memhold   
    hold off;
  end
  caxis(cax);
end

%% Set object tags %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

set(h_,'Tag','Comet');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function P=init_properties

% Initialize an empty property struct

P.marker=[];
P.markersize=[];
P.sizefactor=[];
P.markercolor=[];
P.edgecolor=[];
P.trajwidth=[];
P.widthfactor=[];
P.trajcolor=[];
P.text=[];
P.textsize=[];
P.textcolor=[];
P.subplot=[];
P.shift=[];