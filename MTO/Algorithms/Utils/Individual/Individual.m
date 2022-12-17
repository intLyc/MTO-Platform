classdef Individual

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

%% Individual Base Class

properties
    Dec % decision variables
    Obj % objective value
    CV % constraint violation
end

methods
    function value = Decs(obj)
        value = cat(1, obj.Dec);
    end

    function value = Objs(obj)
        value = cat(1, obj.Obj);
    end

    function value = CVs(obj)
        value = cat(1, obj.CV);
    end
end
end
