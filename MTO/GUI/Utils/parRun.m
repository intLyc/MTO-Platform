function result = parRun(Algo, Prob)
Prob.setTasks();
Algo.reset();
Algo.run(Prob)
result = Algo.getResult(Prob);
end
