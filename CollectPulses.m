function [Stp,FIT]=CollectPulses(Pulses)
Npulse=size(Pulses,2);
N=size(Pulses,1);
Stp=zeros(N*Npulse,1);

Stp(1:Npulse,1)=[1:size(Pulses,2)];
Stp(1:Npulse,2)=Pulses(1,:);
FIT=zeros(N,3);
FIT(1,:)=[0,1,0];

for i=2:size(Pulses,1)
    tic;
    fprintf('%2d ',i);
    Fit=FitOneToAnother(Stp(1:(i-1)*Npulse,:),Pulses(i,:),0,0,12);
    FittedPulse(:,1)=[1:Npulse]+Fit.Shift;
    FittedPulse(:,2)=Fit.A*Pulses(i,:)+Fit.B;
    FIT(i,:)=[Fit.Shift,Fit.A,Fit.B];
    Stp(1+(i-1)*Npulse:i*Npulse,:)=FittedPulse;
    assignin('base','Stp',Stp);
    assignin('base','Fit',FIT);
    toc;
end;
Stp=sortrows(Stp);
