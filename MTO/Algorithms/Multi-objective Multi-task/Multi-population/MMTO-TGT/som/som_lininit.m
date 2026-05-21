function sMap = som_lininit(D, varargin)

%SOM_LININIT Initialize a Self-Organizing Map linearly.
%
% sMap = som_lininit(D, [[argID,] value, ...])
%
%  sMap = som_lininit(D);
%  sMap = som_lininit(D,sMap);
%  sMap = som_lininit(D,'munits',100,'hexa');
% 
%  Input and output arguments ([]'s are optional): 
%   D                 The training data.
%            (struct) data struct
%            (matrix) data matrix, size dlen x dim
%   [argID,  (string) Parameters affecting the map topology are given 
%    value]  (varies) as argument ID - argument value pairs, listed below.
%   sMap     (struct) map struct
%
% Here are the valid argument IDs and corresponding values. The values 
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) topology struct
%  'som_topol','sTopol'    = 'topol'
%  'map'         *(struct) map struct
%  'som_map','sMap'        = 'map'
%
% For more help, try 'type som_lininit' or check out online documentation.
% See also SOM_MAP_STRUCT, SOM_RANDINIT, SOM_MAKE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_lininit
%
% PURPOSE
%
% Initializes a SOM linearly along its greatest eigenvectors.
%
% SYNTAX
%
%  sMap = som_lininit(D);
%  sMap = som_lininit(D,sMap);
%  sMap = som_lininit(D,'munits',100,'hexa');
%
% DESCRIPTION
%
% Initializes a SOM linearly. If necessary, a map struct is created
% first. The initialization is made by first calculating the eigenvalues
% and eigenvectors of the training data. Then, the map is initialized
% along the mdim greatest eigenvectors of the training data, where
% mdim is the dimension of the map grid.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 106-107.
%
% REQUIRED INPUT ARGUMENTS
%
%  D                 The training data.
%           (struct) Data struct. If this is given, its '.comp_names' and 
%                    '.comp_norm' fields are copied to the map struct.
%           (matrix) data matrix, size dlen x dim
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is used. 
%
%  Here are the valid argument IDs and corresponding values. The values 
%  which are unambiguous (marked with '*') can be given without the 
%  preceeding argID.
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix) the training data
%                *(struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) topology struct
%  'som_topol','sTopol'    = 'topol'
%  'map'         *(struct) map struct
%  'som_map','sMap'        = 'map'
%
% OUTPUT ARGUMENTS
% 
%  sMap     (struct) The initialized map struct.
%
% EXAMPLES
%
%  sMap = som_lininit(D);
%  sMap = som_lininit(D,sMap);
%  sMap = som_lininit(D,'msize',[10 10]);
%  sMap = som_lininit(D,'munits',100,'rect');
%
% SEE ALSO
% 
%  som_map_struct   Create a map struct.
%  som_randinit     Initialize a map with random values.
%  som_make         Initialize and train self-organizing map.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 100997
% Version 2.0beta 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% data
if isstruct(D), 
  data_name = D.name; 
  comp_names = D.comp_names; 
  comp_norm = D.comp_norm; 
  D = D.data;
  struct_mode = 1; 
else 
  data_name = inputname(1); 
  struct_mode = 0;
end
[dlen dim] = size(D);

% varargin
sMap = [];
sTopol = som_topol_struct; 
sTopol.msize = 0; 
munits = NaN;
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'munits',     i=i+1; munits = varargin{i}; sTopol.msize = 0;
     case 'msize',      i=i+1; sTopol.msize = varargin{i};
                               munits = prod(sTopol.msize); 
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i}; 
     case 'shape',      i=i+1; sTopol.shape = varargin{i}; 
     case {'som_topol','sTopol','topol'}, i=i+1; sTopol = varargin{i}; 
     case {'som_map','sMap','map'}, i=i+1; sMap = varargin{i}; sTopol = sMap.topol;
     case {'hexa','rect'}, sTopol.lattice = varargin{i}; 
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}.type, 
     case 'som_topol',
      sTopol = varargin{i}; 
     case 'som_map', 
      sMap = varargin{i};
      sTopol = sMap.topol;
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_topol_struct) Ignoring invalid argument #' num2str(i)]); 
  end
  i = i+1; 
