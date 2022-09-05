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
            result(prob, algo).runTime = 0;
            result(prob, algo).convergeObj = [];
            result(prob, algo).convergeCV = [];
            result(prob, algo).bestDec = {};
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
        task_num(prob) = length(prob_obj_cell{prob}.getTasks());
    end
    data_save.sub_pop = data_save.sub_pop';
    data_save.sub_eva = data_save.sub_eva';
    data_save.algo_cell = algo_cell;
    data_save.prob_cell = prob_cell';
    data_save.task_num = task_num';

    if par_flag
        % Parallel Run
        for prob = 1:length(prob_obj_cell)
            disp(['Problem: ', char(prob_obj_cell{prob}.getName())]);
            for algo = 1:length(algo_obj_cell)
                convergeObj = {};
                convergeCV = {};
                bestDec = {};
                par_tool = Par(reps);
                parfor rep = 1:reps
                    Par.tic
                    data = singleRun(algo_obj_cell{algo}, prob_obj_cell{prob});
                    par_tool(rep) = Par.toc;
                    convergeObj = [convergeObj; {data.convergeObj}];
                    if ~isfield(data, 'convergeCV')
                        data.convergeCV = zeros(size(data.convergeObj));
                    end
                    convergeCV = [convergeCV; {data.convergeCV}];
                    bestDec = [bestDec; data.bestDec];
                end
                result(prob, algo).convergeObj = convergeObj{1};
                result(prob, algo).convergeCV = convergeCV{1};
                for rep = 2:reps
                    % data process
                    % convergeObj
                    gen_old = size(result(prob, algo).convergeObj, 2);
                    gen_new = size(convergeObj{rep}, 2);
                    if gen_old < gen_new
                        result(prob, algo).convergeObj = [result(prob, algo).convergeObj, repmat(result(prob, algo).convergeObj(:, gen_old), 1, gen_new - gen_old)];
                    else
                        convergeObj{rep} = [convergeObj{rep}, repmat(convergeObj{rep}(:, gen_new), 1, gen_old - gen_new)];
                    end
                    result(prob, algo).convergeObj = [result(prob, algo).convergeObj; convergeObj{rep}];
                    % convergeCV
                    gen_old = size(result(prob, algo).convergeCV, 2);
                    gen_new = size(convergeCV{rep}, 2);
                    if gen_old < gen_new
                        result(prob, algo).convergeCV = [result(prob, algo).convergeCV, repmat(result(prob, algo).convergeCV(:, gen_old), 1, gen_new - gen_old)];
                    else
                        convergeCV{rep} = [convergeCV{rep}, repmat(convergeCV{rep}(:, gen_new), 1, gen_old - gen_new)];
                    end
                    result(prob, algo).convergeCV = [result(prob, algo).convergeCV; convergeCV{rep}];
                end
                result(prob, algo).runTime = sum([par_tool.ItStop] - [par_tool.ItStart]);
                result(prob, algo).bestDec = bestDec;

                % print
                tasks_num = data_save.task_num(prob);
                for task = 1:tasks_num
                    convergeObj_task = result(prob, algo).convergeObj(task:tasks_num:end, :);
                    convergeCV_task = result(prob, algo).convergeCV(task:tasks_num:end, :);
                    convergeObj_task(convergeCV_task > 0) = NaN;
                    best_obj(task, :) = convergeObj_task(:, end);
                    best_cv(task, :) = convergeCV_task(:, end);
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
                    if ~isfield(data, 'convergeCV')
                        data.convergeCV = zeros(size(data.convergeObj));
                    end
                    result(prob, algo).runTime = result(prob, algo).runTime + toc(t_temp);
                    if ~isempty(result(prob, algo).convergeObj)
                        % data_process
                        % convergeObj
                        gen_old = size(result(prob, algo).convergeObj, 2);
                        gen_new = size(data.convergeObj, 2);
                        if gen_old < gen_new
                            result(prob, algo).convergeObj = [result(prob, algo).convergeObj, repmat(result(prob, algo).convergeObj(:, gen_old), 1, gen_new - gen_old)];
                        else
                            data.convergeObj = [data.convergeObj, repmat(data.convergeObj(:, gen_new), 1, gen_old - gen_new)];
                        end
                        result(prob, algo).convergeObj = [result(prob, algo).convergeObj; data.convergeObj];
                        % convergeCV
                        gen_old = size(result(prob, algo).convergeCV, 2);
                        gen_new = size(data.convergeCV, 2);
                        if gen_old < gen_new
                            result(prob, algo).convergeCV = [result(prob, algo).convergeCV, repmat(result(prob, algo).convergeCV(:, gen_old), 1, gen_new - gen_old)];
                        else
                            data.convergeCV = [data.convergeCV, repmat(data.convergeCV(:, gen_new), 1, gen_old - gen_new)];
                        end
                        result(prob, algo).convergeCV = [result(prob, algo).convergeCV; data.convergeCV];
                    else
                        result(prob, algo).convergeObj = data.convergeObj;
                        result(prob, algo).convergeCV = data.convergeCV;
                    end
                    result(prob, algo).bestDec = [result(prob, algo).bestDec; data.bestDec];

                    % print
                    best_obj = data.convergeObj(:, end)';
                    best_cv = data.convergeCV(:, end)';
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
