function varargout=sompak_rb_control(str)

%SOMPAK_RB_CONTROL  An auxiliary function for SOMPAK_*_GUI functions.
%
% This is an auxiliary function for SOMPAK_GUI, SOMPAK_INIT_GUI, 
% SOMPAK_SAMMON_GUI and SOMPAK_TRAIN_GUI functions. It controls the 
% radio buttons in the GUIs.
%  
% See also SOMPAK_GUI, SOMPAK_INIT_GUI, SOMPAK_SAMMON_GUI, SOMPAK_TRAIN_GUI.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100

data=get(gcf,'UserData');
switch str
  case {'rand','linear'}
   h=cat(2,findobj(get(gcf,'Children'),'Tag','RANDOM'),...
	   findobj(get(gcf,'Children'),'Tag','LINEAR'));
   set(h,'Value',0);
   set(gcbo,'Value',1);
   data.inittype=str;
  case {'bubble','gaussian'}
   h=cat(2,findobj(get(gcf,'Children'),'Tag','BUBBLE'),...
           findobj(get(gcf,'Children'),'Tag','GAUSSIAN'));
   set(h,'Value',0);
   set(gcbo,'Value',1);
   data.neigh=str;
  case {'hexa','rect'}
   h=cat(2,findobj(get(gcf,'Children'),'Tag','HEXA'),...
           findobj(get(gcf,'Children'),'Tag','RECT'));
   set(h,'Value',0);
   set(gcbo,'Value',1);
   data.topol=str;
  case {'out_ft'}
   value=get(gcbo,'Value');
   switch value
     case 1
      h=findobj(get(gcf,'Children'),'Tag','OUT_FILE');
      data.out_file_type='';
      set(h,'String','');
     case 2
      data.out_file_type='box';
     case 3
      data.out_file_type='pak';
   end
  case {'input_ft'}
   value=get(gcbo,'Value');
   switch value
     case 1
      data.input_file_type='';
     case 2
      data.input_file_type='box';
     case 3
      data.input_file_type='pak';
   end
  case {'map_ft'}
   value=get(gcbo,'Value');
   switch value
     case 1
      data.map_type='';
     case 2
      data.map_type='box';
     case 3
      data.map_type='pak';
   end
  case {'out_file'}
   if isempty(data.out_file_type)
     data.out_file='';
     h=findobj(get(gcf,'Children'),'Tag','OUT_FILE');
     set(h,'String','');
   else
     data.out_file=get(findobj(get(gcf,'Children'),'Tag','OUT_FILE'),'String');
     if isempty(data.out_file)
       h=findobj(get(gcf,'Children'),'Tag','OUT_FILE_TYPE');
       set(h,'Value',1);
     end
   end

  case {'out_var'}
   h=findobj(get(gcf,'Children'),'Tag','OUT_VAR');
   if ~isempty(get(h,'String'))
     data.out_var=get(h,'String');
   else
     data.out_var=[];
     set(h,'String','''ans''');
   end
  case {'xdim'}
   h=findobj(get(gcf,'Children'),'Tag','XDIM');
   data.xdim=str2num(get(h,'String'));
  case {'ydim'}
   h=findobj(get(gcf,'Children'),'Tag','YDIM');
   data.ydim=str2num(get(h,'String'));
  case {'radius'}
   h=findobj(get(gcf,'Children'),'Tag','RADIUS');
   data.radius=str2num(get(h,'String'));
  case {'data'}
   h=findobj(get(gcf,'Children'),'Tag','DATA');
   data.data=get(h,'String');
  case {'rlen'}
   h=findobj(get(gcf,'Children'),'Tag','RLEN');
   data.rlen=str2num(get(h,'String'));
  case {'alpha'}
   h=findobj(get(gcf,'Children'),'Tag','ALPHA');
   data.alpha=str2num(get(h,'String'));
  case {'map'}
   h=findobj(get(gcf,'Children'),'Tag','MAP');
   data.map=get(h,'String');
  case 'init_ok'
   if isempty(data.xdim) || ~is_positive_integer(data.xdim)
     errordlg('Argument ''xdim'' must be positive integer.');
     return;
   end
   if isempty(data.ydim) || ~is_positive_integer(data.ydim)
     errordlg('Argument ''ydim'' must be positive integer.');
     return;
   end
   if isempty(data.data)
     errordlg('Argument ''Workspace data'' must be a string.');
     return;
   end

   if isempty(data.input_file_type)
     sData=evalin('base',data.data);
   else 
     sData=data.data;
   end
   if isempty(data.out_file)
     if ~isempty(data.out_file_type)
       errordlg('Argument ''Output file'' is not defined.');
       return;
     end
     data.out_file=[];
   end
   answer=sompak_init(sData,...
                      data.input_file_type,...
                      data.inittype,...
                      data.out_file,...
                      data.out_file_type,...
                      data.xdim,...
                      data.ydim,...
                      data.topol,...
                      data.neigh);
   if any(strcmp(data.out_var,{'ans','''ans'''})) || ischar(answer)
     varargout{1}=answer; 
   else
     assignin('base',data.out_var,answer);
     disp(sprintf('Map is set to workspace as ''%s''.',data.out_var));
   end
   close(findobj(get(0,'Children'),'Tag','InitGUI'));
   return;
  case 'train_ok'
   if isempty(data.rlen) || ~is_positive_integer(data.rlen)
     errordlg('Argument ''Running Length'' must be positive integer.');
     return;
   end
   if isempty(data.alpha) || data.alpha <= 0
     errordlg('Argument ''Initial Alpha Value'' must be a positive float.');
     return;
   end
   if isempty(data.radius) || data.radius <= 0
     errordlg('Argument ''Neighborhood Radius'' must be a positive float.');
     return;
   end
   if isempty(data.data)
     errordlg('Argument ''Teaching Data'' must be a string.');
     return;
   end
   if isempty(data.input_file_type)
     sData=evalin('base',data.data);
   else 
     sData=data.data;
   end
   if isempty(data.out_file);
     data.outfile = [];
   end
   if isempty(data.map)
     errordlg('Argument ''Workspace Map'' must be a string.');
     return;
   end
   if isempty(data.map_type)
     sMap=evalin('base',data.map);
   else
     sMap=data.map;
   end

   answer=sompak_train(sMap,...
                       data.map_type,...
                       data.out_file,...
                       data.out_file_type,...
                       data.data,...
                       data.input_file_type,...
                       data.rlen,...
                       data.alpha,...
                       data.radius);
   if any(strcmp(data.out_var,{'''ans''','ans'})) || ischar(answer)
     varargout{1}=answer;
   else
     assignin('base',data.out_var,answer);
     disp(sprintf('Map is set to workspace as ''%s''.',data.out_var));
   end
   close(findobj(get(0,'Children'),'Tag','TrainGUI')); 
   return;
  case 'sammon_ok'
   if isempty(data.map)
    errordlg('Argument ''Workspace Map'' must be a string.');
    return;
   end
   if isempty(data.map_type)
     sMap=evalin('base',data.map);
   else
     sMap=data.map;
   end
   if isempty(data.out_file);
     data.outfile = [];
   end
   answer=sompak_sammon(sMap,...
                        data.map_type,...
                        data.out_file,...
                        data.out_file_type,...
                        data.rlen);
   if strcmp(data.out_var,'''ans''')||strcmp(data.out_var,'ans')||ischar(answer)
     varargout{1}=answer;
   else
     assignin('base',data.out_var,answer);
     disp(sprintf('Codebook is set to workspace as ''%s''.',data.out_var));
   end
   close(findobj(get(0,'Children'),'Tag','SammonGUI')); 
   return;
end

set(gcf,'UserData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool = is_positive_integer(x)

bool = ~isempty(x) & isreal(x) & all(size(x) == 1) & x > 0;
if ~isempty(bool)
  if bool && x~=round(x)
    bool = 0;
  end
else
  bool = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



