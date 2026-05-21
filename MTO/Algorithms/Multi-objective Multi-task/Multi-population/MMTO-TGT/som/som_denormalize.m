function sD = som_denormalize(sD,varargin)

%SOM_DENORMALIZE Denormalize data.
%   
% sS = som_denormalize(sS, [argID, value, ...])               
%
%   sS = som_denormalize(sS) 
%   sS = som_denormalize(sS,[1:3 10],'remove') 
%    D = som_denormalize(D,sM.comp_norm)
%    D = som_denormalize(D,sM,[1:3 10])
%
%  Input and output arguments ([]'s are optional): 
%   sS                The data to which the denormalization is applied.
%                     The modified and updated data is returned.
%            (struct) data or map struct
%            (matrix) data matrix (a matrix is also returned)
%   [argID, (string) See below. The values which are unambiguous can 
%    value] (varies) be given without the preceeding argID.
%
% Here are the valid argument IDs and corresponding values. The values which
% are unambiguous (marked with '*') can be given without the preceeding argID.
%   'norm'   *(struct) Normalization struct, or an array of such. 
%                      Alternatively, a map/data struct can be given 
%                      in which case its '.comp_norm' field is used 
%                      (see below).
%            *(cell array) Of normalization structs. Typically, the
%                      '.comp_norm' field of a map/data struct. The 
%                      length of the array must be equal to data dimension.
%   'remove' *(string) If 'remove' tag is specified, the
%                      normalization operations are not only undone, 
%                      they are also removed from the struct.
%   'comps'  *(vector) the components to which the denormalization is
%                      applied, default is [1:dim] ie. all components
%
% For more help, try 'type som_denormalize' or check out online documentation.
% See also SOM_NORMALIZE, SOM_NORM_VARIABLE, SOM_INFO.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_denormalize
%
% PURPOSE
%
% Undo normalizations of data structs/sets.
%
% SYNTAX
%
%  sS = som_denormalize(sS)
%  sS = som_denormalize(...,'argID',value,...);
%  sS = som_denormalize(...,value,...);
%   D = som_denormalize(D,sNorm)
%
% DESCRIPTION
%
% This function is used to undo normalizations of data structs/sets. If a
% data/map struct is given, all normalizations in the '.comp_norm' field are
% undone and, thus, the values in the original data context are returned. If
% a matrix is given, the normalizations to undo must be given as the second
% argument. SOM_DENORMALIZE actually uses function SOM_NORM_VARIABLE to
% handle the normalization operations, and only handles the data struct/set
% specific stuff itself.
%
% Normalizations are always one-variable operations. In the data and map
% structs the normalization information for each component is saved in the
% '.comp_norm' field, which is a cell array of length dim. Each cell
% contains normalizations for one vector component in a
% struct array of normalization structs. Each component may have different
% amounts of different kinds of normalizations. Typically, all
% normalizations are either 'undone' or 'done', but in special situations
% this may not be the case. The easiest way to check out the status of the
% normalizations is to use function SOM_INFO, e.g. som_info(sS,3)
% 
% REQUIRED INPUT ARGUMENTS
%
%   sS                The data to which the denormalization is applied.
%            (struct) Data or map struct. The normalizations in the 
%                     '.comp_norm' field are undone for the specified 
%                     components.
%            (matrix) Data matrix. The normalization to undo must be
%                     given in the second argument.
%
% OPTIONAL INPUT ARGUMENTS
%
%  argID (string) Argument identifier string (see below).
%  value (varies) Value for the argument (see below).
%
%  The optional arguments can be given as 'argID',value -pairs. If an
%  argument is given value multiple times, the last one is used. The
%  valid IDs and corresponding values are listed below. The values
%  which are unambiguous (marked with '*') can be given without the
%  preceeding argID.
%
%   sNorm    *(struct) Normalization struct, or an array of structs, which
%                      is undone for all specified components. If the 
%                      '.status' field of the struct(s) is 'uninit', 
%                      the undoing operation is interrupted - it cannot be 
%                      done. Alternatively, the struct may be map or 
%                      data struct in which case its '.comp_norm' field 
%                      is used (see the cell array option below).
%            *(cell array) In practice, the '.comp_norm' field of 
%                      a data/map struct. The length of the array 
%                      must be equal to the dimension of the given 
%                      data set (sS). Each cell contains the
%                      normalization(s) for one component. Only the
%                       normalizations listed in comps argument are
%                      undone though.
%
%   'remove' *(string) If 'remove' tag is specified, the
%                      normalization operations are not only undone, 
%                      they are also removed from the struct.
%
%   'comps'  *(vector) The components which are denormalized.
%                      Default is to undo all components.
%            *(string) 'all'
%
% OUTPUT ARGUMENTS
% 
%   sS                Modified and/or updated data.
%            (struct) If a struct was given as input argument, the
%                     same struct is returned with denormalized data and
%                     updated '.comp_norm' fields. 
%            (matrix) If a matrix was given as input argument, the 
%                     denormalized data matrix is returned.
% 
% EXAMPLES
%
%  To undo normalization of a data/map struct: 
%
%    sD = som_denormalize(sD); 
%    sM = som_denormalize(sM); 
%
%  To completely remove the normalizations, use the 'remove' tag: 
%
%    sD = som_denormalize(sD,'remove');
%
%  To undo only a few selected components, use the comps argument: 
% 
%    sD = som_denormalize(sD,[1 3:5]); 
% 
%  To denormalize a set of values from a data set D (which must be 
%  of equal dimension as the data in sD): 
%
%    D = som_denormalize(D,sD); 
%  or 
%    D = som_denormalize(D,sD.comp_norm); 
%  only denormalize a few components
%    D = som_denormalize(D,sD,[1 3:5]); 
% 
%  Assuming you have a few values of a certain vector component (i)
%  in a vector (x) which you want to denormalize: 
%
%    xorig = som_denormalize(x,sD.comp_norm{i}); 
%  or using SOM_NORM_VARIABLE
%    xorig = som_norm_variable(x,sD.comp_norm{i},'undo');
%
%  To check out the status of normalization in a struct use SOM_INFO: 
% 
%    som_info(sM,3)
%    som_info(sD,3)
%
% SEE ALSO
%  
%  som_normalize      Add/apply/redo normalizations of a data struct/set.
%  som_norm_variable  Normalization operations for a set of scalar values.
%  som_info           User-friendly information of SOM Toolbox structs.

% Copyright (c) 1998-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 151199 150300

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 3, nargin));  % check no. of input arguments is correct

