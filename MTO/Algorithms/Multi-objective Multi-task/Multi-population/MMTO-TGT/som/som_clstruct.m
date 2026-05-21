function sC = som_clstruct(Z,varargin)

%SOM_CLSTRUCT Create a clustering struct or set its field values.
%
%  sC = som_clstruct(Z, [argID, value, ...]) 
%
%    Z  = linkage(pdist(sM.codebook));
%    sC = som_clstruct(Z); 
%    sC = som_clstruct(sC,'coord',som_vis_coords(lattice,msize));
%    sC = som_clstruct(sC,'color',som_colorcode(sM));
%    sC = som_clstruct(sC,'base',sC.base(som_bmus(sM,sD)));
%
%  Input and output arguments ([]'s are optional): 
%   Z         (matrix) size clen-1 x 3, where clen is the number of 
%                      base clusters. This is a clustering matrix 
%                      similar to that produced by LINKAGE in 
%                      Statistical Toolbox. See SOM_LINKAGE.
%             (struct) clustering struct (as produced by this function)
%   [argID,   (string) See below. Each pair is the fieldname and 
%    value]   (varies) the value to be given to that field.
%
%   sC        (struct) clustering struct
% 
%   The clustering struct is based on the assumption that there 
%   is a base partitioning of the SOM (or data) which is saved in 
%   the .base field of the struct. Then a hierarchical clustering
%   is applied to this base partitioning. The results are saved to 
%   .tree field of the struct. Each cluster (base and combined)
%   has also three properties: height, coordinate and color, which 
%   are used in the visualizations. The fields of the struct are:
%     .type   (string) 'som_clustering'
%     .name   (string) Identifier for the clustering.
%     .tree   (matrix) Size clen-1 x 3, as argument Z above. 
%     .base   (vector) Size dlen x 1, the basic groups of data 
%                      forming the base clusters, e.g. as a result 
%                      of partitive clustering. Allowed values are 
%                       1:clen indicating the base cluster
%                              to which the data belongs to. 
%                       NaN    indicating that the data has
%                              been ignored in the clustering
%                      By default [1:clen]. 
%     .height (vector) Size 2*clen-1 x 1, (clustering) height for each 
%                      cluster. By default 0 for each base cluster and
%                      .tree(:,3) for the others.
%     .coord  (matrix) Size 2*clen-1 x *, coordinate for each cluster, 
%                      By default the coordinates are set so that 
%                      the base clusters are ordered on a line, and the
%                      position of each combined cluster is average of 
%                      the base clusters that constitute it.
%     .color  (matrix) Size 2*clen-1 x 3, color for each cluster. 
%                      By default the colors are set so that the 
%                      base clusters are ordered on a line, like above,
%                      and then colors are assigned from the 'hsv' 
%                      colormap to the base clusters. The color
%                      of each combined cluster is average as above.
%
% Height, coord and color can also be specified in alternate forms:
%   'height' (vector) size 2*clen-1 x 1, if given explicitly
%                     size clen-1 x 1, specified heights of the 
%                          combined clusters (the base cluster heights
%                          are all = 0)
%                     size 0 x 0, default value is used
%   'coord'  (matrix) size 2*clen-1 x *, if given explicitly
%                     size clen x *, to give coordinates for base 
%                          clusters; the coordinate of combined clusters
%                          are averaged from these
%                     size dlen x *, to give coordinates of the 
%                          original data: the cluster coordinates are
%                          averaged from these based on base clusters
%                     size 0 x 0, default value is used
%   'color'  (matrix) as 'coord'
%
% See also  SOM_CLPLOT, SOM_CLVALIDITY, SOM_CLGET, SOM_CLLINKAGE.

% Copyright (c) 2000 by the SOM toolbox programming team.
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 180800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(Z), 
  base = Z.base; 
  color = Z.color; 
  coord = Z.coord; 
  height = Z.height; 
  name = Z.name; 
  Z = Z.tree; 
else
  base  = []; 
  color = []; 
  coord = []; 
  height = []; 
  name = ''; 
end    
clen  = size(Z,1)+1; 

i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'tree',   i=i+1; Z = varargin{i}; clen = size(Z,1)+1;
     case 'base',   i=i+1; base = varargin{i}; 
     case 'color',  i=i+1; color = varargin{i}; 
     case 'coord',  i=i+1; coord = varargin{i}; 
     case 'height', i=i+1; height = varargin{i}; 
     case 'name',   i=i+1; name = varargin{i}; 
     otherwise argok=0; 
    end
  else argok = 0; 
  end
  if ~argok, disp(['(som_clstruct) Ignoring invalid argument #' num2str(i+1)]); end
  i = i+1; 
end

if isempty(base), 
  dlen = clen; 
  base = 1:dlen; 
else
  dlen = length(base); 
  if any(base)>clen || any(base)<1, error('Incorrect base partition vector.'); end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% analysis of hierarchy

% order of base clusters
order = 2*clen-1; 
nonleaves = 1; 
while any(nonleaves), 
  j = nonleaves(1); 
  ch = Z(order(j)-clen,1:2);
  if j==1, oleft = []; else oleft = order(1:(j-1)); end
  if j==length(order), oright = []; else oright = order((j+1):length(order)); end
  order = [oleft, ch, oright];
  nonleaves = find(order>clen); 
end

% base cluster indeces for each non-base cluster
basecl = cell(clen-1,1); 
for i=1:clen-1, 
  c1 = Z(i,1); if c1>clen, c1 = basecl{c1-clen}; end
  c2 = Z(i,2); if c2>clen, c2 = basecl{c2-clen}; end
  basecl{i} = [c1 c2];   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set coordinates, color and height and make the struct

% coordinates
if size(coord,1)==2*clen-1, % this is ok already
else
  if size(coord,1)==0, % the default    
    [~,coord] = sort(order); 
    coord = coord'; 
  elseif size(coord,1)==dlen && dlen>clen, % coordinates given for original data
    codata = coord; 
    coord = zeros(clen,size(coord,2)); 
    for i=1:clen, coord(i,:) = mean(codata(find(base==i),:),1); end  
  end
  if size(coord,1)==clen, % average from base clusters
    coord = [coord; zeros(clen-1,size(coord,2))]; 
    for i=1:clen-1, coord(i+clen,:) = mean(coord(basecl{i},:),1); end
  else
    error('Incorrect coordinate matrix.'); 
  end
end

% color
if size(color,1)==2*clen-1, % this is ok already
else
  if size(color,1)==0, % the default
    color(order,:) = hsv(length(order)); 
  elseif size(color,1)==dlen && dlen>clen, % colors given for original data
    codata = color; 
    color = zeros(clen,3); 
    for i=1:clen, color(i,:) = mean(codata(find(base==i),:),1); end  
  end
  if size(color,1)==clen, % average from base clusters
    color = [color; zeros(clen-1,3)]; 
    for i=1:clen-1, color(i+clen,:) = mean(color(basecl{i},:),1); end
  else
    error('Incorrect color matrix.'); 
  end
end

% height 
if isempty(height), 
  height = [zeros(clen,1); Z(:,3)]; 
elseif length(height)==clen-1, 
  if size(height,2)==clen-1, height = height'; end
  height = [zeros(clen,1); height]; 
elseif length(height)~=2*clen-1, 
  error('Incorrect height vector.'); 
end

% make the struct
sC = struct('type','som_clustering',...
	    'name',name,'base',base,'tree',Z,...
	    'color',color,'coord',coord,'height',height); 
return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
