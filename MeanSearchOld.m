function [MeanVal,StdVal,PP,Noise]=MeanSearchOld(tr,OverSt,Plot);    
% search the signal pedestal and make it zero
           % Input parameters: tr or trD - input measurements, Over St (see above), Noise - assumed initial noise array  
           % Output parameters: MeanValue, Standad deviation, Pulse polarity, Noise - residual noise array

if nargin<2;   OverSt=3;   end; 
if nargin<3;   Plot=true;   end; 



trSize=size(tr(:,1),1); %  (N,1) dimension
Noise=true(trSize,1);
NoisePoints=size(find(Noise),1); 

M =mean(tr(:)); St=std(tr(:));  
Positive=size(find(tr(:)-(M+5*St)>0),1);  
Negative=size(find(tr(:)-(M-5*St)<0),1); 
MaxVal=max(tr(:)); MinVal=min(tr(:));  

if Positive>Negative 
    PeakPolarity=1;
    tr=tr-M; 
else
    PeakPolarity=-1;
    tr=M-tr;
end; 



DeltaM=abs(M);
DeltaS=1;

while DeltaS|DeltaM>0.1
    M =[M,mean(tr(Noise))];  St=[St,std(tr(Noise))];          
    L=length(M);    
    if L>2   
        DeltaM=abs(M(L)-M(L-1));  
        DeltaS=abs(St(L)-St(L-1))/St(L-1);
%         tr=tr-M(L);
    else
        DeltaM=10;
        DeltaS=10;
    end;
    NoiseLevel=OverSt*St(L);    
    Noise=(tr(:)<NoiseLevel+M(L)); 
    NoisePoints=[NoisePoints,size(find(Noise),1)]; 
end; 

   MeanVal=M(L)+M(1); StdVal=St(L); PP=PeakPolarity;

if Plot
    figure; 
    plot(tr); 
    hold on; grid on;
    plot(M(L)+(1-Noise)*OverSt*St(L), '-r','LineWidth',2);
    figure;
    subplot(3,1,1); plot(M-M(L),'-or');  grid on; title('means');
    subplot(3,1,2); plot(St,'-*b'); grid on;  title('Std''s');
    subplot(3,1,3); plot(NoisePoints,'-or'); grid on;  title('Noise points');
    
end;