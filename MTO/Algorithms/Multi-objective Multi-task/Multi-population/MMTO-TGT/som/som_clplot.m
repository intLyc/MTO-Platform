function h = som_clplot(sC,varargin)

%SOM_CLPLOT Visualize clustering.
% 
% h = som_clplot(sC, [[argID,] value, ...])
% som_clplot(sM, part)
% 
%   som_clplot(sC);
%   som_clplot(som_clstruct(Z))
%   som_clplot(sC,sM);
%   som_clplot(sC,'coord',P);
%   som_clplot(sC,'dendrogram',[1 1 1 1 0 0 1 1 0 0 1]);
%   som_clplot(sC,'linewidth',10);
%   som_clplot(sC,'size',10);
%   som_clplot(sM,part);
%    
%  Input and output arguments ([]'s are optional):    
%   sC        (struct) clustering struct, as produced by SOM_CLSTRUCT
%   [argID,   (string) See below. Each pair is the fieldname and 
%    value]   (varies) the value to be given to that field.
%   sM        (struct) map struct
%   part      (vector) length = munits, partitioning for the map
%
%   h         (vector) handles to the arcs between 
%   
% Here are the valid argument IDs and corresponding values. The values 
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%   'linecolor' (string) color of the arc lines, 'k' by default
%               (vector) size 1 x 3
%   'linewidth' (scalar) width of the arc lines
%   'size'      (vector) length 2*clen-1, sizes for each of the 
%                        cluster markers
%               (scalar) this size is used for all cluster markers
%   'dendrogram'(vector) size 2*clen-1, indicates which clusters 
%                        are shown in the dendrogram
%              *(string) 'on' or 'off' ('on' by default)
%   'coord'     (matrix) size dlen x odim, the coordinates
%                        for the data. If odim<=2, these are used as is.
%                        Otherwise a 2-dimensional PCA-projection is
%                        first made (see function PCAPROJ). These
%                        coordinates are applied also to the clusters.
%              *(struct) data struct: as above
%                        map or topology struct: the coordinates given 
%                        by SOM_VIS_COORDS are used for the data 
%   'color'     (matrix) size dlen x 3, color for each data. By
%                        default the colors defined for base 
%                        clusters are used (sC.color(sC.base,:)).
%                        For ignored data figure background color is used. 
%               (vector) size dlen x 1, indexed colors are used
%
% See also SOM_CLSTRUCT, SOM_LINKAGE, SOM_CLPRUNE, LINKAGE, DENDROGRAM.

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 180600

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read the arguments

% sC
if strcmp(sC.type,'som_map'), 
  base = varargin{1}; 
  clen = length(unique(base(isfinite(base)))); 
  Z = ones(clen-1,3); 
  Z(:,1) = randperm(clen-1)'; 
  Z(:,2) = [clen:2*clen-2]'; 
  Z(:,3) = [1:clen-1]'; 
  sT = sC;
  sC = som_clstruct(Z,'base',varargin{1}); 
  h = som_clplot(sC,'coord',sT,'dendrogram','off',varargin{2:end}); 
  return; 
end
clen = size(sC.tree,1)+1; 

% varargin
show = 'on'; 
markersize = 10; 
linecolor = 'k'; 
linewidth = 1; 
datacoord = []; 
datacolor = []; 

i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'dendrogram', i=i+1; show = varargin{i}; 
     case 'size',       i=i+1; markersize = varargin{i}; 
     case 'linecolor',  i=i+1; linecolor = varargin{i}; 
     case 'linewidth',  i=i+1; linewidth = varargin{i};
     case 'color',      i=i+1; datacolor = varargin{i};
     case 'coord',      i=i+1; datacoord = varargin{i};
     case {'on','off'}, show = varargin{i}; 
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}), datacoord = varargin{i}; 
  else argok = 0; 
  end
  if ~argok, disp(['(som_clplot) Ignoring invalid argument #' num2str(i+1)]); end
  i=i+1;
end

% markersize
if length(markersize)==1, markersize = ones(2*clen-1,1)*markersize; end

