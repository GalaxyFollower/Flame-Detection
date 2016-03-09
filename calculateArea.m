%Calculates the flame front area of each of the frames resulting from a 
%ideo analyzed in simulink's file FlameAnalysis.mdl 
%PARAMETERS:    
%   FFC:    struct array containing the information of the positions of the
%           points limiting the flame front for each frame of the video
%   ppcm: (number of pixels)/(centimeter) for the videio analyzed
%   numberOfPoints: number of point to be taken into account when producing
%           the regresion polynomial of the flame front (regresion made by 
%           segments)
%   type:   it's either 'profile' to do the calculation with the border of 
%           the profile the  or 'paraboloid' to aproximate the value with a
%           revolution paraboloid.
%   order:  order of the regresion polinomials.
function [Af As]=calculateArea(FFC,t,aprox_type, numberOfPoints,order)
global position bords tWalls 
tic;


nFrames=size(FFC.signals.values,3);
Af=zeros(nFrames,1);
As=zeros(nFrames,1);
timeelapsed=0;
for i=1:nFrames
 

    Y=FFC.signals.values(:,:,i);
    x=Y(1,:);
    y=Y(2,:);

    %delete borders
    y2=y;
    x2=x;

        %erase nan
    y2=y2(~isnan(y2));
    x2=x2(~isnan(y2));
        %get de indices of the left and right middles of the flame
    i1=x2<=mean(x2);
    j1=x2>mean(x2);
        %get the indices of those y that are greater than the one found in
        %the border
    if(aprox_type~=4) %To do as long as the aproximation is no an spheroid
        if(isempty(y2(x2<=bords(1))))
            i2=cast(ones(size(y2)),'logical');
        else
            i2=y2>max(y2(x2<=bords(1)));
        end

        if( isempty(y2(x2>=bords(2))))   
            j2=cast(ones(size(y2)),'logical');
        else
            j2=y2>max(y2(x2>=bords(2)));
        end
    
        %intersection and union ofthe halfs and the greater y
    k=i1.*i2+j1.*j2;

    y(~k)=nan;
    %end delete borders
    else
        %there's no regresion when aproximating by paraboloid
        numberOfPoints=0;
        order=0;
    end

    
    hold on
        
    time=t(i);
    

    
    try
        flame=FlameProfile(x,y,time, numberOfPoints,order);
        [Af(i) As(i)]= getArea(flame,aprox_type);

    catch err
        err
    end
    clc;
    previoustime=timeelapsed;
    timeelapsed=toc;
    
    fprintf(['Please wait while the flame surface area is calculated \n\t%6.2f%%\nTime Elapsed:\t' min_sec(timeelapsed) '\nTime Left: ' min_sec((nFrames-i)*(timeelapsed-previoustime)) '\n'],i/nFrames*100);
end
clc
fprintf(['Calculation completed.\n\t%6.2f%% Completed.\nTime Elapsed: ' min_sec(timeelapsed) ' \n'],i/nFrames*100);
figure(1);
subplot(2,1,1);
plot(t, position,'.')
subplot(2,1,2);
plot(t, Af,'.')
hold off;


function y=min_sec(seconds)

minutes=floor(seconds/60);
left=floor(mod(seconds,60));


y=[num2str(minutes) ' min ' num2str(left) ' seconds'];
