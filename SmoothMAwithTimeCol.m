function B=SmoothMAwithTimeCol(A,step,start,interv,type)
%moving average for not equal distance between points
%A must contain "time" column
if size(A,1)<size(A,2)
    A=A';
end;

if nargin<2
    step=mean(diff(A(:,1)));
end;
if nargin<3
    start=min(A(:,1));
end;
if nargin<4
    interv=step;
end
if nargin<5
    type='i';
end;
sizeA=size(A,1);

if strcmpi(type,'point')
    N=fix(sizeA-start+1)/step;
    B=zeros(N,2);
    t=start;
    for i=1:N
        fprintf('%2d ',i);
        tic;
        ind=round(t-interv/2):round(t+interv/2);
        ind(ind<1|ind>sizeA)=[];
        B(i,1)=mean(A(ind,1));
        B(i,2)=mean(A(ind,2));
        t=t+step;
        toc;
    end;    
else
    N=fix(max(A(:,1)-start)/step);
    B=zeros(N,2);
    t=start;
    for i=1:N
        fprintf('%2d ',i);
        tic;
        ind=find(A(:,1)>t-interv/2&A(:,1)<=t+interv/2);
        ind(ind<1|ind>sizeA)=[];
        B(i,1)=t;
        B(i,2)=mean(A(ind,2));
        t=t+step;
        toc;
    end;
end;