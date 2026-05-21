function [sMap,sTrain] = som_batchtrain(sMap, D, varargin)

%SOM_BATCHTRAIN  Use batch algorithm to train the Self-Organizing Map.
%
% [sM,sT] = som_batchtrain(sM, D, [argID, value, ...])
% 
%  sM     = som_batchtrain(sM,D);
%  sM     = som_batchtrain(sM,sD,'radius',[10 3 2 1 0.1],'tracking',3);
%  [M,sT] = som_batchtrain(M,D,'ep','msize',[10 3],'hexa');
%
%  Input and output arguments ([]'s are optional): 
%   sM      (struct) map struct, the trained and updated map is returned
%           (matrix) codebook matrix of a self-organizing map
%                    size munits x dim or  msize(1) x ... x msize(k) x dim
%                    The trained map codebook is returned.
%   D       (struct) training data; data struct
%           (matrix) training data, size dlen x dim
%   [argID, (string) See below. The values which are unambiguous can 
%    value] (varies) be given without the preceeding argID.
%
%   sT      (struct) learning parameters used during the training
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'mask'       (vector) BMU search mask, size dim x 1
%   'msize'      (vector) map size
%   'radius'     (vector) neighborhood radiuses, length 1, 2 or trainlen
%   'radius_ini' (scalar) initial training radius
%   'radius_fin' (scalar) final training radius
%   'tracking'   (scalar) tracking level, 0-3 
%   'trainlen'   (scalar) training length in epochs
%   'train'     *(struct) train struct, parameters for training
%   'sTrain','som_train'  = 'train'
%   'neigh'     *(string) neighborhood function, 'gaussian', 'cutgauss',
%                         'ep' or 'bubble'
%   'topol'     *(struct) topology struct
%   'som_topol','sTopol'  = 'topol'
%   'lattice'   *(string) map lattice, 'hexa' or 'rect'
%   'shape'     *(string) map shape, 'sheet', 'cyl' or 'toroid'
%   'weights'    (vector) sample weights: each sample is weighted 
%
% For more help, try 'type som_batchtrain' or check out online documentation.
% See also  SOM_MAKE, SOM_SEQTRAIN, SOM_TRAIN_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_batchtrain
%
% PURPOSE
%
% Trains a Self-Organizing Map using the batch algorithm. 
%
% SYNTAX
%
%  sM = som_batchtrain(sM,D);
%  sM = som_batchtrain(sM,sD);
%  sM = som_batchtrain(...,'argID',value,...);
%  sM = som_batchtrain(...,value,...);
%  [sM,sT] = som_batchtrain(M,D,...);
%
% DESCRIPTION
%
% Trains the given SOM (sM or M above) with the given training data
% (sD or D) using batch training algorithm.  If no optional arguments
% (argID, value) are given, a default training is done. Using optional
% arguments the training parameters can be specified. Returns the
% trained and updated SOM and a train struct which contains
% information on the training.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 127-128.
% Kohonen, T., "Things you haven't heard about the Self-Organizing
%    Map", In proceedings of International Conference
%    on Neural Networks (ICNN), San Francisco, 1993, pp. 1147-1156.
%
% KNOWN BUGS
%
% Batchtrain does not work correctly for a map with a single unit. 
% This is because of the way 'min'-function works. 
%
% REQUIRED INPUT ARGUMENTS
%
%  sM          The map to be trained. 
%     (struct) map struct
%     (matrix) codebook matrix (field .data of map struct)
%              Size is either [munits dim], in which case the map grid 
%              dimensions (msize) should be specified with optional arguments,
%              or [msize(1) ... msize(k) dim] in which case the map 
%              grid dimensions are taken from the size of the matrix. 
%              Lattice, by default, is 'rect' and shape 'sheet'.
%  D           Training data.
%     (struct) data struct
%     (matrix) data matrix, size [dlen dim]
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
%  Below is the list of valid arguments: 
%   'mask'       (vector) BMU search mask, size dim x 1. Default is 
%                         the one in sM (field '.mask') or a vector of
%                         ones if only a codebook matrix was given.
%   'msize'      (vector) map grid dimensions. Default is the one
%                         in sM (field sM.topol.msize) or 
%                         'si = size(sM); msize = si(1:end-1);' 
%                         if only a codebook matrix was given. 
%   'radius'     (vector) neighborhood radius 
%                         length = 1: radius_ini = radius
%                         length = 2: [radius_ini radius_fin] = radius
%                         length > 2: the vector given neighborhood
%                                     radius for each step separately
%                                     trainlen = length(radius)
%   'radius_ini' (scalar) initial training radius
%   'radius_fin' (scalar) final training radius
%   'tracking'   (scalar) tracking level: 0, 1 (default), 2 or 3
%                         0 - estimate time 
%                         1 - track time and quantization error 
%                         2 - plot quantization error
%                         3 - plot quantization error and two first 
%                             components 
%   'trainlen'   (scalar) training length in epochs
%   'train'     *(struct) train struct, parameters for training. 
%                         Default parameters, unless specified, 
%                         are acquired using SOM_TRAIN_STRUCT (this 
%                         also applies for 'trainlen', 'radius_ini' 
%                         and 'radius_fin').
%   'sTrain', 'som_topol' (struct) = 'train'
%   'neigh'     *(string) The used neighborhood function. Default is 
%                         the one in sM (field '.neigh') or 'gaussian'
%                         if only a codebook matrix was given. Other 
%                         possible values is 'cutgauss', 'ep' and 'bubble'.
%   'topol'     *(struct) topology of the map. Default is the one
%                         in sM (field '.topol').
%   'sTopol', 'som_topol' (struct) = 'topol'
%   'lattice'   *(string) map lattice. Default is the one in sM
%                         (field sM.topol.lattice) or 'rect' 
%                         if only a codebook matrix was given. 
%   'shape'     *(string) map shape. Default is the one in sM
%                         (field sM.topol.shape) or 'sheet' 
%                         if only a codebook matrix was given. 
%   'weights'    (vector) weight for each data vector: during training, 
%                         each data sample is weighted with the corresponding
%                         value, for example giving weights = [1 1 2 1] 
%                         would have the same result as having third sample
%                         appear 2 times in the data
%
% OUTPUT ARGUMENTS
% 
%  sM          the trained map
%     (struct) if a map struct was given as input argument, a 
%              map struct is also returned. The current training 
%              is added to the training history (sM.trainhist).
%              The 'neigh' and 'mask' fields of the map struct
%              are updated to match those of the training.
%     (matrix) if a matrix was given as input argument, a matrix
%              is also returned with the same size as the input 
%              argument.
%  sT (struct) train struct; information of the accomplished training
%
% EXAMPLES
%
% Simplest case:
%  sM = som_batchtrain(sM,D);  
%  sM = som_batchtrain(sM,sD);  
%
% To change the tracking level, 'tracking' argument is specified:
%  sM = som_batchtrain(sM,D,'tracking',3);
%
% The change training parameters, the optional arguments 'train','neigh',
% 'mask','trainlen','radius','radius_ini' and 'radius_fin' are used. 
%  sM = som_batchtrain(sM,D,'neigh','cutgauss','trainlen',10,'radius_fin',0);
%
% Another way to specify training parameters is to create a train struct:
%  sTrain = som_train_struct(sM,'dlen',size(D,1));
%  sTrain = som_set(sTrain,'neigh','cutgauss');
%  sM = som_batchtrain(sM,D,sTrain);
%
% By default the neighborhood radius goes linearly from radius_ini to
% radius_fin. If you want to change this, you can use the 'radius' argument
% to specify the neighborhood radius for each step separately:
%  sM = som_batchtrain(sM,D,'radius',[5 3 1 1 1 1 0.5 0.5 0.5]);
%
% You don't necessarily have to use the map struct, but you can operate
% directly with codebook matrices. However, in this case you have to
% specify the topology of the map in the optional arguments. The
% following commads are identical (M is originally a 200 x dim sized matrix):
%  M = som_batchtrain(M,D,'msize',[20 10],'lattice','hexa','shape','cyl');
%   or
%  M = som_batchtrain(M,D,'msize',[20 10],'hexa','cyl');
%   or
%  sT= som_set('som_topol','msize',[20 10],'lattice','hexa','shape','cyl');
%  M = som_batchtrain(M,D,sT);
%   or
%  M = reshape(M,[20 10 dim]);
%  M = som_batchtrain(M,D,'hexa','cyl');
%
% The som_batchtrain also returns a train struct with information on the 
% accomplished training. This struct is also added to the end of the 
% trainhist field of map struct, in case a map struct was given.
%  [M,sTrain] = som_batchtrain(M,D,'msize',[20 10]);
%  [sM,sTrain] = som_batchtrain(sM,D); % sM.trainhist{end}==sTrain
%
% SEE ALSO
% 
%  som_make         Initialize and train a SOM using default parameters.
%  som_seqtrain     Train SOM with sequential algorithm.
%  som_train_struct Determine default training parameters.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 071197 041297
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check arguments 

error(nargchk(2, Inf, nargin));  % check the number of input arguments

% map 
struct_mode = isstruct(sMap);
if struct_mode, 
  sTopol = sMap.topol;
else  
  orig_size = size(sMap);
  if ndims(sMap) > 2, 
    si = size(sMap); dim = si(end); msize = si(1:end-1);
    M = reshape(sMap,[prod(msize) dim]);
  else
    msize = [orig_size(1) 1]; 
    dim = orig_size(2);    
  end
  sMap   = som_map_struct(dim,'msize',msize);
  sTopol = sMap.topol;
end
[munits dim] = size(sMap.codebook);

% data
if isstruct(D), 
  data_name = D.name; 
  D = D.data;
else 
  data_name = inputname(2); 
end
nonempty = find(sum(isnan(D),2) < dim);
D = D(nonempty,:);                    % remove empty vectors from the data
[dlen ddim] = size(D);                % check input dimension
if dim ~= ddim, 
  error('Map and data input space dimensions disagree.'); 
end

% varargin
sTrain = som_set('som_train','algorithm','batch','neigh', ...
		 sMap.neigh,'mask',sMap.mask,'data_name',data_name);
radius     = [];
tracking   = 1;
weights    = 1; 

i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     % argument IDs
     case 'msize', i=i+1; sTopol.msize = varargin{i}; 
     case 'lattice', i=i+1; sTopol.lattice = varargin{i};
     case 'shape', i=i+1; sTopol.shape = varargin{i};
     case 'mask', i=i+1; sTrain.mask = varargin{i};
     case 'neigh', i=i+1; sTrain.neigh = varargin{i};
     case 'trainlen', i=i+1; sTrain.trainlen = varargin{i};
     case 'tracking', i=i+1; tracking = varargin{i};
     case 'weights', i=i+1; weights = varargin{i}; 
     case 'radius_ini', i=i+1; sTrain.radius_ini = varargin{i};
     case 'radius_fin', i=i+1; sTrain.radius_fin = varargin{i};
     case 'radius', 
      i=i+1; 
      l = length(varargin{i}); 
      if l==1, 
        sTrain.radius_ini = varargin{i}; 
      else 
        sTrain.radius_ini = varargin{i}(1); 
        sTrain.radius_fin = varargin{i}(end);
        if l>2, radius = varargin{i}; end
      end 
     case {'sTrain','train','som_train'}, i=i+1; sTrain = varargin{i};
     case {'topol','sTopol','som_topol'}, 
      i=i+1; 
      sTopol = varargin{i};
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
      % unambiguous values
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i}; 
     case {'gaussian','cutgauss','ep','bubble'}, sTrain.neigh = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}(1).type, 
     case 'som_topol', 
      sTopol = varargin{i}; 
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
     case 'som_train', sTrain = varargin{i};
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_batchtrain) Ignoring invalid argument #' num2str(i+2)]); 
  end
  i = i+1; 
