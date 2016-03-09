y2=y;
x2=x;

y2=y2(~isnan(y2));
x2=x2(~isnan(y2));

i1=x2<=mean(x2);
j1=x2>mean(x2);

i2=y2>max(y2(x2<=bords(1)));
j2=y2>max(y2(x2>=bords(2)));

i=i1.*i2;
j=j1.*j2;
k=i+j;

[i' j' k']

y(~k)=nan;
plot(x,y)