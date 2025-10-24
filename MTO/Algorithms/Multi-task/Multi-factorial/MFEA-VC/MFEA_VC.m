classdef MFEA_VC < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Wang2024MFEA-VC,
%   title   = {Contrastive Variational Auto-Encoder Driven Convergence Guidance in Evolutionary Multitasking},
%   author  = {Ruilin Wang and Xiang Feng and Huiqun Yu},
%   journal = {Applied Soft Computing},
%   year    = {2024},
%   issn    = {1568-4946},
%   pages   = {111883},
%   volume  = {163},
%   doi     = {https://doi.org/10.1016/j.asoc.2024.111883},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    RMP = 0.3
    MuC = 2
    MuM = 5
    VAEModel
    X1
    X2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);

        while Algo.notTerminated(Prob, population)
            if Algo.Gen <= 25
                % Extract Dec, MFObj, and TaskLabel from the population
                numIndividuals = length(population);
                Dec = [];
                MFObj = zeros(numel(population(1).MFObj), numIndividuals);
                TaskLabel = zeros(1, numIndividuals);
                data = [];

                for i = 1:numIndividuals
                    Dec(:, i) = population(i).Dec(1, :);
                    MFObj(:, i) = population(i).MFObj(:);
                    TaskLabel(i) = population(i).MFFactor;
                    data(:, i) = [Dec(:, i); MFObj(:, i); TaskLabel(i) .* 10000];
                end
                data(1:size(Dec, 1), :) = Dec .* 10000;

                % Get the input sizes for Dec, MFObj, and TaskLabel
                data1 = [data(:, TaskLabel == 1)];
                data2 = [data(:, TaskLabel == 2)];
                desiredColumns = 100; % 设定你需要的列数

                % For data1
                if size(data1, 2) > desiredColumns
                    % 如果超过设定的列数，裁剪
                    data1 = data1(:, 1:desiredColumns);
                elseif size(data1, 2) < desiredColumns
                    % 如果小于设定的列数，随机采样补齐
                    additionalSamples = datasample(data1', desiredColumns - size(data1, 2))';
                    data1 = [data1 additionalSamples];
                end

                % 对data2执行相同的操作
                if size(data2, 2) > desiredColumns
                    data2 = data2(:, 1:desiredColumns);
                elseif size(data2, 2) < desiredColumns
                    additionalSamples = datasample(data2', desiredColumns - size(data2, 2))';
                    data2 = [data2 additionalSamples];
                end

                % 将data随机分为训练集和测试集
                splitRatio = 0.5;
                data1Num = size(data1, 2);
                data2Num = size(data2, 2);
                numX1 = floor(splitRatio * data1Num);
                numX2 = floor(splitRatio * data2Num);
                randomIndices1 = randperm(numX1);
                randomIndices2 = randperm(numX2);
                trainIndices1 = randomIndices1(1:numX1);
                trainIndices2 = randomIndices2(1:numX2);
                testIndices1 = trainIndices1;
                testIndices2 = trainIndices2;
                Algo.X1 = data1(:, trainIndices1(:)); %task1训练集
                X3 = data1(:, testIndices1(:)); %task1测试集
                Algo.X2 = data2(:, trainIndices2(:)); %task2训练集
                X4 = data2(:, testIndices2(:)); %task2测试集
                inputSizeX1 = size(Algo.X1, 1) - 1;
                inputSizeX2 = size(X3, 1) - 1;
                inputSizeX3 = size(Algo.X2, 1) - 1;
                inputSizeX4 = size(X4, 1) - 1;

                hiddenSize = 256;
                latentSize = 200;
                Algo.VAEModel = MyVAE(inputSizeX1, inputSizeX2, hiddenSize, latentSize);

                % Train VAE models
                istraining = false;
                if istraining == true
                    Algo.VAEModel.train(Algo.X1, Algo.X2);
                end

                % Generate new individuals with VAE
                lambda = 0.8; % 控制生成新个体的任务相似性权重，范围在0到1之间
                newIndividuals = Algo.VAEModel.generate(Algo.X1, Algo.X2, lambda);
            else
                newIndividuals = Individual_MF.empty();
            end

            % Generation
            offspring = Algo.Generation(population, newIndividuals);
            % Evaluation
            offspring_temp = Individual_MF.empty();

            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;
            % Selection
            population = Selection_MF(population, offspring, Prob);
        end
    end

    function offspring = Generation(Algo, population, newIndividuals)
        indorder = randperm(length(population));
        count = 1;

        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            % 修改交叉操作部分
            if (population(p1).MFFactor == population(p2).MFFactor) || rand() < Algo.RMP
                if Algo.Gen <= 25
                    newIndividualIdx = randi(length(newIndividuals));
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, newIndividuals(newIndividualIdx).Dec, Algo.MuC);
                    [offspring(count + 1).Dec, ~] = GA_Crossover(population(p2).Dec, newIndividuals(newIndividualIdx).Dec, Algo.MuC);
                    offspring(count).Dec = offspring(count).Dec(1:length(population(p1).Dec));
                    offspring(count + 1).Dec = offspring(count + 1).Dec(1:length(population(p2).Dec));
                else
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                end
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            else
                % mutation
                offspring(count).Dec = GA_Mutation(population(p1).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, Algo.MuM);

                % imitation
                offspring(count).MFFactor = population(p1).MFFactor;
                offspring(count + 1).MFFactor = population(p2).MFFactor;
            end
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
