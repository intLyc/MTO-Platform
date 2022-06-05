function [archive, bestobj, bestCV, bestX] = selectDeCODEarchive(archive, offspring, bestobj, bestCV, bestX)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    replace_cv = [archive.constraint_violation] > [offspring.constraint_violation];
    equal_cv = [archive.constraint_violation] == [offspring.constraint_violation];
    replace_obj = [archive.factorial_costs] > [offspring.factorial_costs];
    replace = (equal_cv & replace_obj) | replace_cv;

    archive(replace) = offspring(replace);

    [bestobj_now, bestCV_now, best_idx] = min_FP([archive.factorial_costs], [archive.constraint_violation]);
    if bestCV_now < bestCV || (bestCV_now == bestCV && bestobj_now < bestobj)
        bestobj = bestobj_now;
        bestCV = bestCV_now;
        bestX = archive(best_idx).rnvec;
    end
end
