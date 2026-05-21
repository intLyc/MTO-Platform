function sData = som_read_data(filename, varargin)

%SOM_READ_DATA Read data from an ascii file in SOM_PAK format.
%
% sD = som_read_data(filename, dim, [missing])
% sD = som_read_data(filename, [missing])
%
%  sD = som_read_data('system.data');
%  sD = som_read_data('system.data',10);
%  sD = som_read_data('system.data','*');
%  sD = som_read_data('system.data',10,'*');
%
%  Input and output arguments ([]'s are optional): 
%   filename    (string) input file name
%   dim         (scalar) input space dimension
%   [missing]   (string) string which indicates a missing component
%                        value, 'NaN' by default
%
%   sD          (struct) data struct
%
% Reads data from an ascii file. The file must be in SOM_PAK format, 
% except that it may lack the input space dimension from the first
% line. 
%
% For more help, try 'type som_read_data' or check out online documentation.
% See also  SOM_WRITE_DATA, SOM_READ_COD, SOM_WRITE_COD, SOM_DATA_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_read_data
%
% PURPOSE
%
% Reads data from an ascii file in SOM_PAK format.
%
% SYNTAX
%
%  sD = som_read_data(filename)
%  sD = som_read_data(..., dim)
%  sD = som_read_data(..., 'missing')
%  sD = som_read_data(..., dim, 'missing')
%
% DESCRIPTION
%
% This function is offered for compatibility with SOM_PAK, a SOM software
% package in C. It reads data from a file in SOM_PAK format.
%
% The SOM_PAK data file format is as follows. The first line must
% contain the input space dimension and nothing else. The following
% lines are comment lines, empty lines or data lines. Unlike programs
% in SOM_PAK, this function can also determine the input dimension
% from the first data lines, if the input space dimension line is
% missing.  Note that the SOM_PAK format is not fully supported: data
% vector 'weight' and 'fixed' properties are ignored (they are treated
% as labels).
%
% Each data line contains one data vector and its labels. From the beginning
% of the line, first are values of the vector components separated by
% whitespaces, then labels also separated by whitespaces. If there are
% missing values in the vector, the missing value marker needs to be
% specified as the last input argument ('NaN' by default). The missing
% values are stored as NaNs in the data struct. 
% 
% Comment lines start with '#'. Comment lines as well as empty lines are
% ignored, except if the comment lines that start with '#n' or '#l'. In that
% case the line should contain names of the vector components or label names
% separated by whitespaces.
%
% NOTE: The minimum value Matlab is able to deal with (realmax)
% should not appear in the input file. This is because function sscanf is
% not able to read NaNs: the NaNs are in the read phase converted to value
% realmax.
%
% REQUIRED INPUT ARGUMENTS
%
%  filename    (string) input filename
%
% OPTIONAL INPUT ARGUMENTS
%
%  dim         (scalar) input space dimension
%  missing     (string) string used to denote missing components (NaNs); 
%                       default is 'NaN'
%
% OUTPUT ARGUMENTS
%
%  sD   (struct) the resulting data struct
%
% EXAMPLES
%
% The basic usage is:
%  sD = som_read_data('system.data');
%
% If you know the input space dimension beforehand, and the file does
% not contain it on the first line, it helps if you specify it as the
% second argument: 
%  sD = som_read_data('system.data',9);
%
% If the missing components in the data are marked with some other
% characters than with 'NaN', you can specify it with the last argument: 
%  sD = som_read_data('system.data',9,'*')
%  sD = som_read_data('system.data','NaN')
%
% Here's an example data file:
%
% 5
% #n one two three four five
% #l ID
% 10 2 3 4 5 1stline label
% 0.4 0.3 0.2 0.5 0.1 2ndline label1 label2
% # comment line: missing components are indicated by 'x':s
% 1 x 1 x 1 3rdline missing_components
% x 1 2 2 2 
% x x x x x 5thline emptyline
%
% SEE ALSO
%
%  som_write_data   Writes data structs/matrices to a file in SOM_PAK format.
%  som_read_cod     Read a map from a file in SOM_PAK format.
%  som_write_cod    Writes data struct into a file in SOM_PAK format.
%  som_data_struct  Creates data structs.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 221097
% Version 2.0beta ecco 060899, juuso 151199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 3, nargin))  % check no. of input args is correct

dont_care       = 'NaN';  % default don't care string
comment_start   = '#';    % the char a SOM_PAK command line starts with
comp_name_line  = '#n';   % string denoting a special command line,
                          % which contains names of each component
label_name_line = '#l';   % string denoting a special command line,
                          % which contains names of each label
block_size      = 1000;   % block size used in file read

kludge          = num2str(realmax, 100); % used in sscanf                
  

% open input file

fid = fopen(filename);
if fid < 0
  error(['Cannot open ' filename]); 
