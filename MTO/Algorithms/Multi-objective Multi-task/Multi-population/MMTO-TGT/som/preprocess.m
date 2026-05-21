function preprocess(sData,arg2)

%PREPROCESS  A GUI for data preprocessing.
%
%  preprocess(sData)
%
%    preprocess(sData)
%
% Launches a preprocessing GUI. The optional input argument can be
% either a data struct or a struct array of such. However, primarily
% the processed data sets are loaded to the application using the
% tools in the GUI. Also, the only way to get the preprocessed data
% sets back into the workspace is to use the tools in the GUI (press
% the button DATA SET MANAGEMENT).
%  
% For a more throughout description, see online documentation.
% See also SOM_GUI. 

%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% IN FILES: preprocess.html,preproc.jpg,sDman.jpg,clip.jpg,delay.jpg,window.jpg,selVect.jpg

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas and the SOM Toolbox team

% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100

global no_of_sc  % every Nth component in 'relative values' is drawn stronger.
no_of_sc=5;

if nargin < 1 || nargin > 2 
  error('Invalid number of input arguments');
  return;
end
  
if nargin == 1, arg2=[]; end

if ~ischar(sData)   %%% Preprocess is started...
data.LOG{1}='% Starting the ''Preprocess'' -window...';
data.LOG{2}=cat(2,'preprocess(',...
                     sprintf('%s);',inputname(1)));

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
if ~isempty(pre_h)
  figure(pre_h);
  msgbox('''Preprocess''-figure already exists.');
  return;
end

h0 = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[595 216 600 775], ...
	'Tag','Preprocess');
	
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.015 0.06064516129032258 0.9550000000000001 0.1458064516129032], ...
	'Style','text', ...
	'Tag','StaticText1');

data.results_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess close', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.8067 0.0142 0.1667 0.0348],...
	'String','CLOSE', ...
	'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.2141935483870968 0.07000000000000001 0.01806451612903226], ...
	'String','LOG', ...
	'Style','text', ...
	'Tag','StaticText2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess sel_comp',...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.7983333333333333 0.2090322580645161 0.1666666666666667 0.03483870967741935], ...
	'String',' ', ...
	'Style','popupmenu', ...
	'Tag','sel_comp_h', ...
	'Value',1);

data.sel_comp_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.0183 0.2568 0.2133 0.1290], ...
	'Style','text', ...
	'Tag','StaticText3');

data.sel_cdata_h=h1;

h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'Position',[0.2583 0.2568 0.2133 0.1290], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'XTickLabel',['0  ';'0.5';'1  '], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);

data.sel_chist_h=h1;

h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4960629921259843 -0.08080808080808044 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.0551181102362206 0.4848484848484853 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-1.2283    5.7980    9.1603], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4960629921259843 1.070707070707071 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);

h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[0.7529 0.7529 0.7529], ...
	'Position',[0.4950000000000001 0.2567741935483871 0.4766666666666667 0.1290322580645161], ...
	'Tag','Axes2', ...
	'XColor',[0 0 0], ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTick',[0 0.5 1], ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);

data.vector_h=h1;

h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4982456140350879 -0.08080808080808044 9.160254037844386], ...
	'Tag','Axes2Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.1018    0.4848    9.1603], ...
	'Rotation',90, ...
	'Tag','Axes2Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-1.045614035087719 5.797979797979799 9.160254037844386], ...
	'Tag','Axes2Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4982456140350879 1.070707070707071 9.160254037844386], ...
	'Tag','Axes2Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.3922580645161291 0.17 0.01806451612903226], ...
	'String','STATISTICS', ...
	'Style','text', ...
	'Tag','StaticText4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2583333333333334 0.3922580645161291 0.1633333333333333 0.01806451612903226], ...
	'String','HISTOGRAM', ...
	'Style','text', ...
	'Tag','StaticText5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi',...
	'FontSize',6,...
	'HorizontalAlignment','left',...
	'String',{'LEFT: NEW SELECTION';'RIGHT: ADD TO SELECTION'}, ...
	'ListboxTop',0, ...
	'Position',[0.5016666666666667 0.38 0.235 0.03741935483870968], ...
	'Style','text', ...
	'Tag','StaticText6', ...
	'UserData','[ ]');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess selall', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.8066666666666668 0.3922580645161291 0.1666666666666667 0.03483870967741935], ...
	'String','SELECT ALL', ...
	'Tag','Pushbutton2', ...
	'UserData','[ ]');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.7529 0.7529 0.7529], ...
	'Position',[0.01833333333333333 0.4503225806451613 0.23 0.3225806451612903], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);

data.comp_names_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[0.4950000000000001 0.4503225806451613 0.2333333333333333 0.3225806451612903], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',1);

data.vect_mean_h = h1;

h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'Position',[0.7383333333333334 0.4503225806451613 0.2333333333333333 0.3225806451612903], ...
	'Tag','Axes3', ...
	'XColor',[0 0 0], ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);

data.sel_cplot_h = h1;

h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4964028776978418 -0.03212851405622486 9.160254037844386], ...
	'Tag','Axes3Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.05035971223021596 0.493975903614458 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes3Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-3.1942    1.7028    9.1603], ...
	'Tag','Axes3Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4964028776978418 1.028112449799197 9.160254037844386], ...
	'Tag','Axes3Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess plxy', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.265 0.4683870967741936 0.125 0.03483870967741935], ...
	'String','XY-PLOT', ...
	'Tag','Pushbutton3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess hist', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.265 0.5303225806451613 0.125 0.03483870967741935], ...
	'String','HISTOGRAM', ...
	'Tag','Pushbutton4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess bplo', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.265 0.5922580645161291 0.125 0.03483870967741935], ...
	'String','BOX PLOT', ...
	'Tag','Pushbutton5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess plot', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.265 0.654195483870968 0.125 0.03483870967741935], ...
	'String','PLOT', ...
	'Tag','Pushbutton6');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.4088888888888889 0.5333333333333333 0.06 0.03268817204301075], ...
	'String','30', ...
	'Style','edit', ...
	'Tag','EditText1');

data.no_of_bins_h = h1;


h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.775483870967742 0.2016666666666667 0.01806451612903226], ...
	'String','COMPONENT LIST', ...
	'Style','text', ...
	'Tag','StaticText7');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.4950000000000001 0.775483870967742 0.1966666666666667 0.01806451612903226], ...
	'String','AVERAGE', ...
	'Style','text', ...
	'Tag','StaticText8');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.7383333333333334 0.775483870967742 0.225 0.01806451612903226], ...
	'String','RELATIVE VALUES', ...
	'Style','text', ...
	'Tag','StaticText9');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',10, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.8154838709677419 0.2033333333333333 0.0232258064516129], ...
	'String','COMPONENTS', ...
	'Style','text', ...
	'Tag','StaticText10');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',10, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.4950000000000001 0.8154838709677419 0.2 0.0232258064516129], ...
	'String','VECTORS', ...
	'Style','text', ...
	'Tag','StaticText11');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess sD_management', ...
	'FontSize',5, ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.8503225806451613 0.1666666666666667 0.03483870967741935], ...
	'String','DATA SET MANAGEMENT', ...
	'Tag','Pushbutton7');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','preprocess sel_sD', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.8890322580645161 0.1666666666666667 0.03483870967741935], ...
	'String',' ', ...
	'Style','popupmenu', ...
	'Tag','PopupMenu2', ...
	'Value',1);

data.sD_set_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.2516666666666667 0.8503225806451613 0.7216666666666667 0.07354838709677419], ...
	'Style','text', ...
	'Tag','StaticText12');

data.sD_name_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',10, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.01833333333333333 0.9341935483870968 0.1616666666666667 0.02064516129032258], ...
	'String','DATA SETS', ...
	'Style','text', ...
	'Tag','StaticText13');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',10, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2516666666666667 0.9341935483870968 0.2833333333333333 0.02064516129032258], ...
	'String','SELECTED DATA SET', ...
	'Style','text', ...
	'Tag','StaticText14');

if ~isstruct(sData), 
  sData=som_data_struct(sData);
end

ui_h=uimenu('Label','&Normalization');
uimenu(ui_h,'Label','Scale [0,1]','Callback','preprocess zscale');
uimenu(ui_h,'Label','Scale var=1','Callback','preprocess vscale');
uimenu(ui_h,'Label','HistD','Callback','preprocess histeq');
uimenu(ui_h,'Label','HistC','Callback','preprocess histeq2');
uimenu(ui_h,'Label','Log','Callback','preprocess log');
uimenu(ui_h,'Label','Eval (1-comp)','Callback','preprocess eval1');

ui_h=uimenu('Label','&Components');
uimenu(ui_h,'Label','Move component','Callback','preprocess move');
uimenu(ui_h,'Label','Copy component','Callback','preprocess copy');
uimenu(ui_h,'Label','Add: N binary types','Callback','preprocess oneo');
uimenu(ui_h,'Label','Add: zeros','Callback','preprocess zero');
uimenu(ui_h,'Label','Remove component','Callback','preprocess remove');
uimenu(ui_h,'Label','Remove selected vectors',...
            'Callback','preprocess remove_vects');
uimenu(ui_h,'Label','Select all components',...
            'Callback','preprocess sel_all_comps');

ui_h=uimenu('Label','&Misc');
ui_h1=uimenu(ui_h,'Label','Calculate');
ui_h2=uimenu(ui_h,'Label','Process');

uimenu(ui_h,'Label','Get LOG-file','Callback','preprocess LOG');
uimenu(ui_h,'Label','Indices of the selected vectors',...
            'Callback','preprocess get_inds');
uimenu(ui_h,'Label','Undo','Callback','preprocess undo');
uimenu(ui_h1,'Label','Number of values','Callback','preprocess noof');
uimenu(ui_h1,'Label','Number of selected vectors',...
             'Callback','preprocess no_of_sel');
uimenu(ui_h1,'Label','Correlation','Callback','preprocess corr');
uimenu(ui_h2,'Label','Unit length','Callback','preprocess unit');
uimenu(ui_h2,'Label','Eval','Callback','preprocess eval2');
uimenu(ui_h2,'Label','Clipping','Callback','preprocess clipping');
uimenu(ui_h2,'Label','Delay','Callback','preprocess delay');
uimenu(ui_h2,'Label','Windowed','Callback','preprocess window');
uimenu(ui_h2,'Label','Select vectors','Callback','preprocess select');

len=getfield(size(sData(1).data),{1});
data.selected_vects=find(ones(1,len));
data.sD_set=sData;
set(data.vector_h,'ButtonDownFcn','preprocess(''vector_bdf'',''down'')');
set(gcf,'UserData',data);
if ~set_sD_stats;
  return;
end
sel_sD;
return;    %%% Preprocess-window is ready.

else
 arg=sData;
 if strcmp(arg,'rename')
   rename(arg2);
 elseif strcmp(arg,'sel_sD')
   if isempty(arg2)
     sel_sD;
   else
     sel_sD(arg2);
   end
 elseif strcmp(arg,'zscale')
   if isempty(arg2)
      zero2one_scale;
   else
      zero2one_scale(arg2);
   end
 elseif strcmp(arg,'vscale');
   if isempty(arg2)
      var_scale;
   else
      var_scale(arg2);
   end
 elseif strcmp(arg,'histeq2')
   if isempty(arg2)
     hist_eq2;
   else
     hist_eq2(arg2);
   end
 elseif strcmp(arg,'log')
   if isempty(arg2)
     logarithm;
   else
     logarithm(arg2);
   end
 elseif strcmp(arg,'eval1')
   if isempty(arg2)
     eval1;
   else
     eval1(arg2);
   end
 elseif strcmp(arg,'eval2')
   if isempty(arg2)
     eval2;
   else
     eval2(arg2);
   end
 elseif strcmp(arg,'histeq');
   if isempty(arg2)
     hist_eq;
   else
      hist_eq(arg2);
   end
 elseif strcmp(arg,'selall')
   if isempty(arg2)
     select_all;
   else
     select_all(arg2);
   end
 elseif strcmp(arg,'sel_button');
   if isempty(arg2)
     sel_button;
   else
     sel_button(arg2);
   end
 elseif strcmp(arg,'clear_button')
   if isempty(arg2)
     clear_button;
   else
     clear_button(arg2)
   end
 elseif(strcmp(arg,'move'))
   if isempty(arg2)
     move_component;
   else
     move_component(arg2);
   end
 elseif(strcmp(arg,'copy'))
   if isempty(arg2)
     copy_component;
   else
     copy_component(arg2);
   end
 elseif strcmp(arg,'oneo')
   if isempty(arg2)
     one_of_n;
   else
     one_of_n(arg2);
   end
 elseif strcmp(arg,'zero')
   if isempty(arg2)
     add_zeros;
   else
     add_zeros(arg2);
   end
 elseif strcmp(arg,'remove')
   if isempty(arg2)
     remove_component;
   else
     remove_component(arg2);
   end
 elseif strcmp(arg,'remove_vects')
   if isempty(arg2)
     remove_vects;
   else
     remove_vects(arg2);
   end
 elseif strcmp(arg,'noof')
   if isempty(arg2)
     no_of_values;
   else
     no_of_values(arg2);
   end
 elseif strcmp(arg,'corr');
   if isempty(arg2)
     correlation;
   else
     correlation(arg2);
   end
 elseif strcmp(arg,'unit')
   if isempty(arg2)
     unit_length;
   else
     unit_length(arg2);
   end
 elseif strcmp(arg,'clip_data')
   clip_data(arg2);
 elseif strcmp(arg,'copy_delete')
   copy_delete(arg2);
 elseif strcmp(arg,'and_or_cb')
   and_or_cb(arg2);
 elseif strcmp(arg,'all_sel_cb')
   all_sel_cb(arg2);
 elseif strcmp(arg,'clip_exp_cb')
   clip_exp_cb(arg2);
 elseif strcmp(arg,'window_cb')
   window_cb(arg2);
 elseif strcmp(arg,'set_state_vals')
   set_state_vals(arg2);
 elseif strcmp(arg,'vector_bdf')
   vector_bdf(arg2);
 elseif strcmp(arg,'sD_management');
   if isempty(arg2)
     sD_management;
   else
     sD_management(arg2);
   end
 elseif strcmp(arg,'clipping')
   if isempty(arg2)
     clipping;
   else
     clipping(arg2);
   end
 elseif strcmp(arg,'delay')
   if isempty(arg2)
     delay;
   else
     delay(arg2);
   end
 elseif strcmp(arg,'window');
   if isempty(arg2)
     window;
   else
     window(arg2);
   end
 elseif strcmp(arg,'select');
   if isempty(arg2)
     select;
   else
     select(arg2);
   end
 elseif strcmp(arg,'import')
   if isempty(arg2)
     import;
   else
     import(arg2);
   end
 elseif strcmp(arg,'export')
   if isempty(arg2)
     export;
   else
     export(arg2);
   end
 elseif strcmp(arg,'undo');
   if isempty(arg2)
     undo;
   else
     undo(arg2);
   end
 elseif strcmp(arg,'delay_data')
   if isempty(arg2)
     delay_data;
   else
     delay_data(arg2);
   end
 elseif strcmp(arg,'eval_windowed')
   if isempty(arg2)
     eval_windowed;
   else
     eval_windowed(arg2);
   end 
 elseif strcmp(arg,'get_inds')
   if isempty(arg2)
     get_selected_inds;
   else
     get_selected_inds(arg2);
   end
 elseif strcmp(arg,'no_of_sel')
   if isempty(arg2)
     no_of_selected;
   else
     no_of_selected(arg2);
   end
 elseif strcmp(arg,'sel_comp');
   if isempty(arg2)
     sel_comp;
   else
     sel_comp(arg2);
   end
 elseif strcmp(arg,'sel_all_comps')
   if isempty(arg2)
     select_all_comps;
   else
     select_all_comps(arg2);
   end 
 elseif strcmp(arg,'refresh')
   set_var_names;  
 elseif any(strcmp(arg,{'close_c','close_d','close_s','close_w','close_sD'}))
   if isempty(arg2)
     close_func(arg)
   else
     close_func(arg,arg2);
   end 
 end
 

 switch arg
   case 'sD_stats'
     sD_stats;
   case 'LOG'
     log_file;
   otherwise
     pro_tools(arg);
 end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_compnames(sData,h)

%SET_COMPNAMES
%
% set_compnames(sData,h)
%
% ARGUMENTS
%
%  sData     (struct)  som_data_struct
%  h         (scalar)  handle to a list box object
%
%
% This function sets the component names of sData to the list box
% indicated by 'h'. 
%

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  error('Figure ''Preprocess'' does not exist. Closing program...');
  close_preprocess;
end

udata=get(pre_h,'UserData');

set(h,'Value',[]);
for i=1:length(sData.comp_names)	
  tmp=sprintf('#%d: ',i);
  names{i,1}=cat(2,tmp, sData.comp_names{i});
end


set(h,'String',names,'Max',2);
set(udata.sel_comp_h,'String',names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw_vectors(vectors,h)

%DRAW_VECTORS
%
% draw_vectors(vectors,h)
%
% ARGUMENTS
%
%  vectors  (vector) vector of 0's and 1's
%  h        (scalar) handle to an axis object
%
%
%  This function draws an horizontal bar of 'vectors' in the axis
%  indicated by 'h'.
%
%

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
subplot(h);
hold off;
cla;

set(h,'YLim',[0 1]);
set(h,'YTick',[]);
set(h,'XLim',[0 length(vectors)+1]);
hold on;

comp_no=get(getfield(get(pre_h,'UserData'),'sel_comp_h'),'Value');
comp=getfield(get(pre_h,'UserData'),'sData');
comp=comp.data(:,comp_no);
Max = max(comp);
Min = min(comp);
lims=get(gca,'YLim');
lims(1)=Min;
h=abs(0.1*Max);
lims(2)=Max;
if Max - Min <= eps
  tmp=Max;
  lims(1)=tmp-1;
  lims(2)=tmp+1;
end
lims(2)=lims(2)+h;
if ~all(isnan(lims))
  set(gca,'YLim',lims);
end
h=(lims(2)-lims(1))/4;
set(gca,'YTickMode','auto'); 
t=1:length(vectors);
h=plot(t,comp);
set(h,'ButtonDownFcn','preprocess(''vector_bdf'',''down'')');
indices =find(vectors);
vectors(indices)=0.1*(getfield(get(gca,'YLim'),...
                      {2})-getfield(get(gca,'YLim'),{1}));
plot(indices,vectors(indices)+getfield(get(gca,'YLim'),{1}),...
     'ored','MarkerSize',4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vect_means(sData,handle,indices)

%VECT_MEANS
%
% vect_means(sData,handle,indices)
%
% ARGUMENTS
% 
%  sData    (struct)    som_data_struct
%  handle   (scalar)    handle to the static text box object
%  indices  (vector)    indices of selected vectors
%
%
% This function calculates means of selected vectors' components
% and writes them in the static text box indicated by 'handle'.
%
%

sData= sData.data(indices,:);

for i=1:length(sData(1,:))
  names{i}=sprintf('#%d: ',i);
end


for i=1:length(sData(1,:))
  tmp=sData(:,i);
  tmp=cat(2,names{i},sprintf('%-10.3g',mean(tmp(find(~isnan(tmp))))));
  string{i}=tmp;
end

set(handle,'String',string);
set(handle,'HorizontalAlignment','left');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vector_bdf(arg)

%VECTOR_BDF   A button down function.
%
% vector_bdf(arg)
%
% ARGUMENTS
%
%  arg      (string)  'down' or 'up',  tells the mouse button's state.
%                     
%
%  This function selects vectors in the vector-window and plots maxima,
%  minima and means of the selected vectors. It also writes means of the
%  selected vectors' components in a static text box and takes care of
%  changes of the chosen component's data.
%
%  See also VECTOR_MEANS, SEL_COMP
%
%
 

arg2=arg(6:length(arg));
if ~isempty(arg2)
  LOG=1;
else
  LOG=0;
end
arg=arg(1:4);

%%% arg's first "word" is 4 letters long and it can be:
%%%
%%% 'key '
%%% 'down'
%%% 'drag'
%%% 'up  '

if strcmp(arg,'key ') %string is 'key' + 1 space!!!
  if ~LOG
    key=get(gcf,'CurrentCharacter');
   else 
    key=arg2
  end
  if ~strcmp(key,'<') && ~strcmp(key,'>')
    return;
  end
  data=get(gcf,'UserData');
  sel=data.selected_vects;
  if length(sel) == 1
    if strcmp(key,'<') && sel ~= 1 
      data.selected_vects=sel-1;
      set(gcf,'UserData',data);
     elseif strcmp(key,'>') && sel ~= length(data.sData.data(:,1))
      data.selected_vects = sel + 1;
      set(gcf,'UserData',data);
     end
  else
    if strcmp(key,'<') && sel(1) ~= 1
      data.selected_vects=cat(2,sel(1)-1,sel);
      set(gcf,'UserData',data);
     elseif strcmp(key,'>') && sel(length(sel)) ~= length(sel)
      data.selected_vects=cat(2,sel,sel(length(sel))+1);
      set(gcf,'UserData',data);
     end
  end
  cplot_mimema;
  pro_tools('plot_hist');
  pro_tools('c_stat');
  vects=zeros(1,length(data.sData.data(:,1)));
  vects(data.selected_vects)=1;
  draw_vectors(vects,data.vector_h);
 
  if ~LOG
    data=get(gcf,'UserData');
    data.LOG{length(data.LOG)+1}=...
    sprintf('preprocess(''vector_bdf'',''key  %s'');',key);
                                                %string is 'key'+2spaces+%s
    set(gcf,'UserData',data);
  end
  return;
end

switch arg
  case 'down'
   set(gcf,'WindowButtonUpFcn','preprocess(''vector_bdf'',''up  '')');
   set(gcf,'WindowButtonMotionFcn','preprocess(''vector_bdf'',''drag'')');
   switch get(gcf,'SelectionType')
     case 'normal'
      data.lims1=round(getfield(get(gca,'CurrentPoint'),{1,1}));
      data.lims2=[];
     case 'alt'
      tmp=round(getfield(get(gca,'CurrentPoint'),{1,1}));
      if isempty(get(gca,'UserData'))
        data.lims1=tmp;
        data.lims2=[];
      else
        data.lims1=cat(2,getfield(get(gca,'UserData'),'lims1'),tmp);
        data.lims2=getfield(get(gca,'UserData'),'lims2');
      end
   end
   coords=get(gca,'CurrentPoint');
   h=line([coords(1),coords(1)],get(gca,'YLim'),'EraseMode','xor');
   set(h,'Color','red');
   h2=line([coords(1),coords(1)],get(gca,'YLim'),'EraseMode','xor');
   set(h2,'Color','red');
   data.h=h;
   data.h2=h2;
   set(gca,'UserData',data);

  case 'drag'
   coords=get(gca,'CurrentPoint');
   lim=get(gca,'XLim');
   h2=getfield(get(gca,'UserData'),'h2');
   if lim(1) >= coords(1)
     set(h2,'XData',[lim(1) lim(1)]);
   elseif lim(2) <= coords(2)
     set(h2,'XData',[lim(2) lim(2)]);
   else
     set(h2,'XData',[coords(1) coords(1)]);
   end
  case 'up  '   % string is 'up' + 2 spaces!!! 
   set(gcf,'WindowButtonUpFcn','');
   set(gcf,'WindowButtonMotionFcn','');
   if ~LOG
     data=get(gca,'UserData');
     delete(data.h);
     delete(data.h2);
     tmp=round(getfield(get(gca,'CurrentPoint'),{1,1}));
     data.lims2=cat(2,data.lims2,tmp);
     tmp_data=sort(cat(1,data.lims1,data.lims2));
     high=getfield(get(gca,'XLim'),{2})-1;
     vectors=zeros(1,high);
     tmp_data(find(tmp_data<1))=1;
     tmp_data(find(tmp_data>high))=high;

     for i=1:getfield(size(tmp_data),{2})
       vectors(tmp_data(1,i):tmp_data(2,i))=1;
     end
     selected_vects=find(vectors);
   else
     pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
     len=size(getfield(getfield(get(pre_h,'UserData'),'sData'),'data'));
     vectors=zeros(1,len(1));
     i=1;
     while i <= length(arg2) && (isspace(arg2(i)) || ~isletter(arg2(i)))
      i=i+1;
     end
     arg3=arg2(i:length(arg2));
     selected_vects=str2num(arg2(1:i-1));
     if ~isempty(arg3) && ~all(isspace(arg3))
       selected_vects=unique(cat(2,selected_vects,...
                            getfield(get(pre_h,'UserData'),'selected_vects')));
     end           
     vectors(selected_vects)=1;  
     set(pre_h,'CurrentAxes',getfield(get(pre_h,'UserData'),'vector_h'));
     set(0,'CurrentFigure',pre_h);
   end
   draw_vectors(vectors,gca);
   sData=getfield(get(gcf,'UserData'),'sData');
   h=getfield(get(gcf,'UserData'),'vect_mean_h');
   vect_means(sData,h,selected_vects);
   if ~LOG
     set(gca,'UserData',data);
   end
   data=get(gcf,'UserData');  
   data.undo.sData=data.sData;
   data.undo.selected=data.selected_vects;
   data.selected_vects=selected_vects;
   if ~LOG
     data.LOG{length(data.LOG)+1}='% Vector selection by using the mouse...';
     tmp=sprintf('preprocess(''vector_bdf'',''up   %s'');',...
                num2str(data.selected_vects));
     if length(tmp) > 500
       tmp=textwrap({tmp},500);
       data.LOG{length(data.LOG)+1}=cat(2,tmp{1},''');');
       for i=2:length(tmp)-1
         data.LOG{length(data.LOG)+1}=...
               cat(2,sprintf('preprocess(''vector_bdf'',''up   %s',...
                     tmp{i}),'add'');');
       end
       data.LOG{length(data.LOG)+1}=...
             cat(2,sprintf('preprocess(''vector_bdf'',''up   %s',...
                   tmp{length(tmp)}(1:length(tmp{length(tmp)})-3)),' add'');');
     else
       data.LOG{length(data.LOG)+1}=tmp;
     end
   end   
   set(gcf,'UserData',data);
   cplot_mimema;
   sel_comp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sel_button(varargin) 

