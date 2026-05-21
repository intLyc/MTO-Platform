function [color,best,kmeans]=som_kmeanscolor(sM,C,initRGB,contrast)

% SOM_KMEANSCOLOR Map unit color code according to K-means clustering
%
% [color, best, kmeans] = som_kmeanscolor(sM, C, [initRGB],[contrast])
%
%  color        = som_kmeanscolor(sM,15,som_colorcode(sM,'rgb1'),'enhance');
%  [color,best] = som_kmeanscolor(sM,15,[],'normal');
%  
%  Input and output arguments ([]'s are optional):
%   sM       (struct) map struct
%   C        (scalar) maximum number of clusters
%   initRGB  (string, matrix) color code string accepted by SOM_COLORCODE
%                     or an Mx3 matrix of RGB triples, where M is the number
%                     of map units. Default: SOM_COLORCODEs default
%   contrast (string) 'flat', 'enhanced' color contrast mode, default:
%                     'enhanced'
%
%   color    (matrix) MxCx3 of RGB triples
%   best     (scalar) index for "best" clustering according to 
%                     Davies-Boulding index; color(:,:,best) includes the 
%                     corresponding color code.
%   kmeans   (cell)   output of KMEANS_CLUSTERS in a cell array.
% 
% The function gives a set of color codings according to K-means 
% clustering. For clustering, it uses function KMEANS_CLUSTERS for map units, 
% and it calculates color codings for 1,2,...,C clusters. 
% The idea of coloring is that the color of a cluster is the mean of the 
% original colors (RGB values) of the map units belonging to that cluster, 
% see SOM_CLUSTERCOLOR. The original colors are defined by  SOM_COLORCODE
% by default. Input 'contrast' simply specifies whether or not 
% to linearly redistribute R,G, and B values so that minimum is 0 and 
% maximum 1 ('enahanced')  or to use directly the output of 
% SOM_CLUSTERCOLOR ('flat'). KMEANS_CLUSTERS uses certain heuristics to 
% select the best of 5 trials for each  number of clusters. Evaluating the 
% clustering multiple times may take some time. 
%
% EXAMPLE
% 
%  load iris; % or any other map struct sM 
%  [color,b]=som_kmeanscolor(sM,10);
%  som_show(sM,'color',color,'color',{color(:,:,b),'"Best clustering"');
% 
% See also SOM_SHOW, SOM_COLORCODE, SOM_CLUSTERCOLOR, KMEANS_CLUSTERS

% Contributed to SOM Toolbox 2.0, April 1st, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% corrected help text 11032005 johan

%%% Check number of inputs

error(nargchk(2, 4, nargin));  % check no. of input args

%%% Check input args & set defaults

if isstruct(sM) && isfield(sM,'type') && strcmp(sM.type,'som_map'),
   [tmp,lattice,msize]=vis_planeGetArgs(sM);
   munits=prod(msize);
   if length(msize)>2 
      error('Does not work with 3D maps.')
   end
else
   error('Map struct requires for first input argument!');
end

if ~vis_valuetype(C,{'1x1'}),
   error('Scalar value expect for maximum number of clusters.');
end

% check initial color coding
if nargin<3 || isempty(initRGB)
   initRGB=som_colorcode(sM);
end

% check contrast checking
if nargin<4 || isempty(contrast),
   contrast='enhanced';
end

if ~ischar(contrast),
   error('String input expected for input arg. ''contrast''.');
else
   switch lower(contrast)
   case {'flat','enhanced'}
   otherwise 
      error(['''flat'' or ''enhanced'' expected for '...
            'input argument ''contrast''.']);
   end
end

if ischar(initRGB),
   try 
      initRGB=som_colorcode(sM,initRGB);
   catch
      error(['Color code ' initRGB ...
            'was not recognized by SOM_COLORCODE.']);
   end
elseif vis_valuetype(initRGB,{'nx3rgb',[munits 3]},'all'),
else
   error(['The initial color code must be a string '...
         'or an Mx3 matrix of RGB triples.']);
end

%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Wait...');
[c,p,err,ind]=kmeans_clusters(sM,C,5,0); % use 5 trials, verbose off

% Store outputs to kmeans
kmeans{1}=c; 
kmeans{2}=p; 
kmeans{3}=err; 
kmeans{4}=ind;

%%% Build output
color=som_clustercolor(sM,cat(2,p{:}),initRGB);
[tmp,best]=min(ind);

switch contrast
case 'flat'
case 'enhanced'
   warning off;
   ncolor=maxnorm(color);
   ncolor(~isfinite(ncolor))=color(~isfinite(ncolor));
   color=ncolor;
   warning on;
end

%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X=maxnorm(x)
% normalize columns of x between [0,1]

x=x-repmat(min(x),[size(x,1) 1 1]);
X=x./repmat(max(x),[size(x,1) 1 1]);
