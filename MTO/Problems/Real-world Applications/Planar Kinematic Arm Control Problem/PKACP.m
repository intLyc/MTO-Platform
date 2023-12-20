classdef PKACP < Problem
% <Multi-task/Many-task> <Single-objective> <None>

% Planar Kinematic Arm Control Problem
% Provided by Jiang, Yi

%------------------------------- Reference --------------------------------
% Reference 1
% @Article{Jiang2022BoKT,
%   author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   title      = {A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization},
%   year       = {2022},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2022.3210783},
% }
% Reference 2
% @Article{Xu2021AEMTO,
%   title   = {Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer},
%   author  = {Xu, Hao and Qin, A. K. and Xia, Siyu},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2021},
%   pages   = {1-1},
%   doi     = {10.1109/TEVC.2021.3107435},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties
    Ntask = 20
    Dim = 20
    Gen = 100
end

methods
    function Prob = PKACP(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
    end

    function parameter = getParameter(Prob)
        parameter = {'Ntask: The number of the tasks', num2str(Prob.Ntask), ...
                'Dim: Dimensionality of each task', num2str(Prob.Dim), ...
                'Gen: Generation number', num2str(Prob.Gen), };
        parent_para = Prob.getRunParameter();
        parameter = [parent_para, parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        Prob.Ntask = str2double(Parameter{3});
        Prob.Dim = str2double(Parameter{4});
        Prob.Gen = str2double(Parameter{5});
        Prob.T = Prob.Ntask;
        if Prob.maxFE ~= Prob.Ntask * Prob.N * Prob.Gen
            Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        else
            Prob.setRunParameter({Parameter{1}, Parameter{2}});
        end
    end

    function setTasks(Prob)
        Prob.maxFE = Prob.Ntask * Prob.N * Prob.Gen;
        Prob.T = Prob.Ntask;
        file_dir = './Problems/Real-world Applications/Planar Kinematic Arm Control Problem/';
        file_name = [file_dir, 'cvt_d', num2str(Prob.Dim), '_nt', num2str(Prob.Ntask), '.mat'];
        if exist(file_name, 'file')
            load(file_name);
        else
            samples = 50 * Prob.Ntask;
            x = rand(samples, 2);
            [Idx, C] = kmeans(x, Prob.Ntask);
            task_para = C;
            save(file_name, 'task_para');
        end

        Prob.D = [];
        Prob.Lb = {};
        Prob.Ub = {};
        Prob.Fnc = {};
        for t = 1:Prob.T
            Prob.D(t) = Prob.Dim;
            Prob.Lb{t} = zeros(1, Prob.D(t));
            Prob.Ub{t} = ones(1, Prob.D(t));
            Amax = task_para(t, 1);
            Lmax = task_para(t, 2);
            Prob.Fnc{t} = @(x)fitness_arm(x, Amax, Lmax);
        end
    end
end
end

function [Objs, Cons] = fitness_arm(angles_var, Amax, Lmax)
Objs = [];
for i = 1:size(angles_var, 1)
    angles = angles_var(i, :);
    angular_range = Amax / length(angles);
    lengths = ones(1, length(angles)) * Lmax / length(angles);
    target = 0.5 * ones(1, 2);
    command = (angles - 0.5) * angular_range * pi * 2;
    ef = fw_kinematics(command, lengths);
    fitness = sum((ef - target) .* (ef - target))^0.5;
    Objs(i, :) = fitness;
end
Cons = zeros(size(angles_var, 1), 1);
end

function [joint_xy] = fw_kinematics(p, lengths)
mat = eye(4);
p = [p, 0];
n_dofs = length(p);
joint_xy = zeros(1, 2);
lengths = [0, lengths];
for i = 1:n_dofs
    m = [cos(p(i)), -sin(p(i)), 0, lengths(i);
        sin(p(i)), cos(p(i)), 0, 0;
        0, 0, 1, 0;
        0, 0, 0, 1; ];
    mat = mat * m;
    v = mat * ([0, 0, 0, 1]');
    joint_xy = v';
end
joint_xy = joint_xy(1:2);
end
