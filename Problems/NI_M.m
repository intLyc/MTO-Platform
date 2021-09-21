classdef NI_M < Problem

    properties
    end

    methods

        function obj = NI_M(name)
            obj = obj@Problem(name);
            obj.dims = [50, 50];
            obj.tasks_name = {'Griewank', 'Weierstrass'};
        end

        function Tasks = getTasks(obj)
            load('NI_M.mat') % loading data from folder ./Tasks
            Tasks(1).dims = obj.dims(1);
            Tasks(1).fnc = @(x)Griewank(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -100 * ones(1, obj.dims(1));
            Tasks(1).Ub = 100 * ones(1, obj.dims(1));
            Tasks(2).dims = obj.dims(2);
            Tasks(2).fnc = @(x)Weierstrass(x, Rotation_Task2, GO_Task2);
            Tasks(2).Lb = -0.5 * ones(1, obj.dims(2));
            Tasks(2).Ub = 0.5 * ones(1, obj.dims(2));
        end

    end

end
