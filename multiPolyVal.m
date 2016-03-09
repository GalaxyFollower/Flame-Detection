function f=multiPolyVal(A,I,x)

[m n]=size(x);
[mi ni]=size(x);
% Checking Errors
if(m==1 & n>=1)
    x=x;
elseif(n==1 & m>=1)
    x=x';
    [m n]=size(x);
else
    Error('The dimensions of X and Y are not coherent with those of a vector');
end

f=zeros(size(x));
f(:)=nan;
for i=1:size(I,2)-1
  if(i==size(I,2)-1)
      j=x>=I(i) & x<=I(i+1);
  else
      j=x>=I(i) & x<I(i+1);
  end
  f(j)=polyval(A(i,:),x(j));
end
f=reshape(f,mi,ni);
