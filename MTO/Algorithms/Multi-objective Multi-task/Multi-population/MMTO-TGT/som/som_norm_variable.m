function [x,sNorm] = som_norm_variable(x, method, operation)

%SOM_NORM_VARIABLE Normalize or denormalize a scalar variable.
%
% [x,sNorm] = som_norm_variable(x, method, operation)
%
%   xnew = som_norm_variable(x,'var','do');
%   [dummy,sN] = som_norm_variable(x,'log','init');
%   [xnew,sN]  = som_norm_variable(x,sN,'do');
%   xorig      = som_norm_variable(xnew,sN,'undo');
%
%  Input and output arguments: 
%   x         (vector) a set of values of a scalar variable for
%                      which the (de)normalization is performed.
%                      The processed values are returned.
%   method    (string) identifier for a normalization method: 'var',
%                      'range', 'log', 'logistic', 'histD', or 'histC'.
%                      A normalization struct with default values is created.
%             (struct) normalization struct, or an array of such
%             (cellstr) first string gives normalization operation, and the
%                      second gives denormalization operation, with x 
%                      representing the variable, for example: 
%                      {'x+2','x-2}, or {'exp(-x)','-log(x)'} or {'round(x)'}.
%                      Note that in the last case, no denorm operation is 
%                      defined. 
%   operation (string) the operation to be performed: 'init', 'do' or 'undo'
%                     
%   sNorm     (struct) updated normalization struct/struct array
%
% For more help, try 'type som_norm_variable' or check out online documentation.
% See also SOM_NORMALIZE, SOM_DENORMALIZE.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_norm_variable
%
% PURPOSE
%
% Initialize, apply and undo normalizations on a given vector of
% scalar values.
%
% SYNTAX
%
%  xnew = som_norm_variable(x,method,operation)
%  xnew = som_norm_variable(x,sNorm,operation)
%  [xnew,sNorm] = som_norm_variable(...)
%
% DESCRIPTION
%
% This function is used to initialize, apply and undo normalizations
% on scalar variables. It is the low-level function that upper-level
% functions SOM_NORMALIZE and SOM_DENORMALIZE utilize to actually (un)do
% the normalizations.
%
% Normalizations are typically performed to control the variance of 
% vector components. If some vector components have variance which is
% significantly higher than the variance of other components, those
% components will dominate the map organization. Normalization of 
% the variance of vector components (method 'var') is used to prevent 
% that. In addition to variance normalization, other methods have
% been implemented as well (see list below). 
%
% Usually normalizations convert the variable values so that they no 
% longer make any sense: the values are still ordered, but their range 
% may have changed so radically that interpreting the numbers in the 
% original context is very hard. For this reason all implemented methods
% are (more or less) revertible. The normalizations are monotonic
% and information is saved so that they can be undone. Also, the saved
% information makes it possible to apply the EXACTLY SAME normalization
% to another set of values. The normalization information is determined
% with 'init' operation, while 'do' and 'undo' operations are used to
% apply or revert the normalization. 
%
% The normalization information is saved in a normalization struct, 
% which is returned as the second argument of this function. Note that 
% normalization operations may be stacked. In this case, normalization 
% structs are positioned in a struct array. When applied, the array is 
% gone through from start to end, and when undone, in reverse order.
%
%    method  description
%
%    'var'   Variance normalization. A linear transformation which 
%            scales the values such that their variance=1. This is
%            convenient way to use Mahalanobis distance measure without
%            actually changing the distance calculation procedure.
%
%    'range' Normalization of range of values. A linear transformation
%            which scales the values between [0,1]. 
%
%    'log'   Logarithmic normalization. In many cases the values of
%            a vector component are exponentially distributed. This 
%            normalization is a good way to get more resolution to
%            (the low end of) that vector component. What this 
%            actually does is a non-linear transformation: 
%               x_new = log(x_old - m + 1) 
%            where m=min(x_old) and log is the natural logarithm. 
%            Applying the transformation to a value which is lower 
%            than m-1 will give problems, as the result is then complex.
%            If the minimum for values is known a priori, 
%            it might be a good idea to initialize the normalization with
%              [dummy,sN] = som_norm_variable(minimum,'log','init');
%            and normalize only after this: 
%              x_new = som_norm_variable(x,sN,'do');
%
%    'logistic' or softmax normalization. This normalization ensures
%            that all values in the future, too, are within the range
%            [0,1]. The transformation is more-or-less linear in the 
%            middle range (around mean value), and has a smooth 
%            nonlinearity at both ends which ensures that all values
%            are within the range. The data is first scaled as in 
%            variance normalization: 
%               x_scaled = (x_old - mean(x_old))/std(x_old)
%            and then transformed with the logistic function
%               x_new = 1/(1+exp(-x_scaled))
% 
%    'histD' Discrete histogram equalization. Non-linear. Orders the 
%            values and replaces each value by its ordinal number. 
%            Finally, scales the values such that they are between [0,1].
%            Useful for both discrete and continuous variables, but as 
%            the saved normalization information consists of all 
%            unique values of the initialization data set, it may use
%            considerable amounts of memory. If the variable can get
%            more than a few values (say, 20), it might be better to
%            use 'histC' method below. Another important note is that
%            this method is not exactly revertible if it is applied
%            to values which are not part of the original value set.
%            
%    'histC' Continuous histogram equalization. Actually, a partially
%            linear transformation which tries to do something like 
%            histogram equalization. The value range is divided to 
%            a number of bins such that the number of values in each
%            bin is (almost) the same. The values are transformed 
%            linearly in each bin. For example, values in bin number 3
%            are scaled between [3,4[. Finally, all values are scaled
%            between [0,1]. The number of bins is the square root
%            of the number of unique values in the initialization set,
%            rounded up. The resulting histogram equalization is not
%            as good as the one that 'histD' makes, but the benefit
%            is that it is exactly revertible - even outside the 
%            original value range (although the results may be funny).
%
%    'eval'  With this method, freeform normalization operations can be 
%            specified. The parameter field contains strings to be 
%            evaluated with 'eval' function, with variable name 'x'
%            representing the variable itself. The first string is 
%            the normalization operation, and the second is a 
%            denormalization operation. If the denormalization operation
%            is empty, it is ignored.
% 
% INPUT ARGUMENTS
%
%   x          (vector) The scalar values to which the normalization      
%                       operation is applied.
%                     
%   method              The normalization specification.
%              (string) Identifier for a normalization method: 'var', 
%                       'range', 'log', 'logistic', 'histD' or 'histC'. 
%                       Corresponding default normalization struct is created.
%              (struct) normalization struct 
%              (struct array) of normalization structs, applied to 
%                       x one after the other
%              (cellstr) of length 
%              (cellstr array) first string gives normalization operation, and 
%                       the second gives denormalization operation, with x 
%                       representing the variable, for example: 
%                       {'x+2','x-2}, or {'exp(-x)','-log(x)'} or {'round(x)'}.
%                       Note that in the last case, no denorm operation is 
%                       defined. 
%
%               note: if the method is given as struct(s), it is
%                     applied (done or undone, as specified by operation)
%                     regardless of what the value of '.status' field
%                     is in the struct(s). Only if the status is
%                     'uninit', the undoing operation is halted.
%                     Anyhow, the '.status' fields in the returned 
%                     normalization struct(s) is set to approriate value.
%   
%   operation  (string) The operation to perform: 'init' to initialize
%                       the normalization struct, 'do' to perform the 
%                       normalization, 'undo' to undo the normalization, 
%                       if possible. If operation 'do' is given, but the
%                       normalization struct has not yet been initialized,
%                       it is initialized using the given data (x).
%
% OUTPUT ARGUMENTS
% 
%   x        (vector) Appropriately processed values. 
%
%   sNorm    (struct) Updated normalization struct/struct array. If any,
%                     the '.status' and '.params' fields are updated.
% 
% EXAMPLES
%
%  To initialize and apply a normalization on a set of scalar values: 
%
%    [x_new,sN] = som_norm_variable(x_old,'var','do'); 
%
%  To just initialize, use: 
% 
%    [dummy,sN] = som_norm_variable(x_old,'var','init'); 
% 
%  To undo the normalization(s): 
%
%    x_orig = som_norm_variable(x_new,sN,'undo');
%
%  Typically, normalizations of data structs/sets are handled using
%  functions SOM_NORMALIZE and SOM_DENORMALIZE. However, when only the
%  values of a single variable are of interest, SOM_NORM_VARIABLE may 
%  be useful. For example, assume one wants to apply the normalization
%  done on a component (i) of a data struct (sD) to a new set of values 
%  (x) of that component. With SOM_NORM_VARIABLE this can be done with: 
%
%    x_new = som_norm_variable(x,sD.comp_norm{i},'do'); 
% 
%  Now, as the normalizations in sD.comp_norm{i} have already been 
%  initialized with the original data set (presumably sD.data), 
%  the EXACTLY SAME normalization(s) can be applied to the new values.
%  The same thing can be done with SOM_NORMALIZE function, too: 
%
%    x_new = som_normalize(x,sD.comp_norm{i}); 
%
%  Or, if the new data set were in variable D - a matrix of same
%  dimension as the original data set: 
%
%    D_new = som_normalize(D,sD,i);
%
% SEE ALSO
%  
%  som_normalize    Add/apply/redo normalizations for a data struct/set.
%  som_denormalize  Undo normalizations of a data struct/set.

% Copyright (c) 1998-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 151199 170400 150500

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(3, 3, nargin));  % check no. of input arguments is correct

% method
sNorm = []; 
if ischar(method) 
  if any(strcmp(method,{'var','range','log','logistic','histD','histC'})), 
    sNorm = som_set('som_norm','method',method);
  else 
    method = cellstr(method);
  end
elseif iscell(method),
  if length(method)==1 && isstruct(method{1}), sNorm = method{1}; 
  else
    if length(method)==1 || isempty(method{2}), 
      method{2} = 'x'; 
    end
    sNorm = som_set('som_norm','method','eval','params',method);
  end
else
  sNorm = method; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

order = [1:length(sNorm)]; 
if length(order)>1 && strcmp(operation,'undo'), order = order(end:-1:1); end

for i=order, 

  % initialize
  if strcmp(operation,'init') || ...
     (strcmp(operation,'do') && strcmp(sNorm(i).status,'uninit')), 

    % case method = 'hist'
    if strcmp(sNorm(i).method,'hist'), 
      inds = find(~isnan(x) & ~isinf(x));
      if length(unique(x(inds)))>20, sNorm(i).method = 'histC'; 
      else sNorm{i}.method = 'histD'; end
    end

    switch(sNorm(i).method), 
    case 'var',   params = norm_variance_init(x);
    case 'range', params = norm_scale01_init(x);
    case 'log',   params = norm_log_init(x);
    case 'logistic', params = norm_logistic_init(x);
    case 'histD', params = norm_histeqD_init(x);
    case 'histC', params = norm_histeqC_init(x);
    case 'eval',  params = sNorm(i).params; 
    otherwise, 
      error(['Unrecognized method: ' sNorm(i).method]); 
    end
    sNorm(i).params = params;
    sNorm(i).status = 'undone';
  end

  % do / undo
  if strcmp(operation,'do'), 
    switch(sNorm(i).method), 
    case 'var',   x = norm_scale_do(x,sNorm(i).params);
    case 'range', x = norm_scale_do(x,sNorm(i).params);
    case 'log',   x = norm_log_do(x,sNorm(i).params);
    case 'logistic', x = norm_logistic_do(x,sNorm(i).params);
    case 'histD', x = norm_histeqD_do(x,sNorm(i).params);
    case 'histC', x = norm_histeqC_do(x,sNorm(i).params);
    case 'eval',  x = norm_eval_do(x,sNorm(i).params);
    otherwise, 
      error(['Unrecognized method: ' sNorm(i).method]);
    end
    sNorm(i).status = 'done';

  elseif strcmp(operation,'undo'), 

    if strcmp(sNorm(i).status,'uninit'), 
      warning('Could not undo: uninitialized normalization struct.')
      break;
    end
    switch(sNorm(i).method), 
    case 'var',   x = norm_scale_undo(x,sNorm(i).params);
    case 'range', x = norm_scale_undo(x,sNorm(i).params);
    case 'log',   x = norm_log_undo(x,sNorm(i).params);    
    case 'logistic', x = norm_logistic_undo(x,sNorm(i).params);
    case 'histD', x = norm_histeqD_undo(x,sNorm(i).params);
    case 'histC', x = norm_histeqC_undo(x,sNorm(i).params);
    case 'eval',  x = norm_eval_undo(x,sNorm(i).params);
    otherwise, 
      error(['Unrecognized method: ' sNorm(i).method]);
    end
    sNorm(i).status = 'undone';

  elseif ~strcmp(operation,'init'),

    error(['Unrecognized operation: ' operation])

  end
end  

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

% linear scaling

function p = norm_variance_init(x)
  inds = find(~isnan(x) & isfinite(x));
  p = [mean(x(inds)), std(x(inds))];
  if p(2) == 0, p(2) = 1; end
  %end of norm_variance_init

function p = norm_scale01_init(x)
  inds = find(~isnan(x) & isfinite(x));
  mi = min(x(inds)); 
  ma = max(x(inds));
  if mi == ma, p = [mi, 1]; else p = [mi, ma-mi]; end
  %end of norm_scale01_init  

function x = norm_scale_do(x,p)
  x = (x - p(1)) / p(2);
  % end of norm_scale_do

function x = norm_scale_undo(x,p)
  x = x * p(2) + p(1);
  % end of norm_scale_undo

% logarithm

function p = norm_log_init(x)
  inds = find(~isnan(x) & isfinite(x));
  p = min(x(inds));
  % end of norm_log_init

function x = norm_log_do(x,p)
  x = log(x - p +1); 
  % if any(~isreal(x)), ok = 0; end
  % end of norm_log_do 

function x = norm_log_undo(x,p)
  x = exp(x) -1 + p; 
  % end of norm_log_undo 

% logistic

function p = norm_logistic_init(x)
  inds = find(~isnan(x) & isfinite(x));
  p = [mean(x(inds)), std(x(inds))];
  if p(2)==0, p(2) = 1; end
  % end of norm_logistic_init

function x = norm_logistic_do(x,p)
  x = (x-p(1))/p(2);
  x = 1./(1+exp(-x));
  % end of norm_logistic_do

function x = norm_logistic_undo(x,p)
  x = log(x./(1-x));
  x = x*p(2)+p(1);
  % end of norm_logistic_undo

% histogram equalization for discrete values

function p = norm_histeqD_init(x)
  inds = find(~isnan(x) & ~isinf(x));
  p = unique(x(inds));
  % end of norm_histeqD_init

function x = norm_histeqD_do(x,p)
  bins = length(p);
  inds = find(~isnan(x) & ~isinf(x))';
  for i = inds, 
    [dummy ind] = min(abs(x(i) - p));
    % data item closer to the left-hand bin wall is indexed after RH wall
    if x(i) > p(ind) && ind < bins, 
      x(i) = ind + 1;  
    else 
      x(i) = ind;
    end
  end
  x = (x-1)/(bins-1); % normalization between [0,1]
  % end of norm_histeqD_do 

function x = norm_histeqD_undo(x,p)
  bins = length(p);
  x = round(x*(bins-1)+1);
  inds = find(~isnan(x) & ~isinf(x));
  x(inds) = p(x(inds));
  % end of norm_histeqD_undo

% histogram equalization with partially linear functions

function p = norm_histeqC_init(x)
  % investigate x
  inds = find(~isnan(x) & ~isinf(x));
  samples = length(inds);
  xs = unique(x(inds));
  mi = xs(1);
  ma = xs(end);
  % decide number of limits
  lims = ceil(sqrt(length(xs))); % 2->2,100->10,1000->32,10000->100
  % decide limits
  if lims==1,     
    p = [mi, mi+1];
    lims = 2; 
  elseif lims==2, 
    p = [mi, ma];
  else
    p = zeros(lims,1);   
    p(1) = mi; 
    p(end) = ma;
    binsize = zeros(lims-1,1); b = 1; avebinsize = samples/(lims-1);
    for i=1:(length(xs)-1), 
      binsize(b) = binsize(b) + sum(x==xs(i)); 
      if binsize(b) >= avebinsize, 
        b = b + 1;
        p(b) = (xs(i)+xs(i+1))/2;
      end
      if b==(lims-1), 
        binsize(b) = samples-sum(binsize); break;
      else
        avebinsize = (samples-sum(binsize))/(lims-1-b);
      end
    end
  end
  % end of norm_histeqC_init

function x = norm_histeqC_do(x,p)
  xnew = x; 
  lims = length(p);
  % handle values below minimum
  r = p(2)-p(1); 
  inds = find(x<=p(1) & isfinite(x)); 
  if any(inds), xnew(inds) = 0-(p(1)-x(inds))/r; end 
  % handle values above maximum
  r = p(end)-p(end-1); 
  inds = find(x>p(end) & isfinite(x)); 
  if any(inds), xnew(inds) = lims-1+(x(inds)-p(end))/r; end
  % handle all other values
  for i=1:(lims-1), 
    r0 = p(i); r1 = p(i+1); r = r1-r0; 
    inds = find(x>r0 & x<=r1); 
    if any(inds), xnew(inds) = i-1+(x(inds)-r0)/r; end
  end
  % scale so that minimum and maximum correspond to 0 and 1
  x = xnew/(lims-1);
  % end of norm_histeqC_do

function x = norm_histeqC_undo(x,p)
  xnew = x; 
  lims = length(p); 
  % scale so that 0 and 1 correspond to minimum and maximum
  x = x*(lims-1);

  % handle values below minimum
  r = p(2)-p(1); 
  inds = find(x<=0 & isfinite(x)); 
  if any(inds), xnew(inds) = x(inds)*r + p(1); end 
  % handle values above maximum
  r = p(end)-p(end-1); 
  inds = find(x>lims-1 & isfinite(x)); 
  if any(inds), xnew(inds) = (x(inds)-(lims-1))*r+p(end); end
  % handle all other values
  for i=1:(lims-1), 
    r0 = p(i); r1 = p(i+1); r = r1-r0; 
    inds = find(x>i-1 & x<=i); 
    if any(inds), xnew(inds) = (x(inds)-(i-1))*r + r0; end
  end
  x = xnew;
  % end of norm_histeqC_undo

% eval

function p = norm_eval_init(method)
  p = method;
  %end of norm_eval_init

function x = norm_eval_do(x,p)
  x_tmp = eval(p{1});
  if size(x_tmp,1)>=1 && size(x,1)>=1 && ...
     size(x_tmp,2)==1 && size(x,2)==1,
    x = x_tmp;
  end
  %end of norm_eval_do

function x = norm_eval_undo(x,p)
  x_tmp = eval(p{2});
  if size(x_tmp,1)>=1 && size(x,1)>=1 && ...
     size(x_tmp,2)==1 && size(x,2)==1,
    x = x_tmp;
  end
  %end of norm_eval_undo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



