function sMap=sompak_sammon(sMap,ft,cout,ct,rlen)

%SOMPAK_SAMMON Call SOM_PAK Sammon's mapping program from Matlab.
%
%  P = sompak_sammon(sMap,ft,cout,ct,rlen)
%
% ARGUMENTS ([]'s are optional and can be given as empty: [] or '')
%  sMap   (struct) map struct
%         (string) filename
%  [ft]   (string) 'pak' or 'box'. Argument must be defined, if
%                  input file is used.
%  [cout] (string) output file name. If argument is not defined 
%                  (i.e argument is '[]') temporary file '__abcdef' is
%                  used in operations and *it_is_removed* after 
%                  operations!!!
%  [ct]   (string) 'pak' or 'box'. Argument must be defined, if
%                  output file is used.
%  rlen   (scalar) running length
%
% RETURNS: 
%  P      (matrix) the mapping coordinates
%
% Calls SOM_PAK Sammon's mapping program (sammon) from Matlab. Notice
% that to use this function, the SOM_PAK programs must be in your
% search path, or the variable 'SOM_PAKDIR' which is a string
% containing the program path, must be defined in the workspace.
% SOM_PAK programs can be found from:
% http://www.cis.hut.fi/research/som_lvq_pak.shtml
%
% See also SOMPAK_INIT, SOMPAK_SAMMON, SOMPAK_SAMMON_GUI,
%          SOMPAK_GUI, SAMMON.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100

NO_FILE = 0;

nargchk(5,5,nargin);

if ~(isstruct(sMap) || ischar(sMap))
  error('Argument ''sMap'' must be a struct or filename.');
end

if ischar(sMap)
 if isempty(ft) || ~ischar(ft) || ~(strcmp(ft,'pak') || strcmp(ft,'box'))
   error('Argument ''ft'' must be string ''pak'' or ''box''.');
 end
 if strcmp(ft,'pak')
   sMap=som_read_cod(sMap);
 else
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
  NO_FILE = 1;
  cout = '__abcdef';
elseif ~ischar(cout) || isempty(cout)
  error('Argument ''cout'' must be a string or ''[]''.');
end

if ~NO_FILE && (isempty(ct) || ~(strcmp(ct,'pak') || strcmp(ct,'box')))
  error('Argument ''ct'' must be string ''pak'' or ''box''.');
end

som_write_cod(sMap,cout);

if ~is_positive_integer(rlen)
  error('Argument ''rlen'' must be a positive integer.');
end

if any(strcmp('SOM_PAKDIR',evalin('base','who')))
  command=cat(2,evalin('base','SOM_PAKDIR'),'sammon ');
else
  command='sammon ';
end

str = sprintf('%s -cin %s -cout %s -rlen %d',command,cout,cout,rlen);

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
  if strcmp(ct,'box');
    sMap=sMap.codebook;
    eval(cat(2,'save ',cout,' sMap'));
    disp(cat(2,'Output is saved to the file ',sprintf('''%s.mat''.',cout)));
  else
    som_write_cod(sMap,cout);
    sMap=sMap.codebook;
    disp(cat(2,'Output is saved to the file ',cout,'.'));
  end
else
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







