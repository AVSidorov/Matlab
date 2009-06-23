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
% WmainRad=5.9;   % keV,   energy of the Fe line 
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

W4=W1*W4Rad/W1Rad;


% Borders for fitting the main peak
LowerBorder=min(Spectr(:,1)); HighBorder=max(Spectr(:,1)); 
LowerBorder1=min(Spectr(:,1)); HighBorder1=max(Spectr(:,1)); 






key='s';
hp=figure; 
if isstr(FileName); 
    set(hp,'name',FileName );
end;
while key=='r'|'R'
    if key~='s'
%         fprintf('A1=%3.0f:   ', A1);
%         Inp= input('Insert the main peak amplitude\n');  
%         if not(isempty(Inp)) A1=Inp ;    end;
        
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

        fprintf('W4=%3.0f:   ', W4);        
        Inp = input('Insert the escape peak position\n');  
        if not(isempty(Inp)) W4=Inp ;    end;
        
        fprintf('Lower border=%3.0f:   ', LowerBorder1);                
        Inp = input('Insert lower border for fitting escape\n'); 
        if not(isempty(Inp)) LowerBorder1=Inp ;    end;

        fprintf('High border =%3.0f:   ', HighBorder1);                
        Inp = input('Insert lower border for fitting escape\n'); 
        if not(isempty(Inp)) HighBorder1=Inp ;    end;

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

    x=[LowerBorder1, LowerBorder1]; y=[0,max(Spectr(:,2))]; 
    plot(x,y,'-c');
    x=[HighBorder1, HighBorder1];
    plot(x,y,'-c');

    K=2*W1/Sigma1^2;
 
    % Sigma1=SigmaMain*sqrt(W1/Wmain);
  
    W2=W1*W2Rad/W1Rad;
    W3=W1*W3Rad/W1Rad;

    FitSpec1=SpectrFit(Spectr(:,1),W1,K);
    FitSpec2=0.5*SpectrFit(Spectr(:,1),W2,K);
    FitSpec3=0.16*SpectrFit(Spectr(:,1),W3,K);
    FitSpec4=SpectrFit(Spectr(:,1),W4,K);
    FitSpecS=FitSpec1+FitSpec2+FitSpec3;

    
    BorderBool=(Spectr(:,1)>=LowerBorder)&(Spectr(:,1)<=HighBorder);

    A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %

   
    BorderBool=(Spectr(:,1)>=LowerBorder1)&(Spectr(:,1)<=HighBorder1);

    A4=P1(Spectr(BorderBool,:),FitSpec4(BorderBool))/P2(Spectr(BorderBool,:),FitSpec4(BorderBool));  %

    
   
    
    plot(Spectr(:,1),A1*FitSpec1,'-b'); 
    plot(Spectr(:,1),A1*FitSpec2,'-c'); 
    plot(Spectr(:,1),A1*FitSpec3,'-g'); 
    plot(Spectr(:,1),A4*FitSpec4,'-k'); 
    plot(Spectr(:,1),A1*FitSpecS+A4*FitSpec4,'-m','LineWidth',1.5); 
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
           W1=Wset(j);
           W2=W1*W2Rad/W1Rad;
           W3=W1*W3Rad/W1Rad;
           FitSpec1=SpectrFit(Spectr(:,1),W1,Kset(i));
           FitSpec2=0.5*SpectrFit(Spectr(:,1),W2,Kset(i));
           FitSpec3=0.16*SpectrFit(Spectr(:,1),W3,Kset(i));
           FitSpec4=SpectrFit(Spectr(:,1),W4,Kset(i));         
           FitSpecS=FitSpec1+FitSpec2+FitSpec3;          
           A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %
           FitSpecS=FitSpec1+FitSpec2+FitSpec3+(A4/A1)*FitSpec4;
           A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %
           FitSpecS=A1*FitSpec1+A1*FitSpec2+A1*FitSpec3+A4*FitSpec4;
           S(i)=KhiSquare(Spectr(BorderBool,:),FitSpecS(BorderBool))/NumSpectrPoints;   %
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

Kmin=KminExact(Ind);    
W1=Wset(Ind);    
           W2=W1*W2Rad/W1Rad;
           W3=W1*W3Rad/W1Rad;

           
poly = polyfit(Wset(Ind-2:Ind+2)-W1,MinKhi2(Ind-2:Ind+2),4); 
WsetP=(W1-Wstep:Wstep/20:W1+Wstep);
polyset=poly(1)*(WsetP-W1).^4+poly(2)*(WsetP-W1).^3+poly(3)*(WsetP-W1).^2+poly(4)*(WsetP-W1)+poly(5);
Ind=find(polyset==min(polyset)); 
AbsMinKhi2=polyset(Ind);
if (AbsMinKhi2<0)|(AbsMinKhi2>min(MinKhi2)) 
    AbsMinKhi2=min(MinKhi2); else   W1=WsetP(Ind);   end;    