%SEL_BUTTON     A Callback function. It performs the operations needed
%               when vector components are selected.
%
% See also SEL_COMP
%

if nargin == 1
  LOG=1;
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  string=getfield(get(pre_h,'UserData'),'comp_names_h');
  string=getfield(get(string,'String'),{str2num(varargin{1})});
  set(0,'CurrentFigure',pre_h);
else
  LOG=0;
  val=get(getfield(get(gcf,'UserData'),'comp_names_h'),'Value');
end

sel_button_h=getfield(get(gcf,'UserData'),'sel_button_h');
sel_comps_h=getfield(get(gcf,'UserData'),'sel_comps_h');
comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
if ~LOG
  string=getfield(get(comp_names_h,'String'),{get(comp_names_h,'Value')});
end
tmp_string=get(sel_comps_h,'String');

if iscell(tmp_string)

  for i=1:length(string)
    if ~any(strcmp(string{i},tmp_string))
      tmp_string=cat(1,tmp_string,string(i));
    end
  end
  string=tmp_string;
end

set(sel_comps_h,'String',string);
set(comp_names_h,'Value',[]);
sel_comp;
if ~LOG
  data=get(gcf,'UserData');
  data.LOG{length(data.LOG)+1}='% Select components';
  data.LOG{length(data.LOG)+1}=sprintf('preprocess(''sel_button'',''%s'');',...
                                        num2str(val));
  set(gcf,'UserData',data);
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clear_button(varargin)

%CLEAR_BUTTON  Function callback evaluated when a 'Clear'-button is
%              pressed. It removes texts from the 'selected components' 
%              -window and the 'selected component data' -window and
%              clears the 'histogram' -axis.
%
%

if nargin==1
  LOG=1;
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  set(0,'CurrentFigure',pre_h);
else
  LOG=0;
end

sel_comp_h=getfield(get(gcf,'UserData'),'sel_comp_h');
sel_cdata_h=getfield(get(gcf,'UserData'),'sel_cdata_h');
sel_cplot_h=getfield(get(gcf,'UserData'),'sel_cplot_h');
sel_chist_h=getfield(get(gcf,'UserData'),'sel_chist_h');
vector_h=getfield(get(gcf,'UserData'),'vector_h');

set(sel_comp_h,'Value',1);
set(sel_cdata_h,'String',' ');
subplot(sel_chist_h);
hold off;
cla;

selected=getfield(get(gcf,'UserData'),'selected_vects');
dims=size(getfield(getfield(get(gcf,'UserData'),'sData'),'data'));
vectors=zeros(1,dims(1));
vectors(selected)=1;
subplot(vector_h);
draw_vectors(vectors,vector_h);
if ~LOG
  data=get(gcf,'UserData');
  data.LOG{length(data.LOG)+1}='% Remove components from the selected list.';
  data.LOG{length(data.LOG)+1}='preprocess(''clear_button'',''foo'');';
  set(gcf,'UserData',data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sel_comp(varargin)

%SEL_COMP  performs the operations needed when vector components are
%          chosen. It writes maxima, minima, mean and standard deviation
%          of the chosen component to a text box window and draws a
%          histogram of the chosen component of selected vectors' 
%
%

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
set(0,'CurrentFigure',pre_h);
sel_comp_h=getfield(get(pre_h,'UserData'),'sel_comp_h');

if nargin == 1
  set(sel_comp_h,'Value',str2num(varargin{1}));
elseif ~isempty(gcbo)
  no=get(sel_comp_h,'Value');
  data=get(gcf,'UserData');
  data.LOG{length(data.LOG)+1}='% Select one component';
  data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''sel_comp'',''',...
                                      num2str(no),''');');
  set(gcf,'UserData',data);
end

pro_tools('c_stat');
pro_tools('plot_hist');
data=get(gcf,'UserData');
sData=data.sData;  
vector_h=data.vector_h;
len=length(sData.data(:,1));
vects=zeros(1,len);
vects(data.selected_vects)=1;
draw_vectors(vects,vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cplot_mimema

global no_of_sc

sData=getfield(get(gcf,'UserData'),'sData');
sel_cplot_h=getfield(get(gcf,'UserData'),'sel_cplot_h');
selected=getfield(get(gcf,'UserData'),'selected_vects');

set(sel_cplot_h,'YLim',[0 length(sData.data(1,:))+1]);

subplot(sel_cplot_h);
hold off;
cla;
hold on;

for i=1:length(sData.data(1,:))
  Max=max(sData.data(:,i));
  Min=min(sData.data(:,i));
  tmp=sData.data(selected,i);

  selMax=max(tmp);
  selMin=min(tmp);
  Mean=abs(mean(tmp(find(~isnan(tmp)))));
  Median=abs(median(tmp(find(~isnan(tmp)))));
  
  if Max ~= Min && ~all(isnan(sData.data(:,i)))

    if rem(i,no_of_sc)   % no_of_sc is defined in the beginning of this file...

      line([abs(selMin-Min)/(Max-Min) (selMax-Min)/(Max-Min)],...
           [i i],'Color','black');
      plot(abs(Mean-Min)/(Max-Min),i,'oblack');
      plot(abs(Median-Min)/(Max-Min),i,'xblack');
    else
      line([abs(selMin-Min)/(Max-Min) (selMax-Min)/(Max-Min)],...
           [i i],'Color','black','LineWidth',2);
      plot(abs(Mean-Min)/(Max-Min),i,'oblack','LineWidth',2);
      plot(abs(Median-Min)/(Max-Min),i,'xblack','LineWidth',2);
    end
  else

    if rem(i,no_of_sc)     % N is defined in the beginning of this file.

      plot(mean(get(gca,'XLim')),i,'oblack');
      plot(mean(get(gca,'XLim')),i,'xblack');
    else
      plot(mean(get(gca,'XLim')),i,'oblack','LineWidth',2);
      plot(mean(get(gca,'XLim')),i,'xblack','LineWidth',2);
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function bool=set_sD_stats

%SET_SD_STATS Writes the data set names to popup menu.
%
%

bool=1;
data=get(gcf,'UserData');

for i=1:length(data.sD_set)
 % if ~isvalid_var_name({data.sD_set(i).name})
 %   close_preprocess;
 %   bool=0;
 %   return;
 % end
  string{i}=cat(2,sprintf('#%d: ',i),data.sD_set(i).name);
end

set(data.sD_set_h,'String',string);
data.sData=data.sD_set(get(data.sD_set_h,'Value'));
data.sData.MODIFIED=0;
data.sData.INDEX=1;
set(gcf,'UserData',data);
write_sD_stats;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_sD_stats

%WRITE_SD_STATS  writes data's name, length and dimension to text box.
%
%

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');


sD_name_h=getfield(get(pre_h,'UserData'),'sD_name_h');
sData=getfield(get(pre_h,'UserData'),'sData');
dims=size(sData.data);
string{1}=cat(2,'Name:   ',sData.name);
string{2}=cat(2,'Length: ',sprintf('%d',dims(1)));
string{3}=cat(2,'Dim:     ',sprintf('%d',dims(2)));

set(sD_name_h,'String',string);
set(sD_name_h,'HorizontalAlignment','left');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sel_sD(varargin)

%SEL_SD  sets new data to UserData's 'sData'.
%        
%

if nargin==1
  LOG=1;
  index=str2num(varargin{1});
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  set(0,'CurrentFigure',pre_h);
else
  LOG=0;
end

sD_set_h=getfield(get(gcf,'UserData'),'sD_set_h');
comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
vector_h=getfield(get(gcf,'UserData'),'vector_h');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');

if ~LOG
  index=get(sD_set_h,'Value');
end
data=get(gcf,'UserData');
data.undo = [];
INDEX=data.sData.INDEX;
data.sData=rmfield(data.sData,'MODIFIED'); 
data.sData=rmfield(data.sData,'INDEX');

tmp=data.sD_set(index);
tmp.MODIFIED=0;
tmp.INDEX=index;
data.sD_set(INDEX)=data.sData;
data.sData=tmp;

len=getfield(size(tmp.data),{1});

data.selected_vects=find(ones(1,len));
if ~LOG
  data.LOG{length(data.LOG)+1}='% Select a new data set.';
  data.LOG{length(data.LOG)+1}=sprintf('preprocess(''sel_sD'',''%s'');',...
                                        num2str(index));
end
set(gcf,'UserData',data);
write_sD_stats;
set_compnames(tmp,comp_names_h);
draw_vectors(ones(1,len),vector_h);
vect_means(tmp,vect_mean_h,data.selected_vects);
clear_button;
sel_comp;
cplot_mimema;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function indices=get_indices

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

comp_names_h=getfield(get(pre_h,'UserData'),'comp_names_h');
indices = get(comp_names_h,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sD_management(varargin)

if nargin ~= 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
           '% Starting the ''Data Set Management'' -window...';
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
                 'preprocess(''sD_management'',''foo'');';
  set(pre_h,'UserData',preh_udata);
end 

man_h=findobj(get(0,'Children'),'Tag','Management');
if ~isempty(man_h)
  figure(man_h);
  return;
end

h0 = figure('BackingStore','off', ...
	'Color',[0.8 0.8 0.8], ...
	'Name','Data Set Management', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[753 523 324 470], ...
	'RendererMode','manual', ...
	'Tag','Management');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Max',2, ...
	'Position',[0.02777777777777778 0.0723404255319149 0.7716049382716049 0.1914893617021277], ...
	'String',' ', ...
	'Style','edit', ...
	'Tag','EditText1');

data.new_c_name_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess rename comp',...
	'Units','normalized', ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.8240740740740741 0.2106382978723404 0.154320987654321 0.05319148936170213], ...
	'String','RENAME', ...
	'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess close_sD',...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.8240740740740741 0.01914893617021277 0.154320987654321 0.05319148936170213], ...
	'String','CLOSE', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.02777777777777778 0.2680851063829787 0.345679012345679 0.02978723404255319], ...
	'String','COMPONENTS:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'Position',[0.02777777777777778 0.3170212765957447 0.3549382716049382 0.5319148936170213], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);

data.sets_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'Position',[0.6234567901234568 0.3170212765957447 0.3549382716049382 0.5319148936170213], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',1);


data.variables_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess export',...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.4259259259259259 0.551063829787234 0.154320987654321 0.0425531914893617], ...
	'String','->', ...
	'Tag','Pushbutton4');

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess import',...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.4259259259259259 0.625531914893617 0.154320987654321 0.0425531914893617], ...
	'String','<-', ...
	'Tag','Pushbutton3');



h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.02777777777777778 0.8531914893617022 0.2993827160493827 0.02978723404255319], ...
	'String','DATA SETS', ...
	'Style','text', ...
	'Tag','StaticText2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.6234567901234568 0.8531914893617022 0.2561728395061728 0.02978723404255319], ...
	'String','WORKSPACE', ...
	'Style','text', ...
	'Tag','StaticText3');

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess rename set',...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1820987654320987 0.9127659574468086 0.7808641975308641 0.0425531914893617], ...
	'Style','edit', ...
	'Tag','EditText2');

data.new_name_h = h1;


h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.02777777777777778 0.9127659574468086 0.1388888888888889 0.02978723404255319], ...
	'String','NAME:', ...
	'Style','text', ...
	'Tag','StaticText4');


ui_h=uimenu('Label','&Tools');
uimenu(ui_h,'Label','Copy','Callback','preprocess copy_delete copy');
uimenu(ui_h,'Label','Delete','Callback','preprocess copy_delete delete');
uimenu(ui_h,'Label','Refresh','Callback','preprocess refresh');

set(gcf,'UserData',data);
set_var_names;
sD_names;
sD_stats;



%%% Subfunction: set_var_names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_var_names


variables_h=getfield(get(gcf,'UserData'),'variables_h');
value=get(variables_h,'Value');
len=evalin('base','length(who)');

names=cell(len,1);

for i=1:len
  string=cat(2,'getfield(who,{',num2str(i),'})');
  names(i)=evalin('base',string);
end

