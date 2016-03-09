function [Y A]=blobDepurator(areas, blobs, previousAreas, previousBlobs)

num1=zeros(size(areas));
num0=num1;
for i=1:size(areas,1)
    str='';
    str2='';
    for j=1:4
        str=[str num2str(blobs(i,j))];
        str2=[str2 num2str(previousBlobs(i,j))];
    end
  
    num1(i)=str2num([str num2str(areas(i))]);
    num0(i)=str2num([str2 num2str(previousAreas(i))]);
end

i=~ismember(num1,num0);

A=zeros(size(areas));
b=zeros(size(blobs));


A(i)=areas(i);
b(i,:)=blobs(i,:);

[A j]=sort(A,'descend');
Y=b(j,:);


