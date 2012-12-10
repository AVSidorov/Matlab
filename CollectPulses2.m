function [Stp,FIT]=CollectPulses2(Pulses,STP)
Npulse=size(Pulses,2);
N=size(Pulses,1);
Stp=zeros(N*Npulse,2);

FIT=zeros(N,3);


for i=1:N
    tic;
    fprintf('%2d ',i);
    Fit=FitOneToAnother(Pulses(i,:),STP,0,0,10);
    FittedPulse(:,1)=[1:Npulse]+Fit.Shift;
    FittedPulse(:,2)=Fit.A*Pulses(i,:)+Fit.B;
    FIT(i,:)=[Fit.Shift,Fit.A,Fit.B];
    Stp(1+(i-1)*Npulse:i*Npulse,:)=FittedPulse;
    assignin('base','Stp',Stp);
    assignin('base','Fit',FIT);
    toc;
end;
Stp=sortrows(Stp);
