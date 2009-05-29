function [MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(trek,OverStd,Plot);    
% search the signal pedestal of trek and make it zero
% trek - input measurements  [N,1] array, 
% OverStd - exceed of sdt 
% Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array

if nargin<2;   OverStd=3;   end; 
if nargin<3;   Plot=true;   end;  
   


% find first max(Histogram(trF))for trF   !!!!!!!!! This is the  zero  level! 

trSize=size(trek(:,1),1); %  (N,1) dimension

Noise=true(trSize,1);
M =mean(trek); Std=std(trek);
% Positive=size(find(trek-(M+5*Std)>0),1);  
% Negative=size(find(trek-(M-5*Std)<0),1); 
% if Positive>Negative; PeakPolarity=1; else PeakPolarity=-1;  end; 
PeakPolarity=1;
MaxVal=max(trek); MinVal=min(trek); DeltaM=MaxVal-MinVal;
DeltaS=1e20;
NoisePoints=size(find(Noise),1); 
if Plot;    figure; 
    plot(trek); hold on; grid on;
end; 
cmap =['k','r','m','y','g','b','c']';
DeltaRel=0.1;
while DeltaS>DeltaRel
    cmap=circshift(cmap,-1);   Mark=['-',cmap(1)];
    M =[M,mean(trek(Noise))];    Std=[Std,std(trek(Noise))]; 
    L=length(M);    
    %if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
    if L>2;  DeltaS=abs(Std(L)-Std(L-1))/Std(L-1);  else     DeltaS=10;    end; 
    NoiseLevel=PeakPolarity*OverStd*Std(L);    
    Noise=(abs(trek-M(L))<NoiseLevel); 
    %if Plot; plot(M(L)+(1-Noise)*OverStd*Std(L), Mark);    end; 
    NoisePoints=[NoisePoints,size(find(Noise),1)]; 
end; 
    %NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
    %NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
    %SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
    %Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array

Signal=not(Noise);    
% if PeakPolarity==1; Noise(not(Noise)&(trek<0))=1; else 
%                     Noise(not(Noise)&(trek>0))=1;end;  %(abs(M(L)-trek)<OverStd*Std(L));    
if Plot;  plot(M(L)+(1-Noise)*OverStd*Std(L), '-r','LineWidth',2);    end; 
MeanVal=M(L); StdVal=Std(L); 
%M(1)=[];  Std(1)=[]; L=L-1; 
if Plot
    figure;
    subplot(3,1,1); plot(M-M(L),'-or');  grid on; title('means');
    subplot(3,1,2); plot(Std,'-*b'); grid on;  title('Std''s');
    subplot(3,1,3); plot(NoisePoints,'-or'); grid on;  title('Noise points');
    
end;
