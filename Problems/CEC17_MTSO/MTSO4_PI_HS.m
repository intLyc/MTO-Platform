classdef MTSO4_PI_HS < Problem

    properties
    end

    methods
        function parameter = getParameter(obj)
            parameter = {};
        end

        function obj = setParameter(obj, parameter_cell)
        end

        function Tasks = getTasks(obj)
            dims = [50 50];
            load('PI_H.mat') % loading data from folder ./Tasks
            Tasks(1).dims = dims(1);
            Tasks(1).fnc = @(x)Rastrigin(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -50 * ones(1, dims(1));
            Tasks(1).Ub = 50 * ones(1, dims(1));
            Tasks(2).dims = dims(2);
            Tasks(2).fnc = @(x)Sphere(x, 1, GO_Task2);
            Tasks(2).Lb = -100 * ones(1, dims(2));
            Tasks(2).Ub = 100 * ones(1, dims(2));
        end

    end

end
