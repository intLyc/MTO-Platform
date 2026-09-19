classdef AMES_RET < AsyncCMAStream
% <Multi-task/Many-task> <Single-objective> <None/Constrained> <Stream>
% Asynchronous adaptation of MES-RET (Li et al., ICML 2026).
% Event-published rewards; alternating round-robin/reward service, fixed task caps.
properties
    tau = 1
    Warmup = 10
    RewardScheduling = true
end
methods
    function params=getParameter(a)
        params={'sigma0',num2str(a.sigma0),'tau',num2str(a.tau), ...
            'Warmup (local generations)',num2str(a.Warmup), ...
            'Reward scheduling (1/0)',num2str(a.RewardScheduling), ...
            'Source scope (latest/active)',a.SourceScope};
    end
    function setParameter(a,p)
        a.sigma0=str2double(p{1}); a.tau=str2double(p{2});
        a.Warmup=str2double(p{3}); a.RewardScheduling=logical(str2double(p{4}));
        a.SourceScope=char(p{5});
    end
end
methods (Access = protected)
    function validateSettings(a)
        validateattributes(a.tau,{'numeric'},{'scalar','nonnegative','finite'});
        validateattributes(a.Warmup,{'numeric'},{'scalar','nonnegative','integer','finite'});
    end
    function s=initializeExtra(~,s) %#ok<INUSD>
    end
    function tf=isKG(~), tf=false; end
    function t=selectTask(a,p,active)
        if a.RewardScheduling && a.Shared.RewardTurn
            progress=mean(a.TaskFE(active)./p.TaskBudget(active));
            mode=double(rand>=1-progress);
            w=a.rewardWeights(active,mode);
            t=active(find(rand<=cumsum(w),1));
        else
            ids=sort(active); ids=[ids(ids>a.Shared.RRLast),ids(ids<=a.Shared.RRLast)];
            t=ids(1); a.Shared.RRLast=t;
        end
        a.Shared.RewardTurn=~a.Shared.RewardTurn;
    end
    function [x,ctx]=makeSamples(a,p,t,s)
        x=a.selfSamples(s,p.N);
        ctx=struct('Sources',[],'External',false(1,p.N),'Mode',0);
        ids=a.donors(p,t);
        if a.tau==0 || s.gen<a.Warmup || ~any(ids~=t), return; end
        if a.tau>=1, count=round(a.tau); else, count=double(rand<a.tau); end
        count=min(count,floor(p.N/2)); if count==0, return; end
        mode=double(rand>=1-a.TaskFE(t)/p.TaskBudget(t));
        weights=a.rewardWeights(ids,mode);
        m=zeros(size(s.m)); ratios=m; sigmaRatio=0;
        for j=1:numel(ids)
            k=a.Shared.Knowledge{ids(j)};
            m=m+weights(j)*k.m;
            ratios=ratios+weights(j)*k.StdRatio;
            sigmaRatio=sigmaRatio+weights(j)*k.SigmaRatio;
        end
        step=mean(vecnorm(x-s.m,2,2));
        for i=1:count
            noise=a.selfSamples(s,1)-s.m; u=m-s.m+noise;
            if norm(u)>1e-12, x(i,:)=s.m+u/norm(u)*step;
            else, x(i,:)=s.m; end
        end
        v=sigmaRatio*ratios;
        for i=count+1:2*count
            x(i,:)=s.m+v.*s.sigma.*sqrt(max(0,diag(s.C)))'.*randn(size(s.m));
        end
        ctx.Sources=ids; ctx.External(1:2*count)=true; ctx.Mode=mode;
    end
    function w=rewardWeights(a,ids,mode)
        raw=zeros(1,numel(ids));
        for j=1:numel(ids)
            if a.Shared.Ready(ids(j))
                k=a.Shared.Knowledge{ids(j)};
                if mode==0, raw(j)=k.FitReward; else, raw(j)=k.DivReward; end
            end
        end
        raw(~isfinite(raw))=0;
        range=max(raw)-min(raw);
        if range<1e-9, normalized=zeros(size(raw));
        else, normalized=(raw-min(raw))/range; end
        if mode==0, w=exp(normalized); else, w=normalized; end
        if sum(w)<=1e-12, w=ones(size(w)); end
        w=w/sum(w); w(end)=1-sum(w(1:end-1));
    end
    function s=afterUpdate(a,~,t,s,before,order)
        current=[a.Best{t}.CV,a.Best{t}.Obj];
        old=before.context.OldFitness;
        if isempty(s.initFitness)
            s.initFitness=current;
            cv=sort(s.batch.CVs); s.cvMax=cv(max(1,round(.2*numel(cv))));
            fit=0;
        else
            if current(1)<=0, j=2; else, j=1; end
            fit=max(0,old(j)-current(j))/(abs(s.initFitness(j)-old(j))+1e-12);
        end
        k=a.record(t,s,order);
        k.SigmaRatio=s.sigma/max(before.sigma,realmin);
        k.StdRatio=sqrt(max(0,diag(s.C)))'./max(sqrt(max(0,diag(before.C)))',realmin);
        k.FitReward=fit;
        k.DivReward=(before.sigma*trace(before.C)+s.sigma*trace(s.C))/numel(s.m);
        if ~isfinite(k.SigmaRatio) || any(~isfinite(k.StdRatio))
            k.SigmaRatio=1; k.StdRatio=ones(size(s.m));
        end
        a.Shared.Knowledge{t}=k; a.Shared.Ready(t)=true;
    end
end
end