FitSpec1=SpectrFit(Spectr(:,1),W1,Kmin);
FitSpec2=0.5*SpectrFit(Spectr(:,1),W2,Kmin);
FitSpec3=0.16*SpectrFit(Spectr(:,1),W3,Kmin);
FitSpecS=FitSpec1+FitSpec2+FitSpec3;
A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %


Sigma4=sqrt(2*W4/Kmin);
Wrange=2*Sigma4; 
BorderBool1=(Spectr(:,1)>=LowerBorder1)&(Spectr(:,1)<=HighBorder1);
NumSpectrPoints1=size(Spectr(BorderBool1,1),1); 
Wstep=Wrange/(Wnum-1);
W4set=(W4-Wrange/2:Wstep:W4+Wrange/2);
for j=1:Wnum
           FitSpec4=SpectrFit(Spectr(:,1),W4set(j),Kmin);
           A4=P1(Spectr(BorderBool1,:),FitSpec4(BorderBool1))/P2(Spectr(BorderBool1,:),FitSpec4(BorderBool1));  %
           FitSpecS=A1/A4*FitSpec1+A1/A4*FitSpec2+A1/A4*FitSpec3+FitSpec4;
           A4=P1(Spectr(BorderBool1,:),FitSpecS(BorderBool1))/P2(Spectr(BorderBool1,:),FitSpecS(BorderBool1));  %
           FitSpecS=A1*FitSpec1+A1*FitSpec2+A1*FitSpec3+A4*FitSpec4;
           S(j)=KhiSquare(Spectr(BorderBool1,:),FitSpecS(BorderBool1))/NumSpectrPoints1;   %
end; 
%search along the W direction
[MinKhi2,MinKhi2Ind]=min(S);
Wfit=[W4set(MinKhi2Ind-1):Wstep/100:W4set(MinKhi2Ind+1)];
SFine=interp1(W4set(MinKhi2Ind-1:MinKhi2Ind+1),S(MinKhi2Ind-1:MinKhi2Ind+1),Wfit,'spline');
[MinKhi2,MinKhi2Ind]=min(SFine);
W4=Wfit(MinKhi2Ind);

FitSpec1=SpectrFit(Spectr(:,1),W1,Kmin);
FitSpec2=0.5*SpectrFit(Spectr(:,1),W2,Kmin);
FitSpec3=0.16*SpectrFit(Spectr(:,1),W3,Kmin);
FitSpec4=SpectrFit(Spectr(:,1),W4,Kmin);
FitSpecS=FitSpec1+FitSpec2+FitSpec3;

A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %
A4=P1(Spectr(BorderBool1,:),FitSpec4(BorderBool1))/P2(Spectr(BorderBool1,:),FitSpec4(BorderBool1));  %


FitSpecS=A1/A4*FitSpec1+A1/A4*FitSpec2+A1/A4*FitSpec3+FitSpec4;
A4=P1(Spectr(BorderBool1,:),FitSpecS(BorderBool1))/P2(Spectr(BorderBool1,:),FitSpecS(BorderBool1));  %

FitSpecS=FitSpec1+FitSpec2+FitSpec3+A4/A1*FitSpec4;
A1=P1(Spectr(BorderBool,:),FitSpecS(BorderBool))/P2(Spectr(BorderBool,:),FitSpecS(BorderBool));  %




KminW=Kmin*W1/W1Rad;

Sigma1=sqrt(2*W1/Kmin); %%%%%SigmaMain=2*sqrt(Wmain/Kmin);
Sigma1W=Sigma1*W1Rad/W1;

FitSpecS=A1*FitSpec1+A1*FitSpec2+A1*FitSpec3+A4*FitSpec4;

[Amain,WmainI]=max(FitSpecS);
Wmain=Spectr(WmainI,1);
WmainW=W1Rad*Wmain/W1;
W4W=W1Rad*W4/W1;


SigmaMain=Sigma1*sqrt(Wmain/W1);
SigmaMainW=SigmaMain*WmainW/Wmain;

Bool=(Spectr(:,1)>=W4+Sigma1)&(Spectr(:,1)<=Wmain);
w1=interp1(FitSpecS(Bool),Spectr(Bool,1),Amain/2);
Bool=(Spectr(:,1)>=Wmain);
w2=interp1(FitSpecS(Bool),Spectr(Bool,1),Amain/2);

w1W=W1Rad*w1/W1;
w2W=W1Rad*w2/W1;


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
fprintf('W1=%3.3f counts or 5.989 keV\n', W1);
fprintf('Wmain=%3.3f counts or %3.3f keV\n',Wmain,WmainW);
fprintf('W4=%3.3f counts or %3.3f keV\n',W4,W4W);

