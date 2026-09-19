function adjusted = HolmAdjust(p)
%HOLMADJUST Family-wise correction for the supplied planned comparisons.
% Missing tests remain NaN and count conservatively as p=1 in the family.
validateattributes(p, {'numeric'}, {'vector','real'});
assert(all(isnan(p) | (p>=0 & p<=1)), 'MToP:InvalidP', 'Invalid p value.');
shape=size(p);values=p(:);missing=isnan(values);values(missing)=1;
[values,order]=sort(values);m=numel(values);
corrected=min(1,cummax((m:-1:1)'.*values));
adjusted=nan(m,1);adjusted(order)=corrected;adjusted(missing)=NaN;
adjusted=reshape(adjusted,shape);
end
