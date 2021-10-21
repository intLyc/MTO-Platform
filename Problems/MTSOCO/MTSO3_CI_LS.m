classdef MTSO3_CI_LS < Problem

    properties
    end

    methods

        function obj = MTSO3_CI_LS(name)
            obj = obj@Problem(name);
            obj.dims = [50, 50];
            obj.tasks_name = {'Ackley', 'Schwefel'};
        end

        function Tasks = getTasks(obj)
            load('CI_L.mat') % loading data from folder ./Tasks
            Tasks(1).dims = obj.dims(1);
            Tasks(1).fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -50 * ones(1, obj.dims(1));
            Tasks(1).Ub = 50 * ones(1, obj.dims(1));
            Tasks(2).dims = obj.dims(2);
            Tasks(2).fnc = @(x)Schwefel(x);
            Tasks(2).Lb = -500 * ones(1, obj.dims(2));
            Tasks(2).Ub = 500 * ones(1, obj.dims(2));
        end

    end

end
