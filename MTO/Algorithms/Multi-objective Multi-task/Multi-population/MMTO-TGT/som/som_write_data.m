function som_write_data(sData, filename, missing)

%SOM_WRITE_DATA Writes data structs/matrices to a file in SOM_PAK format.
%
% som_write_data(data,filename,[missing])
%
%  som_write_data(sD,'system.data')
%  som_write_data(D,'system.data','*')
%
%  Input and output arguments ([]'s are optional): 
%   data        (struct) data struct to be written in the file
%               (matrix) data matrix
%   filename    (string) output filename
%   [missing]   (string) string used to denote missing components (NaNs); 
%                default is 'NaN'
%
% Note that much of the information in the data struct is lost.
% Typically, when saving data structs into files use the 'save' command.
%
% For more help, try 'type som_write_data' or check out online documentation.
% See also  SOM_READ_DATA, SOM_READ_COD, SOM_WRITE_COD.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_write_data
%
% PURPOSE
%
% Writes data structs/matrices to a file in SOM_PAK format.
%
% SYNTAX
%
%  som_write_data(sD,'filename')
%  som_write_data(D,'filename')
%  som_write_data(...,'missing')
%
% DESCRIPTION
%
% This function is offered for compatibility with SOM_PAK, a SOM software
% package in C. It writes data structs/matrices to a file in SOM_PAK format.
%
% See SOM_READ_DATA for a decription of the SOM_PAK data file format. Since
% the format does not support information on normalizations, that
% information is lost, as well as the data name. The component names are
% written on a comment line which begins with '#n' and label names on
% comment line which begins with '#l', respectively. Any spaces (' ') in the
% component names and in the label names are replaced with
% underscores ('_').
%
% This function is only offered for compatibility with SOM_PAK. In
% general, when saving data in files, use 'save filename.mat sData'. This is
% faster and retains all information of the data struct.
%
% The string to use for missing values (NaNs) in the written file can
% be given with the last argument. Notice that if you use SOM_PAK to
% read the files, you need to set the SOM_PAK environment variable
% LVQSOM_MASK_STR accordingly, e.g. to 'NaN' if you use the default
% replacement. For more information, see the SOM_PAK instructions.
%
% REQUIRED INPUT ARGUMENTS
%
%  data        (struct or matrix) data to be written
%  filename    (string) output filename
%
% OPTIONAL INPUT ARGUMENTS
%
%  missing     (string) string used to denote missing components (NaNs); 
%               default is 'NaN'
%
% EXAMPLES
%
% The basic usage is:
%  som_write_data(sData,'system.data')
%
% To write a data matrix to a file in plain SOM_PAK format, give a
% data matrix as the first argument: 
%  som_write_data(D,'system.data')
%
% By default, all NaNs in the data matrix are written as 'NaN':s. The
% third argument can be used to change this:
%  som_write_data(sData,'system.data','+')
%  som_write_data(sData,'system.data','missing')
%
% SEE ALSO
%
%  som_read_data    Reads data from an ascii file.
%  som_read_cod     Read a map from a file in SOM_PAK format.
%  som_write_cod    Writes data struct into a file in SOM_PAK format.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 131197
% Version 2.0beta ecco 030899 juuso 151199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(2, 3, nargin));  % check no. of input args is correct

% data
if isstruct(sData)
  is_struct = 1;
  D = sData.data;
else 
  is_struct = 0;
  D = sData; 
end
[samples dim] = size(D);

% missing
if nargin == 2, missing = 'NaN'; end

% open output file
fid = fopen(filename, 'w');
if fid < 0, error(['Cannot open file ' filename]); end

% check version
v = version;
ver_53_or_newer = (str2num(v(1:3)) >= 5.3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% write data

% write dimension

fprintf(fid, '%d\n', dim);

% write component names as a SOM_PAK comment line
if is_struct,
  fprintf(fid,'#n ');                     
  for i = 1:dim, fprintf(fid, '%s ', strrep(sData.comp_names{i},' ','_')); end
  fprintf(fid,'\n');                      
  if ~isempty(sData.label_names)
    fprintf(fid,'#l ');                     
    l = length(sData.label_names);
    for i = 1:l,  fprintf(fid, '%s ', strrep(sData.label_names{i},' ','_')); end
    fprintf(fid,'\n');                      
  end
end

% are there NaNs and/or labels?

has_nans = isnan(sum(D,2)) * (~strcmp(missing, 'NaN'));

has_labels = 0;
if is_struct
  [lines numlabs] = size(sData.labels);
  has_labels = zeros(lines, 1);
  if ver_53_or_newer
    has_labels = sum((~(cellfun('isempty', sData.labels))), 2);
  else
    for i = 1:lines
      for j = 1:numlabs
	if ~isempty(sData.labels{i,j}) 
	  has_labels(i) = 1; break; 
	end
      end
    end
  end
end

% write data

form = [repmat('%g ',[1 dim-1]) '%g\n'];

if ~sum(has_labels) && ~sum(has_nans)    % no NaNs, no labels
  fprintf(fid, form, D'); 
elseif ~sum(has_labels)                 % no labels, NaNs
  fprintf(fid, '%s', strrep(sprintf(form, D'), 'NaN', missing));
else                                    % labels and NaNs
  for i = 1:samples
    if has_nans(i)
      fprintf(fid, strrep(sprintf('%g ', D(i,:)), 'NaN', missing));
    else
      fprintf(fid, '%g ', D(i,:));
    end
    
    if has_labels(i)
      temp = '';
      if ver_53_or_newer
	nonempty = ~(cellfun('isempty', sData.labels(i,:)));
      else
	for j = 1:numlabs, nonempty(j) = ~isempty(sData.labels{i, j}); end
      end
      labs = char(sData.labels{i, nonempty});
      labs(:,end + 1) = ' ';
      temp = reshape(labs',[1 numel(labs)]);
      temp(findstr('  ', temp))='';
      fprintf(fid, '%s', temp(1:end-1));
    end
    fprintf(fid,'\n');
  end
end

% close file

if fclose(fid), 
  error(['Cannot close file ' filename]); 
else
  fprintf(2, 'data write ok\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






