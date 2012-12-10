function FitStruct=FitOneToAnother(Y,F,Ym,Fm,ShiftRange)

Nfit=20;
gs=(1+sqrt(5))/2;
Plot=false;




if nargin<5
    ShiftRange=max([max(diff(sortrows(Y(:,1)))),max(diff(sortrows(F(:,1))))]);
end;
if nargin<4
    Fm=mean(F(:,1));
end;
if nargin<3
    Ym=mean(Y(:,1));
end;
if size(Y,1)<size(Y,2)
    Y=Y';
end;
if size(F,1)<size(F,2)
    F=F';
end;
if size(Y,2)<2
 Y(:,2)=[1:numel(Y)];
 Y(:,3)=Y(:,1);
 Y(:,1)=[];
end;
if size(F,2)<2
 F(:,2)=[1:numel(F)];
 F(:,3)=F(:,1);
 F(:,1)=[];
end;


BaseShift=Ym-Fm;

ShKhi(1:3,1)=[-ShiftRange;0;ShiftRange];
ShKhi(1:3,2)=[inf;inf;inf];


while any(isinf(ShKhi(:,2)))
    for i=find(isinf(ShKhi(:,2)))' 
          xF=F(:,1)+BaseShift+ShKhi(i,1);%shift fit function
          xF(xF<min(Y(:,1))|xF>max(Y(:,1)))=[]; %remove points that are out bounds of base function
          YInd=find(Y(:,1)>=min(xF)&Y(:,1)<=max(xF));
          N=numel(YInd);
          xF=Y(YInd,1);
          xfit=xF-BaseShift-ShKhi(i,1); %x points for fit function interpolation
          Ffit=interp1(F(:,1),F(:,2),xfit,'cubic',0);  
            p=polyfit(Ffit,Y(YInd,2),1);
            A=p(1);
            B=p(2);
       ShKhi(i,2)=sqrt(sum((Y(YInd,2)-A*Ffit-B).^2)/N);
       AB(i,1)=A;
       AB(i,2)=B;
    end;
      [ShKhi,index]=sortrows(ShKhi);
      AB=AB(index,:);
     [KhiMin,KhiMinInd]=min(ShKhi(:,2));
     li=max([KhiMinInd-1;1]);
     ri=min([KhiMinInd+1;size(ShKhi,1)]);
     if ri-li>1
        [KhiFit,S,m]=polyfit(ShKhi(li:ri,1),ShKhi(li:ri,2),2);
         mid=-KhiFit(2)/(2*KhiFit(1))*m(2)+m(1);
            if mid>-ShiftRange&&mid<ShiftRange
                ShKhi(end+1,1)= mid;  
                ShKhi(end,2)=inf;
            end;
     end;
     dS=ShKhi(ri,1)-ShKhi(li,1);
     

     if isempty(find(ShKhi(:,1)==ShKhi(ri,1)-dS/gs))
        ShKhi(end+1,1)=ShKhi(ri,1)-dS/gs;
        ShKhi(end,2)=inf;
     end;
     if isempty(find(ShKhi(:,1)==ShKhi(ri,1)+dS/gs))
        ShKhi(end+1,1)=ShKhi(li,1)+dS/gs;
        ShKhi(end,2)=inf;
     end;
    % check for exit
    if min(diff(sortrows(ShKhi(:,1))))<=1/Nfit&&size(ShKhi,1)>=2*Nfit
        ShKhi(isinf(ShKhi(:,2)),:)=[];
    end;
end;
[KhiMin,KhiMinInd]=min(ShKhi(:,2));
A=AB(KhiMinInd,1);
B=AB(KhiMinInd,2);    

FitStruct.A=A;
FitStruct.B=B;
FitStruct.Shift=ShKhi(KhiMinInd,1);
FitStruct.Khi=KhiMin;

if Plot
figure;
    subplot(2,1,1);            
        plot(Y(:,1),Y(:,2));
        grid on; hold on;
        plot(F(:,1)+BaseShift+ShKhi(KhiMinInd,1),A*F(:,2)+B,'r');
%         plot(FitInd,trek(FitInd)-A*FitPulse(FitIndPulse)-B,'k');
    subplot(2,1,2);
        plot(ShKhi(:,1),ShKhi(:,2),'.b');
        grid on; hold on;
        KhiFit=polyfit(ShKhi(:,1),ShKhi(:,2),2);
        plot(ShKhi(:,1),polyval(KhiFit,ShKhi(:,1)));
pause;
close(gcf);
end;

