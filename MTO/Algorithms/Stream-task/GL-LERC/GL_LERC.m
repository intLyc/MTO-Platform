classdef GL_LERC < SequentialStreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None> <Stream> <Year: 2025>

%------------------------------- Reference --------------------------------
% @Article{Cao2025Global,
%   title      = {Global and Local Search Experience-Based Evolutionary Sequential Transfer Optimization},
%   author     = {Cao, Chenming and Zhang, Kai and Xue, Xiaoming and Tan, Kay Chen and Wang, Jian and Zhang, Liming and Liu, Piyang and Yan, Xia},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2025},
%   volume     = {29},
%   number     = {4},
%   pages      = {1269--1283},
%   doi        = {10.1109/TEVC.2024.3417325},
% }
%--------------------------------------------------------------------------

% Global/local LERC solution transfer from completed source searches.
% Mechanisms adapted from https://github.com/ccm831143/GL-LERC

properties
    TransferInterval = 1
    SkeletonSize = 20
    LookAhead = 3
    MuC = 15
    MuM = 15
end

methods
    function p = getParameter(Algo)
        p = {'Transfer interval (generations)',num2str(Algo.TransferInterval), ...
            'Local skeleton size',num2str(Algo.SkeletonSize), ...
            'Source look-ahead (generations)',num2str(Algo.LookAhead), ...
            'SBX distribution index',num2str(Algo.MuC), ...
            'Mutation distribution index',num2str(Algo.MuM)};
    end

    function setParameter(Algo,p)
        Algo.TransferInterval=str2double(p{1});
        Algo.SkeletonSize=str2double(p{2});
        Algo.LookAhead=str2double(p{3});
        Algo.MuC=str2double(p{4}); Algo.MuM=str2double(p{5});
    end
end

