classdef IMEA < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Hashimoto2018IMEA,
    %   title     = {Analysis of Evolutionary Multi-Tasking as an Island Model},
    %   author    = {Hashimoto, Ryuichi and Ishibuchi, Hisao and Masuyama, Naoki and Nojima, Yusuke},
    %   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
    %   year      = {2018},
    %   address   = {New York, NY, USA},
    %   pages     = {1894–1897},
    %   publisher = {Association for Computing Machinery},
    %   series    = {GECCO '18},
    %   doi       = {10.1145/3205651.3208228},
    %   isbn      = {9781450357647},
    %   location  = {Kyoto, Japan},
    %   numpages  = {4},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        T = 10;
        N = 10;
        mu = 2;
        mum = 5;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'T: Transfer Interval', num2str(obj.T), ...
                        'N: Transfer Size', num2str(obj.N), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.T = str2double(parameter_cell{count}); count = count + 1;
            obj.N = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMT(Individual, sub_pop, Tasks, max([Tasks.dims]) * ones(1, length(Tasks)));
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    parent = population{t};

                    % transfer
                    if obj.N > 0 && mod(generation, obj.T) == 0
                        transfer_num = round(obj.N ./ (length(Tasks) - 1));
                        transfer_pop = Individual.empty();
                        for tt = 1:length(Tasks)
                            if t == tt
                                continue;
                            end
                            transfer_idx = randperm(length(population{tt}), transfer_num);
                            tmp_pop = population{tt}(transfer_idx);
                            transfer_pop = [transfer_pop, tmp_pop];
                        end
                        [~, replace_idx] = sort(- [population{t}.factorial_costs]);
                        parent(replace_idx(1:length(transfer_pop))) = transfer_pop;
                    end

                    % generation
                    [offspring, calls] = OperatorGA.generate(1, parent, Tasks(t), obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    population{t} = [population{t}, offspring];
                    [~, rank] = sort([population{t}.factorial_costs]);
                    population{t} = population{t}(rank(1:sub_pop));
                    [bestobj_now, idx] = min([population{t}.factorial_costs]);
                    if bestobj_now < bestobj(t)
                        bestobj(t) = bestobj_now;
                        data.bestX{t} = population{t}(idx).rnvec;
                    end
                    data.convergence(t, generation) = bestobj(t);
                end
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
