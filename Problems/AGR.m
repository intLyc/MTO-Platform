classdef AGR < Problem

    properties
    end

    methods

        function obj = AGR(name)
            obj = obj@Problem(name);
            obj.dims = [50, 50, 50];
            obj.tasks_name = {'Ackley', 'Griewank', 'Rastrigin', };
        end

        function Tasks = getTasks(obj)
            Tasks(1).dims = obj.dims(1);
            Tasks(1).fnc = @(x)Ackley(x, 1, 0);
            Tasks(1).Lb = -50 * ones(1, obj.dims(1));
            Tasks(1).Ub = 50 * ones(1, obj.dims(1));

            Tasks(2).dims = obj.dims(2); % dimensionality of Task 1
            Tasks(2).fnc = @(x)Griewank(x, 1, 0);
            Tasks(2).Lb = -100 * ones(1, obj.dims(2)); % Upper bound of Task 1
            Tasks(2).Ub = 100 * ones(1, obj.dims(2)); % Lower bound of Task 1

            Tasks(3).dims = obj.dims(3); % dimensionality of Task 2
            Tasks(3).fnc = @(x)Rastrigin(x, 1, 0);
            Tasks(3).Lb = -50 * ones(1, obj.dims(3)); % Upper bound of Task 2
            Tasks(3).Ub = 50 * ones(1, obj.dims(3)); % Lower bound of Task 2
        end

    end

end
