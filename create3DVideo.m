function create3DVideo(FFC,t,numberOfPoints,order, name,aprox_type)
vidObj = VideoWriter(['Videos Matlab/' name '_3D.avi']);%
open(vidObj);%
fig1=figure(1);


numframes=size(FFC.signals.values,3);
set(fig1,'NextPlot','replacechildren');%

for i=1:numframes
    Y=FFC.signals.values(:,:,i);
    x=Y(1,:);
    y=Y(2,:);
    if(~isempty(x(~isnan(x))))
        flame=FlameProfile(x,y,t(i), numberOfPoints,order);
        
        
          
        fig1=get3DPoint(flame,aprox_type,'figure');
        
        
        winsize=get(fig1,'Position');%
        winsize(1:2)=0;%
        
        currFrame = getframe(fig1,winsize);%
        writeVideo(vidObj,currFrame);%
        writeVideo(vidObj,currFrame);
        writeVideo(vidObj,currFrame);
    end
end
    
close(vidObj);


