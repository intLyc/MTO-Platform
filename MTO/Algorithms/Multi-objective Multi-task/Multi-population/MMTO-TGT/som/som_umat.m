function U = som_umat(sMap, varargin)

%SOM_UMAT Compute unified distance matrix of self-organizing map.
%
% U = som_umat(sMap, [argID, value, ...])
%
%  U = som_umat(sMap);  
%  U = som_umat(M,sTopol,'median','mask',[1 1 0 1]);
%
%  Input and output arguments ([]'s are optional): 
%   sMap     (struct) map struct or
%            (matrix) the codebook matrix of the map
%   [argID,  (string) See below. The values which are unambiguous can 
%    value]  (varies) be given without the preceeding argID.
%
%   U        (matrix) u-matrix of the self-organizing map 
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'mask'       (vector) size dim x 1, weighting factors for different 
%                         components (same as BMU search mask)
%   'msize'      (vector) map grid size
%   'topol'     *(struct) topology struct
%   'som_topol','sTopol' = 'topol'
%   'lattice'   *(string) map lattice, 'hexa' or 'rect'
%   'mode'      *(string) 'min','mean','median','max', default is 'median'
%
% NOTE! the U-matrix is always calculated for 'sheet'-shaped map and
% the map grid must be at most 2-dimensional.
% 
% For more help, try 'type som_umat' or check out online documentation.
% See also SOM_SHOW, SOM_CPLANE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_umat
%
% PURPOSE
%
% Computes the unified distance matrix of a SOM.
%
% SYNTAX
%
%  U = som_umat(sM)  
%  U = som_umat(...,'argID',value,...)
%  U = som_umat(...,value,...)
%
% DESCRIPTION
%
% Compute and return the unified distance matrix of a SOM. 
% For example a case of 5x1 -sized map:
%            m(1) m(2) m(3) m(4) m(5)
% where m(i) denotes one map unit. The u-matrix is a 9x1 vector:
%    u(1) u(1,2) u(2) u(2,3) u(3) u(3,4) u(4) u(4,5) u(5) 
% where u(i,j) is the distance between map units m(i) and m(j)
% and u(k) is the mean (or minimum, maximum or median) of the 
% surrounding values, e.g. u(3) = (u(2,3) + u(3,4))/2. 
%
% Note that the u-matrix is always calculated for 'sheet'-shaped map and
% the map grid must be at most 2-dimensional.
%
% REFERENCES
%
% Ultsch, A., Siemon, H.P., "Kohonen's Self-Organizing Feature Maps
%   for Exploratory Data Analysis", in Proc. of INNC'90,
%   International Neural Network Conference, Dordrecht,
%   Netherlands, 1990, pp. 305-308.
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 117-119. 
% Iivarinen, J., Kohonen, T., Kangas, J., Kaski, S., "Visualizing 
%   the Clusters on the Self-Organizing Map", in proceedings of
%   Conference on Artificial Intelligence Research in Finland,
%   Helsinki, Finland, 1994, pp. 122-126.
% Kraaijveld, M.A., Mao, J., Jain, A.K., "A Nonlinear Projection
%   Method Based on Kohonen's Topology Preserving Maps", IEEE
%   Transactions on Neural Networks, vol. 6, no. 3, 1995, pp. 548-559.
% 
% REQUIRED INPUT ARGUMENTS
%
%  sM (struct) SOM Toolbox struct or the codebook matrix of the map.
%     (matrix) The matrix may be 3-dimensional in which case the first 
%              two dimensions are taken for the map grid dimensions (msize).
%
% OPTIONAL INPUT ARGUMENTS
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments are given as 'argID',value -pairs. If the 
%  value is unambiguous, it can be given without the preceeding argID.
%  If an argument is given value multiple times, the last one is used. 
%
%  Below is the list of valid arguments: 
%   'mask'      (vector) mask to be used in calculating
%                        the interunit distances, size [dim  1]. Default is 
%                        the one in sM (field sM.mask) or a vector of
%                        ones if only a codebook matrix was given.
%   'topol'     (struct) topology of the map. Default is the one
%                        in sM (field sM.topol).
%   'sTopol','som_topol' (struct) = 'topol'
%   'msize'     (vector) map grid dimensions
%   'lattice'   (string) map lattice 'rect' or 'hexa'
%   'mode'      (string) 'min', 'mean', 'median' or 'max'
%                        Map unit value computation method. In fact, 
%                        eval-function is used to evaluate this, so 
%                        you can give other computation methods as well.
%                        Default is 'median'. 
%
% OUTPUT ARGUMENTS
%
%  U   (matrix) the unified distance matrix of the SOM 
%               size 2*n1-1 x 2*n2-1, where n1 = msize(1) and n2 = msize(2)
%
% EXAMPLES
%
%  U = som_umat(sM);  
%  U = som_umat(sM.codebook,sM.topol,'median','mask',[1 1 0 1]);
%  U = som_umat(rand(10,10,4),'hexa','rect'); 
% 
% SEE ALSO
%
%  som_show    show the selected component planes and the u-matrix
%  som_cplane  draw a 2D unified distance matrix

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 260997
% Version 2.0beta juuso 151199, 151299, 200900

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, Inf, nargin));  % check no. of input arguments is correct

