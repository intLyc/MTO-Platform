function sMap = som_map_struct(dim, varargin)

%SOM_MAP_STRUCT Create map struct. 
% 
% sMap = som_map_struct(dim, [[argID,] value, ...])
%
%  sMap = som_map_struct(4);
%  sMap = som_map_struct(4,'msize',[3 4],'hexa','sheet');
%  sMap = som_map_struct(4,'msize',[3 4 5],'rect','name','a 3D-SOM');
%  sMap = som_map_struct(4,'msize',[3 4],'bubble','mask',[1 1 1 0]);
%
%  Input and output arguments ([]'s are optional): 
%   dim      (scalar) input space dimension
%   [argID,  (string) See below. The values which are unambiguous can 
%    value]  (varies) be given without the preceeding argID.
%
%   sMap     (struct) self-organizing map struct
%
% Here are the valid argument IDs and corresponding values. The values
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%   'mask'       (vector) BMU search mask, size dim x 1
%   'msize'      (vector) map grid size, default is [0]
%   'labels'     (string array / cellstr) labels for each map unit, 
%                 length=prod(msize)
%   'name'       (string) map name
%   'comp_names' (string array / cellstr) component names, size dim x 1
%   'comp_norm'  (cell array) normalization operations for each
%                 component, size dim x 1. Each cell is either empty, 
%                 or a cell array of normalization structs.
%   'topol'     *(struct) topology struct
%   'som_topol','sTopol' = 'topol'
%   'lattice'   *(string) map lattice, 'hexa' or 'rect'
%   'shape'     *(string) map shape, 'sheet', 'cyl' or 'toroid'
%   'neigh'     *(string) neighborhood function, 'gaussian', 'cutgauss',
%                 'ep' or 'bubble'
%
% For more help, try 'type som_map_struct' or check out online documentation.
% See also SOM_SET, SOM_INFO, SOM_DATA_STRUCT, SOM_TOPOL_STRUCT, SOM_MAKE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_map_struct
%
% PURPOSE
%
% Creates a self-organizing map structure. 
%
% SYNTAX
%
%  sM = som_map_struct(dim)
%  sM = som_map_struct(...,'argID',value,...);
%  sM = som_map_struct(...,value,...);
%
% DESCRIPTION
%
% Creates a self-organizing map struct. The struct contains the map
% codebook, labels, topology, information on normalization and training, 
% as well as component names and a name for the map. The obligatory
% parameter is the map dimension. Most of the other fields can be
% given values using optional arguments. If they are left unspecified,
% default values are used.
%
%  Field         Type         Size / default value (munits = prod(msize))
%  ------------------------------------------------------------------------
%   .type        (string)     'som_map'               
%   .name        (string)     'SOM date'
%   .codebook    (matrix)     rand(munits, dim)
%   .topol       (struct)     topology struct, with the following fields
%     .type         (string)  'som_topol'
%     .msize        (vector)  size k x 1, [0] 
%     .lattice      (string)  'hexa' 
%     .shape        (string)  'sheet'
%   .labels      (cellstr)    size munits x m, {''; ''; ... ''}
%   .neigh       (string)     'gaussian'
%   .mask        (vector)     size dim x 1, [1; 1; ...; 1]
%   .trainhist   (cell array) size tl x 1, []
%   .comp_names  (cellstr)    size dim x 1, {'Variable1', 'Variable2', ...}
%   .comp_norm   (cell array) size dim x 1, {[], [], ... []}
%
% '.type' field is the struct identifier. Do not change it.
% '.name' field is the identifier for the whole map struct
% '.codebook' field is the codebook matrix, each row corresponds to one unit
% '.topol' field is the topology of the map. This struct has three fields:
%   '.msize' field is the dimensions of the map grid. Note that the
%         matrix notation of indeces is used.
%   '.lattice' field is the map grid lattice
%   '.shape' field is the map grid shape
% '.labels' field contains the labels for each of the vectors. The ith row
%         of '.labels' contains the labels for ith map unit. Note that 
%         if some vectors have more labels than others, the others are
%         are given empty labels ('') to pad the '.labels' array up.
% '.neigh' field is the neighborhood function. 
% '.mask' field is the BMU search mask.
% '.trainhist' field contains information on the training. It is a cell
%         array of training structs. The first training struct contains
%         information on initialization, the others on actual trainings. 
%         If the map has not been initialized, '.trainhist' is empty ([]).
% '.comp_names' field contains the names of the vector components
% '.comp_norm' field contains normalization information for each
%         component. Each cell of '.comp_norm' is itself a cell array of
%         normalization structs. If no normalizations are performed for 
%         the particular component, the cell is empty ([]).
%
% REQUIRED INPUT ARGUMENTS
%
%  dim    (scalar) Input space dimension. 
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments are given as 'argID',value -pairs. If the
%  value is unambiguous (marked below with '*'), it can be given
%  without the preceeding argID. If an argument is given value
%  multiple times, the last one is used.
%
%   'mask'       (vector) BMU search mask, size dim x 1
%   'msize'      (vector) map grid size, default is [0]
%   'labels'     (string array / cellstr) labels for each map unit, 
%                 length=prod(msize)
%   'name'       (string) map name
%   'comp_names' (string array / cellstr) component names, size dim x 1
%   'comp_norm'  (cell array) normalization operations for each
%                 component, size dim x 1. Each cell is either empty, 
%                 or a cell array of normalization structs.
%   'lattice'   *(string) map lattice, 'hexa' or 'rect'
%   'shape'     *(string) map shape, 'sheet', 'cyl' or 'toroid'
%   'topol'     *(struct) topology struct, sets msize, lattice and shape
%   'som_topol','sTopol' = 'topol'
%   'neigh'     *(string) neighborhood function, 'gaussian', 'cutgauss',
%                 'ep' or 'bubble'
%
% OUTPUT ARGUMENTS
% 
%  sMap (struct) the map struct
%
% EXAMPLES
%
% Simplest case:
%  sMap = som_map_struct(3);
%  
% With optional arguments, the other fields can be given values:
%  sTo    = som_set('som_topol','msize',[10 5]);
%  labs   = cell(50, 1); labs{1, 1} = 'first_unit';
%  cnames = {'first'; 'second'; 'third'};
%  sN     = som_set('som_norm');
%  csN    = {sN; sN; sN};
%  
%  sMap = som_map_struct(3,'msize',[10 5],'rect');
%  sMap = som_map_struct(3,'msize',[10 5],'lattice','rect');
%  sMap = som_map_struct(3,sTo,'bubble','labels',labs);
%  sMap = som_map_struct(3,sTo,'comp_names',cnames);
%  sMap = som_map_struct(3,sTo,'name','a data struct');
%  sMap = som_map_struct(3,sTo,'comp_norm',csN,'mask',[1 0 0.5]);
%
% SEE ALSO
% 
%  som_set          Set values and create SOM Toolbox structs.
%  som_data_struct  Create a data struct.
%  som_make         Initialize and train self-organizing map.
%  som_topol_struct Default values for map topology.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 100997
% Version 2.0beta juuso 101199 130300

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default values
sTopol     = som_set('som_topol','lattice','hexa','shape','sheet');
neigh      = 'gaussian';
mask       = ones(dim,1);
name       = sprintf('SOM %s', datestr(now, 1));
labels     = cell(prod(sTopol.msize),1);
for i=1:length(labels), labels{i} = ''; end
comp_names = cell(dim,1); 
for i = 1:dim, comp_names{i} = sprintf('Variable%d', i); end
comp_norm  = cell(dim,1); 

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
      % argument IDs
     case 'mask',       i=i+1; mask = varargin{i}; 
     case 'msize',      i=i+1; sTopol.msize = varargin{i}; 
     case 'labels',     i=i+1; labels = varargin{i};
     case 'name',       i=i+1; name = varargin{i};
     case 'comp_names', i=i+1; comp_names = varargin{i}; 
     case 'comp_norm',  i=i+1; comp_norm = varargin{i};
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i};
     case 'shape',      i=i+1; sTopol.shape = varargin{i}; 
     case {'topol','som_topol','sTopol'}, i=i+1; sTopol = varargin{i};
     case 'neigh',      i=i+1; neigh = varargin{i};
      % unambiguous values
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i}; 
     case {'gaussian','cutgauss','ep','bubble'}, neigh = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
     case 'som_topol', sTopol = varargin{i};
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_map_struct) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end

% create the SOM
codebook = rand(prod(sTopol.msize),dim); 
sTrain = som_set('som_train','time',datestr(now,0),'mask',mask);
sMap = som_set('som_map','codebook',codebook,'topol',sTopol,...
                         'neigh',neigh,'labels',labels,'mask',mask,...
                         'comp_names',comp_names,'name',name,...
                         'comp_norm',comp_norm,'trainhist',sTrain);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
