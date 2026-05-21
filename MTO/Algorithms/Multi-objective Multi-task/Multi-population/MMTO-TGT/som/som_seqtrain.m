function [sMap, sTrain] = som_seqtrain(sMap, D, varargin)

%SOM_SEQTRAIN  Use sequential algorithm to train the Self-Organizing Map.
%
% [sM,sT] = som_seqtrain(sM, D, [[argID,] value, ...])
% 
%  sM     = som_seqtrain(sM,D);
%  sM     = som_seqtrain(sM,sD,'alpha_type','power','tracking',3);
%  [M,sT] = som_seqtrain(M,D,'ep','trainlen',10,'inv','hexa');
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
%   'mask'        (vector) BMU search mask, size dim x 1
%   'msize'       (vector) map size
%   'radius'      (vector) neighborhood radiuses, length 1, 2 or trainlen
%   'radius_ini'  (scalar) initial training radius
%   'radius_fin'  (scalar) final training radius
%   'alpha'       (vector) learning rates, length trainlen
%   'alpha_ini'   (scalar) initial learning rate
%   'tracking'    (scalar) tracking level, 0-3 
%   'trainlen'    (scalar) training length
%   'trainlen_type' *(string) is the given trainlen 'samples' or 'epochs'
%   'train'      *(struct) train struct, parameters for training
%   'sTrain','som_train '  = 'train'
%   'alpha_type' *(string) learning rate function, 'inv', 'linear' or 'power'
%   'sample_order'*(string) order of samples: 'random' or 'ordered'
%   'neigh'      *(string) neighborhood function, 'gaussian', 'cutgauss',
%                          'ep' or 'bubble'
%   'topol'      *(struct) topology struct
%   'som_topol','sTopo l'  = 'topol'
%   'lattice'    *(string) map lattice, 'hexa' or 'rect'
%   'shape'      *(string) map shape, 'sheet', 'cyl' or 'toroid'
%
% For more help, try 'type som_seqtrain' or check out online documentation.
% See also  SOM_MAKE, SOM_BATCHTRAIN, SOM_TRAIN_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_seqtrain
%
% PURPOSE
%
% Trains a Self-Organizing Map using the sequential algorithm. 
%
% SYNTAX
%
%  sM = som_seqtrain(sM,D);
%  sM = som_seqtrain(sM,sD);
%  sM = som_seqtrain(...,'argID',value,...);
%  sM = som_seqtrain(...,value,...);
%  [sM,sT] = som_seqtrain(M,D,...);
%
% DESCRIPTION
%
% Trains the given SOM (sM or M above) with the given training data
% (sD or D) using sequential SOM training algorithm. If no optional
% arguments (argID, value) are given, a default training is done, the
% parameters are obtained from SOM_TRAIN_STRUCT function. Using
% optional arguments the training parameters can be specified. Returns
% the trained and updated SOM and a train struct which contains
% information on the training.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 78-82.
% Kohonen, T., "Clustering, Taxonomy, and Topological Maps of
%    Patterns", International Conference on Pattern Recognition
%    (ICPR), 1982, pp. 114-128.
% Kohonen, T., "Self-Organized formation of topologically correct
%    feature maps", Biological Cybernetics 43, 1982, pp. 59-69.
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
%   'alpha'      (vector) learning rate
%                         length = 1: alpha_ini = alpha
%                         length > 1: the vector gives learning rate
%                                     for each step separately
%                                     trainlen is set to length(alpha)
%                                     alpha_type is set to 'user defined'
%   'alpha_ini'  (scalar) initial learning rate
%   'tracking'   (scalar) tracking level: 0, 1 (default), 2 or 3
%                         0 - estimate time 
%                         1 - track time and quantization error 
%                         2 - plot quantization error
%                         3 - plot quantization error and two first 
%                             components 
%   'trainlen'   (scalar) training length (see also 'tlen_type')
%   'trainlen_type' *(string) is the trainlen argument given in 'epochs'
%                         or in 'samples'. Default is 'epochs'.
%   'sample_order'*(string) is the sample order 'random' (which is the 
%                         the default) or 'ordered' in which case
%                         samples are taken in the order in which they 
%                         appear in the data set
%   'train'     *(struct) train struct, parameters for training. 
%                         Default parameters, unless specified, 
%                         are acquired using SOM_TRAIN_STRUCT (this 
%                         also applies for 'trainlen', 'alpha_type',
%                         'alpha_ini', 'radius_ini' and 'radius_fin').
%   'sTrain', 'som_train' (struct) = 'train'
%   'neigh'     *(string) The used neighborhood function. Default is 
%                         the one in sM (field '.neigh') or 'gaussian'
%                         if only a codebook matrix was given. Other 
%                         possible values is 'cutgauss', 'ep' and 'bubble'.
%   'topol'     *(struct) topology of the map. Default is the one
%                         in sM (field '.topol').
%   'sTopol', 'som_topol' (struct) = 'topol'
%   'alpha_type'*(string) learning rate function, 'inv', 'linear' or 'power'
%   'lattice'   *(string) map lattice. Default is the one in sM
%                         (field sM.topol.lattice) or 'rect' 
%                         if only a codebook matrix was given. 
%   'shape'     *(string) map shape. Default is the one in sM
%                         (field sM.topol.shape) or 'sheet' 
%                         if only a codebook matrix was given. 
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
%  sM = som_seqtrain(sM,D);  
%  sM = som_seqtrain(sM,sD);  
%
% To change the tracking level, 'tracking' argument is specified:
%  sM = som_seqtrain(sM,D,'tracking',3);
%
% The change training parameters, the optional arguments 'train', 
% 'neigh','mask','trainlen','radius','radius_ini', 'radius_fin', 
% 'alpha', 'alpha_type' and 'alpha_ini' are used. 
%  sM = som_seqtrain(sM,D,'neigh','cutgauss','trainlen',10,'radius_fin',0);
%
% Another way to specify training parameters is to create a train struct:
%  sTrain = som_train_struct(sM,'dlen',size(D,1),'algorithm','seq');
%  sTrain = som_set(sTrain,'neigh','cutgauss');
%  sM = som_seqtrain(sM,D,sTrain);
%
% By default the neighborhood radius goes linearly from radius_ini to
% radius_fin. If you want to change this, you can use the 'radius' argument
% to specify the neighborhood radius for each step separately:
%  sM = som_seqtrain(sM,D,'radius',[5 3 1 1 1 1 0.5 0.5 0.5]);
%
% By default the learning rate (alpha) goes from the alpha_ini to 0
% along the function defined by alpha_type. If you want to change this, 
% you can use the 'alpha' argument to specify the learning rate
% for each step separately: 
%  alpha = 0.2*(1 - log([1:100]));
%  sM = som_seqtrain(sM,D,'alpha',alpha);
%
% You don't necessarily have to use the map struct, but you can operate
% directly with codebook matrices. However, in this case you have to
% specify the topology of the map in the optional arguments. The
% following commads are identical (M is originally a 200 x dim sized matrix):
%  M = som_seqtrain(M,D,'msize',[20 10],'lattice','hexa','shape','cyl');
%
%  M = som_seqtrain(M,D,'msize',[20 10],'hexa','cyl');
%
%  sT= som_set('som_topol','msize',[20 10],'lattice','hexa','shape','cyl');
%  M = som_seqtrain(M,D,sT);
%
%  M = reshape(M,[20 10 dim]);
%  M = som_seqtrain(M,D,'hexa','cyl');
%
% The som_seqtrain also returns a train struct with information on the 
% accomplished training. This is the same one as is added to the end of the 
% trainhist field of map struct, in case a map struct is given.
%  [M,sTrain] = som_seqtrain(M,D,'msize',[20 10]);
%
%  [sM,sTrain] = som_seqtrain(sM,D); % sM.trainhist{end}==sTrain
%
% SEE ALSO
% 
%  som_make         Initialize and train a SOM using default parameters.
%  som_batchtrain   Train SOM with batch algorithm.
%  som_train_struct Determine default training parameters.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 220997
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
D = D(find(sum(isnan(D),2) < dim),:); % remove empty vectors from the data
[dlen ddim] = size(D);                % check input dimension
if dim ~= ddim, error('Map and data input space dimensions disagree.'); end

