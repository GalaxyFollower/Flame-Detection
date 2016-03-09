function S=aproxSurface(a,b,P,A)

[Se, Ae, Pe]= references(a,b,'ellipse');
[Sr, Ar, Pr]= references(a,b,'rectangle');
[Srs, Ars, Prs]= references(a,b,'rhombus');

X=[Pr./(a+b) Pe./(a+b) Prs./(a+b)];
Y=[Sr./Ar Se./Ae Srs./Ars] ;
S= arrayfun(@(i)A(i)*polyval(polyfit(X(i,:),Y(i,:),2),...
                        P(i)/(a(i)+b(i))),(1:length(a))' ) ;