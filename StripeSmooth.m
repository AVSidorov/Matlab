function [MinIndC,MaxIndC]=StripeSmooth(A)
f=figure;
plot(A,'.b-');
grid on; hold on;
[Max,MainMax]=max(A);
[Min,MainMin]=min(A);
Ind=1:numel(A);
s=[];
while isempty(s)
Al=circshift(A(Ind),-1);
Ar=circshift(A(Ind),1);

MaxBool=A(Ind)>Ar&A(Ind)>=Al;
MinBool=A(Ind)<=Ar&A(Ind)<Al;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=numel(MaxInd);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=numel(MinInd);

if MinInd(1)>MaxInd(1)
    MinInd=[1;MinInd];    
    MinN=MinN+1;
end;
Ind(MinInd)=[];
plot(Ind,A(Ind),'or-','Tag','dd');
figure(f);
s=input('Exit if not empty','s');
delete(findobj('Tag','dd'));
end;
MaxIndC=Ind;

Ind=1:numel(A);
s=[];
while isempty(s)
Al=circshift(A(Ind),-1);
Ar=circshift(A(Ind),1);

MaxBool=A(Ind)>Ar&A(Ind)>=Al;
MinBool=A(Ind)<=Ar&A(Ind)<Al;
MaxBool(1)=false;    MaxBool(end)=false;
MaxInd=find(MaxBool);
MaxN=numel(MaxInd);

MinBool(1)=false;    MinBool(end)=false;
MinInd=find(MinBool);
MinN=numel(MinInd);

if MinInd(1)>MaxInd(1)
    MinInd=[1;MinInd];    
    MinN=MinN+1;
end;
Ind(MaxInd)=[];
plot(Ind,A(Ind),'ok-','Tag','dd');
figure(f);
s=input('Exit if not empty','s');
delete(findobj('Tag','dd'));
end;
MinIndC=Ind;
close(f);