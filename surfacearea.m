%Estimates the surface area of a revolution solid using the approximation
%defined by method
%   a=length that encloses the object in the x axis
%   b=length that encloses the object in the y axis
function [Surface]=surfacearea(A,a,b)
[Se, Ae, Pe,Ce]= references(a,b, 'ellipse');
[Sr, Ar, Pr,Cr]= references(a,b,'rectangle');
[Srs, Ars, Prs,Crs]= references(a,b,'rhombus');


Surface=((Sr-Srs)./(Ar-Ars).*A+(Ar.*Srs-Sr.*Ars)./(Ar-Ars)) ;

end

% 
% function [Surface, Area, Perimeter,circularity]= references(a,b, object)
% 
% 
% Perimeter=zeros(size(a));
% Area=zeros(size(a));
% Surface=zeros(size(a));
% Centroid=zeros(size(a));
% 
% switch(object)
%     case 'ellipse'
%         %Estimating the equavalent radios 
%         
%         h=(a-b).^2./(a+b).^2;
%         Perimeter=pi*(a+b)/2 .*(1+3*h./(10+sqrt(4-3*h)));
%         Area=pi*a.*b/4;   
%         
%         %spheroid surface        
%                                 %http://mathworld.wolfram.com/Spheroid.html
%         
%         %oblate spheroid
%         i=a>b;
%         e=zeros(size(a));
%         e(i)=sqrt(1-b(i).^2./a(i).^2);% e1
%         Surface(i)=pi/2.*(a(i).^2+b(i).^2.*atanh(e(i))./e(i) );
%         
%         %prolate spheroid
%         j=a<b;%e2
%         e(j)=sqrt(1-a(j).^2./b(j).^2);
%         Surface(j)=pi*a(j).^2/2  +pi*a(j).*b(j)/2.*asin(e(j))./e(j) ;
%         
%         % sphere
%         k=a==b;
%         Surface(k)=pi.*a(k).^2;
%         
%     case 'rectangle'
%         Perimeter=2*(a+b);
%         Area=a.*b;        
%         %revolution surface of the cyllinder with axis parrallel to b
%         %side
%         Surface=pi*a.*(b+0.5*a); 
%         
%     case 'rhombus'
%         Perimeter=2*sqrt(a.^2+b.^2);
%         Area=a.*b/2;
%         Surface=pi*a.*sqrt(b.^2+a.^2)/2;
%     case 'weird'
%         [Se, Ae, Pe]= surfacearea(a,b,'ellipse');
%         Perimeter=Pe/2+a+3*b;
%         Area=Ae/2+3*a.*b/10;
%         Surface=Se/2+pi*a.^2/4+3*pi.*a.*b/10;
%     case 'cake'
%         Perimeter=2*a+2*b;
%         Area=3*a.*b/5;
%         Surface=pi*a.*(a/2+9/15*b);                
% end
% circularity=4*pi*Area./Perimeter.^2;
% end
