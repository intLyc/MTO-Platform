classdef CEC06_CSO7 < Problem
    % <Single> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC06_CSO7(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 500000;
        end

        function Tasks = getTasks(obj)
            Tasks(1) = benchmark_CEC06_CSO(7);
        end
    end
end
