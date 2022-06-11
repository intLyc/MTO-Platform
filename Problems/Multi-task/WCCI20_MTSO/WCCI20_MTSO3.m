classdef WCCI20_MTSO3 < Problem
    % <Multi> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = WCCI20_MTSO3(varargin)
            obj = obj@Problem(varargin);
            obj.sub_eva = 1000 * 50;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI20_MTSO(3);
        end
    end
end
