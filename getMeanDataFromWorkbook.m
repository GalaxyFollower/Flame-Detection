excelFile='C:\Users\Jean-Christophe\Documents\LRGP\Matlab\Flame detection\Results\Methane - Amidon _ 120 vs 180 ms Paraboloid.xlsm';
[status,sheets] = xlsfinfo(excelFile);

%find similar sheets by cuting their names where the character '-' exists
cutIt=zeros(size(sheets));
sheets2=sheets;
for i=1:size(sheets,2)
    name=sheets{i};
    cutIt=findstr(name, '-');

    if(size(cutIt,1)>0)
        sheets2{i}= name(1:cutIt-1);
    end
end