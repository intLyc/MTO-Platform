function sM  = som_supervised(sData,varargin)

%SOM_SUPERVISED SOM training which utilizes class information.
%
% sM = som_supervised(sData, [ArgID, value,...]))
%
%  Input and output arguments ([]'s are optional)
%   sData    (struct) data struct, the class information is 
%                     taken from the first column of .labels field
%   [argID,  (string) See below. These are given as 
%    value]  (varies) 'argID', value -pairs.
%
%   sMap     (struct) map struct
%
%  Here are the argument IDs and corresponding values: 
%  'munits'     (scalar) the preferred number of map units
%  'msize'      (vector) map grid size
%  'mask'       (vector) BMU search mask, size dim x 1
%  'name'       (string) map name
%  'comp_names' (string array / cellstr) component names, size dim x 1
%  'tracking'   (scalar) how much to report, default = 1
%  The following values are unambiguous and can therefore
%  be given without the preceeding argument ID:
%  'algorithm'  (string) training algorithm: 'seq' or 'batch'
%  'mapsize'    (string) do you want a 'small', 'normal' or 'big' map
%               Any explicit settings of munits or msize override this.
%  'topol'      (struct) topology struct
%  'som_topol','sTopol' = 'topol'
%  'lattice'    (string) map lattice, 'hexa' or 'rect'
%  'shape'      (string) map shape, 'sheet', 'cyl' or 'toroid'
%  'neigh'      (string) neighborhood function, 'gaussian', 'cutgauss',
%                       'ep' or 'bubble'
%
% For more help, try 'type som_supervised', or check out online documentation.
% See also SOM_MAKE, SOM_AUTOLABEL.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_supervised
%
% PURPOSE
%
% Creates, initializes and trains a supervised SOM by taking the 
% class-identity into account.
%
% SYNTAX
%
% sMap = som_supervised(sData);
% sMap = som_supervised(...,'argID',value,...)
% sMap = som_make(...,value,...);
%
% DESCRIPTION
%
% Creates, initializes and trains a supervised SOM. It constructs the
% training data by adding 1-of-N -coded matrix to the original data
% based on the class information in the .labels field. The dimension
% of vectors after the process is (the old dimension + number of
% different classes). In each vector, one of the new components has
% value '1' (this depends on the class of the vector), and others '0'.
% Calls SOM_MAKE to construct the map. Then the class of each map unit
% is determined by taking maximum over these added components, and a
% label is give accordingly. Finally, the extra components (the
% 1-of-N -coded ones) are removed.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 160-161.
% Kohonen, T., M�kivasara, K., Saram�ki, T., "Phonetic Maps - 
%    Insightful Representation of Phonological Features For 
%    Speech Recognition", In proceedings of International
%    Conference on Pattern Recognition (ICPR), Montreal, Canada, 
%    1984, pp. 182-185.
%
% REQUIRED INPUT ARGUMENTS
%
% sData           The data to use in the training.
%        (struct) A data struct. '.comp_names' as well as '.name' 
%                 is copied to the map. The class information is 
%                 taken from the first column of '.labels' field.
%
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is used. 
%  Here are the argument IDs and corresponding values: 
%   'munits'     (scalar) the preferred number of map units - this may 
%                 change a bit, depending on the properties of the data
%   'msize'      (vector) map grid size
%   'mask'       (vector) BMU search mask, size dim x 1
%   'name'       (string) map name
%   'comp_names' (string array / cellstr) component names, size dim x 1
%   'tracking'   (scalar) how much to report, default = 1. This parameter 
%                 is also passed to the training functions. 
%   The following values are unambiguous and can therefore
%   be given without the preceeding argument ID:
%   'algorithm'  (string) training algorithm: 'seq' or 'batch' (default)
%   'mapsize'    (string) do you want a 'small', 'normal' or 'big' map
%                 Any explicit settings of munits or msize (or topol) 
%                 override this.
%   'topol'      (struct) topology struct
%   'som_topol','sTopol' = 'topol'
%   'lattice'    (string) map lattice, 'hexa' or 'rect'
%   'shape'      (string) map shape, 'sheet', 'cyl' or 'toroid'
%   'neigh'      (string) neighborhood function, 'gaussian', 'cutgauss',
%                 'ep' or 'bubble'
%
% OUTPUT ARGUMENTS
% 
%  sMap (struct)  SOM -map struct
%
% EXAMPLES
%
%  To simply train a map with default parameters:
%
%   sMap = som_supervised(sData);
%
%  With the optional arguments, the initialization and training can be
%  influenced. To change map size, use 'msize', 'munits' or 'mapsize'
%  arguments:  
%
%   sMap = som_supervised(D,'mapsize','big'); or 
%   sMap = som_supervised(D,'big');
%   sMap = som_supervised(D,'munits', 100);
%   sMap = som_supervised(D,'msize', [20 10]); 
%
%  Argument 'algorithm' can be used to switch between 'seq' and 'batch'
%  algorithms. 'batch' is the default, so to use 'seq' algorithm: 
%
%   sMap = som_supervised(D,'algorithm','seq'); or 
%   sMap = som_supervised(D,'seq'); 
%
%  The 'tracking' argument can be used to control the amout of reporting
%  during training. The argument is used in this function, and it is
%  passed to the training functions. To make the function work silently
%  set it to 0.
%
%   sMap = som_supervised(D,'tracking',0); 
%
% SEE ALSO
% 
%  som_make         Create, initialize and train Self-Organizing map.
%  som_autolabel    Label SOM/data set based on another SOM/data set.

% Contributed to SOM Toolbox vs2, Feb 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 050100

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D0 = sData.data;
[c,n,classlabels] = class2num(sData.labels(:,1));

%%%%%%%% Checking arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isstruct(sData)
  error('Argument ''sData'' must be a ''som_data'' -struct.');
else
  data_name = sData.name;
  comp_names = sData.comp_names;
  comp_norm = sData.comp_norm;
end

[dlen,dim] = size(sData.data);

% defaults

mapsize = '';
sM = som_map_struct(dim+n); 
sTopol = sM.topol;
munits = prod(sTopol.msize); % should be zero
mask = sM.mask; 
name = sM.name; 
neigh = sM.neigh; 
tracking = 1;
algorithm = 'batch'; 

%%%% changes to defaults (checking varargin) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1; 
while i <= length(varargin) 
  argok = 1; 
  if ischar(varargin{i}) 
    switch varargin{i}, 
      % argument IDs
     case 'mask',       
      i=i+1; 
      mask = varargin{i}; 
     case 'munits',     
      i=i+1; 
      munits = varargin{i}; 
     case 'msize',      
      i=i+1; 
      sTopol.msize = varargin{i}; 
      munits = prod(sTopol.msize); 
     case 'mapsize',    
      i=i+1; 
      mapsize = varargin{i}; 
     case 'name',       
      i=i+1; 
      name = varargin{i};
     case 'comp_names', 
      i=i+1; 
      comp_names = varargin{i}; 
     case 'lattice',    
      i=i+1; 
      sTopol.lattice = varargin{i};
     case 'shape',      
      i=i+1; 
      sTopol.shape = varargin{i}; 
     case {'topol','som_topol','sTopol'}, 
      i=i+1; 
      sTopol = varargin{i}; 
      munits = prod(sTopol.msize); 
     case 'neigh',      
      i=i+1; 
      neigh = varargin{i};
     case 'tracking',   
      i=i+1; 
      tracking = varargin{i};
     case 'algorithm',  
      i=i+1; 
      algorithm = varargin{i}; 
  % unambiguous values
     case {'hexa','rect'}, 
      sTopol.lattice = varargin{i};
     case {'sheet','cyl','toroid'}, 
      sTopol.shape = varargin{i}; 
     case {'gaussian','cutgauss','ep','bubble'}, 
      neigh = varargin{i};
     case {'seq','batch'}, 
      algorithm = varargin{i}; 
     case {'small','normal','big'}, 
      mapsize = varargin{i}; 
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
      case 'som_topol', 
       sTopol = varargin{i}; 
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_supervised) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end

