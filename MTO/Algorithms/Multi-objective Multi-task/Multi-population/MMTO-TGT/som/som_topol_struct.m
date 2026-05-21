function sTopol = som_topol_struct(varargin)

%SOM_TOPOL_STRUCT Default values for SOM topology.
%
% sT = som_topol_struct([[argID,] value, ...])
%
%  sTopol = som_topol_struct('data',D); 
%  sTopol = som_topol_struct('data',D,'munits',200); 
%  sTopol = som_topol_struct(sTopol); 
%  sTopol = som_topol_struct; 
% 
%  Input and output arguments ([]'s are optional): 
%    [argID,  (string) Default map topology depends on a number of 
%     value]  (varies) factors (see below). These are given as a 
%                      argument ID - argument value pairs, listed below.
%
%    sT       (struct) The ready topology struct.
%
% Topology struct contains values for map size, lattice (default is 'hexa')
% and shape (default is 'sheet'). Map size depends on training data and the
% number of map units. The number of map units depends on number of training
% samples.
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix) the training data
%                *(struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) incomplete topology struct: its empty fields 
%                          will be given values
%  'som_topol','sTopol'    = 'topol'
%
% For more help, try 'type som_topol_struct' or check out online documentation.
% See also SOM_SET, SOM_TRAIN_STRUCT, SOM_MAKE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_topol_struct
%
% PURPOSE
%
% Default values for map topology and training parameters.
%
% SYNTAX
%
%  sT = som_topol_struct('argID',value,...);
%  sT = som_topol_struct(value,...);
%
% DESCRIPTION
%
% This function is used to give sensible values for map topology (ie. map
% size). The topology struct is returned. 
%
% The topology struct has three fields: '.msize', '.lattice' and
% '.shape'. Of these, default value for '.lattice' is 'hexa' and for
% '.shape' 'sheet'. Only the '.msize' field depends on the optional
% arguments: 'dlen', 'munits' and 'data'.  The value for '.msize' field is
% determined as follows.
%
% First, the number of map units is determined (unless it is given). A
% heuristic formula of 'munits = 5*sqrt(dlen)' is used to calculate
% it. After this, the map size is determined. Basically, the two biggest
% eigenvalues of the training data are calculated and the ratio between
% sidelengths of the map grid is set to the square root of this ratio. The
% actual sidelengths are then set so that their product is as close to the
% desired number of map units as possible. If the lattice of the grid is
% 'hexa', the ratio is modified a bit to take it into account. If the
% lattice is 'hexa' and shape is 'toroid', the map size along the first axis
% must be even.
%  
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is
%  used. The valid IDs and corresponding values are listed below. The values 
%  which are unambiguous (marked with '*') can be given without the 
%  preceeding argID.
%
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix) the training data
%                *(struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'lattice'     *(string) map lattice: 'hexa' or 'rect'
%  'shape'       *(string) map shape: 'sheet', 'cyl' or 'toroid'
%  'topol'       *(struct) incomplete topology struct: its empty fields 
%                          will be given values
%  'som_topol','sTopol'    = 'topol'
%
% OUTPUT ARGUMENTS
% 
%  sT     (struct) The topology struct.
%
% EXAMPLES
%
%  The most important optional argument for the default topology is 'data'.
%  To get a default topology (given data) use:
%
%    sTopol = som_topol_struct('data',D); 
%
%  This sets lattice to its default value 'hexa'. If you want to have a
%  'rect' lattice instead: 
%
%    sTopol = som_topol_struct('data',D,'lattice','rect');
%     or 
%    sTopol = som_topol_struct('data',D,'rect');
%
%  If you want to have (close to) a specific number of map units, e.g. 100: 
%
%    sTopol = som_topol_struct('data',D,'munits',100);
%
% SEE ALSO
%
%  som_make         Initialize and train a map using default parameters.
%  som_train_struct Default training parameters.
%  som_randinint    Random initialization algorithm.
%  som_lininit      Linear initialization algorithm.
%  som_seqtrain     Sequential training algorithm.
%  som_batchtrain   Batch training algorithm.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0alpha juuso 060898 250399 070499 050899 240801

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% initialize
sTopol = som_set('som_topol','lattice','hexa','shape','sheet'); 
D = [];
dlen = NaN;
dim = 2; 
munits = NaN;

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'dlen',       i=i+1; dlen = varargin{i}; 
     case 'munits',     i=i+1; munits = varargin{i}; sTopol.msize = 0;
     case 'msize',      i=i+1; sTopol.msize = varargin{i}; 
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i}; 
     case 'shape',      i=i+1; sTopol.shape = varargin{i}; 
     case 'data',       
      i=i+1; 
      if isstruct(varargin{i}), D = varargin{i}.data; 
      else D = varargin{i}; 
      end
      [dlen dim] = size(D); 
     case {'hexa','rect'}, sTopol.lattice = varargin{i}; 
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i};
     case {'som_topol','sTopol','topol'}, 
      i=i+1;
      if ~isempty(varargin{i}.msize) && prod(varargin{i}.msize), 
	sTopol.msize = varargin{i}.msize; 
      end
      if ~isempty(varargin{i}.lattice), sTopol.lattice = varargin{i}.lattice; end   
      if ~isempty(varargin{i}.shape), sTopol.shape = varargin{i}.shape; end
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}.type, 
     case 'som_topol',
      if ~isempty(varargin{i}.msize) && prod(varargin{i}.msize), 
	sTopol.msize = varargin{i}.msize; 
      end
      if ~isempty(varargin{i}.lattice), sTopol.lattice = varargin{i}.lattice; end   
      if ~isempty(varargin{i}.shape), sTopol.shape = varargin{i}.shape; end
     case 'som_data', 
      D = varargin{i}.data; 
      [dlen dim] = size(D);       
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action - topology struct