% sMap
if isstruct(sMap), 
  M = sMap.codebook;
  sTopol = sMap.topol; 
  mask = sMap.mask;
elseif isnumeric(sMap),
  M = sMap; 
  si = size(M);
  dim = si(end);
  if length(si)>2, msize = si(1:end-1);
  else msize = [si(1) 1];
  end
  munits = prod(msize);
  sTopol = som_set('som_topol','msize',msize,'lattice','rect','shape','sheet'); 
  mask = ones(dim,1);
  M = reshape(M,[munits,dim]);
end
mode = 'median';

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
      % argument IDs
     case 'mask',       i=i+1; mask = varargin{i}; 
     case 'msize',      i=i+1; sTopol.msize = varargin{i}; 
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i};
     case {'topol','som_topol','sTopol'}, i=i+1; sTopol = varargin{i};
     case 'mode',       i=i+1; mode = varargin{i};
      % unambiguous values
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'min','mean','median','max'}, mode = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
     case 'som_topol', sTopol = varargin{i};
     case 'som_map',   sTopol = varargin{i}.topol;
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_umat) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end

% check
[munits dim] = size(M);
if prod(sTopol.msize)~=munits, 
  error('Map grid size does not match the number of map units.')
end
if length(sTopol.msize)>2, 
  error('Can only handle 1- and 2-dimensional map grids.')
end
if prod(sTopol.msize)==1,
  warning('Only one codebook vector.'); U = []; return;
