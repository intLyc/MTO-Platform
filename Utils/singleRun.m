function data = singleRun(algo_obj, prob_obj, pre_run_list)
    data = algo_obj.run(prob_obj.getTasks(), pre_run_list);
end
