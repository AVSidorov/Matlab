function [MaxwSp,WMax]=Maxw(Te,FileName);
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
TeInd=find(abs(AvaibleT(:)-Te)<=dTe/2,1,'first');
Te=AvaibleT(TeInd);
fprintf('Te for Maxwellian Fitting is %4.3f keV\n',Te);
MaxwSp(:,1:2)=A(find(A(:,1)==Te),2:3);
[Max,MaxI]=max(MaxwSp(:,2));
Max2=max([MaxwSp(MaxI-1,2),MaxwSp(MaxI+1,2)]);
MaxI2=find(MaxwSp(:,2)==Max2);
FitI=sort([MaxI,MaxI2]);
Xi=MaxwSp(FitI(1),1):(MaxwSp(FitI(end),1)-MaxwSp(FitI(1),1))/1000:MaxwSp(FitI(end),1);
%Xi=MaxwSp(FitI(1)-1,1):(MaxwSp(FitI(end)+1,1)-MaxwSp(FitI(1)-1,1))/1000:MaxwSp(FitI(end)+1,1);
MaxwFit=interp1(MaxwSp(:,1),MaxwSp(:,2),Xi,'spline');
[MaxB,MaxBI]=max(MaxwFit);
WMax=Xi(MaxBI);