% varargin
sTrain = som_set('som_train','algorithm','seq','neigh', ...
		 sMap.neigh,'mask',sMap.mask,'data_name',data_name);
radius     = [];
alpha      = [];
tracking   = 1;
sample_order_type = 'random';
tlen_type  = 'epochs';

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
     case 'trainlen_type', i=i+1; tlen_type = varargin{i}; 
     case 'tracking', i=i+1; tracking = varargin{i};
     case 'sample_order', i=i+1; sample_order_type = varargin{i};
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
        if l>2, radius = varargin{i}; tlen_type = 'samples'; end
      end 
     case 'alpha_type', i=i+1; sTrain.alpha_type = varargin{i};
     case 'alpha_ini', i=i+1; sTrain.alpha_ini = varargin{i};
     case 'alpha',     
      i=i+1; 
      sTrain.alpha_ini = varargin{i}(1);
      if length(varargin{i})>1, 
        alpha = varargin{i}; tlen_type = 'samples'; 
        sTrain.alpha_type = 'user defined'; 
      end
     case {'sTrain','train','som_train'}, i=i+1; sTrain = varargin{i};
     case {'topol','sTopol','som_topol'}, 
      i=i+1; 
      sTopol = varargin{i};
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
      % unambiguous values
     case {'inv','linear','power'}, sTrain.alpha_type = varargin{i}; 
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i}; 
     case {'gaussian','cutgauss','ep','bubble'}, sTrain.neigh = varargin{i};
     case {'epochs','samples'}, tlen_type = varargin{i};
     case {'random', 'ordered'}, sample_order_type = varargin{i}; 
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
    disp(['(som_seqtrain) Ignoring invalid argument #' num2str(i+2)]); 
  end
  i = i+1; 
