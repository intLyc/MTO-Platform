classdef Chromosome_MFEA_AKT
    properties
        rnvec; % (genotype)--> decode to find design variables --> (phenotype)
        factorial_costs;
        factorial_ranks;
        scalar_fitness;
        skill_factor;
        cx_factor;
        isTran;
        parNum;
    end

    methods
        function object = initialize(object, D)
            object.rnvec = rand(1, D);
            object.isTran = 0;
            object.cx_factor = randi(6);
            object.parNum = 0;
        end

        function [object, calls] = evaluate(object, Tasks, p_il, no_of_tasks, options)
            if object.skill_factor == 0
                calls = 0;
                for i = 1:no_of_tasks
                    [object.factorial_costs(i), xxx, funcCount] = fnceval(Tasks(i), object.rnvec, p_il, options);
                    calls = calls + funcCount;
                end
            else
                object.factorial_costs(1:no_of_tasks) = inf;
                for i = 1:no_of_tasks
                    if object.skill_factor == i
                        [object.factorial_costs(object.skill_factor), object.rnvec, funcCount] = fnceval(Tasks(object.skill_factor), object.rnvec, p_il, options);
                        calls = funcCount;
                        break;
                    end
                end
            end
        end

        % SBX
        function object = crossover(object, p1, p2, cf)
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        %Simple crossover
        function object = spcrossover(object, p1, p2)
            r = randi([1, length(p1.rnvec)], 1, 1);
            t1 = p1.rnvec(1:r - 1);
            t2 = p2.rnvec(r:end);
            object.rnvec = [t1 t2];

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;

            %test
            %disp(['Simple crossover: ',num2str(r)]);
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        %Twopoint crossover
        function object = tpcrossover(object, p1, p2)
            i = randi([1, length(p1.rnvec)], 1, 1);
            j = randi([1, length(p1.rnvec)], 1, 1);
            if i > j
                t = i; i = j; j = t;
            end
            t1 = p1.rnvec(1:i - 1);
            t2 = p2.rnvec(i:j);
            t3 = p1.rnvec(j + 1:end);
            object.rnvec = [t1 t2 t3];

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;

            %test
            %disp(['Twopoint crossover: ',num2str(i),' ',num2str(j)]);
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        %Uniform crossover
        function object = ufcrossover(object, p1, p2)
            i = 1;
            while i <= length(p1.rnvec)
                u = randi([0, 1], 1, 1);
                if u == 0
                    object.rnvec(i) = p1.rnvec(i);
                else
                    object.rnvec(i) = p2.rnvec(i);
                end
                %disp(num2str(u));
                i = i + 1;
            end

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
            %test
            %disp('Uniform crossover: ');
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        function object = newcrossover(object, p1, p2, alpha)

            i = 1; len = length(p1.rnvec);
            r = 0.25;
            %r=rand(1,len);
            while i <= len
                if p1.rnvec(i) < p2.rnvec(i)
                    cmin = p1.rnvec(i);
                    cmax = p2.rnvec(i);
                else
                    cmin = p2.rnvec(i);
                    cmax = p1.rnvec(i);
                end

                if cmax - r * p1.rnvec(i) + (1 - r) * p2.rnvec(i) > r * p1.rnvec(i) + (1 - r) * p2.rnvec(i) - cmin
                    segValue = r * p1.rnvec(i) + (1 - r) * p2.rnvec(i) - cmin;
                else
                    segValue = cmax - r * p1.rnvec(i) + (1 - r) * p2.rnvec(i);
                end

                object.rnvec(i) = ((2 * rand() - 1) * alpha) * segValue + (r * p1.rnvec(i) + (1 - r) * p2.rnvec(i));
                %object.rnvec(i)=normrnd(r*p1.rnvec(i)+(1-r)*p2.rnvec(i),10);
                i = i + 1;
            end

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;

        end

        function object = hyberCX(object, p1, p2, cf, alpha)
            switch alpha
                case 1
                    object = tpcrossover(object, p1, p2);
                case 2
                    object = ufcrossover(object, p1, p2);
                case 3
                    object = aricrossover(object, p1, p2);
                case 4
                    object = geocrossover(object, p1, p2);
                case 5
                    a = 0.3;
                    object = blxacrossover(object, p1, p2, a);
                case 6
                    object = crossover(object, p1, p2, cf);
            end
        end

        %Arithmetical crossover
        function object = aricrossover(object, p1, p2)
            i = 1; len = length(p1.rnvec);
            r = 0.25;
            %r=rand(1,len);
            while i <= len
                object.rnvec(i) = r * p1.rnvec(i) + (1 - r) * p2.rnvec(i);
                i = i + 1;
            end

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;

        end

        %Geometric crossover
        function object = geocrossover(object, p1, p2)
            i = 1; len = length(p1.rnvec);
            r = 0.2;
            while i <= len
                object.rnvec(i) = p1.rnvec(i)^r * p2.rnvec(i)^(1 - r);
                i = i + 1;
            end
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        %BLX-a crossover
        function object = blxacrossover(object, p1, p2, a)
            i = 1; len = length(p1.rnvec);
            while i <= len
                if p1.rnvec(i) < p2.rnvec(i)
                    Cmin = p1.rnvec(i);
                    Cmax = p2.rnvec(i);
                else
                    Cmin = p2.rnvec(i);
                    Cmax = p1.rnvec(i);
                end
                I = Cmax - Cmin;
                object.rnvec(i) = (Cmin - I * a) + (I + 2 * I * a) * rand(1, 1);
                %object.rnvec(i)=(Cmin-I*a(i))+(I+2*I*a(i))*rand(1,1);
                i = i + 1;
            end

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
            %test
            %disp('BLX-a crossover: ');
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        %BLX-b crossover
        function object = blxbcrossover(object, p1, p2, a, b)
            i = 1; len = length(p1.rnvec);
            while i <= len
                if p1.rnvec(i) < p2.rnvec(i)
                    Cmin = p1.rnvec(i);
                    Cmax = p2.rnvec(i);
                else
                    Cmin = p2.rnvec(i);
                    Cmax = p1.rnvec(i);
                end
                I = Cmax - Cmin;
                object.rnvec(i) = (Cmin - I * a(i)) + (I + I * a(i) + I * b(i)) * rand(1, 1);
                i = i + 1;
            end
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
            %test
            %disp('BLX-b crossover: ');
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        %Heuristic crossover
        function object = heucrossover(object, p1, p2)
            u = rand(1, 1);
            if p1.scalar_fitness > p2.scalar_fitness
                f1 = p1.rnvec;
                f2 = p2.rnvec;
            else
                f1 = p2.rnvec;
                f2 = p1.rnvec;
            end
            object.rnvec = u * (f1 - f2) + f1;
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;

            %test
            %disp('BLX-a crossover: ');
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        %Simulated binary crossover
        function object = sbcrossover(object, p1, p2, y)
            i = 1; len = length(p1.rnvec);
            while i <= len
                u = rand(1, 1);
                if u < 1/2
                    b = (2 * u)^(1 / (y + 1));
                else
                    b = (2 * (1 - u))^(1 / (y + 1));
                end
                f1 = @(t) 1/2 * (y + 1) * t^(y + 2);
                f2 = @(t) 1/2 * (y + 1) * (1 / t^(y + 2));
                bk = f1(b) .* (0 <= b && b <= 1) + f2(b) .* (b > 1); %根据公式计算概率密度
                object.rnvec(i) = 1/2 * ((1 - bk) * p1.rnvec(i) + (1 + bk) * p2.rnvec(i));
                i = i + 1;
            end
            %test
            %disp('BLX-a crossover: ');
            %p1.rnvec
            %p2.rnvec
            %object.rnvec
        end

        function object = flowcrossover(object, p1, p2)
            len = length(p2.rnvec);
            left = randi([1, len]);
            right = randi([1, len]);

            if right < left
                tmp = left;
                left = right;
                right = tmp;
            end

            object.rnvec = p1.rnvec;

            position = randi([1, len - right + left]);
            object.rnvec(position:position + right - left) = p2.rnvec(left:right);

            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        % polynomial mutation
        function object = mutate(object, p, dim, mum)
            rnvec_temp = p.rnvec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        rnvec_temp(i) = p.rnvec(i) + del * (p.rnvec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        rnvec_temp(i) = p.rnvec(i) + del * (1 - p.rnvec(i));
                    end
                end
            end
            object.rnvec = rnvec_temp;
        end
    end
end
