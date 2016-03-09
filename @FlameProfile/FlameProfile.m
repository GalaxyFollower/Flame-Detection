%This is the costructor of the class that receives the coordinates of the
%points that describe the profile of the flame and creates the regresion 
%constants that can be used for each point of the flame. The regresion is
%done by using the point considered as the central point of the
%'numberOfPoints' used for the regresion. Whenever a point near the border 
%is considered the regresion is done using the 'numberOfPoints' that arr
%closer to the respective border.
%   PARAMETERS:
%       x: x-axis coordinates of the flame front
%       y: y-axis coordinates of the flame front
%       numberOfPoints: the number of points to be considered for each
%       regresion.
%       order: the order of the polynomial used for the regresion.
function this = FlameProfile(x,y,time,numberOfPoints,order)
%Make sure its posible
if(size(x)~=size(y))
    error('the vectors x and y must be the same size');
end
y(isnan(y))=0;
x(isnan(x))=0;
i= find(y);
y=y(i);
x=x(i);

order=min(size(x,2),order);
numberOfPoints=min(size(x,2),numberOfPoints);

p1=1;
p2=size(y,2);



if(p2>p1)
    %Change of coordinates
    %the y=0 coordinate is placed at the base of the line conecting the
    %beggining and the end of the flame front
    ymin=min(y);
    y=y-ymin; 

    %the x=0 coordinate is fixed to be the center of the of the front flame
    maxX=max(x);
    minX=min(x);
    R=(maxX-minX)/2;
    As=pi*R^2;
    xmean=(maxX+minX)/2;
    
    x=x-xmean;
end

if(order>0)
    k=Regresion(x,y, numberOfPoints, order);

else
    k=[];
end

this=struct( ...
    'x',x, ... %x coordinates of the flame profile
    'y',y, ... %y coorfinates of the flame profile
    'time', time, ... %coordinates of the flame profile
    'k',k, ... %regresion constants
    'R',R,... %Radius of the circle that composes the base of the flame
    'ymin',ymin, ... %Position of the flame
    'numberOfPoints',numberOfPoints, ... %number of points used in the regresion
    'order', order ... %order of the regresion polynomial
    );

this=class(this,'FlameProfile');

    


%Makes a regresion of the numOfPoints closest points to x to a order-grade
%polynomial, given the X and Y arrays. An returns the value of the
%regresion at that point
function k=Regresion(X,Y, numOfPoints, order)

%Make sure its posible
order=min(size(X,2),order);
numOfPoints=min(size(X,2),numOfPoints);
x=X;
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
k=zeros(size(x,2),order+1);
warning off
for i=1:size(p1,2)
    k(i,:)=polyfit(X(p1(i):p2(i)), Y(p1(i):p2(i)),order);
end
warning on

    


