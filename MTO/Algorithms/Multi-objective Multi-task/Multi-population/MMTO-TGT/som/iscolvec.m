function status = iscolvec(x)

status = ~isempty(x) && isvector(x) && size(x,2) == 1;