set(variables_h,'String',names);
if(value > length(names))
  set(variables_h,'Value',1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: sD_names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sD_names

sets_h=getfield(get(gcf,'UserData'),'sets_h');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

sD_set = getfield(get(pre_h,'UserData'),'sD_set');

for i=1:length(sD_set)
  names{i,1}=cat(2,sprintf('#%d: ',i),sD_set(i).name);
end

set(sets_h,'String',names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: sD_stats %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sD_stats

man_h=findobj(get(0,'Children'),'Tag','Management');
c_names_h=getfield(get(man_h,'UserData'),'new_c_name_h');
sD_name_h=getfield(get(man_h,'UserData'),'new_name_h');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
INDEX=getfield(getfield(get(pre_h,'UserData'),'sData'),'INDEX');
MODIFIED=getfield(getfield(get(pre_h,'UserData'),'sData'),'MODIFIED');
value=get(getfield(get(man_h,'UserData'),'sets_h'),'Value');
 
if value==INDEX
  data=get(pre_h,'UserData');
  sData=rmfield(data.sData,[{'INDEX'};{'MODIFIED'}]);
  data.sD_set(INDEX)=sData;
  data.sData.MODIFIED=0;
  set(pre_h,'UserData',data);
end      

sData=getfield(getfield(get(pre_h,'UserData'),'sD_set'),{value});
string1=[{sData.name}];


set(sD_name_h,'String',string1);
set(c_names_h,'String',sData.comp_names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: import %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function import(varargin)

if nargin==1
  LOG=1;
  man_h=findobj(get(0,'Children'),'Tag','Management');
  set(0,'CurrentFigure',man_h);
  name=varargin;
else 
  LOG=0;
end

variables_h=getfield(get(gcf,'UserData'),'variables_h');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
if ~LOG
  name=getfield(get(variables_h,'String'),{get(variables_h,'Value')});
end
errstr='Data to be imported must be real matrix or ''som_data_struct''.';
new_sD=evalin('base',name{1});

if isempty(pre_h)
  errordlg('''Preprocess'' -figure does not exist. Terminating program...');
  close_preprocess;
  return;
end

if ischar(new_sD) || (~isstruct(new_sD) && ~isreal(new_sD))
  errordlg(errstr);
  return;
elseif isstruct(new_sD) && length(new_sD) > 1
  errordlg(errstr)
  return;
elseif ~isstruct(new_sD)
  new_sD=som_data_struct(new_sD);
  new_sD.name=name{1};
end

new_sD_names=fieldnames(new_sD);
right_names=fieldnames(som_data_struct(1));
for i=1:length(new_sD_names)
  if ~any(strcmp(new_sD_names(i),right_names));
    errordlg(errstr);
    return;
  end
end

data=get(pre_h,'UserData');
data.sD_set(length(data.sD_set) + 1)=new_sD;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Import a data set from the workspace.';
  data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''import'',''',...
                                    name{1},''');');
end
set(pre_h,'UserData',data);
sD_names;
sD_stats;
old =gcf;
set(0,'CurrentFigure',pre_h);
set_sD_stats;
set(0,'CurrentFigure',old);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: export %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function export(varargin)

if nargin == 1
  LOG=1;
  man_h=findobj(get(0,'Children'),'Tag','Management');
  set(0,'CurrentFigure',man_h);
  index=str2num(varargin{1});  
else
  LOG=0;
end

sets_h=getfield(get(gcf,'UserData'),'sets_h');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if ~LOG
  index=get(sets_h,'Value');
end

if isempty(pre_h)
  errordlg('''Preprocess''-figure does not exist. Terminating program...');
  close(findobj(get(0,'Children'),'Tag','Management'));
  close(findobj(get(0,'Children'),'Tag','PlotWin'));
  return;
end

sData=getfield(getfield(get(pre_h,'UserData'),'sD_set'),{index});

if ~isvalid_var_name({sData.name})
  return;
end

assignin('base',sData.name,sData);
disp(sprintf('Data set ''%s'' is set to the workspace.',sData.name));
if ~LOG
  data=get(pre_h,'UserData');
  data.LOG{length(data.LOG)+1}='% Export a data set to the workspace.';
  data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''export'',''',...
                                   num2str(index),''');');
  set(pre_h,'UserData',data);
end
set_var_names;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Subfunction: rename %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rename(arg)

i=1;
while i <= length(arg) && arg(i) ~= ' '
  i=i+1;
end

arg2=arg(i+1:length(arg));
arg=arg(1:i-1);
if ~isempty(arg2)
  LOG=1;
  i=1;
  if arg2(1) ~= '{'
    while i <= length(arg2) && arg2(i) ~= ' '
      i=i+1;
    end
    index=str2num(arg2(i+1:length(arg2)));
    arg2=arg2(1:i-1);
  else
    while i <= length(arg2) && arg2(i) ~= '}'
      i=i+1;
    end
    index=str2num(arg2(i+1:length(arg2)));
    arg2=arg2(1:i);
  end
else
  LOG=0;
end

new_name_h=getfield(get(gcf,'UserData'),'new_name_h');
new_c_name_h=getfield(get(gcf,'UserData'),'new_c_name_h');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  errordlg('''Preprocess'' -figure does not exist. Terminating program...');
  close_preprocess;
  return;
end

switch arg
  case 'set'
   if LOG
     name={arg2};
   else
     name=get(new_name_h,'String');
   end
   if ~isempty(name{1}) && ~any(isspace(name{1}))
     if ~isvalid_var_name(name)
       sD_stats;
       return;
     end
     if ~LOG
       index=get(getfield(get(gcf,'UserData'),'sets_h'),'Value');
     end
     data=get(pre_h,'UserData');
     tmp_set.name=name{1};        
     data.sD_set(index).name=name{1};
     if data.sData.INDEX == index
       data.sData.name=name{1};
     end
     if ~LOG
       data.LOG{length(data.LOG)+1}='% Rename a data set.';
       data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''rename'',''set ',...
                                                       name{1},' ',...
                                                       num2str(index),...
                                                       ''');');
     end 

     set(pre_h,'UserData',data);
     sD_names;
     string=get(data.sD_set_h,'String');
     string{index}=cat(2,sprintf('#%d: ',index),name{1});
     set(data.sD_set_h,'String',string);
     string=get(data.sD_name_h,'String');
     string{1}=cat(2,'Name:   ',name{1});
     if index==data.sData.INDEX
       set(data.sD_name_h,'String',string);
     end
   else
     sD_stats;
   end
  case 'comp'
   if ~LOG
     names=get(new_c_name_h,'String');
     index=get(getfield(get(gcf,'UserData'),'sets_h'),'Value');
   else
     names=eval(arg2);
   end
   if check_cell_names(names)
     data=get(pre_h,'UserData');
     sData=data.sD_set(index);
     if length(sData.comp_names)==length(names)
       data.sD_set(index).comp_names=names;
       if index == data.sData.INDEX
         for i=1:length(names)
           names{i}=cat(2,sprintf('#%d: ',i),names{i});
         end
         set(data.comp_names_h,'String',names);
         set(data.sel_comp_h,'String',names);
       end
       if ~LOG
         data.LOG{length(data.LOG)+1}='% Rename components.';
         str='preprocess(''rename'',''comp {';
         for i=1:length(names)-1
           str=cat(2,str,'''''',names{i},''''',');
         end
         str=cat(2,str,'''''',names{length(names)},'''''} ',...
                 num2str(index),''');');
         data.LOG{length(data.LOG)+1}=str;
       else
         set(new_c_name_h,'String',names);
       end
       set(pre_h,'UserData',data);          
     else
       errordlg('There are less components in data.');
       sD_stats;
       return;
     end
   else
     sD_stats;  
   end
end

%%% Subfunction: check_cell_names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool=check_cell_names(names)

bool = 1;

if isempty(names)
  bool= 0;
  return;
end
for i=1:length(names)
  if isempty(names{i}) || isspace(names{i})
    bool = 0;
    return;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: isvalid_var_name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool=isvalid_var_name(name)

bool=1;

tmp=name{1};
if ~((tmp(1)>='a' && tmp(1)<='z') || (tmp(1)>='A' && tmp(1)<='Z'))
  errordlg('Invalid name.');
  bool=0;
  return;
end
for j=1:length(tmp)
  if ~((tmp(j)>='a' && tmp(j)<='z') || ...
       (tmp(j)>='A' && tmp(j)<='Z') || ...
       (j>1 && tmp(j) == '_') || ...
       (tmp(j)>='0' && tmp(j) <= '9')) || tmp(j) == '.'
    errordlg('Invalid name.');
    bool=0;
    return;
  end
  if j == length(tmp) && tmp(j) == '_'
    errordlg('Invalid name.');
    bool=0;
    return;
  end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: copy_delete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function copy_delete(arg)

i=1;
while i <= length(arg) && arg(i) ~= ' '
  i=i+1;
end

arg2=arg(i+1:length(arg));
arg=arg(1:i-1);

if ~isempty(arg2)
  index=str2num(arg2);
  LOG=1;
else
  LOG=0;
end

sets_h=getfield(get(gcf,'UserData'),'sets_h');
if ~LOG
  index=get(sets_h,'Value');
end
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  errordlg('''Preprocess'' -figure does not exist. Terminating program.');
  close_preprocess;
  return;
end

switch arg
  case 'copy'
   data=get(pre_h,'UserData');
   data.sD_set(length(data.sD_set)+1)=data.sD_set(index);
   if ~LOG
     data.LOG{length(data.LOG)+1}='% Copy a data set.';
     data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''copy_delete'',''',...
                                      'copy ',num2str(index),''');');
   end
   set(pre_h,'UserData',data);
   sD_names;   
   old=gcf;
   set(0,'CurrentFigure',pre_h);
   set_sD_stats;
   set(0,'CurrentFigure',old);
  case 'delete'
   if length(get(sets_h,'String')) == 1
     msgbox('No data left. Closing program...')
     close_preprocess;
     return;
   end
   data=get(pre_h,'UserData');
   if ~isempty(data.undo) &&  any(strcmp('index',fieldnames(data.undo)))
     if data.undo.index > index
       data.undo.index = data.undo.index-1;
     elseif data.undo.index==index;
       data.undo=[];
     end
   end
   set1=data.sD_set(1:index-1);
   set2=data.sD_set(index+1:length(data.sD_set));

   if ~isempty(set1)
     data.sD_set=[set1 set2];
   else
     data.sD_set=set2;
   end
   if ~LOG
     data.LOG{length(data.LOG)+1}='% Delete a data set.';
     data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''copy_delete'',''',...
                                      'delete ',num2str(index),''');');
   end
   set(pre_h,'UserData',data);

   set(sets_h,'Value',1);
   sD_names;
   sD_stats;
   old = gcf;
   set(0,'CurrentFigure',pre_h);

   for i=1:length(data.sD_set)
     string{i}=cat(2,sprintf('#%d: ',i),data.sD_set(i).name);
   end

   set(data.sD_set_h,'String',string);
   data.sData=data.sD_set(get(data.sD_set_h,'Value'));
   data.sData.MODIFIED=0;
   data.sData.INDEX=1;
   set(gcf,'UserData',data);
   write_sD_stats;

   sData=getfield(get(gcf,'UserData'),'sData');
   if sData.INDEX > index
     value=get(getfield(get(gcf,'UserData'),'sD_set_h'),'Value');
     set(getfield(get(gcf,'UserData'),'sD_set_h'),'Value',value-1);
     sData.INDEX = sData.INDEX -1;
   elseif sData.INDEX == index
     set(getfield(get(gcf,'UserData'),'sD_set_h'),'Value',1);
   end
 
   sel_sD;
   set(0,'CurrentFigure',old);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clipping(varargin)

if nargin ~= 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
        '% Starting the ''Clipping'' -window...';
  preh_udata.LOG{length(preh_udata.LOG)+1}='preprocess(''clipping'',''foo'');';
  set(pre_h,'UserData',preh_udata);
end

clip_h=findobj(get(0,'Children'),'Tag','Clipping');

if ~isempty(clip_h)
  figure(clip_h);
  return;
end

h0 = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 575 432], ...
	'PaperUnits','points', ...
	'Position',[718 389 300 249], ...
	'Tag','Clipping');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.03 0.03614457831325301 0.4666666666666667 0.9236947791164658], ...
	'Style','frame', ...
	'Tag','Frame1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.05333333333333334 0.5983935742971887 0.42 0.3333333333333333], ...
	'Style','frame', ...
	'Tag','Frame2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Style','frame', ...
	'Position',[0.05333333333333334 0.33 0.42 0.24], ...
	'Tag','Frame3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Style','frame', ...
	'Position',[0.05333333333333334 0.06 0.42 0.24],...
	'Tag','Frame4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'ListboxTop',0, ...
	'Position',[0.5133333333333334 0.6385542168674698 0.4666666666666667 0.321285140562249], ...
	'Style','frame', ...
	'Tag','Frame5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.5366666666666667 0.6666666666666666 0.42 0.2650602409638554], ...
	'Style','frame', ...
	'Tag','Frame6');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.31 0.823293172690763 0.15 0.09638554216867469], ...
	'Style','edit', ...
	'Tag','EditText1');

data.big_val_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.31 0.7148594377510039 0.15 0.09638554216867469], ...
	'Style','edit', ...
	'Tag','EditText2');

data.small_val_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.31 0.606425702811245 0.15 0.09638554216867469], ...
	'Style','edit', ...
	'Tag','EditText3');

data.equal_val_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.06000000000000001 0.8473895582329316 0.22 0.05622489959839357], ...
	'String','Bigger than', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.06000000000000001 0.7389558232931727 0.24 0.04819277108433735], ...
	'String','Smaller than', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.06000000000000001 0.610441767068273 0.22 0.07228915662650602], ...
	'String','Equal to', ...
	'Style','text', ...
	'Tag','StaticText3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.07000000000000001 0.465863453815261 0.06333333333333334 0.07228915662650602], ...
	'Style','radiobutton', ...
	'Value',1,...
	'Tag','Radiobutton1');

data.and_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.07000000000000001 0.3734939759036144 0.06333333333333334 0.07228915662650602], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton2');

data.or_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'Position',[0.1466666666666667 0.45 0.2333333333333333 0.07228915662650602], ...
	'String','AND', ...
	'Style','text', ...
	'Tag','StaticText4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'String','OR', ...
	'Position',[0.1466666666666667 0.35 0.2333333333333333 0.07228915662650602], ...
	'Style','text', ...
	'Tag','StaticText5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.07000000000000001 0.1967871485943775 0.06333333333333334 0.07228915662650602], ...
	'Style','radiobutton', ...
	'Value',1,...
	'Tag','Radiobutton3');

data.all_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.07000000000000001 0.09236947791164658 0.06333333333333334 0.07228915662650602], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton4');

data.sel_vects_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1466666666666667 0.1927710843373494 0.2333333333333333 0.07228915662650602], ...
	'String','All vectors', ...
	'Style','text', ...
	'Tag','StaticText6');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1466666666666667 0.09638554216867469 0.3133333333333334 0.05622489959839357], ...
	'String','Among selected', ...
	'Style','text', ...
	'Tag','StaticText7');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.7866666666666667 0.823293172690763 0.1366666666666667 0.09236947791164658], ...
	'Style','edit', ...
	'Tag','EditText4');

data.replace_val_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',6, ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.5633333333333334 0.8273092369477911 0.2066666666666667 0.07630522088353413], ...
	'String','Replace', ...
	'Style','text', ...
	'Tag','StaticText8');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.5700000000000001 0.6827309236947791 0.3566666666666667 0.08032128514056225], ...
	'String','Replace', ...
	'Tag','Pushbutton1');

data.OK_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess close_c',...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.6633333333333333 0.07228915662650602 0.2833333333333333 0.09638554216867469], ...
	'String','Close', ...
	'Tag','Pushbutton2');


data.state.and=1;
data.state.all=1;
data.state.big=[];
data.state.small=[];
data.state.equal=[];
data.state.replace=[];

set(data.or_button_h,'Callback','preprocess and_or_cb or');
set(data.and_button_h,'Callback','preprocess and_or_cb and');
set(data.and_button_h,'Value',1);
set(data.all_button_h,'Callback','preprocess all_sel_cb all');
set(data.sel_vects_button_h,'Callback','preprocess all_sel_cb sel');
set(data.big_val_h,'Callback','preprocess set_state_vals big');
set(data.small_val_h,'Callback','preprocess set_state_vals small');
set(data.equal_val_h,'Callback','preprocess set_state_vals equal');
set(data.replace_val_h,'Callback','preprocess set_state_vals replace');
set(data.OK_button_h,'Callback','preprocess clip_data clip');
set(h0,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function select(varargin)

if nargin ~= 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
      '% Starting the ''Select'' -window...';
  preh_udata.LOG{length(preh_udata.LOG)+1}='preprocess(''select'',''foo'');';
  set(pre_h,'UserData',preh_udata);
end

sel_h=findobj(get(0,'Children'),'Tag','Select');

if ~isempty(sel_h)
  figure(sel_h);
  return;
end

h0 = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[750 431 168 365], ...
	'Tag','Select');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.05357142857142857 0.2712328767123288 0.8333333333333333 0.6301369863013698], ...
	'Style','frame', ...
	'Tag','Frame1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.05357142857142857 0.1041095890410959 0.8333333333333333 0.1397260273972603], ...
	'Style','frame', ...
	'Tag','Frame2');

h1 = uicontrol('Parent',h0,...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.09523809523809523 0.6547945205479452 0.75 0.2273972602739726], ...
	'Style','frame', ...
	'Tag','Frame3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.09523809523809523 0.4794520547945206 0.75 0.1506849315068493], ...
	'Style','frame', ...
	'Tag','Frame4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.09523809523809523 0.2986301369863014 0.75 0.1506849315068493], ...
	'Style','frame', ...
	'Tag','Frame5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.5535714285714285 0.8082191780821918 0.2678571428571429 0.06575342465753425], ...
	'Style','edit', ...
	'Tag','EditText1');

data.big_val_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.5535714285714285 0.7342465753424657 0.2678571428571429 0.06575342465753425], ...
	'Style','edit', ...
	'Tag','EditText2');

data.small_val_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.5535714285714285 0.6602739726027397 0.2678571428571429 0.06575342465753425], ...
	'Style','edit', ...
	'Tag','EditText3');

data.equal_val_h=h1;

h1 = uicontrol('Parent',h0, ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1071 0.8247 0.3929 0.0384], ...
	'String','Bigger than', ...
	'Style','text', ...
	'Tag','StaticText1');

h1 = uicontrol('Parent',h0, ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1071 0.7507 0.4286 0.0329], ...
	'String','Smaller than', ...
	'Style','text', ...
	'Tag','StaticText2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1071 0.6630 0.3929 0.0493], ...
	'String','Equal to', ...
	'Style','text', ...
	'Tag','StaticText3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.125 0.5643835616438356 0.1130952380952381 0.04931506849315068], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton1');

data.and_button_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.125 0.5013698630136987 0.1130952380952381 0.04931506849315068], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton2');

data.or_button_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2619047619047619 0.5561643835616439 0.3809523809523809 0.05205479452054795], ...
	'String','AND', ...
	'Style','text', ...
	'Tag','StaticText4');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2619047619047619 0.4986301369863014 0.3809523809523809 0.04657534246575343], ...
	'String','OR', ...
	'Style','text', ...
	'Tag','StaticText5');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.125 0.3808219178082192 0.1130952380952381 0.04931506849315068], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton3');

data.all_button_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.125 0.3095890410958904 0.1130952380952381 0.04931506849315068], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton4');

data.sel_vects_button_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2619047619047619 0.3780821917808219 0.4166666666666666 0.04931506849315068], ...
	'String','All vectors', ...
	'Style','text', ...
	'Tag','StaticText6');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.2619047619047619 0.3123287671232877 0.5595238095238095 0.03835616438356165], ...
	'String','Among selected', ...
	'Style','text', ...
	'Tag','StaticText7');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.0952    0.1178    0.7500    0.1068], ...
	'Style','frame', ...
	'Tag','Frame6');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.5298    0.1342    0.2738    0.0712], ...
	'Style','edit', ...
	'Tag','EditText4');

data.replace_val_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',8,...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1369047619047619 0.136986301369863 0.3214285714285714 0.06027397260273973], ...
	'String','Vectors', ...
	'Style','text', ...
	'Tag','StaticText8');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.05357142857142857 0.01917808219178082 0.3869047619047619 0.0684931506849315], ...
	'String','OK', ...
	'Tag','Pushbutton1');

data.OK_button_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','preprocess close_s',...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.5 0.01917808219178082 0.3869047619047619 0.0684931506849315], ...
	'String','Close', ...
	'Tag','Pushbutton2');



data.state.and=1;
data.state.all=1;
data.state.big=[];
data.state.small=[];
data.state.equal=[];
data.state.replace=[];

set(data.or_button_h,'Callback','preprocess and_or_cb or');
set(data.and_button_h,'Callback','preprocess and_or_cb and');
set(data.and_button_h,'Value',1);
set(data.all_button_h,'Callback','preprocess all_sel_cb all');
set(data.sel_vects_button_h,'Callback','preprocess all_sel_cb sel');
set(data.big_val_h,'Callback','preprocess set_state_vals big');
set(data.small_val_h,'Callback','preprocess set_state_vals small');
set(data.equal_val_h,'Callback','preprocess set_state_vals equal');
set(data.replace_val_h,'Callback','preprocess set_state_vals replace');
set(data.OK_button_h,'Callback','preprocess clip_data sel');
set(h0,'UserData',data);



%%% Subfunction: and_or_cb %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function and_or_cb(arg)

%AND_OR_CB  A callback function. Checks that only one of the radiobox
%           buttons 'AND' and 'OR' is pressed down.
%
%

and_button_h=getfield(get(gcf,'UserData'),'and_button_h');
or_button_h=getfield(get(gcf,'UserData'),'or_button_h');
data=get(gcf,'UserData');

