function data_save = MTO_commandline(algo_cell, prob_cell, reps)
    addpath(genpath('./Algorithms/'));
    addpath(genpath('./Problems/'));

    % initialize data
    for algo = 1:length(algo_cell)
        for prob = 1:length(prob_cell)
            result(prob, algo).clock_time = 0;
            result(prob, algo).convergence = [];
            result(prob, algo).bestX = {};
        end
    end
    algo_obj_cell = {};
    for algo = 1:length(algo_cell)
        eval(['algo_obj = ', algo_cell{algo}, '("', algo_cell{algo}, '"); ']);
        algo_obj_cell = [algo_obj_cell, {algo_obj}];
    end
    prob_obj_cell = {};
    for prob = 1:length(prob_cell)
        eval(['prob_obj = ', prob_cell{prob}, '("', prob_cell{prob}, '"); ']);
        prob_obj_cell = [prob_obj_cell, {prob_obj}];
    end

    for rep = 1:reps
        disp(['Rep: ', num2str(rep)]);
        for prob = 1:length(prob_cell)
            disp(['Problem: ', prob_cell{prob}]);
            for algo = 1:length(algo_cell)
                data = singleRun(algo_obj_cell{algo}, prob_obj_cell{prob});
                disp([algo_cell{algo}, ' Best Objective Values:', num2str(data.convergence(:, end)')]);

                result(prob, algo).clock_time = result(prob, algo).clock_time + data.clock_time;
                if ~isempty(result(prob, algo).convergence)
                    result(prob, algo).convergence = [result(prob, algo).convergence; data.convergence];
                else
                    result(prob, algo).convergence = data.convergence;
                end
                result(prob, algo).bestX = [result(prob, algo).bestX; data.bestX];
            end
        end
    end

    data_save.reps = reps;
    for prob = 1:length(prob_cell)
        run_parameter_list = prob_obj_cell{prob}.getRunParameterList();
        data_save.sub_pop(prob) = run_parameter_list(1);
        data_save.iter_num(prob) = run_parameter_list(2);
        data_save.eva_num(prob) = run_parameter_list(3);
        tasks_num_list(prob) = length(prob_obj_cell{prob}.getTasks());
    end
    data_save.sub_pop = data_save.sub_pop';
    data_save.iter_num = data_save.iter_num';
    data_save.eva_num = data_save.eva_num';
    data_save.algo_cell = algo_cell;
    data_save.prob_cell = prob_cell';
    data_save.tasks_num_list = tasks_num_list';
    data_save.result = result;
    % save('data_save', 'data_save');
end

function data = singleRun(algo_obj, prob_obj)
    data = algo_obj.run(prob_obj.getTasks(), prob_obj.getRunParameterList);
end
