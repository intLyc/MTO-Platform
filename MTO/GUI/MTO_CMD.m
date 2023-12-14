function MTO_CMD(AlgoCell, ProbCell, Reps, Par_Flag, Results_Num, Save_Dec, Save_Name)
%% MTO Platform run with command line, save data in mat file
% Input: algorithms char cell, problems char cell, no. of runs, parallel flag, no. of results, save decision variables flag, save file name
% Output: none

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

if isa(AlgoCell, 'char')
    AlgoCell = {AlgoCell};
end
if isa(ProbCell, 'char')
    ProbCell = {ProbCell};
end
AlgoCell = strrep(AlgoCell, '-', '_');
ProbCell = strrep(ProbCell, '-', '_');

% Create Algorithm and Problem Object cell
AlgoObject = {};
for algo = 1:length(AlgoCell)
    eval(['algo_obj = ', AlgoCell{algo}, '(''', strrep(AlgoCell{algo}, '_', '-'), '''); ']);
    AlgoObject = [AlgoObject, {algo_obj}];
end
ProbObject = {};
for prob = 1:length(ProbCell)
    eval(['prob_obj = ', ProbCell{prob}, '(''', strrep(ProbCell{prob}, '_', '-'), '''); ']);
    ProbObject = [ProbObject, {prob_obj}];
end

% Set Data
Data.Reps = Reps;
Data.Problems = [];
for prob = 1:length(ProbObject)
    Data.Problems(prob).Name = ProbObject{prob}.Name;
    Data.Problems(prob).T = ProbObject{prob}.T;
    Data.Problems(prob).M = ProbObject{prob}.M;
    if max(Data.Problems(prob).M) > 1
        Data.Problems(prob).Optimum = ProbObject{prob}.getOptimum();
    end
    Data.Problems(prob).D = ProbObject{prob}.D;
    Data.Problems(prob).N = ProbObject{prob}.N;
    Data.Problems(prob).Fnc = ProbObject{prob}.Fnc;
    Data.Problems(prob).Lb = ProbObject{prob}.Lb;
    Data.Problems(prob).Ub = ProbObject{prob}.Ub;
    Data.Problems(prob).maxFE = ProbObject{prob}.maxFE;
end
Data.Algorithms = [];
for algo = 1:length(AlgoObject)
    Data.Algorithms(algo).Name = AlgoObject{algo}.Name;
    Data.Algorithms(algo).Para = AlgoObject{algo}.getParameter();
end
Data.Results = {};
Data.RunTimes = [];
Results = {};

% Run
for prob = 1:length(ProbObject)
    disp(['Problem: ', char(ProbObject{prob}.Name)]);
    for algo = 1:length(AlgoObject)
        disp(['Algorithm: ', char(AlgoObject{algo}.Name)]);
        algo_obj = AlgoObject{algo};
        algo_obj.Result_Num = Results_Num;
        algo_obj.Save_Dec = Save_Dec;
        if Par_Flag
            par_tool = Par(Reps);
            parfor rep = 1:Reps
                Par.tic
                algo_obj.reset();
                algo_obj.run(ProbObject{prob});
                tmp = algo_obj.getResult(ProbObject{prob});
                for t = 1:size(tmp, 1)
                    for g = 1:size(tmp, 2)
                        if max(ProbObject{prob}.M) > 1
                            Results(prob, algo, rep).Obj{t}(g, :, :) = tmp(t, g).Obj;
                            if isfield(tmp, 'Dec')
                                Results(prob, algo, rep).Dec(t, g, :, :) = tmp(t, g).Dec;
                            end
                        else
                            Results(prob, algo, rep).Obj(t, g, :) = tmp(t, g).Obj;
                            if isfield(tmp, 'Dec')
                                Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                            end
                        end
                        Results(prob, algo, rep).CV(t, g, :) = tmp(t, g).CV;
                    end
                end
                par_tool(rep) = Par.toc;
            end
            Data.RunTimes(prob, algo, :) = [par_tool.ItStop] - [par_tool.ItStart];
        else
            t_temp = [];
            for rep = 1:Reps
                tstart = tic;
                algo_obj.reset();
                algo_obj.run(ProbObject{prob});
                tmp = algo_obj.getResult(ProbObject{prob});
                for t = 1:size(tmp, 1)
                    for g = 1:size(tmp, 2)
                        if max(ProbObject{prob}.M) > 1
                            Results(prob, algo, rep).Obj{t}(g, :, :) = tmp(t, g).Obj;
                            if isfield(tmp, 'Dec')
                                Results(prob, algo, rep).Dec(t, g, :, :) = tmp(t, g).Dec;
                            end
                        else
                            Results(prob, algo, rep).Obj(t, g, :) = tmp(t, g).Obj;
                            if isfield(tmp, 'Dec')
                                Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                            end
                        end
                        Results(prob, algo, rep).CV(t, g, :) = tmp(t, g).CV;
                    end
                end
                t_temp(rep) = toc(tstart);
            end
            Data.RunTimes(prob, algo, :) = t_temp;
        end
    end
    % save temporary data
    % Data.Results = MakeGenEqual(Results);
    % MTOData = Data;
    % MTOData.Problems = MTOData.Problems(1:prob);
    % save('MTOData_Temp', 'MTOData');
end

% save mat file
Data.Results = MakeGenEqual(Results);
MTOData = Data;
save(Save_Name, 'MTOData');
end
