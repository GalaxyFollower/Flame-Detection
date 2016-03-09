%Makes a regresion of the numOfPoints closest points to x to a order-grade
%polynomial, given the X and Y arrays. An returns the value of the
%regresion at that point
function [y k]=Regresion(X,Y,x, numOfPoints, order)

%Make sure its posible
order=min(size(X,2),order);
numOfPoints=min(size(X,2),numOfPoints);

%organize the arrays in ascending order for X
[X i]=sort(X);
Y=Y(i);

%find the position in X of the closest number to X
I=ones(size(x));
i=ones(size(X));
[min_difference, position] =min(abs(I'*X-x'*i)');


%find the inicial and last position of the points to be used
p1=position-round(numOfPoints/2)+1;
p2=position+round(numOfPoints/2)-mod(numOfPoints,2);

[a i]=find(p1<1);
p1(i)=1;

p2(i)=numOfPoints;

[a i]=find(p2>size(X,2));
p1(i)=size(X,2)-numOfPoints+1;
p2(i)=size(X,2);

for i=1:size(p1,2)
    k(i,:)=polyfit(X(p1(i):p2(i)), Y(p1(i):p2(i)),order);
    y(i,:)=polyval(k(i,:),x(i));
end


    

