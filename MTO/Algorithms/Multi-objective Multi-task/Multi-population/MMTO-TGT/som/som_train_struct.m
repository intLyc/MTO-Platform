function sTrain = som_train_struct(varargin)

%SOM_TRAIN_STRUCT Default values for SOM training parameters.
%
% sT = som_train_struct([[argID,] value, ...])
%
%  sTrain = som_train_struct('train',sM,sD);
%  sTrain = som_train_struct('finetune','data',D); 
%  sTrain = som_train_struct('previous',sT0);
% 
%  Input and output arguments ([]'s are optional): 
%    [argID,  (string) Several default values depend on other SOM parameters
%     value]  (varies) or on the proporties of a data set. See below for a
%                      a list of required and optional arguments for
%                      different parameters, and well as the list of valid 
%                      argIDs and associated values. The values which are 
%                      unambiguous can be given without the preceeding argID.
%
%    sT       (struct) The training struct.
%
% Training struct contains values for training and initialization
% parameters. These parameters depend on the number of training samples,
% phase of training, the training algorithm.
% 
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding rgID.
%  'dim'          (scalar) input space dimension
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix / struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'previous'     (struct) previous training struct can be given in 
%                          conjunction with 'finetune' phase (see below) 
%  'phase'       *(string) training phase: 'init', 'train', 'rough' or 'finetune'
%  'algorithm'   *(string) algorithm to use: 'lininit', 'randinit', 'batch' or 'seq'
%  'map'         *(struct) If a map struct is given, the last training struct
%                          in '.trainhist' field is used as the previous training
%                          struct. The map size and input space dimension are 
%                          extracted from the map struct.
%  'sTrain'      *(struct) a train struct, the empty fields of which are
%                          filled with sensible values
%
% For more help, try 'type som_train_struct' or check out online documentation.
% See also SOM_SET, SOM_TOPOL_STRUCT, SOM_MAKE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_train_struct
%
% PURPOSE
%
% Default values for SOM training parameters.
%
% SYNTAX
%
%  sT = som_train_struct('argID',value,...);
%  sT = som_train_struct(value,...);
%
% DESCRIPTION
%
% This function is used to give sensible values for SOM training
% parameters and returns a training struct. Often, the parameters
% depend on the properties of the map and the training data. These are
% given as optional arguments to the function. If a partially filled
% train struct is given, its empty fields (field value is [] or '' or
% NaN) are supplimented with default values.
%
% The training struct has a number of fields which depend on each other
% and the optional arguments in complex ways. The most important argument 
% is 'phase' which can be either 'init', 'train', 'rough' or 'finetune'.
%
%  'init'     Map initialization. 
%  'train'    Map training in a onepass operation, as opposed to the
%             rough-finetune combination.
%  'rough'    Rough organization of the map: large neighborhood, big
%             initial value for learning coefficient. Short training.
%  'finetune' Finetuning the map after rough organization phase. Small
%             neighborhood, learning coefficient is small already at 
%             the beginning. Long training.
%
% The fields of training struct set by this function are listed below.
%
%  '.mask'  Basically, a column vector of ones. But if a previous
%           train or map struct is given, it is copied from there.
%  '.neigh' Default value is 'gaussian' but if a previous train or map 
%           struct is given, it is copied from there.
%  '.alpha_type' Default value is 'inv' but if a previous training struct 
%           is given, it is copied from there.
%  '.alpha_ini' For 'train' and 'rough' phases, this is 0.5, for
%           'finetune' it is 0.05.
%  '.radius_ini' Depends on the previous training operation and the 
%           maximum sidelength of the map ms = max(msize).
%           if there isn't one, or it is 'randinit', rad_ini = max(1,ms/2)
%           if it is 'lininit', rad_ini = max(1,ms/8)
%           otherwise, rad_ini = rad_fin of the previous training
%  '.radius_fin' Default value is 1, but if the training phase is
%           'rough', rad_fin = max(1,rad_ini/4).
%  '.trainlen' For 'train' phase this is 20 x mpd epochs, for 'rough'
%           phase 4 x mpd epochs and for 'finetune' 16 x mpd
%           epochs, where mpd = munits/dlen. If mpd cannot be
%           calculated, it is set to be = 0.5. In any case,
%           trainlen is at least one epoch.
%  '.algorithm' Default training algorithm is 'batch' and default
%           initialization algorithm is 'lininit'.
%
% OPTIONAL INPUT ARGUMENTS 
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is used.  The
%  valid IDs and corresponding values are listed below. The values
%  which are unambiguous (marked with '*') can be given without the
%  preceeding argID.
%
%  'dim'          (scalar) input space dimension
%  'dlen'         (scalar) length of the training data
%  'data'         (matrix / struct) the training data
%  'munits'       (scalar) number of map units
%  'msize'        (vector) map size
%  'previous'     (struct) previous training struct can be given in 
%                  conjunction with 'finetune' phase. 
%  'phase'       *(string) training phase: 'init', 'train', 'rough' or 'finetune'
%  'algorithm'   *(string) algorithm to use: 'lininit', 'randinit', 
%                  'batch' or 'seq'
%  'map'         *(struct) If a map struc is given, the last training struct
%                  in '.trainhist' field is used as the previous training
%                  struct. The map size and input space dimension are 
%                  extracted from the map struct.
%  'sTrain'      *(struct) a train struct, the empty fields of which are
%                  filled with sensible values
%
% OUTPUT ARGUMENTS
% 
%  sT     (struct) The training struct.
%
% EXAMPLES
%
%  The most important optional argument for the training parameters is
%  'phase'. The second most important are 'previous' and/or 'map'. 
%
%  To get default initialization parameters, use: 
%
%    sTrain = som_train_struct('phase','init');
%     or
%    sTrain = som_train_struct('init');
%
%  To get default training parameters, use: 
%
%    sTrain = som_train_struct('phase','train','data',D,'map',sMap);
%     or  
%    sTrain = som_train_struct('train','data',D,sMap);
%     or
%    sTrain = som_train_struct('train','dlen',dlen, ...
%                              'msize',sMap.topol.msize,'dim',dim);
%  
%  If you want to first rough train and then finetune, do like this: 
%
%   sT1 = som_train_struct('rough','dlen',length(D),sMap); % rough training
%   sT2 = som_train_struct('finetune','previous',sT1);     % finetuning
%
% SEE ALSO
%
%  som_make         Initialize and train a map using default parameters.
%  som_topol_struct Default map topology.
%  som_randinint    Random initialization algorithm.
%  som_lininit      Linear initialization algorithm.
%  som_seqtrain     Sequential training algorithm.
%  som_batchtrain   Batch training algorithm.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 101199 090200 210301

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% initial default structs
sTrain = som_set('som_train'); 

% initialize optional parameters
dlen = NaN;
msize = 0; 
munits = NaN;
sTprev = [];
dim = NaN; 
phase = '';

% varargin
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'dim',        i=i+1; dim = varargin{i}; 
     case 'dlen',       i=i+1; dlen = varargin{i}; 
     case 'msize',      i=i+1; msize = varargin{i};
     case 'munits',     i=i+1; munits = varargin{i}; msize = 0; 
     case 'phase',      i=i+1; phase = varargin{i}; 
     case 'algorithm',  i=i+1; sTrain.algorithm = varargin{i}; 
     case 'mask',       i=i+1; sTrain.mask = varargin{i}; 
     case {'previous','map'},   
      i=i+1; 
      if strcmp(varargin{i}.type,'som_map'), 
	if length(varargin{i}.trainhist), 
	  sTprev = varargin{i}.trainhist(end); 
	  msize = varargin{i}.topol.msize;
	end
      elseif strcmp(varargin{i}.type,'som_train'), 
	sTprev = varargin{i}; 
      end
     case 'data',       
      i=i+1; 
      if isstruct(varargin{i}), [dlen dim] = size(varargin{i}.data); 
      else [dlen dim] = size(varargin{i}); 
      end
     case {'init','train','rough','finetune'},  phase = varargin{i};       
     case {'lininit','randinit','seq','batch'}, sTrain.algorithm = varargin{i}; 
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}.type, 
     case 'som_train', 
      sT = varargin{i}; 
      if ~isempty(sT.algorithm),  sTrain.algorithm = sT.algorithm; end
      if ~isempty(sT.neigh),      sTrain.neigh = sT.neigh; end
      if ~isempty(sT.mask),       sTrain.mask = sT.mask; end
      if ~isnan(sT.radius_ini),   sTrain.radius_ini = sT.radius_ini; end
      if ~isnan(sT.radius_fin),   sTrain.radius_fin = sT.radius_fin; end
      if ~isnan(sT.alpha_ini),    sTrain.alpha_ini = sT.alpha_ini; end
      if ~isempty(sT.alpha_type), sTrain.alpha_type = sT.alpha_type; end
      if ~isnan(sT.trainlen),     sTrain.trainlen = sT.trainlen; end
      if ~isempty(sT.data_name),  sTrain.data_name = sT.data_name; end
      if ~isempty(sT.time),       sTrain.time = sT.time; end
     case 'som_map', 
      if strcmp(varargin{i}.type,'som_map'), 
	if length(varargin{i}.trainhist), 
	  sTprev = varargin{i}.trainhist(end); 
	  msize = varargin{i}.topol.msize; 
	end
	if ~isempty(varargin{i}.neigh) 
	  sTrain.neigh = varargin{i}.neigh; 
	end
	if ~isempty(varargin{i}.mask) && isempty(sTrain.mask),  
	  sTrain.mask = varargin{i}.mask; 
	end
      elseif strcmp(varargin{i}.type,'som_train'), 
	sTprev = varargin{i}; 
      end
     case 'som_topol', msize = varargin{i}.msize; 
     case 'som_data', [dlen dim] = size(varargin{i}.data); 
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_train_struct) Ignoring invalid argument #' num2str(i)]); 
  end
  i = i+1; 