end

% take only weights of non-empty vectors
if length(weights)>dlen, weights = weights(nonempty); end

% trainlen
if ~isempty(radius), sTrain.trainlen = length(radius); end

% check topology
if struct_mode, 
  if ~strcmp(sTopol.lattice,sMap.topol.lattice) || ...
	~strcmp(sTopol.shape,sMap.topol.shape) || ...
	any(sTopol.msize ~= sMap.topol.msize), 
    warning('Changing the original map topology.');
  end
end
sMap.topol = sTopol; 

% complement the training struct
sTrain = som_train_struct(sTrain,sMap,'dlen',dlen);
if isempty(sTrain.mask), sTrain.mask = ones(dim,1); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize

M        = sMap.codebook;
mask     = sTrain.mask;
trainlen = sTrain.trainlen;

% neighborhood radius
if trainlen==1, 
  radius = sTrain.radius_ini; 
elseif length(radius)<=2,  
  r0 = sTrain.radius_ini; r1 = sTrain.radius_fin;
  radius = r1 + fliplr((0:(trainlen-1))/(trainlen-1)) * (r0 - r1);
else
  % nil
end
                                   
% distance between map units in the output space
%  Since in the case of gaussian and ep neighborhood functions, the 
%  equations utilize squares of the unit distances and in bubble case
%  it doesn't matter which is used, the unitdistances and neighborhood
%  radiuses are squared.
Ud = som_unit_dists(sTopol);
Ud = Ud.^2;
radius = radius.^2;
% zero neighborhood radius may cause div-by-zero error
radius(find(radius==0)) = eps; 