switch arg
  case 'or'
   set(and_button_h,'Value',0);
   set(or_button_h,'Value',1);
   data.state.and=0;
  case 'and'
   set(or_button_h,'Value',0);
   set(and_button_h,'Value',1);
   data.state.and=1;
end

set(gcf,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: all_sel_cb %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function all_sel_cb(arg)

all_button_h=getfield(get(gcf,'UserData'),'all_button_h');
sel_vects_button_h=getfield(get(gcf,'UserData'),'sel_vects_button_h');
data=get(gcf,'UserData');

switch arg
 case 'all'
  set(sel_vects_button_h,'Value',0);
  set(all_button_h,'Value',1);
  data.state.all=1;
 case 'sel'
  set(all_button_h,'Value',0);
  set(sel_vects_button_h,'Value',1);
  data.state.all=0;
end

set(gcf,'UserData',data);

%%% Subfunction: set_state_vals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_state_vals(arg)

%SET_STATE_VALS  sets the values to the UserData's state-struct.
%
%


data=get(gcf,'UserData');

switch arg
  case 'big'
   big_val_h=getfield(get(gcf,'UserData'),'big_val_h');
   val =str2num(get(big_val_h,'String'));
   dims=size(val);
   if dims(1) ~= 1 || dims(2) ~= 1
     errordlg('Argument of the operation must be scalar.');
     set(big_val_h,'String','');
     return;
   end 
   if isreal(val) 
     data.state.big=val;
   else
     errordlg('Limits of the operation must be real.');
     set(big_val_h,'String','');
     return;
   end
  case 'small'
   small_val_h=getfield(get(gcf,'UserData'),'small_val_h');
   val=str2num(get(small_val_h,'String'));
   dims=size(val);
   if dims(1) ~= 1 || dims(2) ~= 1
     errordlg('Argument of the operation must be scalar.')
     set(small_val_h,'String','');
     return;
   end 
   if isreal(val)
     data.state.small=val;
   else
     errordlg('Limits of the operation must be real.');
     set(small_val_h,'String','');
     return;
   end 
  case 'equal'
   equal_val_h=getfield(get(gcf,'UserData'),'equal_val_h');
   val = str2num(get(equal_val_h,'String'));
   dims=size(val);
   if dims(1) ~= 1 || dims(2) ~= 1
     errordlg('Argument of the operation must be scalar.');
     set(equal_val_h,'String','');
     return;
   end
   if isreal(val)
     data.state.equal=val;
   else
     errordlg('Limits of the operation must be real.');
     set(equal_val_h,'String','');
     return;
   end
  case 'replace'
   replace_val_h=getfield(get(gcf,'UserData'),'replace_val_h');
   val=str2num(get(replace_val_h,'String'));
   dims=size(val);
   if (dims(1) ~= 1 || dims(2) ~= 1) && ~strcmp(get(gcf,'Tag'),'Select')
     errordlg('Argument of the operation must be scalar.');
     set(replace_val_h,'String','');
     return;
   end
   if isreal(val)
     data.state.replace=val;
   else
     errordlg('Limits of the operation must be real.');
     set(replace_val_h,'String','');
     return;
   end
end

set(gcf,'UserData',data);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: clip_data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clip_data(arg)

%CLIP_DATA  A callback function. Filters the data.
%
%

i=1;
while i <= length(arg) && arg(i) ~= ' '
  i=i+1;
end

arg2=arg(i+1:length(arg));
arg=arg(1:i-1);

if ~isempty(arg2)
  LOG=1;
  if strcmp(arg,'sel')
    c_h=findobj(get(0,'Children'),'Tag','Select');
  else
    c_h=findobj(get(0,'Children'),'Tag','Clipping');
  end
  set(0,'CurrentFigure',c_h);
  i=1;
  while i <= length(arg2) && arg2(i) ~= ' '
    i=i+1;
  end
  BT=str2num(arg2(1:i-1));
  i=i+1;
  j=i;
  while i <= length(arg2) && arg2(i) ~= ' '
    i=i+1;
  end
  ST=str2num(arg2(j:i-1));
  i=i+1;
  j=i;
  while i <= length(arg2) && arg2(i) ~= ' '
    i=i+1;
  end
  EQ=str2num(arg2(j:i-1));
  i=i+1;
  j=i;
  while i <= length(arg2) && arg2(i) ~= ' '
    i=i+1;
  end
  AND_OR=str2num(arg2(j:i-1));
  i=i+1;
  j=i;
  while i <= length(arg2) && arg2(i) ~= ' '
    i=i+1;
  end
  ALL_AMONG=str2num(arg2(j:i-1));
  i=i+1;
  j=i;
  while i <= length(arg2)
    i=i+1;
  end
  VECT_REPL=str2num(arg2(j:i-1));
else
  LOG=0;
end

if ~LOG
  big_val_h=getfield(get(gcf,'UserData'),'big_val_h');
  small_val_h=getfield(get(gcf,'UserData'),'small_val_h');
  equal_val_h=getfield(get(gcf,'UserData'),'equal_val_h');
  replace_val_h=getfield(get(gcf,'UserData'),'replace_val_h');
end

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  errordlg('''Preprocess'' -figure does not exist. Terminating program...');
  pro_tools('close');
  return;
end

comp_names_h=getfield(get(pre_h,'UserData'),'comp_names_h');
selected=getfield(get(pre_h,'UserData'),'selected_vects');
sData=getfield(get(pre_h,'UserData'),'sData');
undo = sData;
state=getfield(get(gcf,'UserData'),'state');

if LOG
  state.big=BT;
  state.small=ST;
  state.equal=EQ;
  state.replace=VECT_REPL;
  state.and=AND_OR;
  state.all=ALL_AMONG;
end

if isempty(pre_h)
  pro_tools('close');
end

if isempty(get(comp_names_h,'Value'))
  clear_state_vals;
  errordlg('There must be one component chosen for the operation.');
  return;
end

n_th_comp=getfield(get_indices,{1});

if isempty(state.big) && isempty(state.small) && isempty(state.equal) && ...
   strcmp(arg,'clip')
  clear_state_vals;
  errordlg('At least one limit must be chosen for the-operation.');
  return;
end

if ~isempty(state.replace) && strcmp(arg,'sel')
  if ~all(state.replace == round(state.replace)) || any(state.replace < 1)
    errordlg('Indices of vectors must be positive integers.');
    return;
  elseif any(state.replace > length(sData.data(:,1)))
    errordlg('Indices of the vectors to be selected are too big.');
    return;
  end
end

if isempty(state.replace) && strcmp(arg,'clip')
  clear_state_vals;
  errordlg('Replace value must be determined for Clipping-operation.');
  return;
end

if isempty(state.big) && isempty(state.small) && isempty(state.equal) && ...
   isempty(state.replace)
   clear_state_vals;
   return;
end

bt_indices=[];
lt_indices=[];
equal_indices=[];


if ~isempty(state.big)
  if state.all
    bt_indices=find(sData.data(:,n_th_comp) > state.big); 
  else
    bt_indices=selected(find(sData.data(selected,n_th_comp) > state.big));
  end
end

if ~isempty(state.small)
  if state.all
    lt_indices=find(sData.data(:,n_th_comp) < state.small);
  else
    lt_indices=selected(find(sData.data(selected,n_th_comp) < state.small)); 
  end
end

if ~isempty(state.equal)
  if isnan(state.equal)
    if state.all
      equal_indices=find(isnan(sData.data(:,n_th_comp)));
    else
      equal_indices=selected(find(isnan(sData.data(selected,n_th_comp))));
    end
  elseif state.all
    equal_indices=find(sData.data(:,n_th_comp)==state.equal);
  else
    equal_indices=selected(find(sData.data(selected,n_th_comp)==state.equal));
  end
end

if state.and

  if ~isempty(bt_indices) || ~isempty(lt_indices) || ~isempty(equal_indices)...
     || strcmp(arg,'sel')

    if isempty(bt_indices) && isempty(lt_indices) && isempty(equal_indices) &&...
       isempty(state.replace)
      clear_state_vals;
      return;
    end
    if isempty(bt_indices)
      if ~state.all
        bt_indices=selected;
      else
        bt_indices=1:getfield(size(sData.data),{1});
      end
    end
    if isempty(lt_indices)
      if ~state.all
        lt_indices=selected;
      else
        lt_indices=1:getfield(size(sData.data),{1});
      end
    end
    if isempty(equal_indices)
      if ~state.all
        equal_indices=selected;
      else
        equal_indices=1:getfield(size(sData.data),{1});
      end
    end
    
    indices=intersect(intersect(bt_indices,lt_indices),equal_indices);
    if strcmp(arg,'sel')
      if ~isempty(indices) || ~isempty(state.replace)
        if isempty(state.replace)
          NOTEMPTY=0;
          if ~state.all
            state.replace=selected;
          else
            state.replace=1:getfield(size(sData.data),{1});
          end
        else
          NOTEMPTY=1;
        end
        if isempty(indices)
          indices=selected;
        end
        indices=intersect(indices,state.replace);
        if isempty(indices)
          indices=selected;
        end
        data=get(pre_h,'UserData');
        data.undo.sData=sData;
        data.undo.selected=data.selected_vects;
        data.selected_vects=indices;
        if ~LOG
         if ~NOTEMPTY
           data.LOG{length(data.LOG)+1}='% Select vectors.';
           data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''clip_data'',''',...
                                                 arg,...
                                                 ' ',num2str(state.big),...
                                                 ' ',num2str(state.small),...
                                                 ' ',num2str(state.equal),...
                                                 ' ',num2str(state.and),...
                                                 ' ',num2str(state.all),...
                                                 ''');');
         else
           code=write_log_code(state.replace,...
                               arg,...
                               state.big,...
                               state.small,...
                               state.equal,...
                               state.and,...
                               state.all);
           data.LOG(length(data.LOG)+1:length(data.LOG)+length(code))=code;
         end 
        end 
        set(pre_h,'UserData',data);
        old=gcf;
        set(0,'CurrentFigure',pre_h);
        sel_comp;
        cplot_mimema;
        vect_means(data.sData,data.vect_mean_h,data.selected_vects);
        set(0,'CurrentFigure',old);
      end
      clear_state_vals;
      return;
    end
    sData.data(indices,n_th_comp) = state.replace;
    sData.MODIFIED=1;
  end
else
  indices=union(union(bt_indices,lt_indices),equal_indices);
  if ~isempty(indices) || strcmp(arg,'sel')
    if strcmp(arg,'sel')
      if ~isempty(indices) || ~isempty(state.replace')
        data=get(pre_h,'UserData');
        data.undo.sData=sData;
        data.undo.selected=data.selected_vects;
        data.selected_vects=union(indices,state.replace);
        if ~LOG
         if isempty(state.replace);
           data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''clip_data'',''',...
                                                 arg,...
                                                 ' ',num2str(state.big),...
                                                 ' ',num2str(state.small),...
                                                 ' ',num2str(state.equal),...
                                                 ' ',num2str(state.and),...
                                                 ' ',num2str(state.all),...
                                                 ''');');
         else
           code=write_log_code(state.replace,...
                               arg,...
                               state.big,...
                               state.small,...
                               state.equal,...
                               state.and,...
                               state.all);
           data.LOG(length(data.LOG)+1:length(data.LOG)+length(code))=code;
         end
        end 
        set(pre_h,'UserData',data);
        old=gcf;
        set(0,'CurrentFigure',pre_h);
        sel_comp;
	vect_means(data.sData,data.vect_mean_h,data.selected_vects);
        cplot_mimema;
        set(0,'CurrentFigure',old);
      end
      clear_state_vals;
      return;
    end
    sData.data(indices,n_th_comp)=state.replace;
    sData.MODIFIED=1;
  end
end

if sData.MODIFIED
  data=get(pre_h,'UserData');
  data.sData=sData;
  data.undo.sData=undo;
  if ~LOG
    if strcmp(arg,'sel')
      data.LOG{length(data.LOG)+1}='% Select vectors';
    else
      data.LOG{length(data.LOG)+1}='% Clip values.';
    end
    if strcmp(arg,'clip') || isempty(state.replace)
     data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''clip_data'',''',arg,...
                                                 ' ',num2str(state.big),...
                                                 ' ',num2str(state.small),...
                                                 ' ',num2str(state.equal),...
                                                 ' ',num2str(state.and),...
                                                 ' ',num2str(state.all),...
                                                 ' ',num2str(state.replace),...
                                                 ''');');
    else
      code=write_log_code(state.replace,...
                          arg,...
                          state.big,...
                          state.small,...
                          state.equal,...
                          state.and,...
                          state.all);
      data.LOG(length(data.LOG)+1:length(data.LOG)+length(code))=code;
    end
  end 
  set(pre_h,'UserData',data);
  old=gcf;
  set(0,'CurrentFigure',pre_h)

  vector_h=getfield(get(gcf,'UserData'),'vector_h');
  vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
  set(gcf,'CurrentAxes',vector_h);
  vect_means(sData,vect_mean_h,selected);
  cplot_mimema;
  sel_comp;

  set(0,'CurrentFigure',old);
end

clear_state_vals;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: clear_state_vals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clear_state_vals

%CLEAR_STATE_VALS  Sets the fields of the UserData's state-struct empty.
%
%


data=get(gcf,'UserData');
set(data.big_val_h,'String','');
set(data.small_val_h,'String','');
set(data.equal_val_h,'String','');
set(data.replace_val_h,'String','');
data.state.big=[];
data.state.small=[];
data.state.equal=[];
data.state.replace=[];
set(gcf,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function delay(varargin)

delay_h=findobj(get(0,'Children'),'Tag','Delay');

if nargin ~= 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
      '% Starting the ''Delay'' -window...';
  preh_udata.LOG{length(preh_udata.LOG)+1}='preprocess(''delay'',''foo'');';
  set(pre_h,'UserData',preh_udata);
end

if ~isempty(delay_h)
  figure(delay_h);
  return;
end

h0 = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[759 664 162 215], ...
	'Tag','Delay');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.05555555555555555 0.2046511627906977 0.8950617283950617 0.7441860465116279], ...
	'Style','frame', ...
	'Tag','Frame1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.08641975308641975 0.6976744186046512 0.8333333333333333 0.2232558139534884], ...
	'Style','frame', ...
	'Tag','Frame2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.08641975308641975 0.227906976744186 0.8333333333333333 0.4418604651162791], ...
	'Style','frame', ...
	'Tag','Frame3');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','preprocess delay_data',...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.0556 0.0326 0.4012 0.1163], ...
	'String','OK', ...
	'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','preprocess close_d',...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.5494 0.0326 0.4012 0.1163], ...
	'String','Close', ...
	'Tag','Pushbutton2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.4876543209876543 0.7534883720930232 0.3518518518518519 0.1255813953488372], ...
	'Style','edit', ...
	'Tag','EditText1');

data.delay_val_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.1173 0.7860 0.3086 0.0651], ...
	'String','Delay', ...
	'Style','text', ...
	'Tag','StaticText1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','preprocess clip_exp_cb c_this',...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.1173 0.5349 0.1173 0.0837], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton1');

data.c_this_button_h=h1;
data.mode='c_this';

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess clip_exp_cb c_all',...
	'ListboxTop',0, ...
	'Position',[0.1173 0.4047 0.1173 0.0837], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton2');

data.c_all_button_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess clip_exp_cb e_all',...
	'ListboxTop',0, ...
	'Position',[0.1173    0.2651    0.1173    0.0837], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton3');

data.e_all_button_h=h1;


h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.26 0.5534883720930233 0.4135802469135802 0.06511627906976744], ...
	'String','Clip this', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.26 0.413953488372093 0.3765432098765432 0.06511627906976744], ...
	'String','Clip all', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.26 0.2744186046511628 0.4197530864197531 0.06511627906976744], ...
	'String','Expand all', ...
	'Style','text', ...
	'Tag','StaticText4');


set(gcf,'UserData',data);

%%% Subfunction clip_exp_cb %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clip_exp_cb(arg)

c_this_button_h=getfield(get(gcf,'UserData'),'c_this_button_h');
c_all_button_h=getfield(get(gcf,'UserData'),'c_all_button_h');
e_all_button_h=getfield(get(gcf,'UserData'),'e_all_button_h');
data=get(gcf,'UserData');


switch arg    
  case 'c_this'
   set(c_all_button_h,'Value',0);
   set(e_all_button_h,'Value',0);
   set(c_this_button_h,'Value',1);
   data.mode='c_this';
  case 'c_all'
   set(c_this_button_h,'Value',0);
   set(e_all_button_h,'Value',0);
   set(c_all_button_h,'Value',1);
   data.mode='c_all';
  case 'e_all'
   set(c_this_button_h,'Value',0);
   set(c_all_button_h,'Value',0);
   set(e_all_button_h,'Value',1);
   data.mode='e_all';
end

set(gcf,'UserData',data);

%%% Subfunction: delay_data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function delay_data(varargin)

if nargin == 1
  del_h=findobj(get(0,'Children'),'Tag','Delay');
  set(0,'CurrentFigure',del_h);
  LOG=1;
  arg=varargin{1};
  i=1;
  while i <= length(arg) && arg(i) ~= ' ' 
    i=i+1;
  end
  delay=str2num(arg(1:i-1));
  no=str2num(arg(i+1:length(arg)));
else
  LOG=0;
end

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
q='Delay operation is not evaluated.';
t='Warning';
if isempty(pre_h)
  errordlg('''Preprocess'' -figure does not exist. Terminating program...');
  pro_tools('close');
  return;
end

sData=getfield(get(pre_h,'UserData'),'sData');
undo = sData;
data=get(gcf,'UserData');
if ~LOG
  delay=str2num(get(data.delay_val_h,'String'));
  if isempty(delay)
    errordlg('Value of ''Delay'' must be defined.');
    return
  end
  set(data.delay_val_h,'String','');
  if round(delay) ~= delay
    errordlg('Value of ''Delay'' must be integer.');
    return;
  end
end
comp_names_h=getfield(get(pre_h,'UserData'),'comp_names_h');
if isempty(get(comp_names_h,'Value'))
  errordlg('There are not components chosen.');
  return;
end
n_th_comp=getfield(get_indices,{1});
len=length(sData.data(:,1));

if LOG
  switch no
    case 1
     data.mode='c_this';
     preprocess('clip_exp_cb','c_this');
    case 2
     data.mode='c_all';
     preprocess('clip_exp_cb','c_all');
    case 3
     data.mode='e_all';
     preprocess('clip_exp_cb','e_all');
  end
end

switch data.mode
  case 'c_this'
   MODE='1';
   if delay > 0
     sData.data(delay+1:len,n_th_comp)=sData.data(1:len-delay);
     if delay >= len
       errordlg(q,t);
       return;
     else
       sData.data(1:delay,n_th_comp)=NaN;
     end
   elseif delay < 0
     sData.data(1:len+delay,n_th_comp)=...
              sData.data(abs(delay)+1:len,n_th_comp);    
     if abs(delay) >= len
       errordlg(q,t);
       return;
     else
       sData.data(len+delay+1:len,n_th_comp)=NaN;
     end
   end
   if delay ~= 0
     data=get(pre_h,'UserData');
     sData.MODIFIED=1;
     sData.comp_norm(n_th_comp)=[];
     data.sData=sData;
     data.undo.sData=undo;
     set(pre_h,'UserData',data);
     old = gcf;
     set(0,'CurrentFigure',pre_h);
     sel_comp;
     cplot_mimema;
     set(0,'CurrentFigure',old);
   end
  case 'c_all'
   MODE='2';
   if delay > 0
     sData.data(delay+1:len,n_th_comp)=sData.data(1:len-delay,n_th_comp);
     if delay >= len
       errordlg(q,t);
       return;
     else
       sData.data=sData.data(delay+1:len,:);
     end
   elseif delay < 0
    sData.data(1:len+delay,n_th_comp)=sData.data(abs(delay)+1:len,n_th_comp);
    if abs(delay) >= len
      errordlg(q,t);
      return;
    else
      sData.data=sData.data(1:len+delay,:);
    end
   end
   if delay ~= 0
     data=get(pre_h,'UserData');
     sData.MODIFIED=1;
     sData.comp_norm(:,:)={[]};
     data.sData=sData;
     data.undo.sData=undo;
     data.undo.selected=data.selected_vects;
     if delay > 0
       data.selected_vects=...
                        data.selected_vects(find(data.selected_vects>delay));
       data.selected_vects=data.selected_vects-delay;
     elseif nargin == 1
       data.selected_vects=...
         data.selected_vects(find(data.selected_vects<=len-abs(delay)));
     end
     set(pre_h,'UserData',data);
     old=gcf;
     set(0,'CurrentFigure',pre_h);
     vects=zeros(1,length(sData.data(:,1)));
     vects(data.selected_vects)=1;
     write_sD_stats;
     draw_vectors(vects,data.vector_h);
     sel_comp;
     cplot_mimema;
     set(0,'CurrentFigure',old);
   end
  case 'e_all'
   MODE='3';
   if delay > 0
     sData.data(len+1:len+delay,:)=NaN;
     sData.data(1+delay:delay+len,n_th_comp)=sData.data(1:len,n_th_comp);
     sData.data(1:delay,n_th_comp)=NaN;
   elseif delay < 0
     delay=abs(delay);
     sData.data(delay+1:len+delay,:)=sData.data;
     sData.data(1:delay,:)=NaN;
     sData.data(1:len,n_th_comp)=sData.data(delay+1:len+delay,n_th_comp);
     sData.data(len+1:len+delay,n_th_comp)=NaN;
   end 
   if delay ~= 0
     data=get(pre_h,'UserData');
     sData.MODIFIED=1;
     sData.comp_norm(:,:)={[]};
     data.sData=sData;
     data.undo.sData=undo;
     data.undo.selected=data.selected_vects;
     set(pre_h,'UserData',data);
     old=gcf;
     set(0,'CurrentFigure',pre_h);
     write_sD_stats;
     pro_tools('selall');
     set(0,'CurrentFigure',old);
   end
end
 
if ~LOG
  data=get(pre_h,'UserData');
  data.LOG{length(data.LOG)+1}='% Delay a component.';
  data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''delay_data'',''',...
                                      num2str(delay),' ',MODE,''');');
  set(pre_h,'UserData',data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function window(varargin)

if nargin ~= 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  preh_udata.LOG{length(preh_udata.LOG)+1}=...
    '% Starting the ''Windowed'' -window...';
  preh_udata.LOG{length(preh_udata.LOG)+1}='preprocess(''window'',''foo'');';
  set(pre_h,'UserData',preh_udata);
end

win_h=findobj(get(0,'Children'),'Tag','Window');

if ~isempty(win_h)
  figure(win_h);
  return;
end

h0 = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[513 703 288 219], ...
	'Tag','Window');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.03125 0.1552511415525114 0.9375 0.7990867579908676], ...
	'Style','frame', ...
	'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.04861111111111111 0.7214611872146118 0.9027777777777777 0.2009132420091324], ...
	'Style','frame', ...
	'Tag','Frame2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.04861111111111111 0.1780821917808219 0.2777777777777778 0.5251141552511416], ...
	'Style','frame', ...
	'Tag','Frame3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.3611111111111111 0.1780821917808219 0.2777777777777778 0.5251141552511416], ...
	'Style','frame', ...
	'Tag','Frame4');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.6736111111111111 0.1780821917808219 0.2777777777777778 0.5251141552511416], ...
	'Style','frame', ...
	'Tag','Frame5');

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess eval_windowed',...	
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.03125 0.0319634703196347 0.2256944444444444 0.091324200913242], ...
	'String','OK', ...
	'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
	'Callback','preprocess close_w', ...
	'Units','normalized', ...
	'FontWeight','demi', ...
	'ListboxTop',0, ...
	'Position',[0.7430555555555555 0.0319634703196347 0.2256944444444444 0.091324200913242], ...
	'String','Close', ...
	'Tag','Pushbutton2');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.7083333333333333 0.7625570776255708 0.2083333333333333 0.1232876712328767], ...
	'Style','edit', ...
	'Tag','EditText1');

