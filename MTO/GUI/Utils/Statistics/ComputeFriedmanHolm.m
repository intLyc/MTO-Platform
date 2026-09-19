function result = ComputeFriedmanHolm(raw, base, minimize, mode, alpha)
%COMPUTEFRIEDMANHOLM Independent problem blocks x algorithms x repetitions.
% mode: 'mean' or 'all reps'. NaN means no feasible solution: rank WORST.
% mean: mean(raw,3,'omitnan') compares successful-run means; all-failed
% algorithm/problem cells rank worst. all reps: every failed run ranks worst.
% All-failed blocks are retained as ties. Neither mode drops problem blocks.
% 'all reps' preserves the original GUI definition: each problem/run row
% ranks its k algorithms separately. MeanRanks therefore lies in [1,k].
% Inference treats these rows as independent blocks; related repetitions or
% tasks require care. Use mean mode for across-problem aggregate comparisons.
if nargin<5,alpha=.05;end
validateattributes(raw,{'numeric'},{'real','nonempty'});
assert(ndims(raw)<=3,'MToP:StatisticsShape','Expected problems x algorithms x repetitions.');
k=size(raw,2);n=size(raw,1);r=size(raw,3);
validateattributes(base,{'numeric'},{'scalar','integer','>=',1,'<=',k});
validateattributes(alpha,{'numeric'},{'scalar','>',0,'<',1});
assert(ismember(mode,{'mean','all reps'}),'MToP:StatisticsMode','Invalid Friedman mode.');
result=struct('Valid',false,'Reason','','OverallP',NaN,'MeanRanks',nan(1,k), ...
 'RawP',nan(1,k),'AdjustedP',nan(1,k),'Significant',false(1,k), ...
 'KeptBlocks',[],'FailedObservations',sum(isnan(raw(:))),'AllFailedBlocks',[], ...
 'N',0,'ProblemCount',n,'K',k,'Reps',r,'InputBlocks',n,'Mode',mode,'SE',NaN);
x=double(raw);if ~minimize,x=-x;end
result.SuccessCounts=sum(~isnan(raw),3);
result.AllFailedBlocks=find(reshape(all(all(isnan(x)|x==Inf,3),2),[],1));
keep=true(n,1);
if strcmp(mode,'mean')
 allFailed=all(isnan(x),3);
 x=mean(x,3,'omitnan');reps=1;
 x(allFailed)=Inf;
 if any(isnan(x),'all')
  result.Reason='A mean mixes positive and negative infinity; fix the source metric.';return;
 end
 data=x(keep,:);
else
 reps=1;
 x(isnan(x))=Inf;
 data=reshape(permute(x(keep,:,:),[3 1 2]),[],k);
end
result.KeptBlocks=find(keep);result.N=size(data,1);
if k<2,result.Reason='At least two algorithms are required.';return;end
if result.N<2,result.Reason='At least two comparison rows are required.';return;end
[p,~,stats]=friedman(data,reps,'off');
result.OverallP=p;result.MeanRanks=stats.meanranks;
result.SE=sqrt(2*stats.sigma^2/stats.n); % MATLAB multcompare's tied-rank variance
others=setdiff(1:k,base);
if result.SE==0
 values=ones(size(others));
else
 z=abs(stats.meanranks(others)-stats.meanranks(base))/result.SE;
 values=2*normcdf(-z);
end
result.RawP(others)=values;result.AdjustedP(others)=HolmAdjust(values);
result.Significant(others)=p<alpha & result.AdjustedP(others)<alpha;
result.Valid=isfinite(p)&&all(isfinite(values));
if ~result.Valid,result.Reason='The rank test produced an undefined statistic.';end
end
