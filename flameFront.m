%Function that analyses a boolean image with a sylouette of a flame, and
%returns the coordinates of the upper border of the image and the vector
%necessary for ploting the image.
%PARAMETERS:
%   BW: Boolean Image with closed white profile
%   BBox: vector containing the dimensions of the box that encloses the
%   flame in the form BBox=[x1 y1 w1 h1]
%   fraction: a vector or scalar containing the fraction of the flame front
%       desired it can be either on the form: 0<fraction<=1 or fraction=[L R]
%       where 0<L,R<=1
%   aprox_type: indicates the kind of aproximation that will be ploted on the
%       image 
%           aprox_type=1:     Profile
%           aprox_type=2:     Paraboloid with moving base
%           aprox_type=3:     Paraboloid with fixed base
%           aprox_type=4:     Spheroid 
%           aprox_type=5:     Profile Spheroid 
%RETURNS:
%   Y: Coordinates of the upper border of the image independently from the
%       aprox_type, in the form Y=[x;y]
%   P: Coordinates of the upper border of the image depending on the
%       aprox_type, in the form L=[x1 y1 x2 y2 ... xn yn]
function [Y,P,newBW]=flameFront(BW,BBox,fraction, y_electrodes, profile)
%find the extreme positions of the box the encloses the flame
x1=BBox(1,1);
x2=BBox(1,3)+x1;
y1=BBox(1,2);
y2=BBox(1,4)+y1;


m=size(BW,1);
if (profile==4)
    Y=zeros(2,m*10);    
else
    Y=zeros(2,m*2);
end
Y(:)=nan;
P=zeros(1,m*20);
P(:)=nan;

newBW=cast(zeros(size(BW)),'logical');
%locate a point of the flame in the lowest part of the 

row=cast(round((y1+y2)/2),'double');

