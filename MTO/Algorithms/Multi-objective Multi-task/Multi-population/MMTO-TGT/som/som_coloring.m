function Col = som_coloring(sM,ncol,chaingap,dw)

% SOM_COLORING Make a SOM-based coloring for given data/map.
%
% Col = som_coloring(sM,[ncol],[chaingap],[dw])
% 
%  Col = som_coloring(sM,5);
%  som_show(sM,'color',Col); 
%
% Input and output arguments ([]'s are optional):
%  sM          (struct) map or data struct
%              (matrix) data matrix
%  [ncol]      (scalar) number of colors to use
%  [chaingap]  (scalar) size of gap in the color circle (see below), 
%                       0.1 by default
%  [dw]        (scalar) 1 = use input space distances to stretch
%                           the color circle (default) 
%                       0 = don't use
%
%  Col         (matrix) color for each data/codebook vector
%
% This function trains a 1-dimensional SOM using the input data
% (codebook of a SOM, or a set of data vectors). A color from the 
% color circle (see HSV function) is associated with each map unit, 
% and each data/codebook vector of the input data picks its color
% from its BMU on the 1-dimensional SOM. 
%
% If the chaingap argument == 0, the 1-dimensional map has a cylinder
% (in effect, a ring) topology. Otherwise, the topology is rectangular
% (in effect, a chain). 
%
% The colors are mapped to the 1-dimensional SOM simply by picking colors
% from the color circle. If chaingap>0, a slice of the color circle is
% removed before map units pick their colors from it. This creates a
% discontiuity in the coloring at the ends of the 1-dimensional SOM.
%
% If the dw argument == 0, the colors are picked from the color circle
% equidistantly. If not, the distances between the prototype vectors
% in the 1-dimensional SOM are taken into account.
%
% See also SOM_KMEANSCOLOR, SOM_KMEANSCOLOR2, SOM_FUZZYCOLOR.

% Contributed to SOM Toolbox 2.0, December 21st, 2001 by Juha Vesanto 
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta juuso 211201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(sM), 
  if strcmp(sM.type,'som_map'), ismap = 1; D = sM.codebook; 
  else ismap = 0; D = sM.data; 
  end
else ismap = 0; D = sM; 
end

if nargin<2 || isempty(ncol) || isnan(ncol), ncol = min(64,size(D,1)); end
if nargin<3 || isempty(chaingap) || isnan(chaingap), chaingap = 0.1; end
if nargin<4 || isempty(dw) || isnan(dw), dw = 1; end

if chaingap == 0, lattice = 'sheet'; else lattice = 'cyl'; end
sMring = som_make(D,'msize',[1,ncol],lattice,'tracking',0);
b = som_bmus(sMring,D);

Colmap = hsv(ceil(ncol*(1+chaingap))); 
Colmap = Colmap(1:ncol,:);

if dw, % take distances in input space into account
  dist = sqrt(sum((sMring.codebook-sMring.codebook([2:end 1],:)).^2,2));  
  ind  = round([0; cumsum(dist)/sum(dist)]*(ncol-1)) + 1;
  Colmap = Colmap(ind,:);
end  
Col = Colmap(b,:); 

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% visualization
  if ismap, 
    a = som_bmus(sM.codebook,sMring.codebook); 
    if chaingap==0, a(end+1) = a(1); end
    som_show(sM,'color',Col); 
    som_show_add('traj',a) 
  else
    i = find(sum(isnan(D),2)==0); 
    [P,V,me] = pcaproj(D(i,:),2); 
    Pr = pcaproj(sMring.codebook,V,me);
    a = som_bmus(D(i,:),sMring.codebook); % Pr = P(a,:);
    som_grid({'rect',[length(i) 1]},'line','none',...
             'coord',P,'markercolor',Col(i,:));
    hold on
    if chaingap==0, Pr(end+1,:) = Pr(1,:); end
    som_grid({'rect',[size(Pr,1) 1]},'linecolor','k',...
             'linewidth',2,'markercolor','k','coord',Pr);
  end


