function [adm,admu,tdmu] = som_distortion(sM, D, arg1, arg2)

%SOM_DISTORTION Calculate distortion measure for the map.
%
% [adm,admu,tdmu] = som_distortion(sMap, D, [radius], ['prob'])
%
%  adm = som_distortion(sMap,D);
%  [adm,admu] = som_distortion(sMap,D);
%  som_show(sMap,'color',admu);
%
%  Input and output arguments: 
%   sMap     (struct) a map struct
%   D        (struct) a data struct
%            (matrix) size dlen x dim, a data matrix
%   [radius] (scalar) neighborhood function radius to be used.
%                     Defaults to the last radius_fin in the 
%                     trainhist field of the map struct, or 1 if
%                     that is missing.
%   ['prob'] (string) If given, this argument forces the 
%                     neigborhood function values for each map
%                     unit to be normalized so that they sum to 1.
%
%   adm      (scalar) average distortion measure (sum(dm)/dlen)
%   admu     (vector) size munits x 1, average distortion in each unit 
%   tdmu     (vector) size munits x 1, total distortion for each unit
%
% The distortion measure is defined as: 
%                                           2
%    E = sum sum h(bmu(i),j) ||m(j) - x(i)|| 
%         i   j    
% 
% where m(i) is the ith prototype vector of SOM, x(j) is the jth data
% vector, and h(.,.) is the neighborhood function. In case of fixed
% neighborhood and discreet data, the distortion measure can be
% interpreted as the energy function of the SOM. Note, though, that
% the learning rule that follows from the distortion measure is
% different from the SOM training rule, so SOM only minimizes the
% distortion measure approximately.
% 
% If the 'prob' argument is given, the distortion measure can be 
% interpreted as an expected quantization error when the neighborhood 
% function values give the likelyhoods of accidentally assigning 
% vector j to unit i. The normal quantization error is a special case 
% of this with zero incorrect assignement likelihood. 
% 
% NOTE: when calculating BMUs and distances, the mask of the given 
%       map is used.
%
% See also SOM_QUALITY, SOM_BMUS, SOM_HITS.

% Reference: Kohonen, T., "Self-Organizing Map", 2nd ed., 
%    Springer-Verlag, Berlin, 1995, pp. 120-121.
%
%    Graepel, T., Burger, M. and Obermayer, K., 
%    "Phase Transitions in Stochastic Self-Organizing Maps",
%    Physical Review E, Vol 56, No 4, pp. 3876-3890 (1997).

% Contributed to SOM Toolbox vs2, Feb 3rd, 2000 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 030200

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% input arguments
if nargin < 2, error('Not enough input arguments.'); end

% map
M = sM.codebook;
munits = prod(sM.topol.msize);

% data
if isstruct(D), D = D.data; end
[dlen dim] = size(D);

% arg1, arg2
rad = NaN;
normalize = 0;
if nargin>2, 
  if isnumeric(arg1), rad = arg1;
  elseif ischar(arg1) && strcmp(arg1,'prob'), normalize = 0;
  end
end
if nargin>3, 
  if isnumeric(arg2), rad = arg2;
  elseif ischar(arg2) && strcmp(arg2,'prob'), normalize = 0;
  end
end

% neighborhood radius
if isempty(rad) || isnan(rad), 
  if ~isempty(sM.trainhist), rad = sM.trainhist(end).radius_fin;
  else rad = 1; 
  end
end
if rad<eps, rad = eps; end

% neighborhood  
Ud = som_unit_dists(sM.topol); 
switch sM.neigh, 
 case 'bubble',   H = (Ud <= rad);
 case 'gaussian', H = exp(-(Ud.^2)/(2*rad*rad)); 
 case 'cutgauss', H = exp(-(Ud.^2)/(2*rad*rad)) .* (Ud <= rad);
 case 'ep',       H = (1 - (Ud.^2)/rad) .* (Ud <= rad);
end  
if normalize, 
  for i=1:munits, H(:,i) = H(:,i)/sum(H(:,i)); end
end

% total distortion measure
mu_x_1 = ones(munits,1);
tdmu = zeros(munits,1);
hits = zeros(munits,1);
for i=1:dlen,
  x = D(i,:);                        % data sample
  known = ~isnan(x);                 % its known components
  Dx = M(:,known) - x(mu_x_1,known); % each map unit minus the vector
  dist2 = (Dx.^2)*sM.mask(known);    % squared distances  
  [qerr bmu] = min(dist2);           % find BMU
  tdmu = tdmu + dist2.*H(:,bmu);     % add to distortion measure
  hits(bmu) = hits(bmu)+1;           % add to hits
end 

% average distortion per unit
admu = tdmu; 
ind = find(hits>0);
admu(ind) = admu(ind) ./ hits(ind);
  
% average distortion measure
adm = sum(tdmu)/dlen;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


