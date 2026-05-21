function [K,P] = som_estimate_gmm(sM, sD)

%SOM_ESTIMATE_GMM Estimate a gaussian mixture model based on map.
%
% [K,P] = som_estimate_gmm(sM, sD)
%
%  Input and output arguments:
%   sM    (struct) map struct
%   sD    (struct) data struct
%         (matrix) size dlen x dim, the data to use when estimating
%                  the gaussian kernels
%
%   K     (matrix) size munits x dim, kernel width parametes for 
%                  each map unit
%   P     (vector) size 1 x munits, a priori probability of each map unit
%
% See also SOM_PROBABILITY_GMM.

% Reference: Alhoniemi, E., Himberg, J., Vesanto, J.,
%   "Probabilistic measures for responses of Self-Organizing Maps", 
%   Proceedings of Computational Intelligence Methods and
%   Applications (CIMA), 1999, Rochester, N.Y., USA, pp. 286-289.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Esa Alhoniemi
% Copyright (c) by Esa Alhoniemi
% http://www.cis.hut.fi/projects/somtoolbox/

% ecco 180298 juuso 050100 250400

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[c, dim] = size(sM.codebook);
M = sM.codebook;

if isstruct(sD), D = sD.data; else D = sD; end
dlen = length(D(:,1));

%%%%%%%%%%%%%%%%%%%%%
% compute hits & bmus

[bmus, qerrs] = som_bmus(sM, D);
hits = zeros(1,c);
for i = 1:c, hits(i) = sum(bmus == i); end

%%%%%%%%%%%%%%%%%%%%
% a priori  

% neighborhood kernel
r  = sM.trainhist(end).radius_fin; % neighborhood radius
if isempty(r) || isnan(r), r=1; end
Ud = som_unit_dists(sM);
Ud = Ud.^2; 
r = r^2; 
if r==0, r=eps; end % to get rid of div-by-zero errors
switch sM.neigh, 
 case 'bubble',   H = (Ud<=r); 
 case 'gaussian', H = exp(-Ud/(2*r)); 
 case 'cutgauss', H = exp(-Ud/(2*r)) .* (Ud<=r);
 case 'ep',       H = (1-Ud/r) .* (Ud<=r);
end  

% a priori prob. = hit histogram weighted by the neighborhood kernel
P = hits*H;
P = P/sum(P);              

%%%%%%%%%%%%%%%%%%%%
% kernel widths (& centers)

K = ones(c, dim) * NaN; % kernel widths
for m = 1:c,
  w = H(bmus,m);
  w = w/sum(w);
  for i = 1:dim,
    d = (D(:,i) - M(m,i)).^2;   % compute variance of ith
    K(m,i) = w'*d;              % variable of centroid m
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
