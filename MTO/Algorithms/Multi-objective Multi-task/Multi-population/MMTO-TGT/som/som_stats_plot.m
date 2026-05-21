function som_stats_plot(csS,plottype,varargin)

%SOM_STATS_PLOT Plots of data set statistics.
%  
% som_stats_plot(csS, plottype, [argID, value, ...])
%
%  som_stats_plot(csS,'stats')
%  som_stats_plot(csS,'stats','p','vert','color','r')
%
%  Input and output arguments ([]'s are optional): 
%   csS         (cell array) of statistics structs
%               (struct) a statistics struct
%   plottype    (string) some of the following
%                        'hist'   histogram
%                        'box'    min, max, mean, and std shown as a boxplot
%                        'stats'  both histogram (with black) and the boxplot
%   [argID, (string) See below. The values which are unambiguous can 
%    value] (varies) be given without the preceeding argID.
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'counts'      *(string) 'c' (for counts, the default) or 'p' (for percentages)
%   'color'        (vector) size 1 x 3, color to be used
%                  (string) a color string
%   'title'        (string) 'on' (default) or 'off'
%   'orientation' *(string) 'horiz' or 'vert' (default): orientation for the 
%                           bin values (horizontally or vertically)
%
% See also  SOM_STATS, SOM_STATS_TABLE, SOM_TABLE_PRINT, SOM_STATS_REPORT.

% Contributed to SOM Toolbox 2.0, December 31st, 2001 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 311201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% arguments

% statistics
if isstruct(csS), csS = {csS}; end

% default values
useprob   = 0; 
color     = [0 0 1];
showtitle = 1; 
horiz     = 0; 

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     % argument IDs
     case 'counts',      i=i+1; useprob = strcmp(varargin{i}(1),'p'); 
     case 'color',       i=i+1; color = varargin{i}; 
     case 'title',       i=i+1; showtitle = strcmp(varargin{i},'on');
     case 'orientation', i=i+1; horiz = strcmp(varargin{i},'horiz'); 
     % unambiguous values
     case {'horiz','vert'}, horiz = strcmp(varargin{i},'horiz'); 
     case {'c','p'}, useprob = strcmp(varargin{i}(1),'p'); 
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    argok = 0; 
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_stats_plot) Ignoring invalid argument #' num2str(i+2)]); 
  end
  i = i+1; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% action

ss = ceil(sqrt(length(csS))); ss = [ss, ceil(length(csS)/ss)];

for j = 1:length(csS), 
    sS = csS{j};    
    subplot(ss(1),ss(2),j);
    switch plottype, 
    case 'stats',
        cla, hold on
        Counts = sS.hist.counts; 
        if useprob, for i=1:size(Counts,2), Counts(:,i) = Counts(:,i)/sum(Counts(:,i)); end, end
        hist_plot(sS.hist.bins,sS.hist.binlabels,Counts,color);
        box_plot(sS.min,sS.max,sS.mean,sS.std,[0 0 0]);
    case 'hist',
        cla, hold on
        Counts = sS.hist.counts; 
        if useprob, for i=1:size(Counts,2), Counts(:,i) = Counts(:,i)/sum(Counts(:,i)); end, end
        hist_plot(sS.hist.bins,sS.hist.binlabels,Counts,color);
    case 'box', 
        cla
	box_plot(sS.min,sS.max,sS.mean,sS.std,color);    
    end
    if showtitle, title(sprintf('%s (valid: %d/%d)',sS.name,sS.nvalid,sS.ntotal)); end
    if ~horiz, view(90,-90); end
    a = axis; a(1) = sS.min; a(2) = sS.max; axis(a); 
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% subfunctions

function hist_plot(bins,binlabels,Counts,color)
    
    if nargin<4, color = jet(size(Counts,2)); end
    h = bar(bins,Counts);
    for j=1:length(h), set(h(j),'facecolor',color(j,:),'edgecolor','none'); end
    a = axis; a(3:4) = [0 max(Counts(:))]; axis(a);
    set(gca,'XTick',bins,'XTickLabel',binlabels);
    return;

function vstr = numtostring(v,d)

    nearzero = (abs(v)/(max(v)-min(v)) < 10.^-d);
    i1 = find(v > 0 & nearzero); 
    i2 = find(v < 0 & nearzero);     
    vstr = strrep(cellstr(num2str(v,d)),' ','');
    vstr(i1) = {'0.0'};
    vstr(i2) = {'-0.0'};
    return;

function box_plot(mi,ma,me,st,Color)

    if nargin < 5, Color = jet(length(mi)); end
    a = axis;      
    y = linspace(a(3),a(4),length(mi)+2); y = y(2:end);
    d = (y(2)-y(1))/20;   
    for i=1:length(mi),
        h1 = line([mi(i) ma(i)],[y(i) y(i)]); 
        h2 = line([mi(i) mi(i) NaN ma(i) ma(i)],[y(i)-d y(i)+d NaN y(i)-d y(i)+d]); 
        h3 = line([me(i)-st(i) me(i)+st(i)],[y(i) y(i)]); 
        h4 = line([me(i) me(i)],[y(i)-2*d y(i)+2*d]); 
        set([h1 h2 h3 h4],'color',Color(i,:));
        set([h1 h2],'linewidth',1);
        set([h3 h4],'linewidth',3);
    end 
    return;
