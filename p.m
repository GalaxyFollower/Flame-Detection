function [dP_dtmax ti]=p(A)
warning off
t=A(:,1);
P1=A(:,2);
P2=A(:,3);
order= 12;

k1=polyfit(t, P1,order);
k2=polyfit(t, P2,order);
y1 =polyval(k1,t);
y2 =polyval(k2,t);



figure(1)
subplot(2,1,1);
plot(t,P1, t, P2, t, y1,t,y2); 

dk1_dt= [order:-1:1].*k1(:,1:order);
dk2_dt= [order:-1:1].*k2(:,1:order);
dy1=polyval(dk1_dt,t)*1000;
dy2=polyval(dk2_dt,t)*1000;

[dP_dtmax(1) i]=max(dy1);
[dP_dtmax(2) j]=max(dy2)

dP_dtmax(3)=round(mean(dP_dtmax(1:2)));
ti(1)=t(i);
ti(2)=t(j);
ti(3)=mean(ti(1:2));
subplot(2,1,2);
plot(t,dy1,t,dy2);

% 
% 
% 
% 
% 
% [y1 k1]=Regresion(A(:,1)',A(:,2)',A(:,1)', 50, 4);
% [y2 k2]=Regresion(A(:,1)',A(:,3)',A(:,1)', 50, 4);
% warning on
% 
% dk1_dt= repmat(4:-1:1,size(t)).*k1(:,1:4);
% dk2_dt= repmat(4:-1:1,size(t)).*k2(:,1:4);
% 
% dP1_dt=max(getPointOfMultipleRegression(dk1_dt,t,t));
% dP2_dt=max(getPointOfMultipleRegression(dk2_dt,t,t));
% 
% 
% 
% function [y ]=getPointOfMultipleRegression(k,X,x)
% 
% I=ones(size(x));
% i=ones(size(X));
% [mini, pos]=min(abs(X*I'-i*x'));
% 
% y=zeros(size(x));
% 
% for i=1:size(x,1)
%     y(i)=polyval(k(pos(i),:),x(i));
% end