% The training algorithm involves calculating weighted Euclidian distances 
% to all map units for each data vector. Basically this is done as
%   for i=1:dlen, 
%     for j=1:munits, 
%       for k=1:dim
%         Dist(j,i) = Dist(j,i) + mask(k) * (D(i,k) - M(j,k))^2;
%       end
%     end
%   end
% where mask is the weighting vector for distance calculation. However, taking 
% into account that distance between vectors m and v can be expressed as
%   |m - v|^2 = sum_i ((m_i - v_i)^2) = sum_i (m_i^2 + v_i^2 - 2*m_i*v_i)
% this can be made much faster by transforming it to a matrix operation:
%   Dist = (M.^2)*mask*ones(1,d) + ones(m,1)*mask'*(D'.^2) - 2*M*diag(mask)*D'
% Of the involved matrices, several are constant, as the mask and data do 
% not change during training. Therefore they are calculated beforehand.

% For the case where there are unknown components in the data, each data
% vector will have an individual mask vector so that for that unit, the 
% unknown components are not taken into account in distance calculation.
% In addition all NaN's are changed to zeros so that they don't screw up 
% the matrix multiplications and behave correctly in updating step.
Known = ~isnan(D);
W1 = (mask*ones(1,dlen)) .* Known'; 
D(find(~Known)) = 0;  

