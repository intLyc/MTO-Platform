function transfer_individuals = Transfer(archive, bestX, Tnum)
    tp_idx = [];
    archive_dist = [];

    for t = 1:length(archive)

        for p = 1:length(archive{t})
            x = bestX.rnvec;
            y = archive{t}(p).rnvec;

            if length(y) > length(x)
                y = y(1:length(x));
            elseif length(y) < length(x)
                y(length(y) + 1:length(x)) = rand(1, length(x) - length(y));
            end

            archive{t}(p).rnvec = y;

            archive_dist = [archive_dist, dist(x, y')];
            tp_idx = [tp_idx; [t, p]];
        end

    end

    [~, min_idx] = sort(archive_dist);

    for i = 1:Tnum
        transfer_individuals(i) = archive{tp_idx(min_idx(i), 1)}(tp_idx(min_idx(i), 2));
    end

end