end

% dim
if ~isempty(sTprev) && isnan(dim), dim = length(sTprev.mask); end

% mask
if isempty(sTrain.mask) && ~isnan(dim), sTrain.mask = ones(dim,1); end

% msize, munits
if any(~msize) || isempty(msize), % TODO ITN: This actually checks for msize invalidity
    
  if isnan(munits), msize = [10 10]; 
  else s = round(sqrt(munits)); msize = [s round(munits/s)]; 
  end
end
munits = prod(msize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% previous training
prevalg = ''; 
if ~isempty(sTprev), 
  if any(findstr(sTprev.algorithm,'init')), prevalg = 'init';
  else prevalg = sTprev.algorithm; 
  end
end

% first determine phase  
if isempty(phase), 
  switch sTrain.algorithm,
   case {'lininit','randinit'},    phase = 'init'; 
   case {'batch','seq',''}, 
    if     isempty(sTprev),        phase = 'rough'; 
    elseif strcmp(prevalg,'init'), phase = 'rough';
    else                           phase = 'finetune'; 
    end
   otherwise,                      phase = 'train'; 
  end
end

% then determine algorithm  
if isempty(sTrain.algorithm),
  if     strcmp(phase,'init'),             sTrain.algorithm = 'lininit';
  elseif any(strcmp(prevalg,{'init',''})), sTrain.algorithm = 'batch';
  else sTrain.algorithm = sTprev.algorithm; 
  end
end

% mask
if isempty(sTrain.mask), 
  if ~isempty(sTprev), sTrain.mask = sTprev.mask; 
  elseif ~isnan(dim),  sTrain.mask = ones(dim,1); 
  end
end

% neighborhood function
if isempty(sTrain.neigh), 
  if ~isempty(sTprev) && ~isempty(sTprev.neigh), sTrain.neigh = sTprev.neigh; 
  else sTrain.neigh = 'gaussian';
  end
end

if strcmp(phase,'init'), 
  sTrain.alpha_ini = NaN;
  sTrain.alpha_type = '';
  sTrain.radius_ini = NaN;
  sTrain.radius_fin = NaN;
  sTrain.trainlen = NaN;
  sTrain.neigh = '';
else
  mode = [phase, '-', sTrain.algorithm];
  
  % learning rate
  if isnan(sTrain.alpha_ini), 
    if strcmp(sTrain.algorithm,'batch'), sTrain.alpha_ini = NaN; 
    else
      switch phase, 
       case {'train','rough'}, sTrain.alpha_ini = 0.5;
       case 'finetune',        sTrain.alpha_ini = 0.05;
      end
    end
  end
  if isempty(sTrain.alpha_type),     
    if ~isempty(sTprev) && ~isempty(sTprev.alpha_type) ... 
	  && ~strcmp(sTrain.algorithm,'batch'),
      sTrain.alpha_type = sTprev.alpha_type;
    elseif strcmp(sTrain.algorithm,'seq'),
      sTrain.alpha_type = 'inv';
    end
  end
  
  % radius
  ms = max(msize);   
  if isnan(sTrain.radius_ini),     
    if isempty(sTprev) || strcmp(sTprev.algorithm,'randinit'), 
      sTrain.radius_ini = max(1,ceil(ms/4));
    elseif strcmp(sTprev.algorithm,'lininit') || isnan(sTprev.radius_fin),
      sTrain.radius_ini = max(1,ceil(ms/8));
    else
      sTrain.radius_ini = sTprev.radius_fin;
    end
  end
  if isnan(sTrain.radius_fin), 
    if strcmp(phase,'rough'), 
      sTrain.radius_fin = max(1,sTrain.radius_ini/4);
    else
      sTrain.radius_fin = 1;
    end
  end
  
  % trainlen  
  if isnan(sTrain.trainlen),     
    mpd = munits/dlen; 
    if isnan(mpd), mpd = 0.5; end
    switch phase, 
     case 'train',    sTrain.trainlen = ceil(50*mpd);
     case 'rough',    sTrain.trainlen = ceil(10*mpd); 
     case 'finetune', sTrain.trainlen = ceil(40*mpd);
    end
    sTrain.trainlen = max(1,sTrain.trainlen);
  end

end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
