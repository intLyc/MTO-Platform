classdef (Abstract) SequentialStreamAlgorithm < StreamAlgorithm
% Stream adapter for sequential transfer from sources completed on arrival.
% Numeric source records are published only by the completion event. Each
% target freezes its source IDs on arrival, including when initialization is
% interrupted. All objective calls go through StreamAlgorithm.Evaluation.

properties
    TransferLog = struct([])
end

methods
    function reset(Algo)
        reset@StreamAlgorithm(Algo);
        Algo.TransferLog = struct('Time',{},'Task',{},'Generation',{}, ...
            'Sources',{},'Origin',{},'Weights',{});
    end
end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks)
        switch event
            case 'start'
                validateattributes(Prob.N, {'numeric'}, {'scalar','integer','>=',2});
                Algo.Shared.Memory = cell(1, Prob.T);
                Algo.configure(Prob);
            case 'arrival'
                sources = find(~cellfun(@isempty, Algo.Shared.Memory));
                for t = tasks
                    s = struct('Sources',sources,'ArrivalClock',Algo.Clock, ...
                        'Generation',0,'Batch',Individual.empty(1,0), ...
                        'Offset',0,'Context',struct(), ...
                        'History',struct('Dec',{},'Obj',{}));
                    Algo.State{t} = Algo.initializeState(Prob,t,s);
                end
            case 'complete'
                for t = tasks
                    s = Algo.State{t};
                    p = Algo.Population{t};
                    memory = struct('Dimension',Prob.D(t),'History',s.History, ...
                        'Final',p.Decs,'Fitness',p.Objs, ...
                        'Best',Algo.Best{t}.Dec,'CompletionClock',Algo.Clock);
                    Algo.Shared.Memory{t} = memory;
                end
        end
    end

    function step(Algo, Prob, active)
        t = active(1);
        s = Algo.State{t};
        if isempty(s.Batch)
            n = min(Prob.N, Prob.TaskBudget(t)-Algo.TaskFE(t));
            if s.Generation == 0
                X = Algo.initialDecisions(Prob,t);
                context = struct('Sources',[],'Origin',zeros(1,n),'Weights',[]);
            else
                [X,s,context] = Algo.generateDecisions(Prob,t,s);
            end
            X = X(1:n,:);
            assert(size(X,2)==max(Prob.D) && all(isfinite(X(:))), ...
                'SequentialStreamAlgorithm:InvalidCandidates','Invalid candidate dimensions or values.');
            X = min(1,max(0,X));
            s.Batch = repmat(Individual(),1,n);
            for j = 1:n, s.Batch(j).Dec = X(j,:); end
            s.Offset = 0;
            s.Context = context;
            s.Context.Improved = false;
            if ~isempty(context.Sources)
                Algo.TransferLog(end+1) = struct('Time',Algo.Clock,'Task',t, ...
                    'Generation',s.Generation,'Sources',context.Sources, ...
                    'Origin',context.Origin(1:n),'Weights',context.Weights);
            end
        end
        [s,complete] = StreamEvaluateBatch(Algo,Prob,t,s);
        if complete
            evaluated = s.Batch(1:s.Offset);
            if s.Generation == 0
                % Preserve initialization row order for common-skeleton ranks.
                Algo.Population{t} = evaluated;
            else
                Algo.Population{t} = Algo.selectPopulation(Algo.Population{t},evaluated);
            end
            p = Algo.Population{t};
            s.History(end+1) = struct('Dec',p.Decs,'Obj',p.Objs);
            s.Generation = s.Generation+1;
            s.Batch = Individual.empty(1,0);
            s.Offset = 0;
        end
        Algo.State{t} = s;
    end

    function configure(~,~)
    end

    function s = initializeState(~,~,~,s)
    end

    function X = initialDecisions(~,Prob,~)
        X = rand(Prob.N,max(Prob.D));
    end

    function p = selectPopulation(~,parent,child)
        p = [parent,child];
        [~,order] = sortrows([p.CVs,p.Objs],[1,2]);
        p = p(order(1:numel(parent)));
    end
end

methods (Abstract, Access = protected)
    [X,s,context] = generateDecisions(Algo,Prob,t,s)
end
end
