function y=apparat_smooth(Spectr,K);
%y=SpectrFit(x,W,K);
 Smooth=zeros(size(Spectr));
 Smooth(:,1)=Spectr(:,1);
 for i=1:max(size(Spectr))
     Smooth(:,2)=Smooth(:,2)+Spectr(:,2).*SpectrFit(Spectr(:,1),Spectr(i,1),K);
 end;
y=Smooth;
% function y=SpectrFit(x,W0,K);   % Poisson distribution
% X=K*x+1; X0=K*W0+1; 
% y=X;
% LargeBool=(X>20)&(X0>20);
% if not(isempty(y(LargeBool)))
%     XX=X(LargeBool);
%     y(LargeBool)=(1+1/12/X0-1/12./XX).*exp(XX-X0).*(X0./XX).^(XX+1/2);
% end; 
% if not(isempty(y(not(LargeBool))))
%     XX=X(not(LargeBool));
%     y(not(LargeBool))=(X0-1).^(XX-X0).*gamma(X0)./gamma(XX);
% end; 