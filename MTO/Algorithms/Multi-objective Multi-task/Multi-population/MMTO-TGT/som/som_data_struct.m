function sData = som_data_struct(D, varargin)

%SOM_DATA_STRUCT Create a data struct.
%
% sData = som_data_struct(D, [argID, value, ...])
%
%  sData  = som_data_struct(D); 
%  sData  = som_data_struct(D,'name','my_data','labels',labs);
%
%  Input and output arguments ([]'s are optional): 
%   D        (matrix) data matrix, size dlen x dim
%   [argID,  (string) See below. These are given as argID, value pairs.
%    value]  (varies) 
%
%   sData    (struct) created data struct
%
%  Here are the argument IDs and corresponding values: 
%   'labels'     (string array / cellstr) labels for each data vector,
%                 length=dlen
%   'name'       (string) data name
%   'comp_names' (string array / cellstr) component names, size dim x 1
%   'comp_norm'  (cell array) normalization operations for each
%                 component, size dim x 1. Each cell is either empty, 
%                 or a cell array of normalization structs.
%
% For more help, try 'type som_data_struct' or check out online documentation.
% See also SOM_SET, SOM_INFO, SOM_MAP_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_data_struct   
%
% PURPOSE
%
% Creates a data structure. 
%
% SYNTAX
%
%  sD = som_data_struct(D);
%  sD = som_data_struct(...,'argID',value,...);
%
% DESCRIPTION
%
% Creates a data struct. The struct contains, in addition to the data
% matrix, component names, normalization operations for the components,
% labels for each vector, and a name for the whole data set. All of these
% can be given in the optional arguments of the function. If left
% unspecified, they are given default values. 
%
%  Field         Type         Size / default value    
%  ------------------------------------------------------------------------
%   .type        (string)     'som_data'               
%   .data        (matrix)     size dlen x dim             
%   .name        (string)     'unnamed'
%   .labels      (cellstr)    size dlen x m, {''; ''; ... ''}
%   .comp_names  (cellstr)    size dim x 1, {'Variable1', 'Variable2', ...}
%   .comp_norm   (cell array) size dim x 1, {[], [], ... []}
%   .label_names (cellstr)    size m x 1, []
%                          
% '.type' field is the struct identifier. Do not change it.
% '.data' field is the data matrix, each row is one data vector
% '.name' field is the identifier for the whole data struct
% '.labels' field contains the labels for each of the vectors. The ith
%         of '.labels' contains the labels for ith data vector. Note that 
%         if some vectors have more labels than others, the others are
%         are given empty labels ('') to pad the '.labels' array up.
% '.comp_names' field contains the names of the vector components
% '.comp_norm' field contains normalization information for each
%         component. Each cell of '.comp_norm' is itself a cell array of
%         normalization structs. If no normalizations are performed for 
%         the particular component, the cell is empty ([]).
% '.label_names' is similar to .comp_names field holding the names for
%         each data label column
%
% REQUIRED INPUT ARGUMENTS
%
%  D  (matrix) The data matrix, size dlen x dim. The data matrix may 
%              contain unknown values, indicated by NaNs. 
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs as
%  listed below. If an argument is given value multiple times, the
%  last one is used.
%
%   'labels'     (string array / cellstr) labels for each data vector,
%                 size dlen x m
%   'name'       (string) data name
%   'comp_names' (string array / cellstr) component names, size dim x 1
%   'comp_norm'  (cell array) normalization operations for each
%                 component, size dim x 1. Each cell is either empty, 
%                 or a cell array of normalization structs.
%   'label_names'(string array / cellstr) label names, size m x 1
%
% OUTPUT ARGUMENTS
% 
%  sD (struct) the data struct
%
% EXAMPLES
%
% Simplest case:
%  D  = rand(8, 3); % 8 3-dimensional vectors
%  sD = som_data_struct(D);
%  
% With optional arguments, the other fields can be given values:
%  labs   = cell(8, 1); labs{1, 1} = 'first_label';
%  cnames = {'first'; 'second'; 'third'};
%  
%  sD = som_data_struct(D,'labels',labs,'name','a data struct');
%  sD = som_data_struct(D,'comp_names',cnames);
%
% SEE ALSO
% 
%  som_set          Set values and create SOM Toolbox structs.
%  som_map_struct   Create a map struct.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 071197
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% data
[dlen dim] = size(D);

% default values
if ~isempty(inputname(1)), name = inputname(1); 
else name = 'unnamed'; end
labels = cell(dlen,1);
labels(1:dlen) = {''};
%for i=1:dlen, labels{i} = ''; end
comp_names = cell(dim,1);
for i = 1:dim, comp_names{i} = sprintf('Variable%d', i); end
comp_norm = cell(dim,1);
label_names = []; 

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
      % argument IDs
     case 'comp_names', i=i+1; comp_names = varargin{i}; 
     case 'labels',     i=i+1; labels = varargin{i};
     case 'name',       i=i+1; name = varargin{i};
     case 'comp_norm',  i=i+1; comp_norm = varargin{i};
     case 'label_names',i=i+1; label_names = varargin{i};
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_data_struct) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end

% create struct
sData = som_set('som_data','data',D,'labels',labels,...
                          'name',name,'comp_names',comp_names,...
                          'comp_norm',comp_norm,'label_names',label_names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



