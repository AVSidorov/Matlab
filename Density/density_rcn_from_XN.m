function rcn=density_rcn_from_XN(xn,n)
if nargin>1&&~isempty(n)
    if length(xn)~=length(n)
        error('in case two input arguments xn and n should be a same length');
    end
    if length(xn)~=numel(xn)||length(n)~=numel(n)
         error('in case two input arguments both should be vectors');
    end
    if isrow(xn)
        reshape(xn,[],1);
    end
    if isrow(n)
        reshape(n,[],1);
    end    
    xn(:,2)=n;
end;
    
        
N=length(xn);
den=linspace(min(xn(:,2)),max(xn(:,2)),N);
rcn=zeros(N,3);
for i=1:N
    leftInd=find(xn(:,2)>=den(i),1,'first');
    ind1=max([1,leftInd-1]);
    ind2=min([N,ind1+1]);
    x1=interp1(xn(ind1:ind2,2),xn(ind1:ind2,1),den(i));
    
    rightInd=find(xn(:,2)>=den(i),1,'last');
    ind2=min([N,rightInd+1]);
    ind1=max([1,ind2-1]);
    x2=interp1(xn(ind1:ind2,2),xn(ind1:ind2,1),den(i));
    rcn(i,1)=(x2-x1)/2;
    rcn(i,2)=(x2+x1)/2;
    rcn(i,3)=den(i);
end
rcn=sortrows(rcn);