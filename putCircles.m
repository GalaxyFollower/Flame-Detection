function putCircles(boundary)
 
figure(1)
clf
hold on

x=boundary(1,:);
y=boundary(2,:);
n=length(y);

%Organizing the data to start at the bottom and deleting pointd INSIDE
%horizontal lines
i=1:length(y)-1;
m=(y(i+1)-y(i))./(x(i+1)-x(i));
i=2:length(m);
j=[~(m(1)==0 & m(end)==0)  ~(m(i)==0 & m(i-1)==0)];
x=x(j);
y=y(j);
j=find(y==min(y));
y=[y(j:end)  y(1:j)];
x=[x(j:end)  x(1:j)];
i=1:length(y)-1;
m=(y(i+1)-y(i))./(x(i+1)-x(i));


plot(x,y)
plot(x,y,'o')
[yun]= unique(y);


slp(m<0)=-1;
slp(m>0)=1;
slp(m==0)=0;
slp(isinf(m))=inf;

arrayfun(@(i)text(mean([x(i) x(i+1)]),mean([y(i) y(i+1)]),num2str(slp(i))),i,'uniformoutput',false);

%trace circles from bottom to top
for i=1:length(yun)
   %find points that are share the same height as yun(i)
      [yi idx]=find(y==yun(i));
   %find the points that enclose all others at yun(i)
      xmin=min(x(idx));
      xmax=max(x(idx));
      r=(xmax-xmin)/2;
      x0=(xmax+xmin)/2;
      theta=[0:0.01:2]*pi;
      zcirc=r*sin(theta);
      xcirc=r*cos(theta)+x0;
      plot3(xcirc,ones(size(xcirc))*yun(i),zcirc)
      
      
end


% 
% 
% 
% 
% txt=cell([length(y)-1 1]);
% txt{1}=[slp{end} slp{1}];
% text(mean(x(1:2)),mean(y(1:2)),slp(1));
% text(x(1),y(1),txt(1));
% for i=2:length(y)-1
%    txt{i}=[slp{i-1} slp{i}];
%    text(mean(x(i:i+1)),mean(y(i:i+1)),slp(i));
%    text(x(i),y(i),txt{i});
% end
% text(mean(x(n-2:n-1)),mean(y(n-2:n-1)),slp(n-1));

    

hold off
