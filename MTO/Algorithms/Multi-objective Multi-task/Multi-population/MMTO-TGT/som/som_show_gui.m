function fig = som_show_gui(input,varargin)

%SOM_SHOW_GUI A GUI for using SOM_SHOW and associated functions.
%
%  h = som_show_gui(sM);
%
%  Input and output arguments:
%    sM     (struct) a map struct: the SOM to visualize
%    h      (scalar) a handle to the GUI figure
%
% This is a graphical user interface to make the usage of SOM_SHOW and
% associated functions somewhat easier for beginning users of the SOM
% Toolbox.
%
% How to use the GUI: 
%  1. Start the GUI by giving command som_show_gui(sM);
%  2. Build a list of visualization planes using the buttons 
%     ('Add components', etc.) on the right 
%     - the options associated with each of the planes can be 
%       modified by selecting a plane from the list, and pressing
%       the 'Plane options' button
%     - the controls below the list apply to all planes
%     - the subplot grid size can be controlled using the 'subplots'
%       field on top right corner, e.g. '4 3' to get 4 times 3 grid
%  3. To visualize the planes, press the 'Visualize' button on the bottom.
%  4. To add hits, labels, trajectories (or comets) to the 
%     visualization, or clear them, or reset the colorbars, 
%     see the tools available from the 'Tools' menu. 
%     - the arguments to those tools are either given in the tool, 
%       or read from the workspace ('Select variable' buttons)
%     - the tools always apply to the latest figure created
%       by the GUI
%  5. To quit, press the 'Close' button on the bottom.
%
% Known bugs:
%  - Especially when using the adding tools, you can easily 
%    give arguments which do not fit each other, and this 
%    results in a lengthy (and often cryptic) error message.
%    In such a case, check the arguments you are giving to see
%    if there's something wrong with them. See function 
%    SOM_SHOW_ADD for more information on how the options 
%    can be set.
%  - The default values in the adding tools may not be 
%    very reasonable: you may have to try out different 
%    values for e.g. markersize before getting the kind of
%    result you want.
% 
% SOM_SHOW_GUI has two subfunctions: VIS_SHOW_GUI_COMP and 
% VIS_SHOW_GUI_TOOL. These are for internal use of SOM_SHOW_GUI.
%
% See also SOM_SHOW, SOM_SHOW_ADD, SOM_SHOW_CLEAR, SOM_RECOLORBAR.

% Copyright (c) 2000 by Roman Feldman and Juha Vesanto
% Contributed to SOM Toolbox on August 22nd, 2000
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta roman 160800 juuso 220800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    MAIN                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off;
if (nargin < 1)
  errordlg({'Make sure you have SOM as input argument'; ''; ...
            'example: som_show_gui(sMap)'},'Error in SOM_VIS: input arguments');
  return
end

if isstruct(input)
  fig_h = create_main_gui(input);
  if (nargout > 0) fig = fig_h; end
  return;

