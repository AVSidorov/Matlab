function [Profile,MaxPos]=SymProfile(Profile)

[M,MaxInd]=max(Profile(:,2));
if M>0&&MaxInd>2
    fit=polyfit(Profile(MaxInd-2:MaxInd+2,1),Profile(MaxInd-2:MaxInd+2,2),2);
    MaxPos=-fit(2)/2/fit(1);
else
    MaxPos=0;
end;
x=[-ceil(max(abs(Profile(:,1)))):ceil(max(abs(Profile(:,1))))]';
p1=spline(Profile(:,1)-MaxPos,Profile(:,2),x);
p2=spline(MaxPos-Profile(:,1),Profile(:,2),x);
FIT=FitOneToAnother(p1,p2,1,1,5);
p2=interp1(1:length(p1),p2,[1:length(p1)]'-FIT.Shift);
p2=(p1+p2)/2;
Profile=[x,p2];
MaxPos=MaxPos+FIT.Shift/2;