function [Flow1,Flow2,Uloop,Etor,Wb,K_W,K_A]=ProcessPeaks(peaks);
MeasAmplf=100;
ClbrAmplf=33.33;
ClbrAmplt=420;
R=0.55;
Flow1=[];
Flow2=[];
Uloop=[];
Etor=[];
Wb=[];
K_W=[];
K_A=[];

peaks=PreparePeaks(peaks);
continuestr='y';
while continuestr=='y'
peaks1=PickTimeIntPeaks(peaks);

MaxTime=max(peaks1(:,2));%peaks(end,2)
MinTime=min(peaks1(:,2));%peaks(1,2)
TimeInt=MaxTime-MinTime;
Time=0.5*(MinTime+MaxTime);

[flow1,flow2,spectr]=AnalyzePeaks(peaks1);


    
assignin('base',['SpecT',num2str(round(Time/1000),'%2.0f'),'Av',num2str(round(TimeInt/1000),'%2.0f')],spectr);

return;
% 
% alpha=input('Input chord angel\n');
% if isempty(alpha)
%     alpha=0;
% end;
% Te=TeByAngelTime(alpha,Time);
% Ne=NeByAngelTime(alpha,Time);
% 
% MaxwTab=MaxwTb('D:\!SCN\EField\maxw\MaxwSpectr.dat ');
% MaxwSpectr=MaxwSpByTe(Te,MaxwTab);
% 
% [k_W,k_A,Wb1]=SpectrFit(spectr,MaxwSpectr,ClbrAmplt,ClbrAmplf,MeasAmplf);
% 
% 
% Et=4*Te*Ne/Wb1^2;
% Ul=Et*2*pi*R;
% fprintf('Uloop is %4.3f V, Etor is %4.3f V/m\n',Ul,Et);
%  Flow1=[Flow1;[Time,flow1]];
%  Flow2=[Flow2;[Time,flow2]];
%  Uloop=[Uloop;[Time,Ul]];
%  Etor=[Etor;[Time,Et]];
%  Wb=[Wb;[Time,Wb1]];
%  K_W=[K_W;[Time,k_W]];
%  K_A=[K_A;[Time,k_A]];
continuestr=input('continue?[y]/n \n','s');
if isempty(continuestr) 
    continuestr='y'; 
else 
     continuestr=lower(continuestr);
end;
    
end;