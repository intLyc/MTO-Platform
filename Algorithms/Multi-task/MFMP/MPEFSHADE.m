%authot ligenghui  11 january 2018
%multipopulation for multitasking optimization

clc;
clear;
format short e
popsize=200; %all population size
totaltimes=20; % the total number of runs
gen=500; % the total number of generation
H=100;
c=0.3;
for problem=1:9 %for each multitasking optimization problem
    problem   
    Outcome=[];
    for time=1:totaltimes% for each run
        Tasks = benchmark(problem);% get the details information of the multitask problem
        K=max(size(Tasks)); % the number of the tasks
        Dmax=max(Tasks.dims); % the maximum dimension of all tasks
        pop=popsize/K; % the population size of each task
        
        g=1;  % generation number
        rand('seed', sum(rand*clock));  % Random seed
        
        P=[]; % population
        SR=[]; % success rate 
        for k=1:K              
            P{k}=0.0+1.0*rand(pop,Dmax);% generate the initial population for each task in the unified space [0, 1];           
            SR(k,g)=1; % the initial success rate of each population
            rmp(k,g)=0.5;% the initial random mating probability 
            % the initial random mating probability          
        end
        
        %****calculate the objective value of each individul in each population
        for k=1:K
            for i=1:pop
                temp=P{k};
                fit(i,k)=Tasks(k).fnc(Tasks(k).Lb+temp(i,1:Tasks(k).dims).*(Tasks(k).Ub-Tasks(k).Lb));
            end
        end
        %**********************************************************
        
        %******initialize the parameter historial memory
        for k=1:2
            Fm{k}=0.5*ones(1,H);
            CRm{k}=0.5*ones(1,H);
            Arc{k}=[];%external archive 
            Hindex(k)=1; %denote whhic item in the memory should be update
        end       
        %**********************************************
        
                  
        %record the best objective value found so far;
        BestFitness=min(fit);
        BestFitness_T1(time,g)=BestFitness(1); %record the best solution in each generation for T1
        BestFitness_T2(time,g)=BestFitness(2); %record the best solution in each generation for T2
        
        while g<gen
            
            [~,sortindex]=sort(fit);%sort the population on each task                                
            %update the random mating probability                                  
            for k=1:K              
                temp=P{k};
                tempFm=Fm{k}; % the historial memory of scale factor Fm
                tempCRm=CRm{k}; % the historial memory of corssover rate CRm
                F=zeros(1,pop); % save the scale factor of the current population
                CR=zeros(1,pop); % save the crosover rate of the current population
                
                rpbestid=randi([1,floor((2/pop+(0.2-2/pop)*rand)*pop)],1,pop);
                pbestid=sortindex(rpbestid,k);
                rH=randi([1,H],1,pop); % randomly choose the index in the historical memory 
                
                A=Arc{k};%the current archive 
                LA=size(A,1);%the size of the archive
                Union=[temp;A];%the union of the population and the archive 
                
                TasksIndex=[1:K];% the index of all tasks
                TasksIndex(k)=[];% delete the current task index                        
                cTaskIndex=TasksIndex(randi([1,length(TasksIndex)],1)); %randomly choose an task to communicate 
                ctemp=P{cTaskIndex};% the population associated with the communication tast 
                cUnion=[ctemp;Arc{cTaskIndex}]; % the external archive of the communication task 
                LcA=size(Arc{cTaskIndex},1); 
                                                                 
                V=[];%trial population
                Flag=zeros(1,pop);%  
                for i=1:pop
                    
                    [F(i),CR(i)] = randFCR(1, tempCRm(rH(i)), 0.1, tempFm(rH(i)), 0.1);                  
                   
                    %*******mutation***************************  
                    if rand<rmp(k,g)                       
                       r1=randi([1,pop],1); 
                       while r1==i
                             r1=randi([1,pop],1);
                       end                    
                       r2=randi([1,pop+LcA],1);                                             
                       v=temp(i,:)+F(i)*(ctemp(pbestid(i),:)-temp(i,:))+F(i)*(ctemp(r1,:)-cUnion(r2,:));
                       Flag(i)=1; % the ith  individual use information communication
                    else
                        r1=randi([1,pop],1);                     
                        while r1==i
                            r1=randi([1,pop],1);
                        end                    
                        r2=randi([1,pop+LA],1);                        
                        v=temp(i,:)+F(i)*(temp(pbestid(i),:)-temp(i,:))+F(i)*(temp(r1,:)-Union(r2,:));
                        %
                    end
                    %******************************************
                                                                                                             
                    %reset the vabiables which violate the box constraints                   
                    vioLowIndex=find(v<0);
                    v(vioLowIndex)=(temp(i,vioLowIndex)+0.0)/2;
                    vioUpIndex=find(v>1);
                    v(vioUpIndex)=(temp(i,vioUpIndex)+1.0)/2;
                    
                    %crossover *********************************
                    j_rand = floor(rand * Dmax) + 1;
                    t = rand(1, Dmax) < CR(i);                   
                    t(1, j_rand) = 1;
                    t_ = 1 - t;
                    V(i,:) = t .* v + t_ .* temp(i, :);
                    %********************************************
                    
                    % evaluate the offspring
                    fitV(i)=Tasks(k).fnc(Tasks(k).Lb+V(i,1:Tasks(k).dims).*(Tasks(k).Ub-Tasks(k).Lb));
                end
                
                %selection
                SF=[]; SCR=[]; % save the successful scale factor F and crossover rate CR
                DeltFit=[];%save the improvement;
                count=0;%record the number of the successful update;
                
                ccount=sum(Flag);
                sccount=0;
                for i=1:pop
                    if fitV(i)<fit(i,k)
                        SF=[SF,F(i)];
                        SCR=[SCR,CR(i)];
                        deltfit=abs(fitV(i)-fit(i,k));
                        DeltFit=[DeltFit,deltfit];
                        A=[A;temp(i,:)];
                    end
                    if fitV(i)<=fit(i,k)
                        fit(i,k)=fitV(i);
                        temp(i,:)=V(i,:);
                        count=count+1;
                        if Flag(i)==1
                            sccount=sccount+1;
                        end
                    end
                end
                             
                SR(k,g+1)=count/pop;
                if SR(k,g+1)>=1/5
                   rmp(k,g+1)=rmp(k,g);
                else
                   if ccount==0
                      rmp(k,g+1)=min(rmp(k,g)+c*(1-SR(k,g+1)),1);                   
                   else
                      if (sccount/ccount)>SR(k,g+1);
                       rmp(k,g+1)=min(rmp(k,g)+c*sccount/ccount,1);
                      
                      else
                         rmp(k,g+1)=max(rmp(k,g)-c*(1-sccount/ccount),0);                        
                      end
                   end
                end
              
                %update historial parameter memory
                if  ~isempty(SF) && ~isempty(SCR)
                    W=DeltFit./(sum(DeltFit));% weight
                    tempFm(Hindex(k))=sum(W.*(SF.^2))/sum(W.*SF);           
                    tempCRm(Hindex(k))=sum(W.*SCR);                   
                end
                Hindex(k)=Hindex(k)+1;
                if Hindex(k)>H
                    Hindex(k)=1;
                end
                
                 %************update the archvie 
                LA=size(A,1);
                if LA>pop
                   Rnd=randperm(LA);
                   A(Rnd(1:LA-pop),:)=[];
                end
                %**************************
                
                P{k}=temp; %update populatiom
                Fm{k}=tempFm;%update history 
                CRm{k}=tempCRm;
                Arc{k}=A;
            end
            g=g+1;
            BestFitness=min(fit);
            BestFitness_T1(time,g)=BestFitness(1); %record the best solution in each generation
            BestFitness_T2(time,g)=BestFitness(2);
        end
        Outcome(time,:)=min(fit)
    end
    mean(Outcome)
    RMP{problem}=rmp;
    MPEFSHADEOutcome{problem}=Outcome;
    MPEFSHADEBestFitness_T1{problem}=BestFitness_T1;
    MPEFSHADEBestFitness_T2{problem}=BestFitness_T2;
end



% figure('color',[1,1,1]);
% plot(rmp(1,:),'r-');
% hold on
% plot(rmp(2,:),'b-');
% legend('Task1','Task2')
% axis([0,500,0,1])