fprintf('Sigma1=%3.3f counts or %3.3f keV or %3.1f %%\n', Sigma1, Sigma1W, 100*Sigma1/W1); 
fprintf('SigmaMain=%3.3f counts or %3.3f keV or %3.1f %%\n', SigmaMain, SigmaMainW, 100*SigmaMain/Wmain); 
fprintf('FWHM=%3.3f counts or %3.3f keV or %3.1f %%\n', w2-w1, w2W-w1W, 100*(w2W-w1W)/WmainW); 
fprintf('A1=%3.3f\n',A1);
fprintf('A4=%3.3f\n',A4);
fprintf('Amain=%3.3f\n',Amain);
fprintf('AbsMinKhi2=%3.3f  \n',AbsMinKhi2);
fprintf('++++++++++++\n');
fprintf('PoissonCoef=%3.3f 1/count or %3.3f 1/keV\n', Kmin, KminW); 
fprintf('++++++++++++\n');
fprintf('Lower border of fitting interval= %3.0f counts or %3.3f keV\n', LowerBorder, LowerBorder*W1Rad/W1); 
fprintf('High border of fitting interval= %3.0f counts or %3.3f keV\n', HighBorder, HighBorder*W1Rad/W1); 
fprintf('end=end=end=end=end=end=end=end=end=end=end=end\n'); 


subplot(2,1,1); plot(Spectr(:,1),Spectr(:,2),'-ro'); grid on; hold on; 
                
                x=[LowerBorder, LowerBorder]; y=[0,Amain];      plot(x,y,'-y');
                x=[HighBorder, HighBorder];                  plot(x,y,'-y');
                x=[Wset(1),Wset(1)];                         plot(x,y,'-r')
                x=[Wset(end),Wset(end)];                     plot(x,y,'-r')
                
                x=[LowerBorder1, LowerBorder1]; y=[0,Amain];      plot(x,y,'-y');
                x=[HighBorder1, HighBorder1];                  plot(x,y,'-y');
                x=[W4set(1),W4set(1)];                         plot(x,y,'-r')
                x=[W4set(end),W4set(end)];                     plot(x,y,'-r')                
                
                x=[Wmain,Wmain];                             plot(x,y,'-m');               
                
                y=[0,A1]/exp(1); 
%                 x=[W1-Sigma1,W1-Sigma1];            plot(x,y,'-b');
%                 x=[W1+Sigma1,W1+Sigma1];            plot(x,y,'-b');
                y=[A1,A1]/exp(1);
%                 x=[W1-Sigma1,W1+Sigma1];            plot(x,y,'-b');
                
                y=[0,Amain]/exp(1); 
                x=[Wmain-SigmaMain,Wmain-SigmaMain];            plot(x,y,'-m');
                x=[W1+SigmaMain,W1+SigmaMain];                  plot(x,y,'-m');
                y=[Amain,Amain]/exp(1);
                x=[Wmain-SigmaMain,Wmain+SigmaMain];            plot(x,y,'-m');

                y=[0,Amain/2]; 
                x=[w1,w1];            plot(x,y,'-r','LineWidth',1.5);
                x=[w2,w2];            plot(x,y,'-r','LineWidth',1.5);
                y=[Amain/2,Amain/2]; 
                x=[w1,w2];            plot(x,y,'-r','LineWidth',1.5);
                
                x=Spectr(:,1);               
                plot(Spectr(:,1),A1*FitSpec1,'-b','LineWidth',2); 
                plot(Spectr(:,1),A1*FitSpec2,'-c','LineWidth',2); 
                plot(Spectr(:,1),A1*FitSpec3,'-g','LineWidth',2); 
                plot(Spectr(:,1),A4*FitSpec4,'-k','LineWidth',2); 
                plot(Spectr(:,1),FitSpecS,'-m','LineWidth',3); 
                plot(x,Amain*Gauss(x,Wmain,SigmaMain),'-k');  

                xlabel('counts'); ylabel('numbers'); 
%                 'A1=',num2str(A1,'%6.2f'),'; W1=',num2str(W1,'%6.2f'),'cnts (5.989 keV); Sigma1=',...
%                            num2str(Sigma1,'%6.2f'),' cnts (',num2str(Sigma1W,'%6.2f'),' keV)=',...
%                            num2str(100*Sigma1/W1,'%6.2f'),'%',... 
                TitleText=['Amain=',num2str(Amain,'%6.2f'),'; Wmain=',num2str(Wmain,'%6.2f'),'cnts (',num2str(WmainW,'%6.2f'),...
                           'keV); SigmaMain=', num2str(SigmaMain,'%6.2f'),' cnts (',num2str(SigmaMainW,'%6.2f'),' keV)=',...
                           num2str(100*SigmaMain/Wmain,'%6.2f'),'%; FWHM=',num2str(w2-w1,'%6.2f'),...
                           ' cnts (',num2str(w2W-w1W,'%6.2f'),' keV)=',...
                           num2str(100*(w2W-w1W)/WmainW,'%6.2f'),'%']; 
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
y=Poisson_distr(K,W0,x);    

function s=KhiSquare(HSpec,FitSpec);
    s=sum(((HSpec(:,2)-FitSpec)./HSpec(:,3)).^2);
    
function s=P1(HSpec,FitSpec); 
    s=sum(HSpec(:,2).*FitSpec./HSpec(:,3).^2);

function s=P2(HSpec,FitSpec); 
    s=sum((FitSpec./HSpec(:,3)).^2);

function y=Gauss(W,W0,DW); 
y=exp(-((W-W0)/DW).^2);

