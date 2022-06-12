function MTO_CMD(algo_cell, prob_cell, reps, save_name, par_flag)
    %% MTO Platform run with command line, save data in mat file
    % Input: algorithms char cell, problems char cell, reps, save file name, parallel flag
    % Output: none

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    if isa(algo_cell, 'char')
        algo_cell = {algo_cell};
    end
    if isa(prob_cell, 'char')
        prob_cell = {prob_cell};
    end
    algo_cell = strrep(algo_cell, '-', '_');
    prob_cell = strrep(prob_cell, '-', '_');

    % initialize data
    for algo = 1:length(algo_cell)
        for prob = 1:length(prob_cell)
            result(prob, algo).clock_time = 0;
            result(prob, algo).convergence = [];
            result(prob, algo).convergence_cv = [];
            result(prob, algo).bestX = {};
        end
    end
    algo_obj_cell = {};
    for algo = 1:length(algo_cell)
        eval(['algo_obj = ', algo_cell{algo}, '(''', strrep(algo_cell{algo}, '_', '-'), '''); ']);
        algo_obj_cell = [algo_obj_cell, {algo_obj}];
    end
    prob_obj_cell = {};
    for prob = 1:length(prob_cell)
        eval(['prob_obj = ', prob_cell{prob}, '(''', strrep(prob_cell{prob}, '_', '-'), '''); ']);
        prob_obj_cell = [prob_obj_cell, {prob_obj}];
    end

    data_save.reps = reps;
    for prob = 1:length(prob_cell)
        run_parameter_list = prob_obj_cell{prob}.getRunParameterList();
        data_save.sub_pop(prob) = run_parameter_list(1);
        data_save.sub_eva(prob) = run_parameter_list(2);
        tasks_num_list(prob) = length(prob_obj_cell{prob}.getTasks());
    end
    data_save.sub_pop = data_save.sub_pop';
    data_save.sub_eva = data_save.sub_eva';
    data_save.algo_cell = algo_cell;
    data_save.prob_cell = prob_cell';
    data_save.tasks_num_list = tasks_num_list';

    if par_flag
        % Parallel Run
        for prob = 1:length(prob_obj_cell)
            disp(['Problem: ', char(prob_obj_cell{prob}.getName())]);
            for algo = 1:length(algo_obj_cell)
                convergence = {};
                convergence_cv = {};
                bestX = {};
                par_tool = Par(reps);
                parfor rep = 1:reps
                    Par.tic
                    data = singleRun(algo_obj_cell{algo}, prob_obj_cell{prob});
                    par_tool(rep) = Par.toc;
                    convergence = [convergence; {data.convergence}];
                    if ~isfield(data, 'convergence_cv')
                        data.convergence_cv = zeros(size(data.convergence));
                    end
                    convergence_cv = [convergence_cv; {data.convergence_cv}];
                    bestX = [bestX; data.bestX];
                end
                result(prob, algo).convergence = convergence{1};
                result(prob, algo).convergence_cv = convergence_cv{1};
                for rep = 2:reps
                    % data process
                    % convergence
                    gen_old = size(result(prob, algo).convergence, 2);
                    gen_new = size(convergence{rep}, 2);
                    if gen_old < gen_new
                        result(prob, algo).convergence = [result(prob, algo).convergence, repmat(result(prob, algo).convergence(:, gen_old), 1, gen_new - gen_old)];
                    else
                        convergence{rep} = [convergence{rep}, repmat(convergence{rep}(:, gen_new), 1, gen_old - gen_new)];
                    end
                    result(prob, algo).convergence = [result(prob, algo).convergence; convergence{rep}];
                    % convergence_cv
                    gen_old = size(result(prob, algo).convergence_cv, 2);
                    gen_new = size(convergence_cv{rep}, 2);
                    if gen_old < gen_new
                        result(prob, algo).convergence_cv = [result(prob, algo).convergence_cv, repmat(result(prob, algo).convergence_cv(:, gen_old), 1, gen_new - gen_old)];
                    else
                        convergence_cv{rep} = [convergence_cv{rep}, repmat(convergence_cv{rep}(:, gen_new), 1, gen_old - gen_new)];
                    end
                    result(prob, algo).convergence_cv = [result(prob, algo).convergence_cv; convergence_cv{rep}];
                end
                result(prob, algo).clock_time = sum([par_tool.ItStop] - [par_tool.ItStart]);
                result(prob, algo).bestX = bestX;

                % print
                tasks_num = data_save.tasks_num_list(prob);
                for task = 1:tasks_num
                    convergence_task = result(prob, algo).convergence(task:tasks_num:end, :);
                    convergence_cv_task = result(prob, algo).convergence_cv(task:tasks_num:end, :);
                    convergence_task(convergence_cv_task > 0) = NaN;
                    best_obj(task, :) = convergence_task(:, end);
                    best_cv(task, :) = convergence_cv_task(:, end);
                end
                best_obj(best_cv > 0) = NaN;
                str_temp = num2str(nanmean(best_obj, 2)', '%.2e, ');
                disp(['Algorithm: ', char(algo_obj_cell{algo}.getName()), ' / Mean Best Objs: ', str_temp]);
            end
        end
    else
        % No Parallel
        for rep = 1:reps
            disp(['Rep: ', num2str(rep)]);
            for prob = 1:length(prob_obj_cell)
                disp(['Problem: ', char(prob_obj_cell{prob}.getName())]);
                for algo = 1:length(algo_obj_cell)
                    t_temp = tic;
                    data = singleRun(algo_obj_cell{algo}, prob_obj_cell{prob});
                    if ~isfield(data, 'convergence_cv')
                        data.convergence_cv = zeros(size(data.convergence));
                    end
                    result(prob, algo).clock_time = result(prob, algo).clock_time + toc(t_temp);
                    if ~isempty(result(prob, algo).convergence)
                        % data_process
                        % convergence
                        gen_old = size(result(prob, algo).convergence, 2);
                        gen_new = size(data.convergence, 2);
                        if gen_old < gen_new
                            result(prob, algo).convergence = [result(prob, algo).convergence, repmat(result(prob, algo).convergence(:, gen_old), 1, gen_new - gen_old)];
                        else
                            data.convergence = [data.convergence, repmat(data.convergence(:, gen_new), 1, gen_old - gen_new)];
                        end
                        result(prob, algo).convergence = [result(prob, algo).convergence; data.convergence];
                        % convergence_cv
                        gen_old = size(result(prob, algo).convergence_cv, 2);
                        gen_new = size(data.convergence_cv, 2);
                        if gen_old < gen_new
                            result(prob, algo).convergence_cv = [result(prob, algo).convergence_cv, repmat(result(prob, algo).convergence_cv(:, gen_old), 1, gen_new - gen_old)];
                        else
                            data.convergence_cv = [data.convergence_cv, repmat(data.convergence_cv(:, gen_new), 1, gen_old - gen_new)];
                        end
                        result(prob, algo).convergence_cv = [result(prob, algo).convergence_cv; data.convergence_cv];
                    else
                        result(prob, algo).convergence = data.convergence;
                        result(prob, algo).convergence_cv = data.convergence_cv;
                    end
                    result(prob, algo).bestX = [result(prob, algo).bestX; data.bestX];

                    % print
                    best_obj = data.convergence(:, end)';
                    best_cv = data.convergence_cv(:, end)';
                    best_obj(best_cv > 0) = NaN;
                    str_temp = num2str(best_obj, '%.2e, ');
                    disp(['Algorithm: ', char(algo_obj_cell{algo}.getName()), ' / Best Objs: ', str_temp]);
                end
            end
        end
    end
    data_save.result = result;

    % save mat file
    save(save_name, 'data_save');
end

function data = singleRun(algo_obj, prob_obj)
    data = algo_obj.run(prob_obj.getTasks(), prob_obj.getRunParameterList);
end