end

% training length
if ~isempty(radius) || ~isempty(alpha), 
  lr = length(radius);
  la = length(alpha);
  if lr>2 || la>1,
    tlen_type = 'samples';
    if     lr> 2 && la<=1, sTrain.trainlen = lr;
    elseif lr<=2 && la> 1, sTrain.trainlen = la;
    elseif lr==la,        sTrain.trainlen = la;
    else
      error('Mismatch between radius and learning rate vector lengths.')
    end
  end
end
if strcmp(tlen_type,'samples'), sTrain.trainlen = sTrain.trainlen/dlen; end 

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
trainlen = sTrain.trainlen*dlen;

% neighborhood radius
if length(radius)>2,
  radius_type = 'user defined';
else
  radius = [sTrain.radius_ini sTrain.radius_fin];    
  rini = radius(1); 
  rstep = (radius(end)-radius(1))/(trainlen-1);
  radius_type = 'linear';
end    

% learning rate
if length(alpha)>1, 
  sTrain.alpha_type ='user defined';
  if ~(abs(length(alpha)-trainlen) < ...
          1e4*eps(min(abs(length(alpha)),abs(trainlen)))),
    error('Trainlen and length of neighborhood radius vector do not match.')
  end
  if any(isnan(alpha)), 
    error('NaN is an illegal learning rate.')
  end
else
  if isempty(alpha), alpha = sTrain.alpha_ini; end
  if strcmp(sTrain.alpha_type,'inv'), 
    % alpha(t) = a / (t+b), where a and b are chosen suitably
    % below, they are chosen so that alpha_fin = alpha_ini/100
    b = (trainlen - 1) / (100 - 1);
    a = b * alpha;
  end
end
                                   
% initialize random number generator
rand('state',sum(100*clock));

% distance between map units in the output space
%  Since in the case of gaussian and ep neighborhood functions, the 
%  equations utilize squares of the unit distances and in bubble case
%  it doesn't matter which is used, the unitdistances and neighborhood
%  radiuses are squared.
Ud = som_unit_dists(sTopol).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

update_step = 100; 
mu_x_1 = ones(munits,1);
samples = ones(update_step,1);
r = samples; 
alfa = samples;

