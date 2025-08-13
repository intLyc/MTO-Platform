function [ShiftVector, RotationMatrix] = readData_WCCI20_MaTMO(problem, tasks_num)
current_dir = fileparts(mfilename('fullpath'));
file_dir = fullfile(current_dir, strcat("/MData/benchmark_", string(problem)));

ShiftVector = {};
RotationMatrix = {};
for task_id = 1:tasks_num
    shift_file = strcat("/bias_", string(task_id));
    rotation_file = strcat("/matrix_", string(task_id));
    RotationMatrix{task_id} = load(strcat(file_dir, rotation_file), '-ascii');
    ShiftVector{task_id} = load(strcat(file_dir, shift_file), '-ascii');
end
end
