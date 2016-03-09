function [K, Su, Kr, Sur]=karlovitzIt(t,position,Af,As,alfa,sp,uselog)

    ft = fittype( 'smoothingspline' );
    opts = fitoptions( 'Method', 'SmoothingSpline' );
    opts.SmoothingParam = sp(1);

    % Position.
        if uselog(1)==1
        [k, gof] = fit( t(position>0), log(position(position>0)), ft, opts );        
        Zr=exp(feval(k,t));
    elseif uselog(1)==2   
        [k, gof] = fit( log(t(position>0)), log(position(position>0)), ft, opts );        
        Zr=exp(feval(k,log(t)));
    else
        [k, gof] = fit( t(~isnan(position)),position(~isnan(position)), ft, opts );        
        Zr=(feval(k,t));
    end
    %surface

    opts.SmoothingParam = sp(2);
    if uselog(2)==1
        [c, gof] = fit( t(position>0), log(Af(position>0)), ft, opts );  
        Afr=exp(feval(c,t));
    elseif uselog(2)==2  
        [c, gof] = fit(log( t(position>0)), log(Af(position>0)), ft, opts );  
        Afr=exp(feval(c,log(t)));
    else
        [c, gof] = fit( t(~isnan(position)),Af(~isnan(position)), ft, opts );  
        Afr=feval(c,t);
    end
  
    
        %Section Area  
        opts.SmoothingParam = sp(3);
    if uselog(3)==1
        [q, gof] = fit( t(position>0), log(As(position>0)), ft, opts );  
        Asr=exp(feval(q,t));
    elseif uselog(3)==2  
        [q, gof] = fit(log( t(position>0)), log(As(position>0)), ft, opts );  
        Asr=exp(feval(q,log(t)));
    else
        [q, gof] = fit( t(~isnan(position)),As(~isnan(position)), ft, opts );  
        Asr=feval(q,t);
    end
    
	%Derivatives
    dk_dt= k; dk_dt.p.coefs=differentiatePolynomials(dk_dt.p.coefs);dk_dt.p.order=dk_dt.p.order-1;
    dc_dt= c; dc_dt.p.coefs=differentiatePolynomials(dc_dt.p.coefs);dc_dt.p.order=dc_dt.p.order-1;
    
    if uselog(1)==1        
        dz_dt=Zr.*feval(dk_dt,t);
    elseif uselog(1)==2   
        dz_dt=Zr.*feval(dk_dt,log(t))./t;
    else
        dz_dt=feval(dk_dt,t);
    end
    
    if uselog(2)==1
    dA_dt=Afr.*feval(dc_dt,t);
    elseif uselog(2)==2
    dA_dt=Afr.*feval(dc_dt,log(t))./t;
    else
    dA_dt=feval(dc_dt,t);   
    end
     
    
    
    Su=dz_dt.*As./Af/alfa;
    K=1./Af.*dA_dt;
    
    Sur=dz_dt.*Asr./Afr/alfa;
    Kr=1./Afr.*dA_dt;


