classdef MPEFSHADE < Algorithm
    % @InProceedings{2020LiMPEFSHADE,
    %   author     = {Li Genghui  and Lin Qiuzhen  and Gao Weifeng.},
    %   booktitle  = {2020 Information Science},
    %   title      = {Multifactorial optimization via explicit multipopulation evolutionary framework},
    %   year       = {2020},
    %   pages      = {1555-1570},
    %   doi        = {},
    % }
    properties (SetAccess = private)
        H=100;
        c=0.3;
        p=0.1;
    end
     methods
        function parameter = getParameter(obj)
            parameter = {'c:life span of uF and uCR ', num2str(obj.c), ...
                         'p: 100p% top as pbest', num2str(obj.p), ...
                         'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.c = str2double(parameter_cell{count}); count = count + 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
        end
         function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            data.convergence = [];
            data.bestX = {};
            SR=[]; % success rate 
            rmp=[];
            tic
            sub_pop = round(pop_size / length(Tasks));
            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);
                % initialize
               [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
               data.convergence(:, 1) = bestobj;
               [bestobj, idx] = min([population.factorial_costs]);
               bestX = population(idx).rnvec;
               convergence(1) = bestobj;

               generation = 1;
               
               % initialize parameter
               H_idx = 1;
               MF = 0.5 .* ones(obj.H, 1);
               MCR = 0.5 .* ones(obj.H, 1);
               SR(generation)=1;
               rmp(generation)=0.5;% the initial random mating probability  
               Flag=zeros(1,pop);
               
               while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;    
                    % calculate individual F and pCR
                    for i = 1:length(population)
                        idx = randi(obj.H);
                        uF = MF(idx);
                        population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population(i).F <= 0)
                            population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        population(i).F(population(i).F > 1) = 1;

                        uCR = MCR(idx);
                        population(i).pCR = normrnd(uCR, 0.1);
                        population(i).pCR(population(i).pCR > 1) = 1;
                        population(i).pCR(population(i).pCR < 0) = 0;
                    end
                    % generation
                    [offspring, calls] = OperatorMPEFSHADE.generate(1, population, Tasks, obj.rmp, obj.F, obj.pCR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.factorial_costs] > [offspring.factorial_costs];
                    count=0;%record the number of the successful update;
                    ccount=sum(Flag);
                    sccount=0;
        
                    % calculate SF SCR 
                    SF = [population(replace).F];
                    SCR =[population(replace).pCR];
                    dif = abs([population(replace).factorial_costs] - [offspring(replace).factorial_costs]);
                    dif = dif ./ sum(dif);
                    %.....¼ÆËã´æ»îÂÊ...?
                    
                    %update rmp
                    if SR(generation+1)>=1/5
                         rmp(generation+1)=rmp(generation);
                    else
                         if ccount==0
                            rmp(generation+1)=min(rmp(generation)+c*(1-SR(generation)),1);                   
                         else
                            if (sccount/ccount)>SR(generation+1);
                               rmp(generation+1)=min(rmp(generation)+c*sccount/ccount,1);
                            else
                              rmp(generation+1)=max(rmp(generation)-c*(1-sccount/ccount),0);                        
                            end
                         end
                    end
                    
                    % update MF MCR
                    if ~isempty(SF)
                        MF(H_idx) = (dif * (SF'.^2)) / (dif * SF');
                        MCR(H_idx) = (dif * (SCR'.^2)) / (dif * SCR');
                    else
                        MF(H_idx) = MF(mod(H_idx + obj.H - 2, obj.H) + 1);
                        MCR(H_idx) = MCR(mod(H_idx + obj.H - 2, obj.H) + 1);
                    end
                    H_idx = mod(H_idx, obj.H) + 1;

                    population(replace) = offspring(replace);
                    [bestobj_now, idx] = min([population.factorial_costs]);
                    if bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestX = offspring(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
                    
            