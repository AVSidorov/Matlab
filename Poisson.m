function [A1,A2,W1,W2,K]=Poisson(FileName);
%[A1,Amain,W1,W2,K]=Poisson(FileName);  FileName is a histogram file
%Fit calibration spectra
%A1 - amplitude of the first peak, 
%Amain - amplitude of the second (main) peak, 
%W1 - counts for the first peak maximum, 
%Wmain - counts for the second peak maximum, 
%K=2*W1/Sigma1^2=2*Wmain/SigmaMain^2;  Sigma - half width of the peaks

W1Rad=5.989;
W2Rad=5.887;
W3Rad=6.490;
%W3Rad=2.956;   % keV,   energy of the Ar excited line 3.2-0.247 Fe-Kalpha Ar Radiation
W4Rad=3.2;      % keV,   energy escape Peak by manual fit;
WmainRad=5.9;   % keV,   energy of the Fe line 
if isstr(FileName) Spectr=load(FileName);  else  Spectr=FileName;  end; 
ZeroBool=Spectr(:,2)==0; 
Spectr(ZeroBool,:)=[]; 
NumPeaks=sum(Spectr(:,2)); 
% First approximation data
Amain=max(Spectr(:,2)); 
Ind=find(Amain==Spectr(:,2));
Ind=fix(mean(Ind)); 

W1=Spectr(Ind,1); 
Sigma1=0.15*W1; 


% Borders for fitting the main peak
LowerBorder=min(Spectr(:,1)); HighBorder=max(Spectr(:,1)); 






key='s';
hp=figure; 
if isstr(FileName); 
    set(hp,'name',FileName );
end;
while key=='r'|'R'
    if key~='s'
        fprintf('A1=%3.0f:   ', A1);
        Inp= input('Insert the main peak amplitude\n');  
        if not(isempty(Inp)) A1=Inp ;    end;
        
        fprintf('W1=%3.0f:   ', W1);        
        Inp = input('Insert the main peak position\n');  
        if not(isempty(Inp)) W1=Inp ;    end;
        
        fprintf('Sigma1=%3.0f:   ', Sigma1);        
        Inp = input('Insert main peak halfwidth\n'); 
        if not(isempty(Inp)) Sigma1=Inp ;    end;

        fprintf('Lower border=%3.0f:   ', LowerBorder);                
        Inp = input('Insert lower border for fitting\n'); 
        if not(isempty(Inp)) LowerBorder=Inp ;    end;

        fprintf('High border =%3.0f:   ', HighBorder);                
        Inp = input('Insert lower border for fitting\n'); 
        if not(isempty(Inp)) HighBorder=Inp ;    end;
        
%         fprintf('A4=%3.0f:   ', A4);                
%         Inp = input('Insert the second peak amplitude\n');  
%         if not(isempty(Inp)) A4=Inp ;    end;
       
%         W4=Wmain*W3Rad/WmainRad;
%         Sigma4=SigmaMain*sqrt(W4/Wmain);
    end;
    hold off; 
    plot(Spectr(:,1),Spectr(:,2),'-ro'); grid on; hold on; 
    x=[LowerBorder, LowerBorder]; y=[0,max(Spectr(:,2))]; 
    plot(x,y,'-m');
    x=[HighBorder, HighBorder];
    plot(x,y,'-m');

    K=2*W1/Sigma1^2;

  
    W2=W1*W2Rad/W1Rad;
    W3=W1*W3Rad/W1Rad;
    W4=W1*W4Rad/W1Rad;


    BorderBool=(Spectr(:,1)>=LowerBorder)&(Spectr(:,1)<=HighBorder);

    A1=P1(Spectr(BorderBool,:),W1,K)/P2(Spectr(BorderBool,:),W1,K);  %

    A2=A1*0.5;
    A3=A1*0.16;
    A4=A1*0.2;


    FitSpec1=A1*SpectrFit(Spectr(:,1),W1,K);
    FitSpec2=A2*SpectrFit(Spectr(:,1),W2,K);
    FitSpec3=A3*SpectrFit(Spectr(:,1),W3,K);
    FitSpec4=A4*SpectrFit(Spectr(:,1),W4,K);
    FitSpecS=FitSpec1+FitSpec2+FitSpec3+FitSpec4;

    
    
    plot(Spectr(:,1),FitSpec1,'-b'); 
    plot(Spectr(:,1),FitSpec2,'-c'); 
    plot(Spectr(:,1),FitSpec3,'-g'); 
    plot(Spectr(:,1),FitSpec4,'-k'); 
    plot(Spectr(:,1),FitSpecS,'-m','LineWidth',1.5); 
    title('Press ''R'' to input new data or any key to continue'); 
    key=input('press a key to continue or ''r'' to reapeat the input  \n ','s'); 
