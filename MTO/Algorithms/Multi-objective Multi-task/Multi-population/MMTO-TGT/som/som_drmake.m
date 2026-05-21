function [sR,best,sig,Cm] = som_drmake(D,inds1,inds2,sigmea,nanis)

% SOM_DRMAKE Make descriptive rules for given group within the given data. 
%
% sR = som_drmake(D,[inds1],[inds2],[sigmea],[nanis]) 
% 
%  D        (struct) map or data struct
%           (matrix) the data, of size [dlen x dim]
%  [inds1]  (vector) indeces belonging to the group
%                    (the whole data set by default)
%  [inds2]  (vector) indeces belonging to the contrast group
%                    (the rest of the data set by default)
%  [sigmea] (string) significance measure: 'accuracy', 
%                    'mutuconf' (default), or 'accuracyI'.
%                    (See definitions below).
%  [nanis]  (scalar) value given for NaNs: 0 (=FALSE, default),
%                    1 (=TRUE) or NaN (=ignored)
%
%  sR      (struct array) best rule for each component. Each 
%                   struct has the following fields:
%    .type     (string) 'som_rule'
%    .name     (string) name of the component
%    .low      (scalar) the low end of the rule range
%    .high     (scalar) the high end of the rule range
%    .nanis    (scalar) how NaNs are handled: NaN, 0 or 1
%
%  best    (vector) indeces of rules which make the best combined rule
%  sig     (vector) significance measure values for each rule, and for the combined rule
%  Cm      (matrix) A matrix of vectorized confusion matrices for each rule, 
%                   and for the combined rule: [a, c, b, d] (see below). 
% 
% For each rule, such rules sR.low <= x < sR.high are found 
% which optimize the given significance measure. The confusion
% matrix below between the given grouping (G: group - not G: contrast group) 
% and rule (R: true or false) is used to determine the significance values:
%
%          G    not G    
%       ---------------    accuracy  = (a+d) / (a+b+c+d)
% true  |  a  |   b   |    
%       |--------------    mutuconf  =  a*a  / ((a+b)(a+c)) 
% false |  c  |   d   | 
%       ---------------    accuracyI =   a   / (a+b+c)
%
% See also  SOM_DREVAL, SOM_DRTABLE.

% Contributed to SOM Toolbox 2.0, January 7th, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 070102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if isstruct(D), 
  switch D.type, 
   case 'som_data', cn = D.comp_names; D = D.data; 
   case 'som_map',  cn = D.comp_names; D = D.codebook; 
  end  
else
  cn = cell(size(D,2),1);
  for i=1:size(D,2), cn{i} = sprintf('Variable%d',i); end
end

[dlen,dim] = size(D);
if nargin<2 || isempty(inds1), inds1 = 1:dlen; end
if nargin<3 || isempty(inds2), i = ones(dlen,1); i(inds1) = 0; inds2 = find(i); end
if nargin<4, sigmea = 'mutuconf'; end
if nargin<5, nanis = 0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

sig = zeros(dim+1,1); 
Cm  = zeros(dim+1,4); 

sR1tmp = struct('type','som_rule','name','','low',-Inf,'high',Inf,'nanis',nanis,'lowstr','','highstr','');
sR = sR1tmp;  

% single variable rules
for i=1:dim,
    
    % bin edges
    mi = min(D(:,i)); 
    ma = max(D(:,i)); 
    [histcount,bins] = hist([mi,ma],10); 
    if size(bins,1)>1, bins = bins'; end
    edges = [-Inf, (bins(1:end-1)+bins(2:end))/2, Inf];
    
    % find the rule for this variable
    [low,high,s,cm] = onevar_descrule(D(inds1,i),D(inds2,i),sigmea,nanis,edges);
    sR1 = sR1tmp;      
    sR1.name = cn{i}; 
    sR1.low = low; 
    sR1.high = high; 
    sR(i) = sR1; 
    sig(i) = s; 
    Cm(i,:) = cm; 
    
end  

% find combined rule
[dummy,order] = sort(-sig);
maxsig = sig(order(1)); bestcm = Cm(order(1),:);
best  = order(1);
for i=2:dim,    
    com = [best, order(i)];
    [s,cm,truex,truey] = som_dreval(sR(com),D(:,com),sigmea,inds1,inds2,'and');
    if s>maxsig, best = com; maxsig = s; bestcm = cm; end
end   
sig(end) = maxsig;
Cm(end,:) = cm; 

return;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% descriptive rules

function [low,high,sig,cm] = onevar_descrule(x,y,sigmea,nanis,edges)

  % Given a set of bin edges, find the range of bins with best significance.
  %
  %  x          data values in cluster
  %  y          data values not in cluster
  %  sigmea     significance measure
  %  bins       bin centers
  %  nanis      how to handle NaNs 

  % histogram counts
  if isnan(nanis), x = x(~isnan(x)); y = y(~isnan(y)); end
  [xcount,xbin] = histc(x,edges); 
  [ycount,ybin] = histc(y,edges); 
  xcount = xcount(1:end-1);
  ycount = ycount(1:end-1); 
  xnan=sum(isnan(x));
  ynan=sum(isnan(y));
    
  % find number of true items in both groups in all possible ranges
  n = length(xcount);
  V = zeros(n*(n+1)/2,4); 
  s1 = cumsum(xcount);
  s2 = cumsum(xcount(end:-1:1)); s2 = s2(end:-1:1);       
  m  = s1(end);      
  Tx = triu(s1(end)-m*log(exp(s1/m)*exp(s2/m)')+repmat(xcount',[n 1])+repmat(xcount,[1 n]),0); 
  s1 = cumsum(ycount); 
  s2 = cumsum(ycount(end:-1:1)); s2 = s2(end:-1:1);        
  Ty = triu(s1(end)-m*log(exp(s1/m)*exp(s2/m)')+repmat(ycount',[n 1])+repmat(ycount,[1 n]),0); 
  [i,j] = find(Tx+Ty);
  k = sub2ind(size(Tx),i,j);
  V = [i, j, Tx(k), Ty(k)];
  tix = V(:,3) + nanis*xnan; 
  tiy = V(:,4) + nanis*ynan; 
  
  % select the best range
  nix   = length(x);
  niy   = length(y);
  Cm    = [tix,nix-tix,tiy,niy-tiy];
  [s,k] = max(som_drsignif(sigmea,Cm));

  % output
  low  = edges(V(k,1));
  high = edges(V(k,2)+1);
  sig  = s;   
  cm   = Cm(k,:);

  return;
 