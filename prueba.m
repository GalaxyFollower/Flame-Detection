[A I]=multiPolyFit(X,Y,8,3);
x=[1:0.001:7]';
f=multiPolyVal(A,I,x);
hold off
plot(X,Y,'.')
hold on
plot(x,f)