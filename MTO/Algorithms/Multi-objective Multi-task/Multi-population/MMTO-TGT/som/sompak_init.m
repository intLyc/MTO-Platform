function sMap=sompak_init(sData,ft,init_type,cout,ct,xdim,ydim,topol,neigh)

%SOMPAK_INIT Call SOM_PAK initialization programs from Matlab.
%
% sMap=sompak_init(sData,ft,init_type,cout,ct,xdim,ydim,topol,neigh)
%
% ARGUMENTS  ([]'s are optional and can be given as empty: [] or '')
%  sData      (struct) data struct
%             (matrix) data matrix
%             (string) filename
%  [ft]       (string) 'pak' or 'box'. Argument must be defined, if input
%                      file is used.
%  init_type  (string) string 'rand' or 'linear'
%  [cout]     (string) filename for output SOM, if argument is not defined
%                      (i.e. argument is '[]') temporary file '__abcdef' is
%                      used in operations and *it_is_removed* after 
%                      operations!!!
%  [ct]       (string) 'pak' or 'box'. Argument must be defined, if output
%                      file is used.
%  xdim       (scalar) Number of units of the map in x-direction.
%  ydim       (scalar) Number of units of the map in y-direction.
%  topol      (string) string 'hexa' or 'rect'
%  neigh      (string) string 'bubble' or 'gaussian'.
%
% RETURNS
%  sMap       (struct) map struct
%
% Calls SOM_PAK initialization programs (randinit and lininit) from
% Matlab. Notice that to use this function, the SOM_PAK programs must
% be in your search path, or the variable 'SOM_PAKDIR' which is a
% string containing the program path, must be defined in the
% workspace. SOM_PAK programs can be found from:
% http://www.cis.hut.fi/research/som_lvq_pak.shtml
%  
% See also SOMPAK_TRAIN, SOMPAK_SAMMON, SOMPAK_INIT_GUI,
%          SOMPAK_GUI, SOM_LININIT, SOM_RANDINIT.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100

nargchk(9,9,nargin);

NO_FILE = 0;
if isstruct(sData);
  sData=sData.data;
elseif ~(isreal(sData) || ischar(sData))
  error('Argument ''sData'' must be a struct or a real matrix.');
else
  if isempty(ft)
    if ischar(sData)
      error('Argument ''file_type'' must be defined when input file is used.');
    end
  elseif strcmp(ft,'pak');
    sData=som_read_data(sData);
  elseif strcmp(ft,'box')
    new_var=diff_varname;
    varnames=evalin('base','who');
    loadname=eval(cat(2,'who(''-file'',''',sData,''')'));
    if any(strcmp(loadname{1},evalin('base','who')))
      assignin('base',new_var,evalin('base',loadname{1}));
      evalin('base',cat(2,'load(''',sData,''');'));
      new_var2=diff_varname;

      assignin('base',new_var2,evalin('base',loadname{1}));
      assignin('base',loadname{1},evalin('base',new_var));
      evalin('base',cat(2,'clear ',new_var));
      sData=evalin('base',new_var2);
      evalin('base',cat(2,'clear ',new_var2));
    else
      evalin('base',cat(2,'load(''',sData,''');'));
      sData=evalin('base',loadname{1});
      evalin('base',cat(2,'clear ',loadname{1}));
    end              
  else
    error('Argument ''ft'' must be a string ''pak'' or ''box''.');
  end
end
if ischar(init_type)
  if strcmp(init_type,'rand')
    if any(strcmp('SOM_PAKDIR',evalin('base','who')))
      init_command=cat(2,evalin('base','SOM_PAKDIR'),'randinit');
    else
      init_command='randinit';
    end
  elseif strcmp(init_type,'linear')
    if any(strcmp('SOM_PAKDIR',evalin('base','who')))
      init_command=cat(2,evalin('base','SOM_PAKDIR'),'lininit');
    else
      init_command='lininit';
    end
  else
    error('Argument ''init_type'' must be string ''rand'' or ''linear''.');
  end
else
  error('Argument ''init_type'' must be string ''rand'' or ''linear''.');
end

if (ischar(cout) && isempty(cout)) || (~ischar(cout) && isempty(cout))
  NO_FILE = 1;
  cout = '__abcdef';
elseif  ~ischar(cout) && ~isempty(cout)
  error('Argument ''cout'' must be a string or ''[]''.');
end
  
if ~is_positive_integer(xdim)
  error('Argument ''xdim'' must be a positive integer.');
end

if ~is_positive_integer(ydim)
  error('Argument ''ydim'' must be a positive integer.');
end

if ischar(topol)
  if isempty(topol) || (~strcmp(topol,'hexa') && ~strcmp(topol,'rect'))
    error ('Argument ''topol'' must be either a string ''hexa'' or ''rect''.');
  end
else
  error ('Argument ''topol'' must be either a string ''hexa'' or ''rect''.');  
end

if ischar(neigh)
  if isempty(neigh) || (~strcmp(neigh,'bubble') && ~strcmp(neigh,'gaussian'))
    error(sprintf(cat(2,'Argument ''neigh'' must be either a string ',...
                        '''bubble'' or ''gaussian''.')));
  end
else
  error(sprintf(cat(2,'Argument ''neigh'' must be either a string ',...
                       '''bubble'' or ''gaussian''.')));
end

som_write_data(sData, cout); 
str=cat(2,init_command,sprintf(' -din %s -cout %s ', cout ,cout),...
           sprintf('-topol %s ',topol),...
           sprintf('-neigh %s ',neigh),...
           sprintf('-xdim %d -ydim %d',xdim,ydim));

if isunix
  unix(str);
else
  dos(str);
end

sMap=som_read_cod(cout);

if ~NO_FILE
    if isunix
      unix(cat(2,'/bin/rm ',cout));
    else
      dos(cat(2,'del ',cout));
    end
    if strcmp(ct,'pak')
      som_write_cod(sMap,cout);
      disp(cat(2,'Output written to the file ',cout,'.'));
    elseif strcmp(ct,'box')
      eval(cat(2,'save ',cout,' sMap'));	
      disp(cat(2,'Output written to the file ',sprintf('''%s.mat''.',cout)));
    end
else
  sMap.name=cat(2,'SOM ',date);
  if isunix	
    unix('/bin/rm __abcdef');
  else
    dos('del __abcdef');
  end
end

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

function str = diff_varname()

array=evalin('base','who');

if isempty(array)
  str='a';
  return;
end

for i=1:length(array)
  lens(i)=length(array{i});
end


ind=max(lens);

str(1:ind+1)='a';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








