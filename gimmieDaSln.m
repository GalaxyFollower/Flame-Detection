function [sln, rsquare, k]=gimmieDaSln(filePath, sheet,alfa, Delta_t, sp,uselog)
        
[~,~,raw]=xlsread(filePath,sheet);
data=xlsread(filePath,sheet,['A11:O' num2str(size(raw,1))]);
i=~isnan(data(:,6));
t=data(i,1);

position=data(i,6);
Af=data(i,10);
As=data(i,12);      

repeat=true;
options = optimoptions('fmincon','display','iter');
while repeat
    [sln, fun]=fmincon(@(x)(1-linearRegressionR2(t,position,Af,As,alfa,Delta_t,sp,x,sp(3), uselog))^2,sp(1:2)',[],[],[],[],[0;0],[1;1],[],options);
    [fun, rsquare,k ]=linearRegressionR2(t,position,Af,As,alfa,Delta_t,sp,sln,sp(3),uselog),sln
    saveThem=input('Save Results?','s');
    saveThem=strcmp(saveThem,'y') || isempty(saveThem);
    if saveThem
        analyzeResults3(filePath,sheet,alfa,[sln' sp(3)],uselog);
        repeat=false;
    else        
        repeat=strcmp(input('do you want to repeat?','s'),'y');
        
        if repeat
            sp(1:2)=input('What values wanna use?');        
        end
    end
end

end

function [fun, rsquare,k ]=linearRegressionR2(t,position,Af,As,alfa,Delta_t,sp0,sp,sp3,uselog)
    [K0, Su0, Kr0, Sur0]=karlovitzIt(t,position,Af,As,alfa,sp0,uselog);
     i=find(t>=Delta_t(1)-0.001 & t<=Delta_t(2)+0.001);
    [k0, gof0] = fit( K0(i)*1000, Su0(i)*1000, fittype( 'poly1')); 
    rsquare0= (gof0.rsquare);
    
    [K, Su, Kr, Sur]=karlovitzIt(t,position,Af,As,alfa,[sp;sp3],uselog);
    i=find(t>=Delta_t(1)-0.001 & t<=Delta_t(2)+0.001);
    [k, gof] = fit( K(i)*1000, Su(i)*1000, fittype( 'poly1')); 
    rsquare= (gof.rsquare);
    
   fun=sum((((K-Kr)./K).^2+((Su-Sur)./Su).^2))+length(t)*(log10(rsquare)./log10(rsquare0));
    %fun=sum(  ((K-Kr)./K).^2+((Su-Sur)./Su).^2 )+length(t)*sum((feval(k,K(i)*1000)-Su(i)*1000).^2./(Su(i)*1000).^2) ;

end