data.win_len_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.07638888888888888 0.8036529680365296 0.3784722222222222 0.0547945205479452], ...
	'String','Window length', ...
	'Style','text', ...
	'Tag','StaticText1');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb centered',...
	'ListboxTop',0, ...
	'Position',[0.06597222222222222 0.5616438356164384 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton1');

data.centered_h=h1;
data.position='center';

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb previous',...
	'ListboxTop',0, ...
	'Position',[0.06597222222222222 0.4018264840182648 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton2');

data.previous_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb next',...
	'ListboxTop',0, ...
	'Position',[0.06597222222222222 0.2465753424657534 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton3');

data.next_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	 'Callback','preprocess window_cb mean',...
	'ListboxTop',0, ...
	'Position',[0.3784722222222222 0.5799086757990868 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton4');

data.mean_h=h1;
data.mode='mean';


h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb median',...
	'ListboxTop',0, ...
	'Position',[0.3784722222222222 0.4611872146118721 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton5');


data.median_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb max',...
	'ListboxTop',0, ...
	'Position',[0.3784722222222222 0.3515981735159817 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton6');

data.max_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','preprocess window_cb min',...
	'BackgroundColor',[0.8 0.8 0.8], ...	
	'ListboxTop',0, ...
	'Position',[0.3784722222222222 0.2374429223744292 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton7');

data.min_h = h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb clip',...
	'ListboxTop',0, ...
	'Position',[0.6909722222222222 0.5525114155251141 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton8');

data.clip_h=h1;
data.eval_mode='clip';

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Callback','preprocess window_cb expand',...
	'ListboxTop',0, ...
	'Position',[0.6909722222222222 0.2922374429223744 0.06597222222222222 0.0821917808219178], ...
	'Style','radiobutton', ...
	'Tag','Radiobutton9');

data.expand_h=h1;

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.132 0.5799 0.19 0.0548], ...
	'String','Centered', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.132 0.4247 0.1667 0.0548], ...
	'String','Previous', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.132 0.2648 0.1632 0.0548], ...
	'String','Next', ...
	'Style','text', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...,
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.445 0.6027397260273972 0.19 0.0547945205479452], ...
	'String','Mean', ...
	'Style','text', ...
	'Tag','StaticText5');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.445 0.4795 0.1806 0.0548], ...
	'String','Median', ...
	'Style','text', ...
	'Tag','StaticText6');

h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.445 0.3699 0.1667 0.0548], ...
	'String','Max', ...
	'Style','text', ...
	'Tag','StaticText7');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.445 0.2557077625570776 0.1597222222222222 0.0547945205479452], ...
	'String','Min', ...
	'Style','text', ...
	'Tag','StaticText8');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.7535 0.5753 0.1354 0.054], ...
	'String','Clip', ...
	'Style','text', ...
	'Tag','StaticText9');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontWeight','demi', ...
	'FontSize',8,...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.7534722222222222 0.3150684931506849 0.1527777777777778 0.0547945205479452], ...
	'String','Expand', ...
	'Style','text', ...
	'Tag','StaticText10');



