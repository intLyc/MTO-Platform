function sMap=sompak_train(sMap,ft,cout,ct,din,dt,rlen,alpha,radius)

%SOMPAK_TRAIN Call SOM_PAK training program from Matlab.
%
% sMap=sompak_train(sMap,ft,cout,ct,din,dt,rlen,alpha,radius)
%
% ARGUMENTS ([]'s are optional and can be given as empty: [] or '')
%  sMap   (struct) map struct 
%         (string) filename
%  [ft]   (string) 'pak' or 'box'. Argument must be defined, if input file
%                  is used.
%  [cout] (string) filename for output SOM, if argument is not defined
%                  (i.e. argument is '[]') temporary file '__abcdef' is
%                  used in operations and *it_is_removed* after 
%                  operations!!!
%   [ct]  (string) 'pak' or 'box'. Argument must be defined, if output
%                  file is used.
%   din   (struct) data struct to be used in teaching
%         (matrix) data matrix
%         (string) filename
%                  If argument is not a filename or file is .mat -file, 
%                   temporary file '__din' is used in operations
%                   and *it_is_removed* after operations!!!
%  [dt]   (string) 'pak' or 'box'. Argument must be defined, if input file
%                  is used.
%  rlen   (scalar) running length of teaching
%  alpha  (float)  initial alpha value
%  radius (float)  initial radius of neighborhood
% 
% RETURNS
%  sMap   (struct) map struct
%
% Calls SOM_PAK training program (vsom) from Matlab. Notice that to
% use this function, the SOM_PAK programs must be in your search path,
% or the variable 'SOM_PAKDIR' which is a string containing the
% program path, must be defined in the workspace. SOM_PAK programs can
% be found from: http://www.cis.hut.fi/research/som_lvq_pak.shtml
%
% See also SOMPAK_TRAIN, SOMPAK_SAMMON, SOMPAK_TRAIN_GUI,
%          SOMPAK_GUI, SOM_SEQTRAIN.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100


nargchk(9,9,nargin);

NO_FILE=0;
DIN_FILE = 0;

if ~isstruct(sMap) && ~ischar(sMap)
  error('Argument ''sMap'' must be a struct or string.');
end

if ischar(sMap)
  if isempty(ft)
    error('Argument ''ft'' must be defined.');
  end
  if strcmp(ft,'pak')
    sMap=som_read_cod(sMap);
  elseif strcmp(ft,'box')
    new_var=diff_varname;
    varnames=evalin('base','who');
    loadname=eval(cat(2,'who(''-file'',''',sMap,''')'));
    if any(strcmp(loadname{1},evalin('base','who')))
      assignin('base',new_var,evalin('base',loadname{1}));
      evalin('base',cat(2,'load(''',sMap,''');'));
      new_var2=diff_varname;

      assignin('base',new_var2,evalin('base',loadname{1}));
      assignin('base',loadname{1},evalin('base',new_var));
      evalin('base',cat(2,'clear ',new_var));
      sMap=evalin('base',new_var2);
      evalin('base',cat(2,'clear ',new_var2));
    else
      evalin('base',cat(2,'load(''',sMap,''');'));
      sMap=evalin('base',loadname{1});
      evalin('base',cat(2,'clear ',loadname{1}));
    end

  end
end
if ~ischar(cout) && isempty(cout)
  cout = '__abcdef';
  NO_FILE = 1;
elseif ~ischar(cout) || (ischar(cout) && isempty(cout))
  error('Argument ''cout'' must be a string or ''[]''.');
end

if ~NO_FILE && (isempty(ct) || ~(~isempty(ct) && ...
   (strcmp(ct,'pak') || strcmp(ct,'box'))))
  error('Argument ''ct'' must be string ''pak'' or ''box''.');
end

map_name=sMap.name;
som_write_cod(sMap,cout);

if ~isempty(din)
  som_write_data(din, '__din');
  DIN_FILE = 1;
  din = '__din';
else
  DIN_FILE=0;
end

if ~DIN_FILE
  if isempty(dt) || ~ischar(dt) || ~(strcmp(dt,'box') || strcmp(dt,'pak'))
    error('Argument ''dt'' must be string ''pak'' or ''box''.');
  end
  if strcmp(dt,'box');
    DIN_FILE = 1;
    din_var=diff_varname;
    varnames=evalin('base','who');
    loadname=eval(cat(2,'who(''-file'',''',din,''')'));
    if any(strcmp(loadname{1},evalin('base','who')))
      assignin('base',din_var,evalin('base',loadname{1}));
      evalin('base',cat(2,'load(''',din,''');'));
      din_var2=diff_varname;

      assignin('base',new_var2,evalin('base',loadname{1}));
      assignin('base',loadname{1},evalin('base',din_var));
      evalin('base',cat(2,'clear ',din_var));
      din=evalin('base',din_var2);
    else
      evalin('base',cat(2,'load(''',din,''')'));
      din=evalin('base',loadname{1});
      evalin('base',cat(2,'clear ',loadname{1}));
    end
    som_write_data(din,'__din');
    din = '__din';
  end
end
if ~is_positive_integer(rlen)
  error('Argument ''rlen'' must be positive integer.');
end

if ~(isreal(alpha) && all(size(alpha)==1))
  error('Argument ''alpha'' must be a floating point number.');
end

if ~(isreal(radius) && all(size(radius)==1) && radius > 0)
  error('Argument ''radius'' must be a positive floating point number.');
end

if any(strcmp('SOM_PAKDIR',evalin('base','who')))
  traincommand=cat(2,evalin('base','SOM_PAKDIR'),'vsom ');
else
  traincommand='vsom ';
end

str=cat(2,traincommand,sprintf('-cin %s -din %s -cout %s ',cout,din,cout),...
                  sprintf(' -rlen %d -alpha %f -radius %f',rlen,alpha,radius));
if isunix
  unix(str);
else
  dos(str);
end

sMap=som_read_cod(cout);
sMap.name=map_name;

if ~NO_FILE
  if isunix
    unix(cat(2,'/bin/rm ',cout));
  else
    dos(cat(2,'del ',cout));
  end
  if isempty(ct) || ~ischar(ct) || ~(strcmp(ct,'pak') || strcmp(ct,'box'))
    error('Argument ''ct'' must be string ''pak'' or ''box''.');
  elseif strcmp(ct,'box');
    eval(cat(2,'save ',cout,' sMap'));
    disp(cat(2,'Output written to the file ',sprintf('''%s.mat''.',cout)));
  else
    som_write_cod(sMap,cout);
  end
else
  if isunix
    unix('/bin/rm __abcdef');
  else
    dos('del __abcdef');
  end
end 

if DIN_FILE
  if isunix
    unix('/bin/rm __din');
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












