function [mqe,tge,cbe] = som_quality(sMap, D)

%SOM_QUALITY Calculate the mean quantization, topographic
%            and combined (Kaski and Lagus, 1996) error.
%
% [qe,te,ce] = som_quality(sMap, D)
%
%  qe = som_quality(sMap,D);
%  [qe,te] = som_quality(sMap,sD);
%
%  Input and output arguments: 
%   sMap     (struct) a map struct
%   D                 the data
%            (struct) a data struct
%            (matrix) a data matrix, size dlen x dim
%
%   qe       (scalar) mean quantization error
%   te       (scalar) topographic error
%   ce      (scalar) combined error (Kaski and Lagus, 1996)
%
% The issue of SOM quality is a complicated one. Typically two
% evaluation criterias are used: resolution and topology preservation.
% If the dimension of the data set is higher than the dimension of the 
% map grid, these usually become contradictory goals. 
%
% The first value returned by this function measures resolution and the
% second the topology preservation.
%  qe : Average distance between each data vector and its BMU.
%  te : Topographic error, the proportion of all data vectors
%       for which first and second BMUs are not adjacent units.
%
% NOTE: when calculating BMUs of data vectors, the mask of the given 
%       map is used.
%
% For more help, try 'type som_quality' or check out the online documentation.
% See also SOM_BMUS.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_quality
%
% PURPOSE
%
% Calculates two quality measures for the given map.
%
% SYNTAX
%
%  qe = som_quality(sM,sD);
%  qe = som_quality(sM,D);
%  [qe,te] = som_quality(...);
%
% DESCRIPTION
%
% This function measures the quality of the given map. The measures are
% data-dependent: they measure the map in terms of the given
% data. Typically, the quality of the map is measured in terms of the
% training data. The returned quality measures are average quantization
% error and topographic error.
%
% The issue of SOM quality is a complicated one. Typically two evaluation
% criterias are used: resolution and topology preservation. There are
% many ways to measure them. The ones implemented here were chosen for
% their simplicity.
%
%  qe : Average distance between each data vector and its BMU.
%       Measures map resolution.
%  te : Topographic error, the proportion of all data vectors
%       for which first and second BMUs are not adjacent units.
%       Measures topology preservation.
%
% NOTE: when calculating BMUs of data vectors, the mask of the given 
%       map is used. The mask affects the quantization errors, too.
%       If you want the quantization errors without the weighting given
%       by the mask, you can use the following code: 
%         bmus = som_bmus(sMap,D); % this uses the mask in finding the BMUs
%         for i=1:length(bmus), 
%           dx = sMap.codebook(bmus(i),:)-D(i,:); % m - x
%           dx(isnan(dx)) = 0;                    % remove NaNs 
%           qerr(i) = sqrt(sum(dx.^2));           % euclidian distance
%         end
%         qe = mean(qerr); % average quantization error
%
% Please note that you should _not_ trust the measures blindly. Generally,
% both measures give the best results when the map has overfitted the
% data. This may happen when the number of map units is as large or larger
% than the number of training samples. Beware when you have such a case.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 113.
% Kiviluoto, K., "Topology Preservation in Self-Organizing Maps", 
%    in the proceeding of International Conference on Neural
%    Networks (ICNN), 1996, pp. 294-299.
%
% INPUT ARGUMENTS
%
%  sMap    (struct) Map struct.
%  D                The data to be used.
%          (matrix) A data matrix, size dlen x dim.
%          (struct) A data struct.
%
% OUTPUT ARGUMENTS
% 
%  qe      (scalar) mean quantization error
%  te      (scalar) topographic error
%  ce      (scalar) combined error (Kaski and Lagus, 1996)
%
% EXAMPLES
%
%  qe = som_quality(sMap,D);
%  [qe,te] = som_quality(sMap,sD);
%  [qe,te,ce] = som_quality(sMap,sD);
%
% SEE ALSO
% 
%  som_bmus         Find BMUs for the given set of data vectors.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 220997
% Version 2.0beta juuso 151199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% input arguments
if nargin < 2, error('Not enough input arguments.'); end

% data
if isstruct(D), D = D.data; end
[dlen dim] = size(D);

% calculate topographic error, too?
if nargout==1, b=1; 
elseif nargout==2, b=1:2;
else b=1:3;
end
[bmus qerrs]= som_bmus(sMap,D,b);
inds = find(~isnan(bmus(:,1)));
bmus = bmus(inds,:);
qerrs = qerrs(inds,:);
l = length(inds);
if ~l, error('Empty data set.'); end

% mean quantization error
mqe = mean(qerrs(:,1));

if length(b)>1, % topographic error
  Ne = full(som_unit_neighs(sMap.topol));
  tge = 0;
  for i=1:l, tge = tge+(Ne(bmus(i,1),bmus(i,2)) ~= 1); end
  tge = tge / l;
else
  tge = NaN;
end

if length(b)==3, % combined error (Kaski and Lagus, 1996)
  neigh = som_mdist(sMap.codebook).*som_unit_neighs(sMap);
  [bmus qerrors] = som_bmus(sMap, D, [1 2]);
  d = qerrors(:,1);
  for k = 1:dlen
    if neigh(bmus(k,1), bmus(k,2)) > 0
      d(k) = d(k) + neigh(bmus(k,1), bmus(k,2));
    else
      d(k) = d(k) + dijkstraKay(neigh, bmus(k,1), bmus(k,2));
    end
  end
  cbe = mean(d);
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%