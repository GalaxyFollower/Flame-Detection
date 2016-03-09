
a=10.^(log10(0.5):0.1:log10(2))';
b=ones(size(a));
ab=repmat(a./(a+b), [1 8]);

[Se, Ae, Pe,Ce]= references(a,b, 'ellipse');
[Sr, Ar, Pr,Cr]= references(a,b,'rectangle');
[Srs, Ars, Prs,Crs]= references(a,b,'rhombus');
[Sw, Aw, Pw,Cw]= references(a,b,'weird');
[Sc, Ac, Pc,Cc]= references(a,b,'cake');
[Si, Ai, Pi,Ci]= references(a,b,'ideal');
logP=log([ Pr; Prs; Pe; Pe; Pe]);
logA=log([ Ar; Ars; Ae; Ae; Ae]);
logS=log([ Sr; Srs; Se;Se; Se]);

P=log10([ Pr./(a+b) Prs./(a+b) Pe./(a+b) Pe./(a+b) Pe./(a+b)]);
A=log10([ Ar./(a.*(b))  Ars./(a.*(b)) Ae./(a.*(b)) Ae./(a.*(b)) Ae./(a.*(b))]);
S=log10([ Sr Srs  Se  Se  Se ]);

logab=log(repmat(a./b, [ 1 8]));



CCr=(Ae./Pe.^2)./(Ar./Pr.^2);
CCrs=(Ae./Pe.^2)./(Ars./Prs.^2);
CCw=(Ae./Pe.^2)./(Aw./Pw.^2);

figure(1)
clf

subplot(2,2,1)
plot(a./(b+a),[ Cr Crs Cw Cc Ce]);
%plot(log10(a./b),[ Cr./Cr Crs./Cr Cw./Cr Cc./Cr Ce./Cr ]);
xlabel('$\log_{10}\left(\frac{a}{b}\right)$','interpreter','latex')
ylabel('$\frac{C_x}{C_e}$','interpreter','latex','rotation',0)

subplot(2,2,2)
%fun1=@(C,P,A,S) 1- 0.5*sqrt((1-(Pc./P)).^2.*(1+Pc./P).^2);
fun1=@(C,P,A,S) P./(a+b);
abP=[fun1(Cr,Pr,Ar,Sr) fun1(Crs,Prs,Ars,Srs)  fun1(Crs,Prs,Ars,Srs) fun1(Ce,Pe,Ae,Se) fun1(Ce,Pe,Ae,Se) fun1(Crs,Prs,Ars,Srs) fun1(Ce,Pe,Ae,Se) fun1(Ce,Pe,Ae,Se)];

plot(a./(a+b),([fun1(Cr,Pr,Ar,Sr) fun1(Crs,Prs,Ars,Srs) fun1(Cw,Pw,Aw,Sw) fun1(Cc,Pc,Ac,Sc) fun1(Ce,Pe,Ae,Se)] )) 
xlabel('$\log_{10}\left(\frac{a}{b}\right)$','interpreter','latex')
ylabel('$\frac{P_x}{P_e}$','interpreter','latex','rotation',0)

subplot(2,2,3)
%plot(log10(a./b),[Ar./Ae Ars./Ae Aw./Ae Ac./Ae ] );
fun2=@(C,P,A,S) A./(a.*b);
plot(a./(a+b), ([fun2(Cr,Pr,Ar,Sr) fun2(Crs,Prs,Ars,Srs) fun2(Cw,Pw,Aw,Sw) fun2(Cc,Pc,Ac,Sc) fun2(Ce,Pe,Ae,Se)]) );
xlabel('$\log_{10}\left(\frac{a}{b}\right)$','interpreter','latex')
ylabel('$\frac{A_x}{A_e}$','interpreter','latex','rotation',0)
Aab=[fun2(Cr,Pr,Ar,Sr) fun2(Crs,Prs,Ars,Srs) fun2(Ce,Pe,Ae,Se) fun2(Ce,Pe,Ae,Se) fun2(Ce,Pe,Ae,Se)];


