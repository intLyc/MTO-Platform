function pop_size = fixPopSize(pop_size, tasks_size)
    %% Fix population size for multi-task
    % Input: pop_size, tasks_size
    % Output: pop_size (fixed)

    if mod(pop_size, tasks_size) ~= 0
        pop_size = pop_size + tasks_size - mod(pop_size, tasks_size);
    end
end
