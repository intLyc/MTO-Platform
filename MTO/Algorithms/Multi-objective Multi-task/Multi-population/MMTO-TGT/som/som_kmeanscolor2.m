function [color,centroids]=som_kmeanscolor2(mode,sM,C,initRGB,contrast,R)

% SOM_KMEANSCOLOR2 Color codes a SOM according to averaged or best K-means clustering
%
% color = som_kmeanscolor2('average',sM, C, [initRGB], [contrast],[R]) 
%
%  color=som_kmeanscolor2('average',sM,[2 4 8 16],som_colorcode(sM,'rgb1'),'enhanced');
%  [color,centroid]=som_kmeanscolor2('best',sM,15,[],'flat',R);
%  
%  Input and output arguments ([]'s are optional):
%
%   mode       (string) 'average' or 'best', defalut: 'average'
%   sM         (struct) a map struct
%   C          (vector) number of clusters
%   [initRGB]  (string, matrix) a color code string accepted by SOM_COLORCODE
%               or an Mx3 matrix of RGB triples, where M is the number
%               of map units. Default: SOM_COLORCODEs default
%   [contrast] (string) 'flat', 'enhanced' color contrast mode, default:
%               'enhanced'.
%   [R]        (scalar) number of K-means trials, default: 30.
%   color      (matrix) Mx3xC of RGB triples
%   centroid   (array of matrices) centroid{i} includes codebook for the best
%               k-means for C(i) clusters, i.e. the cluster centroids corresponding to
%               the color code color(:,:,i).
% 
% The function gives a set of color codes for the SOM according to K-means 
% clustering. It has two operation modes: 
% 
% 'average': The idea of coloring is that the color of the units belonging to the same 
%   cluster is the  mean of the original RGB values (see SOM_COLORCODE) of the map units 
%   belonging to the cluster (see SOM_CLUSTERCOLOR). The K-means clustering is made,
%   by default, 30 times and the resulting color codes are averaged for
%   each specified number of clusters C(i), i=1,...,k. In a way, the resulting averaged color 
%   codes reflect the stability of the K-means clustering made on the map units.
%
% 'best': runs the k-means R times for C(i), i=1,...,n clusters as in previous mode, 
%   but instead of averaging all the R color codes, it picks the one that corresponds to the 
%   best k-means clustering for each C(i). The 'best' is the one with the lowest 
%   quantization error. The result may differ from run to run.
%
% EXAMPLE
% 
%  load iris; % or any other map struct sM 
%  color=som_kmeanscolor2('average',sM,[2:6]);
%  som_show(sM,'umat','all','color',color);
% 
% See also SOM_KMEANS, SOM_SHOW, SOM_COLORCODE, SOM_CLUSTERCOLOR, SOM_KMEANSCOLOR

% Contributed to SOM Toolbox 2.0, 2001 February by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

%%% Check number of inputs

error(nargchk(3, 6, nargin));  % check no. of input args

%%% Check input args & set defaults

if ~vis_valuetype(mode,{'string'}),
   error('Mode must be a string.');
end
switch lower(mode),
case{'average','best'}
otherwise
   error('Mode must be string ''average'' or ''best''.');
end

if isstruct(sM) && isfield(sM,'type') && strcmp(sM.type,'som_map'),
   [tmp,lattice,msize]=vis_planeGetArgs(sM);
   munits=prod(msize);
   if length(msize)>2 
      error('Does not work with 3D maps.')
   end
else
   error('Map struct required for the second input argument!');
end

if ~vis_valuetype(C,{'1xn','nx1'}),
   error('Vector value expected for cluster number.');
end

% Round C and check
C=round(C(:)');

if any(C<2),
   error('Cluster number must be 2 or more.');
end

% check initial color coding
if nargin<4 || isempty(initRGB)
   initRGB=som_colorcode(sM);
end

% check contrast checking
if nargin<5 || isempty(contrast),
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

if nargin<6||isempty(R),
   R=30;
end

if ~vis_valuetype(R,{'1x1'}),
   error('''R'' must be scalar.');
end

%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Wait...');
index=0; hit_=zeros(munits,munits);

switch mode,
   %% Averaged k-means coloring
case 'average'
   for k=C,
      disp(['Running K-means for ' num2str(k) ' clusters...']); 
      color_=zeros(munits,3);
      colord_=color_;
      % Average R k-means colorings for C clusters
      for j=1:R,
         [dummy,c]=som_kmeans('batch',sM,k,100,0); % max 100 iterations, verbose off 
         color_=color_+som_clustercolor(sM,c,initRGB);
      end
      index=index+1;
      color(:,:,index)=color_./R;
   end
   
   %% coloring for 'best' k-means coloring
case 'best'
   for k=C,
      disp(['Running K-means for ' num2str(k) ' clusters...']);
      c=[];err=Inf; div=[];
      %% look for the best k-means among R trials
      for i=1:R,
         [c_,div_,err_(i)]=som_kmeans('batch',sM,k,100,0); % max 100 iterations, verbose off
         if err_(i)<err, 
            err=err_(i); c=c_; div=div_; 
         end
      end
      % record the 'best' k-means for C clusters
      index=index+1;
      color(:,:,index)=som_clustercolor(sM,div,initRGB);
      centroid{index}=c;   
   end
end

%%% Build output

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
