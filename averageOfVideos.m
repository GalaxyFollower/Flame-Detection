function averageOfVideos(excelFile, save)
global  t position dz_dt d2z_dt2 d3z_dt3 Af As dA_dt filePath Su_ Su alfa Karlovitz tWalls 
[num,txt,raw] = xlsread(excelFile,'All');
t=[];
T=[];

for i=1:4:size(num,2)
   t=[t;num(~isnan(num(:,i)),i)];
   T=[T,num(:,i)];
end
t=unique(t(~isnan(t)));

z=nan(size(t,1),size(num,2)/4);
a=nan(size(t,1),size(num,2)/4);
at=nan(size(t,1),size(num,2)/4);

for i=1:size(num,2)/4

    [tf, loc] =ismember(T(:,i),t);
    z(loc(loc~=0),i)=num(~isnan(num(:,(i-1)*4+1)),(i-1)*4+2); 
    a(loc(loc~=0),i)=num(~isnan(num(:,(i-1)*4+2)),(i-1)*4+3);
    at(loc(loc~=0),i)=num(~isnan(num(:,(i-1)*4+3)),(i-1)*4+4);
end

position=nan(size(t));
Af=nan(size(t));
As=nan(size(t));
non=position;
stZ=nan(size(t));
stA=nan(size(t));
stAt=nan(size(t));

n=nan(size(t));
for i=1:size(t,1)
    position(i)=mean(z(i,~isnan(z(i,:))));
    Af(i)=mean(a(i,~isnan(a(i,:))));
    As(i)=mean(at(i,~isnan(at(i,:))));
  
    stZ(i)=std(z(i,~isnan(z(i,:))));
    stA(i)=std(a(i,~isnan(a(i,:))));
    stAt(i)=std(at(i,~isnan(at(i,:))));
    
    n(i)=sum(~isnan(z(i,:)),2);
    
end
t=t(n==size(num,2)/4);
position=position(n==size(num,2)/4);
Af=Af(n==size(num,2)/4);
As=As(n==size(num,2)/4);
stZ=stZ(n==size(num,2)/4);
stA=stA(n==size(num,2)/4);
stAt=stAt(n==size(num,2)/4);
n=n(n==size(num,2)/4);
non=non(n==size(num,2)/4);
if(save)
    filePath=excelFile;
    head=cell(10,18);
    head(1,1)={''''};
    xlswrite(excelFile,[head;{'Time (ms)', 'Time Spark (ms)', 'Time Left wall (ms)','Time Right wall (ms)', 'Time Ac_max(ms)','position (cm)', ... 
    'dz/dt (cm/ms)','d2z/dt2 (cm/ms)','d3z/dt3 (cm/ms)','Flame Area (cm2)','dAf/dt (cm2/s)', 'Cross-seccional Area(cm2)', ...
    'Su''(cm/ms)', 'K(1/ms)','Su (cm/ms)', 'Stdev(Position)', 'Stdev(Flame Area)','Stdev(Cross-section Area)'}], 'mean', 'A1');
    xlswrite(excelFile,[t non non non non position non non non Af non As non non non stZ stA stAt n],'mean', 'A12');
end