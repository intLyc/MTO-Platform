function [archive] = selectDeCODEarchive(archive, offspring)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    replace_cv = [archive.CV] > [offspring.CV];
    equal_cv = [archive.CV] == [offspring.CV];
    replace_obj = [archive.Obj] > [offspring.Obj];
    replace = (equal_cv & replace_obj) | replace_cv;

    archive(replace) = offspring(replace);
end
