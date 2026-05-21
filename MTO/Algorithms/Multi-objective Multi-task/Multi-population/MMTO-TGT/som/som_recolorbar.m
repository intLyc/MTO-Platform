function h=som_recolorbar(p, ticks, scale, labels)

%SOM_RECOLORBAR Refresh and  rescale colorbars in the current SOM_SHOW fig.
%
% h = som_recolorbar([p], [ticks], [scaling], [labels])
%
%   colormap(jet); som_recolorbar   
%
% Input and output arguments ([]'s are optional) 
%  [p]      (vector) subplot number vector 
%           (string) 'all' (the default), 'comp' to process only
%                    component planes        
%  [ticks]  (string) 'auto' or 'border', default: 'auto'
%           (cell array) p x 1 cell array of p row vectors
%           (vector) the same ticks are applied to all given subplots
%           (scalar) value is at least 2: the number of ticks to show, 
%                    evenly spaced between and including minimum and maximum 
%  [scale]  (string) 'denormalized' or 'normalized' (the default)
%  [labels] (cell array) p x 1 cell array of cells containing strings
%
%  h        (vector) handles to the colorbar objects.
%
% This function refreshes the colorbars in the figure created by SOM_SHOW.
% Refreshing  is necessary if you have changed the colormap.
% Each colorbar has letter 'd' or 'n' and possibly 'u' as label. Letter 'd' means
% that the scale is denormalized, letter 'n' that the scale is
% normalized, and 'u' is for user specified labels.
%
% For more help, try 'type som_recolorbar' or check out online documentation.
% See also SOM_SHOW
 
%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_recolorbar
%
% PURPOSE
% 
% Refreshes the the colorbars in the figure.
%
% SYNTAX
%
%  h = som_recolorbar
%  h = som_recolorbar(p)
%  h = som_recolorbar(p, ticks)
%  h = som_recolorbar(p, ticks, scaling)
%  h = som_recolorbar(p, ticks, scaling, labels)
%
% DESCRIPTION
%
% This function refreshes the colorbars in the figure created by SOM_SHOW.
% Refreshing is necessary if you have changed the colormap.  Each colorbar
% has letter 'd' or 'n' and possibly 'u' as label. Letter 'd' means that the
% scale is denormalized, letter 'n' that the scale is normalized, and 'u' is
% for user specified labels.
%
% Different argument combinations:
%
% 1. Argument 'ticks' has string values:
%  - 'auto' for input argument ticks sets the automatic tick
%     marking on (factory default). 
%  - 'border' sets the tick marks to the color borders. This is 
%     convenient if there are only few colors in use. 
%
%  Argument scale controls the scaling of the tick mark label values. 
%  'normalized' means that the tick mark labels are directly the values 
%  of the ticks, that is, they refer to the map codebook values. 
%  Value 'denormalized' scales the tick mark label values back to the original
%  data scaling. This is made using som_denormalize_data.
%
% 2. Argument 'ticks' is a cell array of vectors:
%  The values are set to be the tick marks to the colorbar specified by p.
%  - if arg. scale is 'normalized' the ticks are set directly to the colorbar.
%  - if arg. scale is 'denormalized' the tick values are first normalized 
%    in the same way as the data.
%
% 3. Argument 'ticks' is a vector
%  As above, but the same values are used for all (given) subplots.
%  
% 4. Argument 'ticks' is a scalar
%  The ticks are set to equally spaced values between (and including)
%  minimum and maximum.
%     
% Argument 'labels' specify user defined labels to the tick marks
%
% NOTE: ticks are rounded to contain three significant digits.
%
% OPTIONAL INPUT ARGUMENTS
% 
%  p        (vector) subplot number vector 
%           (string) 'all' (the default), 'comp' to effect only 
%                    component planes
%
%  ticks    (string) 'auto' or 'border', default: 'auto'
%           (cell array) p x 1 cell array of p row vectors
%           (vector) as the cell array, but the same vector is 
%                    applied to all given subplots
%           (scalar) the number of ticks to show: these are 
%                    evenly space between minimum and maximum
%
%  scale    (string) 'denormalized' or 'normalized' (the default)
%
%  labels   (cell array) p x 1 cell array of cells containing strings
%
% OUTPUT ARGUMENTS
%
%  h        (vector) handles to the colorbar objects.
%
% EXAMPLE
%
%  colormap(jet(5)); som_recolorbar('all','border','denormalized')
%      % Uses five colors and sets the ticks on the color borders.
%      % Tick label values are denormalized back to the original data scaling
%
%  colormap(copper(64));som_recolorbar
%      % changes to colormap copper and resets default ticking and labeling
%
%  som_recolorbar('all',3)
%      % To put 3 ticks to each colorbar so that minimum, mean and
%      % maximum values on the colorbar are shown.
% 
%  som_recolorbar([1 3],{[0.1 0.2 0.3];[0.2 0.4]},'denormalized')
%      % Ticks colorbar 1 by first normalizing values 0.1, 0.2, 0.3 and
%      % then setting the ticks to the colorbar. Labels are of course 
%      % 0.1, 0.2 and 0.3. Ticks colorbar 3 in the same way using values
%      % 0.2 and 0.4.
%
%  som_recolorbar([2 4],{[0.1 0.2];[-1.2 3]},'normalized',{{'1' '2'};{'a' 'b'}})
%      % Ticks colorbar 2 and 4 directly to the specified values. Sets labels
%      % '1' '2' and 'a' 'b' to the ticks.
%
%  som_recolorbar([2 4],{[0.1 0.2];[-1.2 3]},'normalized',{{'1' '2'};{'a' 'b'}})
%      % as previous one, but normalizes tick values first
%
% SEE ALSO
% 
%  som_show        Basic SOM visualization.
%  som_normalize   Normalization operations.
%  som_denormalize Denormalization operations.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 1.0beta Johan 061197 
% Version 2.0beta juuso 151199 130300 160600 181101

%% Init & check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(0, 4, nargin))    % check no. of input args

