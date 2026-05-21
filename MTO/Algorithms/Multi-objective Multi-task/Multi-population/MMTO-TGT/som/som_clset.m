function [sC,old2new,newi] = som_clset(sC,action,par1,par2)

% SOM_CLSET Create and/or set values in the som_clustering struct.
%
%   first argument
%     sC       (struct) a som_clustering struct
%     Z        (matrix) size nb-1 x 3, as given by LINKAGE function
%     base     (vector) size dlen x 1, a partitioning of the data
%
%   actions    
%     'remove'           removes the indicated clusters (par1: vector)
%     'add'              add a cluster by making a combination of the indicated
%                        clusters (par1: vector)
%     %'move'             moves a child cluster (par1: scalar) from a parent to another
%     %                   (par2: vector 1 x 2)
%     'merge'            like 'add', followed by removing the indicated clusters (par1: vector)
%     %'split'            the indicated cluster (par1: scalar) is partitioned into indicated
%     %                   parts (par2: vector), which are then added, while the indicated cluster
%     %                   (par1) is removed
%     'coord'            sets the coordinates of base clusters (par1: matrix nb x *), and 
%                        recalculates coordinates of the derived clusters (by averaging base cluster
%                        coordinates)
%     'color'            sets the colors of base clusters (par1: matrix nb x 3), and recalculates
%                        colors of the derived clusters (as averages of base cluster colors)
%                        
%   sC
%     .type     (string) 'som_clustering'
%     .name     (string) Identifier for the clustering.
%     .nb       (scalar) Number of base clusters in the clustering.
%     .base     (vector) Size dlen x 1, the basic groups of data 
%                        forming the base clusters, e.g. as a result 
%                        of partitive clustering. Allowed values are 
%                         1:nb   indicating the base cluster
%                                to which the data belongs to. 
%                         NaN    indicating that the data has
%                                been ignored in the clustering                        
%     .nc       (scalar) Number of clusters in the clustering (nb + derived clusters).
%     .children (cellarray) size nc x 1, each cell gives the list of indeces
%                        of child clusters for the cluster
%     .parent   (vector) size nc x 1, the index of parent of each cluster 
%                        (or zero if the cluster does not have a parent)
%     .coord    (matrix) size nc x *, visualization coordinates for each cluster
%                        By default the coordinates are set so that 
%                        the base clusters are ordered on a line, and the
%                        position of each combined cluster is average of 
%                        the base clusters that constitute it.
%     .color    (matrix) size nc x 3, color for each cluster. 
%                        By default the colors are set so that the 
%                        base clusters are ordered on a line,
%                        and then colors are assigned from the 'hsv' 
%                        colormap to the base clusters. The color
%                        of each combined cluster is average as above.
%     .cldist   (string) Default cluster distance function.

inew = []; 
if isstruct(sC), 
    % it should be a som_clustering struct
    old2new = [1:sC.nc];
elseif size(sC,2)==3, 
    % assume it is a cluster hierarchy matrix Z 
    sC = Z2sC(sC); 
    old2new = [1:sC.nc];
else
    % assume it is a partitioning vector
    base = sC; 
    u = unique(base(isfinite(base)));
    old2new = sparse(u,1,1:length(u));
    base = old2new(base);
    sC = part2sC(base); 
end 

switch action, 
case 'remove',        
    for i=1:length(par1),         
        [sC,o2n] = removecluster(sC,old2new(par1(i)));
        old2new = o2n(old2new);
    end 
case 'add', 
    [sC,old2new,inew] = addmergedcluster(sC,par1);    
case 'move',
    % not implemented yet
case 'split', 
    % not implemented yet
case 'merge', 
    [sC,old2new,inew] = addmergedcluster(sC,par1);
    for i=1:length(par1), 
        [sC,o2n] = removecluster(sC,old2new(par1(i)));
        old2new = o2n(old2new);
    end 
case 'color', 
    sC.color = derivative_average(sC,par1);
case 'coord',
    sC.coord = derivative_average(sC,par1);
end 

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function sC = clstruct(nb,nc)

    sC = struct('type','som_clustering',...
                'name','','base',[],'nb',nb,'nc',nc,...
                'parent',[],'children',[],'coord',[],'color',[],'cldist','centroid');
    sC.base = [1:nb]; 
    sC.parent = zeros(nc,1);
    sC.children = cell(nc,1); sC.children(:) = {[]}; 
    sC.coord = zeros(nc,2);
    sC.color = zeros(nc,3);
    return;

function Z = sC2Z(sC,height)

    if nargin<2, height = 'level'; end

    root   = find(sC.parent==0); 
    order  = [root]; 
    ch     = sC.children(root); 
    while any(ch), i = ch(1); order = [ch(1), order]; ch = [ch(2:end), sC.children{i}]; end 

    he = zeros(sC.nc,1); 
    if strcmp(height,'level'), 
        ch = sC.children{root}; 
        while any(ch),
            i = ch(1); he(i) = he(sC.parent(i))+1; 
            ch = [ch(2:end), sC.children{i}]; 
        end 
        he = max(he)-he; 
    elseif strcmp(height,'level2'), 
        for i=order, if any(sC.children{i}), he(i) = max(he(sC.children{i}))+1; end, end
    else
        %he = som_cldist ( between children )
    end 
    
    Z = zeros(sC.nb-1,3);    
    i = sC.nb-1; 
    inds = root; 
    while i>0, 
        ch = sC.children{inds(1)}; h = he(inds(1)); inds = [inds(2:end), ch]; 
        if length(ch)>=2,
            for k=1:length(ch)-2, Z(i,:) = [i-1, ch(k), h]; i = i - 1; end
            Z(i,:) = [ch(end-1) ch(end) h]; i = i - 1;             
        end 
    end 
    return;

