classdef LES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Lange2023LES,
%   title     = {Discovering Evolution Strategies via Meta-Black-Box Optimization},
%   author    = {Robert Tjarko Lange and Tom Schaul and Yutian Chen and Tom Zahavy and Valentin Dalibard and Chris Lu and Satinder Singh and Sebastian Flennerhag},
%   booktitle = {The Eleventh International Conference on Learning Representations},
%   year      = {2023},
%   url       = {https://openreview.net/forum?id=mFDU0fP3EQH},
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
    sigma0 = 0.3
    useN = 1 % use Prob.N for sample points number
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma0', num2str(Algo.sigma0), ...
                'useN: (1: use Prob.N, 0: use 4+3*log(D))', num2str(Algo.useN)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma0 = str2double(Parameter{1});
        Algo.useN = str2double(Parameter{2});
    end

    function run(Algo, Prob)
        bridge = loadLESBridge();

        N = cell(1, Prob.T);
        meanDec = cell(1, Prob.T);
        sigma = cell(1, Prob.T);
        runner = cell(1, Prob.T);
        sample = cell(1, Prob.T);
        for t = 1:Prob.T
            if Algo.useN
                N{t} = Prob.N;
            else
                N{t} = fix(4 + 3 * log(Prob.D(t)));
            end
            if N{t} < 2
                error('LES:PopulationSize', ...
                'LES requires a population size of at least two.');
            end

            meanDec{t} = initESMean(Prob, t);
            Algo.Mean{t} = meanDec{t};
            sigma{t} = Algo.sigma0 * initESSigmaScale(Prob, t);

            % Draw the JAX seed from MATLAB so that MToP controls run seeds.
            seed = randi([0, double(intmax('int32'))]);
            meanPy = py.numpy.array(meanDec{t}, dtype = py.numpy.float32);
            runner{t} = bridge.LESRunner( ...
                int32(N{t}), int32(Prob.D(t)), meanPy, sigma{t}, int64(seed));

            sample{t}(1:N{t}) = Individual();
        end

        taskFE = zeros(1, Prob.T);
        maxTaskFE = Prob.maxFE / Prob.T;
        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                if taskFE(t) >= maxTaskFE
                    continue;
                end

                % Ask is performed by evosax; objective evaluation remains in MToP.
                currentRunner = runner{t};
                population = double(currentRunner.ask());
                expectedSize = [N{t}, Prob.D(t)];
                if ~isequal(size(population), expectedSize)
                    error('LES:PythonShape', ...
                        'Python returned a %s population; expected %s.', ...
                        mat2str(size(population)), mat2str(expectedSize));
                end
                for i = 1:N{t}
                    sample{t}(i).Dec = population(i, :);
                end

                [sample{t}, improved] = Algo.Evaluation(sample{t}, Prob, t);

                % Reuse MToP's lexicographic constraint handling and boundary
                % penalty. The finite ordinal fitness prevents Inf/NaN objective
                % values from destabilizing the learned JAX update.
                rank = RankWithBoundaryHandling(sample{t}, Prob);
                fitness = zeros(N{t}, 1);
                fitness(rank) = (0:N{t} - 1)';
                fitnessPy = py.numpy.array(fitness, dtype = py.numpy.float32);

                meanDec{t} = reshape(double(currentRunner.tell( ...
                    fitnessPy, logical(improved))), 1, []);
                if length(meanDec{t}) ~= Prob.D(t) || any(~isfinite(meanDec{t}))
                    error('LES:InvalidMean', ...
                    'The Python LES update returned an invalid search mean.');
                end
                Algo.Mean{t} = meanDec{t};
                taskFE(t) = taskFE(t) + N{t};
            end
        end
    end
end
end

function bridge = loadLESBridge()
% Import the local Python bridge without changing the process-wide pyenv.
algorithmDir = fileparts(mfilename('fullpath'));
sysPath = py.sys.path;
if sysPath.count(algorithmDir) == 0
    sysPath.insert(int32(0), algorithmDir);
end
py.importlib.invalidate_caches();
try
    bridge = py.importlib.import_module('les_bridge');
catch ME
    error('LES:PythonSetup', ...
        ['Unable to import the LES Python bridge. Configure MATLAB pyenv ' ...
        'with Python 3.10+ and install LES/requirements.txt.\nPython error: %s'], ...
        ME.message);
end
end
