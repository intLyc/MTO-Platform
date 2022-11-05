function [size1, size2] = InterCompare(conleadpop_obj, conleadpop_con, objleadpop_obj, objleadpop_con)

    mix_obj = [objleadpop_obj; conleadpop_obj];
    mix_con = [conleadpop_con; objleadpop_con];

    [~, objIndex] = sort(mix_obj);
    [~, conIndex] = sort(mix_con);

    popsize = length(conleadpop_obj);
    temp1 = find(objIndex(1:popsize) > popsize);
    temp2 = find(conIndex(1:popsize) > popsize);
    size1 = length(temp1);
    size2 = length(temp2);
end
