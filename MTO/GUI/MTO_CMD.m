function MTOData = MTO_CMD(AlgoCell, ProbCell, varargin)
%% MTO_CMD - Hybrid command-line runner for MToP (preserves original data structure)
% Supports both positional and Name-Value pair style inputs,
% and preallocates Results as the original struct array so MakeGenEqual works.
%
% Examples:
%   MTO_CMD({MFEA, MFDE},{CMT1, CMT2})
%   MTO_CMD({MFEA, MFDE},{CMT1, CMT2}, 5, true, 100, false, 'MTOData.mat', 2333)
%   MTO_CMD({MFEA, MFDE},{CMT1, CMT2}, 'Reps', 5, 'Par_Flag', true)

fprintf('** MToP Command-Line Runner\n');

%% ------------------- Default values -------------------------------------
default.Reps = 1;
default.Par_Flag = false;
default.Results_Num = 50;
default.Save_Dec = false;
default.Save_Name = 'MTOData.mat';
default.Global_Seed = randi(1e6);

%% ------------------- Detect input mode ---------------------------------
if ~isempty(varargin) && ischar(varargin{1})
    mode = 'namevalue';
else
    mode = 'positional';
end

%% ------------------- Parse input ---------------------------------------
if strcmp(mode, 'positional')
    args = varargin;
    params = cell(1, 6);
    n = numel(args);
    params(1:n) = args;
    [Reps, Par_Flag, Results_Num, Save_Dec, Save_Name, Global_Seed] = deal(params{:});

    if isempty(Reps), Reps = default.Reps; end
    if isempty(Par_Flag), Par_Flag = default.Par_Flag; end
    if isempty(Results_Num), Results_Num = default.Results_Num; end
    if isempty(Save_Dec), Save_Dec = default.Save_Dec; end
    if isempty(Save_Name), Save_Name = default.Save_Name; end
    if isempty(Global_Seed), Global_Seed = default.Global_Seed; end
else
    p = inputParser;
    addParameter(p, 'Reps', default.Reps, @(x)isnumeric(x) && x > 0);
    addParameter(p, 'Par_Flag', default.Par_Flag, @(x)islogical(x) || isnumeric(x));
    addParameter(p, 'Results_Num', default.Results_Num, @(x)isnumeric(x) && x > 0);
    addParameter(p, 'Save_Dec', default.Save_Dec, @(x)islogical(x) || isnumeric(x));
    addParameter(p, 'Save_Name', default.Save_Name, @(x)ischar(x) || isstring(x));
    addParameter(p, 'Global_Seed', default.Global_Seed, @(x)isnumeric(x) && isscalar(x));
    parse(p, varargin{:});
    s = p.Results;
    [Reps, Par_Flag, Results_Num, Save_Dec, Save_Name, Global_Seed] = ...
        deal(s.Reps, s.Par_Flag, s.Results_Num, s.Save_Dec, s.Save_Name, s.Global_Seed);
end

%% ------------------- Normalize input -----------------------------------
if ~isa(AlgoCell, 'cell'), AlgoCell = {AlgoCell}; end
if ~isa(ProbCell, 'cell'), ProbCell = {ProbCell}; end

%% ------------------- Create objects (keeps original eval behavior) -----
AlgoObject = {};
for algo = 1:length(AlgoCell)
    if isa(AlgoCell{algo}, 'char')
        AlgoCell{algo} = strrep(AlgoCell{algo}, '-', '_');
        eval(['algo_obj = ', AlgoCell{algo}, '(''', strrep(AlgoCell{algo}, '_', '-'), ''');']);
    else
        algo_obj = AlgoCell{algo};
    end
    AlgoObject = [AlgoObject, {algo_obj}];
end

ProbObject = {};
for prob = 1:length(ProbCell)
    if isa(ProbCell{prob}, 'char')
        ProbCell{prob} = strrep(ProbCell{prob}, '-', '_');
        eval(['prob_obj = ', ProbCell{prob}, '(''', strrep(ProbCell{prob}, '_', '-'), ''');']);
    else
        prob_obj = ProbCell{prob};
    end
    ProbObject = [ProbObject, {prob_obj}];
end

%% ------------------- Initialize Data -----------------------------------
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
% Prepare Results as preallocated struct array to match original layout
nProb = length(ProbObject);
nAlgo = length(AlgoObject);
Results = repmat(struct('Obj', [], 'Dec', [], 'CV', []), [nProb, nAlgo, Reps]);

%% ------------------- Global Seed ---------------------------------------
seeds = (0:Reps - 1) + Global_Seed;

%% ------------------- Run Experiments -----------------------------------
for prob = 1:length(ProbObject)
    disp([' * Problem: ', char(ProbObject{prob}.Name)]);
    % local copies to avoid repeated indexing inside parfor (if needed)
    prob_obj = ProbObject{prob};
    for algo = 1:length(AlgoObject)
        disp(['   Algorithm: ', char(AlgoObject{algo}.Name)]);
        algo_obj = AlgoObject{algo};
        algo_obj.Result_Num = Results_Num;
        algo_obj.Save_Dec = Save_Dec;

        if Par_Flag
            % Use preallocated Results to allow indexed assignment inside parfor
            par_tool = Par(Reps);
            parfor rep = 1:Reps
                rng(seeds(rep));
                Par.tic
                % note: use prob_obj / algo_obj references (object handles)
                prob_obj.setTasks();
                algo_obj.reset();
                algo_obj.run(prob_obj);
                tmp = algo_obj.getResult(prob_obj);
                out = ConvertResult(tmp, prob_obj); % produce struct
                Results(prob, algo, rep) = out; % assign into preallocated struct array
                par_tool(rep) = Par.toc;
            end
            Data.RunTimes(prob, algo, :) = [par_tool.ItStop] - [par_tool.ItStart];
        else
            t_temp = zeros(1, Reps);
            for rep = 1:Reps
                rng(seeds(rep));
                tstart = tic;
                prob_obj.setTasks();
                algo_obj.reset();
                algo_obj.run(prob_obj);
                tmp = algo_obj.getResult(prob_obj);
                out = ConvertResult(tmp, prob_obj);
                Results(prob, algo, rep) = out;
                t_temp(rep) = toc(tstart);
            end
            Data.RunTimes(prob, algo, :) = t_temp;
        end
    end
end

%% ------------------- Save ----------------------------------------------
Data.Results = MakeGenEqual(Results);
MTOData = Data;
save(Save_Name, 'MTOData');
fprintf('** Results saved to "%s"\n', Save_Name);

end

%% ------------------- Helper: Convert result -----------------------------
function out = ConvertResult(tmp, prob_obj)
% Ensure out is always a struct with fields Obj/Dec/CV (possibly empty)
out = struct('Obj', [], 'Dec', [], 'CV', []);
for t = 1:size(tmp, 1)
    for g = 1:size(tmp, 2)
        if max(prob_obj.M) > 1
            % multi-objective / multi-task structures use cell arrays in Obj
            if ~isfield(out, 'Obj') || isempty(out.Obj)
                out.Obj = cell(size(tmp, 1), 1); % ensure cell container at least
            end
            out.Obj{t}(g, :, :) = tmp(t, g).Obj;
            if isfield(tmp, 'Dec')
                out.Dec(t, g, :, :) = tmp(t, g).Dec;
            end
        else
            out.Obj(t, g, :) = tmp(t, g).Obj;
            if isfield(tmp, 'Dec')
                out.Dec(t, g, :) = tmp(t, g).Dec;
            end
        end
        out.CV(t, g, :) = tmp(t, g).CV;
    end
end
end
