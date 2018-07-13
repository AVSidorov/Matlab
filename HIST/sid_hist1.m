function [Hist,N]=sid_hist1(InArray,X,Accuracy);
AccuracyDef=0.1; %Number of min intervals for HistInterval Calculations
A=[];
if nargin==1
    [m,n]=size(InArray);
    if m==1&n>1 
        A=InArray';
    end;
    if m>1&n==1
        A=InArray;
    end;
    if m>1&n>1
        A=InArray(:,1);
    end;
        if m==1&n==1
        Hist(1,1)=InArray;
        Hist(1,2)=1;
        Hist(1,3)=1;
        return;
    end;
    Accuracy=AccuracyDef;
end;
if nargin==2
    A=InArray(:,X);
    Accuracy=AccuracyDef;
end;
if nargin==3
    A=InArray(:,X);
end;

B=A-real(A);
A(find(B))=[];
A=sort(A);
NA=size(A,1);

N=round(1/(Accuracy^2));
if N>=NA
    disp('Too high Accyracy for such number of peaks');
    Hist=[];
    return;
end;
ASh=circshift(A,-N);
Ind=[1:NA-N];
Hist(:,1)=(A(Ind)+ASh(Ind))/2;
Hist(:,2)=N./(ASh(Ind)-A(Ind));
Hist(:,3)=Hist(:,2)/sqrt(N);

