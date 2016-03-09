function analyzeResults3(filePath, sheet,alfa, sp,uselog)

global  t position dz_dt d2z_dt2 d3z_dt3 Af As dA_dt Su Karlovitz tWalls editing simulating numPointsAnalysis Zr Afr Asr
figure(1);
reply=input('Do you wish to analyse de data for calculation of derivatives [Y/N]\n>>','s');
numPointsAnalysis=sp;
if (isempty(reply))
    reply='Y';
end

if(strcmp('Y',reply) || strcmp('y',reply))
    if(~isempty(filePath))
        
        [~,~,raw]=xlsread(filePath,sheet);
        data=xlsread(filePath,sheet,['A11:O' num2str(size(raw,1))]);
        i=~isnan(data(:,6));
        t=data(i,1);
        tWalls(1)=t(1);
        position=data(i,6);
        Af=data(i,10);
        As=data(i,12);
        
    end
    warning off;
    t2=(min(t):(max(t)-min(t))/200:max(t))';
        
    ft = fittype( 'smoothingspline' );
    opts = fitoptions( 'Method', 'SmoothingSpline' );
    opts.SmoothingParam = sp(1);

    % Fit model to data.
    tx=(min(t):min(diff(t)):max(t))';
    if uselog(1)==1
        [k, gof] = fit( t(position>0), log(position(position>0)), ft, opts );        
        Zr=exp(feval(k,tx));
    elseif uselog(1)==2   
        [k, gof] = fit( log(t(position>0)), log(position(position>0)), ft, opts );        
        Zr=exp(feval(k,log(tx)));
    else
        [k, gof] = fit( t(~isnan(position)),position(~isnan(position)), ft, opts );        
        Zr=(feval(k,tx));
    end
    opts.SmoothingParam = sp(2);
    if uselog(2)==1
        [c, gof] = fit( t(position>0), log(Af(position>0)), ft, opts );  
        Afr=exp(feval(c,tx));
    elseif uselog(2)==2  
        [c, gof] = fit(log( t(position>0)), log(Af(position>0)), ft, opts );  
        Afr=exp(feval(c,log(tx)));
    else
        [c, gof] = fit( t(~isnan(position)),Af(~isnan(position)), ft, opts );  
        Afr=feval(c,tx);
    end
       
    opts.SmoothingParam = sp(3);
    if uselog(3)==1
        [q, gof] = fit( t(position>0), log(As(position>0)), ft, opts );  
        Asr=exp(feval(q,tx));
    elseif uselog(3)==2   
        [q, gof] = fit(log( t(position>0)), log(As(position>0)), ft, opts );  
        Asr=exp(feval(q,log(tx)));
    else
        [q, gof] = fit( t(~isnan(position)),As(~isnan(position)), ft, opts );  
        Asr=feval(q,tx);
    end
  
    dk_dt= k; dk_dt.p.coefs=differentiatePolynomials(dk_dt.p.coefs);dk_dt.p.order=dk_dt.p.order-1;
    d2k_dt2= dk_dt; d2k_dt2.p.coefs=differentiatePolynomials(d2k_dt2.p.coefs);d2k_dt2.p.order=d2k_dt2.p.order-1;
    d3k_dt3= d2k_dt2; d3k_dt3.p.coefs=differentiatePolynomials(d3k_dt3.p.coefs);d3k_dt3.p.order=d3k_dt3.p.order-1;
    
    
    dc_dt= c; dc_dt.p.coefs=differentiatePolynomials(dc_dt.p.coefs);dc_dt.p.order=dc_dt.p.order-1;
    d2c_dt2= dc_dt; d2c_dt2.p.coefs=differentiatePolynomials(d2c_dt2.p.coefs);d2c_dt2.p.order=d2c_dt2.p.order-1;
    
    dq_dt= q; dq_dt.p.coefs=differentiatePolynomials(dq_dt.p.coefs);dq_dt.p.order=dq_dt.p.order-1;
    d2q_dt2= dq_dt; d2q_dt2.p.coefs=differentiatePolynomials(d2q_dt2.p.coefs);d2q_dt2.p.order=d2q_dt2.p.order-1;
    
    
    
    dz_dt=zeros(size(tx));
    d2z_dt2=zeros(size(tx));
    d3z_dt3=zeros(size(tx));
    dA_dt=zeros(size(tx));    
    
    if uselog(1)==1        
        dz_dt=Zr.*feval(dk_dt,tx);
        d2z_dt2=Zr.*(feval(d2k_dt2,tx)+feval(dk_dt,tx).^2) ;
        d3z_dt3=Zr.*feval(d3k_dt3,tx)+1./Zr.*dz_dt.*d2z_dt2+2*Zr.*feval(dk_dt,tx).*feval(d2k_dt2,tx);

        Z_=exp(feval(k,t2));
        dz_dt_=Z_.*feval(dk_dt,t2);
        d2z_dt2_=Z_.*(feval(d2k_dt2,t2)+feval(dk_dt,t2).^2) ;
        d3z_dt3_=Z_.*feval(d3k_dt3,t2)+1./Z_.*dz_dt_.*d2z_dt2_+2*Z_.*feval(dk_dt,t2).*feval(d2k_dt2,t2);
    elseif uselog(1)==2   
        dz_dt=Zr.*feval(dk_dt,log(tx))./tx;
        d2z_dt2=Zr.*(feval(d2k_dt2,log(tx))-feval(dk_dt,log(tx))+feval(dk_dt,log(tx)).^2)./tx.^2 ;
        %d3z_dt3=Zr.*feval(d3k_dt3,log(tx))+1./Zr.*dz_dt.*d2z_dt2+2*Zr.*feval(dk_dt,log(tx)).*feval(d2k_dt2,log(tx));

        Z_=exp(feval(k,log(t2)));
        dz_dt_=Z_.*feval(dk_dt,log(t2))./t2;
        d2z_dt2_=Z_.*(feval(d2k_dt2,log(t2))+feval(dk_dt,log(t2)).^2) ;
        d2z_dt2_=Z_.*(feval(d2k_dt2,log(t2))-feval(dk_dt,log(t2))+feval(dk_dt,log(t2)).^2)./t2.^2 ;
        %d3z_dt3_=Z_.*feval(d3k_dt3,t2)+1./Z_.*dz_dt_.*d2z_dt2_+2*Z_.*feval(dk_dt,t2).*feval(d2k_dt2,t2);
        
    else
        dz_dt=feval(dk_dt,tx);
        d2z_dt2=feval(d2k_dt2,tx) ;
        d3z_dt3=feval(d3k_dt3,tx);
        
        Z_=feval(k,t2);
        dz_dt_=feval(dk_dt,t2);
        d2z_dt2_=feval(d2k_dt2,t2);
        d3z_dt3_=feval(d3k_dt3,t2);
    
        
        
    end
        
	 if uselog(2)==1
        A_=exp(feval(c,t2)); 
        dA_dt_=A_.*feval(dc_dt,t2); 
        d2A_dt2_=A_.*(feval(d2c_dt2,t2)+feval(dc_dt,t2).^2) ;
        dA_dt=Afr.*feval(dc_dt,tx);
     elseif uselog(2)==2
        A_=exp(feval(c,log(t2))); 
        dA_dt_=A_.*feval(dc_dt,log(t2))./t2; 
        d2A_dt2_=A_.*(feval(d2c_dt2,log(t2))-feval(dc_dt,log(t2))+feval(dc_dt,log(t2)).^2)./t2.^2 ;
        dA_dt=Afr.*feval(dc_dt,log(tx))./tx;
     else
        A_=feval(c,t2); 
        dA_dt_=feval(dc_dt,t2); 
        d2A_dt2_=feval(d2c_dt2,t2);
        
        dA_dt=feval(dc_dt,tx);   
     
     end
    
     if uselog(3)==1
        As_=exp(feval(q,t2)); 
        dAs_dt_=As_.*feval(dq_dt,t2); 
        d2As_dt2_=As_.*(feval(d2q_dt2,t2)+feval(dq_dt,t2).^2) ;
        dAs_dt=Asr.*feval(dq_dt,tx);
     elseif uselog(3)==2   
        As_=exp(feval(q,log(t2))); 
        dAs_dt_=As_.*feval(dq_dt,log(t2))./t2; 
        d2As_dt2_=As_.*(feval(d2q_dt2,log(t2))-feval(dq_dt,log(t2))+feval(dq_dt,log(t2)).^2)./t2.^2 ;
        dAs_dt=Asr.*feval(dq_dt,log(tx))./tx;
     else
        As_=feval(q,t2); 
        dAs_dt_=feval(dq_dt,t2); 
        d2As_dt2_=feval(d2q_dt2,t2);      
        dAs_dt=feval(dq_dt,tx);
    end
     
    [max_dz_dt pos_max_dz_dt]=max(dz_dt);
    
    

    




    warning on;
    
    Su=dz_dt.*Asr./Afr/alfa;
    Karlovitz=1./Afr.*dA_dt;
    
    figure(1);
    subplot(1,3,1);hold off;
    plot(t,position,'.'); hold on;
    plot(tx,Zr);hold off;
    
        
    subplot(1,3,2);
    plot(t,Af,'.'); hold on;
    plot(tx,Afr);
    hold off;
    fprintf('Analysis finished.\n');
   
    
        subplot(1,3,3);
        plot(t,As,'.'); hold on;
        plot(tx,Asr);
        hold off;
        fprintf('Analysis finished.\n');
    
    
    
    if ~simulating
        model_path=[gcs '/Edit Parameters'];
       editing=true;
       set_param(model_path,'splinesmoothing','Spline Smoothing (matlab)')
       set_param(model_path,'numPointsAnalysis' ,['[' num2str(sp) ']'],'uselog',['[' num2str(uselog) ']'])
       editing=false;
       
    end
    saveResults2(sheet,filePath,alfa)%    saveResults2(sheet);
    
