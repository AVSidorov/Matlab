function FIT=FitDouble(Y,F,YInd,FInd,YBaseInd,FBaseInd,ShiftRange)
Nfit=100;
N=min([numel(YInd),numel(FInd)]);
YIndNorm=YInd-YBaseInd;
NF=numel(F);
ShAKhi=[];
i=0;
for sh1=-ShiftRange:2*ShiftRange/Nfit:ShiftRange
    i=i+1;
    ii=0;
    for sh2=-ShiftRange:2*ShiftRange/Nfit:ShiftRange
        ii=ii+1;
        if sh1~=sh2
            Pulse1=interp1([1:NF]',F,[1:NF]'-sh1,'linear',0);
            Pulse2=interp1([1:NF]',F,[1:NF]'-sh2,'linear',0);
            FInd1=round(FInd-sh1);
            FInd1(FInd1<1|FInd1>numel(F))=[];
            FInd2=round(FInd-sh2);
            FInd2(FInd2<1|FInd2>numel(F))=[];
            FIndNorm1=FInd1-FBaseInd;
            FIndNorm2=FInd2-FBaseInd;
            Ind1=intersect(YIndNorm,FIndNorm1);
            Ind2=intersect(YIndNorm,FIndNorm2);
            Ind=intersect(Ind1,Ind2);
            Sf1f2=sum(Pulse1(Ind+FBaseInd).*Pulse2(Ind+FBaseInd));
            Sf12=sum(Pulse1(Ind+FBaseInd).^2);
            Sf22=sum(Pulse2(Ind+FBaseInd).^2);
            Syf1=sum(Y(Ind+YBaseInd).*Pulse1(Ind+FBaseInd));
            Syf2=sum(Y(Ind+YBaseInd).*Pulse2(Ind+FBaseInd));
            A1=(Syf1*Sf22-Syf2*Sf1f2)/(Sf12*Sf22-Sf1f2^2);
            A2=(Syf2*Sf12-Syf1*Sf1f2)/(Sf12*Sf22-Sf1f2^2);
            ShAKhi(end+1,1)=sh1;
            ShAKhi(end,2)=sh2;
            ShAKhi(end,3)=A1;            
            ShAKhi(end,4)=A2;            
            ShAKhi(end,5)=sum((Y(Ind+YBaseInd)-A1*Pulse1(Ind+FBaseInd)-A2*Pulse2(Ind+FBaseInd)).^2)/numel(Ind);
            ShAKhi(end,6)=numel(Ind);
            x(i,ii)=sh1;
            y(i,ii)=sh2;
            if A1>0&&A2>0
                z(i,ii)=ShAKhi(end,5);
            else
                z(i,ii)=inf;
            end;
        else
            Pulse1=interp1([1:NF]',F,[1:NF]'-sh1,'linear',0);
            FInd1=round(FInd-sh1);
            FInd1(FInd1<1|FInd1>numel(F))=[];
            FIndNorm1=FInd1-FBaseInd;
            Ind=intersect(YIndNorm,FIndNorm1);
            A=sum(Y(Ind+YBaseInd).*F(Ind+FBaseInd))/sum(F(Ind+FBaseInd).^2);
            ShAKhi(end+1,1)=sh1;
            ShAKhi(end,2)=0;
            ShAKhi(end,3)=A;            
            ShAKhi(end,4)=0;            
            ShAKhi(end,5)=sum((Y(Ind+YBaseInd)-A*Pulse1(Ind+FBaseInd)).^2)/numel(Ind);
            ShAKhi(end,6)=numel(Ind);
            x(i,ii)=sh1;
            y(i,ii)=sh2;            
            z(i,ii)=ShAKhi(end,5);            
        end;
    end;
end;
ShAKhi=sortrows(ShAKhi,5);
ShAKhi=ShAKhi(ShAKhi(:,3)>0&ShAKhi(:,4)>0,:);
figure;
grid on; hold on;
contour(x,y,z,ShAKhi(1:20:2000,5));