set(gcf,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function window_cb(arg)

data=get(gcf,'UserData');

if any(strcmp(arg,[{'centered'},{'previous'},{'next'}]))
  switch arg
    case 'centered'
     data.position='center';
     set(data.previous_h,'Value',0);
     set(data.next_h,'Value',0);
     set(data.centered_h,'Value',1);
    case 'previous'
     data.position='previous';
     set(data.centered_h,'Value',0);
     set(data.next_h,'Value',0);
     set(data.previous_h,'Value',1);
    case 'next'
     data.position='next';
     set(data.centered_h,'Value',0);
     set(data.previous_h,'Value',0);
     set(data.next_h,'Value',1);
  end
elseif any(strcmp(arg,[{'mean'},{'median'},{'min'},{'max'}]))
  switch arg
    case 'mean'
     data.mode='mean';
     set(data.median_h,'Value',0);
     set(data.min_h,'Value',0);
     set(data.max_h,'Value',0);
     set(data.mean_h,'Value',1);
    case 'median'
     data.mode='median';
     set(data.mean_h,'Value',0);
     set(data.max_h,'Value',0);
     set(data.min_h,'Value',0);
     set(data.median_h,'Value',1);
    case 'max'
     data.mode='max';
     set(data.mean_h,'Value',0);
     set(data.median_h,'Value',0);
     set(data.min_h,'Value',0);
     set(data.max_h,'Value',1);
    case 'min'
     data.mode='min';
     set(data.mean_h,'Value',0);
     set(data.median_h,'Value',0);
     set(data.max_h,'Value',0);
     set(data.min_h,'Value',1);
  end
elseif any(strcmp(arg,[{'clip','expand'}]))
  switch arg
    case 'clip'
     data.eval_mode='clip';
     set(data.expand_h,'Value',0);
     set(data.clip_h,'Value',1);
    case 'expand'
     data.eval_mode='expand';
     set(data.clip_h,'Value',0);
     set(data.expand_h,'Value',1); 
  end
end

set(gcf,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eval_windowed(varargin)

if nargin == 1
  LOG=1;
  i=1;
  arg=varargin{1};
  while i <= length(arg) && arg(i) ~= ' '
    i=i+1;
  end
  value=str2num(arg(1:i-1));
  i=i+1;
  j=i;
  while i <= length(arg) && arg(i) ~= ' '
    i=i+1;
  end
  position=arg(j:i-1);
  i=i+1;
  j=i;
  while i <= length(arg) && arg(i) ~= ' '
    i=i+1;
  end
  mode=arg(j:i-1);
  i=i+1;
  j=i;
  while i <= length(arg) && arg(i) ~= ' '
    i=i+1;
  end
  eval_mode=arg(j:i-1);
else
  LOG=0;
end

data=get(gcf,'UserData');
if LOG
  data.position=position;
  data.eval_mode=eval_mode;
  data.mode=mode;
end
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  errordlg('''Preprocess''-window does not exist. Terminating program...');
  pro_tools('close');
  return;
end

comp_names_h=getfield(get(pre_h,'UserData'),'comp_names_h');
sData=getfield(get(pre_h,'UserData'),'sData');
undo=sData;

if isempty(get(comp_names_h,'Value'))
 errordlg('There are not components chosen.');
 return;
end

if ~LOG
  if isempty(get(data.win_len_h,'String'))
    errordlg('Window length must be defined');
    return;
  end

  value=str2num(get(data.win_len_h,'String'));
end

set(data.win_len_h,'String','');

if ~LOG
  if isempty(value) || value < 0 || value ~= round(value)
    errordlg('Window length must be positive integer.');
    return;
  end

  if value > length(sData.data(:,1))
    errordlg('Length of window is too big.');
    return;
  end
end

index=getfield(get_indices,{1});

sData=eval_operation(sData,value,data.mode,data.eval_mode,data.position,index);
sData.comp_norm(index)={[]};
u_data=get(pre_h,'UserData');
u_data.sData=sData;
u_data.undo.sData=undo;
u_data.undo.selected=u_data.selected_vects;

if ~LOG
  u_data.LOG{length(u_data.LOG)+1}=...
    '% Evaluating the wanted ''windowed'' -operation.';
  u_data.LOG{length(u_data.LOG)+1}=cat(2,'preprocess(''eval_windowed'',',...
                                        '''',num2str(value),...
                                       ' ',data.position,' ',data.mode,...
                                       ' ',data.eval_mode,''');');
end
 
set(pre_h,'UserData',u_data);
old=gcf;
set(0,'CurrentFigure',pre_h);

if strcmp(data.eval_mode,'expand');
  write_sD_stats;
  pro_tools('selall');
else
  sel_comp;
  cplot_mimema;
end

set(0,'CurrentFigure',old);



%%% Subfunction: eval_operation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function sData=eval_operation(sData,winlen,mode,evalmode,position,n)


len=length(sData.data(:,1));
dim=length(sData.data(1,:));

switch(position)
  case 'center'
   prev=round(winlen/2)-1;
   next=winlen-round(winlen/2);
  case 'previous'
   prev=winlen-1;
   next=0;
  case 'next'
   prev=0;
   next=winlen-1;
end

switch(evalmode)
  case 'clip'
   for center=1:len
     win=center-prev:center-prev+winlen-1;
     win=win(find(win > 0 & win <= len));
     str=cat(2,mode,'(sData.data(win(find(~isnan(sData.data(win,n)))),n))');
     tmp(center)=eval(str);
   end
   sData.data(:,n)=tmp;
  case 'expand'   
   for i=1:len+winlen-1  
     win=i-(winlen-1):i;
     win=win(find(win > 0 & win <= len));
     str=cat(2,mode,'(sData.data(win(find(~isnan(sData.data(win,n)))),n))');
     tmp(i)=eval(str);
   end  
  sData.data=cat(1,repmat(NaN,next,dim),sData.data,repmat(NaN,prev,dim));
  sData.data(:,n)=tmp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pro_tools(arg)

switch arg
  case 'close'
   close_preprocess;
  case 'c_stat'
   write_c_stats;
  case 'plot_hist'
   plot_hist;
  case 'plot'
   plot_button;
  case 'plxy'
   plxy_button;
  case 'bplo'
   bplo_button;
  case 'hist'
   hist_button;
end


%%% Subfunction close_preprocess %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function close_preprocess

 
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
man_h=findobj(get(0,'Children'),'Tag','Management');
clip_h=findobj(get(0,'Children'),'Tag','Clipping');
plot_h=findobj(get(0,'Children'),'Tag','PlotWin');
delay_h=findobj(get(0,'Children'),'Tag','Delay');
window_h=findobj(get(0,'Children'),'Tag','Window');
sel_h=findobj(get(0,'Children'),'Tag','Select');

if ~isempty(man_h)
  close(man_h);
end
if ~isempty(clip_h)
  close(clip_h);
end
if ~isempty(plot_h)
  close(plot_h);
end
if ~isempty(delay_h)
  close(delay_h);
end
if ~isempty(window_h)
  close(window_h);
end
if ~isempty(sel_h)
  close(sel_h);
end
if ~isempty(pre_h)
  close(pre_h);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: undo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function undo(varargin)

if nargin == 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  set(0,'CurrentFigure',pre_h);
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
if ~isempty(data.undo)
  if any(strcmp('selected',fieldnames(data.undo)))
    data.selected_vects=data.undo.selected;
  end
  if ~any(strcmp('index',fieldnames(data.undo)))
    data.sData=data.undo.sData;
    data.undo=[];
    if ~LOG
      data.LOG{length(data.LOG)+1}='% Undo the most recent operation.';
      data.LOG{length(data.LOG)+1}='preprocess(''undo'',''foo'');';
    end
    set(gcf,'UserData',data);
    set_compnames(data.sData,data.comp_names_h);
    write_sD_stats;
    vect_means(data.sData,data.vect_mean_h,data.selected_vects);
    sel_comp;
    cplot_mimema;
    return;
  end
  
  % 'undo.sData' does not exist in sD_set - array

  index=data.undo.index; 
  data.undo.sData=rmfield(data.undo.sData,[{'INDEX'};{'MODIFIED'}]);
  if index<=length(data.sD_set)
    rest=data.sD_set(index:length(data.sD_set));        
  else
    rest=[];
  end
  data.sD_set=cat(2,data.sD_set(1:index-1),data.undo.sData,rest);
  data.undo=[];
  if ~LOG
    data.LOG{length(data.LOG)+1}='% Undo the most recent operation.';
    data.LOG{length(data.LOG)+1}='preprocess(''undo'',''foo'');';
  end
  set(gcf,'UserData',data);
  set(getfield(get(gcf,'UserData'),'sD_set_h'),'Value',index);
  set_sD_stats;
  sel_sD;
else
  msgbox('Can''t do...');
end

%%% Subfunction: write_c_stats %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_c_stats(varargin)


pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
comp_names_h=getfield(get(pre_h,'UserData'),'comp_names_h');
sel_comp_h=getfield(get(pre_h,'UserData'),'sel_comp_h');
sel_chist_h=getfield(get(pre_h,'UserData'),'sel_chist_h');

if nargin==1
  val1=varargin(1);
else
  val1=get(sel_comp_h,'String');
end
   
if ~isempty(val1) && iscell(val1)
  selected_vects=getfield(get(pre_h,'UserData'),'selected_vects');
  sData=getfield(get(pre_h,'UserData'),'sData');
  sel_cdata_h=getfield(get(pre_h,'UserData'),'sel_cdata_h');
  name=getfield(get(sel_comp_h,'String'),{get(sel_comp_h,'Value')});
  name=name{1};
  i=2;

  while ~isempty(str2num(name(i)))
   value(i-1)=name(i);
   i=i+1;
  end

  value=str2num(value);


  data=sData.data(selected_vects,value);

  string{1} = cat(2,'Min: ',sprintf('%-10.3g',min(data)));
  string{2} = cat(2,'Mean: ',sprintf('%-10.3g',mean(data(find(~isnan(data))))));
  string{3} = cat(2,'Max: ',sprintf('%-10.3g',max(data)));
  string{4} = cat(2,'Std: ',sprintf('%-10.3g',std(data(find(~isnan(data)))))); 
  string{5} = cat(2,'Number of NaNs: ',sprintf('%-10.3g',sum(isnan(data))));
  string{6} = cat(2,'NaN (%):',...
                    sprintf('%-10.3g',100*sum(isnan(data))/length(data)));
  string{7} = cat(2,'Number of values: ',sprintf('%-10.3g',...
                    length(find(~isnan(unique(data))))));
  set(sel_cdata_h,'String',string);
  set(sel_cdata_h,'HorizontalAlignment','left');  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction plot_hist %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_hist

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
sel_chist_h=getfield(get(pre_h,'UserData'),'sel_chist_h');
sData=getfield(get(pre_h,'UserData'),'sData');
selected=getfield(get(pre_h,'UserData'),'selected_vects');

value=get(getfield(get(pre_h,'UserData'),'sel_comp_h'),'Value');
subplot(sel_chist_h);
hold off;
cla;
if all(isnan(sData.data(:,value)));
  return;
end
hold on;
lim1=min(sData.data(:,value));
lim2=max(sData.data(:,value));
if lim2 - lim1 >= eps
  x=lim1:(lim2-lim1)/(30-1):lim2;
  set(sel_chist_h,'XLim',[lim1 lim2]);
elseif lim1 ~= 0
  x=(lim1)/2:lim1/(30-1):lim1+(lim1)/2;
  set(sel_chist_h,'Xlim',[lim1-abs(lim1/2) lim1+abs(lim1/2)]);
else
  x=-1:2/(30-1):1;
  set(sel_chist_h,'XLim',[-1 1]);
end

hist(sData.data(selected,value),x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: select_all %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function select_all(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
data.selected_vects=(1:length(data.sData.data(:,1)));
if ~LOG
  data.LOG{length(data.LOG)+1}='% Select all vectors.';
  data.LOG{length(data.LOG)+1}='selall(''foo'');';
end
set(gcf,'UserData',data);
tmp=zeros(1,length(data.sData.data(:,1)));
tmp(data.selected_vects)=1;
draw_vectors(tmp,data.vector_h);
cplot_mimema;
vect_means(data.sData,data.vect_mean_h,data.selected_vects);
sel_comp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: plot_button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_button

%PLOT_BUTTON  A callback function. Plots all the components and marks
%             the chosen components.
%
%

sData=getfield(get(gcf,'UserData'),'sData');
selected=getfield(get(gcf,'UserData'),'selected_vects');

indices=get_indices;
if isempty(indices)
  return;
end
h=findobj(get(0,'Children'),'Tag','PlotWin');
if isempty(h)
  h= figure;
  set(h,'Tag','PlotWin');
end

names=sData.comp_names(indices);  
data=sData.data(:,indices);

set(0,'CurrentFigure',h);
hold off;
clf;
t=0:1/(getfield(size(data),{1})-1):1;
tmp=setdiff(1:length(data(:,1)),selected);
for i=1:length(names)
  subplot(length(names),1,i);
  hold on;
  if max(data(:,i))- min(data(:,i)) <= eps
    set(gca,'YLim',[max(data(:,i))-1 max(data(:,i))+1]);
  end
  plot(t,data(:,i));
  if ~isempty(tmp);
    data(tmp,i)=NaN;
  end
  plot(t,data(:,i),'red');
  ylabel(names{i});
  set(gca,'XTick',[]);
end
set(gcf,'Name','Plotted Data Components');    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: plxy_button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plxy_button

%PLXY_BUTTON  A callback function. XY-plots the first and the second
%             components chosen.
%
%


sData=getfield(get(gcf,'UserData'),'sData');
selected=getfield(get(gcf,'UserData'),'selected_vects');

inds = get_indices;
if length(inds) < 2
  errordlg('There must be two components chosen for XY-plot.');
  return;
end

inds=inds(1:2);
names=getfield(sData,'comp_names',{inds});

h=findobj(get(0,'Children'),'Tag','PlotWin');

if isempty(h)
  h= figure;
  set(h,'Tag','PlotWin');
end

set(0,'CurrentFigure',h);
clf;
axes;
if max(sData.data(:,inds(1))) - min(sData.data(:,inds(1))) <= eps
  set(gca,'XLim',[max(sData.data(:,inds(1)))-1 max(sData.data(:,inds(1)))+1]);
end
if max(sData.data(:,inds(2))) - min(sData.data(:,inds(2))) <= eps
  set(gca,'YLim',[max(sData.data(:,inds(2)))-1 max(sData.data(:,inds(2)))+1]);
end
hold on;
plot(sData.data(:,inds(1)),sData.data(:,inds(2)),'o');
x=sData.data(selected,inds(1));
y=sData.data(selected,inds(2));

plot(x,y,'ored','MarkerSize',4);
xlabel(names(1));
ylabel(names(2));
set(h,'Name','Plotted Data Components');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sub_function: bplo_button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bplo_button

%BPLO_BUTTON  A callback function. Box-plots the first component chosen.


sData=getfield(get(gcf,'UserData'),'sData');
selected=getfield(get(gcf,'UserData'),'selected_vects');

if length(selected) == 1
  errordlg('There are too few vectors chosen for box-plotting.');
else
  indices=get_indices;
  if isempty(indices)
    return;
  end
  for i=1:length(indices)
    if length(unique(sData.data(selected,indices(i))))==1
      errordlg('All the values are the same. Operation can''t be evaluated.');
      return;
    end
  end 
  names=getfield(sData,'comp_names',{indices});
  h= findobj(get(0,'Children'),'Tag','PlotWin');
  if isempty(h)
    h= figure;
    set(h,'Tag','PlotWin');
  end

  data=sData.data(selected,indices);

  set(0,'CurrentFigure',h);
  hold off;
  clf;
  hold on;
  for i=1:getfield(size(data),{2})
    subplot(getfield(size(data),{2}),1,i);
    if ~all(isnan(data(:,i)))
      boxplot(data(:,i));
    end
    name=names{i};
    tmp=get(get(gca,'YLabel'),'String');
    ylabel(cat(2,sprintf('[%s]    ',name),tmp));
  end
  set(h,'Name','Box-plot');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: hist_button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hist_button

no_of_bins_h=getfield(get(gcf,'UserData'),'no_of_bins_h');
selected=getfield(get(gcf,'UserData'),'selected_vects');
sData=getfield(get(gcf,'UserData'),'sData');
n=str2num(get(no_of_bins_h,'String'));
s1='Invalid number of bins.';
s2=sprintf('\nSet new value to the box under the ''Histogram''-button.');

if isempty(n)
  errordlg(cat(2,s1,s2));
else
  indices=get_indices;
  if isempty(indices)
    return;
  end
  n=round(n);
  if n < 1
    errordlg('Number of bins must be positive integer.');
  else
    h= findobj(get(0,'Children'),'Tag','PlotWin');
    if isempty(h)
      h= figure;
      set(h,'Tag','PlotWin');
    end

    set(0,'CurrentFigure',h);
    hold off;
    clf;
    data=sData.data(selected,indices);
    names=sData.comp_names(indices);
    for i=1:length(names)
      subplot(length(names),1,i);
      hold on;
      lim1=min(sData.data(:,indices(i)));
      lim2=max(sData.data(:,indices(i)));
      if n > 1
        if lim2 - lim1 >= eps
          x=lim1:(lim2-lim1)/(n-1):lim2;
          set(gca,'XLim',[lim1 lim2]);
        elseif lim1 ~= 0
          x=lim1/2:lim1/(n-1):lim1/2+lim1;
          if ~all(isnan([lim1 lim2]))
            set(gca,'XLim',[lim1-abs(lim1/2) lim1+abs(lim1/2)]);
          end
        else
          x=-1:2/(n-1):1;
          set(gca,'XLim',[-1 1]);
        end
      else 
        x=1;
        if lim2 ~= lim1
          set(gca,'XLim',[lim1 lim2]);
        else
          set(gca,'XLim',[lim1/2 lim1/2+lim1]);
        end
      end
      if ~all(isnan(data(:,i)))
        hist(data(:,i),x);
      end
      name=names{i};
      xlabel(name);     
    end
    set(h,'Name','Histogram');      
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: no_of_values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function no_of_values(varargin)

%NO_OF_VALUES  A callback function. Calculates the number of different
%              values of the chosen components.
%
%

if nargin==1;
  LOG=1;
else
  LOG=0;
end

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
results_h=getfield(get(pre_h,'UserData'),'results_h');
sData=getfield(get(pre_h,'UserData'),'sData');
selected=getfield(get(pre_h,'UserData'),'selected_vects');
str1='There must be one component chosen for ''Number of Values''-operation';


if ~LOG && isempty(get_indices) 
  errordlg(str1);
else
  indices=get_indices;
  data=sData.data(selected,indices);

  string{1} = 'Number of different values:';

  for i=1:getfield(size(data),{2})

    tmp=data(:,i);
    string{i+1}=cat(2,sprintf('#%d:',indices(i)),... 
                      sprintf('%d',length(find(~isnan(unique(data(:,i)))))));
  end

  set(results_h,'String',string);
  set(results_h,'HorizontalAlignment','left');
  if ~LOG
    data=get(pre_h,'UserData');
    data.LOG{length(data.LOG)+1}='% Number of values';
    data.LOG{length(data.LOG)+1}='preprocess(''noof'',''foo'');';
    set(pre_h,'UserData',data);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: correlation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function correlation(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
results_h=getfield(get(pre_h,'UserData'),'results_h');
selected=getfield(get(pre_h,'UserData'),'selected_vects');
sData=getfield(get(pre_h,'UserData'),'sData');

if length(get_indices) < 2
  errordlg('There must be two components chosen for Correlation');
else
  indices=getfield(get_indices,{1:2});
  data=sData.data(selected,indices);
  inds=find(~isnan(data(:,1)) & ~isnan(data(:,2)));
  value=getfield(corrcoef(data(inds,1),data(inds,2)),{1,2});
  names=sData.comp_names(indices);
  string{1}='Correlation between';
  string{2}=cat(2,names{1},' and ',names{2},':');
  string{3}=sprintf('%-10.3g',value);

  set(results_h,'String',string);
  set(results_h,'HorizontalAlignment','left');
  if ~LOG
    data=get(pre_h,'UserData');
    data.LOG{length(data.LOG)+1}='% Correlation';
    data.LOG{length(data.LOG)+1}='preprocess(''corr'',''foo'');';
    set(pre_h,'UserData',data);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: unit_length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function unit_length(varargin) 

%UNIT_LENGTH  A callback function Scales all the vectors to the unit
%             length.
%
% 

if nargin==1
  LOG=1;
else
  LOG=0;
end

vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
sData=getfield(get(gcf,'UserData'),'sData');
sData.MODIFIED=1;
scaled=sData.data;
comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');

if ~LOG && isempty(get(comp_names_h,'Value'))
  errordlg('There must be components chosen for the ''unit length''- operation');
  return;
end
inds=get_indices;
for i=1:length(scaled(:,1));
  x=find(~isnan(scaled(i,inds)));
  scaled(i,inds(x))=(1/sqrt(sum(scaled(i,inds(x)).^2)))*scaled(i,inds(x));
end

data=get(gcf,'UserData');


data.undo.sData = sData;
data.sData.data=scaled;

for i=1:length(inds)
  data.sData.comp_norm{inds(i)}=[];
end

if ~LOG
  data.LOG{length(data.LOG)+1}='% Unit length';
  data.LOG{length(data.LOG)+1}='preprocess(''unit'',''foo'');';
end
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

draw_vectors(vects,data.vector_h);
vect_means(sData,vect_mean_h,data.selected_vects);
cplot_mimema;
plot_hist;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: one_of_n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function one_of_n(varargin)

if nargin==1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
vector_h=getfield(get(gcf,'Userdata'),'vector_h');
comp_names_h=getfield(get(gcf,'Userdata'),'comp_names_h');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
sData=data.sData;
undo=data.sData;
selected=getfield(get(gcf,'UserData'),'selected_vects');
msg='Creating over 10 new components. Stop operation?';

if ~LOG
  if isempty(get(data.comp_names_h,'Value'))
    errordlg('There must be one component chosen for ''Add: N binary types'' -operation');
    return;
  end
end

index=getfield(get_indices,{1});

tmp=unique(sData.data(:,index)); 
n=length(tmp);

if ~LOG
  if n>10
    answer=questdlg(msg,'Question','Yes','No','Yes');

    if strcmp(answer,'Yes')
      msgbox('Operation stopped.');
      return;
    end

  end
end

dim1=getfield(size(sData.data),{1});
dim2=getfield(size(sData.data),{2});
sData.data=cat(2,sData.data,zeros(dim1,n));

dim=dim2+n;
for i=1:n
  sData.data(:,dim-(n-i))=(sData.data(:,index) == tmp(i));
end

INDEX=sData.INDEX;
for i=1:n
  sData.comp_names{dim2+i}=sprintf('%dNewVar',dim2+i);
end
tmp_norm=cat(1,sData.comp_norm,cell(n,1));
sData=som_data_struct(sData.data,...
                      'name',sData.name,...
                      'labels',sData.labels,...
                      'comp_names',sData.comp_names);
                
sData.MODIFIED=1;
sData.INDEX=INDEX;
sData.comp_norm=tmp_norm;
data.undo.sData=undo;
data.sData=sData;
data.selected_vects=1:length(sData.data(:,1));
if ~LOG
  data.LOG{length(data.LOG)+1}='% Add: N binary types';
  data.LOG{length(data.LOG)+1}='preprocess(''oneo'',''foo'');';
end
set(gcf,'UserData',data);
clear_button;
write_sD_stats;
set_compnames(sData,comp_names_h);
tmp=ones(1,length(sData.data(:,1)));
draw_vectors(tmp,vector_h);
vect_means(sData,vect_mean_h,1:length(sData.data(:,1)));
cplot_mimema;
sel_comp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: add_zeros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function add_zeros(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
vector_h=getfield(get(gcf,'Userdata'),'vector_h');
comp_names_h=getfield(get(gcf,'Userdata'),'comp_names_h');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
sData=data.sData;
undo=sData;

dim1=getfield(size(sData.data),{1});
dim2=getfield(size(sData.data),{2});
sData.data=cat(2,sData.data,zeros(dim1,1));

INDEX=sData.INDEX;

sData.comp_names{dim2+1}=sprintf('%dNewVar',dim2+1);
tmp_norm=cat(1,sData.comp_norm,cell(1,1));
sData=som_data_struct(sData.data,...
                      'name',sData.name,...
                      'labels',sData.labels,...
                      'comp_names',sData.comp_names);
         
sData.MODIFIED=1;
sData.INDEX=INDEX;
sData.comp_norm=tmp_norm;
data.sData=sData;
data.undo.sData=undo;
data.selected_vects=1:length(sData.data(:,1));
if ~LOG
  data.LOG{length(data.LOG)+1}='% Add: zeros';
  data.LOG{length(data.LOG)+1}='preprocess(''zero'',''foo'');';
end
set(gcf,'UserData',data);
clear_button;
write_sD_stats;
set_compnames(sData,comp_names_h);
tmp=ones(1,length(sData.data(:,1)));
draw_vectors(tmp,vector_h);
vect_means(sData,vect_mean_h,1:length(sData.data(:,1)));
cplot_mimema;
sel_comp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: move_component %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function move_component(varargin)

%MOVE_COMPONENT  A callback function. Moves one component of vectors to
%                the position wanted.
%
%

if nargin == 1
  LOG=1;
  i=1;
  while varargin{1}(i) ~= ' ' 
    value(i)=varargin{1}(i);
    i=i+1;
  end
  value=str2num(value);                                 % the new place
  index=str2num(varargin{1}(i:length(varargin{1})));    % index of the chosen
                                                        % component
else
  LOG=0;
end

data=get(gcf,'UserData');
sData=data.sData;
undo=sData;
prompt='Enter the number of the new component place:';


if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be one component chosen for ''Move Component''-operation');
  return;
end

if ~LOG
  index=getfield(get_indices,{1});
  answer=inputdlg(prompt);

  if isempty(answer) || (iscell(answer) && isempty(answer{1}))
    msgbox('No components moved');
    return;
  end

  value=str2num(answer{1});


  dims=size(value);

  if dims(1) ~= 1 || dims(2) ~= 1 || ~isreal(value)
    errordlg('The new component place must be positive integer.')
    return;
  end

  if value <= 0 || round(value) ~= value
    errordlg('The new component place must be positive integer.');
    return;
  end

  if value > getfield(size(sData.data),{2})
    errordlg('Too big value for the new component place.');
    return;
  end
end

sData.MODIFIED=1;
if index < value
  indices1=setdiff(1:value,index);
  indices2=setdiff(value+1:length(sData.data(1,:)),index);
elseif index > value
  indices1=setdiff(1:value-1,index);
  indices2=setdiff(value:length(sData.data(1,:)),index);
else
  data.sData=sData;
  data.undo.sData=undo;
  set(gcf,'UserData',data);
  return;
end

tmp1=sData.data(:,indices1);
tmp2=sData.data(:,indices2);
sData.data=cat(2,tmp1,sData.data(:,index),tmp2);

tmp1=sData.comp_names(indices1);
tmp2=sData.comp_names(indices2);
sData.comp_names=cat(1,tmp1,sData.comp_names(index),tmp2);

tmp1=sData.comp_norm(indices1);
tmp2=sData.comp_norm(indices2);
sData.comp_norm=cat(1,tmp1,sData.comp_norm(index),tmp2);

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Move component.';
  data.LOG{length(data.LOG)+1}=sprintf('preprocess(''move'',''%s %s'');',...
           num2str(value),num2str(index));
end
comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
vector_h=getfield(get(gcf,'UserData'),'vector_h');
data.selected_vects=1:length(sData.data(:,1));
set(gcf,'UserData',data);
clear_button;
set_compnames(sData,comp_names_h);
draw_vectors(ones(1,length(sData.data(:,1))),vector_h);
vect_means(sData,vect_mean_h,data.selected_vects);
cplot_mimema;
sel_comp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: copy_component %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function copy_component(varargin)

%COPY_COMPONENT  Copies one component of vectors to the position wanted.
%
%

if nargin == 1
  LOG=1;
  i=1;
  while varargin{1}(i) ~= ' ' 
    value(i)=varargin{1}(i);
    i=i+1;
  end
  value=str2num(value);                                 % the new place
  index=str2num(varargin{1}(i:length(varargin{1})));    % index of the chosen
                                                        % component
else
  LOG=0;
end


data=get(gcf,'UserData');
sData=data.sData;
undo=sData;
if ~LOG
  prompt='Enter the number of the new component place:';


  if isempty(get(data.comp_names_h,'Value'))
    errordlg('There must be one component chosen for ''Copy Component''-operation');
    return;
  end

  index=getfield(get_indices,{1});
  answer=inputdlg(prompt);

  if isempty(answer) || (iscell(answer) && isempty(answer{1}))
    msgbox('No components moved');
    return
  end


  value=str2num(answer{1});
  dims=size(value);

  if dims(1) ~= 1 || dims(2) ~= 1 || ~isreal(value)
    errordlg('The new component place must be positive integer.')
    return;
  end

  if value <= 0 || round(value) ~= value
    errordlg('The new component place must be positive integer.');
    return;
  end

  if value > getfield(size(sData.data),{2}) + 1
    errordlg('Too big value for the new component place.');
    return;
  end
end

sData.MODIFIED=1;

indices1=1:value-1;
indices2=value:length(sData.data(1,:));
tmp1=sData.data(:,indices1);
tmp2=sData.data(:,indices2);
sData.data=cat(2,tmp1,sData.data(:,index),tmp2);

tmp1=sData.comp_names(indices1);
tmp2=sData.comp_names(indices2);
name=cell(1,1);
name{1}=cat(2,'Copied',sData.comp_names{index});
sData.comp_names=cat(1,tmp1,name,tmp2);

tmp1=sData.comp_norm(indices1);
tmp2=sData.comp_norm(indices2);
norm=cell(1,1);
norm{1}=sData.comp_norm{index};
sData.comp_norm=cat(1,tmp1,norm,tmp2);

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Copy component';
  data.LOG{length(data.LOG)+1}=sprintf('preprocess(''copy'',''%s %s'');',...
           num2str(value),num2str(index));
end


comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
vector_h=getfield(get(gcf,'UserData'),'vector_h');
data.selected_vects=1:length(sData.data(:,1));
set(gcf,'UserData',data);
clear_button;
write_sD_stats;
set_compnames(sData,comp_names_h);
draw_vectors(ones(1,length(sData.data(:,1))),vector_h);
vect_means(sData,vect_mean_h,data.selected_vects);
cplot_mimema;
sel_comp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: remove_component %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function remove_component(varargin)

if nargin == 1
  LOG=1;
  value=str2num(varargin{1});
else
  LOG=0;
end

data=get(gcf,'UserData');
vect_mean_h=getfield(get(gcf,'UserData'),'vect_mean_h');
vector_h=getfield(get(gcf,'UserData'),'vector_h');
comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
sData=data.sData;
undo=sData;
prompt='Enter the number of component to be removed.';
dim=length(sData.data(1,:));

if ~LOG
  answer=inputdlg(prompt);

  if isempty(answer) || (iscell(answer) && isempty(answer{1}))
    msgbox('Components not removed.');
    return;
  end

  value=str2num(answer{1});
  dims=size(value);

  if dims(1) ~= 1 || dims(2) ~= 1 || ~isreal(value)
    errordlg('Number of the component to be removed must be positive integer.')
    return;
  end

  if value <= 0 || round(value) ~= value
    errordlg('Number of the component to be removed must be positive integer.');
    return;
  end

  if value > getfield(size(sData.data),{2})
    errordlg('There are less components.');
    return;
  end
end

sD_set_h=getfield(get(gcf,'UserData'),'sD_set_h');
index=get(sD_set_h,'Value');
if value == 1 && getfield(size(sData.data),{2}) == 1
   if length(get(sD_set_h,'String')) == 1
    msgbox('No data left. Closing program...')
    pro_tools('close');
    return;
  end
 
  set1=data.sD_set(1:index-1);
  set2=data.sD_set(index+1:length(data.sD_set));
  data.sD_set=[set1 set2];
   set(gcf,'UserData',data);
  
  set_sD_stats;
  sel_sD;
  data=get(gcf,'UserData');
  data.undo.sData=undo;
  data.undo.index=index;
  set(gcf,'UserData',data);
  return;
end
dims=size(sData.data);
tmp_data=cat(2,sData.data(:,1:value-1),sData.data(:,value+1:dims(2)));
tmp_norm=cat(1,sData.comp_norm(1:value-1),sData.comp_norm(value+1:dims(2)));
names=cat(1,sData.comp_names(1:value-1),sData.comp_names(value+1:dims(2)));
INDEX=sData.INDEX;
comp_norm=sData.comp_norm;
sData=som_data_struct(tmp_data,...
                      'name',sData.name,...
                      'labels',sData.labels,...
                      'comp_names',names);
sData.comp_norm=tmp_norm;
sData.MODIFIED=1;
sData.INDEX=INDEX;
data=get(gcf,'UserData');
data.sData=sData;
data.undo.sData=undo;
data.selected_vects=1:length(sData.data(:,1));
if ~LOG
  data.LOG{length(data.LOG)+1}='% Remove component';
  data.LOG{length(data.LOG)+1}=sprintf('preprocess(''remove'',''%s'');',...
                                        answer{1});
end
set(gcf,'UserData',data);
clear_button;
write_sD_stats;
set_compnames(sData,comp_names_h);
tmp=ones(1,length(sData.data(:,1)));
draw_vectors(tmp,vector_h);
vect_means(sData,vect_mean_h,1:length(sData.data(:,1)));
cplot_mimema;
sel_comp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: remove_vects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function remove_vects(varargin)

if nargin==1
  LOG=1;
  tmp_str=varargin{1};
else
  LOG=0;
  tmp_str='_foo';
end
data=get(gcf,'UserData');
vect_mean_h=data.vect_mean_h;
vector_h=data.vector_h;
sData=data.sData;
undo=sData;

if length(data.selected_vects) == getfield(size(sData.data),{1})
  if LOG
    answer='Yes';
  else
    answer=questdlg('Do you want to delete this data set?');
  end
  if strcmp(answer,'No')
    return;
  else
    index=get(data.sD_set_h,'Value');
    if length(get(data.sD_set_h,'String')) == 1
      msgbox('No data left. Closing program...')
      pro_tools('close');
      return;
    end
     
    set1=data.sD_set(1:index-1);
    set2=data.sD_set(index+1:length(data.sD_set));
    data.sD_set=[set1 set2];
    set(gcf,'UserData',data);
  
    set(data.sD_set_h,'Value',1);
    set_sD_stats;
    sel_sD;
    data=get(gcf,'UserData');
    data.undo.sData=undo;
    data.undo.index=index;
    if ~LOG
      data.LOG{length(data.LOG)+1}='% Remove selected vectors';
      data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''remove_vects'',''',...
                                          tmp_str,''');');
    end
    set(gcf,'UserData',data);
    return;
  end
end

tmp=sData.data(data.selected_vects,:);
if ~LOG
  answer=questdlg('Do you want to save removed values to workspace?');
else
  if ~strcmp(tmp_str,'_foo')
    answer='Yes';
  else
    answer='No';
  end
end
old=gcf;
if strcmp(answer,'Yes')
  if ~LOG
    answer=inputdlg('Give the name of the output -variable.');
  else
    answer={tmp_str};
  end
  if isvalid_var_name(answer)
    assignin('base',answer{1},tmp);
    disp(sprintf('Removed values are set to workspace as''%s''.',answer{1}));
    tmp_str=answer{1};
  end
end
set(0,'CurrentFigure',old);
sData.data(data.selected_vects,:)=[];
sData.labels(data.selected_vects,:)=[];
sData.MODIFIED=1;
data.sData=sData;
data.selected=1:length(sData.data(:,1));
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)}='% Remove selected vectors';
  data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''remove_vects'',''',...
                                      tmp_str,''');');
end
set(gcf,'UserData',data);


draw_vectors(ones(1,length(data.selected)),data.vector_h);
write_sD_stats;
select_all('foo');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%% Subfunction: eval1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eval1(varargin)

if nargin == 1
  answer=varargin
  LOG=1;
else
  LOG=0;
end

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
if isempty(pre_h)
  errordlg('''Preprocess''-figure does not exist. Terminating program...');
  pro_tools('close');
  return;
end  

undo=getfield(get(pre_h,'UserData'),'sData');

if ~LOG
  prompt={'Enter the expression to be evaluated.',...
          'Enter the inverse normalization method (optional).'};
  title='Single component eval.';
  answer= inputdlg(prompt,title,1);
end

if ~isempty(answer)
  tmp=[];
  if ~isempty(answer{1})
    [tmp,method]=build_expr(answer{1},'single');
    if ~ischar(tmp)
      sData=getfield(get(gcf,'UserData'),'sData');
      tmp='Done.';
      %if ~isempty(answer{2})
      %  sN=som_norm_struct('eval',{method,answer{2}});
      %else
      %  sN=som_norm_struct('eval',{method});
      %end
      %sN=som_set(sN,'status','done');
      params={answer{1};answer{2}};
      ind=getfield(get_indices,{1});
      x.type='';
      x.method='eval';
      x.params={answer{1};answer{2}};
      x.status='';
      sData.comp_norm{ind}=x;
      data=get(gcf,'UserData');
      data.undo.sData=undo;
      data.sData=sData;
      if ~LOG
        data.LOG{length(data.LOG)+1}='% Eval (1-comp)';
        data.LOG{length(data.LOG)+1}=cat(2,'preprocess eval1 ',...
                 sprintf('{''%s''  ''%s''};',answer{1},answer{2}));
      end 
      set(pre_h,'UserData',data);

    end
  end    
  set(getfield(get(pre_h,'UserData'),'results_h'),'String',tmp);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: eval2

function eval2(varargin)

if nargin == 1
  answer=varargin{1};
  LOG=1;
else
  LOG=0;
end

undo=getfield(get(gcf,'UserData'),'sData');
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  errordlg('''Preprocess''-figure does not exist. Terminating program.');
  pro_tools('close');
  return;
end

if ~LOG
  prompt='Enter the expression to be evaluated.';
  title ='Eval';
  answer=inputdlg(prompt,title,1);
end

if ~isempty(answer) && ~isempty(answer{1})
   str=answer{1};
   [answer,foo]=build_expr(answer{1},'multiple');
   if ~ischar(answer)
     
     answer='Done.';
     data=get(gcf,'UserData');
     data.undo.sData=undo;
     if ~LOG
        data.LOG{length(data.LOG)+1}='% Eval';
        data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''eval2'',',...
                 sprintf('{''%s''});',str));
      end 
     set(gcf,'UserData',data);
   end
end

set(getfield(get(pre_h,'UserData'),'results_h'),'String',answer);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: zero2one_scale %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function zero2one_scale(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end


data=get(gcf,'UserData');
sData=data.sData;
undo=sData;
INDEX=sData.INDEX;
sData=rmfield(sData,[{'INDEX'};{'MODIFIED'}]);

if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be components chosen for scaling.');
  return;
end

sData=som_normalize(sData,'range',get_indices);
sData.MODIFIED=1;
sData.INDEX=INDEX;

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Scale [0,1]';
  data.LOG{length(data.LOG)+1}='preprocess(''zscale'', ''foo'');';
end 
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

cplot_mimema;
plot_hist;
vect_means(sData,data.vect_mean_h,data.selected_vects);
draw_vectors(vects,data.vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: var_scale %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function var_scale(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
sData=data.sData;
undo=sData;
INDEX=sData.INDEX;
sData=rmfield(sData,[{'INDEX'};{'MODIFIED'}]);

if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be components chosen for scaling.');
  return;
end  

sData=som_normalize(sData,'var',get_indices);

sData.INDEX=INDEX;
sData.MODIFIED=1;

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Scale var=1';
  data.LOG{length(data.LOG)+1}='preprocess(''vscale'', ''foo'');';
end 
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

cplot_mimema;
plot_hist;
vect_means(sData,data.vect_mean_h,data.selected_vects);
draw_vectors(vects,data.vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: hist_eq %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hist_eq(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
sData=data.sData;
undo=sData;
INDEX=sData.INDEX;
sData=rmfield(sData,[{'INDEX'},{'MODIFIED'}]);

if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be components chosen for ''Histogram eq''.');
  return;
end

sData=som_normalize(sData,'histD',get_indices);

sData.INDEX=INDEX;
sData.MODIFIED=1;

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Histogram eq';
  data.LOG{length(data.LOG)+1}='preprocess(''histeq'', ''foo'');';
end 
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

cplot_mimema;
plot_hist;
vect_means(sData,data.vect_mean_h,data.selected_vects);
draw_vectors(vects,data.vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: hist_eq2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hist_eq2(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end


data=get(gcf,'UserData');
sData=data.sData;
undo=sData;

INDEX=sData.INDEX;
sData=rmfield(sData,[{'INDEX'};{'MODIFIED'}]);

if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be components chosen for ''Histogram eq2''.');
  return;
end

inds=get_indices;
%%%[sData,ok]=som_normalize(sData,inds,'histC');
sData=som_normalize(sData,'histC',inds);
sData.INDEX=INDEX;
sData.MODIFIED=1;

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Histogram eq2';
  data.LOG{length(data.LOG)+1}='preprocess(''histeq2'', ''foo'');';
end 
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

cplot_mimema;
plot_hist;
vect_means(sData,data.vect_mean_h,data.selected_vects);
draw_vectors(vects,data.vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: logarithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function logarithm(varargin)

if nargin == 1
  LOG=1;
else
  LOG=0;
end

data=get(gcf,'UserData');
sData=data.sData;
undo=sData;

INDEX=sData.INDEX;
sData=rmfield(sData,[{'INDEX'},{'MODIFIED'}]);

if isempty(get(data.comp_names_h,'Value'))
  errordlg('There must be components chosen for ''Log''.');
  return;
end

Data=som_normalize(sData,'log',get_indices);

sData.INDEX=INDEX;
sData.MODIFIED=1;

data.sData=sData;
data.undo.sData=undo;
if ~LOG
  data.LOG{length(data.LOG)+1}='% Log';
  data.LOG{length(data.LOG)+1}='preprocess(''log'', ''foo'');';
end 
set(gcf,'UserData',data);

vects=zeros(1,length(sData.data(:,1)));
vects(data.selected_vects)=1;

cplot_mimema;
plot_hist;
vect_means(sData,data.vect_mean_h,data.selected_vects);
draw_vectors(vects,data.vector_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [answer,method]=build_expr(string,evaltype)

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

method=[];
if isempty(pre_h)
  close_preprocess;
  errordlg('''Preprocess'' -figure does not exist. Terminating program...'); 
  return;

end

if isempty(string)
  str = '[]';
  return;
end

tmp=[];
[name,assign,skip]=check_assign(string,evaltype);

if ~strcmp(assign,'NOTASSIGN') && ~strcmp(assign,'error')
  string=string(skip:length(string));
end

if ~strcmp(assign,'error')
  if isempty(string)
    answer='Illegal expression.';
    return;
  end
  [str,skip]=check_token(string,evaltype);
  method=string;
  while ~strcmp(str,'error') && ~strcmp(tmp,'error') && skip < length(string)
    if ~strcmp(tmp,')')
      str=cat(2,str,tmp);
    end
    [tmp,skip2]=check_token(string(skip+1:length(string)),evaltype);
    skip=skip+skip2;
               
  end
   if ~strcmp(tmp,')') && ~strcmp(tmp,'error')
     str=cat(2,str,tmp);
   elseif strcmp(tmp,'error')
     str='error';
   end
end

if ~strcmp(assign,'error') && ~strcmp(str,'error');
  answer=evalin('caller',str,'lasterr');
else
  answer='??? Illegal expression.';
end


data=get(pre_h,'UserData');
sData=data.sData;
if strcmp(assign,'NOTASSIGN') && strcmp(evaltype,'single') && ~ischar(answer)
  if isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'))
    errordlg('There are not components chosen.');
    answer='??? Illegal expression.';
    return;
  end
  index=getfield(get_indices,{1});
  if strcmp(assign,'NOTASSIGN')
    if length(sData.data(:,index)) ~=length(answer) && ~isscalar(answer)
      answer='??? Illegal assignment.';
    else
      sData.data(:,index)=answer;
      sData.MODIFIED=1;
      data.sData=sData;
      set(pre_h,'UserData',data);
    end
  else
    if length(sData.data(str2num(assign),index)) ~=length(answer) && ~isscalar(answer)
      answer='??? Illegal assignment.';
    else
      sData.data(str2num(assign),index)=answer;
      sData.MODIFIED=1;
      data.sData=sData;
      set(pre_h,'UserData',data);
    end
  end
elseif ~strcmp(assign,'error') && ~ischar(answer) && ~strcmp(assign,'NOTASSIGN')  
  switch name
    case 'x'
     if isempty(get(data.comp_names_h,'Value'))
       return;
     end
     index = getfield(get_indices,{1});
     if isempty(assign)
       if length(sData.data(:,index)) ~= length(answer) && ~isscalar(answer)
         answer='??? Illegal assignment.';
       else
         sData.data(:,index)=answer;
         sData.MODIFIED=1;
         data.sData=sData;
         if strcmp(evaltype,'multiple')
           data.sData.comp_norm(index)={[]};
         end
         set(pre_h,'UserData',data);
       end
     else
       args=create_args(assign,'x');
       if length(args) == 1
         len=max(str2num(args{1}));
         if ~isscalar(len)
           answer='??? Illegal assignment.';
           return;
         elseif len > length(sData.data(:,1)) || min(str2num(args{1})) < 1
           answer='??? Illegal assignment.';
           return;
         elseif ~all(size(sData.data(str2num(args{1}),index))) == size(answer) && ~isscalar(answer)
           answer='??? Illegal assignment.';
           return;
         else            
           sData.data(str2num(args{1}),index)=answer;
           sData.MODIFIED=1;
           data.sData=sData;
           if strcmp(evaltype,'multiple')
             data.sData.comp_norm(index)={[]};
           end
           set(pre_h,'UserData',data);
         end
       else
         len=max(str2num(args{1}));
         dim=max(str2num(args{2}));
         asize=size(answer);
         msize=size(sData.data);
         if ~isscalar(len) || ~isscalar(dim) 
           answer='??? Illegal assignment.';
           return;
         elseif len > length(sData.data(:,1)) || len < 1
           answer='??? Illegal assignment.';
           return;
         elseif dim > 1 || dim > msize(2) || min(str2num(args{2})) < 1
           answer='??? Illegal assignment.';
           return;
         end 
         len=length(str2num(args{1}));
         dim=length(str2num(args{1}));
         if ~all([len dim] == asize) && ~isscalar(answer) 
           answer='??? Illegal assignment.';
           return;
         else
           tmp=sData.data(:,index);
           tmp([str2num(args{1})],[str2num(args{2})])=answer;
           sData.data(:,index)=tmp;
           sData.MODIFIED=1;
           data.sData=sData;
           if strcmp(evaltype,'multiple')
             data.sData.comp_norm(index)={[]};
           end
           set(pre_h,'UserData',data);
         end
       end
     end

    case 'xs'
     if isempty(get(data.comp_names_h,'Value'))
       return;
     end
     indices=get_indices;
     if isempty(assign)
       if ~all(size(answer) == size(sData.data(:,indices))) && ~isscalar(answer)
         answer='??? Illegal assignment.';
       else       
         sData.data(:,indices) = answer;
         sData.MODIFIED=1;
         data.sData=sData;
         data.sData.comp_norm(indices)={[]};
         set(pre_h,'UserData',data);
       end
     else
       args=create_args(assign,'xs');
       if length(args) == 1
         len=max(str2num(args{1}));
         if ~isscalar(len)
           answer='??? Illegal assignment.';
           return;
         elseif len > length(sData.data(:,1)) || min(str2num(args{1})) < 1
           answer='??? Illegal assignment.';
           return;
         end
         if ~all(size(answer) == size(sData.data(str2num(args{1})))) &&...
            ~isscalar(answer)
           answer='??? Illegal assignment.';
           return;
         else
           tmp=sData.data(:,indices);
           tmp(str2num(args{1}))=answer;
           sData.data(:,indices)=tmp;
           sData.MODIFIED=1;
           sData.comp_norm{indices}={[]};
           data.sData=sData;
           set(pre_h,'UserData',data);
         end
       else
         len=max(str2num(args{1}));
         dim=max(str2num(args{2}));
         asize=size(answer);
         msize=size(sData.data(:,indices));
         if ~isscalar(len) || ~isscalar(dim)
           answer='??? Illegal assignment.';
           return;
         elseif len > msize(1) || min(str2num(args{1})) < 1
           answer='??? Illegal assignment.';
           return;
         elseif dim > msize(2) || min(str2num(args{2})) < 1
           answer='??? Illegal assignment.';
           return;
         end
         len=length(str2num(args{1}));
         dim=length(str2num(args{2}));
         if ~all([len dim] == asize) && ~isscalar(answer)
           answer='??? Illegal assignment';
           return;
         else
           tmp=sData.data(:,indices);
           tmp([str2num(args{1})],[str2num(args{2})])=answer;
           sData.MODIFIED=1;
           sData.data(:,indices)=tmp;
           data.sData=sData;
           data.sData.comp_norm(indices)={[]};
           set(pre_h,'UserData',data); 
         end
        
       end
     end

    case 'D'
     if isempty(assign)
       if ~all(size(answer) == size(sData.data)) && ~isscalar(answer)
         answer='??? Illegal assignment.';
       else
         if isscalar(answer)
           sData.data(:,:)=answer;
         else
           sData.data=answer;
         end
         sData.MODIFIED=1;
         data.sData=sData;
         data.sData.comp_norm(1:length(sData.data(1,:)))={[]};
         set(pre_h,'UserData',data);
       end
     else
       args=create_args(assign,'D');
       if length(args) == 1
         len=max(str2num(args{1}));
         if ~isscalar(len)
           answer='??? Illegal assignment.';
           return;
         elseif len > length(sData.data(:,1)) || min(str2num(args{1})) < 1
           answer='??? Illegal assignment.';
           return;
         end 
         if ~all(size(answer) == size(sData.data(str2num(args{1})))) &&...
            ~isscalar(answer)
           answer='??? Illegal assignment.';
         else
           sData.data(str2num(args{1}))=answer;
           sData.MODIFIED=1;
           data.sData=sData;
           [~,j]=ind2sub(size(sData.data),str2num(args{1}));
           data.sData.comp_norm(j)={[]};
           set(pre_h,'UserData',data);
         end
       else
         len=max(str2num(args{1}));
         dim=max(str2num(args{2}));
         asize=size(answer);
         msize=size(sData.data);
         if ~isscalar(len) || ~isscalar(dim)
           answer='??? Illegal assignment.';
           return;
         elseif len > msize(1) || min(str2num(args{1})) < 1
           answer='??? Illegal assignment.';
           return;
         elseif dim > msize(2) || min(str2num(args{2})) < 1
           answer= '??? Illegal assignment.';
           return;
         end
         len = length(str2num(args{1}));
         dim = length(str2num(args{2}));
         if ~all([len dim] == asize) && ~isscalar(answer)
           answer='??? Illegal assignment.';
           return;
         else
           sData.data([str2num(args{1})],[str2num(args{2})])=answer;
           sData.MODIFIED=1;
           data.sData=sData;
           data.sData.comp_norm(str2num(args{2}))={[]};
           set(pre_h,'UserData',data);
         end
       end
     end
  end
end
if sData.MODIFIED
  selected=getfield(get(pre_h,'UserData'),'selected_vects');
  vector_h=getfield(get(pre_h,'UserData'),'vector_h');
  vect_mean_h=getfield(get(pre_h,'UserData'),'vect_mean_h');
  vects=zeros(length(sData.data(:,1)));
  vects(selected)=1;
  draw_vectors(vects,vector_h);
  vect_means(sData,vect_mean_h,selected);
  pro_tools('plot_hist');
  pro_tools('c_stat');
  cplot_mimema;
end

 
%%% Subfunction: check_assign %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [name,string,skip]=check_assign(string,evaltype)


reswords=[{'D'};{'x'};{'xs'}];
flag=0;
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

if isempty(pre_h)
  man_h=findobj(get(0,'Children'),'Tag','Management');
  clip_h=findobj(get(0,'Children'),'Tag','Clipping');
  errordlg('''Preprocess'' -window does not exist. Terminating program.');
  if ~isempty(man_h)
    close man_h;
  end
  if ~isempty(clip_h)
    close clip_h;
  end
  return;
end

EMPTY=isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'));

[name,s]=give_token(string,evaltype);
skip=length(s);

if strcmp(evaltype,'single') && ~strcmp(name,'x')
  string='NOTASSIGN';
  return;
end

if strcmp(name,'other') && ~strcmp(s,'x') 
  string = 'error';
  return;
end

if strcmp(name,[{'x'};{'xs'}])
  comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');
  if isempty(get(comp_names_h,'Value'))
    errordlg('There are not components chosen.');
    string='error';
    return;
  end
end


if skip == length(string) || ~strcmp(name,reswords)
  string = 'NOTASSIGN';
  return;
end

if (strcmp(name,'x') || strcmp(name,'xs')) && EMPTY
  errordlg('There are not components chosen.');
  string = 'error';
  return;
end

[t,s]=give_token(string(length(name)+1),evaltype);

if strcmp(t,'(')
  flag=1;
end

[~,skip]=check_token(string,evaltype);
if length(name) ~= skip-1
  skip=skip-1;
  tmp=string(length(name)+1:skip);
else 
  tmp = [];
end

if flag && tmp(length(tmp)) ~= ')'
  tmp(length(tmp)+1)=')';
end

if skip==length(string)
  return;
end

skip=skip+1;
if length(string) ~= skip
  [t,s]=give_token(string(skip+1:length(string)),evaltype);
else
  string='NOTASSIGN';
  return;
end

if ~strcmp(t,'=')
  string = 'NOTASSIGN';
  return;
end
string=tmp;
skip = skip+2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: isscalar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool = isscalar(x)

  m= size(x);
  
  bool = m(1) == 1 & m(2) == 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: create_args %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function args=create_args(string,type)

arg2='';
i=2;
j=1;
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
msize=size(getfield(getfield(get(pre_h,'UserData'),'sData'),'data'));


if string(i) == ':'
  arg1=num2str(cat(2,'1:',num2str(msize(1))));
  i=i+1;
  j=j+length(arg1);
end

while string(i) ~=',' && string(i) ~=')'
  arg1(j)=string(i);
  i=i+1;
  j=j+1;
end



if string(i) ==','
  j=1;
  i=i+1;
  if string(i)==':'
    switch type
      case 'x'
       arg2='1';
      case 'cs'
       arg2=num2str(get_indices);
      case 'D'
       arg2=num2str(cat(2,'1:',num2str(msize(2))));
    end
    i=i+1;
    j=j+length(arg2);
  end

  while string(i) ~= ')'
    arg2(j)=string(i);
    j=j+1;
    i=i+1;
  end
end


args{1}=arg1;
if ~isempty(arg2)
  args{2} = arg2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [str,skip] = check_token(string,evaltype)

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

tmp_string=string;
[t,s]=give_token(tmp_string,evaltype);
skip=length(s);

if strcmp(t,'c')
  if isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'))
    errordlg('There are no components chosen.');
    str='error';
    return;
  end
  index=getfield(get_indices,{1});
  str=cat(2,'[',num2str(index),']');
  if skip == length(tmp_string)
    return;
  end
  tmp_string=tmp_string(skip+1:length(tmp_string));  
  [t,s] = give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  end
  [args,skip2] = get_args(tmp_string(length(s)+1:length(tmp_string)),'c',...
                          evaltype);
  skip=skip+skip2+2;
  if strcmp(args,'error')
    str = 'error'
    return;
  elseif ~strcmp(args,'all')
    str=cat(2,'getfield(',str,',',args,')');
  else
    str=cat(2,'getfield(',str,',{[1]})'); 
  end
elseif strcmp(t,'cs')
  if isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'))
    errordlg('There are no components chosen.');
    str='error';
    return;
  end
  str =cat(2,'[',num2str(get_indices),']');
  if length(s) == length(string)
    return;
  end
  tmp_string=tmp_string(1+length(s):length(string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  else
    [args,skip2]=get_args(tmp_string(1+length(s):length(tmp_string)),'cs',...
                          evaltype);
    skip=2+skip+skip2;
    if strcmp(args,'error')
      str='error';
      return;
    elseif ~strcmp(args,'all')
      str = cat(2,'getfield(',str,',',args,')');
    else
      tmp_str=str;
      str=cat(2,'[getfield(',str,',','{1})');
      for i=2:length(get_indices)
        str=cat(2,str,';getfield(',tmp_str,',',sprintf('{%d})',i));
      end
      str=cat(2,str,']');
    end
  end
elseif strcmp(t,'dim')
  ind1=getfield(size(getfield(getfield(get(pre_h,'UserData'),'sData'),'data')),{2});
  str=cat(2,'[',num2str(ind1),']');
  if length(s)==length(string)
    return;
  end
  tmp_string=string(1+length(s):length(string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  end
  skip=1+skip+length(s);
  [args,skip2]=get_args(tmp_string(1+length(s):length(tmp_string)),'dim',...
                        evaltype);
  if strcmp(args,'error')
    str = 'error';
    return;
  else
    skip=skip+skip2;
    if ~strcmp(args,'all')
      str=cat(2,'getfield(',str,',',args,')');
    end
  end

elseif strcmp(t,'dlen') 
  ind1=getfield(size(getfield(getfield(get(pre_h,'UserData'),'sData'),'data')),{1});
  str=cat(2,'[',num2str(ind1),']');
  if length(s)==length(string)
    return;
  end
  tmp_string=string(1+length(s):length(string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  end
  skip=skip+length(s);
  [args,skip2]=get_args(tmp_string(1+length(s):length(tmp_string)),'dlen',...
                        evaltype);
  if strcmp(args,'error')
    str='error';
    return;
  else
    skip=1+skip+skip2;
    if ~strcmp(args,'all')
      str=cat(2,'getfield(',str,',',args,')');
    end
  end

elseif strcmp(t,'x')
  if isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'))
    errordlg('There are not components chosen.');
    str='error';
    return;
  end
  len=getfield(size(getfield(getfield(get(pre_h,'UserData'),...
               'sData'),'data')),{1});
  index=num2str(getfield(get_indices,{1}));
  h_str='findobj(get(0,''Children''),''Tag'',''Preprocess'')';
  get_str=cat(2,'getfield(get(',h_str,',''UserData''),''sData'')');
  get_str=cat(2,'getfield(',get_str,',''data'')');
  str=cat(2,'getfield(',get_str,',{[1:',num2str(len),'],',index,'})');
  if length(s) == length(string)
    return;
  end
  tmp_string=string(1+length(s):length(string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(');
    return;
  end
  skip=skip+length(s);
  [args,skip2]=get_args(tmp_string(1+length(s):length(tmp_string)),'x',...
                        evaltype);
  if strcmp(args,'error')
    str = 'error';
    return;
  else
    skip=1+skip+skip2;
    if ~strcmp(args,'all')
      str=cat(2,'getfield(',str,',',args,')');
    end
  end

elseif strcmp(t,'xs')
  if isempty(get(getfield(get(pre_h,'UserData'),'comp_names_h'),'Value'))
    errordlg('There are not components chosen.');
    str='error';
    return;
  end
  len=getfield(size(getfield(getfield(get(pre_h,'UserData'),...
               'sData'),'data')),{1});
  index=get_indices;
  index=cat(2,'[',num2str(index),']');
  h_str='findobj(get(0,''Children''),''Tag'',''Preprocess'')';
  get_str=cat(2,'getfield(get(',h_str,',''UserData''),''sData'')');
  get_str=cat(2,'getfield(',get_str,',''data'')');
  str=cat(2,'getfield(',get_str,',{[1:',num2str(len),'],',index,'})');
  if length(s) == length(string)
    return;
  end
  tmp_string=string(1+length(s):length(string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  end
  skip=1+skip+length(s);

  [args,skip2]=get_args(tmp_string(1+length(s):length(tmp_string)),'xs',...
                        evaltype);
  if strcmp(args,'error')
    str = 'error';
    return;
  elseif ~strcmp(args,'all')  
    str=cat(2,'getfield(',str,',',args,')');
    skip=skip+skip2;
  else
    skip=skip+skip2;
    [dlen,dim]=size(eval(str));
    tmp_str=str;
    str=cat(2,'[','getfield(',tmp_str,sprintf(',{1:%d,1})',dlen));
    for i=2:dim
      tmp=sprintf(',{1:%d,%d})',dlen,dim);
      str=cat(2,str,';','getfield(',tmp_str,tmp);
    end
    str=cat(2,str,']');
  end
elseif strcmp(t,'D')
  get_h='findobj(get(0,''Children''),''Tag'',''Preprocess'')';
  str=cat(2,'getfield(getfield(get(',get_h,',''UserData''),''sData''),''data'')');

  if length(s) >= length(tmp_string)
    return;
  end

  tmp_string=tmp_string(1+length(s):length(tmp_string));
  [t,s]=give_token(tmp_string,evaltype);
  if ~strcmp(t,'(')
    return;
  else
    tmp_string=tmp_string(1+length(s):length(tmp_string));
    skip = skip+length(s);
    [args, skip2]=get_args(tmp_string,'D',evaltype);
    if strcmp(args,'error')
      str='error';
      return;
    elseif ~strcmp(args,'all')
      str=cat(2,'getfield(',str,',',args,')');
      skip=1+skip+skip2;
    else
      skip=1+skip+skip2;
      [dlen,dim]=size(eval(str));
      tmp_str=str;
      str=cat(2,'[getfield(',str,sprintf(',{1:%d,1})',dlen));
      for i=2:dim
        tmp=sprintf(',{1:%d,%d}',dlen,i);
        str=cat(2,str,';getfield(',tmp_str,tmp,')');
      end
      str=cat(2,str,']');
    end
  end  
else
  if strcmp(t,'(')
    str = t;
    str2='';
    tmp_string=tmp_string(1+length(s):length(tmp_string));
    while ~strcmp(str2,')') && ~isempty(tmp_string)
      [str2,skip2]=check_token(tmp_string,evaltype);
      if strcmp(str2,'error')
        str='error';
        return;
      end
      skip=skip+skip2;
      tmp_string=tmp_string(skip2+1:length(tmp_string));
      str=cat(2,str,str2);
    end
    if ~strcmp(str2,')')
      str = 'error';
    end
  else
    str = s;
  end
end

%%% Subfunction: get_args %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [str,skip] = get_args(string,flag,evaltype)

res_words=[{'D'};{'c'};{'cs'};{'dim'};{'dlen'};{'x'};{'xs'}];
NOTALL=1;
if isempty(string)
  str='error'
  skip=[];
  return;
end
[t,s] = give_token(string,evaltype);


skip=length(s);
if any(strcmp(t,res_words));
  [str,skip2] = check_token(string,evaltype);
  string=string(1+length(s):length(string)); 
  str=cat(2,'{[',str);
  [t,s]=give_token(string,evaltype);
elseif t==')' || t==','
  str = 'error';
  return;
elseif strcmp(t,':');
  if length(s) == length(string)
    str='error';
    return;
  end
  [t,s]=give_token(string(1+length(s):length(string)),evaltype);
  if t == ')'
    str = 'all';
    return;
  end
  switch flag
    case {'c','cs','dim','dlen'}
     str= '{[1';
    otherwise
     str=cat(2,'{[',get_all('vect'));
  end
  NOTALL=0;
  string=string(1+length(s):length(string));
  [t,s]=give_token(string,evaltype);
  skip=skip+1;
else 
  str = cat(2,'{[',s);
end
str2 =[];


if ~strcmp(t,',') && ~strcmp(t,')')
  skip=skip-length(s);
end



while ~strcmp(t,',') && ~strcmp(t,')') && NOTALL;
  str=cat(2,str,str2);
  [~,s] = give_token(string,evaltype);
  if length(s) == length(string)
    str = 'error';
    return;
  end
  string=string(1+length(s):length(string));
  skip=skip+length(s);
  [t,s]=give_token(string,evaltype);
  if length(s) == length(string) && ~strcmp(t,')')
    str = 'error';
    return;
  end

  [str2,foo]=check_token(string,evaltype);  
end 

if NOTALL && ~strcmp(t,')')
 skip=skip+1;
end

if strcmp(t,')')
  str=cat(2,str,']}');
  return
end

str=cat(2,str,']',',','[');
str2 = [];


[t,s] = give_token(string,evaltype);
if strcmp(t,')')
  str = 'error'
  return;
end
NOTALL=1;
string=string(1+length(s):length(string));
[t,s]=give_token(string,evaltype);
if strcmp(t,':');
   switch flag
     case {'c','dim','dlen','x'}
      str=cat(2,str,'1');
     case 'D'
      str=cat(2,str,get_all('comp'));
     case {'cs','xs'}
      str=cat(2,str,'1:',num2str(length(get_indices)));
   end
   NOTALL=0;
   if length(s) == length(string)
    str='error';
    return;
   end
   string=string(1+length(s):length(string));
   [t,s]=give_token(string,evaltype);
end

if ~strcmp(t,')') && NOTALL
  skip=skip-1;
end

while ~strcmp(t,')') && NOTALL
  str=cat(2,str,str2);
  skip=skip+length(s);
  if length(s) == length(string) && ~strcmp(t,')')
    str='error';
    return;
  end
  [str2,foo]=check_token(string,evaltype);
  string=string(1+length(s):length(string));
  [t,s]=give_token(string,evaltype);
end
if ~strcmp(t,')')
  str='error';
  return;
end


str=cat(2,str,str2,']}');
skip=skip+length(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: get_all %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str=get_all(vect_or_comp)

pre_h=findobj(get(0,'Children'),'Tag','Preprocess');

switch vect_or_comp
  case 'vect'
   dim=getfield(size(getfield(getfield(get(pre_h,'UserData'),...
                'sData'),'data')),{1});
   str=cat(2,'1:',num2str(dim));
  case 'comp'
   dim=getfield(size(getfield(getfield(get(pre_h,'UserData'),...
                'sData'),'data')),{2});
   str=cat(2,'1:',num2str(dim));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [token,str]=give_token(string,evaltype)

n=length(string);
i=1;
char=string(i);

switch analyze_char(string(i));
  case 'num'
   token='num';
   while i <= n && strcmp('num',analyze_char(string(i)))
     str(i)=string(i);
     i=i+1;
   end
  case 'other'
   switch string(i)
     case ':'
      token = ':';
     case ','
      token = ',';
     case '('
      token = '(';
     case ')'
      token = ')';
     case '='
      token = '=';
     otherwise
      token='other';
   end
   str=string(i);
  case 'alpha'
   while i <= n && strcmp('alpha',analyze_char(string(i)))
    str(i)=string(i);
    i=i+1;
   end
   token = find_res_word(str,evaltype);
end

%%% Subfunction: analyze_char %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function type=analyze_char(char)


if ((char-0) >= ('0'-0) &&  (char-0) <= ('9'-0))
  type='num';
elseif   ((char-0) >= ('a'-0) && (char-0) <= ('z'-0)) ...
       || ((char-0) >= ('A'-0) && (char-0) <= ('Z'-0))  
  type='alpha';
else
  type='other';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Subfunction: find_res_word %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function token = find_res_word(string,evaltype)

reswords=[{'D'};{'c'};{'cs'};{'dim'};{'dlen'};{'x'};{'xs'};{'other'}];

for i=1:length(reswords);
  token=reswords{i};
  if strcmp(string,reswords{i})
    if strcmp(evaltype,'single') && ~strcmp(string,'x')
      token = 'other';
    end
    return;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function close_func(varargin)

switch varargin{1}
  case 'close_c'
   str='% Closing the ''Clipping'' -window...';
   clip_h=findobj(get(0,'Children'),'Tag','Clipping');
   close(clip_h);
  case 'close_sD'
   str='% Closing the ''Data Set Management'' -window...';
   sD_h=findobj(get(0,'Children'),'Tag','Management');
   close(sD_h);
  case 'close_w'
   str='% Closing the ''Windowed'' -window...';
   win_h=findobj(get(0,'Children'),'Tag','Window');
   close(win_h);
  case 'close_s'
   str='% Closing the ''Select'' -window...';
   sel_h=findobj(get(0,'Children'),'Tag','Select');
   close(sel_h);
  case 'close_d'
   str='% Closing the ''Delay'' -window...';
   del_h=findobj(get(0,'Children'),'Tag','Delay');
   close(del_h);
end

if nargin ~= 2
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  preh_udata=get(pre_h,'UserData');
  str2=cat(2,'preprocess(''',varargin{1},''',''foo'');');
  preh_udata.LOG{length(preh_udata.LOG)+1}=str;
  preh_udata.LOG{length(preh_udata.LOG)+1}=str2;
  set(pre_h,'UserData',preh_udata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function log_file

answer=inputdlg('Give the name of the outputfile:','LOG function',1,...
                {'log_function'});

if isempty(answer)
  return;
end


tmp=clock;
str =cat(2,'% Created: ',...
           date,...
           ' ',sprintf('%d:%d\n%\n\n',tmp(4),tmp(5)));
pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
LOG=getfield(get(pre_h,'UserData'),'LOG');
file=cat(2,pwd,'/',answer{1},'.m');
fid =fopen(file,'w');

arg=LOG{2}(12:length(LOG{2})-2);
fprintf(fid,'%s\n \n',cat(2,'function ',answer{1},'(',arg,')'));
fprintf(fid,'%s\n',str);
for i=1:length(LOG)
  fprintf(fid,'%s\n',LOG{i});
end
fclose(fid);
disp(sprintf('LOG-file ''%s'' is done.',file));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function get_selected_inds(varargin)

if nargin == 1
  LOG=1;
  answer = {varargin{1}};
else
  LOG=0;
end

selected=getfield(get(gcf,'UserData'),'selected_vects');
if ~LOG
  answer=inputdlg('Give the name of the output variable:',...
                '',1,{'indices'});
end

if isempty(answer) || isempty(answer{1})
  return;
else
  assignin('base',answer{1},selected);
  disp(cat(2,'Indices of the selected vectors are set to the workspace ',...  
           sprintf(' as ''%s''.',answer{1})));
  if ~LOG
    data=get(gcf,'UserData');
    data.LOG{length(data.LOG)+1}=...
    '% Saving indices of the selected vectors to the workspace.';
    data.LOG{length(data.LOG)+1}=cat(2,'preprocess(''get_inds'',',...
                                        '''',answer{1},''');');
    set(gcf,'UserData',data);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function no_of_selected(varargin)

if nargin == 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  set(0,'CurrentFigure',pre_h);
  LOG = 1;
else
  LOG = 0;
end

results_h=getfield(get(gcf,'UserData'),'results_h');
no=length(getfield(get(gcf,'UserData'),'selected_vects'));
str={sprintf('Number of selected vectors: %d\n', no)};
set(results_h,'String',str,'HorizontalAlignment','left');

if ~LOG
  data=get(gcf,'UserData');
  data.LOG{length(data.LOG)+1}='% Number of selected vectors';
  data.LOG{length(data.LOG)+1}='preprocess(''no_of_sel'',''foo'');';
  set(gcf,'UserData',data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function select_all_comps(varargin)

if nargin == 1
  pre_h=findobj(get(0,'Children'),'Tag','Preprocess');
  set(0,'CurrentFigure',pre_h);
  LOG=1;
else
  LOG=0;
end

comp_names_h=getfield(get(gcf,'UserData'),'comp_names_h');

set(comp_names_h,'Value',[1:length(get(comp_names_h,'String'))]);
sel_comp;

if ~LOG
  data=get(gcf,'UserData');
  data.LOG{length(data.LOG)+1}='% Select all components';          
  data.LOG{length(data.LOG)+1}='preprocess(''sel_all_comps'',''foo'');';
  set(gcf,'UserData',data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

function code=write_log_code(indices,arg1,arg2,arg3,arg4,arg5,arg6)

str=textwrap({num2str(indices)},500);

code{1}=sprintf('inds=[];');
for i=1:length(str);
  code{i+1}=sprintf('  inds=cat(2,inds,[%s]);',str{i});
end
str=cat(2,'preprocess(''''clip_data'''',''''',arg1,' ',num2str(arg2),' ',...
                      num2str(arg3),' ',num2str(arg4),...
                      ' ',num2str(arg5),' ',num2str(arg6),' ');
code{length(code)+1}=cat(2,'eval(cat(2,',...
                            '''',str,'''',...
                            ',num2str(inds),'''''');''));');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