end
if ~strcmp(sTopol.shape,'sheet'), 
  disp(['The ' sTopol.shape ' shape of the map ignored. Using sheet instead.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize variables

y = sTopol.msize(1);
x = sTopol.msize(2);
lattice = sTopol.lattice;
shape = sTopol.shape;
M = reshape(M,[y x dim]);

ux = 2 * x - 1; 
uy = 2 * y - 1;
U  = zeros(uy, ux);

calc = sprintf('%s(a)',mode);

if size(mask,2)>1, mask = mask'; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% u-matrix computation

% distances between map units

if strcmp(lattice, 'rect'), % rectangular lattice
  
  for j=1:y, for i=1:x,
      if i<x, 
	dx = (M(j,i,:) - M(j,i+1,:)).^2; % horizontal
	U(2*j-1,2*i) = sqrt(mask'*dx(:));
      end 
      if j<y, 
	dy = (M(j,i,:) - M(j+1,i,:)).^2; % vertical
	U(2*j,2*i-1) = sqrt(mask'*dy(:));
      end
      if j<y && i<x,	
	dz1 = (M(j,i,:) - M(j+1,i+1,:)).^2; % diagonals
	dz2 = (M(j+1,i,:) - M(j,i+1,:)).^2;
	U(2*j,2*i) = (sqrt(mask'*dz1(:))+sqrt(mask'*dz2(:)))/(2 * sqrt(2));
      end
    end
  end

elseif strcmp(lattice, 'hexa') % hexagonal lattice

  for j=1:y, 
    for i=1:x,
      if i<x,
	dx = (M(j,i,:) - M(j,i+1,:)).^2; % horizontal
	U(2*j-1,2*i) = sqrt(mask'*dx(:));
      end
      
      if j<y, % diagonals
	dy = (M(j,i,:) - M(j+1,i,:)).^2;
	U(2*j,2*i-1) = sqrt(mask'*dy(:));	
	
	if rem(j,2)==0 && i<x,
	  dz= (M(j,i,:) - M(j+1,i+1,:)).^2; 
	  U(2*j,2*i) = sqrt(mask'*dz(:));
	elseif rem(j,2)==1 && i>1,
	  dz = (M(j,i,:) - M(j+1,i-1,:)).^2; 
	  U(2*j,2*i-2) = sqrt(mask'*dz(:));
	end
      end
    end
  end
  
end

% values on the units

if (uy == 1 || ux == 1),
  % in 1-D case, mean is equal to median 

  ma = max([ux uy]);
  for i = 1:2:ma,
    if i>1 && i<ma, 
      a = [U(i-1) U(i+1)]; 
      U(i) = eval(calc);
    elseif i==1, U(i) = U(i+1); 
    else U(i) = U(i-1); % i==ma
    end
  end    

elseif strcmp(lattice, 'rect')

  for j=1:2:uy, 
    for i=1:2:ux,
      if i>1 && j>1 && i<ux && j<uy,    % middle part of the map
	a = [U(j,i-1) U(j,i+1) U(j-1,i) U(j+1,i)];        
      elseif j==1 && i>1 && i<ux,        % upper edge
	a = [U(j,i-1) U(j,i+1) U(j+1,i)];
      elseif j==uy && i>1 && i<ux,       % lower edge
	a = [U(j,i-1) U(j,i+1) U(j-1,i)];
      elseif i==1 && j>1 && j<uy,        % left edge
	a = [U(j,i+1) U(j-1,i) U(j+1,i)];
      elseif i==ux && j>1 && j<uy,       % right edge
	a = [U(j,i-1) U(j-1,i) U(j+1,i)];
      elseif i==1 && j==1,              % top left corner
	a = [U(j,i+1) U(j+1,i)];
      elseif i==ux && j==1,             % top right corner
	a = [U(j,i-1) U(j+1,i)];
      elseif i==1 && j==uy,             % bottom left corner
	a = [U(j,i+1) U(j-1,i)];
      elseif i==ux && j==uy,            % bottom right corner
	a = [U(j,i-1) U(j-1,i)];
      else
	a = 0;
      end
      U(j,i) = eval(calc);
    end
  end

elseif strcmp(lattice, 'hexa')
  
  for j=1:2:uy, 
    for i=1:2:ux,
      if i>1 && j>1 && i<ux && j<uy,      % middle part of the map
	a = [U(j,i-1) U(j,i+1)];
	if rem(j-1,4)==0, a = [a, U(j-1,i-1) U(j-1,i) U(j+1,i-1) U(j+1,i)];
	else a = [a, U(j-1,i) U(j-1,i+1) U(j+1,i) U(j+1,i+1)]; end       
      elseif j==1 && i>1 && i<ux,        % upper edge
	a = [U(j,i-1) U(j,i+1) U(j+1,i-1) U(j+1,i)];
      elseif j==uy && i>1 && i<ux,       % lower edge
	a = [U(j,i-1) U(j,i+1)];
	if rem(j-1,4)==0, a = [a, U(j-1,i-1) U(j-1,i)];
	else a = [a, U(j-1,i) U(j-1,i+1)]; end
      elseif i==1 && j>1 && j<uy,        % left edge
	a = U(j,i+1);
	if rem(j-1,4)==0, a = [a, U(j-1,i) U(j+1,i)];
	else a = [a, U(j-1,i) U(j-1,i+1) U(j+1,i) U(j+1,i+1)]; end
      elseif i==ux && j>1 && j<uy,       % right edge
	a = U(j,i-1);
	if rem(j-1,4)==0, a=[a, U(j-1,i) U(j-1,i-1) U(j+1,i) U(j+1,i-1)];
	else a = [a, U(j-1,i) U(j+1,i)]; end
      elseif i==1 && j==1,              % top left corner
	a = [U(j,i+1) U(j+1,i)];
      elseif i==ux && j==1,             % top right corner
	a = [U(j,i-1) U(j+1,i-1) U(j+1,i)];
      elseif i==1 && j==uy,             % bottom left corner
	if rem(j-1,4)==0, a = [U(j,i+1) U(j-1,i)];
	else a = [U(j,i+1) U(j-1,i) U(j-1,i+1)]; end
      elseif i==ux && j==uy,            % bottom right corner
	if rem(j-1,4)==0, a = [U(j,i-1) U(j-1,i) U(j-1,i-1)];
	else a = [U(j,i-1) U(j-1,i)]; end
      else
	a=0;
      end
      U(j,i) = eval(calc);
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% normalization between [0,1]

% U = U - min(min(U)); 
% ma = max(max(U)); if ma > 0, U = U / ma; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



