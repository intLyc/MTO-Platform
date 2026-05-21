function som_write_cod(sMap, filename)

%SOM_WRITE_COD Writes a map struct to ascii file in SOM_PAK format.
%
% som_write_cod(sMap,filename)
%
%  som_write_cod(sMap,'map1.cod');
%
%  Input and output arguments: 
%   sMap        (struct) self-organizing map structure
%   filename    (string) name of input file
%
% Note that much of the information in the map struct is lost.
% Typically, when saving map structs into files use the 'save' command.
%
% For more help, try 'type som_write_cod' or check out online documentation.
% See also SOM_READ_COD, SOM_READ_DATA, SOM_WRITE_DATA.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_write_cod
%
% PURPOSE
%
% Writes a self-organizing map struct to a file in SOM_PAK format.
%
% SYNTAX
%
%  som_write_cod(sMap,filename); 
%
% DESCRIPTION
%
% This function is offered for compatibility with SOM_PAK, a SOM 
% software package in C. It writes map struct to files in SOM_PAK format.
%
% See SOM_READ_COD for description of the SOM_PAK map file format.
% Because the SOM_PAK package does not support many of the features and
% options of the SOM Toolbox, some of the information is changed, or even
% lost. 
%
% SOM_PAK does not support 3- or higher dimensional map grids. These cannot
%         be exported using this function.  
% SOM_PAK always supposes that the map has 'sheet' shape. 
% SOM_PAK only supports 'bubble' and 'gaussian' neighborhood functions.
%         Any other neighborhood function is changed to 'gaussian'.
% SOM_PAK doesn't support component names. However, the component names are
%         written on a comment line which begins with '#n '. Any spaces (' ') 
%         in the component names are replaced with underscores ('_').      
% Information on map name, mask, training history and normalizations is lost.
%
% This function is only offered for compatibility with SOM_PAK. In general,
% when saving map structs in files, use 'save filename.mat sMap'. This is
% faster and retains all information of the map.
% 
% REQUIRED INPUT ARGUMENTS
%
%  sMap       (struct) the SOM struct to be written
%  filename   (string) the name of the input file
%
% EXAMPLES
%
%  som_write_cod(sMap,'map1.cod');
%
% SEE ALSO
% 
%  som_read_cod     Read a map from a file in SOM_PAK format.
%  som_read_data    Reads data from an ascii file.
%  som_write_data   Writes data struct into a file in SOM_PAK format.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 221097
% Version 2.0beta ecco 030899, juuso 151199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments and initialize

error(nargchk(2, 2, nargin))  % check no. of input args is correct

% sMap
msize = sMap.topol.msize;           % map grid size
mdim  = length(msize);              % map grid dimension
[munits dim] = size(sMap.codebook); % input space dimension

% map dimension check:
% map dimensions higher than 2 are not supported by SOM_PAK
if mdim > 2,      
  error('Cannot write maps with higher dimension than two');
end

% in SOM_PAK the xy-indexing is used, while in Matlab ij-indexing
% therefore, the codebook vectors have to be reorganized 
order = reshape([1:munits],msize);
order = reshape(order',[munits 1]);
msize = fliplr(msize);

% open output file
fid = fopen(filename, 'w');
if fid < 0,
  error(['Cannot open file ' filename]);
end

% check version
v = version;
ver_53_or_newer = (str2num(v(1:3)) >= 5.3);


[lines numlabs] = size(sMap.labels);
has_labels = zeros(lines, 1);
if ver_53_or_newer
  has_labels = sum((~(cellfun('isempty', sMap.labels))), 2);
else
  for i = 1:lines
    for j = 1:numlabs
      if ~isempty(sMap.labels{i,j}) 
	has_labels(i) = 1; break; 
      end
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% write map into a file

% write header

fprintf(fid, '%d %s ', dim, sMap.topol.lattice); % dimension and lattice
fprintf(fid, '%d ', msize);                      % map size
% neighborhood type ('ep' and 'cutgauss' are not supported by SOM_PAK; 
% they are converted to 'gaussian')
if strcmp(sMap.neigh,'bubble'), fprintf(fid, 'bubble\n');
else 
  if ~strcmp(sMap.neigh,'gaussian'), 
    warning(['Neighborhood type ''' sMap.neigh ''' converted to ''gaussian''']);
  end
  fprintf(fid,'gaussian\n'); 
end

% write the component names as a SOM_PAK comment line

fprintf(fid,'#n ');
for i=1:dim, fprintf(fid, '%s ', strrep(sMap.comp_names{i},' ','_')); end
fprintf(fid,'\n');

% write codebook

form  = [repmat('%g ',[1 dim]) '\n'];
if ~has_labels  % no labels; fast
  fprintf(fid, form, sMap.codebook(order,:)');
else            % has labels; slow
  for i=1:munits, 
    fprintf(fid, '%g ', sMap.codebook(order(i),:));

    if has_labels(order(i))
      temp = '';
      if ver_53_or_newer
	nonempty = ~(cellfun('isempty', sMap.labels(i,:)));
      else
	for j = 1:numlabs, nonempty(j) = ~isempty(sMap.labels{i, j}); end
      end
      labs = char(sMap.labels{order(i), nonempty});
      labs(:,end + 1) = ' ';
      temp = reshape(labs',[1 numel(labs)]);
      temp(findstr('  ', temp))='';
      fprintf(fid, '%s\n', temp(1:end-1));
    else
      fprintf(fid, '\n');
    end
  end
end

% close file

if fclose(fid) 
  error(['Cannot close file ' filename]);
else
  fprintf(2, 'map write ok\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






