function transfer_individuals = Transfer_Random(archive, bestX, Tnum)
    % random transfer
    for i = 1:Tnum
        rand_t = randi([1, length(archive)]);
        rand_p = randi([1, length(archive{rand_t})]);
        transfer_individuals(i) = archive{rand_t}(rand_p);

        % fix rnvec dim
        x = bestX.rnvec;
        y = transfer_individuals(i).rnvec;

        if length(y) > length(x)
            y = y(1:length(x));
        elseif length(y) < length(x)
            y(length(y) + 1:length(x)) = rand(1, length(x) - length(y));
        end

        transfer_individuals(i).rnvec = y;
    end

end