% Check the subplot vector p and  get the handles, exit if error
% Default subplot vector is 'all'

if nargin < 1 || isempty(p)                       % default p
  p= 'all';
end

% check SOM_SHOW and get the figure data. Exit, if error

[handles, msg, lattice, msize, dim, normalization, comps]= ...
    vis_som_show_data(p, gcf);
error(msg);                                       

if nargin < 2 || isempty(ticks)                   % default tick mode is 'auto'
  ticks = 'auto';
elseif isa(ticks,'cell')                         % check for cell
  tickValues = ticks; 
  ticks= 'explicit';
elseif isa(ticks,'double') && length(ticks)>1,
  tickValues = {ticks}; 
  ticks = 'explicit'; 
elseif isa(ticks,'double') && length(ticks)==1,
  tickValues = max(2,round(ticks)); 
  ticks = 'evenspace'; 
end
if ~ischar(ticks)                                % invalid argument
  error('The second argument should be a string or a cell array of vectors.');
end

switch ticks                                     % check ticks
 case {'auto','border'}, % nill
 case 'evenspace', 
  tickValues_tmp = cell(length(handles),1); 
  for i=1:length(handles), tickValues_tmp{i} = tickValues; end
  tickValues = tickValues_tmp; 
 case 'explicit', 
  if length(tickValues)==1 && length(handles)>1, 
    tickValues_tmp = cell(length(handles),1); 
    for i=1:length(handles), tickValues_tmp{i} = tickValues{1}; end
    tickValues = tickValues_tmp; 
  end
  if length(tickValues) ~= length(handles), 
    error('Cell containing the ticks has wrong size.')
  end
