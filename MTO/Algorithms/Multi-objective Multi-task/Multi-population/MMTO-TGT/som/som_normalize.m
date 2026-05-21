function sD = som_normalize(sD,method,comps)

%SOM_NORMALIZE (Re)normalize data or add new normalizations.
%   
% sS = som_normalize(sS,[method],[comps])               
%
%   sS = som_normalize(sD) 
%   sS = som_normalize(sS,sNorm) 
%    D = som_normalize(D,'var')
%   sS = som_normalize(sS,'histC',[1:3 10])
%
%  Input and output arguments ([]'s are optional): 
%   sS                The data to which the normalization is applied.
%                     The modified and updated data is returned.
%            (struct) data or map struct
%            (matrix) data matrix (a matrix is also returned)
%   [method]          The normalization method(s) to add/use. If missing, 
%                     or an empty variable ('') is given, the 
%                     normalizations in sS are used.
%            (string) identifier for a normalization method to be added: 
%                     'var', 'range', 'log', 'logistic', 'histD' or 'histC'. 
%            (struct) Normalization struct, or an array of such. 
%                     Alternatively, a map/data struct can be given 
%                     in which case its '.comp_norm' field is used 
%                     (see below).
%            (cell array) Of normalization structs. Typically, the
%                     '.comp_norm' field of a map/data struct. The 
%                     length of the array must be equal to data dimension.
%            (cellstr array) norm and denorm operations in a cellstr array
%                     which are evaluated with EVAL command with variable
%                     name 'x' reserved for the variable.
%   [comps]  (vector) the components to which the normalization is
%                     applied, default is [1:dim] ie. all components
%
% For more help, try 'type som_normalize' or check out online documentation.
% See also SOM_DENORMALIZE, SOM_NORM_VARIABLE, SOM_INFO.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_normalize
%
% PURPOSE
%
% Add/apply/redo normalization on data structs/sets.
%
% SYNTAX
%
%  sS = som_normalize(sS)
%  sS = som_normalize(sS,method)
%   D = som_normalize(D,sNorm)
%  sS = som_normalize(sS,csNorm)
%  sS = som_normalize(...,comps)
%
% DESCRIPTION
%
% This function is used to (initialize and) add, redo and apply 
% normalizations on data/map structs/sets. If a data/map struct is given, 
% the specified normalizations are added to the '.comp_norm' field of the 
% struct after ensuring that all normalizations specified therein have
% status 'done'. SOM_NORMALIZE actually uses function SOM_NORM_VARIABLE 
% to handle the normalization operations, and only handles the data 
% struct/set specific stuff itself.
%
% The different normalization methods are listed below. For more 
% detailed descriptions, see SOM_NORM_VARIABLE.
%  
%   method     description
%   'var'      Variance is normalized to one (linear operation).
%   'range'    Values are normalized between [0,1] (linear operation).
%   'log'      Natural logarithm is applied to the values: 
%                xnew = log(x-m+1)
%              where m = min(x).
%   'logistic' Logistic or softmax trasformation which scales all
%              possible values between [0,1].
%   'histD'    Histogram equalization, values scaled between [0,1].
%   'histC'    Approximate histogram equalization with partially 
%              linear operations. Values scaled between [0,1].
%   'eval'     freeform operations
%  
% To enable undoing and applying the exactly same normalization to
% other data sets, normalization information is saved into a 
% normalization struct, which has the fields: 
% 
%   .type   ; struct type, ='som_norm'
%   .method ; normalization method, a string
%   .params ; normalization parameters
%   .status ; string: 'uninit', 'undone' or 'done'
%
% Normalizations are always one-variable operations. In the data and map
% structs the normalization information for each component is saved in the
% '.comp_norm' field, which is a cell array of length dim. Each cell
% contains normalizations for one vector component in a struct array of
% normalization structs. Each component may have different amounts of
% different kinds of normalizations. Typically, all normalizations are
% either 'undone' or 'done', but in special situations this may not be the
% case. The easiest way to check out the status of the normalizations is to
% use function SOM_INFO, e.g. som_info(sS,3)
%
% REQUIRED INPUT ARGUMENTS
%
%   sS                The data to which the normalization is applied.
%            (struct) Data or map struct. Before adding any new 
%                     normalizations, it is ensured that the
%                     normalizations for the specified components in the
%                     '.comp_norm' field have status 'done'. 
%            (matrix) data matrix 
%
% OPTIONAL INPUT ARGUMENTS
%
%   method            The normalization(s) to add/use. If missing, 
%                     or an empty variable ('' or []) is given, the 
%                     normalizations in the data struct are used.
%            (string) Identifier for a normalization method to be added: 
%                     'var', 'range', 'log', 'logistic', 'histD' or 'histC'. The 
%                     same method is applied to all specified components
%                     (given in comps). The normalizations are first 
%                     initialized (for each component separately, of
%                     course) and then applied.
%            (struct) Normalization struct, or an array of structs, which
%                     is applied to all specified components. If the 
%                     '.status' field of the struct(s) is 'uninit', 
%                     the normalization(s) is initialized first.
%                     Alternatively, the struct may be map or data struct
%                     in which case its '.comp_norm' field is used
%                     (see the cell array option below).
%            (cell array) In practice, the '.comp_norm' field of 
%                     a data/map struct. The length of the array 
%                     must be equal to the dimension of the given 
%                     data set (sS). Each cell contains the
%                     normalization(s) for one component. Only the
%                     normalizations listed in comps argument are
%                     applied though.
%            (cellstr array) norm and denorm operations in a cellstr array
%                     which are evaluated with EVAL command with variable
%                     name 'x' reserved for the variable.
%
%   comps    (vector) The components to which the normalization(s) is
%                     applied. Default is to apply to all components.
%
% OUTPUT ARGUMENTS
% 
%   sS                Modified and/or updated data.
%            (struct) If a struct was given as input argument, the
%                     same struct is returned with normalized data and
%                     updated '.comp_norm' fields. 
%            (matrix) If a matrix was given as input argument, the 
%                     normalized data matrix is returned.
% 
% EXAMPLES
%
%  To add (initialize and apply) a normalization to a data struct: 
%
%    sS = som_normalize(sS,'var'); 
%
%  This uses 'var'-method to all components. To add a method only to
%  a few selected components, use the comps argument: 
% 
%    sS = som_normalize(sS,'log',[1 3:5]); 
% 
%  To ensure that all normalization operations have indeed been done: 
% 
%    sS = som_normalize(sS); 
%
%  The same for only a few components: 
%
%    sS = som_normalize(sS,'',[1 3:5]); 
% 
%  To apply the normalizations of a data struct sS to a new data set D: 
%
%    D = som_normalize(D,sS); 
%  or 
%    D = som_normalize(D,sS.comp_norm); 
% 
%  To normalize a data set: 
%
%    D = som_normalize(D,'histD'); 
%
%  Note that in this case the normalization information is lost.
%
%  To check out the status of normalization in a struct use SOM_INFO: 
% 
%    som_info(sS,3)
%
%
% SEE ALSO
%  
%  som_denormalize    Undo normalizations of a data struct/set.
%  som_norm_variable  Normalization operations for a set of scalar values.
%  som_info           User-friendly information of SOM Toolbox structs.

% Copyright (c) 1998-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 151199 150500

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

% comps
if nargin<3 || (ischar(comps) && strcmp(comps,'all')), 
  comps = [1:dim]; 
end
if isempty(comps), return; end
if size(comps,1)>1, comps = comps'; end  % make it a row vector

% method
csNorm = cell(dim,1); 
if nargin<2 || isempty(method), 
  if ~struct_mode, 
    warning('No normalization method given. Data left unchanged.');
    return; 
  end
  method = '';
else  
  % check out the given method 
  % (and if necessary, copy it for each specified component)
  if ischar(method),
    switch method, 
    case {'var','range','log','histD','histC','logistic'}, 
      sN = som_set('som_norm','method',method); 
    otherwise,       
      error(['Unrecognized method: ' method]);
    end
    for i=comps, csNorm{i} = sN; end
  elseif isstruct(method),
    switch method(1).type, 
    case {'som_map','som_data'}, csNorm = method(1).comp_norm; 
    case {'som_norm'}, for i=comps, csNorm{i} = method; end
    otherwise, 
      error('Invalid struct given as normalization method.')
    end
  elseif iscellstr(method), 
    [dummy,sN] = som_norm_variable(1,method,'init');      
    for i=comps, csNorm{i} = sN; end
  elseif iscell(method), 
    csNorm = method; 
  else
    error('Illegal method argument.')
  end
  % check the size of csNorm is the same as data dimension
  if length(csNorm) ~= dim, 
    error('Given number of normalizations does not match data dimension.')
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize

% make sure all the current normalizations for current 
% components have been done
if struct_mode, 
  alldone = 1; 
  for i = comps, 
    for j=1:length(sD.comp_norm{i}), 
      sN = sD.comp_norm{i}(j); 
      if ~strcmp(sN.status,'done'), 
	alldone = 0; 
        [x,sN] = som_norm_variable(D(:,i), sN, 'do'); 
        D(:,i) = x; 
        sD.comp_norm{i}(j) = sN; 
      end
    end
  end
  if isempty(method), 
    if alldone,
      warning('No ''undone'' normalizations found. Data left unchanged.');
    else
      fprintf(1,'Normalizations have been redone.\n');
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action 

% add the new normalizations to the old ones
for i = comps, 
  if ~isempty(csNorm{i}), 
    [x,sN] = som_norm_variable(D(:,i), csNorm{i}, 'do'); 
    D(:,i) = x; 
    if struct_mode, 
      if isempty(sD.comp_norm{i}), sD.comp_norm{i} = sN; 
      else sD.comp_norm{i} = [sD.comp_norm{i}, sN]; end
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% output

if struct_mode, 
  switch sD.type
   case 'som_map', sD.codebook = D; 
   case 'som_data', sD.data = D; 
   otherwise, error('Illegal struct.')
  end
else
  sD = D;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



