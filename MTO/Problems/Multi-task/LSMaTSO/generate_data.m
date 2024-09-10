function generate_data()

%------------------------------- Reference --------------------------------
% @Article{Li2024TNG-NES,
%   title    = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
%   author   = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

task_num = 50;
dim = 300;
m = 50;

file_name = './Problems/Multi-task/LSMaTSO/';

mkdir([file_name, 'Data/']);
for index = 1:5
    switch index
        case 1
            % [1, 2, 3]
            LSMaTSO_Data.Shift = 0.2 + 0.6 * rand(task_num, dim);
            LSMaTSO_Data.Scale = rand(task_num, dim);
            LSMaTSO_Data.Rotation = [];
            LSMaTSO_Data.Group = [];

        case 2
            % [1, 2, 3, 4, 5, 6, 7, 8]
            LSMaTSO_Data.Shift = 0.2 + 0.6 * rand(task_num, dim);
            LSMaTSO_Data.Scale = rand(task_num, dim);
            LSMaTSO_Data.Rotation = [];
            LSMaTSO_Data.Group = [];
            for t = 1:task_num
                if mod(t - 1, 8) + 1 <= 3
                    LSMaTSO_Data.Rotation(t, :, :) = diag(ones(1, m));
                else
                    LSMaTSO_Data.Rotation(t, :, :) = createRotation(m);
                end
                LSMaTSO_Data.Group(t, :) = randperm(dim);
            end

        case 3
            % [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
            LSMaTSO_Data.Shift = 0.2 + 0.6 * rand(task_num, dim);
            LSMaTSO_Data.Scale = rand(task_num, dim);
            LSMaTSO_Data.Rotation = [];
            LSMaTSO_Data.Group = [];
            for t = 1:task_num
                LSMaTSO_Data.Rotation(t, :, :) = createRotation(m);
                LSMaTSO_Data.Group(t, :) = randperm(dim);
            end

        case 4
            % [9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
            LSMaTSO_Data.Shift = 0.2 + 0.6 * rand(task_num, dim);
            LSMaTSO_Data.Scale = rand(task_num, dim);
            LSMaTSO_Data.Rotation = [];
            LSMaTSO_Data.Group = [];
            for t = 1:task_num
                LSMaTSO_Data.Rotation(t, :, :) = createRotation(m);
                LSMaTSO_Data.Group(t, :) = randperm(dim);
            end

        case 5
            % [14, 15, 16, 17, 18, 19, 20]
            LSMaTSO_Data.Shift = 0.2 + 0.6 * rand(task_num, dim);
            LSMaTSO_Data.Scale = rand(task_num, dim);
            LSMaTSO_Data.Rotation = [];
            LSMaTSO_Data.Group = [];
            for t = 1:task_num
                if mod(t - 1, 7) + 1 >= 6
                    LSMaTSO_Data.Rotation(t, :, :) = diag(ones(1, m));
                else
                    LSMaTSO_Data.Rotation(t, :, :) = createRotation(m);
                end
                LSMaTSO_Data.Rotation(t, :, :) = createRotation(m);
                LSMaTSO_Data.Group(t, :) = randperm(dim);
            end
    end

    save([file_name, 'Data/LSMaTSO_Data', num2str(index)], 'LSMaTSO_Data');
end
end

function matrix_rot = createRotation(dim)
while 1
    matrix_rot = randn(dim, dim);
    for i = 1:dim
        flag = 0;
        for j = 1:i - 1
            % dot product
            dp = sum(matrix_rot(i, :) .* matrix_rot(j, :));
            % subtract
            matrix_rot(i, :) = matrix_rot(i, :) - dp * matrix_rot(j, :);
        end

        % normalize
        dp = sum(matrix_rot(i, :).^2);

        % linear dependency -> restart
        if dp <= 0
            flag = 1;
            break;
        end

        matrix_rot(i, :) = matrix_rot(i, :) / sqrt(dp);
    end
    if flag == 1
        break;
    end
    return
end
end
