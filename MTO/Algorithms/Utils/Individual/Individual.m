classdef Individual

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

%% Individual Base Class

properties
    Dec % decision variables
    Obj % objective value
    Con % constraint values
    CV % constraint violation
end

methods
    function value = Decs(obj)
        value = cat(1, obj.Dec);
    end

    function value = Objs(obj)
        value = cat(1, obj.Obj);
    end

    function value = Cons(obj)
        value = cat(1, obj.Con);
    end

    function value = CVs(obj)
        value = cat(1, obj.CV);
    end
end
end
