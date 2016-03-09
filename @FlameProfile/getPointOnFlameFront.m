%Calculates y-positions and the derivatives of the flame front according to 
% the polynomials that are closer to the points in x
%PARAMETERS:
%   this: object of the class FlameProfile
%   x: horizontal vector with the x positions at which the calculation will
%   be made
%RETURNS: 
%   y: the y positions according to the polynomials
%   dy_dx: the derivative at the x point
function [y dy_dx]=getPointOnFlameFront(this,x)

I=ones(size(x));
i=ones(size(this.x));
[mini, pos]=min(abs(I'*this.x-x'*i)');

if(nargout==2)
    dk_dx= repmat(this.order:-1:1,size(x,2),1).*this.k(pos,1:this.order);
end

y=zeros(size(x));
dy_dx=zeros(size(x));
for i=1:size(x,2)
    y(i)=polyval(this.k(pos(i),:),x(i));

    if(nargout==2)       
        dy_dx(i)=polyval(dk_dx(i,:),x(i));
    end
end