end; 

K=2*W1/Sigma1^2;

%fitting procedures
Knum=15;        Wnum=25; 
Krange=1.5*K;   Wrange=2*Sigma1; 
BorderBool=(Spectr(:,1)>=LowerBorder)&(Spectr(:,1)<=HighBorder);
NumSpectrPoints=size(Spectr(BorderBool,1),1); 
Kstep=Krange/(Knum-1); Wstep=Wrange/(Wnum-1);
Wset=(W1-Wrange/2:Wstep:W1+Wrange/2);

% Khi min search
subplot(2,1,2); grid on; hold on; 
for j=1:Wnum
    Kset=(K-Krange/2:Kstep:K+Krange/2); 
    for i=1:Knum
           A1=P1(Spectr(BorderBool,:),Wset(j),Kset(i))/P2(Spectr(BorderBool,:),Wset(j),Kset(i));  %
           S(i)=KhiSquare(Spectr(BorderBool,:),A1,Wset(j),Kset(i))/NumSpectrPoints;   %
    end;
    %search along the K direction
    Kset(isnan(S))=[]; 
    S(isnan(S))=[]; 
    plot(sqrt(2*Wset(j)./Kset),S);
    Ind=find(S==min(S)); 
    Kmin=Kset(Ind); 
    poly = polyfit(Kset-Kmin,S,4); 
    KsetP=(K-Krange/2:Kstep/20:K+Krange/2);
    polyset=poly(1)*(KsetP-Kmin).^4+poly(2)*(KsetP-Kmin).^3+poly(3)*(KsetP-Kmin).^2+poly(4)*(KsetP-Kmin)+poly(5);
    Ind=find(polyset==min(polyset)); 
    MinKhi2(j)=polyset(Ind);
    KminExact(j)=KsetP(Ind);
end; 
%search along the W direction
Ind=find(MinKhi2==min(MinKhi2)); 
Kmin=KminExact(Ind);    Wmain=Wset(Ind);    
poly = polyfit(Wset(Ind-2:Ind+2)-Wmain,MinKhi2(Ind-2:Ind+2),4); 
WsetP=(Wmain-Wstep:Wstep/20:Wmain+Wstep);
polyset=poly(1)*(WsetP-Wmain).^4+poly(2)*(WsetP-Wmain).^3+poly(3)*(WsetP-Wmain).^2+poly(4)*(WsetP-Wmain)+poly(5);
Ind=find(polyset==min(polyset)); 
AbsMinKhi2=polyset(Ind);
if (AbsMinKhi2<0)|(AbsMinKhi2>min(MinKhi2)) 
    AbsMinKhi2=min(MinKhi2); else   W1=WsetP(Ind);   end;    



KminW=Kmin*Wmain/WmainRad;
A1=P1(Spectr(BorderBool,:),W1,Kmin)/P2(Spectr(BorderBool,:),W1,Kmin);
Sigma1=sqrt(2*Wmain/Kmin); %%%%%SigmaMain=2*sqrt(Wmain/Kmin);
Sigma1W=Sigma1*W1Rad/W1;

W2=W1*W2Rad/W1Rad;
W3=W1*W3Rad/W1Rad;
W4=W1*W4Rad/W1Rad;

A2=A1*0.5;
A3=A1*0.16;
A4=A1*0.2;

