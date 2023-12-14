classdef Individual

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
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
