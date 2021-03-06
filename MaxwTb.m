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

AvaibleE=[];
for i=1:size(A,1)  
    E_=A(i,2);
    if E_~=0
        bool=find(AvaibleE==E_);
        if size(bool,1)==0
         AvaibleE=[AvaibleE;E_];
        end;
    end;
end;
AvaibleE=sort(AvaibleE);


M=zeros(size(AvaibleE,1),size(AvaibleT,1)+1);
M(:,1)=AvaibleE;

for i=1:size(AvaibleT,1)  
 MaxwSp=[];
 MaxwSp(:,1:2)=A(find(A(:,1)==AvaibleT(i)),2:3);
 FitInd=find(AvaibleE(:)>=MaxwSp(1,1)&AvaibleE(:)<=MaxwSp(end,1));
 MaxwFitLn=interp1(MaxwSp(:,1),log(MaxwSp(:,2)),AvaibleE(FitInd),'spline');
 MaxwFit=exp(MaxwFitLn(1:end));
 MaxwFit=MaxwFit';
 M(FitInd,1+i)=MaxwFit;
end;
MaxwTb=[[-1,AvaibleT'];M];
