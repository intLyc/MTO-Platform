classdef AMTEA_MS < SequentialStreamAlgorithm
% <Multi-task/Many-task> <Single-objective> <None> <Stream> <Year: 2021>

%------------------------------- Reference --------------------------------
% @Article{Lim2021Nonlinear,
%   title      = {Non-linear Domain Adaptation in Transfer Evolutionary Optimization},
%   author     = {Lim, Ray and Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang and Zhang, Allan N.},
%   journal    = {Cognitive Computation},
%   year       = {2021},
%   volume     = {13},
%   number     = {2},
%   pages      = {290--307},
%   doi        = {10.1007/s12559-020-09777-7},
% }
%--------------------------------------------------------------------------

% AMTEA with online nonlinear source-to-target maps (AMTEA + M_s^NN).
% Paper-based reproduction of Algorithms 1 and Eqs. (13)-(17).
% Source histories and final distributions become available on completion.

properties
    TransferInterval = 2
    MutationProbability = 0.04
    MutationSigma = 0.1
    HiddenFactor = 2
    RidgeMin = 1
    RidgeMax = 1000
    EMIterations = 100
    WeightNoise = 0.01
end

methods
    function p = getParameter(Algo)
        p={'Transfer interval (generations)',num2str(Algo.TransferInterval), ...
            'Gaussian mutation probability',num2str(Algo.MutationProbability), ...
            'Gaussian mutation SD (normalized)',num2str(Algo.MutationSigma), ...
            'Hidden width / target dimension',num2str(Algo.HiddenFactor), ...
            'Minimum mapping ridge',num2str(Algo.RidgeMin), ...
            'Maximum mapping ridge',num2str(Algo.RidgeMax), ...
            'Stacking EM iterations',num2str(Algo.EMIterations), ...
            'Mixture weight mutation SD',num2str(Algo.WeightNoise)};
    end

    function setParameter(Algo,p)
        names={'TransferInterval','MutationProbability','MutationSigma', ...
            'HiddenFactor','RidgeMin','RidgeMax','EMIterations','WeightNoise'};
        for k=1:numel(names), Algo.(names{k})=str2double(p{k}); end
    end
end

