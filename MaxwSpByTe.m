function MaxwSpectr=MaxwSpByTe(Te,FileName);
if isstr(FileName)
    MaxwTab=MaxwTb(FileName);
else
    MaxwTab=FileName;
end;
MaxwSp(:,1)=MaxwTab(:,1);
MaxwSp(:,2)=MaxwTab(:,find(Te>=MaxwTab(1,:),1,'last'));
MaxwSp(:,3)=MaxwTab(:,find(Te<=MaxwTab(1,:),1,'first'));
MaxwSp(1,4)=Te;
%???????? ????????, ????? Te ????? ??????????? ?? ???????
for i=2:size(MaxwSp,1)
       MaxwSp(i,4)=interp1(MaxwSp(1,2:3),MaxwSp(i,2:3),Te);
end;
MaxwSpectr=[MaxwSp(2:end,1),MaxwSp(2:end,4)];