% constant matrices
WD = 2*diag(mask)*D';    % constant matrix
dconst = ((D.^2)*mask)'; % constant in distance calculation for each data sample 
                         % W2 = ones(munits,1)*mask'; D2 = (D'.^2); 		      

% initialize tracking
start = clock;
if floor(trainlen)>=1
    qe = zeros(floor(trainlen),1);
else
    qe = zeros(1,1);
end    
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

% With the 'blen' parameter you can control the memory consumption 
% of the algorithm, which is in practive directly proportional
% to munits*blen. If you're having problems with memory, try to 
% set the value of blen lower. 
blen = min(munits,dlen);

% reserve some space
bmus = zeros(1,dlen); 
ddists = zeros(1,dlen); 

printedbytes = 0; % See tracking subfunction

for t = 1:trainlen,  

  % batchy train - this is done a block of data (inds) at a time
  % rather than in a single sweep to save memory consumption. 
  % The 'Dist' and 'Hw' matrices have size munits*blen
  % which - if you have a lot of data - would be HUGE if you 
  % calculated it all at once. A single-sweep version would 
  % look like this: 
  %  Dist = (M.^2)*W1 - M*WD; %+ W2*D2 
  %  [ddists, bmus] = min(Dist);
  % (notice that the W2*D2 term can be ignored since it is constant)
  % This "batchy" version is the same as single-sweep if blen=dlen. 
  i0 = 0;     
  while i0+1<=dlen, 
    inds = [(i0+1):min(dlen,i0+blen)]; i0 = i0+blen;      
    Dist = (M.^2)*W1(:,inds) - M*WD(:,inds);
    [ddists(inds), bmus(inds)] = min(Dist);
  end  
  
  
  
  % tracking
  if tracking > 0,
    ddists = ddists+dconst; % add the constant term
    ddists(ddists<0) = 0;   % rounding errors...
    qe(t) = mean(sqrt(ddists));
    printedbytes = trackplot(M,D,tracking,start,t,qe,printedbytes);
  end
  
  % neighborhood 
  % notice that the elements Ud and radius have been squared!
  % note: 'bubble' matches the original "Batch Map" algorithm
  switch sTrain.neigh, 
   case 'bubble',   H = (Ud<=radius(t)); 
   case 'gaussian', H = exp(-Ud/(2*radius(t))); 
   case 'cutgauss', H = exp(-Ud/(2*radius(t))) .* (Ud<=radius(t));
   case 'ep',       H = (1-Ud/radius(t)) .* (Ud<=radius(t));
  end  
  
  % update 

  % In principle the updating step goes like this: replace each map unit 
  % by the average of the data vectors that were in its neighborhood.
  % The contribution, or activation, of data vectors in the mean can 
  % be varied with the neighborhood function. This activation is given 
  % by matrix H. So, for each map unit the new weight vector is
  %
  %      m = sum_i (h_i * d_i) / sum_i (h_i), 
  % 
  % where i denotes the index of data vector.  Since the values of
  % neighborhood function h_i are the same for all data vectors belonging to
  % the Voronoi set of the same map unit, the calculation is actually done
  % by first calculating a partition matrix P with elements p_ij=1 if the
  % BMU of data vector j is i.

  P = sparse(bmus,[1:dlen],weights,munits,dlen);
       
  % Then the sum of vectors in each Voronoi set are calculated (P*D) and the
  % neighborhood is taken into account by calculating a weighted sum of the
  % Voronoi sum (H*). The "activation" matrix A is the denominator of the 
  % equation above.
  
  S = H*(P*D); 
  A = H*(P*Known);
  
  % If you'd rather make this without using the Voronoi sets try the following: 
  %   Hi = H(:,bmus); 
  %   S = Hi * D;            % "sum_i (h_i * d_i)"
  %   A = Hi * Known;        % "sum_i (h_i)"
  % The bad news is that the matrix Hi has size [munits x dlen]... 
    
  % only update units for which the "activation" is nonzero
  nonzero = find(A > 0); 
  M(nonzero) = S(nonzero) ./ A(nonzero); 