methods (Access = protected)
    function configure(Algo,Prob)
        validateattributes(Algo.TransferInterval,{'numeric'},{'scalar','integer','positive'});
        validateattributes(Algo.SkeletonSize,{'numeric'},{'scalar','integer','>=',2});
        validateattributes(Algo.LookAhead,{'numeric'},{'scalar','integer','nonnegative'});
        validateattributes(Algo.MuC,{'numeric'},{'scalar','finite','nonnegative'});
        validateattributes(Algo.MuM,{'numeric'},{'scalar','finite','nonnegative'});
        % One shared Latin-hypercube skeleton per run, never regenerated for
        % a later target. Common rows make initial landscape ranks comparable.
        X=zeros(Prob.N,max(Prob.D));
        for j=1:size(X,2), X(:,j)=(randperm(Prob.N)'-rand(Prob.N,1))/Prob.N; end
        Algo.Shared.Skeleton=X;
    end

    function s = initializeState(~,~,~,s)
        s.GlobalOrder=[];
    end

    function X = initialDecisions(Algo,~,~)
        X=Algo.Shared.Skeleton;
    end

    function [X,s,context] = generateDecisions(Algo,Prob,t,s)
        parent=Algo.Population{t};
        X=Algo.variation(parent.Decs,Prob.D(t),Algo.MuC,Algo.MuM);
        sources=s.Sources;
        % A truncated initialization has no full common-skeleton encoding.
        keep=false(size(sources));
        for j=1:numel(sources)
            keep(j)=size(Algo.Shared.Memory{sources(j)}.History(1).Dec,1)==Prob.N;
        end
        sources=sources(keep);
        context=struct('Sources',[],'Origin',zeros(1,Prob.N),'Weights',[]);
        if isempty(sources) || mod(s.Generation,Algo.TransferInterval)~=0, return; end
        if isempty(s.GlobalOrder)
            steps=max(1,ceil(Prob.TaskBudget(t)/Prob.N)-1);
            s.GlobalOrder=Algo.globalWalk(s.History(1).Obj, ...
                Algo.Shared.Memory,sources,steps,Prob.D(t));
        end
        slot=randperm(Prob.N,min(2,Prob.N));
        source=s.GlobalOrder(min(s.Generation,numel(s.GlobalOrder)));
        memory=Algo.Shared.Memory{source};
        d=min(Prob.D(t),memory.Dimension);
        X(slot(1),1:d)=memory.Final(randi(size(memory.Final,1)),1:d);
        context.Origin(slot(1))=source;
        [point,source,d]=Algo.localCandidate(Prob,t,s,sources);
        X(slot(2),1:d)=point;
        context.Origin(slot(2))=source;
        context.Sources=sources;
    end

    function [point,source,d] = localCandidate(Algo,Prob,t,s,sources)
        if s.Generation==1
            source=sources(randi(numel(sources)));
            d=min(Prob.D(t),Algo.Shared.Memory{source}.Dimension);
            point=rand(1,d);
            return;
        end
        target=[s.History(end-1).Dec;s.History(end).Dec];
        targetFitness=[s.History(end-1).Obj;s.History(end).Obj];
        scores=-inf(1,numel(sources)); points=cell(size(sources));
        for j=1:numel(sources)
            m=Algo.Shared.Memory{sources(j)};
            d=min(Prob.D(t),m.Dimension);
            a=min(s.Generation-1,numel(m.History));
            b=min(s.Generation,numel(m.History));
            S=[m.History(a).Dec(:,1:d);m.History(b).Dec(:,1:d)];
            f=[m.History(a).Obj;m.History(b).Obj];
            T=target(:,1:d);
            [Cs,ls]=Algo.principalAxes(S); [Ct,lt]=Algo.principalAxes(T);
            scale=sqrt(max(lt(1),0)/max(ls(1),eps));
            A=scale*(Cs'*Ct); % Reference local_transfer.m PCA convention.
            ms=mean(S,1); mt=mean(T,1);
            transformed=(S-ms)*A+mt;
            [~,mappedLatent]=Algo.principalAxes(transformed);
            uncertainty=1-sum(abs(mappedLatent-lt))/max(sum(lt),eps);
            selected=randperm(size(S,1));
            selected=selected(1:min(Algo.SkeletonSize,numel(selected)));
            estimate=zeros(numel(selected),1);
            for k=1:numel(selected)
                [~,nearest]=min(sum(abs(T-transformed(selected(k),:)),2));
                estimate(k)=targetFitness(nearest);
            end
            scores(j)=uncertainty*Algo.rankCorrelation(f(selected),estimate);
            future=min(s.Generation+Algo.LookAhead,numel(m.History));
            [~,best]=min(m.History(future).Obj);
            points{j}=(m.History(future).Dec(best,1:d)-ms)*A+mt;
        end
        [~,chosen]=max(scores);
        source=sources(chosen); point=points{chosen};
        d=numel(point); point=min(1,max(0,point));
    end
end

methods (Static)
    function order = globalWalk(targetFitness,memory,sources,steps,targetDim)
        scores=zeros(size(sources));
        for j=1:numel(sources)
            scores(j)=GL_LERC.rankCorrelation(targetFitness,memory{sources(j)}.History(1).Obj);
        end
        [~,first]=max(scores);
        order=zeros(1,steps); order(1)=sources(first);
        visited=false(size(sources)); visited(first)=true;
        for k=2:steps
            if all(visited), visited(:)=false; end
            distances=inf(size(sources)); previous=memory{order(k-1)};
            for j=find(~visited)
                next=memory{sources(j)};
                d=min([targetDim,previous.Dimension,next.Dimension]);
                x=previous.Final(randi(size(previous.Final,1)),1:d);
                y=next.Final(randi(size(next.Final,1)),1:d);
                distances(j)=sum(abs(x-y));
            end
            [~,chosen]=min(distances);
            order(k)=sources(chosen); visited(chosen)=true;
        end
    end

    function rho = rankCorrelation(x,y)
        % The reference applies minimum ranks followed by average tie ranks
        % and the Spearman squared-rank-difference expression.
        x=GL_LERC.tieRanks(x); y=GL_LERC.tieRanks(y);
        n=numel(x);
        if n<2, rho=0; else, rho=1-6*sum((x-y).^2)/(n*(n*n-1)); end
    end

    function ranks = tieRanks(x)
        x=x(:); [sorted,order]=sort(x); ranks=zeros(size(x));
        i=1;
        while i<=numel(x)
            j=i;
            while j<numel(x) && sorted(j+1)==sorted(i), j=j+1; end
            ranks(order(i:j))=(i+j)/2; i=j+1;
        end
    end

    function [C,latent] = principalAxes(X)
        X=X-mean(X,1); S=(X'*X)/max(1,size(X,1)-1);
        [C,latent]=eig((S+S')/2,'vector');
        [latent,order]=sort(max(real(latent),0),'descend'); C=real(C(:,order));
        % Match PCA's convention: largest loading in each column is positive.
        for j=1:size(C,2)
            [~,i]=max(abs(C(:,j)));
            if C(i,j)<0, C(:,j)=-C(:,j); end
        end
    end

    function X = variation(P,d,muc,mum)
        n=size(P,1); X=P; order=randperm(n); pairs=ceil(n/2);
        if mod(n,2), order(end+1)=order(1); end
        for i=1:pairs
            p=order(i); q=order(i+pairs);
            u=rand(1,d); cf=(2*u).^(1/(muc+1));
            high=u>.5; cf(high)=(2*(1-u(high))).^(-1/(muc+1));
            a=min(1,max(0,.5*((1+cf).*P(p,1:d)+(1-cf).*P(q,1:d))));
            b=min(1,max(0,.5*((1-cf).*P(p,1:d)+(1+cf).*P(q,1:d))));
            children=[a;b];
            for k=1:2
                mask=rand(1,d)<1/d; u=rand(1,d);
                delta=(2*u).^(1/(mum+1))-1;
                high=u>.5; delta(high)=1-(2*(1-u(high))).^(1/(mum+1));
                step=delta.*children(k,:);
                step(high)=delta(high).*(1-children(k,high));
                children(k,mask)=children(k,mask)+step(mask);
            end
            swap=rand(1,d)>=.5;
            temp=children(1,swap); children(1,swap)=children(2,swap); children(2,swap)=temp;
            X(i,1:d)=children(1,:);
            if i+pairs<=n, X(i+pairs,1:d)=children(2,:); end
        end
    end
end
end
