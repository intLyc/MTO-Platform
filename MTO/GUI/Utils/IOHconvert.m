function result_table = IOHconvert(metric_result)
%% IOHconvert - Convert metric_result of MToP to IOHanalyzer csv format

% Extract basic information
num_algorithms = length(metric_result.ColumnName);
num_rows = length(metric_result.RowName);
num_reps = size(metric_result.ConvergeData.X, 3);

% Get all data dimensions
[~, ~, ~, num_gens] = size(metric_result.ConvergeData.X);

% Vectorized processing
% Reshape data to 2D for easier processing
X_reshaped = reshape(metric_result.ConvergeData.X, [], num_gens);
Y_reshaped = reshape(metric_result.ConvergeData.Y, [], num_gens);

% Find all valid (non-NaN) entries
valid_mask = ~isnan(Y_reshaped);

% Pre-allocate based on total valid entries
total_valid = sum(valid_mask(:));
fe_array = zeros(total_valid, 1);
val_array = zeros(total_valid, 1);
row_indices = zeros(total_valid, 1);
algo_indices = zeros(total_valid, 1);
rep_indices = zeros(total_valid, 1);

% Fill arrays using vectorized operations
idx = 1;
for i = 1:size(X_reshaped, 1)
    valid_cols = valid_mask(i, :);
    n_valid = sum(valid_cols);

    if n_valid > 0
        end_idx = idx + n_valid - 1;
        fe_array(idx:end_idx) = X_reshaped(i, valid_cols);
        val_array(idx:end_idx) = Y_reshaped(i, valid_cols);

        % Calculate original indices
        [row_idx, algo_idx, rep_idx] = ind2sub([num_rows, num_algorithms, num_reps], i);
        row_indices(idx:end_idx) = row_idx;
        algo_indices(idx:end_idx) = algo_idx;
        rep_indices(idx:end_idx) = rep_idx;

        idx = end_idx + 1;
    end
end

% Convert indices to names (ensure same length)
task_names = cell(total_valid, 1);
algo_names = cell(total_valid, 1);

for k = 1:total_valid
    task_names{k} = metric_result.RowName{row_indices(k)};
    algo_names{k} = metric_result.ColumnName{algo_indices(k)};
end

% Create table
result_table = table(fe_array, val_array, task_names, algo_names, rep_indices, ...
    'VariableNames', {'EvaluationCount', 'Values', 'FunctionID', 'AlgorithmID', 'RunID'});

end