% sD
struct_mode = isstruct(sD);
if struct_mode, 
  switch sD.type
   case 'som_map', D = sD.codebook; 
   case 'som_data', D = sD.data; 
   otherwise, error('Illegal struct.')
  end
else 
  D = sD;
end
[dlen dim] = size(D);

% varargin
comps = [1:dim];
remove_tag = 0;
if struct_mode, sNorm = sD.comp_norm; else sNorm = []; end
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     % argument IDs
     case 'comps', i=i+1; comps = varargin{i}; 
     case {'norm','sNorm','som_norm'}, i=i+1; sNorm = varargin{i};
     % unambiguous values
     case 'remove', remove_tag = 1;
     otherwise argok=0; 
    end    
  elseif isnumeric(varargin{i}), 
    comps = varargin{i};
  elseif isstruct(varargin{i}), 
    sNorm = varargin{i};
  elseif iscell(varargin{i}), 
    sNorm = varargin{i};
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_denormalize) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end

% check comps
if ischar(comps), comps = [1:dim]; end
if isempty(comps), return; end
if size(comps,1)>1, comps = comps'; end  % make it a row vector

% sNorm
% check out the given normalization
% (and if necessary, copy it for each specified component)
if isstruct(sNorm),
  switch sNorm(1).type, 
   case {'som_map','som_data'}, csNorm = sNorm(1).comp_norm; 
   case {'som_norm'}, for i=comps, csNorm{i} = sNorm; end
   otherwise, 
    error('Invalid struct for sNorm.')
  end
elseif iscell(sNorm), 
  csNorm = sNorm; 
else
  error('Illegal value for sNorm.')
end

% check that csNorm and comps possibly agree
if max(comps) > length(csNorm), 
  error('Given normalizations does not match the components.')
end  
if length(csNorm) ~= dim, 
  error('Given normalizations does not match data dimension.')
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% undo the normalizations 
for i = comps, 
  len = length(csNorm{i});
  for j=len:-1:1, 
    sN = csNorm{i}(j); 
    if struct_mode, 
      if strcmp(sN.status,'done'), 
	[x,sN] = som_norm_variable(D(:,i), sN, 'undo'); 
	D(:,i) = x; 
	csNorm{i}(j) = sN; 
      end      
    else
      D(:,i) = som_norm_variable(D(:,i), sN, 'undo'); 
    end
  end
end

% remove normalizations
if struct_mode && remove_tag, 
  for i = comps, csNorm{i} = []; end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% output 


if struct_mode, 
  switch sD.type
   case 'som_map', sD.codebook = D; 
   case 'som_data', sD.data = D; 
   otherwise, error('Illegal struct.')
  end
  sD.comp_norm = csNorm; 
else
  sD = D;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



