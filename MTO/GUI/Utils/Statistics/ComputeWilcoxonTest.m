function result = ComputeWilcoxonTest(raw, base, minimize, mode, alpha)
%COMPUTEWILCOXONTEST Original per-problem, unadjusted Wilcoxon comparisons.
% NaN means failure: orient objectives first, then set NaN to +Inf.
% Direction uses signed-rank/rank-sum effects, never the GUI display statistic.
% Equal signed infinities are tied; one-sided infinities keep their rank order.
if nargin<5,alpha=.05;end
[n,k,~]=size(raw);validateattributes(base,{'numeric'},{'scalar','integer','>=',1,'<=',k});
assert(ismember(mode,{'signed-rank','rank-sum'}),'MToP:StatisticsMode','Invalid Wilcoxon mode.');
result=struct('RawP',nan(n,k),'AdjustedP',nan(n,k),'Direction',zeros(n,k), ...
 'Symbols',{repmat({'NA'},n,k)},'Counts',zeros(k,4));
result.Symbols(:,base)={''};others=setdiff(1:k,base);
for row=1:n
 for algo=others
  x=reshape(raw(row,algo,:),[],1);y=reshape(raw(row,base,:),[],1);
  if ~minimize,x=-x;y=-y;end
  x(isnan(x))=Inf;y(isnan(y))=Inf;
  if strcmp(mode,'signed-rank')
   if numel(x)<2,continue;end
   d=x-y;d(x==y)=0; % Inf-Inf for equal failures is a tie, not missing
   nonzero=d(d~=0);
   if isempty(nonzero),p=1;direction=0;
   else,p=signrank(d);direction=sign(sum(sign(nonzero).*tiedrank(abs(nonzero))));end
  else
   if min(numel(x),numel(y))<2,continue;end
   pooled=[x;y];ranks=tiedrank(pooled);
   if all(pooled==pooled(1)),p=1;else,p=ranksum(x,y);end
   u=sum(ranks(1:numel(x)))-numel(x)*(numel(x)+1)/2;
   direction=sign(u-numel(x)*numel(y)/2);
  end
  result.RawP(row,algo)=p;result.Direction(row,algo)=direction;
 end
 result.AdjustedP(row,others)=result.RawP(row,others); % Compatibility field; no correction.
 for algo=others
  p=result.RawP(row,algo);symbol='=';
  if isnan(p),symbol='NA';
  elseif p<alpha && result.Direction(row,algo)<0,symbol='+';
  elseif p<alpha && result.Direction(row,algo)>0,symbol='-';end
  result.Symbols{row,algo}=symbol;
 end
end
for algo=others
 for j=1:4,names={'+','-','=','NA'};result.Counts(algo,j)=sum(strcmp(result.Symbols(:,algo),names{j}));end
end
end