end

% process input arguments

if nargin == 2 
  if ischar(varargin{1})
    dont_care = varargin{1};
  else
    dim      = varargin{1};
  end
elseif nargin == 3
  dim       = varargin{1};
  dont_care = varargin{2};
end

% if the data dimension is not specified, find out what it is

if nargin == 1 || (nargin == 2 && ischar(varargin{1}))

  fpos1 = ftell(fid); c1 = 0;      % read first non-comment line
  while c1 == 0,
    line1 = strrep(fgetl(fid), dont_care, kludge);
    [l1, c1] = sscanf(line1, '%f ');
  end

  fpos2 = ftell(fid); c2 = 0;      % read second non-comment line
  while c2 == 0,
    line2 = strrep(fgetl(fid), dont_care, kludge);
    [l2, c2] = sscanf(line2, '%f ');
  end

  if (c1 == 1 && c2 ~= 1) || (c1 == c2 && c1 == 1 && l1 == 1)
    dim = l1;
    fseek(fid, fpos2, -1);
  elseif (c1 == c2)
    dim = c1;
    fseek(fid, fpos1, -1);
    warning on
    warning(['Automatically determined data dimension is ' ...
	     num2str(dim) '. Is it correct?']); 
  else
    error(['Invalid header line: ' line1]);
  end
end 

% check the dimension is valid

if dim < 1 || dim ~= round(dim) 
  error(['Illegal data dimension: ' num2str(dim)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read data

sData       = som_data_struct(zeros(1, dim), 'name', filename); 
lnum        = 0;                                    % data vector counter
data_temp   = zeros(block_size, dim);
labs_temp   = cell(block_size, 1);
comp_names  = sData.comp_names;
label_names = sData.label_names;
form        = [repmat('%g',[1 dim-1]) '%g%[^ \t]'];

limit       = block_size;
while 1,
  li = fgetl(fid);                         % read next line
  if ~ischar(li), break, end;               % is this the end of file? 

  % all missing vectors are replaced by value realmax because
  % sscanf is not able to read NaNs  
  li = strrep(li, dont_care, kludge);     
  [data, c, err, n] = sscanf(li, form);
  if c < dim % if there were less numbers than dim on the input file line
    if c == 0
      if strncmp(li, comp_name_line, 2) % component name line?
	li = strrep(li(3:end), kludge, dont_care); i = 0; c = 1;
	while c
	  [s, c, e, n] = sscanf(li, '%s%[^ \t]');
	  if ~isempty(s), i = i + 1; comp_names{i} = s; li = li(n:end); end
	end

	if i ~= dim 
	  error(['Illegal number of component names: ' num2str(i) ...
		 ' (dimension is ' num2str(dim) ')']); 
	end
      elseif strncmp(li, label_name_line, 2) % label name line?
	li = strrep(li(3:end), kludge, dont_care); i = 0; c = 1;
	while c
	  [s, c, e, n] = sscanf(li, '%s%[^ \t]');
	  if ~isempty(s), i = i + 1; label_names{i} = s; li = li(n:end); end
	end
      elseif ~strncmp(li, comment_start, 1) % not a comment, is it error?
	[s, c, e, n] = sscanf(li, '%s%[^ \t]');
	if c
	  error(['Invalid vector on input file data line ' ...
		 num2str(lnum+1) ': [' deblank(li) ']']),
	end
      end
    else
      error(['Only ' num2str(c) ' vector components on input file data line ' ...
	     num2str(lnum+1) ' (dimension is ' num2str(dim) ')']);
    end

  else

    lnum = lnum + 1;                % this was a line containing data vector
    data_temp(lnum, 1:dim) = data'; % add data to struct

    if lnum == limit       % reserve more memory if necessary
      data_temp(lnum+1:lnum+block_size, 1:dim) = zeros(block_size, dim);
      [dummy nl] = size(labs_temp);
      labs_temp(lnum+1:lnum+block_size,1:nl) = cell(block_size, nl);
      limit = limit + block_size;
    end
    
    % read labels
    
    if n < length(li)
      li = strrep(li(n:end), kludge, dont_care); i = 0; n = 1; c = 1;
      while c
	[s, c, e, n_new] = sscanf(li(n:end), '%s%[^ \t]');
	if c, i = i + 1; labs_temp{lnum, i} = s; n = n + n_new - 1; end
      end
    end
  end
end

% close input file
if fclose(fid) < 0, error(['Cannot close file ' filename]);
else fprintf(2, '\rdata read ok         \n'); end

% set values
data_temp(data_temp == realmax) = NaN;
sData.data        = data_temp(1:lnum,:);
sData.labels      = labs_temp(1:lnum,:);
sData.comp_names  = comp_names;
sData.label_names = label_names;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%