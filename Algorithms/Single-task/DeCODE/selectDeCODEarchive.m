function archive = selectDeCODEarchive(archive, offspring)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    replace_cv = [archive.constraint_violation] > [offspring.constraint_violation];
    equal_cv = [archive.constraint_violation] <= 0 & [offspring.constraint_violation] <= 0;
    replace_obj = [archive.factorial_costs] > [offspring.factorial_costs];
    replace = (equal_cv & replace_obj) | replace_cv;

    archive(replace) = offspring(replace);
end