end; % for t = 1:trainlen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build / clean up the return arguments

% tracking
% if tracking > 0, fprintf(1,'\n'); end

% update structures
sTrain = som_set(sTrain,'time',datestr(now,0));
if struct_mode, 
  sMap = som_set(sMap,'codebook',M,'mask',sTrain.mask,'neigh',sTrain.neigh);
  tl = length(sMap.trainhist);
  sMap.trainhist(tl+1) = sTrain;
else
  sMap = reshape(M,orig_size);
end

return;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

%%%%%%%%
function [count] = trackplot(M,D,tracking,start,n,qe,printedbytes)

  l = length(qe);
  elap_t = etime(clock,start); 
  tot_t = elap_t*l/n;
  % Carriage return does not work as it should (even on UNIX) when printing
  % to screen, so let's do this instead
  % fprintf(1, repmat('\b', 1, printedbytes));
  count = 0; %fprintf(1,'Training: %3.0f/ %3.0f s',elap_t,tot_t);  
  switch tracking
   case 1, 
   case 2,   
    plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
    title('Quantization error after each epoch');
    drawnow
   otherwise,
    subplot(2,1,1), plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
    title('Quantization error after each epoch');
    subplot(2,1,2), plot(M(:,1),M(:,2),'ro',D(:,1),D(:,2),'b+'); 
    title('First two components of map units (o) and data vectors (+)');
    drawnow
    
  end
  % end of trackplot
  tracking_in_progress = 1;
end