function sC = Z2sC(Z)

    nb        = size(Z,1)+1;
    nc        = 2*nb-1;
    sC        = clstruct(nb,nc);
    sC.base   = [1:nb];
    for i=1:nc, 
        j = find(Z(:,1)==i | Z(:,2)==i); 
        sC.parent(i) = nb+j;
        sC.children{sC.parent(i)}(end+1) = i; 
    end 
    % coords and color
    order = nc; 
    nonleaves = 1; 
    while any(nonleaves), 
        j = nonleaves(1); 
        ch = sC.children{order(j)};
        if j==1, oleft = []; else oleft = order(1:(j-1)); end
        if j==length(order), oright = []; else oright = order((j+1):length(order)); end
        order = [oleft, ch, oright];
        nonleaves = find(order>nb); 
    end
    [~,co] = sort(order);     
    sC.coord   = derivative_average(sC,co');
    H          = hsv(nb+1);
    sC.color   = derivative_average(sC,H(co,:));    
    return;
    
function sC = part2sC(part)

    nb      = max(part); 
    nc      = nb+1; 
    sC      = clstruct(nb,nc);
    sC.base = part; 
    sC.parent(1:nb) = nc; 
    sC.children{nc} = [1:nb]; 
    co       = [1:nb]'; 
    sC.coord = derivative_average(sC,co);
    H        = hsv(nb+1);
    sC.color = derivative_average(sC,H(1:nb,:));
    return;

function [sC,old2new] = removecluster(sC,ind)
  
    old2new = [1:sC.nc]; 
    parent_ind = sC.parent(ind);
    ch = sC.children{ind};
    if ~parent_ind, 
        % trying to remove root cluster - no go
        return; 
    elseif ~any(ch), 
        % trying to remove a base cluster - no go
        return;
    else
        % ok, proceed
        old2new = [1:ind-1 0 ind:sC.nc-1];
        % update parent and child fields
        sC.parent(ch) = parent_ind;
        sC.children{parent_ind} = setdiff([sC.children{parent_ind}, ch],ind);
        % remove old cluster
        j = [1:ind-1, ind+1:sC.nc]; 
        sC.parent   = sC.parent(j);
        sC.children = sC.children(j);
        sC.color    = sC.color(j,:);
        sC.coord    = sC.coord(j,:);
        sC.nc       = sC.nc-1; 
        % update old indeces to new indices
        sC.parent = old2new(sC.parent);
        for i=1:sC.nc, sC.children{i} = old2new(sC.children{i}); end
    end     
    return;

function [sC,old2new,inew] = addmergedcluster(sC,inds)

    old2new    = [1:sC.nc]; 
    inew       = 0; 
    p_inds     = sC.parent(inds); 
    if ~all(p_inds(1)==p_inds),  
        % clusters are not siblings - no go
        return;
    end
    parent_ind = p_inds(1); 
    if isempty(setdiff(sC.children{parent_ind},inds)),  
        % such a merged cluster exists already
        return;     
    else
        % ok, proceed
        inew = parent_ind;
        old2new = [1:inew-1,inew+1:sC.nc+1];
        % add the new cluster (=copy of parent_ind) 
        j = [1:inew,inew:sC.nc];
        sC.parent   = sC.parent(j);
        sC.children = sC.children(j);
        sC.color    = sC.color(j,:);
        sC.coord    = sC.coord(j,:);
        sC.nc       = sC.nc+1;
        % update old indeces to new indices
        sC.parent = old2new(sC.parent);
        for i=1:sC.nc, sC.children{i} = old2new(sC.children{i}); end
        inds = old2new(inds);
        parent_ind = old2new(parent_ind);
        % update parent, child, color and coord fields
        sC.parent(inds)         = inew; 
        sC.parent(inew)         = parent_ind;
        sC.children{inew}       = inds; 
        sC.children{parent_ind} = [setdiff(sC.children{parent_ind}, inds), inew];
        b = baseind(sC,inew); 
        sC.color(inew,:)        = mean(sC.color(b,:));
        sC.coord(inew,:)        = mean(sC.coord(b,:));
    end    
    return;
    
function C = derivative_average(sC,Cbase)

    [n dim] = size(Cbase);
    if n ~= sC.nb, error('Color / Coord matrix should have nb rows'); end
    C = zeros(sC.nc,dim);     
    for i=1:sC.nc, C(i,:) = mean(Cbase(baseind(sC,i),:)); end   
    return;
    
function bi = baseind(sC,ind)

    bi = [ind]; 
    i = 1; 
    while i<=length(bi), bi = [bi, sC.children{bi(i)}]; end 
    bi = bi(bi<=sC.nb);
    return;
  

      
      
