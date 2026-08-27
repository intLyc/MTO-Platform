classdef ABOM < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Wang2026ABOM,
%   title     = {Task-free Adaptive Meta Black-box Optimization},
%   author    = {Chao Wang and Licheng Jiao and Lingling Li and Jiaxuan Zhao and Guanchun Wang and Fang Liu and Shuyuan Yang},
%   booktitle = {The Fourteenth International Conference on Learning Representations},
%   year      = {2026},
%   url       = {https://openreview.net/forum?id=AufVSUgMUo},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    learningRate = 1e-3
    weightDecay = 1e-5
    dropoutC = 0.95
    dropoutM = 0.95
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'learningRate: AdamW', num2str(Algo.learningRate), ...
                'weightDecay: AdamW', num2str(Algo.weightDecay), ...
                'dropoutC: crossover dropout', num2str(Algo.dropoutC), ...
                'dropoutM: mutation dropout', num2str(Algo.dropoutM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.learningRate = str2double(Parameter{i}); i = i + 1;
        Algo.weightDecay = str2double(Parameter{i}); i = i + 1;
        Algo.dropoutC = str2double(Parameter{i}); i = i + 1;
        Algo.dropoutM = str2double(Parameter{i});
    end

    function run(Algo, Prob)
        bridge = loadABOMBridge();

        N = Prob.N;
        if N < 2 || mod(N, 2) ~= 0
            error('ABOM:PopulationSize', ...
            'ABOM requires a positive even population size of at least two.');
        end
        if Algo.learningRate <= 0 || Algo.weightDecay < 0 || ...
                Algo.dropoutC < 0 || Algo.dropoutC >= 1 || ...
                Algo.dropoutM < 0 || Algo.dropoutM >= 1
            error('ABOM:InvalidParameter', ...
            'Learning rate, weight decay, and dropout parameters are invalid.');
        end

        % ABOM is population based: MToP initializes/evaluates each task and
        % remains authoritative for objective values and constraint handling.
        population = Initialization(Algo, Prob, Individual, N);
        runner = cell(1, Prob.T);
        for t = 1:Prob.T
            % The official ABOM starts from a fitness-sorted parent population.
            [~, order] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
            population{t} = population{t}(order);
            parentDec = population{t}.Decs;
            parentDec = parentDec(:, 1:Prob.D(t));

            seed = randi([0, double(intmax('int32'))]);
            parentPy = py.numpy.array(parentDec, dtype = py.numpy.float64);
            runner{t} = bridge.ABOMRunner( ...
                int32(N), int32(Prob.D(t)), parentPy, int64(seed), ...
                Algo.learningRate, Algo.weightDecay, ...
                Algo.dropoutC, Algo.dropoutM);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                currentRunner = runner{t};

                % Python owns only the differentiable evolutionary operators.
                offspringActive = double(currentRunner.ask());
                expectedSize = [N, Prob.D(t)];
                if ~isequal(size(offspringActive), expectedSize)
                    error('ABOM:PythonShape', ...
                        'Python returned a %s population; expected %s.', ...
                        mat2str(size(offspringActive)), mat2str(expectedSize));
                end
                if any(~isfinite(offspringActive(:)))
                    error('ABOM:InvalidOffspring', ...
                    'The Python ABOM update returned non-finite decisions.');
                end

                % Preserve inactive coordinates used by heterogeneous MToP
                % tasks; ABOM evolves only the first Prob.D(t) coordinates.
                offspring = repmat(Individual(), 1, N);
                for i = 1:N
                    dec = population{t}(i).Dec;
                    dec(1:Prob.D(t)) = offspringActive(i, :);
                    offspring(i).Dec = dec;
                end

                offspring = Algo.Evaluation(offspring, Prob, t);

                % This is the same population-level elitist selection pattern
                % used by GA/DE in MToP. It also preserves MToP's lexicographic
                % constraint handling for ABOM.
                population{t} = Selection_Elit(population{t}, offspring);
                selectedDec = population{t}.Decs;
                selectedDec = selectedDec(:, 1:Prob.D(t));
                selectedPy = py.numpy.array(selectedDec, dtype = py.numpy.float64);

                loss = double(currentRunner.tell(selectedPy));
                if ~isscalar(loss) || ~isfinite(loss)
                    error('ABOM:InvalidLoss', ...
                    'The Python ABOM update returned an invalid loss.');
                end
            end
        end
    end
end
end

function bridge = loadABOMBridge()
% Import the local Python bridge without changing the process-wide pyenv.
algorithmDir = fileparts(mfilename('fullpath'));
sysPath = py.sys.path;
if sysPath.count(algorithmDir) == 0
    sysPath.insert(int32(0), algorithmDir);
end
py.importlib.invalidate_caches();
try
    bridge = py.importlib.import_module('abom_bridge');
catch ME
    error('ABOM:PythonSetup', ...
        ['Unable to import the ABOM Python bridge. Configure MATLAB pyenv ' ...
        'with Python 3.10+ and install ABOM/requirements.txt.\nPython error: %s'], ...
        ME.message);
end
end