if(~isempty(row) && row>0)
    col = cast(min(find(BW(row,:))),'double');
    if(~isempty(col) && col>0)
        %find the border of the flame

        vector=cast([row, col],'double');
        try
            boundary = bwtraceboundary(BW,vector,'NE');
        catch err
            if(strcmp(err.identifier,'images:bwtraceboundary:failedTrace'))
                boundary = bwtraceboundary(BW,vector,'NW');
            else
                rethrow(err);
            end
        end
        
        if isExternalBlob(boundary, BBox)
            newBW=removeBlob(BW,boundary);
            [Y,P,newBW]=flameFront(newBW,BBox,fraction, y_electrodes, profile);
        else
            newBW=selectOutBlob(BW,boundary);
            
            dim=size(boundary,1);

            [mini jmin]=min(boundary(dim:-1:1,1));%since min returns the first minimum 
            %it can find the vector is inverted so the flame front is defined as the
            %area that is not in contact with the tube.
            jmin=dim-jmin+1;%this is a correction to the previous inversion.

            [maxi jmax]=max(boundary(:,1));
            x=boundary(jmin:jmax,2);
            y=boundary(jmin:jmax,1);

            %the following is for removing the points that share the y
            %coordinate and that are contiguous one to the other.
            [y1 i1]=unique(y,'last');
            [y2 i2]=unique(y,'first');

            x1=x(i1);
            x2=x(i2);
            i3=union(i1,i2);
            x=x(i3);
            y=y(i3);
            o=size(i3,1);


            %Finally the vector P is calculated according to the profile
            %required
            switch(profile)
                case{1}

                    
                    if(o>1)

                        P(mod(1:o*2,2)~=0)=x';
                        P(mod(1:o*2,2)==0)=y';
                        x=x(~isnan(x));
                        y=y(~isnan(x));
                        Y(1,1:o)=y;
                        Y(2,1:o)=x;
                    end
                case{2}

                    
                    if(o>1)
                        [ymin jmin]=min(y);
                        [ymax jmax]=max(y);
                        [xmax imax]=max(x);

                        jmin=round(median(jmin));
                        jmax=round(median(jmax));
                        imax=round(median(imax));

                        if(isnan(jmin) || isnan(jmax) || isnan(imax))
                           [jmin jmax imax] 
                        end
                        yy=ymin:1:ymax;

                        k=polyfit([ymin (ymin+ymax)/2 ymax],[x(jmin) xmax x(jmax)],2);
                        xx=polyval(k,yy);
                        l=size(xx,2);
                        P(mod(1:l*2,2)~=0)=xx;
                        P(mod(1:l*2,2)==0)=yy; 
                        Y(1,1:o)=y;
                        Y(2,1:o)=x;
                    end

                case{3}   
    
                    
                    ymin=min(y);
                    ymax=max(y);
                    yy=ymin:1:ymax;

                    ymed=round(median(yy));
                    xmax=max(x);
                    k=polyfit([ymin ymed ymax],[y_electrodes xmax y_electrodes],2);
                    xx=polyval(k,yy);
                    l=size(xx,2);
                    P(mod(1:l*2,2)~=0)=xx;
                    P(mod(1:l*2,2)==0)=yy; 
                    Y(1,1:o)=y;
                    Y(2,1:o)=x;
                case{4}
                    a=cast(BBox(1,3)/2,'double')-1;
                    b=cast(BBox(1,4)/2,'double')-1;
                    l= size(BW,1)*4;

                    theta=0:2*pi/(l-1):2*pi;
                    r=cast(a*b./(b^2.*cos(theta).^2+a^2.*sin(theta).^2).^0.5,'double');
                    xx=r.*cos(theta)+a+cast(BBox(1,1),'double');
                    yy=r.*sin(theta)+b+cast(BBox(1,2),'double');
                    x=boundary(:,2);
                    y=boundary(:,1);
                    x=x(~isnan(x));
                    y=y(~isnan(x));
                    P(mod(1:l*2,2)~=0)=xx;
                    P(mod(1:l*2,2)==0)=yy;    

                    Y(1,1:size(y,1))=y;
                    Y(2,1:size(y,1))=x;
                case{5}
                        
                        P(1:2:2*length(boundary))=boundary(:,2)';
                        P(2:2:2*length(boundary))=boundary(:,1)';
                        x=boundary(~isnan(boundary(:,2)),2);
                        y=boundary(~isnan(boundary(:,2)),1);
                        Y(1,1:length(y))=y;
                        Y(2,1:length(y))=x;
                 
            end
            

            
        end
    end
end

i=~isnan(P);
if sum(i)~=0
    P=P(~isnan(P));
end
end

function isIt=isExternalBlob(boundary, BBox)
    xmax=max(boundary(:,2));
    xmin=min(boundary(:,2));
    ymax=max(boundary(:,1));
    ymin=min(boundary(:,1));

    isIt=~min([xmin ymin xmax-xmin+1 ymax-ymin+1]==BBox);
end 
function newBW=removeBlob(BW,boundary)
    xmax=max(boundary(:,2));
    xmin=min(boundary(:,2));
    ymax=max(boundary(:,1));
    ymin=min(boundary(:,1));
    [X,Y] = meshgrid(xmin:xmax,ymin:ymax);
    X=reshape(X,size(X,1)*size(X,2),1);
    Y=reshape(Y,size(Y,1)*size(Y,2),1);
    IN= inpolygon(X,Y,boundary(:,2),boundary(:,1));
    newBW=BW;
    newBW(Y(IN),X(IN))=0;
end

function newBW=selectOutBlob(BW,boundary)
    
    [X,Y] = meshgrid(1:size(BW,2),1:size(BW,1));
    X=reshape(X,size(X,1)*size(X,2),1);
    Y=reshape(Y,size(Y,1)*size(Y,2),1);
    IN= inpolygon(X,Y,boundary(:,2),boundary(:,1));
    newBW=cast(zeros(size(BW)),'logical');
    newBW=reshape(IN,size(BW));
end