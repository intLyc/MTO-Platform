function result = parRun(Algo, Prob, se)
if se ~= -1
    rng(se);
end
Prob.setTasks();
Algo.reset();
Algo.run(Prob);
result = Algo.getResult(Prob);
end
