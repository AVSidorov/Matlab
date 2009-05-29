function Hist=sid_hist(InArray,X,HistInterval,HistStep);

if nargin==1
    A(:)=InArray(:,1);
    NA=size(A,1);
    HistInterval=10*(max(A)-min(A))/NA;
    HistStep=HistInterval;
 end;
if nargin==2
    A(:)=InArray(:,X);
    HistInterval=10*(max(A)-min(A))/NA;
    HistStep=HistInterval;
 end;
if nargin==3
    A(:)=InArray(:,X);
    HistStep=HistInterval;
end;
if nargin==4
    A(:)=InArray(:,X);
end;
MinAmpl=min(A);
MaxAmpl=max(A);
YRange=max(A)-min(A);
HistN=fix(YRange/HistStep)+1;  %HistNA=fix(NPeaks/AveragN);  
if HistN==0; HistN=1; end;     % the number of intervals     
for i=1:HistN Hist(i,1)=MinAmpl+(i-0.5)*HistStep; end; 
for i=1:HistN
        HistBool=(A(:)<HistA(i,1)+HistInterval/2)&...
                 (A(:)>=HistA(i,1)-HistIntervalA/2);
        Hist(i,2)=size(A(HistBool,1),1);  %peak amplitude
end;

