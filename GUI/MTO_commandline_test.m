addpath(genpath('./GUI/'));
reps = 1;
algo_cell = {'GA', 'MFEA'};
prob_cell = {'MTSO1_CI_HS', 'MTSO2_CI_MS'};

data_save = MTO_commandline(algo_cell, prob_cell, reps);
save('data_save', 'data_save')
