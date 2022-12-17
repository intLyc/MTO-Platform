function [ShiftVector, RotationMatrix] = readData_CEC19_MaTMO(problem, tasks_num)
file_dir = './Problems/Multi-objective Multi-task/CEC19-MaTMO/';
ShiftVector = {};
RotationMatrix = {};
for i = 1:tasks_num
    switch problem
        case 1
            ShiftVectorName = [file_dir, 'SVector/S1/S1_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M1/M1_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
        case 2
            ShiftVectorName = [file_dir, 'SVector/S2/S2_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M2/M2_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
        case 3
            ShiftVectorName = [file_dir, 'SVector/S3/S3_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M3/M3_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
        case 4
            ShiftVectorName = [file_dir, 'SVector/S4/S4_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M4/M4_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
        case 5
            ShiftVectorName = [file_dir, 'SVector/S5/S5_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M5/M5_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
        case 6
            ShiftVectorName = [file_dir, 'SVector/S6/S6_', num2str(i)];
            ShiftVectorName = [ShiftVectorName, '.txt'];
            RotationMatrixName = [file_dir, 'M/M6/M6_', num2str(i)];
            RotationMatrixName = [RotationMatrixName, '.txt'];
            ShiftVector{i} = textread(ShiftVectorName);
            RotationMatrix{i} = textread(RotationMatrixName);
    end
end
end