%%%%%%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% constructing the training data by adding 1-of-N -coded matrix to the
% original data.

[dlen,dim] = size(D0);

Dc = zeros(dlen,n);

for i=1:dlen 
  if c(i)
    Dc(i,c(i)) = 1;
  end
end

D = [D0, Dc];

% initialization and training 

sD = som_data_struct(D,...
                     'name',data_name);

sM = som_make(sD,...
              'mask',mask,...
              'munits',munits,...
              'name',data_name,...
              'tracking',tracking,...
              'algorithm',algorithm,...
              'mapsize',mapsize,...
              'topol',sTopol,...
              'neigh',neigh);

% add labels

for i=1:prod(sM.topol.msize), 
  [dummy,class] = max(sM.codebook(i,dim+[1:n]));
  sM.labels{i} = classlabels{class};
end

%sD.labels = sData.labels;
%sM = som_autolabel(sM,sD,'vote');

% remove extra components and modify map -struct

sM.codebook = sM.codebook(:,1:dim);
sM.mask = sM.mask(1:dim);
sM.comp_names = sData.comp_names;
sM.comp_norm = sData.comp_norm;

% remove extras from sM.trainhist

for i=1:length(sM.trainhist)
  if sM.trainhist(i).mask
    sM.trainhist(i).mask = sM.trainhist(i).mask(1:dim);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [numbers, n, names] = class2num(class)

names = {};
numbers = zeros(length(class),1);

for i=1:length(class)
  if ~isempty(class{i}) && ~any(strcmp(class{i},names))
    names=cat(1,names,class(i));
  end
end

n=length(names);

tmp_numbers = (1:n)';

for i=1:length(class)
  if ~isempty(class{i})
    numbers(i,1) = find(strcmp(class{i},names));    
  end
end
