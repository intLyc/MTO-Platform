classdef Algorithm < handle
    %% Algorithm Base Class
    % Inherit the Algorithm class and implement the abstract functions

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------s

    properties
        name % Algorithm's name
    end

    methods
        function obj = Algorithm(varargin)
            % Algorithm constructor, cannot be changed
            if length(varargin) >= 1
                obj.name = varargin{1};
            else
                obj.name = 'algorithm';
            end
        end

        function name = getName(obj)
            % Get algorithm's name, cannot be changed
            name = obj.name;
        end

        function setName(obj, name)
            % Set algorithm's name, cannot be changed
            obj.name = name;
        end

        function parameter = getParameter(obj)
            % Get algorithm's parameter
            % return parameter, contains {para1, value1, para2, value2, ...} (string)
            parameter = {};
        end

        function obj = setParameter(obj, parameter_cell)
            % set algorithm's parameter
            % arg parameter_cell, contains {value1, value2, ...} (string)
        end
    end

    methods (Abstract)
        run(obj, Tasks) % run this tasks with algorithm,
        % return data, contains data.clock_time, data.convergence
    end
end