otherwise
  error('''auto'' or ''border'' expected for the second argument.');
end

if nargin < 3 || isempty(scale)                   % default mode is normalized
  scale= 'normalized';
end
if ~ischar(scale)                                % check scale type
  error('The third argument should be a string.'); 
end
switch scale                                     % check the string
 case { 'normalized', 'denormalized'} % ok
 case 'n', scale = 'normalized'; 
 case 'd', scale = 'denormalized'; 
 otherwise   
  error('''normalized'' or ''denormalized'' expected for the third argument.')
end

if nargin < 4 || isempty(labels)                  % default is autolabeling
  labels = 'auto';
elseif ~isa(labels,'cell')                       % check type
  error('The fourth argument should be a cell array of cells containing strings.')
else
  labelValues=labels;                            % set labels
  labels = 'explicit';
  if length(labelValues) == length(handles)      % check size
  else
    error('Cell containing the labels has wrong size')
  end
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(colormap,1)+1;                      % number of colors+1
h_ = zeros(length(handles),1);  

for i=1:length(handles),                   % MAIN LOOP BEGINS
  axes(handles(i));                        % set axes, refres colorbar and  
  if comps(i)>=0,   
    h_(i)=colorbar;                          % get colorbar handles

    colorbardir=get(h_(i),'YaxisLocation');
    switch colorbardir                     % get colorbar direction &
     case 'left'                            % set some strings
      Tick='Xtick'; Lim='Xlim'; LabelMode='XTickLabelMode'; Label='XtickLabel';
     case 'right'
      Tick='Ytick'; Lim='Ylim'; LabelMode='YTickLabelMode'; Label='YtickLabel';
     otherwise
      error('Internal error: unknown value for YaxisLocation'); % fatal
    end                                                         
    
    switch ticks                         
     case 'auto'
      set(h_(i),LabelMode,'auto');        % factory default ticking
      tickValues{i}=get(h_(i),Tick);       % get tick values
     case 'border' 
      limit=caxis;                        
      t=linspace(limit(1),limit(2),n);    % set n ticks between min and max 
      t([1 length(t)])=get(h_(i),Lim); % <- caxis is not necerraily the same 
      tickValues{i}=t;                    % as the colorbar min & max values
     case 'evenspace'
      limit = caxis; 
      t = linspace(limit(1),limit(2),tickValues{i}); 
      t([1 length(t)])=get(h_(i),Lim);
      tickValues{i}=t; 
     case 'explicit'
      if comps(i)>0, 
	if strcmp(scale,'normalized')     % normalize tick values
	  tickValues{i} = som_normalize(tickValues{i},normalization{comps(i)});
	end
      end
      
     otherwise 
      error('Internal error: unknown tick type')   % this shouldn't happen
    end

    %tickValues{i} = epsto0(tickValues{i});

    switch labels
     case 'auto'
      switch scale                         
       case 'normalized'
	labelValues{i} = round2(tickValues{i});     % use the raw ones 
       case 'denormalized'                 % denormalize tick values
	if comps(i)>0, 
	  labelValues{i} = som_denormalize(tickValues{i},normalization{comps(i)});
	  labelValues{i} = round2(labelValues{i});     % round the scale
	else
	  labelValues{i} = round2(tickValues{i});
	end
       otherwise
	error('Internal error: unknown scale type'); % this shouldn't happen
      end
     case 'explicit'
                                            % they are there already
     otherwise
      error('Internal error: unknown label type'); % this shouldn't happen
    end

    set(h_(i),Tick,tickValues{i});                 % set ticks and labels
    set(h_(i),Label,labelValues{i});            
    
    if comps(i)>0,
      % Label the colorbar with letter 'n' if normalized, with letter 'd'
      % if denormalized and 'u' if the labels are user specified 
      ch='  ';
      if strcmp(scale,'normalized'),   ch(1)='n'; end
      if strcmp(scale,'denormalized'), ch(1)='d'; end
      if strcmp(labels,'explicit'),    ch(2)='u'; end
      if verLessThan('matlab', '8.4')
          mem_axes = gca();
          axes(h_(i));
          xlabel(ch);
          axes(mem_axes);
      else
          lbl = get(h_(i), 'Label');
          lbl.String = ch;
      end
    end
  end
end                                              % MAIN LOOP ENDS 


%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout>0
  h=h_;
end

return; 

%% Subfunction: ROUND2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROUND2 rounds the labels to tol significant digits

function r=round2(d)

tol=3;

zero=(d==0);
d(zero)=1;
k=floor(log10(abs(d)))-(tol-1);
r=round(d./10.^k).*10.^k;
r(zero)=0;
%r=epsto0(r);

%% Subfunction: ISVECTOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function t=isvector(v)
% ISVECTOR checks if a matrix is a vector or not

t=(ndims(v) == 2 & min(size(v)) == 1) & isnumeric(v);

%% Subfunction: EPSTO0

function t=epsto0(t)
% EPSTO0 checks whether first tick value is *very* close to zero, 
% if so sets it to zero.

if (t(end)-t(1))/t(end) > 1-0.005 && abs(t(1))<1, t(1) = 0; end




