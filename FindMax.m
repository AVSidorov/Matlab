function MaxSet=FindMax(A)
% function search maximums (not  by every point as in SpecialTreks)
% 

if size(A,1)<size(A,2)&&max(size(A))>2
    A=A';
end;
if size(A,2)>1
    x=A(:,1);
    y=A(:,2);
else
    x(:,1)=1:numel(A);
    y=A;
end;
n=numel(y);
ex=false;
WidthInd=[];
MaxInd=[];
MaxVal=[];
boolSearch=true(n,1);
while ~ex
   [M,MI]=max(y(boolSearch));
   bool=y>=M/2;
   PSet=PartsSearch(bool);
   PartInd=find(PSet.SpaceEnd<MI,1,'last');
   if PSet.SpaceEnd(PartInd)<MI
        MaxInd(end+1)=MI;
        MaxVal(end+1)=M;
        WidthInd(end+1,:)=[max([1,PSet.SpaceEnd(PartInd)-1]),min([PSet.SpaceStart(PartInd)+1,n])];
        boolSearch(WidthInd(end,1):WidthInd(end,2))=false;
   end;
end;