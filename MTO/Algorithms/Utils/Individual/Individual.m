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
    Dec double % Decision variables (1xD)
    Obj double % Objective values (1xM)
    Con double % Constraint values (1xC)
    CV double % Constraint violation (1x1)
end

methods
    function value = Decs(obj)
        % Return matrix of Decision variables (NxD)
        if isempty(obj)
            value = [];
        else
            % vertcat is the standard optimized concatenation
            value = vertcat(obj.Dec);
        end
    end

    function value = Objs(obj)
        % Return matrix of Objective values (NxM)
        if isempty(obj)
            value = [];
        else
            value = vertcat(obj.Obj);
        end
    end

    function value = Cons(obj)
        % Return matrix of Constraint values (NxC)
        if isempty(obj)
            value = [];
        else
            value = vertcat(obj.Con);
        end
    end

    function value = CVs(obj)
        % Return vector of Constraint Violations (Nx1)
        if isempty(obj)
            value = [];
        else
            % CV is usually a scalar, simple concatenation is fast
            value = [obj.CV]';
        end
    end
end
end