FitSpec1=A1*SpectrFit(Spectr(:,1),W1,Kmin);
FitSpec2=A2*SpectrFit(Spectr(:,1),W2,Kmin);
FitSpec3=A3*SpectrFit(Spectr(:,1),W3,Kmin);
FitSpec4=A4*SpectrFit(Spectr(:,1),W4,Kmin);
FitSpecS=FitSpec1+FitSpec2+FitSpec3+FitSpec4;


%Energy spectrum 
% Spectr(:,4)=Spectr(:,1)*WmainRad/Wmain;      % energy
% Spectr(:,5)=Spectr(:,2)/NumPeaks;      % Norm numbers
% Spectr(:,6)=Spectr(:,3)/NumPeaks;      % Norm errors
% Spectr(:,7)=Amain*SpectrFit(Spectr(:,4),WmainRad,KminW)/NumPeaks; % Norm main Poisson
% Spectr(:,8)=Amain*Gauss(Spectr(:,4),WmainRad,SigmaMainW)/NumPeaks;   % Norm main Gauss
% Spectr(:,9)=A1*SpectrFit(Spectr(:,4),W1Rad,KminW)/NumPeaks; % Norm side Poisson
% NaNind=isnan(Spectr); 
% Spectr(NaNind)=0; 
%Saving in file
% if isstr(FileName)
%     fid=fopen(FileName,'w'); 
%     fprintf(fid,'%6.2f %3.0f %5.2f %6.3f %6.4f %6.4f %6.4f %6.4f %6.4f\n' ,Spectr');
%     fclose(fid);    
% end;


fprintf('begin=begin=begin=begin=begin=begin=begin=begin=begin=begin=begin=begin\n'); 
% fprintf('W4=%3.3f counts or 3.2 keV\n', W1);
% fprintf('Sigma1=%3.3f counts or %3.3f keV\n', Sigma1, Sigma1*W1Rad/W1); 
% fprintf('A4=%3.3f\n ',A1);
fprintf('------------\n');
fprintf('Wmain=%3.3f counts or 5.9 keV\n', W1);
fprintf('SigmaMain=%3.3f counts or %3.3f keV or %3.1f %%\n', Sigma1, Sigma1W, 100*Sigma1/W1); 
fprintf('Amain=%3.3f\n',A1);
fprintf('AbsMinKhi2=%3.3f  \n',AbsMinKhi2);
fprintf('++++++++++++\n');
fprintf('PoissonCoef=%3.3f 1/count or %3.3f 1/keV\n', Kmin, KminW); 
fprintf('++++++++++++\n');
fprintf('Lower border of fitting interval= %3.0f counts or %3.3f keV\n', LowerBorder, LowerBorder*W1Rad/W1); 
fprintf('High border of fitting interval= %3.0f counts or %3.3f keV\n', HighBorder, HighBorder*W1Rad/W1); 
fprintf('end=end=end=end=end=end=end=end=end=end=end=end\n'); 


subplot(2,1,1); plot(Spectr(:,1),Spectr(:,2),'-ro'); grid on; hold on; 
                x=[LowerBorder, LowerBorder]; y=[0,A1];   plot(x,y,'-m');
                x=[HighBorder, HighBorder];                  plot(x,y,'-m');
                x=[Wset(1),Wset(1)];                         plot(x,y,'-r')
                x=[Wset(end),Wset(end)];                     plot(x,y,'-r')                
                x=[W1,W1];                             plot(x,y,'-r');               
                y=y/exp(2); 
                x=[W1-Sigma1,W1-Sigma1];         plot(x,y,'-g');
                x=[W1+Sigma1,Wmain+Sigma1];         plot(x,y,'-g');
                y=[A1,A1]/exp(1);
                x=[W1-Sigma1,W1+Sigma1];         plot(x,y,'-g');
                x=Spectr(:,1);               
                plot(Spectr(:,1),FitSpec1,'-b'); 
                plot(Spectr(:,1),FitSpec2,'-c'); 
                plot(Spectr(:,1),FitSpec3,'-g'); 
                plot(Spectr(:,1),FitSpec4,'-k'); 
                plot(Spectr(:,1),FitSpecS,'-m','LineWidth',1.5); 
                plot(x,A1*Gauss(x,W1,Sigma1),'-k');  

                xlabel('counts'); ylabel('numbers'); 
                TitleText=['Amain=',num2str(A1,'%6.2f'),'; Wmain=',num2str(W1,'%6.2f'),'cnts (5.9 keV); Sigma=',...
                           num2str(Sigma1,'%6.2f'),' cnts (',num2str(Sigma1W,'%6.2f'),' keV)=',...
                           num2str(100*Sigma1/W1,'%6.2f'),'%' ]; 
                title(TitleText);
subplot(2,1,2); 
                x=[Sigma1, Sigma1];
                y=[0,AbsMinKhi2];   
                plot(x,y,'-m');
                xlabel('Sigma'); ylabel('Khi^2'); 
                TitleText=['PoissonCoef =',num2str(Kmin,'%6.2f'),' 1/cnts = ',...
                           num2str(KminW,'%6.2f'),' 1/keV; Khi^2 = ',num2str(AbsMinKhi2,'%6.3f')]; 
                title(TitleText);                



%=================================
function y=SpectrFit(x,W0,K);   % Poisson distribution
X=K*x+1; X0=K*W0+1; 
y=X;
LargeBool=(X>20)&(X0>20);
if not(isempty(y(LargeBool)))
    XX=X(LargeBool);
    y(LargeBool)=(1+1/12/X0-1/12./XX).*exp(XX-X0).*(X0./XX).^(XX+1/2);
end; 
if not(isempty(y(not(LargeBool))))
    XX=X(not(LargeBool));
    y(not(LargeBool))=(X0-1).^(XX-X0).*gamma(X0)./gamma(XX);
end; 
    
function s=KhiSquare(H,A,W0,K);
    W1Rad=5.989;
    W2Rad=5.887;
    W3Rad=6.490;
    W4Rad=3.2;

    W1=W0;
    W2=W0*W2Rad/W1Rad;
    W3=W0*W3Rad/W1Rad;
    W4=W0*W4Rad/W1Rad;
    FitSpec1=SpectrFit(H(:,1),W1,K);
    FitSpec2=0.5*SpectrFit(H(:,1),W2,K);
    FitSpec3=0.16*SpectrFit(H(:,1),W3,K);
    FitSpec4=0.2*SpectrFit(H(:,1),W4,K);
    FitSpecS=FitSpec1+FitSpec2+FitSpec3+FitSpec4;
    s=sum(((H(:,2)-A*FitSpecS)./H(:,3)).^2);
function s=P1(H,W0,K); 
    W1Rad=5.989;
    W2Rad=5.887;
    W3Rad=6.490;
    W4Rad=3.2;

    W1=W0;
    W2=W0*W2Rad/W1Rad;
    W3=W0*W3Rad/W1Rad;
    W4=W0*W4Rad/W1Rad;
    FitSpec1=SpectrFit(H(:,1),W1,K);
    FitSpec2=0.5*SpectrFit(H(:,1),W2,K);
    FitSpec3=0.16*SpectrFit(H(:,1),W3,K);
    FitSpec4=0.2*SpectrFit(H(:,1),W4,K);
    FitSpecS=FitSpec1+FitSpec2+FitSpec3+FitSpec4;
    s=sum(H(:,2).*FitSpecS./H(:,3).^2);
function s=P2(H,W0,K); 
    W1Rad=5.989;
    W2Rad=5.887;
    W3Rad=6.490;
    W4Rad=3.2;
    W1=W0;
    W2=W0*W2Rad/W1Rad;
    W3=W0*W3Rad/W1Rad;
    W4=W0*W4Rad/W1Rad;
    FitSpec1=SpectrFit(H(:,1),W1,K);
    FitSpec2=0.5*SpectrFit(H(:,1),W2,K);
    FitSpec3=0.16*SpectrFit(H(:,1),W3,K);
    FitSpec4=0.2*SpectrFit(H(:,1),W4,K);
    FitSpecS=FitSpec1+FitSpec2+FitSpec3+FitSpec4;
    s=sum((FitSpecS./H(:,3)).^2);
function y=Gauss(W,W0,DW); 
y=exp(-((W-W0)/DW).^2);

