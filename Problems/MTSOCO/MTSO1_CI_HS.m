classdef MTSO1_CI_HS < Problem

    properties
    end

    methods

        function obj = MTSO1_CI_HS(name)
            obj = obj@Problem(name);
            obj.dims = [50, 50];
            obj.tasks_name = {'Griewank', 'Rastrigin'};
        end

        function Tasks = getTasks(obj)
            load('CI_H.mat'); % loading data from folder ./Tasks
            Tasks(1).dims = obj.dims(1); % dimensionality of Task 1
            Tasks(1).fnc = @(x)Griewank(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -100 * ones(1, obj.dims(1)); % Upper bound of Task 1
            Tasks(1).Ub = 100 * ones(1, obj.dims(1)); % Lower bound of Task 1
            Tasks(2).dims = obj.dims(2); % dimensionality of Task 2
            Tasks(2).fnc = @(x)Rastrigin(x, Rotation_Task2, GO_Task2);
            Tasks(2).Lb = -50 * ones(1, obj.dims(2)); % Upper bound of Task 2
            Tasks(2).Ub = 50 * ones(1, obj.dims(2)); % Lower bound of Task 2
        end

    end

end
