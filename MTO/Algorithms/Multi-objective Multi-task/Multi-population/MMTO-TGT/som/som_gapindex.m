function [t,r,Cd,S] = som_gapindex(sM, base, between)
 
% SOM_GAPINDEX Gap clustering evaluation index.
%
% [t,r] = som_gapindex(sM, base, [between])
%
%  Input and output arguments ([]'s are optional):  
%    sM        (struct) map struct
%    base      (vector) clusters indeces for each map unit, map units
%                       with index<=0 or NaN are not taken into account
%    [between] (vector) indices of prototypes which are "between" clusters:
%                       the associated distances are doubled
% 
%    t         (scalar) Gap index index for the clustering (=mean(r))
%    r         (vector) maximum Gap index for each cluster (size max(base) x 1)    
% 
% See also  KMEANS, KMEANS_CLUSTERS, SOM_GAPINDEX.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3, between = find(isnan(base)); end

nc = max(base); 
cinds = cell(nc,1); 
for i=1:nc, cinds{i} = find(base==i); end
 
% distances between neighboring prototypes
Ne = som_neighbors(sM,'N1'); 
Md = som_mdist(sM.codebook,2,[],Ne);
Md(Ne==0) = NaN;

Md(between,:) = Md(between,:)*2;
Md(:,between) = Md(:,between)*2;
Md(between,between) = Md(between,between)/2;
 
% dispersion in each cluster 
S = zeros(nc,1);
for i=1:nc, 
    inds = setdiff(cinds{i},between);    
    if any(inds), 
        indist = Md(inds,inds); 
        for j=1:size(indist,1), indist(j,j) = NaN; end
        indist = indist(isfinite(indist(:))); 
        if any(indist), S(i) = mean(indist); end
    end
end 
 
% distances between clusters
Cd = zeros(nc,nc) + NaN;
for i=1:nc,
    inds1 = cinds{i}; 
    for j=1:nc, 
        inds2 = cinds{j}; 
	od = Md(inds1,inds2); 
	od = od(isfinite(od(:)));
	if any(od), Cd(i,j) = mean(od(:)); end        
    end    
end

% Gap index
R = NaN * zeros(nc);
for i = 1:nc
  for j = i+1:nc
    R(i,j) = (S(i) + S(j))/Cd(i,j);
    R(j,i) = R(i,j); 
  end
end
r = max(R,[],2);
 
t = mean(r(isfinite(r)));
 
return; 