end

if length(sTopol.msize)==1, sTopol.msize = [sTopol.msize 1]; end

if ~isempty(sMap), 
  [munits dim2] = size(sMap.codebook);
  if dim2 ~= dim, error('Map and data must have the same dimension.'); end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create map

% map struct
if ~isempty(sMap), 
  sMap = som_set(sMap,'topol',sTopol);
else  
  if ~prod(sTopol.msize), 
    if isnan(munits), 
      sTopol = som_topol_struct('data',D,sTopol);
    else
      sTopol = som_topol_struct('data',D,'munits',munits,sTopol);
    end
  end  
  sMap = som_map_struct(dim, sTopol); 
end

if struct_mode, 
  sMap = som_set(sMap,'comp_names',comp_names,'comp_norm',comp_norm);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialization

% train struct
sTrain = som_train_struct('algorithm','lininit');
sTrain = som_set(sTrain,'data_name',data_name);

msize = sMap.topol.msize;
mdim = length(msize);
munits = prod(msize);

[dlen dim] = size(D);
if dlen<2,  
  %if dlen==1, sMap.codebook = (sMap.codebook - 0.5)*diag(D); end
  error(['Linear map initialization requires at least two NaN-free' ...
	 ' samples.']);
  return;
end

% compute principle components
if dim > 1 && sum(msize > 1) > 1,
  % calculate mdim largest eigenvalues and their corresponding
  % eigenvectors
    
  % autocorrelation matrix
  A = zeros(dim);
  me = zeros(1,dim);
  for i=1:dim, 
    me(i) = mean(D(isfinite(D(:,i)),i)); 
    D(:,i) = D(:,i) - me(i); 
  end  
  for i=1:dim, 
    for j=i:dim, 
      c = D(:,i).*D(:,j); c = c(isfinite(c));
      A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
    end
  end
  
  % take mdim first eigenvectors with the greatest eigenvalues
  [V,S]   = eig(A);
  eigval  = diag(S);
  [y,ind] = sort(eigval); 
  eigval  = eigval(flipud(ind));
  V       = V(:,flipud(ind)); 
  V       = V(:,1:mdim);
  eigval  = eigval(1:mdim);   

  % normalize eigenvectors to unit length and multiply them by 
  % corresponding (square-root-of-)eigenvalues
  for i=1:mdim, V(:,i) = (V(:,i) / norm(V(:,i))) * sqrt(eigval(i)); end
  
else

  me = zeros(1,dim);
  V = zeros(1,dim);
  for i=1:dim, 
    inds = find(~isnan(D(:,i)));
    me(i) = mean(D(inds,i),1);
    V(i) = std(D(inds,i),1);
  end
  
end

% initialize codebook vectors
if dim>1, 
  sMap.codebook = me(ones(munits,1),:); 
  Coords = som_unit_coords(msize,'rect','sheet');
  cox = Coords(:,1); Coords(:,1) = Coords(:,2); Coords(:,2) = cox;
  for i=1:mdim,
    ma = max(Coords(:,i)); mi = min(Coords(:,i)); 
    if ma>mi, Coords(:,i) = (Coords(:,i)-mi)/(ma-mi); else Coords(:,i) = 0.5; end
  end
  Coords = (Coords-0.5)*2;
  for n = 1:munits,   
    for d = 1:mdim,    
      sMap.codebook(n,:) = sMap.codebook(n,:)+Coords(n,d)*V(:, d)';
    end
  end
else  
  sMap.codebook = [0:(munits-1)]'/(munits-1)*(max(D)-min(D))+min(D);
end

% training struct
sTrain = som_set(sTrain,'time',datestr(now,0));
sMap.trainhist = sTrain;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
