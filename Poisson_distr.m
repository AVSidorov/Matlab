function P=Poisson_distr(K,W0,W)
%Poisson distribution curve 
X=K.*W(:)+1;
X0=K.*W0+1;
 P=K*exp(-X0+1).*(X0-1).^(X-1)./gamma(X);
 LargeBool=isnan(P)|P==inf;
 P(LargeBool)=K/sqrt(2*pi*(X0-1))*exp(-(X(LargeBool)-X0).^2/(X0-1)/2);
%  P=K/sqrt(2*pi*(X0-1))*exp(-(X-X0).^2/(X0-1)/2);
