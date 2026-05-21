function sMap = som_read_cod(filename)

%SOM_READ_COD Reads a SOM_PAK format codebook file.
%
% sMap = som_read_cod(filename);
%
%  sMap = som_read_cod('map1.cod');
%
%  Input and output arguments: 
%   filename    (string) name of input file
%   sMap        (struct) self-organizing map structure
%
% The file must be in SOM_PAK format. Empty lines and lines starting 
% with a '#' are ignored, except the ones starting with '#n'. The strings 
% after '#n' are read to field 'comp_names' of the map structure.
%
% For more help, try 'type som_read_cod' or check out online documentation.
% See also SOM_WRITE_COD, SOM_READ_DATA, SOM_WRITE_DATA, SOM_MAP_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_read_cod
%
% PURPOSE
%
% Reads a Self-Organizing Map from an ascii file in SOM_PAK format.
%
% SYNTAX
%
%  sMap = som_read_cod(filename); 
%
% DESCRIPTION
%
% This function is offered for compatibility with SOM_PAK, a SOM 
% software package in C. It reads map files written in SOM_PAK format.
%
% The SOM_PAK map file format is as follows. The first line must contain
% the input space dimension, lattice type ('rect' or 'hexa'), map grid
% size in x-direction, map grid size in y-direction, and neighborhood
% function ('bubble' or 'gaussian'), in that order. The following lines
% are comment lines, empty lines or data lines. 
%
% Each data line contains the weight vector of one map unit and its
% labels. From the beginning of the line, first are values of the vector
% components separated by whitespaces, then labels, again separated by
% whitespaces. The order of map units in the file are one row at a time
% from right to left, from the top to the bottom of the map (x-direction
% first, then y-direction). 
% 
% Comment lines start with '#'. Comment lines as well as empty lines are
% ignored, except if the comment line starts with '#n'. In that case the
% line should contain names of the vector components separated by
% whitespaces.
%
% In the returned map struct, several fields has to be set to default
% values, since the SOM_PAK file does not contain information on
% them. These include map shape ('sheet'), mask ([1 ... 1]),
% normalizations (none), trainhist (two entries, first with algorithm
% 'init' and the second with 'seq', both with data name 'unknown'),
% possibly also component names ('Var1',...). 
%
% REQUIRED INPUT PARAMETERS
%
%  filename   (string) the name of the input file
%
% OUTPUT ARGUMENTS
%
%  sMap       (struct) the resulting SOM struct
% 
% EXAMPLES
%
%  sMap = som_read_cod('map1.cod');
%
% SEE ALSO
% 
%  som_write_cod    Writes a map struct into a file in SOM_PAK format.
%  som_read_data    Reads data from an ascii file.
%  som_write_data   Writes data struct into a file in SOM_PAK format.
%  som_map_struct   Creates map structs.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 221097
% Version 2.0beta juuso 151199 250400

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 1, nargin))  % check no. of input args is correct

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize variables

lnum           = 0;    % codebook vector counter
comment_start  = '#';  % the char a SOM_PAK command line starts with
comp_name_line = '#n'; % string used to start a special command line,
                       % which contains names of each component

% open input file

fid = fopen(filename);
if fid < 0, error(['Cannot open ' filename]); end
 
% read header line

ok_cnt = 0;
lin = fgetl(fid); li = lin;
[dim c err n]  = sscanf(li, '%d%[^ \t]'); ok_cnt=ok_cnt+c; li = li(n:end);
[lattice c err n] = sscanf(li,'%s%[^ \t]'); ok_cnt=ok_cnt+c; li = li(n:end);
[msize(2) c err n] = sscanf(li, '%d%[^ \t]'); ok_cnt=ok_cnt+c; li = li(n:end);
[msize(1) c err n] = sscanf(li, '%d%[^ \t]'); ok_cnt=ok_cnt+c; li = li(n:end);
[neigh c err n] = sscanf(li, '%s%[^ \t\n]'); ok_cnt=ok_cnt+c;

if ok_cnt ~= 5
  error([ 'Invalid header line: ' lin ]); 
end                                 

% create map struct and set its fields according to header line

munits = prod(msize);
sMap   = som_map_struct(dim, 'msize', msize, ...
			lattice, 'sheet', 'neigh', neigh);
[sT0, ok] = som_set('som_train','algorithm','init','data_name','unknown');
sT1       = som_set('som_train','algorithm','seq','data_name','unknown',...
                    'neigh',neigh,'mask',ones(dim,1));
[sMap, ok, msgs] = som_set(sMap,'name',filename,'trainhist',{sT0,sT1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read codebook from the file

codebook   = zeros(munits,dim);
labels     = cell(munits,1);
comp_names = sMap.comp_names;
form       = [repmat('%f',[1 dim-1]) '%f%[^ \t]'];

while 1, 
  li = fgetl(fid);                         % read next line
  if ~ischar(li), break, end;               % is this the end of file?

  [data, c, err, n] = sscanf(li, form);
  if c < dim % if there were less numbers than dim on the input file line
    if c == 0
      if strncmp(li, comp_name_line, 2) % component name line?
        li = li(3:end); i = 0; c = 1;
        while c
          [s, c, e, n] = sscanf(li, '%s%[^ \t]');
          if ~isempty(s), i = i + 1; comp_names{i} = s; li = li(n:end); end
        end

        if i ~= dim
          error(['Illegal number of component names: ' num2str(i) ...
                 ' (dimension is ' num2str(dim) ')']);
        end
      elseif ~strncmp(li, comment_start, 1) % not a comment, is it error?
        [s, c, e, n] = sscanf(li, '%s%[^ \t]');
        if c
          error(['Invalid vector on input file line ' ...
                 num2str(lnum+1) ': [' deblank(li) ']']),
        end
      end
    else
      error(['Only ' num2str(c) ' vector components on input file line ' ...
             num2str(lnum+1) ' (dimension is ' num2str(dim) ')']);
    end

  else

    lnum = lnum + 1;                % this was a line containing data vector
    codebook(lnum, 1:dim) = data'; % add data to struct

    % read labels

    if n < length(li)
      li = li(n:end);
      i = 0; n = 1; c = 1;
      while c
        [s, c, e, n_new] = sscanf(li(n:end), '%s%[^ \t]');
        if c, i = i + 1; labels{lnum, i} = s; n = n + n_new - 1; end
      end
    end
  end
end

% close the input file

if fclose(fid) < 0
  error(['Cannot close file ' filename]); 
else
  fprintf(2, '\rmap read ok         \n');
end

% check that the number of lines read was correct

if lnum ~= munits
  error(['Illegal number of map units: ' num2str(lnum) ' (should be ' num2str(munits) ').']);
end

% set values

% in SOM_PAK the xy-indexing is used, while in Matlab ij-indexing
% therefore, the codebook vectors have to be reorganized 

order = reshape([1:munits],msize);
order = reshape(order',[munits 1]);
codebook(order,:) = codebook;
labels(order,:) = labels; 

sMap.codebook   = codebook;
sMap.labels     = labels;
sMap.comp_names = comp_names;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