% datacoord
if ~isempty(datacoord),
  if isstruct(datacoord), 
    switch datacoord.type, 
     case 'som_map',   datacoord = datacoord.topol;
     case 'som_topol', %nil 
     case 'som_data',  datacoord = datacoord.data;
     otherwise,        datacoord = []; 
    end  
  end
  if isstruct(datacoord), 
    sC = som_clstruct(sC,'coord',som_vis_coords(datacoord.lattice,datacoord.msize));
  else
    [dlen dim] = size(datacoord);
    if dim>2, datacoord = pcaproj(datacoord,2); end
    sC = som_clstruct(sC,'coord',datacoord);
  end
end

% show
if ischar(show), show = strcmp(show,'on'); end
if numel(show) == 1, show = ones(2*clen-1,1)*show; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize values

% find the children to show for each cluster
sTree0 = struct('parent',0,'children',[]); 
sTree = sTree0; 
for i=2:(2*clen-1), sTree(i) = sTree0; end
for i=(clen+1):(2*clen-1), 
  if isfinite(sC.tree(i-clen,3)), 
    ch = sC.tree(i-clen,1:2);
    sTree(i).children = ch; 
    for j=1:length(ch), sTree(ch(j)).parent = i; end
  end  
end
if any(show==0), % some clusters are not shown
  for i=(clen+1):(2*clen-1), 
    if ~show(i),
      p = sTree(i).parent;
      ch = sTree(i).children;
      if p, 
	j = find(sTree(p).children == i);
	sTree(p).children = [sTree(p).children([1:(j-1),(j+1):end]), ch]; 
	for j=1:length(ch), sTree(ch(j)).parent = p; end
      end
    end    
  end  
end

% the arcs
lfrom = []; lto = []; ladd = [];
for i=(clen+1):(2*clen-1),   
  if show(i), 
    ch = sTree(i).children'; 
    %ch = ch(find(show(ch)==1)); 
    lfrom = [lfrom; i*ones(length(ch),1)]; 
    lto = [lto; ch];     
  end
end

% infinite height
%isinf = ~isfinite(sC.height); 
%sC.height(isinf) = 2*max(sC.height(~isinf)); 

% the coordinates of the arcs
Co = [sC.coord, sC.height];
if size(Co,2)==2, 
  Lx = [Co(lfrom,1),   Co(lto,1),     Co(lto,1)];
  Ly = [Co(lfrom,end), Co(lfrom,end), Co(lto,end)];
  Lz = []; 
else
  Lx = [Co(lfrom,1),   Co(lto,1),     Co(lto,1)];
  Ly = [Co(lfrom,2),   Co(lto,2),     Co(lto,2)];
  Lz = [Co(lfrom,end), Co(lfrom,end), Co(lto,end)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot

washold = ishold; 
if ~washold, cla; hold on; end

% plot data
if ~isempty(datacoord), 
  if isempty(datacolor),
    nancolor = get(gcf,'Color'); 
    Col = nancolor(ones(length(sC.base),1),:);
    ind = find(isfinite(sC.base)); 
    Col(ind,:) = sC.color(sC.base(ind),:); 
  elseif size(datacolor,2)==1, Col = som_normcolor(datacolor,jet); 
  else Col = datacolor;     
  end    
  if isstruct(datacoord), som_cplane(datacoord,Col);
  else som_grid('rect',[length(sC.base) 1],'line','none',...
		'Coord',datacoord,'Markercolor',Col); 
  end
end

h = []; 
if any(show), 

  % plot the lines
  if isempty(Lz), 
    h = line(Lx',Ly','color',linecolor,'linewidth',linewidth); 
  else 
    h = line(Lx',Ly',Lz','color',linecolor,'linewidth',linewidth); 
    if ~washold, view(3); end
    rotate3d on
  end
  
  % plot the nodes
  inds = find(show); 
  som_grid('rect',[length(inds) 1],'line','none',...
	   'Coord',Co(inds,:),...
	   'Markercolor',sC.color(inds,:),...
	   'Markersize',markersize(inds));
end

if ~washold, hold off, end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



  