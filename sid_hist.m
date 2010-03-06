function [Hist,HistInterval,HistStep]=sid_hist(InArray,X,HistStep,HistInterval);
Step=5; %Number of min intervals for HistInterval Calculations
A=[];
rflag=false;
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
    B=A-real(A);
    A(find(B))=[];
    NA=size(A,1);
    A=sort(A);
    Ash=circshift(A,-1);
    dA=Ash-A;
    bool=find(dA<=0);
     dA(bool)=[];
%     dA=sort(dA);
%     DdA=diff(dA);
%     Ind=max(find(DdA<mean(DdA)));
%     HistInterval=dA(Ind);
    HistInterval=max(dA);
    HistStep=mean(dA);
 end;
if nargin==2
    A=InArray(:,X);
    NA=size(A,1);
    A=sort(A);
    Ash=circshift(A,-1);
    dA=Ash-A;
    bool=find(dA<=0);
    dA(bool)=[];
    HistInterval=max(dA);
    HistStep=mean(dA);
%     dA=sort(dA,'descend');
%     HistInterval=sum(dA(1:Step))/Step;
%     dA=sort(dA);
%     HistStep=sum(dA(1:Step))/Step;
%     HistInterval=10*(max(A)-min(A))/NA;
%     HistStep=HistInterval;
 end;
if nargin==3;
    A=InArray(:,X);
    A=sort(A);
    Ash=circshift(A,-1);
    dA=Ash-A;
    bool=find(dA<=0);
    dA(bool)=[];
    HistInterval=max(dA);
    if isempty(HistStep); 
        HistStep=mean(dA);
    else
        if isstr(HistStep);
            switch HistStep;
                case 'min'
                    HistStep=min(dA);
                case 'max'
                    HistStep=HistInterval;
                case 'auto'
                    HistStep=mean(dA);
                case 'mean'
                    HistStep=mean(dA);
            end;
        end;
    end;     
end;
if nargin==4
    A=InArray(:,X);
    A=sort(A);
    Ash=circshift(A,-1);
    dA=Ash-A;
    bool=find(dA<=0);
    dA(bool)=[];
    if isempty(HistInterval); 
        HistInterval=max(dA);
    else
        if isstr(HistInterval);
            switch HistInterval;
                case '10percent'
                    HistInterval=max(dA);
                    rflag=true;
                case 'dif'
                     dA=sort(dA);
                     DdA=diff(dA);
                     Ind=max(find(DdA<mean(DdA)));
                     HistInterval=dA(Ind);
                case 'auto'
                    HistInterval=max(dA);
                case 'mean'
                    HistInterval=mean(dA);
            end;
        end;
    end;     

    if isempty(HistStep); 
        HistStep=mean(dA);
    else
        if isstr(HistStep);
            switch HistStep;
                case 'min'
                    HistStep=min(dA);
                case 'max'
                    HistStep=HistInterval;
                case 'auto'
                    HistStep=mean(dA);
                case 'mean'
                    HistStep=mean(dA);
            end;
        end;
    end;     
end;


MinAmpl=min(A);
MaxAmpl=max(A);
YRange=max(A)-min(A);

HistN=fix(YRange/HistStep)+1;  %HistNA=fix(NPeaks/AveragN);  
if HistN==0; HistN=1; end;     % the number of intervals     

for i=1:HistN Hist(i,1)=MinAmpl+(i-0.5)*HistStep; end; 

for i=1:HistN
        HistBool=(A(:)<Hist(i,1)+HistInterval/2)&...
                 (A(:)>=Hist(i,1)-HistInterval/2);
        Hist(i,2)=size(A(HistBool,1),1);  
        Hist(i,3)=sqrt(Hist(i,2));  %error
end;
if rflag
    [MaxHist,MaxHistInd]=max(Hist(:,2));
    err=Hist(MaxHistInd,3)/MaxHist;
    [Hist,HistInterval,HistStep]=sid_hist(InArray,X,HistStep*err/0.1,HistInterval*err/0.1);
end;

