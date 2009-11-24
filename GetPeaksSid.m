function [peaks,trekMinus]=GetPeaksSid(trek,PeakSet,StandardPulse);

tic;
disp('>>>>>>>>>>>>>GetPeaksSid started<<<<<<<<<<<<<<<<<<');
tau=0.020;        % us digitizing time


FineInterpN=40;   %number of extra intervals for fine interpolation of Standard Pulse in fitting

StandardPulseN=size(StandardPulse,1);
[StPMax,StPMaxInd]=max(StandardPulse);

StandardPulseFine=interp1(1:StandardPulseN,StandardPulse,1:1/FineInterpN:StandardPulseN,'spline')';
Pts2CorBool=StandardPulseFine<0;
Pts2CorInd=find(Pts2CorBool);
FirstFrontPoint=Pts2CorInd(find(Pts2CorInd<StPMaxInd*FineInterpN,1,'last'));

StandardPulseFine(Pts2CorInd)=0;
StandardPulseFine(1:FirstFrontPoint)=0;

FitN=StPMaxInd+2;
FitPulse=StandardPulse(1:FitN);

for i=-FineInterpN:FineInterpN
   StandardPulseFineSh=circshift(StandardPulseFine,i);
   StandardPulseFineSh(1)=0;
   FitPulses(:,FineInterpN+i+1)=StandardPulseFineSh(1:FineInterpN:FitN*FineInterpN);
   Sums1F(FineInterpN+i+1)=sum(FitPulses(:,FineInterpN+i+1));
   Sums2F(FineInterpN+i+1)=sum(FitPulses(:,FineInterpN+i+1).^2);
end;

Sums1=sum(FitPulse);
Sums2=sum(FitPulse.^2);

PeakInd=PeakSet.SelectedPeakInd;
bool=PeakInd<StPMaxInd|PeakInd>(size(trek,1)-2);
PeakInd(bool)=[]; 
PeakIndN=size(PeakInd,1);

mGN=1;
ProcessInd=1:PeakIndN;
while mGN<PeakIndN;
for i=ProcessInd;
 Sums3(i,1)=sum(trek(PeakInd(i)-1-StPMaxInd+1:PeakInd(i)-1-StPMaxInd+FitN));
 Sums3(i,2)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN));
 Sums3(i,3)=sum(trek(PeakInd(i)+1-StPMaxInd+1:PeakInd(i)+1-StPMaxInd+FitN));

 Sums4(i,1)=sum(trek(PeakInd(i)-1-StPMaxInd+1:PeakInd(i)-1-StPMaxInd+FitN).*FitPulse);
 Sums4(i,2)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN).*FitPulse);
 Sums4(i,3)=sum(trek(PeakInd(i)+1-StPMaxInd+1:PeakInd(i)+1-StPMaxInd+FitN).*FitPulse);
 
 Sums5(i,1)=sum(trek(PeakInd(i)-1-StPMaxInd+1:PeakInd(i)-1-StPMaxInd+FitN).^2);
 Sums5(i,2)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN).^2);
 Sums5(i,3)=sum(trek(PeakInd(i)+1-StPMaxInd+1:PeakInd(i)+1-StPMaxInd+FitN).^2);

end;

A=zeros(PeakIndN,3);
B=zeros(PeakIndN,3);
Khi=zeros(PeakIndN,3);

for i=1:3
    A(:,i)=(FitN*Sums4(:,i)-Sums3(:,i)*Sums1)./(FitN*Sums2-Sums1^2);
    B(:,i)=(Sums3(:,i)-A(:,i)*Sums1)/FitN;
    Khi(:,i)=(Sums5(:,i)+(A(:,i).^2).*Sums2+FitN*B(:,i).^2+2*A(:,i).*B(:,i)*Sums1-2*A(:,i).*Sums4(:,i)-2*B(:,i).*Sums3(:,i))./(FitN*A(:,i).^2);
end;
mL=Khi(:,1)<Khi(:,2)&Khi(:,2)<Khi(:,3);
mLInd=find(mL);
mLN=size(mLInd,1);
PeakInd(mLInd)=PeakInd(mLInd)-1;

mR=Khi(:,3)<Khi(:,2)&Khi(:,2)<Khi(:,1);
mRInd=find(mR);
mRN=size(mRInd,1);
PeakInd(mRInd)=PeakInd(mRInd)+1;

mG=Khi(:,3)>Khi(:,2)&Khi(:,2)<Khi(:,1);
mGInd=find(mG);
mGN=size(mGInd,1);
ProcessInd=sort([mLInd,mRInd]);
end;
toc
tic;
for i=1:PeakIndN;
    p(i,:)=polyfit([-FineInterpN,0,FineInterpN],Khi(i,:),2);
end;
Shift=-0.5*p(:,2)./p(:,1);
NShift=round(Shift);
dtau=Shift*tau/FineInterpN;
KhiFit=p(:,1).*Shift(:).^2+p(:,2).*Shift(:)+p(:,3);



for i=PeakIndN;
 Sums4F(i)=sum(trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN).*FitPulses(:,NShift(i)+FineInterpN+1));
end;
    
    AF=(FitN*Sums4F(:)-Sums3(:,2)*Sums1)./(FitN*Sums2-Sums1^2);
    BF=(Sums3(:,2)-AF(:)*Sums1)/FitN;
    KhiF=(Sums5(:,2)+(AF(:).^2).*Sums2+FitN*BF(:).^2+2*AF(:).*BF(:)*Sums1-2*AF(:).*Sums4F(:)-2*BF(:).*Sums3(:,2))./(FitN*AF(:).^2);

toc

for i=1:PeakIndN
fg=figure;
subplot(2,1,1)
plot(1:FitN,trek(PeakInd(i)-StPMaxInd+1:PeakInd(i)-StPMaxInd+FitN),'.b-');
grid on; hold on;
plot(1:FitN,A(i,2)*FitPulse+B(i,2),'.r-');
plot(1:FitN,AF(i)*FitPulses(:,NShift(i)+FineInterpN+1)+BF(i),'og-');
subplot(2,1,2)
plot(1:3,Khi(i,:),'*r-');
hold on; grid on;
x=[1:1/FineInterpN:3];
x1=[-FineInterpN:FineInterpN];
plot(x,p(i,1)*x1.^2+p(i,2)*x1+p(i,3),'ob-');
plot([Shift(i)/FineInterpN+2,Shift(i)/FineInterpN+2],[0,KhiFit(i)],'r-');
plot([NShift(i)/FineInterpN+2,NShift(i)/FineInterpN+2],[0,KhiF(i)],'m-');
pause;
close(fg);
end;

figure;
plot(trek,'b-');
hold on;grid on;
plot(PeakInd,AF(:)+BF(:),'>r');
plot(PeakInd,BF(:),'<g');

%  figure;
%  hold on;grid on;
%  for i=1:PeakIndN
%      plot(1:3,Khi(i,:),'b-');
%  end;  
% fprintf('=====  Found pulses      ==========\n');
% fprintf('The number of measured points  = %7.0f during %7.0f us \n',trekSize,trekSize*tau);
% fprintf('The total number of peaks = %7.0f \n',PeakN);
% for Pass=1:PassNumber
%     disp(['   The number of peaks found in pass # ', num2str(Pass), '  = ',num2str(PeakNumber(Pass))]);
% end;
% 
% 
% fprintf('Last threshold = %7.0f \n',PeakSet.Threshold);
% CloseGraphs;
disp('========Get Peaks finished');



 