classdef (Abstract) AsyncCMAStream < StreamAlgorithm
% Shared event/batch lifecycle for asynchronous MTES-KG and MES-RET.
% Each task publishes one latest record, only after a complete local update.
properties
    sigma0 = 0.3
    SourceScope = 'latest' % latest includes completed tasks; active excludes them
    DecisionLog = struct([])
end
methods
    function reset(a)
        reset@StreamAlgorithm(a);
        a.DecisionLog = struct('Task',{},'Clock',{},'Generation',{}, ...
            'Sources',{},'SourceVersions',{},'SourceClocks',{},'CompletedSources',{}, ...
            'External',{},'Mode',{});
    end
end
methods (Access = protected)
    function onEvent(a,p,event,tasks)
        if strcmp(event,'start')
            validateattributes(p.N,{'numeric'},{'scalar','integer','>=',4});
            validateattributes(a.sigma0,{'numeric'},{'scalar','positive','finite'});
            assert(ismember(a.SourceScope,{'latest','active'}),'Invalid SourceScope');
            a.Shared.Ready = false(1,p.T);
            a.Shared.Knowledge = cell(1,p.T);
            a.Shared.RewardTurn = false;
            a.Shared.RRLast = 0;
            a.validateSettings();
        elseif strcmp(event,'arrival')
            for t=tasks
                n=p.D(t); mu=round(p.N/2);
                w=log(mu+.5)-log(1:mu); w=w/sum(w); me=1/sum(w.^2);
                cs=(me+2)/(n+me+5);
                s=struct('m',initESMean(p,t),'sigma',a.sigma0*initESSigmaScale(p,t), ...
                    'C',eye(n),'B',eye(n),'D',ones(n,1),'Inv',eye(n), ...
                    'ps',zeros(n,1),'pc',zeros(n,1),'gen',0,'eigenGen',0, ...
                    'mu',mu,'weights',w,'mueff',me,'cs',cs, ...
                    'damps',1+cs+2*max(sqrt((me-1)/(n+1))-1,0), ...
                    'cc',(4+me/n)/(4+n+2*me/n),'c1',2/((n+1.3)^2+me), ...
                    'cmu',0,'chi',sqrt(n)*(1-1/(4*n)+1/(21*n^2)), ...
                    'batch',[],'offset',0,'context',[],'tau',0, ...
                    'externalCounts',[],'successCounts',[],'initFitness',[], ...
                    'cvMax',0);
                s.cmu=min(1-s.c1,2*(me-2+1/me)/((n+2)^2+me));
                s=a.initializeExtra(s);
                a.State{t}=s; a.Mean{t}=s.m;
            end
        end
    end
    function step(a,p,active)
        % Resume an existing generation before awarding another service slot.
        pending=active(cellfun(@(s)~isempty(s.batch),a.State(active)));
        if isempty(pending), t=a.selectTask(p,active); else, t=pending(1); end
        s=a.State{t};
        if isempty(s.batch)
            [x,ctx]=a.makeSamples(p,t,s);
            total=size(x,1); count=min(total,p.TaskBudget(t)-a.TaskFE(t));
            pop(1,count)=Individual();
            for i=1:count, pop(i).Dec=x(i,:); end
            ctx.Full=(count==total); ctx.OldFitness=[a.Best{t}.CV,a.Best{t}.Obj];
            s.batch=pop; s.offset=0; s.context=ctx;
            clocks=zeros(1,numel(ctx.Sources)); versions=clocks;
            for j=1:numel(ctx.Sources)
                k=a.Shared.Knowledge{ctx.Sources(j)};
                clocks(j)=k.Clock; versions(j)=k.Version;
            end
            a.DecisionLog(end+1)=struct('Task',t,'Clock',a.Clock,'Generation',s.gen+1, ...
                'Sources',ctx.Sources,'SourceVersions',versions,'SourceClocks',clocks, ...
                'CompletedSources',ctx.Sources(a.Completed(ctx.Sources)), ...
                'External',sum(ctx.External(1:count)),'Mode',ctx.Mode);
        end
        evaluated=a.Evaluation(s.batch(s.offset+1:end),p,t);
        s.batch(s.offset+(1:numel(evaluated)))=evaluated;
        s.offset=s.offset+numel(evaluated);
        a.Population{t}=s.batch(1:s.offset);
        if s.offset==numel(s.batch)
            if s.context.Full
                order=a.rankPopulation(p,t,s);
                before=s;
                s=a.updateCMA(p,t,s,order);
                s=a.afterUpdate(p,t,s,before,order);
                a.Mean{t}=s.m;
            end
            s.batch=[]; s.offset=0; s.context=[];
        end
        a.State{t}=s;
    end
    function t=selectTask(~,~,active)
        t=active(1);
    end
    function ids=donors(a,p,t)
        ids=find(a.Shared.Ready);
        if strcmp(a.SourceScope,'active'), ids=ids(~a.Completed(ids)); end
        % No invented coordinate correspondence for heterogeneous tasks.
        ids=ids(p.D(ids)==p.D(t));
    end
    function x=selfSamples(~,s,count)
        x=s.m+s.sigma*(s.B*(s.D.*randn(numel(s.m),count)))';
    end
    function order=rankPopulation(a,p,t,s)
        pop=s.batch; cv=pop.CVs; obj=pop.Objs;
        if a.isKG()
            if p.Bounded
                penalty=arrayfun(@(q)BoundaryViolation(q.Dec,-.05,1.05),pop)';
                penalty(penalty>0)=penalty(penalty>0)+max(cv);
                cv=cv+penalty;
            end
        else
            progress=a.TaskFE(t)/p.TaskBudget(t);
            if progress<.3 && s.cvMax>0
                ep=s.cvMax*(1-progress/.3)^8; cv(cv<ep)=0;
            end
            if p.Bounded
                penalty=arrayfun(@(q)BoundaryViolation(q.Dec),pop)';
                if any(cv>0), cv=cv+penalty*max(1,max(cv));
                else, obj=obj+penalty*max(1,max(abs(obj))); end
            end
        end
        [~,order]=sortrows([cv,obj],[1,2]);
    end
    function s=updateCMA(~,~,~,s,order)
        n=numel(s.m); elite=s.batch(order(1:s.mu)).Decs;
        old=s.m; sigma=s.sigma; s.gen=s.gen+1;
        s.m=s.weights*elite;
        y=(s.m-old)'/sigma;
        s.ps=(1-s.cs)*s.ps+sqrt(s.cs*(2-s.cs)*s.mueff)*s.Inv*y;
        h=norm(s.ps)/sqrt(1-(1-s.cs)^(2*s.gen)) < (1.4+2/(n+1))*s.chi;
        s.pc=(1-s.cc)*s.pc+h*sqrt(s.cc*(2-s.cc)*s.mueff)*y;
        steps=(elite-old)'/sigma;
        s.C=(1-s.c1-s.cmu)*s.C+s.c1*(s.pc*s.pc'+(1-h)*s.cc*(2-s.cc)*s.C) ...
            +s.cmu*steps*diag(s.weights)*steps';
        s.sigma=sigma*exp(s.cs/s.damps*(norm(s.ps)/s.chi-1));
        % Local generations, not global FE or the original task ID.
        if s.gen-s.eigenGen > 1/(s.c1+s.cmu)/n/10
            s.eigenGen=s.gen;
            s.C=(s.C+s.C')/2;
            restart=any(~isfinite(s.C),'all') || ~isfinite(s.sigma) || s.sigma<=0;
            if ~restart
                [b,d]=eig(s.C,'vector');
                restart=any(~isfinite(d)) || any(d<=0);
            end
            if restart
                s.C=eye(n); s.B=eye(n); s.D=ones(n,1); s.Inv=eye(n);
                s.ps=zeros(n,1); s.pc=zeros(n,1);
                if ~isfinite(s.sigma), s.sigma=.3; end
                s.sigma=min(max(2*s.sigma,.01),.3);
            else
                s.B=real(b); s.D=sqrt(real(d));
                s.Inv=s.B*diag(1./s.D)*s.B';
            end
        end
        % A collapsed task must still consume its own budget, without a global restart.
        if all(s.sigma*max(abs(s.pc),sqrt(max(0,diag(s.C))))<1e-12)
            s.C=eye(n); s.B=eye(n); s.D=ones(n,1); s.Inv=eye(n);
            s.ps=zeros(n,1); s.pc=zeros(n,1); s.sigma=.3;
        end
    end
    function k=record(a,t,s,order)
        k=struct('m',s.m,'sigma',s.sigma,'B',s.B,'D',s.D, ...
            'elite',s.batch(order(1:s.mu)).Decs,'Version',s.gen, ...
            'Clock',a.Clock,'TaskFE',a.TaskFE(t));
    end
end
methods (Abstract, Access = protected)
    validateSettings(a)
    s=initializeExtra(a,s)
    tf=isKG(a)
    [x,ctx]=makeSamples(a,p,t,s)
    s=afterUpdate(a,p,t,s,before,order)
end
end
