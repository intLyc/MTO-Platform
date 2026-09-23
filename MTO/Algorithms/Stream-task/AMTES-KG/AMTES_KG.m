classdef AMTES_KG < AsyncCMAStream
% <Multi-task/Many-task> <Single-objective> <None/Constrained> <Stream> <Year: 2024>
% Asynchronous adaptation of MTES-KG (Li et al., TEVC 2024).
% Latest completed local updates replace synchronous source generations.
properties
    tau0 = 2
    alpha = .5
    adjGap = 50
end
methods
    function params=getParameter(a)
        params={'tau0',num2str(a.tau0),'alpha',num2str(a.alpha), ...
            'adjGap',num2str(a.adjGap),'sigma0',num2str(a.sigma0), ...
            'Source scope (latest/active)',a.SourceScope};
    end
    function setParameter(a,p)
        a.tau0=str2double(p{1}); a.alpha=str2double(p{2});
        a.adjGap=str2double(p{3}); a.sigma0=str2double(p{4});
        a.SourceScope=char(p{5});
    end
end
methods (Access = protected)
    function validateSettings(a)
        validateattributes(a.tau0,{'numeric'},{'scalar','integer','nonnegative','finite'});
        validateattributes(a.alpha,{'numeric'},{'scalar','>=',0,'<=',1});
        validateattributes(a.adjGap,{'numeric'},{'scalar','integer','positive','finite'});
    end
    function s=initializeExtra(a,s), s.tau=a.tau0; end
    function tf=isKG(~), tf=true; end
    function [x,ctx]=makeSamples(a,p,t,s)
        x=a.selfSamples(s,p.N);
        ids=a.donors(p,t); ids(ids==t)=[];
        ctx=struct('Sources',[],'External',false(1,p.N),'Mode',0);
        if isempty(ids) || s.gen<1 || s.tau==0, return; end
        source=ids(randi(numel(ids))); k=a.Shared.Knowledge{source};
        step=mean(vecnorm(x-s.m,2,2));
        for i=1:s.tau
            if rand<a.alpha
                candidate=a.selfSamples(k,1); v=candidate-s.m;
                if norm(v)>step, candidate=s.m+v/norm(v)*step; end
            else
                idx=1:size(k.elite,1); idx(randi(numel(idx)))=[];
                v=(mean(k.elite(idx,:),1)-k.m)/k.sigma;
                % Preserve the matrix order in the original MTES-KG SaS.
                candidate=s.m+s.sigma*(s.B*(s.D.*(k.B'*(v'./k.D))))';
            end
            x(end+1,:)=candidate;
        end
        ctx.Sources=source; ctx.External=[false(1,p.N),true(1,s.tau)];
    end
    function s=afterUpdate(a,~,t,s,before,order)
        num=sum(before.context.External); success=sum(before.context.External(order(1:s.mu)));
        % Only actual transfer generations contribute; no-source is not failure.
        s.externalCounts(end+1)=num; s.successCounts(end+1)=success;
        if mod(s.gen,a.adjGap)==0
            ix=max(1,numel(s.externalCounts)-a.adjGap+1):numel(s.externalCounts);
            total=sum(s.externalCounts(ix)); good=sum(s.successCounts(ix));
            if total>0
                if good/total>.5, s.tau=min(a.tau0,s.tau+1);
                else, s.tau=max(0,s.tau-1); end
            elseif s.tau==0
                s.tau=min(a.tau0,1); % Original zero-transfer recovery rule.
            end
        end
        a.Shared.Knowledge{t}=a.record(t,s,order); a.Shared.Ready(t)=true;
    end
end
end