methods (Access = protected)
    function configure(Algo,~)
        validateattributes(Algo.TransferInterval,{'numeric'},{'scalar','integer','positive'});
        validateattributes(Algo.MutationProbability,{'numeric'},{'scalar','finite','>=',0,'<=',1});
        validateattributes(Algo.MutationSigma,{'numeric'},{'scalar','finite','nonnegative'});
        validateattributes(Algo.HiddenFactor,{'numeric'},{'scalar','finite','positive'});
        validateattributes(Algo.RidgeMin,{'numeric'},{'scalar','finite','positive'});
        validateattributes(Algo.RidgeMax,{'numeric'},{'scalar','finite','>=',Algo.RidgeMin});
        validateattributes(Algo.EMIterations,{'numeric'},{'scalar','integer','positive'});
        validateattributes(Algo.WeightNoise,{'numeric'},{'scalar','finite','nonnegative'});
    end

    function s = initializeState(~,Prob,~,s)
        s.Maps=cell(1,Prob.T);
    end

    function [X,s,context] = generateDecisions(Algo,Prob,t,s)
        parent=Algo.Population{t}; P=parent.Decs; dt=Prob.D(t); n=size(P,1);
        context=struct('Sources',[],'Origin',zeros(1,n),'Weights',[]);
        sources=s.Sources;
        keep=false(size(sources));
        for j=1:numel(sources)
            keep(j)=size(Algo.Shared.Memory{sources(j)}.Final,1)>=2;
        end
        sources=sources(keep);
        if isempty(sources) || mod(s.Generation,Algo.TransferInterval)~=0
            % Canonical real-coded EA: uniform crossover and Gaussian mutation.
            order=randperm(n); X=P;
            for k=1:n
                partner=order(mod(k,n)+1);
                swap=rand(1,dt)<.5;
                columns=find(swap);
                X(k,columns)=P(partner,columns);
            end
            mutation=rand(n,dt)<Algo.MutationProbability;
            X(:,1:dt)=X(:,1:dt)+mutation.*(Algo.MutationSigma*randn(n,dt));
            return;
        end
        models=cell(1,numel(sources)+1); logDensity=zeros(n,numel(models));
        [~,targetOrder]=sort(parent.Objs);
        target=P(targetOrder,1:dt);
        for j=1:numel(sources)
            source=sources(j); memory=Algo.Shared.Memory{source};
            generation=min(s.Generation,numel(memory.History));
            training=memory.History(generation);
            [~,rank]=sort(training.Obj);
            sourceX=training.Dec(rank,1:memory.Dimension);
            % Preserve percentile pairing if a short source has fewer rows.
            m=min(size(sourceX,1),n);
            si=round(linspace(1,size(sourceX,1),m)); ti=round(linspace(1,n,m));
            if isempty(s.Maps{source})
                h=max(1,round(Algo.HiddenFactor*dt));
                s.Maps{source}=struct('W',randn(h,memory.Dimension), ...
                    'Bias',randn(1,h),'Ridge',Algo.RidgeMin+ ...
                    (Algo.RidgeMax-Algo.RidgeMin)*rand,'Output',[]);
            end
            map=Algo.fitMap(sourceX(si,:),target(ti,:),s.Maps{source});
            s.Maps{source}=map;
            % Transform samples from the final source distribution, not the
            % intermediate population used to fit the generation-matched map.
            sourceModel=Algo.fitGaussian(memory.Final(:,1:memory.Dimension));
            draws=Algo.sampleGaussian(sourceModel,n);
            mapped=Algo.applyMap(draws,map);
            models{j}=Algo.fitGaussian(mapped);
            noisy=Algo.fitGaussian([mapped;rand(max(1,round(.1*n)),dt)]);
            logDensity(:,j)=Algo.logGaussian(P(:,1:dt),noisy);
        end
        models{end}=Algo.fitGaussian(P(:,1:dt));
        % Leave-one-out target likelihood prevents fitting a density to the
        % same target row on which that density is scored (stacked estimation).
        noise=rand(max(1,round(.1*n)),dt);
        for k=1:n
            train=P([1:k-1,k+1:n],1:dt);
            loo=Algo.fitGaussian([train;noise]);
            logDensity(k,end)=Algo.logGaussian(P(k,1:dt),loo);
        end
        weights=Algo.stacking(logDensity,Algo.EMIterations);
        weights=max(0,weights+Algo.WeightNoise*randn(size(weights)));
        if sum(weights)==0, weights(end)=1; end
        weights=weights/sum(weights);
        % AMTEA's component quotas, followed by random permutation/truncation.
        decisions=[]; origin=[];
        ids=[sources,0];
        for j=1:numel(models)
            count=ceil(n*weights(j));
            if count==0, continue; end
            decisions=[decisions;Algo.sampleGaussian(models{j},count)]; %#ok<AGROW>
            origin=[origin,repmat(ids(j),1,count)]; %#ok<AGROW>
        end
        selected=randperm(size(decisions,1),n);
        X=P; X(:,1:dt)=decisions(selected,:);
        context=struct('Sources',sources,'Origin',origin(selected),'Weights',weights);
    end

    function p = selectPopulation(~,parent,child)
        % Pairwise tournaments retain the better parent/offspring candidate.
        n=numel(child); p=parent;
        [p(1:n),~]=Selection_Tournament(parent(1:n),child);
    end
end

methods (Static)
    function map = fitMap(source,target,map)
        H=AMTEA_MS.hidden(source,map);
        % Row-oriented form of Eq. (17), with the random first layer fixed.
        map.Output=(H'*H+map.Ridge*eye(size(H,2)))\(H'*target);
    end

    function H = hidden(X,map)
        z=X*map.W'+map.Bias;
        H=1./(1+exp(-min(700,max(-700,z))));
    end

    function X = applyMap(X,map)
        X=AMTEA_MS.hidden(X,map)*map.Output;
    end

    function model = fitGaussian(X)
        model.Mean=mean(X,1); centered=X-model.Mean;
        S=(centered'*centered)/max(1,size(X,1)-1);
        ridge=max(1e-10,1e-6*trace(S)/size(X,2));
        model.Factor=chol((S+S')/2+ridge*eye(size(X,2)));
    end

    function X = sampleGaussian(model,n)
        X=randn(n,numel(model.Mean))*model.Factor+model.Mean;
    end

    function value = logGaussian(X,model)
        z=(X-model.Mean)/model.Factor;
        value=-.5*(size(X,2)*log(2*pi)+sum(z.^2,2))-sum(log(diag(model.Factor)));
    end

    function weights = stacking(logDensity,iterations)
        % Row scaling cancels in EM responsibilities and avoids underflow.
        density=exp(logDensity-max(logDensity,[],2));
        weights=ones(1,size(density,2))/size(density,2);
        for k=1:iterations
            responsibility=density.*weights;
            responsibility=responsibility./max(sum(responsibility,2),realmin);
            updated=mean(responsibility,1);
            updated=updated/sum(updated);
            if max(abs(updated-weights))<1e-10, weights=updated; break; end
            weights=updated;
        end
    end
end
end
