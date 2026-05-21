function varargout=som_select(c_vect,plane_h,arg)

%SOM_SELECT  Manual selection of map units from a visualization.
%
% som_select(c_vect,[plane_h])
%     
%   som_select(3)
%   som_select(sM.labels(:,1))
%
%  Input arguments ([]'s are optional):
%   c_vect    (scalar) number of classes 
%             (vector) initial class identifiers
%             (cell array) of strings, class names
%             (matrix) size * x 3, the color of each class
%   [plane_h] (scalar) handle of the plane (axes) to be marked. 
%                      By default, the current axes is used (GCA).
%                      For the function to work, the plot in the 
%                      axes must have been created with the
%                      SOM_CPLANE function (or SOM_SHOW).
% 
% Launches a GUI which allows user to select nodes from plane by 
% clicking them or by choosing a region (a polygon). 
% 
%   Middle mouse button: selects (or clears selection of) a single node
%   Left mouse button:   lets user draw a polygon
%   Right mouse button:  selects (or clears selection of) the units 
%                        inside the polygon
% 
% From the GUI, the color (class) is selected as well as whether
% but buttons select or clear the selection from the units. The
% buttons on the bottom have the following actions: 
% 
%   'OK'    Assigns the class identifiers to the 'ans' variable in 
%           workspace. The value is an array of class identifiers: 
%           strings (cellstr) if the c_vect was an array of
%           strings, a vector otherwise.
%   'Clear' Removes marks from the plane.
%   'Close' Closes the application. 
%
% See also SOM_SHOW, SOM_CPLANE.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas 
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100, juuso 010200

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if nargin < 2, plane_h = gca; end
if(isempty(gcbo)), arg='start'; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

switch arg
 case 'start'
  patch_h=find_patch(plane_h);
  lattice=getfield(size(get(patch_h,'XData')),{1});
  msize(1)=floor(getfield(get(plane_h,'YLim'),{2})); 
  msize(2)=floor(getfield(get(plane_h,'XLim'),{2})-0.5);   
  if lattice==6
    lattice='hexa';
  else
    lattice='rect';
  end
  
  if any(strcmp(get(patch_h,'Tag'),{'planeBar','planePie'}))
    tmp_dim=size(get(patch_h,'XData'),2)/prod(msize);
    tmp_xdata=get(patch_h,'XData');
    tmp_x=tmp_xdata(:,(msize(1)*(msize(2)-1)+2)*tmp_dim);
    if floor(tmp_x(1)) ~= round(tmp_x(1))
      lattice = 'hexa';
    else
      lattice = 'rect';
    end
  elseif strcmp(get(patch_h,'Tag'),'planePlot')
    tmp_lines_h=get(gca,'Children');
    test_x=mean(get(tmp_lines_h(2),'XData'));
    if round(test_x) ~= floor(test_x)
      lattice = 'hexa';
    else
      lattice = 'rect';
    end
    form=0.5*vis_patch('hexa');
    l = size(form,1);
    
    nx = repmat(form(:,1),1,prod(msize));
    ny = repmat(form(:,2),1,prod(msize));
    
    x=reshape(repmat(1:msize(2),l*msize(1),1),l,prod(msize));
    y=repmat(repmat(1:msize(1),l,1),1,msize(2));
    
    if strcmp(lattice,'hexa')
      t = find(~rem(y(1,:),2));
      x(:,t)=x(:,t)+.5;
    end
    x=x+nx;
    y=y+ny;
    
    colors=reshape(ones(prod(msize),1)*[NaN NaN NaN],...
		   [1 prod(msize) 3]);
    v=caxis;
    patch_h=patch(x,y,colors,...
		  'EdgeColor','none',...
		  'ButtonDownFcn',...
		  'som_select([],[],''click'')',...
		  'Tag','planePlot');
    set([gca gcf],'ButtonDownFcn','som_select([],[],''click'')');
    caxis(v)
  end

  c_colors = []; 
  if iscell(c_vect)
    [c_vect,c_names,c_classes]=class2num(c_vect);
    if length(c_classes)<prod(msize), 
      c_classes = zeros(prod(msize),1);
    end
  else
    if all(size(c_vect)>1), 
      c_colors = c_vect; 
      c_names = 1:size(c_vect,1); 
      c_vect = size(c_vect,1); 
      c_classes = zeros(prod(msize),1);
    elseif length(c_vect)==prod(msize),
      c_classes = c_vect;
      u = unique(c_classes(isfinite(c_classes) & c_classes>0));
      c_names = u;
      c_vect = length(u);       
    elseif length(c_vect)>1, 
      c_names = c_vect; 
      c_vect = length(c_vect);
      c_classes = zeros(prod(msize),1);
    elseif length(c_vect)==1,
      c_names = 1:c_vect;        
      c_classes = zeros(prod(msize),1);
    end
  end
  
  udata.lattice=lattice;
  udata.patch_h=patch_h;
  udata.plane_h=plane_h;
  udata.type=get(udata.patch_h,'Tag');
  udata.msize=msize;
  set(patch_h,'UserData',udata);
  if strcmp(udata.type,'planePlot')
    set([gca gcf],'UserData',udata);
  end
  str=cat(2,'som_select([],[],''click'')');
  set(patch_h,'ButtonDownFcn',str);

  draw_colorselection(c_names,c_colors);
  tmp_data=findobj(get(0,'Children'),'Tag','SELECT_GUI');
  tmp_data=get(tmp_data,'UserData');
  tmp_data.c_names=c_names;
  tmp_data.mat=reshape(c_classes,msize);
  tmp_data.patch_h=patch_h;
  tmp_data.plane_h=plane_h;
  tmp_data.type=get(udata.patch_h,'Tag');
  tmp_data.lattice=lattice;
  tmp_data.coords=[];
  tmp_data.poly_h=[];
  tmp_data.msize=msize;
  tmp_data.mode='select';  
  set(tmp_data.fig_h,'UserData',tmp_data);   
  draw_classes;
  
 case 'click'
  switch get(gcf,'SelectionType')
   case 'open'
    return;
   case {'normal','alt'}
    draw_poly;
   case 'extend'
    click;
  end 
 case 'choose'
  draw_colorselection(0,0,'choose');
 case 'close'
  close_gui;
 case 'clear'
  clear_plane;
 case 'rb'
  rb_control;
 case 'ret_mat'
  gui=findobj(get(0,'Children'),'Tag','SELECT_GUI');
  gui=get(gui,'UserData');
  mat=reshape(gui.mat,numel(gui.mat),1);
  if ~isempty(gui.c_names)
    if isnumeric(gui.c_names), tmp=zeros(length(mat),1);
    else tmp=cell(length(mat),1);
    end
    for i=1:length(gui.c_names)
      inds=find(mat==i);
      tmp(inds)=gui.c_names(i);
    end       
    mat=tmp;
  end  
  varargout{1}=mat;
  %gui.mat=zeros(size(gui.mat));
  %set(gui.fig_h,'UserData',gui);
  %h=findobj(get(gui.plane_h,'Children'),'Tag','SEL_PATCH');
  %delete(h);
end  

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function rb_control

h=findobj(get(gcf,'Children'),'Style','radiobutton');
set(h,'Value',0);
set(gcbo,'Value',1);

udata=get(gcf,'UserData');
if strcmp(get(gcbo,'Tag'),'Radiobutton1')
  udata.mode='select';
else
  udata.mode='clear';
end

set(gcf,'UserData',udata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clear_plane

h=findobj(get(0,'Children'),'Tag','SELECT_GUI');
gui=get(h,'UserData');

if strcmp(get(gui.patch_h,'Tag'),'planePlot')
  colors=reshape(get(gui.patch_h,'FaceVertexCData'),[prod(gui.msize) 3]);
  colors(:,:)=NaN;
  set(gui.patch_h,'FaceVertexCData',colors);
end

h=findobj(get(gui.plane_h,'Children'),'Tag','SEL_PATCH');
gui.mat=zeros(gui.msize);
set(gui.fig_h,'UserData',gui);
delete(h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function click

udata=get(gcbo,'UserData');

udata=get(udata.patch_h,'UserData');  
coords=get(gca,'CurrentPoint');
row=round(coords(1,2));
if row > udata.msize(1), row = udata.msize(1); end
if row < 1, row = 1; end
if any(strcmp(udata.lattice,{'hexa','hexaU'})) && ~mod(row,2), 
  col=floor(coords(1,1))+0.5;
  if col > udata.msize(2)+0.5, col=udata.msize(2)+0.5; end
else
  col=round(coords(1,1));
  if col > udata.msize(2), col=udata.msize(2); end
end
if col < 1, col = 1; end

if strcmp(udata.type,'planePlot')

  if ~mod(row,2) && strcmp(udata.lattice,'hexa'), col=round(col-0.5); end
  
  ind=sub2ind(udata.msize,row,col);
  colors=reshape(get(udata.patch_h,'FaceVertexCData'),[prod(udata.msize) 3]);
  gui=findobj(get(0,'Children'),'Tag','SELECT_GUI');
  gui=get(gui,'UserData');
  
  if ~isempty(gui.curr_col) && all(~isnan(colors(ind,1,:))),
    if ~strcmp(gui.mode,'clear') && ~all(gui.curr_col == colors(ind,:))
      colors(ind,:)=gui.curr_col;
      gui.mat(row,col)=gui.class;
    else
      colors(ind,:)=[NaN NaN NaN];
      gui.mat(row,col)=0;
    end
  elseif strcmp(gui.mode,'clear')
    colors(ind,:)=[NaN NaN NaN];
    gui.mat(row,col)=0;
  elseif isempty(gui.curr_col)
    return;
  else
    gui.mat(row,col)=gui.class;
    colors(ind,:)=gui.curr_col;
  end
  set(udata.patch_h,'FaceVertexCData',colors);
  set(gui.fig_h,'UserData',gui);
  return;
end  

if any(strcmp(udata.type,{'planePie','planeBar'}))
  [x,y]=pol2cart(0:0.1:2*pi,0.5);
  coords=[x';0.5]*0.7;
  coords(:,2)=[y';0]*0.7;
elseif strcmp(udata.lattice,'hexa');
  coords=0.7*vis_patch('hexa');
else
  coords=0.7*vis_patch('rect');
end
coords(:,1)=coords(:,1)+col;
coords(:,2)=coords(:,2)+row;
if ~mod(row,2) && strcmp(udata.lattice,'hexa'), col=round(col-0.5); end
 
hold on;
if gco == udata.patch_h
  gui=findobj(get(0,'Children'),'Tag','SELECT_GUI');
  gui=get(gui,'UserData');
  if isnan(gui.curr_col) || strcmp(gui.mode,'clear'), return; end
  h=fill(coords(:,1),coords(:,2),gui.curr_col);
  str=cat(2,'som_select([],[],''click'')');
  set(h,'ButtonDownFcn',str,'Tag','SEL_PATCH');
  tmp.patch_h=udata.patch_h;
  set(h,'UserData',tmp);
  gui.mat(row,col)=gui.class;
  set(gui.fig_h,'UserData',gui);
else
  gui=findobj(get(0,'Children'),'Tag','SELECT_GUI');
  gui=get(gui,'UserData');
  if ~all(get(gcbo,'FaceColor') == gui.curr_col) && ~strcmp(gui.mode,'clear'),
    if ~isnan(gui.curr_col), 
      set(gcbo,'FaceColor',gui.curr_col);
      gui.mat(row,col) = gui.class;
    end
  else
    gui.mat(row,col)=0;
    delete(gco);
  end
  set(gui.fig_h,'UserData',gui);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw_colorselection(varargin)

if length(varargin)==2, 

  if length(varargin{1})==1, 
    n = varargin{1};
    names = 1:n;
  else
    n = length(varargin{1}); 
    names = varargin{1}; 
  end
  colors = varargin{2}; 
  
  shape=[0.5 -0.5;0.5 0.5;1.5 0.5;1.5 -0.5];
  rep_x=repmat(shape(:,1),1,n);
  rep_y=repmat(shape(:,2),1,n);
  for i=0:getfield(size(rep_y,2))-1, rep_x(:,i+1)=rep_x(:,i+1)+i; end
  if isempty(colors), colors=jet(n); end
  data=som_select_gui;
  data.colors=colors;
  data.curr_col=NaN;
  data.class=0;
  set(0,'CurrentFigure',data.fig_h);
  hold on;
  tmp=fill(rep_x,rep_y,0.8);
  for i=1:n
    set(tmp(i),...
        'EdgeColor',[0 0 0],...
        'FaceColor',colors(i,:),...
        'ButtonDownFcn','som_select([],0,''choose'');');
  end
  axis('equal');
  axis('on');
  set(gca,'XTick',1:n,'XTickLabel',names,'XAxisLocation','top');
  set(data.a_h,'YLim',[-0.5,0.5],...
	       'XLim',[0.5 n+0.5],...
	       'YTickLabel','');
  set(data.fig_h,'UserData',data);

elseif strcmp(varargin{3},'choose')
  
  udata=get(gcf,'UserData');
  if strcmp(get(gcbo,'Selected'),'off')
    old=findobj(get(gca,'Children'),'Type','patch');
    set(old,'Selected','off');
    set(gcbo,'Selected','on');
    udata.curr_col=udata.colors(round(mean(get(gcbo,'XData'))),:);
    udata.class=mean(get(gcbo,'XData'));
  else
    set(gcbo,'Selected','off');
    udata.curr_col=NaN;
    udata.class=0;
  end
  set(gcf,'UserData',udata);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data=som_select_gui()


a = figure('Color',[0.8 0.8 0.8], ...
	'PaperType','a4letter', ...
	'Position',[586 584 560 210], ...
	'Tag','SELECT_GUI');

data.fig_h=a;

b = axes('Parent',a, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'DataAspectRatioMode','manual', ...
	'PlotBoxAspectRatio',[20 1 2], ...
	'PlotBoxAspectRatioMode','manual', ...
	'Position',[0.13 0.11 0.775 0.815], ...
	'Tag','Axes1', ...
	'WarpToFill','off', ...
	'XColor',[0 0 0], ...
	'XLimMode','manual', ...
	'YColor',[0 0 0], ...
	'YLimMode','manual', ...
	'YTickLabelMode','manual', ...
	'ZColor',[0 0 0]);

data.a_h=b;

b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'Callback','som_select([],[],''close'')', ...
	'FontWeight','demi', ...
	'Position',[150 12 50 20], ...
	'String','CLOSE', ...
	'Tag','Pushbutton1');

b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
        'Callback','som_select([],0,''ret_mat'')',...
	'FontWeight','demi', ...
	'Position',[365 12 50 20], ...
	'String','OK', ...
	'Tag','Pushbutton2');

b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
        'Callback','som_select([],0,''clear'')',...
	'FontWeight','demi', ...
	'Position',[257.5 12 50 20], ...
	'String','CLEAR', ...
	'Tag','Pushbutton3');

b = uicontrol('Parent',a, ...
        'Units','points', ...
        'Position',[50 27 17 16], ...
        'Callback','som_select([],[],''rb'')',...
        'Style','radiobutton', ...
        'Tag','Radiobutton1', ...
        'Value',1);
b = uicontrol('Parent',a, ...
        'Units','points', ...
        'BackgroundColor',[0.701961 0.701961 0.701961], ...
        'Callback','som_select([],[],''rb'')',...
        'Position',[50 7 17 16], ...
        'Style','radiobutton', ...
        'Tag','Radiobutton2');
b = uicontrol('Parent',a, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontSize',9, ...
        'FontWeight','demi', ...
        'HorizontalAlignment','left', ...
        'Position',[72 25 28 15], ...
        'String','Select', ...
        'Style','text', ...
        'Tag','StaticText1');
b = uicontrol('Parent',a, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontSize',9, ...
        'FontWeight','demi', ...
        'HorizontalAlignment','left', ...
        'Position',[72 7 25 13.6], ...
        'String','Clear', ...
        'Style','text', ...
        'Tag','StaticText2');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function close_gui

udata=get(get(gcbo,'Parent'),'UserData');

if strcmp(udata.type,'planePlot');
  set(udata.plane_h,'ButtonDownFcn','','UserData',[]);
  set(get(udata.plane_h,'Parent'),'ButtonDownFcn','');
  delete(udata.patch_h);
  return;
end  

h=findobj(get(udata.plane_h,'Children'),'Tag','SEL_PATCH');
set(udata.patch_h,'ButtonDownFcn','','UserData',[]);
delete(h);
close(udata.fig_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw_poly

udata=get(findobj(get(0,'Children'),'Tag','SELECT_GUI'),'UserData');

if isempty(udata.coords) && strcmp(get(gcf,'SelectionType'),'alt')
  return;
end

coords(1,1) = getfield(get(gca,'CurrentPoint'),{3});
coords(1,2) = getfield(get(gca,'CurrentPoint'),{1});
udata.coords = cat(1,udata.coords,coords);
delete(udata.poly_h);
subplot(udata.plane_h);

hold on;
switch get(gcf,'SelectionType');
 case 'normal'
  udata.poly_h=plot(udata.coords(:,2),udata.coords(:,1),'black',...
		    'ButtonDownFcn','som_select([],[],''click'')',...
		    'LineWidth',2);
  set(udata.fig_h,'UserData',udata);
 case 'alt'
  udata.coords=cat(1,udata.coords,udata.coords(1,:));
  udata.poly_h=plot(udata.coords(:,2),udata.coords(:,1),'black',...
		    'LineWidth',2);
  delete(udata.poly_h);
  if ~isnan(udata.curr_col)
    tmp=sort(repmat((1:udata.msize(1))',udata.msize(2),1));
    tmp(:,2)=repmat((1:udata.msize(2))',udata.msize(1),1);
    tmp2=tmp;
    if strcmp(udata.type,'planePlot')
      in=find(inpolygon(tmp(:,2),tmp(:,1),...
			udata.coords(:,2),udata.coords(:,1)));
      row=tmp2(in,1);
      col=tmp2(in,2);
      in=sub2ind(udata.msize,row,col);
      colors=reshape(get(udata.patch_h,'FaceVertexCData'),...
		     [prod(udata.msize) 3]);
      if ~isnan(udata.curr_col) && ~strcmp(udata.mode,'clear')
        colors(in,:)=ones(length(in),1)*udata.curr_col;
        udata.mat(row,col)=udata.class;
      elseif strcmp(udata.mode,'clear')
        colors(in,:)=[NaN NaN NaN];
        udata.mat(row,col)=0;
      end
      udata.poly_h=[];
      udata.coords=[];
      set(udata.patch_h,'FaceVertexCData',colors);
      set(udata.fig_h,'UserData',udata);
      return;
    end
    if strcmp(udata.lattice,'hexa');
      t=find(~rem(tmp(:,1),2));
      tmp(t,2)=tmp(t,2)+0.5;
      if any(strcmp(get(udata.patch_h,'Tag'),{'planeC','planeU'}))
        p=0.7*vis_patch('hexa');
      else
        [x,y]=pol2cart(0:0.1:2*pi,0.5);
        p=[x';0.5]*0.7;
        p(:,2)=[y';0]*0.7;
      end
    else
      if any(strcmp(get(udata.patch_h,'Tag'),{'planeC','planeU'}))
        p=0.7*vis_patch('rect');
      else
        [x,y]=pol2cart(0:0.1:2*pi,0.5);
        p=[x';0.5]*0.7;
        p(:,2)=[y';0]*0.7;
      end 
    end
    in=find(inpolygon(tmp(:,2),tmp(:,1),udata.coords(:,2),udata.coords(:,1)));
    set(udata.fig_h,'UserData',udata);
    if strcmp(udata.mode,'select')
      remove_selpatches;
      udata=get(udata.fig_h,'UserData');
      for i=1:length(in)
	udat.patch_h=udata.patch_h;
	h=patch(p(:,1)+tmp(in(i),2),p(:,2)+tmp(in(i),1),...
		udata.curr_col,...
		'EdgeColor','black',...
		'ButtonDownFcn','som_select([],[],''click'')', ...
		'Tag','SEL_PATCH',...
		'UserData',udat);
	udata.mat(tmp2(in(i),1),tmp2(in(i),2))=udata.class;
      end
    else
      remove_selpatches;
      udata=get(udata.fig_h,'UserData');
      %h=findobj(get(udata.plane_h,'Children'),'Tag','SEL_PATCH');
      %for i=1:length(h)
      %    if all(get(h(i),'FaceColor')==udata.curr_col) & ...
      %       inpolygon(mean(get(h(i),'XData')),mean(get(h(i),'YData')),...
      %       udata.coords(:,2),udata.coords(:,1))
      %       coords=[floor(mean(get(h(i),'YData')))...
      %               floor(mean(get(h(i),'XData')))];
      %       udata.mat(coords(1),coords(2))=0;
      %      delete(h(i));
      %    end
      %end
    end
  end
  udata.poly_h=[];
  udata.coords=[];
  set(udata.fig_h,'UserData',udata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function remove_selpatches

udata=get(findobj(get(0,'Children'),'Tag','SELECT_GUI'),'UserData');
h=findobj(get(udata.plane_h,'Children'),'Tag','SEL_PATCH');
for i=1:length(h)
  if inpolygon(mean(get(h(i),'XData')),mean(get(h(i),'YData')),...
               udata.coords(:,2),udata.coords(:,1));
    coords=[floor(mean(get(h(i),'YData')))...           
            floor(mean(get(h(i),'XData')))];
    udata.mat(coords(1),coords(2))=0;
    delete(h(i));
  end
end

set(udata.fig_h,'UserData',udata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n,names,classes]=class2num(class)

names = {};
classes = zeros(length(class),1);
for i=1:length(class)
  if ~isempty(class{i}), 
    a = find(strcmp(class{i},names));
    if isempty(a), 
      names=cat(1,names,class(i));
      classes(i) = length(names);
    else
      classes(i) = a;
    end
  end
end
n=length(names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h=find_patch(a_h)

h=[];

tags={'planeC','planeU','planePie','planeBar','planePlot'};

for i=1:5
  if ~isempty(findobj(get(a_h,'Children'),'Tag',tags{i}))
    h=findobj(get(gca,'Children'),'Tag',tags{i});
    if length(h) > 1
      h=h(1);
    end
    return;
  end
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw_classes

udata=get(findobj(get(0,'Children'),'Tag','SELECT_GUI'), ...
	  'UserData');
figure(get(udata.plane_h,'Parent'))
subplot(udata.plane_h);

colors=zeros(prod(udata.msize),3)+NaN;
c_map=jet(length(udata.c_names));
inds = find(udata.mat);
for i=1:length(inds), 
  colors(inds(i),:) = c_map(udata.mat(inds(i)),:);
end

if strcmp(udata.type,'planePlot'),

  set(udata.patch_h,'FaceVertexCData',colors);
  set(udata.fig_h,'UserData',udata);

else

  hold on
  co = som_vis_coords(udata.lattice,udata.msize);
  if any(strcmp(get(udata.patch_h,'Tag'),{'planeC','planeU'}))
    p=0.7*vis_patch(udata.lattice);
  else
    [x,y]=pol2cart(0:0.1:2*pi,0.5);
    p=[x';0.5]*0.7;
    p(:,2)=[y';0]*0.7;
  end
  for i=1:length(inds),
    udat.patch_h=udata.patch_h;
    h=patch(p(:,1)+co(inds(i),1),p(:,2)+co(inds(i),2),...
	    colors(inds(i),:),...
	    'EdgeColor','black',...
	    'ButtonDownFcn','som_select([],[],''click'')', ...
	    'Tag','SEL_PATCH',...
	    'UserData',udat);
  end 
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
