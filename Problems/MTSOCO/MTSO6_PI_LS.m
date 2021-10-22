classdef MTSO6_PI_LS < Problem

    properties
    end

    methods

        function obj = MTSO6_PI_LS(name)
            obj = obj@Problem(name);
            obj.dims = [50, 25];
            obj.tasks_name = {'Ackley', 'Weierstrass'};
        end

        function Tasks = getTasks(obj)
            load('PI_L.mat') % loading data from folder ./Tasks
            Tasks(1).dims = obj.dims(1);
            Tasks(1).fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -50 * ones(1, obj.dims(1));
            Tasks(1).Ub = 50 * ones(1, obj.dims(1));
            Tasks(2).dims = obj.dims(2);
            Tasks(2).fnc = @(x)Weierstrass(x, Rotation_Task2, GO_Task2);
            Tasks(2).Lb = -0.5 * ones(1, obj.dims(2));
            Tasks(2).Ub = 0.5 * ones(1, obj.dims(2));
        end

    end

end