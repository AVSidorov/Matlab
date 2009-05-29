function [MaxwTb]=MaxwTb(FileName);
A=load(FileName);
AvaibleT=[];
for i=1:size(A,1)  
    T_=A(i,1);
    if T_~=0
        bool=find(AvaibleT==T_);
        if size(bool,1)==0
         AvaibleT=[AvaibleT;T_];
        end;
    end;
end;
AvaibleT=sort(AvaibleT);

dTe=0;
for i=2:size(AvaibleT,1)  
    dTe=max([dTe,AvaibleT(i)-AvaibleT(i-1)]);
end;
dE=10;
for i=1:size(AvaibleT,1)  
 MaxwSpE=A(find(A(:,1)==AvaibleT(i)),2);
 for ii=2:size(MaxwSpE,1)  
    dE=min([dE,MaxwSpE(ii)-MaxwSpE(ii-1)]);
 end;
end;
dE=dE/2;
E=0.1:dE:10;
M(:,1)=E;
for i=1:size(AvaibleT,1)  
MaxwSp(:,1:2)=A(find(A(:,1)==AvaibleT(i)),2:3);
% [Max,MaxI]=max(MaxwSp(:,2));
% Max2=max([MaxwSp(MaxI-1,2),MaxwSp(MaxI+1,2)]);
% MaxI2=find(MaxwSp(:,2)==Max2);
% FitI=sort([MaxI,MaxI2]);
% FitInd1=find(E(:)>=MaxwSp(FitI(1),1)&E(:)<=MaxwSp(FitI(end),1));
% MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),E(FitInd1),'spline');
% FitInd2=find(E(:)>=MaxwSp(1,1)&E(:)<MaxwSp(FitI(1),1));
% MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),E(FitInd2));
% MaxwFit=[exp(MaxwFitLn(1:end)),MaxwFit(1:end)];
% FitInd3=find(E(:)>MaxwSp(FitI(end),1)&E(:)<=MaxwSp(end,1));
% MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),E(FitInd3));
% MaxwFit=[MaxwFit(1:end),exp(MaxwFitLn(1:end))];
% MaxwFit=MaxwFit';
% M([FitInd2;FitInd1;FitInd3],end+1)=MaxwFit;

 FitInd=find(E(:)>=MaxwSp(1,1)&E(:)<=MaxwSp(end,1));
 MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),E(FitInd),'spline');
 MaxwFit=exp(MaxwFitLn(1:end));
 MaxwFit=MaxwFit';
 M(FitInd,end+1)=MaxwFit;
end;
MaxwTb=[[-1,AvaibleT'];M];
