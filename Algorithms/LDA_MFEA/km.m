X = rand(50,10)
[idx,C] = kmeans(X,5)

a = C;

Y = rand(50,10)
[id,c] = kmeans(Y,5)

b = c;


[m1,m2] = mapping(a,b);
b1 = a*m1;
 