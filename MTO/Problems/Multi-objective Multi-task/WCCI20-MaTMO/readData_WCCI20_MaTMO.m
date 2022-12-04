function [ShiftVector, RotationMatrix] = readData_WCCI20_MaTMO(problem, tasks_num)
    file_dir = strcat("./Problems/Multi-objective Multi-task/WCCI20-MaTMO/MData/benchmark_", string(problem));
    ShiftVector = {};
    RotationMatrix = {};
    for task_id = 1:tasks_num
        shift_file = strcat("/bias_", string(task_id));
        rotation_file = strcat("/matrix_", string(task_id));
        RotationMatrix{task_id} = load(strcat(file_dir, rotation_file));
        ShiftVector{task_id} = load(strcat(file_dir, shift_file));
    end
end