% lattice and shape set already, so if msize is also set, there's
% nothing else to do
if prod(sTopol.msize) && ~isempty(sTopol.msize), return; end

% otherwise, decide msize 
% first (if necessary) determine the number of map units (munits)
if isnan(munits), 
  if ~isnan(dlen), 
    munits = ceil(5 * dlen^0.5); % this is just one way to make a guess...
  else
    munits = 100; % just a convenient value
  end
end

% then determine the map size (msize)
if dim == 1, % 1-D data

  sTopol.msize = [1 ceil(munits)]; 

elseif size(D,1)<2, % eigenvalues cannot be determined since there's no data

  sTopol.msize = round(sqrt(munits)); 
  sTopol.msize(2) = round(munits/sTopol.msize(1));

else % determine map size based on eigenvalues
  
  % initialize xdim/ydim ratio using principal components of the input
  % space; the ratio is the square root of ratio of two largest eigenvalues	
  
  % autocorrelation matrix
  A = zeros(dim)+Inf;
  for i=1:dim, D(:,i) = D(:,i) - mean(D(isfinite(D(:,i)),i)); end  
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
  eigval  = eigval(ind);
  
  %me     = mean(D);
  %D      = D - me(ones(length(ind),1),:); % remove mean from data
  %eigval = sort(eig((D'*D)./size(D,1))); 
  if eigval(end)==0 || eigval(end-1)*munits<eigval(end), 
    ratio = 1; 
  else
    ratio  = sqrt(eigval(end)/eigval(end-1)); % ratio between map sidelengths
  end
  
  % in hexagonal lattice, the sidelengths are not directly 
  % proportional to the number of units since the units on the 
  % y-axis are squeezed together by a factor of sqrt(0.75)
  if strcmp(sTopol.lattice,'hexa'), 
    sTopol.msize(2)  = min(munits, round(sqrt(munits / ratio * sqrt(0.75))));
  else
    sTopol.msize(2)  = min(munits, round(sqrt(munits / ratio)));
  end
  sTopol.msize(1)  = round(munits / sTopol.msize(2));
  
  % if actual dimension of the data is 1, make the map 1-D    
  if min(sTopol.msize) == 1, sTopol.msize = [1 max(sTopol.msize)]; end;
  
  % a special case: if the map is toroid with hexa lattice, 
  % size along first axis must be even
  if strcmp(sTopol.lattice,'hexa') && strcmp(sTopol.shape,'toroid'), 
    if mod(sTopol.msize(1),2), sTopol.msize(1) = sTopol.msize(1) + 1; end
  end

end
  
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
