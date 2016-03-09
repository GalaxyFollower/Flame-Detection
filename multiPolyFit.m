%Makes a regresion of vectors X and Y in M polynomials of order J 
function [A I]=multiPolyFit(X,Y,M,J,segIni)
[n m]=size(X);
% Checking Errors
if ~(logical(prod(double(size(X)==size(Y)))))
    Error('The dimensions of X and Y do not agree');
end
if(n==1 & m>=1)
    X=X;
    Y=Y;
    N=m;
elseif(m==1 & n>=1)
    X=X';
    Y=Y';
    [n m]=size(X);
    N=m;
else
    Error('The dimensions of X and Y are not coherent with those of a vector');
end
if ((N-1)/M<J)
    Error('The order of polynomials must be inferior or equal to (N-1)/M where N=numebr of points and M number of polynomials');
end

%initialization of constants
A=zeros(M,J+1);
i=1:M+1;
j=(i-1)*floor((N-1)/M)+1;
j(M+1)=N;
I=X(j);
x=cell(M,1);
y=x;
a=polyfit(X,Y,J);
for i=1:M
  
  if(segIni)
    %x{i}= X(X>=I(i) & X<=I(i+1));
    %y{i}= Y(X>=I(i) & X<=I(i+1));
    x{i}= X(X>=I(max(1,i-1)) & X<=(I(i+1) +I(min(M+1,i+2)))/2);
    y{i}= Y(X>=I(max(1,i-1)) & X<=(I(i+1) +I(min(M+1,i+2)))/2);
    A(i,:)=polyfit(x{i},y{i},J);
  else
    A(i,:)=a;
  end
end


A=fliplr(A);
Avector=reshape(A,M*(J+1),1);

Tk=zeros(M-1,M);

K=Tk;
II=zeros(M-1,M);
for i=2:M
    K(i-1,i-1)=1;
    K(i-1,i)=-1;
    II(i-1,:)=I(i);     
end
Sk=K;
Uk=Tk;
R=[Sk;Tk;Uk];
%R=[Sk;Tk];
for k=2:J+1
    Sk=K.*II.^(k-1);
    Tk=(k-1)*K.*II.^(k-2);
    if(k>2)
        Uk=(k-1)*(k-2)*K.*II.^(k-3);
    end
    R=[R ,[Sk;Tk;Uk]];
    %R=[R ,[Sk;Tk]];
end
options = optimset('MaxFunEvals',100000,'MaxIter',10000);

fun=@(a)sum((Y - multiPolyVal(fliplr(reshape(a,M,J+1)),I,X)).^2);
%Avector2= fgoalattain(fun,Avector,fun(Avector)*1.2,1,[],[],R,zeros(3*(M-1),1));
Avector2= fgoalattain(fun,Avector,fun(Avector)*1.2,1,[],[],R,zeros(3*(M-1),1),[],[],[],options);
A=reshape(Avector2,M,J+1);
A=fliplr(A);





