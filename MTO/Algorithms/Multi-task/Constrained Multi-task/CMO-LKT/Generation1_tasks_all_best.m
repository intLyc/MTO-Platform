function offspring1 = Generation1_tasks_all_best(obj, Niche1, Niche2, best_N1, best_N2, population1, population2, epsilon1, epsilon2, alpha2)
offspring1 = [];

for n = 1:size(Niche1, 1)
    gailv1 = rand;
    for i = 1:size(Niche1, 2)
        off_Niche1(i) = Niche1(n, i);
        A = randperm(size(Niche1, 2), 6);
        A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4); x5 = A(5);
        % x_2= randperm(length(population2), 1);%学习对方全局随机
        x_2 = randperm(size(Niche2, 2), 1); %学习对方有用的小生境随机

        conn1 = [population1.CV];
        objF1 = [population1.Obj];

        conn2 = [population2.CV];
        objF2 = [population2.Obj];

        if isempty(find([Niche1(n, :).CV] <= epsilon1))
            [~, best3] = min([Niche1(n, :).CV]);
        else
            index = find([Niche1(n, :).CV] <= epsilon1);
            [~, r] = min([Niche1(n, index).Obj]);
            best3 = index(r);
        end

        if isempty(find(conn2 <= epsilon2))
            [~, best2] = min(conn2);
        else
            index = find(conn2 <= epsilon2);
            [~, r] = min(objF2(index));
            best2 = index(r);
        end

        %% 直接迁移
        if alpha2(n) >= 1 %这个小生境的信息全部赋给另一个任务，与距离这个pbest最近的另一任务的pbest所在小圣境比较
            if gailv1 < 0.5
                off_Niche1(i).Dec = Niche2(n, i).Dec;
            else
                if rand < 0
                    off_Niche1(i).Dec = Niche1(n, i).Dec + rand * (Niche2(n, x_2).Dec - Niche1(n, i).Dec) + ...
                        obj.F(randperm(3, 1)) * (Niche1(n, x2).Dec - Niche1(n, x3).Dec);
                else %学习另一个任务最好的
                    off_Niche1(i).Dec = Niche1(n, x1).Dec + obj.F(randperm(3, 1)) * (best_N2(n).Dec - Niche1(n, x1).Dec) + ...
                        obj.F(randperm(3, 1)) * (Niche1(n, x2).Dec - Niche1(n, x3).Dec);
                    off_Niche1(i).Dec = DE_Crossover(off_Niche1(i).Dec, Niche1(n, i).Dec, obj.CR(randperm(3, 1)));
                end
            end
        else
            if rand < 0 %随机学习自己的信息
                if n == 1
                    linshi = [size(Niche1, 1) 1 2];
                elseif n == size(Niche1, 1)
                    linshi = [size(Niche1, 1) - 1 size(Niche1, 1) 1];
                else
                    linshi = [n - 1 n n + 1];
                end
                nn = linshi(randperm(3, 1));
                off_Niche1(i).Dec = Niche1(n, i).Dec + rand * (Niche1(nn, x1).Dec - Niche1(n, i).Dec) + ...
                    obj.F(randperm(3, 1)) * (Niche1(n, x2).Dec - Niche1(n, x3).Dec);
            else %学习自己最好的

                if n == 1
                    best_lin = [size(Niche1, 1) 1 2];
                elseif n == size(Niche1, 1)
                    best_lin = [size(Niche1, 1) - 1 size(Niche1, 1) 1];
                else
                    best_lin = [n - 1 n n + 1];
                end
                best_linyu = best_lin(randperm(3, 1));
                off_Niche1(i).Dec = Niche1(n, x1).Dec + obj.F(randperm(3, 1)) * (best_N1(best_linyu).Dec - Niche1(n, x1).Dec) + ...
                    obj.F(randperm(3, 1)) * (Niche1(n, x2).Dec - Niche1(n, x4).Dec);
                off_Niche1(i).Dec = DE_Crossover(off_Niche1(i).Dec, Niche1(n, i).Dec, obj.CR(randperm(3, 1)));

            end

        end

        off_Niche1(i).Dec(off_Niche1(i).Dec > 1) = 1;
        off_Niche1(i).Dec(off_Niche1(i).Dec < 0) = 0;
    end
    offspring1 = [offspring1 off_Niche1];
end

end

%% 之前的
%     if alpha1(n) >= 1
%     if rand < 0.5 %随机学习另一个任务
%         off_Niche1(i).Dec = Niche1(n,i).Dec+rand*(population2(x_2).Dec-Niche1(n,i).Dec)+...
%                                 obj.F(randperm(3,1))*(Niche1(n,x2).Dec-Niche1(n,x3).Dec);
%     else %学习另一个任务最好的
%         off_Niche1(i).Dec = Niche1(n,x1).Dec+obj.F(randperm(3,1))*(best_N2(rrr).Dec-Niche1(n,x1).Dec)+...
%                         obj.F(randperm(3,1))*(Niche1(n,x2).Dec-Niche1(n,x3).Dec);
%         off_Niche1(i).Dec = DE_Crossover(off_Niche1(i).Dec, Niche1(n,i).Dec, obj.CR(randperm(3,1)));
%     end
% else %学习自己
%     if rand < 0.5 %随机学习自己的信息
%         if n==1
%             linshi = [5 1 2];
%         elseif n==5
%             linshi = [4 5 1];
%         else
%             linshi = [n-1 n n+1];
%         end
%         nn=linshi(randperm(3,1));
%         off_Niche1(i).Dec = Niche1(n,i).Dec+rand*(Niche1(nn,x1).Dec-Niche1(n,i).Dec)+...
%                                 obj.F(randperm(3,1))*(Niche1(n,x2).Dec-Niche1(n,x3).Dec);
%     else %学习自己最好的
%
%         if n==1
%             best_lin = [5 1 2];
%         elseif n==5
%             best_lin = [4 5 1];
%         else
%             best_lin = [n-1 n n+1];
%         end
%         best_linyu = best_lin(randperm(3,1));
%         off_Niche1(i).Dec = Niche1(n,x1).Dec+obj.F(randperm(3,1))*(best_N1(best_linyu).Dec-Niche1(n,x1).Dec)+...
%                             obj.F(randperm(3,1))*(Niche1(n,x2).Dec-Niche1(n,x4).Dec);
%         off_Niche1(i).Dec = DE_Crossover(off_Niche1(i).Dec, Niche1(n,i).Dec, obj.CR(randperm(3,1)));
%     end
% end
%
% off_Niche1(i).Dec(off_Niche1(i).Dec > 1) = 1;
% off_Niche1(i).Dec(off_Niche1(i).Dec < 0) = 0;
%             end
%             offspring1 = [offspring1 off_Niche1];
%           end
%
%         end
