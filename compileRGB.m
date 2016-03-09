function [comparison, together ] = compileRGB(I1,I2,I3)
[m,n]=size(I1);
comparison=zeros([m*4 n 3],'single');
together=zeros([m n 3],'single');
%red background
comparison([1:m 3*m+1:4*m],1:n,1)=[I1;I1];
together(:,:,1)=I1;
%green background
comparison([m+1:2*m 3*m+1:4*m],1:n,2)=[I2;I2];
together(:,:,2)=I2;
%Blue background
comparison(2*m+1:4*m,1:n,3)=[I3;I3];
together(:,:,3)=I3;

end