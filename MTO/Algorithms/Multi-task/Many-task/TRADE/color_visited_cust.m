function [flags] = color_visited_cust(connected_customer, ci, flags)
if flags(ci)
    return;
end
flags(ci) = true;
cci = connected_customer(ci);
ici = find(connected_customer == ci);
if ci ~= cci
    flags = color_visited_cust(connected_customer, cci, flags);
end
for i = 1:length(ici)
    bci = ici(i);
    flags = color_visited_cust(connected_customer, bci, flags);
end

end
