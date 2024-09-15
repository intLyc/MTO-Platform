function [Tasks] = benchmark_CEC21_MTMO(prob_idx)

root_dir = './Problems/Multi-objective Multi-task/CEC21-MTMO-CPLX/';
file_dir = [root_dir, 'MData/benchmark_', num2str(prob_idx)];
switch prob_idx
    case 1
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).gType = 'F17';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F17';
        Tasks(2).hType = 'concave';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 2
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F19';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMDTLZ';
        Tasks(2).f1Type = '';
        Tasks(2).hType = '';
        Tasks(2).gType = 'F19';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 3
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F22';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F22';
        Tasks(2).hType = 'convex';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 4
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMZDT';
        Tasks(1).f1Type = 'linear';
        Tasks(1).gType = 'F15';
        Tasks(1).hType = 'convex';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F15';
        Tasks(2).hType = 'convex';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 5
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F4';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F4';
        Tasks(2).hType = 'concave';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 6
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F9';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMDTLZ';
        Tasks(2).f1Type = '';
        Tasks(2).hType = '';
        Tasks(2).gType = 'F9';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 7
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F8';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F8';
        Tasks(2).hType = 'convex';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 8
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F18';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F20';
        Tasks(2).hType = 'concave';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 9
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F11';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F18';
        Tasks(2).hType = 'concave';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
    case 10
        dim = 50;
        %Task 1
        shift_file = strcat("/bias_", string(1));
        rotation_file = strcat("/matrix_", string(1));
        Tasks(1).rotation = load(strcat(file_dir, rotation_file));
        Tasks(1).shift = load(strcat(file_dir, shift_file));
        Tasks(1).tType = 'MMDTLZ';
        Tasks(1).f1Type = '';
        Tasks(1).hType = '';
        Tasks(1).gType = 'F15';
        Tasks(1).boundaryCvDv = 1;
        Tasks(1).dim = dim;

        %Task 2
        shift_file = strcat("/bias_", string(2));
        rotation_file = strcat("/matrix_", string(2));
        Tasks(2).rotation = load(strcat(file_dir, rotation_file));
        Tasks(2).shift = load(strcat(file_dir, shift_file));
        Tasks(2).tType = 'MMZDT';
        Tasks(2).f1Type = 'linear';
        Tasks(2).gType = 'F17';
        Tasks(2).hType = 'concave';
        Tasks(2).boundaryCvDv = 1;
        Tasks(2).dim = dim;

        Lb = -100 .* ones(1, 49);
        Ub = 100 .* ones(1, 49);
        Tasks(1).Lb = [0, Lb];
        Tasks(1).Ub = [1, Ub];
        Tasks(2).Lb = [0, Lb];
        Tasks(2).Ub = [1, Ub];
end
end
