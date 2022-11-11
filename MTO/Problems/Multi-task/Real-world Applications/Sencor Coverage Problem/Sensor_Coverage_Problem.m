classdef Sensor_Coverage_Problem < Problem
    % <Multi-task> <Single-objective> <None/Competitive>

    %------------------------------- Reference --------------------------------
    % Reference 1
    % @Article{Ryerkerk2017VLP,
    %   title      = {Solving Metameric Variable-length Optimization Problems Using Genetic Algorithms},
    %   author     = {Ryerkerk, Matthew L and Averill, Ronald C and Deb, Kalyanmoy and Goodman, Erik D},
    %   journal    = {Genetic Programming and Evolvable Machines},
    %   year       = {2017},
    %   number     = {2},
    %   pages      = {247--277},
    %   volume     = {18},
    %   publisher  = {Springer},
    % }
    % Reference 2
    % @Article{Li2022CompetitiveMTO,
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties
        Nmin = 25
        Nmax = 35
    end

    methods
        function obj = Sensor_Coverage_Problem(name)
            obj = obj@Problem(name);
            obj.maxFE = 1000 * 50 * (obj.Nmax - obj.Nmin + 1);
        end

        function parameter = getParameter(obj)
            parameter = {'Nmin', num2str(obj.Nmin), ...
                        'Nmax', num2str(obj.Nmax)};
            parameter = [obj.getRunParameter(), parameter];
        end

        function obj = setParameter(obj, Parameter)
            nmin = str2double(Parameter{3});
            nmax = str2double(Parameter{4});
            if obj.Nmin == nmin && obj.Nmax == nmax
                obj.setRunParameter(Parameter(1:2));
            else
                obj.Nmin = nmin; obj.Nmax = nmax;
                obj.maxFE = 1000 * 50 * (obj.Nmax - obj.Nmin + 1);
                obj.setRunParameter({Parameter{1}, num2str(obj.maxFE)});
            end
        end

        function setTasks(obj)
            Tasks = benchmark_SCP(obj.Nmin, obj.Nmax);
            obj.T = length(Tasks);
            for t = 1:obj.T
                obj.D(t) = Tasks(t).Dim;
                obj.Fnc{t} = Tasks(t).Fnc;
                obj.Lb{t} = Tasks(t).Lb;
                obj.Ub{t} = Tasks(t).Ub;
            end
        end
    end
end
