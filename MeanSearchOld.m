function [MeanVal,StdVal,PP,Noise]=MeanSearchOld(tr,OverSt,Noise);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array

trSize=size(tr,1); %  (N,1) dimension

M =mean(tr(:)); St=std(tr(:));  
Positive=size(find(tr(:)-(M+5*St)>0),1);  
Negative=size(find(tr(:)-(M-5*St)<0),1); 
MaxVal=max(tr(:)); MinVal=min(tr(:)); DeltaM=MaxVal-MinVal;  

if Positive>Negative PeakPolarity=1; else PeakPolarity=-1;  end; 

NoisePoints=size(find(Noise),1); 
while DeltaM>0.1
    M =[M,mean(tr(Noise))];  St=[St,std(tr(Noise))];          
    L=length(M);    
    if L>2   DeltaM=abs(M(L)-M(L-1));  else     DeltaM=10;    end; 
    NoiseLevel=M(L)+PeakPolarity*OverSt*St(L);    
    if PeakPolarity==1 Noise=(tr(:)<NoiseLevel); else; Noise=(tr(:)>NoiseLevel); end;  %(abs(M(L)-tr(:,2))<OverSt*St(L));
    NoisePoints=[NoisePoints,size(find(Noise),1)];
    %if St(L)==0 DeltaM=0;end;
end; 
    NoiseL=circshift(Noise,-1);   NoiseL(end)=Noise(end);     
    NoiseR=circshift(Noise,1);    NoiseR(1)=Noise(1);
    SingleNoise=not(Noise)&NoiseR&NoiseL;           %search alone peaks above the NoiseLevel
    Noise(SingleNoise)=true;                        %the alone peaks are brought to the Noise array
    NoiseIndx=find(Noise);
    Noise(1:NoiseIndx(1))=1;  Noise(NoiseIndx(end):end)=1;
    MeanVal=M(L); StdVal=St(L); PP=PeakPolarity;
