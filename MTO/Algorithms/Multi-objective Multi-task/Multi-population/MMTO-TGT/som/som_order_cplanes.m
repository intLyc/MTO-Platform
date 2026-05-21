function P = som_order_cplanes(sM, varargin)

%SOM_ORDER_CPLANES Orders and shows the SOM component planes.
%
% P = som_order_cplanes(sM, [[argID,] value, ...])
%
%  som_order_cplanes(sM);
%  som_order_cplanes(sM,'comp',1:30,'simil',C,'pca');
%  P = som_order_cplanes(sM);
%
%  Input and output arguments ([]'s are optional): 
%   sM       (struct) map or data struct
%            (matrix) a data matrix, size * x dim
%   [argID,  (string) See below. The values which are unambiguous can
%    value]  (varies) be given without the preceeding argID.
%
%   P        (matrix) size n x * (typically n x 2), the projection coordinates
%   
% Here are the valid argument IDs and corresponding values. The values
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%   'comp'    (vector) size 1 x n, which components to project, 1:dim by default
%   'simil'  *(string) similarity measure to use 
%                      'corr'        linear correlation between component planes
%                      'abs(corr)'   absolute value of correlation (default)
%                      'umat'        as 'abs(corr)' but calculated from U-matrices
%                      'mutu'        mutual information (not implemented yet)
%             (matrix) size n x n, a similarity matrix to be used             
%   'proj'   *(string) projection method to use: 'SOM' (default), 
%                      'pca', 'sammon', 'cca', 'order', 'ring'
%   'msize'   (vector) size of the SOM that is used for projection
%   'show'   *(string) how visualization is done: 'planes' (default), 
%                      'names', or 'none'
%   'mask'    (vector) dim x 1, the mask to use, ones(dim,1) by default
%   'comp_names' (cell array) of strings, size dim x 1, the component names
%
% The visualized objects have a callback associated with them: by
% clicking on the object, the index and name of the component are printed
% to the standard output.
% 
% See also SOM_SHOW.

% Copyright (c) 2000 by the SOM toolbox programming team.
% Contributed to SOM Toolbox on June 16th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 120600 070601

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% sM
if isstruct(sM), 
  switch sM.type
  case 'som_map', 
    D = sM.codebook; dim = size(D,2); cnames = sM.comp_names; mask = sM.mask; 
    ismap = 1; 
  case 'som_data', 
    D = sM.data; dim = size(D,2); cnames = sM.comp_names; mask = ones(dim,1); 
    ismap = 0; 
  otherwise, error('Invalid first argument.');
  end                  
else
  D = sM; 
  dim = size(D,2); mask = ones(dim,1);
  cnames = cell(dim,1); 
  for i = 1:dim, cnames{i} = sprintf('Variable%d',i); end
  ismap = 0; 
end

% defaults
comps = 1:dim; 
simil = 'abs(corr)';
proj = 'SOM'; 
show = 'planes'; 
mapsize = NaN;

% varargin
i=1;
while i<=length(varargin),
  argok = 1;
  if ischar(varargin{i}),
    switch varargin{i},
     % argument IDs
     case 'mask',       i=i+1; mask = varargin{i};
     case 'comp_names', i=i+1; cnames = varargin{i};
     case 'comp',       i=i+1; comps = varargin{i}; 
     case 'proj',       i=i+1; proj = varargin{i}; 
     case 'show',       i=i+1; show = varargin{i}; 
     case 'simil',      i=i+1; simil = varargin{i}; 
     case 'msize',      i=i+1; mapsize = varargin{i};
     % unambiguous values
     case {'corr','abs(corr)','umat','mutu'}, simil = varargin{i}; 
     case {'SOM','pca','sammon','cca','order','ring'}, proj = varargin{i}; 
     case {'planes','names','none'}, show = varargin{i}; 
     otherwise argok=0;
    end
  else
    argok = 0;
  end
  if ~argok,
    disp(['(som_order_cplanes) Ignoring invalid argument #' num2str(i+1)]);
  end
  i = i+1;
end

if strcmp(show,'planes') && ~ismap, 
  warning('Given data is not a map: using ''names'' visualization.'); 
  show = 'names'; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% similarity matrix

fprintf(1,'Calculating similarity matrix\n');

% use U-matrix
if strcmp(simil,'umat'), 
  if ~ismap, error('Given data is not a map: cannot use U-matrix similarity.'); end
  U = som_umat(sM);
  D = zeros(numel(U),dim); 
  m = zeros(dim,1);
  for i=1:dim, m=m*0; m(i)=1; U = som_umat(sM,'mask',m); D(:,i) = U(:); end
end

% components
D = D(:,comps); 
cnames = cnames(comps);
mask = mask(comps);
dim = length(comps);
  
% similarity matrix
if ischar(simil), 
  switch simil, 
  case {'corr','abs(corr)','umat'}, 
    A = zeros(dim);
    me = zeros(1,dim);
    for i=1:dim, 
        me(i) = mean(D(isfinite(D(:,i)),i)); D(:,i) = D(:,i) - me(i); 
    end  
    for i=1:dim, 
      for j=i:dim, 
        c = D(:,i).*D(:,j); c = c(isfinite(c));
        A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
      end
    end
    s = diag(A); 
    A = A./sqrt(s*s');
    switch simil, 
    case {'abs(corr)','umat'}, A = abs(A); 
    case 'corr', A = A + 1; 
    end
  case 'mutu', 
    error('Mutual information not implemented yet.');
  end
else
  A = simil; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% projection

fprintf(1,'Projection\n');

mu = 2*dim; 

switch proj, 
 case 'SOM',

  if isnan(mapsize), 
    sMtmp = som_randinit(A,'munits',mu); 
    msize = sMtmp.topol.msize; 
  else 
    msize = mapsize; 
  end

  sM2 = som_make(A,'msize',msize,'rect','tracking',0);
  bm  = assign_unique_bm(sM2,A);
  Co  = som_unit_coords(sM2);
  P   = Co(bm,:);

 case 'ring', 

  if isnan(mapsize), msize = [1 mu]; else msize = mapsize; end

  sM2 = som_make(A,'msize',msize,'cyl','rect','tracking',0);
  bm  = assign_unique_bm(sM2,A);
  Co  = som_unit_coords(sM2);
  P   = Co(bm,[1 3]);   
  
 case 'order',

  if isnan(mapsize), msize = [1 mu]; else msize = mapsize; end

  sM2 = som_make(A,'msize',msize,'tracking',0);
  bm  = assign_unique_bm(sM2,A);
  [dummy,i] = sort(bm); 
  [dummy,P] = sort(i);
  if size(P,2)>1, P = P'; end
  if size(P,2)==1, P(:,2) = zeros(length(P),1); end

 case {'pca','sammon','cca'}, 
  P = pcaproj(A,2);  
  if strcmp(proj,'sammon'), P = sammon(A,P,50,'steps');
  elseif strcmp(proj,'cca'), P = cca(A,P,50);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% visualization

if ~strcmp(show,'none'), 
  fprintf(1,'Visualization\n');
  cla
  hold on
  if strcmp(show,'planes')
    s = findscaling(sM.topol.msize,P);
    for i=1:dim, 
      C = som_normcolor(D(:,i));
      if strcmp(simil,'umat'), 
	h=som_cplane([sM.topol.lattice 'U'],sM.topol.msize,C,1,s*P(i,:));
      else
	h=som_cplane(sM,C,1,s*P(i,:)); 
      end 
      set(h,'edgecolor','none','Userdata',sprintf('[%d] %s',i,cnames{i}));
      set(h,'ButtonDownFcn','fprintf(1,''%s\n'',get(gco,''UserData''))');
    end
  else 
    s=1; 
    a=[min(P(:,1))-1 max(P(:,1))+1 min(P(:,2))-1-3 max(P(:,2))+1-3];
    axis(s*a);
  end
  h=text(s*P(:,1),s*P(:,2)-3,cnames);
  for i=1:length(h), set(h(i),'Userdata',sprintf('[%d] %s',i,cnames{i})); end
  set(h,'ButtonDownFcn','fprintf(1,''%s\n'',get(gco,''UserData''))');
  hold off

  axis on; axis equal; axis tight; set(gca,'XTick',[],'YTick',[],'Box','on');
end

return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% subfunctions

function bm = assign_unique_bm(sM,D)

  munits = size(sM.codebook,1);
  [dlen dim] = size(D);
  margin = max(0,dlen-munits);

  [bm,qers] = som_bmus(sM,D); 
  bmi=ones(dim,1);  
  hits = som_hits(sM,D); 
  mult = find(hits>1); 
  while any(mult) && sum(hits(mult))-length(mult)>margin, 
    choices = find(bm==mult(1)); 
    while length(choices)>1,
      [dummy,mv] = max(qers(choices)); mv = choices(mv);
      [mv_to,q] = som_bmus(sM,D(mv,:),bmi(mv)); 
      bmi(mv)=bmi(mv)+1; qers(mv) = q; bm(mv) = mv_to;
      choices = find(bm==mv_to);
    end
    for i=1:length(hits), hits(i)=sum(bm==i); end
    mult = find(hits>1);
  end
  return;
  
function s = findscaling(msize,P)

  d1 = median(abs(diff(unique(sort(P(:,1))))));
  d2 = median(abs(diff(unique(sort(P(:,2))))));
  if d1>0, s1 = 1.5*msize(2)/d1; else s1 = 0; end
  if d2>0, s2 = 1.5*msize(1)/d2; else s2 = 0; end
  s = max(s1,s2);
  if s==0, s=1; end
  return; 

function alternative_SOM_plane_vis(sT,bm,simil,D,cnames)

  clf
  for i=1:size(D,2), 
    subplot(sT.msize(2),sT.msize(1),bm(i));
    if strcmp(simil,'umat'), h=som_cplane([sT.lattice 'U'],sT.msize,D(:,i));
    else h=som_cplane(sT,D(:,i)); 
    end
    set(h,'edgecolor','none');
    title(cnames{i});
    axis off
  end    
  return;

