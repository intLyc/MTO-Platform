function [sMap, sTrain] = som_sompaktrain(sMap, D, varargin)

%SOM_SOMPAKTRAIN  Use SOM_PAK to train the Self-Organizing Map.
%
% [sM,sT] = som_sompaktrain(sM, D, [[argID,] value, ...])
% 
%  sM     = som_sompaktrain(sM,D);
%  sM     = som_sompaktrain(sM,sD,'alpha_type','inv');
%  [M,sT] = som_sompaktrain(M,D,'bubble','trainlen',10,'inv','hexa');
%
%  Input and output arguments ([]'s are optional): 
%   sM      (struct) map struct, the trained and updated map is returned
%           (matrix) codebook matrix of a self-organizing map
%                    size munits x dim or  msize(1) x ... x msize(k) x dim
%                    The trained map codebook is returned.
%   D       (struct) training data; data struct
%           (matrix) training data, size dlen x dim
%           (string) name of data file
%   [argID, (string) See below. The values which are unambiguous can 
%    value] (varies) be given without the preceeding argID.
%
%   sT      (struct) learning parameters used during the training
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'msize'        (vector) map size
%   'radius_ini'   (scalar) neighborhood radius
%   'radius' = 'radius_ini'
%   'alpha_ini'    (scalar) initial learning rate
%   'alpha' = 'alpha_ini'
%   'trainlen'     (scalar) training length
%   'seed'         (scalar) seed for random number generator
%   'snapfile'     (string) base name for snapshot files
%   'snapinterval' (scalar) snapshot interval
%   'tlen_type'   *(string) is the given trainlen 'samples' or 'epochs'
%   'train'       *(struct) train struct, parameters for training
%   'sTrain','som_train' = 'train'
%   'alpha_type'  *(string) learning rate function, 'inv' or 'linear'
%   'neigh'       *(string) neighborhood function, 'gaussian' or 'bubble'
%   'topol'       *(struct) topology struct
%   'som_topol','sTopol' = 'topol'
%   'lattice'     *(string) map lattice, 'hexa' or 'rect'
%
% For more help, try 'type som_sompaktrain' or check out online documentation.
% See also  SOM_MAKE, SOM_SEQTRAIN, SOM_BATCHTRAIN, SOM_TRAIN_STRUCT.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_sompaktrain
%
% PURPOSE
%
% Use SOM_PAK to train the Self-Organizing Map.
%
% SYNTAX
%
%  sM = som_sompaktrain(sM,D);
%  sM = som_sompaktrain(sM,sD);
%  sM = som_sompaktrain(...,'argID',value,...);
%  sM = som_sompaktrain(...,value,...);
%  [sM,sT] = som_sompaktrain(M,D,...);
%
% DESCRIPTION
%
% Trains the given SOM (sM or M above) with the given training data (sD or
% D) using SOM_PAK. If no optional arguments (argID, value) are
% given, a default training is done, the parameters are obtained from
% SOM_TRAIN_STRUCT function.  Using optional arguments the training
% parameters can be specified. Returns the trained and updated SOM and a
% train struct which contains information on the training.
%
% Notice that the SOM_PAK program 'vsom' must be in the search path of your
% shell. Alternatively, you can set a variable 'SOM_PAKDIR' in the Matlab
% workspace to tell the som_sompaktrain where to find the 'vsom' program.
%
% Notice also that many of the training parameters are much more limited in
% values than when using SOM Toolbox function for training:
%   - the map shape is always 'sheet'
%   - only initial value for neighborhood radius can be given
%   - neighborhood function can only be 'bubble' or 'gaussian'
%   - only initial value for learning rate can be given
%   - learning rate can only be 'linear' or 'inv'
%   - mask cannot be used: all variables are always used in BMU search
% Any parameters not confirming to these restrictions will be converted
% so that they do before training. On the other hand, there are some 
% additional options that are not present in the SOM Toolbox: 
%   - random seed
%   - snapshot file and interval
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
%     (string) name of data file
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
%   'msize'        (vector) map grid dimensions. Default is the one
%                           in sM (field sM.topol.msize) or 
%                           'si = size(sM); msize = si(1:end-1);' 
%                           if only a codebook matrix was given. 
%   'radius_ini'   (scalar) initial neighborhood radius 
%   'radius'       (scalar) = 'radius_ini'
%   'alpha_ini'    (vector) initial learning rate
%   'alpha'        (scalar) = 'alpha_ini'
%   'trainlen'     (scalar) training length (see also 'tlen_type')
%   'seed'         (scalar) seed for random number generator
%   'snapfile'     (string) base name for snapshot files
%   'snapinterval' (scalar) snapshot interval
%   'tlen_type'   *(string) is the trainlen argument given in 'epochs' or
%                           in 'samples'. Default is 'epochs'.
%   'train'       *(struct) train struct, parameters for training. 
%                           Default parameters, unless specified, 
%                           are acquired using SOM_TRAIN_STRUCT (this 
%                           also applies for 'trainlen', 'alpha_type',
%                           'alpha_ini', 'radius_ini' and 'radius_fin').
%   'sTrain', 'som_topol' (struct) = 'train'
%   'neigh'       *(string) The used neighborhood function. Default is 
%                           the one in sM (field '.neigh') or 'gaussian'
%                           if only a codebook matrix was given. The other 
%                           possible value is 'bubble'.
%   'topol'       *(struct) topology of the map. Default is the one
%                           in sM (field '.topol').
%   'sTopol', 'som_topol' (struct) = 'topol'
%   'alpha_type'  *(string) learning rate function, 'inv' or 'linear'
%   'lattice'     *(string) map lattice. Default is the one in sM
%                           (field sM.topol.lattice) or 'rect' 
%                           if only a codebook matrix was given. 
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
%  sM = som_sompaktrain(sM,D);  
%  sM = som_sompaktrain(sM,sD);  
%
% The change training parameters, the optional arguments 'train', 
% 'neigh','mask','trainlen','radius','radius_ini', 'alpha', 
% 'alpha_type' and 'alpha_ini' are used. 
%  sM = som_sompaktrain(sM,D,'bubble','trainlen',10,'radius_ini',3);
%
% Another way to specify training parameters is to create a train struct:
%  sTrain = som_train_struct(sM,'dlen',size(D,1),'algorithm','seq');
%  sTrain = som_set(sTrain,'neigh','gaussian');
%  sM = som_sompaktrain(sM,D,sTrain);
%
% You don't necessarily have to use the map struct, but you can operate
% directly with codebook matrices. However, in this case you have to
% specify the topology of the map in the optional arguments. The
% following commads are identical (M is originally a 200 x dim sized matrix):
%  M = som_sompaktrain(M,D,'msize',[20 10],'lattice','hexa');
%
%  M = som_sompaktrain(M,D,'msize',[20 10],'hexa');
%
%  sT= som_set('som_topol','msize',[20 10],'lattice','hexa');
%  M = som_sompaktrain(M,D,sT);
%
%  M = reshape(M,[20 10 dim]);
%  M = som_sompaktrain(M,D,'hexa');
%
% The som_sompaktrain also returns a train struct with information on the 
% accomplished training. This is the same one as is added to the end of the 
% trainhist field of map struct, in case a map struct is given.
%  [M,sTrain] = som_sompaktrain(M,D,'msize',[20 10]);
%
%  [sM,sTrain] = som_sompaktrain(sM,D); % sM.trainhist(end)==sTrain
%
% SEE ALSO
% 
%  som_make         Initialize and train a SOM using default parameters.
%  som_seqtrain     Train SOM with sequential algorithm.
%  som_batchtrain   Train SOM with batch algorithm.
%  som_train_struct Determine default training parameters.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 151199
 
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
givendatafile = '';
if ischar(D), 
  data_name = D; 
  givendatafile = D;
  D = [];
  dlen = NaN;
else
  if isstruct(D), 
    data_name = D.name; 
    D = D.data;   
  else
    data_name = inputname(2); 
  end
  D = D(find(sum(isnan(D),2) < dim),:); % remove empty vectors from the data
  [dlen ddim] = size(D);                % check input dimension
  if ddim ~= dim, error('Map and data dimensions must agree.'); end
end

% varargin
sTrain = som_set('som_train','algorithm','seq',...
			     'neigh',sMap.neigh,...
			     'mask',ones(dim,1),...
			     'data_name',data_name);
tlen_type  = 'epochs';
random_seed = 0; 
snapshotname = ''; 
snapshotinterval = 0;

i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     % argument IDs
     case 'msize',       i=i+1; sTopol.msize = varargin{i}; 
     case 'lattice',     i=i+1; sTopol.lattice = varargin{i};
     case 'neigh',       i=i+1; sTrain.neigh = varargin{i};
     case 'trainlen',    i=i+1; sTrain.trainlen = varargin{i};
     case 'tlen_type',   i=i+1; tlen_type = varargin{i}; 
     case 'radius_ini',  i=i+1; sTrain.radius_ini = varargin{i};
     case 'radius',      i=i+1; sTrain.radius_ini = varargin{i}(1);
     case 'alpha_type',  i=i+1; sTrain.alpha_type = varargin{i};
     case 'alpha_ini',   i=i+1; sTrain.alpha_ini = varargin{i};
     case 'alpha',       i=i+1; sTrain.alpha_ini = varargin{i}(1);
     case 'seed',        i=i+1; random_seed = varargin{i};
     case 'snapshotname',i=i+1; snapshotname = varargin{i};
     case 'snapshotinterval',i=i+1; snapshotinterval = varargin{i};
     case {'sTrain','train','som_train'}, i=i+1; sTrain = varargin{i};
     case {'topol','sTopol','som_topol'}, 
      i=i+1; 
      sTopol = varargin{i};
      if prod(sTopol.msize) ~= munits, 
        error('Given map grid size does not match the codebook size.');
      end
      % unambiguous values
     case {'inv','linear'}, sTrain.alpha_type = varargin{i}; 
     case {'hexa','rect'}, sTopol.lattice = varargin{i};
     case {'gaussian','bubble'}, sTrain.neigh = varargin{i};
     case {'epochs','samples'}, tlen_type = varargin{i};
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
    disp(['(som_sompaktrain) Ignoring invalid argument #' num2str(i+2)]); 
  end
  i = i+1; 
end

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
if ~isnan(dlen), 
  sTrain = som_train_struct(sTrain,sMap,'dlen',dlen);
else
  sTrain = som_train_struct(sTrain,sMap); 
end
if isempty(sTrain.mask), sTrain.mask = ones(dim,1); end

% training length
if strcmp(tlen_type,'epochs'), 
  if isnan(dlen),   
    error('Training length given as epochs, but data length is not known.\n');
  else
    rlen = sTrain.trainlen*dlen;
  end
else
  rlen = sTrain.trainlen;
  sTrain.trainlen = sTrain.trainlen/dlen;   
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% mask
if any(sTrain.mask~=1), 
  sTrain.mask = ones(dim,1); 
  fprintf(1,'Ignoring given mask.\n');
end

% learning rate
if strcmp(sTrain.alpha_type,'power'), 
  sTrain.alpha_type = 'inv';
  fprintf(1,'Using ''inv'' learning rate type instead of ''power''\n');
end
  
% neighborhood
if any(strcmp(sTrain.neigh,{'cutgauss','ep'})), 
  fprintf(1,'Using ''gaussian'' neighborhood function instead of %s.\n',sTrain.neigh);
  sTrain.neigh = 'gaussian'; 
end

% map shape
if ~strcmp(sMap.topol.shape,'sheet'), 
  fprintf(1,'Using ''sheet'' map shape of %s.\n',sMap.topol.shape);
  sMap.topol.shape = 'sheet'; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

% write files
if ~isempty(givendatafile), 
  temp_din = givendatafile; 
else 
  temp_din = tempname; 
  som_write_data(D, temp_din, 'x')
end
temp_cin  = tempname;
som_write_cod(sMap, temp_cin)
temp_cout = tempname;

% check if the environment variable 'SOM_PAKDIR' has been defined
if any(strcmp('SOM_PAKDIR', evalin('base', 'who')))
  som_pak_dir = evalin('base', 'SOM_PAKDIR');
else
  som_pak_dir = '';
end
if ~isempty(som_pak_dir) && ~strncmp(som_pak_dir(end), '/', 1)
  som_pak_dir(end + 1) = '/';
end

aini  = sTrain.alpha_ini; 
atype = sTrain.alpha_type;
if strcmp(atype,'inv'), atype = 'inverse_t'; end
rad   = sTrain.radius_ini;
str = [som_pak_dir 'vsom ' ...
       sprintf('-cin %s -din %s -cout %s', temp_cin, temp_din, temp_cout) ...
       sprintf(' -rlen %d -alpha %g -alpha_type %s', rlen, aini, atype) ...
       sprintf(' -radius %g -rand %g ',rad,random_seed)];
if ~isempty(snapshotname) && snapinterval>0, 
  str = [str, sprintf(' -snapfile %s -snapinterval %d',snapshotname,snapshotinterval)];
end

fprintf(1,'Execute: %s\n',str);
if isunix, 
  [status,w] = unix(str); 
  if status, fprintf(1,'Execution failed.\n'); end
  if ~isempty(w), fprintf(1,'%s\n',w); end
else 
  [status,w] = dos(str); 
  if status, fprintf(1,'Execution failed.\n'); end
  if ~isempty(w), fprintf(1,'%s\n',w); end
end

sMap_temp = som_read_cod(temp_cout);
M = sMap_temp.codebook;

if isunix
  unix(['/bin/rm -f ' temp_din ' ' temp_cin ' ' temp_cout]);
else
  dos(['del ' temp_din ' ' temp_cin ' ' temp_cout]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build / clean up the return arguments

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

