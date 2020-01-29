function rcn=density_rcn_from_XN(xn,n)
if nargin<2||isempty(n)
    n=length(xn);
end
N=length(xn);
den=linspace(min(xn(:,2)),max(xn(:,2)),n);
rcn=zeros(n,3);
for i=1:n
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