qe = 0;
start = clock;
if tracking >  0, % initialize tracking
  track_table = zeros(update_step,1);
  qe = zeros(floor(trainlen/update_step),1);  
end

printedbytes = 0;

for t = 1:trainlen, 

  % Every update_step, new values for sample indeces, neighborhood
  % radius and learning rate are calculated. This could be done
  % every step, but this way it is more efficient. Or this could 
  % be done all at once outside the loop, but it would require much
  % more memory.
  ind = rem(t,update_step); if ind==0, ind = update_step; end
  if ind==1, 
    steps = [t:min(trainlen,t+update_step-1)];
    % sample order    
    switch sample_order_type, 
     case 'ordered', samples = rem(steps,dlen)+1;
     case 'random',  samples = ceil(dlen*rand(update_step,1)+eps);
    end

    % neighborhood radius
    switch radius_type, 
     case 'linear',       r = rini+(steps-1)*rstep;
     case 'user defined', r = radius(steps); 
    end    
    r=r.^2;        % squared radius (see notes about Ud above)
    r(r==0) = eps; % zero radius might cause div-by-zero error
    
    % learning rate
    switch sTrain.alpha_type,
     case 'linear',       alfa = (1-steps/trainlen)*alpha;
     case 'inv',          alfa = a ./ (b + steps-1);
     case 'power',        alfa = alpha * (0.005/alpha).^((steps-1)/trainlen); 
     case 'user defined', alfa = alpha(steps);
    end    
  end
  
  % find BMU
  x = D(samples(ind),:);                 % pick one sample vector
  known = ~isnan(x);                     % its known components
  Dx = M(:,known) - x(mu_x_1,known);     % each map unit minus the vector
  [qerr bmu] = min((Dx.^2)*mask(known)); % minimum distance(^2) and the BMU

  % tracking
%   if tracking>0, 
%     track_table(ind) = sqrt(qerr);
%     if ind==update_step, 
%       n = ceil(t/update_step); 
%       qe(n) = mean(track_table);
%       printedbytes = trackplot(M,D,tracking,start,n,qe,printedbytes);
%     end
%   end
  
  % neighborhood & learning rate
  % notice that the elements Ud and radius have been squared!
  % (see notes about Ud above)
  switch sTrain.neigh, 
  case 'bubble',   h = (Ud(:,bmu)<=r(ind));
  case 'gaussian', h = exp(-Ud(:,bmu)/(2*r(ind))); 
  case 'cutgauss', h = exp(-Ud(:,bmu)/(2*r(ind))) .* (Ud(:,bmu)<=r(ind));
  case 'ep',       h = (1-Ud(:,bmu)/r(ind)) .* (Ud(:,bmu)<=r(ind));
  end  
  h = h*alfa(ind);  
  
  % update M
  M(:,known) = M(:,known) - h(:,ones(sum(known),1)).*Dx;

end; % for t = 1:trainlen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build / clean up the return arguments

%if tracking, fprintf(1,'\n'); end

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

%%%%%%%%
% function [count] = trackplot(M,D,tracking,start,n,qe, printedbytes)
% 
%   l = length(qe);
%   elap_t = etime(clock,start); 
%   tot_t = elap_t*l/n;
%   % Carriage return does not work as it should (even on UNIX) when printing
%   % to screen, so let's do this instead
%   fprintf(1, repmat('\b', 1, printedbytes));
%   count = fprintf(1,'Training: %3.0f/ %3.0f s',elap_t,tot_t);  
%   switch tracking
%    case 1, 
%    case 2,       
%     plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
%     title('Quantization errors for latest samples')    
%     drawnow
%    otherwise,
%     subplot(2,1,1), plot(1:n,qe(1:n),(n+1):l,qe((n+1):l))
%     title('Quantization error for latest samples');
%     subplot(2,1,2), plot(M(:,1),M(:,2),'ro',D(:,1),D(:,2),'b.'); 
%     title('First two components of map units (o) and data vectors (+)');
%     drawnow
%   end  
  % end of trackplot

