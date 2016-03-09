
global editing numPointsAnalysis
switch(aprox_type)
     case 1
           sheet='Profile';
     case 2
           sheet='Paraboloid';
     case 3
           sheet='ParaboloidFB';
     case 4           
           sheet='Spheroid';
     case 5           
           sheet='Profile Spheroid';
end
if(~exist('idx'))
    time=t;
    %[~,idx]=deleteoutliers(position-polyval([coeffvalues(fit(t,position,'a*x^2+b*x')) 0],t),0.99,true);
    %inx=setdiff(1:length(t),idx);
    inx=(1:length(t))';
    position=position(inx);
    t=t(inx);   
    FFC.signals.values=FFC.signals.values(:,:,inx);
    time=t;
    perimeter=reshape(perimeter,[numel(perimeter) 1]);
    area=reshape(area,[numel(perimeter) 1]);
    bbox=reshape(bbox,[4 length(bbox) ]);

    perimeter=perimeter(inx);
    area=area(inx);
    bbox=bbox(:,inx);
    FFC.time=FFC.time(inx);
end

nFrames=size(FFC.signals.values,3);

As=zeros(nFrames,1);
As(:)=nan;

Af=As;
dz_dt=As;
d2z_dt2=As;
d3z_dt3=As;
dA_dt=As;
Su_=As;
Su=As;
Karlovitz=As;


if(save2xls)
  %  notifyme;
end

[bords tW]=findFlameBorders2(FFC,time,fff,true);
tWalls=zeros(1,4);
tWalls(2:3)=tW;



a=bbox(4,:)';
b=bbox(3,:)';



if(cfs)
    if(aprox_type==5)
        P=reshape(cast(perimeter,'double'),[numel(perimeter) 1])/ppcm;
        A=reshape(cast(area,'double'),[numel(perimeter) 1])/ppcm.^2;
        a=cast(bbox(4,:),'double')'/ppcm;
        b=cast(bbox(3,:),'double')'/ppcm;
        Af=aproxSurface(a,b,P,A);
        As=pi*a.^2/4;
    else
        [Af As]=calculateArea(FFC,time,aprox_type,numberOfPoints,order);
    end
end

if(save2xls)
    saveResults(sheet,video_name);
end

if(cfs)
    if strcmp(get_param(model_path,'splinesmoothing'),'Spline Smoothing (matlab)')
        analyzeResults2(numPointsAnalysis,uselog);
    else
        analyzeResults(numPointsAnalysis,orderAnalysis,uselog);
    end
end

if(c3dv)
    create3DVideo(FFC,t,numberOfPoints,order, video_name,aprox_type);

end