elseif ischar(input)
  action = lower(input);

  % 
  udata = get(varargin{1},'UserData');
  plot_array = udata.plot_array;
  l = length(plot_array);
  list1_h = udata.h(1);

  if (strcmp(action,''))
    errordlg('','Error in SOM_VIS: input arguments');
    return;

  %%%%%%%%%%%%%%%%%%%%
  % add_selected_comp
  %
  elseif (strcmp(action,'add_selected_comp'))
    if isempty(plot_array(1).string), tmp = 1; else tmp = l+1; end 
    [sel,ok] = listdlg('ListString',udata.sM.comp_names,...
                       'Name','Component selection',...
                       'PromptString','Select components to add');  
    if ok && ~isempty(sel), 
      for i=1:length(sel),
        plot_array(tmp+i-1).string = udata.sM.comp_names{sel(i)}; 
        plot_array(tmp+i-1).args = {'comp' sel(i)};
        udata.property{tmp+i-1} = {0};
      end      
      set(list1_h,'Value',tmp+i-1, ...
                  'String',{plot_array(:).string});
    end

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % add_all_comps
  %
  elseif (strcmp(action,'add_all_comps'))
    if (strcmp(plot_array(1).string,''))
      tmp = 1;
    else
      tmp = l+1;
    end
    indx = length(udata.sM.comp_names);
    for (i=1:indx)
      plot_array(tmp+i-1).string = udata.sM.comp_names{i};
      plot_array(tmp+i-1).args = {'comp' i};
      udata.property{tmp+i-1} = {0};
    end	
    % update list
    set(list1_h,'Value',tmp+indx-1, ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % add_u_matrix
  %
  elseif (strcmp(action,'add_u_matrix'))
    if (strcmp(plot_array(1).string,''))
      tmp = 1;
    else
      tmp = l+1;
    end
    plot_array(tmp).string = 'U-matrix';
    plot_array(tmp).args = {'umat' 'all'};
    udata.property{tmp} = {0 'U-matrix' 1:length(udata.sM.comp_names)};
    % update list
    set(list1_h,'Value',tmp, ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % add_colorplane
  %
  elseif (strcmp(action,'add_colorplane'))
    if (strcmp(plot_array(1).string,''))
      tmp = 1;
    else
      tmp = l+1;
    end
    plot_array(tmp).string = 'color plane';
    c = som_colorcode(udata.sM);
    plot_array(tmp).args = {'color' c};
    udata.property{tmp} = {0 'Color code' {'rgb1' 'rgb2' 'rgb3' 'rgb4' 'hsv' '-variable-'} 1};
    % update list
    set(list1_h,'Value',tmp, ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % add_empty
  %
  elseif (strcmp(action,'add_empty'))
    if (strcmp(plot_array(1).string,''))
      tmp = 1;
    else
      tmp = l+1;
    end
    plot_array(tmp).string = 'empty plane';
    plot_array(tmp).args = {'empty' ''};
    udata.property{tmp} = {''};
    % update list
    set(list1_h,'Value',tmp, ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % remove
  %
  elseif (strcmp(action,'remove'))
    rm_indx = get(list1_h,'Value');
    rm_l = length(rm_indx);
    % rebuild array
    incl_inds = setdiff(1:length(plot_array),rm_indx);
    if isempty(incl_inds), 
      clear plot_array;
      plot_array(1).args = {};
      plot_array(1).string = '';
      udata.property = {};
      udata.property{1} = {};
    else
      plot_array = plot_array(incl_inds);
      udata.property = udata.property(incl_inds);
    end
    set(list1_h,'Value',length(plot_array), ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % remove_all
  %
  elseif (strcmp(action,'remove_all'))
    plot_array = [];
    plot_array(1).args = {};
    plot_array(1).string = '';
    udata.property = {};
    set(list1_h,'Value',1, ...
                'String',{plot_array(:).string});

    udata.plot_array = plot_array;
    set(varargin{1},'UserData',udata);

  %%%%%%%%%%%%%%%%%%%%
  % more_options
  %
  elseif (strcmp(action,'more_options'))
    vis_show_gui_comp(varargin{1},get(list1_h,'Value'),'init');

  %%%%%%%%%%%%%%%%%%%%
  % close
  %
  elseif (strcmp(action,'close'))
    close(varargin{1});

  %%%%%%%%%%%%%%%%%%%%
  % visualize
  %
  elseif (strcmp(action,'visualize'))     %% s = {k k.^2}; plot(s{:});
    current_fig = varargin{1}; 
    figure;
    args = [{udata.sM} plot_array(:).args];
    % edge
    tmp = get(udata.h(2),'UserData');
    i = get(udata.h(2),'Value');
    args = [args {'edge' tmp{i}}];
    % bar
    tmp = get(udata.h(3),'UserData');
    i = get(udata.h(3),'Value');
    args = [args {'bar' tmp{i}}];
    % norm
    tmp = get(udata.h(4),'UserData');
    i = get(udata.h(4),'Value');
    args = [args {'norm' tmp{i}}];
    % size
    tmp = get(udata.h(5),'String');
    args = [args {'size' eval(tmp)}];
    % colormap
    tmp = get(udata.h(6),'String');
    if ~isempty(tmp)
      args = [args {'colormap' eval(tmp)}];
    end
    % footnote
    tmp = get(udata.h(7),'String');
    args = [args {'footnote' tmp}];
    % subplots
    tmp = get(udata.h(8),'String');
    if ~(strcmp(tmp,'default') || isempty(tmp))
      tmp2 = sscanf(tmp,'%i %i');
      if length(tmp2)<2, tmp2 = sscanf(tmp,'%ix%i'); end
      if length(tmp2)<2, tmp = eval(tmp);
      else tmp = tmp2';
      end
      if length(tmp)<2, tmp(2) = 1; end
      if tmp(1)*tmp(2)<length(get(udata.h(1),'string')),
        close(varargin{1});
        errordlg('Too small subplot size', ...
                 'Error in SOM_VIS: subplot size');
        return;
      end
      args = [args {'subplots' tmp}];
    end

    som_show(args{:});

    % udata.vis_h = varargin{1};
    %  first refresh plot info
    udata.vis_h = setdiff( ...
                    udata.vis_h, ...
                    setdiff(udata.vis_h,get(0,'children')));
    udata.vis_h = [udata.vis_h gcf];
    set(current_fig,'UserData',udata);

  else
  end

else
  errordlg({'Make sure you have SOM as input argument'; ''; ...
            'example: som_show_gui(sMap)'},'Error in SOM_VIS: input arguments');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------------        SUBFUNCTIONS       -----------------------  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              CREATE_MAIN_GUI                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fig_h = create_main_gui(sM)

oldFigNumber=watchon;

% init variables
FIGURENAME = 'SOM_SHOW_GUI';
plot_array = [];
plot_array(1).args = {};
plot_array(1).string = '';

% colors
fig_color = [0.8 0.8 0.8];
bg_color1 = [0.701960784313725 0.701960784313725 0.701960784313725];
bg_color2 = [0.9 0.9 0.9];

%%%%  positions  %%%%%
%---------  figure
fig_i =            [0.02 0.25];
fig_s =            [0.24 0.55];
%---------  
ue = 0.02;
th = 0.03;
hint_text_pos =                [0.05 0.94 0.8 th];
big_frame_pos =                [ue 0.38 (1-2*ue) 0.56];
planes_listbox_text_pos =      [0.07 0.87 0.3 th];
planes_listbox_pos =           [(ue+0.03) 0.395 0.46 0.47];
subplots_text_pos =            [0.53 0.885 0.2 th];
subplots_pos =                 [0.73 0.88 0.22 0.05];  ah = 0.045; d = (planes_listbox_pos(4) - 10*ah)/7;
add_components_pos =           [0.53 (sum(planes_listbox_pos([2 4]))-ah) 0.42 ah]; tmp = add_components_pos(2)-(d+ah);
add_all_components_pos =       [0.53 tmp 0.42 ah]; tmp = add_all_components_pos(2)-(d+ah);
add_u_matrix_pos =             [0.53 tmp 0.42 ah]; tmp = add_u_matrix_pos(2)-(d+ah);
add_colorplane_pos =           [0.53 tmp 0.42 ah]; tmp = add_colorplane_pos(2)-(d+ah);
add_empty_pos =                [0.53 tmp 0.42 ah]; tmp = add_empty_pos(2)-2*(d+ah)+d;
remove_pos =                   [0.53 tmp 0.42 ah]; tmp = remove_pos(2)-(d+ah);
remove_all_pos =               [0.53 tmp 0.42 ah]; tmp = remove_all_pos(2)-2*(d+ah)+d;
plane_options_pos =            [0.53 tmp 0.42 ah]; 
ph = 0.041;
dd = (ph-th)/2;
tmp = big_frame_pos(2) - (planes_listbox_pos(2)-big_frame_pos(2)) - ph;
ie1 = 0.25;
tw = 0.21;
iw = 0.28;
unit_edges_text_pos =          [ue (tmp+dd) tw th];
unit_edges_pos =               [ie1 tmp iw ph]; tmp = unit_edges_pos(2)-(d+ph) - d;
unit_sizes_text_pos =          [ue (tmp+dd) tw th];
unit_sizes_pos =               [ie1 tmp iw ph]; tmp = unit_sizes_pos(2)-(d+ph) - d;
colorbar_dir_text_pos =        [ue (tmp+dd) tw th];
colorbar_dir_pos =             [ie1 tmp iw ph]; tmp2 = sum(colorbar_dir_pos([1 3]));
colorbar_norm_text_pos =       [(tmp2) (tmp+dd) 0.11 th];
colorbar_norm_pos =            [(1-ue-(iw+0.06)) tmp (iw+0.06) ph]; tmp = colorbar_norm_pos(2)-(d+ph) - d;
colormap_text_pos =            [ue (tmp+dd) tw th];
colormap_pos =                 [ie1 tmp iw ph]; tmp = colormap_pos(2)-(d+ph) - d;
footnote_text_pos =            [ue (tmp+dd) tw th]; 
footnote_pos =                 [ie1 tmp (1-ue-ie1) ph];
tmp = planes_listbox_pos(2)-big_frame_pos(2);
tmp2 = ah+2*tmp;
little_frame_pos =             [ue tmp (1-2*ue) tmp2]; tmp2 = little_frame_pos(2)+tmp;
ddd = 0.1;
bw = (little_frame_pos(3)-2*0.03-ddd)/2;
visualize_pos =                [(ue+0.03) tmp2 bw ah];
close_pos =                    [(sum(visualize_pos([1 3]))+ddd) tmp2 bw ah];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  main figure
%
fig_h = figure( ...
  'Units','normalized', ...
  'Color',fig_color, ...
  'PaperPosition',[18 180 576 432], ...
  'PaperType','A4', ...
  'PaperUnits','normalized', ...
  'Position',[fig_i fig_s], ...
  'ToolBar','none', ...
  'NumberTitle','off', ...
  'Name',FIGURENAME, ...
  'Visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  hint text
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',hint_text_pos, ...
  'String','Add planes and then visualize', ...
  'Style','text');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  planes listbox
%
uicontrol( ...
  'Units','normalized', ...
  'Position',big_frame_pos, ...
  'Style','frame');

uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color1, ...
  'HorizontalAlignment','left', ...
  'Position',planes_listbox_text_pos, ...
  'String','Planes', ...
  'Style','text');

list1_h = uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color2, ...
  'Position',planes_listbox_pos, ...
  'String',{plot_array(:).string}, ...
  'Style','listbox', ...
  'Max',2, ...
  'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit subplots
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color1, ...
  'HorizontalAlignment','center', ...
  'Position',subplots_text_pos, ...
  'String','subplots', ...
  'Style','text');

edit4_h = uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color2, ...
  'Position',subplots_pos, ...
  'FontSize',14, ...
  'String','', ...
  'Style','edit');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Add components'
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color1, ...
  'HorizontalAlignment','left', ...
  'Position',add_components_pos, ...
  'String',' Add components', ...
  'Callback',['som_show_gui(''add_selected_comp'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Add all components'
%
uicontrol( ...
  'Units','normalized', ...
  'HorizontalAlignment','left', ...
  'Position',add_all_components_pos, ...
  'String',' Add all components', ...
  'Callback',['som_show_gui(''add_all_comps'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Add U-matrix'
%
uicontrol( ...
  'Units','normalized', ...
  'HorizontalAlignment','left', ...
  'Position',add_u_matrix_pos, ...
  'String',' Add U-matrix', ...
  'Callback',['som_show_gui(''add_u_matrix'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Add colorplane'
%
uicontrol( ...
  'Units','normalized', ...
  'HorizontalAlignment','left', ...
  'Position',add_colorplane_pos, ...
  'String',' Add colorplane', ...
  'Callback',['som_show_gui(''add_colorplane'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Add empty'
%
uicontrol( ...
  'Units','normalized', ...
  'HorizontalAlignment','left', ...
  'Position',add_empty_pos, ...
  'String',' Add empty', ...
  'Callback',['som_show_gui(''add_empty'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Remove'
%
uicontrol( ...
  'Units','normalized', ...
  'HorizontalAlignment','left', ...
  'Position',remove_pos, ...
  'String',' Remove', ...
  'Callback',['som_show_gui(''remove'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creat pushbutton 'Remove all'
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color1, ...
  'HorizontalAlignment','left', ...
  'Position',remove_all_pos, ...
  'String',' Remove all', ...
  'Callback',['som_show_gui(''remove_all'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Plane options'
%
uicontrol( ...
  'Units','normalized', ...
  'Position',plane_options_pos, ...
  'String',' Plane options', ...
  'Callback',['som_show_gui(''more_options'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  popupmenu unitedges
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',unit_edges_text_pos, ...
  'String','unit edges are', ...
  'Style','text');

popup1_h = uicontrol( ...
  'Units','normalized', ...
  'Max',2, ...
  'Min',1, ...
  'Position',unit_edges_pos, ...
  'UserData',{'off' 'on'}, ...
  'String',{'off' 'on'}, ...
  'Style','popupmenu', ...
  'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  unit sizes edit
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',unit_sizes_text_pos, ...
  'String','unit sizes', ...
  'Style','text');

edit1_h = uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color2, ...
  'Position',unit_sizes_pos, ...
  'FontSize',12, ...
  'String','1', ...
  'Style','edit');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  popupmenu colorbardir
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',colorbar_dir_text_pos, ...
  'String','colorbar is', ...
  'Style','text');

popup2_h = uicontrol( ...
  'Units','normalized', ...
  'Max',3, ...
  'Min',1, ...
  'Position',colorbar_dir_pos, ...
  'UserData', {'vert' 'horiz' 'none'}, ...
  'String','vert| horiz| none', ...
  'Style','popupmenu', ...
  'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  popupmenu colorbarnorm
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',colorbar_norm_text_pos, ...
  'String',' and  ', ...
  'Style','text');

popup3_h = uicontrol( ...
  'Units','normalized', ...
  'Max',2, ...
  'Min',1, ...
  'Position',colorbar_norm_pos, ...
  'UserData', {'d' 'n'}, ...
  'String',{'denormalized','normalized'}, ...
  'Style','popupmenu', ...
  'Value',1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  colormap edittext
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',colormap_text_pos, ...
  'String','colormap', ...
  'Style','text');

edit2_h = uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color2, ...
  'Position',colormap_pos, ...
  'FontSize',12, ...
  'String','', ...
  'Style','edit');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  footnote edittext
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',fig_color, ...
  'HorizontalAlignment','left', ...
  'Position',footnote_text_pos, ...
  'String','footnote', ...
  'Style','text');

edit3_h = uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color2, ...
  'Position',footnote_pos, ...
  'FontSize',12, ...
  'String',sM.name, ...
  'Style','edit');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Visualize'
%
uicontrol( ...
  'Units','normalized', ...
  'Position',little_frame_pos, ...
  'Style','frame');

uicontrol( ...
  'Units','normalized', ...
  'Position',visualize_pos, ...
  'String','Visualize', ...
  'Callback',['som_show_gui(''visualize'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pushbutton 'Close'
%
uicontrol( ...
  'Units','normalized', ...
  'BackgroundColor',bg_color1, ...
  'Position',close_pos, ...
  'String','Close', ...
  'Callback',['som_show_gui(''close'',' mat2str(gcf) ')']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menus
%
uimenu('Parent',fig_h','Label','    ','Enable','off');
m = uimenu('Parent',fig_h,'Label','Tools');
 a = uimenu('Parent',m,'Label','Add');
  s = strcat('vis_show_gui_tool(',mat2str(gcf),',''add_label'')');
  uimenu('Parent',a,'Label','label','Callback',s);
  s = strcat('vis_show_gui_tool(',mat2str(gcf),',''add_hit'')');
  uimenu('Parent',a,'Label','hit','Callback',s);
  s = strcat('vis_show_gui_tool(',mat2str(gcf),',''add_traj'')');
  uimenu('Parent',a,'Label','traj','Callback',s);
  s = strcat('vis_show_gui_tool(',mat2str(gcf),',''add_comet'')');
  uimenu('Parent',a,'Label','comet','Callback',s);
 s = ['vis_show_gui_tool(',mat2str(gcf),',''clear'')'];
 c = uimenu('Parent',m,'Label','Clear','Separator','on','callback',s);
 s = strcat('vis_show_gui_tool(',mat2str(gcf),',''recolorbar'')');
 r = uimenu('Parent',m,'Label','Recolorbar','Separator','on', ...
  'Callback',s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%

ud.sM = sM;
ud.plot_array = plot_array;
ud.property = {};
ud.vis_h = [];
ud.h = [list1_h popup1_h popup2_h popup3_h ...
        edit1_h edit2_h edit3_h edit4_h];

watchoff(oldFigNumber);
set(fig_h,'Visible','on', ...
          'UserData', ud, ...
          'handlevisibility','off');

