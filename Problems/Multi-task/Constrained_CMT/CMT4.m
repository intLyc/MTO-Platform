classdef CMT4 < Problem
    % <Multi> <Constrained>

    properties
        dims = 50;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'Dims', num2str(obj.dims)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, parameter_cell)
            obj.setRunParameter(parameter_cell(1:2));
            count = 3;
            obj.dims = str2double(parameter_cell{count}); count = count + 1;
        end

        function Tasks = getTasks(obj)
            Tasks(1).dims = obj.dims;
            Tasks(1).fnc = @(x)Rastrigin1(x, 1, 0 * ones(1, obj.dims), -20 * ones(1, obj.dims));
            Tasks(1).Lb = -50 * ones(1, obj.dims);
            Tasks(1).Ub = 50 * ones(1, obj.dims);

            Tasks(2).dims = obj.dims;
            Tasks(2).fnc = @(x)Sphere1(x, 1, 0 * ones(1, obj.dims), 30 * ones(1, obj.dims));
            Tasks(2).Lb = -100 * ones(1, obj.dims);
            Tasks(2).Ub = 100 * ones(1, obj.dims);
        end
    end
end
