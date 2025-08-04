function [problem,lb,ub,D,fn,k]=dataload(i)
    testname={'cassini1','cassini2','gtoc1','rosetta','sagas','messenger','messengerfull'};
    problem=load([testname{i} '.mat']);
    k=zeros(1,2);
    if i==1 || i==3
        lb=problem.MGAproblem.bounds.lower;
        ub=problem.MGAproblem.bounds.upper;
    else
        lb=problem.MGADSMproblem.bounds.lower;
        ub=problem.MGADSMproblem.bounds.upper;
    end
    D = numel(lb);
    if i==1
        k(1)=0;k(2)=0.4;
        fn=@cassini1;
    elseif i==2
        k(1)=0.9;k(2)=1;
        fn=@cassini2;  
    elseif i==3
        k(1)=0.1;k(2)=0.6;
        fn=@gtoc1;
    elseif i==4
        k(1)=0.2;k(2)=1;
        fn=@rosetta;
    elseif i==5
        k(1)=0.4;k(2)=0;
        fn=@sagas;    
    elseif i==6
        k(1)=0.1;k(2)=0;
        fn=@messenger;
    elseif i==7
        k(1)=0.4;k(2)=0;
        fn=@messengerfull;
    end    
end
