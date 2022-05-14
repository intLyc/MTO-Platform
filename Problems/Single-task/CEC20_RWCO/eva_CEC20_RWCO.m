function evaluation = eva_CEC20_RWCO(index)

    %% Parameter
    D = [9	11	7	6	9	38	48	2	3	3	7	7	5	10	7	14	3	4	4	2	5	9	5	7	4	22	10	10	4	3	4	5 ...
        30	118	153	158	126	126	126	76	74	86	86	30	25	25	25	30	30	30	59	59	59	59	64	64	64];

    if D(index) <= 10
        evaluation = 10^5;
    elseif D(index) > 10 && D(index) <= 30
        evaluation = 2 * 10^5;
    elseif D(index) > 30 && D(index) <= 50
        evaluation = 4 * 10^5;
    elseif D(index) > 50 && D(index) <= 150
        evaluation = 8 * 10^5;
    elseif D(index) > 150
        evaluation = 10^6;
    end
end
