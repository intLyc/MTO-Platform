function [me, st, md, no] = nanstats(D)

%NANSTATS Statistical operations that ignore NaNs and Infs.
%
% [mean, std, median, nans] = nanstats(D)
%
%  Input and output arguments: 
%   D   (struct) data or map struct
%       (matrix) size dlen x dim
%
%   me  (double) columnwise mean
%   st  (double) columnwise standard deviation
%   md  (double) columnwise median
%   no  (vector) columnwise number of samples (finite, not-NaN)

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 300798 200900

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 1, nargin));  % check no. of input args is correct

if isstruct(D), 
  if strcmp(D.type,'som_map'), D = D.codebook;
  else D = D.data;
  end
end
[~, dim] = size(D);
me = zeros(dim,1)+NaN;
md = me;
st = me;
no = me;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computation

for i = 1:dim,
  ind = find(isfinite(D(:, i))); % indices of non-NaN/Inf elements
  n   = length(ind);             % no of non-NaN/Inf elements

  me(i) = sum(D(ind, i)); % compute average
  if n == 0, me(i) = NaN; else me(i) = me(i) / n; end

  if nargout>1, 
    md(i) = median(D(ind, i)); % compute median

    if nargout>2, 
      st(i) = sum((me(i) - D(ind, i)).^2); % compute standard deviation
      if n == 0,     st(i) = NaN;
      elseif n == 1, st(i) = 0;
      else st(i) = sqrt(st(i) / (n - 1));
      end

      if nargout>3, 
	no(i) = n; % number of samples (finite, not-NaN)
      end
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

