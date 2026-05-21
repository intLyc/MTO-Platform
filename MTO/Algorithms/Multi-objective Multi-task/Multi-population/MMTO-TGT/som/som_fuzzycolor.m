function [color,X]=som_fuzzycolor(sM,T,R,mode,initRGB,S)

% SOM_FUZZYCOLOR Heuristic contraction projection/soft cluster color coding for SOM 
% 
% function [color,X]=som_fuzzycolor(map,[T],[R],[mode],[initRGB],[S])
%
%  sM        (map struct)
%  [T]       (scalar) parameter that defines the speed of contraction 
%              T<1: slow contraction, T>1: fast contraction. Default: 1
%  [R]       (scalar) number of rounds, default: 30
%  [mode]    (string) 'lin' or 'exp', default: 'lin'  
%  [initRGB] (string) Strings accepted by SOM_COLORCODE,  default: 'rgb2'
%  [S]       (matrix) MxM matrix a precalculated similarity matrix 
%  color     (matrix) of size MxRx3 resulting color codes at each step 
%  X         (matrix) of size MxRx2 coordiantes for projected unit weight vectors 
%             at each step of iteration. (Color code C is calculated using this
%             projection.)
%
% The idea of the projection is to use a naive contraction model which
% pulls the units together. Units that are close to each other in the
% output space (clusters) contract faster into the same point in the
% projection. The original position for each unit is its location in
% the topological grid.
% 
% This is an explorative tool to color code the map units so that
% similar units (in the sense of euclidean norm) have similar coloring
% (See also SOM_KMEANSCOLOR) The tool gives a series of color codings
% which start from an initial color coding (see SOM_COLORCODE) and
% show the how the fuzzy clustering process evolves.
%
% The speed of contraction is controlled by the input parameter T. If
% it is high the projection contracts more slowly and reveals more
% intermediate stages (hierarchy).  A good value for T must be
% searched manually. It is probable that the default values do not
% yield good results.
%
% The conatrction process may be slow. In this case the mode can be
% set to 'exp' instead of 'lin', however, then the computing becomes
% heavier.
%
% EXAMPLE
%
%  load iris; % or any other map struct sM 
%  [color]=som_fuzzycolor(sM,'lin',10);
%  som_show(sM,'color',color);
%
% See also SOM_KMEANSCOLOR, SOM_COLORCODE, SOM_CLUSTERCOLOR
%
% REFERENCES
% 
% Johan Himberg, "A SOM Based Cluster Visualization and Its
% Application for False Coloring", in Proceedings of International
% Joint Conference on Neural Networks (IJCNN2000)},
% pp. 587--592,Vol. 3, 2000
% 
% Esa Alhoniemi, Johan Himberg, and Juha Vesanto, Probabilistic
% Measures for Responses of Self-Organizing Map Units, pp. 286--290,
% in Proceedings of the International ICSC Congress on Computational
% Intelligence Methods and Applications (CIMA '99)}, ICSC Academic
% Press}, 1999
%
% Outline of the heuristic
%
% First a matrix D of squared pairwise euclidean distances
% D(i,j)=d(i,j)^2 between map weight vectors is calculated. This
% matrix is transformed into a similarity matrix S,
% s(i,j)=exp(-(D(i,j)/(T.^2*v)), where T is a free input parameter and
% v the variance of all elements of D v=var(D(:)). The matrix is
% further normalized so that all rows sum to one. The original
% topological coordinates X=som_unit_coords(sM) are successively
% averaged using this matrix. X(:,:,i)=S^i*X(:,:,1); As the process is
% actually a series of successive weighted averagings of the initial
% coordinates, all projected points eventually contract into one
% point.  T is a user defined parameter that defines how fast the
% projection contracts into this center point. If T is too small, the
% process will end into the center point at once.
% 
% In practise, we don't calculate powers of S, but compute
% 
%  X(:,:,i)=S.*X(:,:,i-1); % mode: 'lin'
%
% The contraction process may be slow if T is selected to be large,
% then for each step the similarity matrix is squared
%
%  X(:,:,i)=S*X(:,:,1); S=S*S % mode: 'exp'
%
% The coloring is done using the function SOM_COLORCODE according to
% the projections in X, The coordinates are rescaled in order to
% achieve maximum color resolution.

% Contributed to SOM Toolbox vs2, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Previously rownorm function normalized the rows of S erroneously
% into unit length, this major bug was corrected 14042003. Now the
% rownorm normalizes the rows to have unit sum as it should johan 14042003

%% Check input arguments

if isstruct(sM), 
   if ~isfield(sM,'topol')
      error('Topology field missing.');
   end
   M=size(sM.codebook,1);
else
   error('Requires a map struct.');
end

if nargin<2 || isempty(T),
   T=1;
end
if ~vis_valuetype(T,{'1x1'})
   error('Input for T must be a scalar.');
end

if nargin<3 || isempty(R),
   R=30;
end
if ~vis_valuetype(R,{'1x1'})
   error('Input for R must be a scalar.');
end

if nargin < 4 || isempty(mode),
   mode='lin';
end
if ~ischar(mode),
   error('String input expected for mode.');
else
   mode=lower(mode);
   switch mode
   case {'lin','exp'}
   otherwise
      error('Input for mode must be ''lin'' or ''exp''.');
   end
end

if nargin < 5 || isempty(initRGB)
   initRGB='rgb2';
end

if ischar(initRGB),   
   try
      dummy=som_colorcode(sM,initRGB);
   catch
      error(['Color code ''' initRGB ''' not known, see SOM_COLORCODE.']);
   end
else
   error('Invalid color code string');   
end

if nargin<6 || isempty(S),
   S=fuzzysimilarity(sM,1./T);
end

if ~vis_valuetype(S,{[M M]}),
   error('Similarity matrix must be a MunitsxMunits matrix.')
end

x = maxnorm(som_unit_coords(sM.topol.msize,sM.topol.lattice,'sheet'));

x = x-repmat(mean(x),size(x,1),1);

X(:,:,1)=x; 
color(:,:,1)=som_colorcode(x,'rgb2',1);

%%% Actions

for i=1:R,
   switch mode
   case 'exp'
      S=rownorm(S*S);
      tmpX=S*X(:,:,1);
   case 'lin'
      tmpX=S*X(:,:,i);
   end
   X(:,:,i+1)=tmpX;
   color(:,:,i+1)=som_colorcode(X(:,:,i+1),initRGB);
end

color(isnan(color))=0;

function r=fuzzysimilarity(sM,p)
  % Calculate a "fuzzy response" similarity matrix
  % sM: map
  % p: sharpness factor
  d=som_eucdist2(sM,sM);
  v=std(sqrt(d(:))).^2;
  r=rownorm(exp(-p^2*(d./v)));
  r(~isfinite(r))=0;
  return;


function X = rownorm(X)

  r = sum(X,2);
  X = X ./ r(:,ones(size(X,2),1)); 
  return;


function X = maxnorm(X)

  for i=1:size(X,2), r = (max(X(:,i))-min(X(:,i))); if r, X(:,i) = X(:,i) / r; end, end
  return; 
