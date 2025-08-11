function result = parRun(Algo, Prob, se)
Prob.setTasks();
Algo.reset();
if se ~= -1
    rng(se);
end
Algo.run(Prob)
result = Algo.getResult(Prob);
end
