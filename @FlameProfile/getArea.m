%Calculates the area of the flame resulting of enclosing the base of the
%two dimensional flame front in a circle and joining points of the circle
%with flame front's points by demi-elypses.
%PARAMETERS:
%   this:   object of the class FlameProfile
%   type:   it's either 'profile' to do the calculation with the border of 
%           the profile the  or 'paraboloid' to aproximate the value with a
%           revolution paraboloid.
%   complete: takes into account the area of the cilender that is located
%              below the flame front.
%RETURNS:  
%   Af: Flame front Area
%   As: Area of the crossed seccion of the base
function [Af As]= getArea(this,aprox_type)

y=this.y;
x=this.x;

%definition of positions of points 1 and 2 for calculation of line
%conecting the beggining and the end of the flame front curve
p1=1;
p2=size(this.x,2);
Af=nan;
As=nan;

if(p2>p1)
	switch(aprox_type)
    	case {1}
        	Af=0;
            As=0;

            R=this.R;
            %the x=0 coordinate is fixed to be the center of the of the front flame
            R=(x(p2)-x(p1))/2;
            As=pi*R^2;
            xmean=(x(p1)+x(p2))/2;
            x=x-xmean;  
            Af=rungekutta(@(theta,t)firstIntegral(this,theta)*R^2,[0 pi],0,pi/size(x,2));
        case {2}
            rf=this.R;
            hf=max(this.y);
            Af=pi*rf/(6*hf^2)*((rf^2+4*hf^2)^(3/2)-rf^3);
            As=pi*rf^2;
            
        case {3}
            rf=this.R;
            hf=max(this.y)+this.ymin;
            Af=pi*rf/(6*hf^2)*((rf^2+4*hf^2)^(3/2)-rf^3);
            As=pi*rf^2;
        case {4}
            a=this.R;
            c=(max(this.y)-min(this.y))/2;
            Af=areaOfSpheroid(a,c);
            As=pi*a^2;
            
        case {5}
            
        otherwise
            error('variable aprox_type most be either ''profile'' or ''paraboloid''');
    end

end

function A=areaOfSpheroid(a,c)



if(a>c)
    e2=1-c^2/a^2;
    e=e2^0.5;
    A=2*pi*a^2*(1+(1-e^2)/e*atanh(e));
elseif(a<c)
    e2=1-a^2/c^2;
    e=e2^0.5;
    A=2*pi*a^2*(1+c/(a*e)*asin(e));
else
    A=4*pi*a^2;
end
        

%Calculates first integral for the calculation of the surface area
function f=firstIntegral(this,theta)
R=this.R;
x=R*cos(theta);


[c dc_dx]=getPointOnFlameFront(this,x);

%integration
 f=rungekutta(@(phi,t) ...
 (  sin(theta)^4*cos(phi)^2 + ...
    +sin(theta)^4*cos(phi)^4*(dc_dx)^2 ...
    -2*c*dc_dx*cos(theta)*sin(phi)^2*sin(theta)^2*cos(phi)^2/R ...
    +c^2*cos(theta)^2*sin(phi)^4/R^2 ...
    +c^2*sin(phi)^2*sin(theta)^2/R^2 ...
    )^0.5 ...
    ,[pi/2 3*pi/2],0,pi/50);
%taking just the final data of the integrationLarc=Larc(size(Larc,1));





%runge-kutta4 method for function integration
%PARAMETERS: 
%   fun: function to be integrated
%   s: integration limits- size(s)=[1 2]
%   y0: Initial value of the function Y0=?fun(x)dx  ;
function y=rungekutta(fun,s,y0,h)
a=s(1);
b=s(2);
x=a;
y=y0;
i=1;
while(~(b-x<0 || (b-x-h<0 && min(b-x-h,b-x)==b-x-h)))
    k1=fun(x,y);
    k2=fun(x+0.5*h,y+0.5*k1*h);
    k3=fun(x+0.5*h,y+0.5*k2*h);
    k4=fun(x+h,y+k3*h);
    y=y+1/6*(k1+2*k2+2*k3+k4)*h;
    x=x+h;
    i=i+1;
end

