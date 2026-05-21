function a = som_clget(sC, mode, ind)

%SOM_CLGET Get properties of specified clusters.
%
%  a = som_clget(sC, mode, ind)
% 
%     inds = som_clget(sC,'dinds',20); 
%     col  = som_clget(sC,'depth',[1 2 3 20 54]); 
%
%  Input and output arguments: 
%    sC     (struct) clustering struct
%    mode   (string) what kind of property is requested
%                    'binds' (a union over) indeces of base clusters 
%                            belonging to the specified cluster(s)
%                    'dinds' (a union over) indeces of the data vectors 
%                            belonging to the specified cluster(s)
%                    'dlen'  number of data vectors belonging 
%                            to each of the specified cluster(s)
%                    'depth' depths of the specified clusters
%                            (depth of the root cluster is 0, 
%                             depth of its children are 1, etc.)
%                    'child' (a union over) children clusters 
%                             of specified cluster(s), including
%                             the clusters themselves
%                    'base'  base partitioning based on given 
%                            clusters
%    ind    (vector) indeces of the clusters
%    
%    a      (vector) the answer
%
% See also  SOM_CLSTRUCT, SOM_CLPLOT.

% Copyright (c) 2000 by the SOM toolbox programming team.
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 180800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clen = size(sC.tree,1)+1; 

switch mode, 
 case 'binds', 
  a = []; 
  for i=1:length(ind), a = [a, getbaseinds(sC.tree,ind(i))]; end
  a = unique(a);
 case 'dinds', 
  b = []; 
  for i=1:length(ind), b = [b, getbaseinds(sC.tree,ind(i))]; end
  b = unique(b);
  a = zeros(length(sC.base),1); 
  for i=1:length(b), a(find(sC.base==b(i)))=1; end
  a = find(a); 
 case 'dlen', 
  a = zeros(length(ind),1); 
  for i=1:length(ind), 
    b = getbaseinds(sC.tree,ind(i)); 
    for j=1:length(b), a(i) = a(i) + sum(sC.base==b(j)); end
  end
 case 'depth', 
  a = getdepth(sC.tree); 
  a = a(ind);
 case 'child', 
  a = getchildren(sC.tree,ind); 
 case 'base',
  a = sC.base*0; 
  ind = -sort(-ind);
  for i=1:length(ind), a(som_clget(sC,'dinds',ind(i))) = ind(i); end
end

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ch = getchildren(Z,ind)

  clen = size(Z,1)+1; 
  ch = ind; cho = ind; 
  while any(cho), 
    i = cho(1); cho = cho(2:end); 
    j = Z(i-clen,1); k = Z(i-clen,2); 
    if j>clen, cho(end+1) = j; end
    if k>clen, cho(end+1) = k; end
    ch(end+1) = j; ch(end+1) = k; 
  end
  return;

function binds = getbaseinds(Z,ind)

  clen = size(Z,1)+1; 
  binds = ind; 
  while binds(1)>clen,   
    i = binds(1); 
    binds = binds(2:end); 
    j = Z(i-clen,1); k = Z(i-clen,2);  
    if j>clen, binds = [j binds]; else binds(end+1) = j; end
    if k>clen, binds = [k binds]; else binds(end+1) = k; end
  end
  return;

function depth = getdepth(Z)

  clen = size(Z,1)+1; 
  depth = zeros(2*clen-1,1); 
  ch = 2*clen-1; % active nodes
  while any(ch), 
    c  = ch(1); ch = ch(2:end);
    if c>clen && isfinite(Z(c-clen,3)), 
      chc = Z(c-clen,1:2); % children of c
      depth(chc) = depth(c) + 1; % or +(ind==chc(1))
      ch = [ch, chc]; 
    end
  end
  return; 
