classdef MTSO9_NI_LS < Problem

    properties
    end

    methods

        function obj = MTSO9_NI_LS(name)
            obj = obj@Problem(name);
            obj.dims = [50, 50];
            obj.tasks_name = {'Rastrigin', 'Schwefel'};
        end

        function Tasks = getTasks(obj)
            load('NI_L.mat') % loading data from folder ./Tasks
            Tasks(1).dims = obj.dims(1);
            Tasks(1).fnc = @(x)Rastrigin(x, Rotation_Task1, GO_Task1);
            Tasks(1).Lb = -50 * ones(1, obj.dims(1));
            Tasks(1).Ub = 50 * ones(1, obj.dims(1));
            Tasks(2).dims = obj.dims(2);
            Tasks(2).fnc = @(x)Schwefel(x);
            Tasks(2).Lb = -500 * ones(1, obj.dims(2));
            Tasks(2).Ub = 500 * ones(1, obj.dims(2));
        end

    end

end