plotZandDerivatives(t2, [Z_ dz_dt_*10 d2z_dt2_*100],4);
plotZandDerivatives(t2, [A_ dA_dt_*10 d2A_dt2_*100],5);
plotZandDerivatives(t2, [As_ dAs_dt_*10 d2As_dt2_*100],6);

    
end

   
%Calculates y-positions and the derivatives of the function requiered 

% according to the polynomials that are closer to the points in x
%PARAMETERS:
%   k: Matrix with the constants of the polynomials derired.
%   X: x-coordinates used for the regrassion.
%   x: horizontal vector with the x positions at which the calculation will
%   be made
%RETURNS: 
%   y: the y positions according to the polynomials
%   dy_dx: the derivative at the x point
function [y ]=getPointOfMultipleRegression(k,X,x)

I=ones(size(x));
i=ones(size(X));
[mini, pos]=min(abs(X*I'-i*x'));

y=zeros(size(x));

for i=1:size(x,1)
    y(i)=polyval(k(pos(i),:),x(i));
end


function plotZandDerivatives(X1, YMatrix1,fig)
%CREATEFIGURE1(X1,YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 13-Jan-2012 15:50:02

% Create figure

figure1 = figure(fig);
clf
% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on',...
    'OuterPosition',[0 1.38777878078145e-017 1 1]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','z');
set(plot1(2),'Color',[1 0 0],'DisplayName','dz/dt');
set(plot1(3),'Color',[0 0.498039215803146 0],'DisplayName','d^2z/dt^2');

ylim([0 1.2*max(YMatrix1(:,1))]);
% Create xlabel
xlabel('t(s)');

% Create ylabel
ylabel({'z (cm)','dz/dt * 10 (cm/ms)','d^2z/dt^2 * 10^2 (cm/ms^2)'},'Rotation',0);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.147065646021805 0.746821590147453 0.0688935281837161 0.170572916666667]);



    