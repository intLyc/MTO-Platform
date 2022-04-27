classdef C4TOP4 < Problem
    % <Multi> <Competitive>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    
    methods
        function obj = C4TOP4(name)
            obj = obj@Problem(name);
            obj.sub_eva = 1000 * 50;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_C4TOP(4);
        end
    end
end