subplot(2,2,4)
fun3=@(C,P,A,S) S./(a.*(a+b));
plot(a./(a+b),([fun3(Cr,Pr,Ar,Sr) fun3(Crs,Prs,Ars,Srs) fun3(Cw,Pw,Aw,Sw) fun3(Cc,Pc,Ac,Sc) fun3(Ce,Pe,Ae,Se)]) );
xlabel('$\log_{10}\left(\frac{a}{b}\right)$','interpreter','latex')
ylabel('$\frac{S_x}{S_e}$','interpreter','latex','rotation',0)
abS=[fun3(Cr,Pr,Ar,Sr) fun3(Crs,Prs,Ars,Srs)  fun3(Crs,Prs,Ars,Srs) fun3(Ce,Pe,Ae,Se)  fun3(Ce,Pe,Ae,Se) fun3(Crs,Prs,Ars,Srs) fun3(Ce,Pe,Ae,Se)  fun3(Ce,Pe,Ae,Se)];


figure(2)
subplot(2,2,1)
fun1=@(C,P,A,S) ((8*S)./(pi*P.^2));
plot(a./(a+b),([fun1(Cr,Pr,Ar,Sr) fun1(Crs,Prs,Ars,Srs) fun1(Cw,Pw,Aw,Sw) fun1(Cc,Pc,Ac,Sc) fun1(Ce,Pe,Ae,Se)] )) 


subplot(2,2,2)
fun2=@(C,P,A,S) pi*A./S;
plot(a./(a+b),([fun2(Cr,Pr,Ar,Sr) fun2(Crs,Prs,Ars,Srs) fun2(Cw,Pw,Aw,Sw) fun2(Cc,Pc,Ac,Sc) fun2(Ce,Pe,Ae,Se)])) 

subplot(2,2,3)
fun3=@(C,P,A,S)8*S./pi./P.^2 +pi.*A./S;% +a.*b./(a+b).^2.*(2*((A./P)+0.5*b./(a+b)));
%fun3=@(C,P,A,S) ( (b.^2.+(2-C./Cr).*a.*b)./(a+b).^2.*(A./Ar)+(a.^2+C./Cr.*a.*b)./(a+b).^2.*(P./Pr).^2 ).*Sr./S;%good enough
%fun3=@(C,P,A,S) abs(pi*A-S +8*S.^2./(pi*P.^2));%./(b./(a+b).*Ae+a./(a+b)*4*pi./(Pe.^2));
plot(a./(a+b),([fun3(Cr,Pr,Ar,Sr) fun3(Crs,Prs,Ars,Srs) fun3(Cw,Pw,Aw,Sw) fun3(Cc,Pc,Ac,Sc) fun3(Ce,Pe,Ae,Se)] )) 
%plot3(abP,Aab,[fun3(Cr,Pr,Ar,Sr) fun3(Crs,Prs,Ars,Srs) fun3(Ce,Pe,Ae,Se) fun3(Ce,Pe,Ae,Se) fun3(Ce,Pe,Ae,Se)])

subplot(2,2,4)
 fun4=@(C,P,A,S)fun1(C,P,A,S)+fun2(C,P,A,S);
% raices=@(P,A)cell2mat(arrayfun(@(i)roots([8/P(i)^2/pi -1 pi*A(i)]),1:length(a),'uniformoutput',false));
% racines=[raices(Pr,Ar);raices(Prs,Ars);raices(Pw,Aw);raices(Pc,Ac); raices(Pe,Ae)];
% racines(find(imag(racines)))=nan;
% racines=racines(1:2:10,:);
% plot(a./(a+b),racines) 
plot(a./(a+b),([fun4(Cr,Pr,Ar,Sr) fun4(Crs,Prs,Ars,Srs) fun4(Cw,Pw,Aw,Sw) fun4(Cc,Pc,Ac,Sc) fun4(Ce,Pe,Ae,Se)] )) 

hold on 
%plot([ min(log10(a./b)) max(log10(b./a))] ,[ 1  1 ],':k' )
%plot([ 0 0 ] ,[ 0  2 ],':k' )
hold off

fun1=@(C,P,A,S) P./(a+b);
X=[fun1(Cr,Pr,Ar,Sr) fun1(Crs,Prs,Ars,Srs) fun1(Ce,Pe,Ae,Se)];
Y=repmat( a./(a+b), [1 3]);
fun3=@(C,P,A,S)(S./A);
Z=[fun3(Cr,Pr,Ar,Sr) fun3(Crs,Prs,Ars,Srs) fun3(Ce,Pe,Ae,Se)];

W=repmat([1 5 5],[length(a) 1]);
plot(ab, abP)