function Amps=TrekSDDAmplitude(peaks,Kfcn)
% this function solves the linear eqution system for amplitudes of
% overlaped pulses
N=size(peaks,1);

B=peaks(:,2);
A=zeros(N);
for i=1:N
    ii=0;
    A(i,i-ii)=1;    
    while A(i,i-ii)~=0&&i-1>ii
        ii=ii+1;
        A(i,i-ii)=Kfcn(peaks(i-ii,1)-peaks(i,1));
    end;
    ii=0;
    while A(i,i+ii)~=0&&i+ii<N
        ii=ii+1;
        A(i,i+ii)=Kfcn(peaks(i+ii,1)-peaks(i,1));
    end;

end;
A(A<1e-3)=0;
Amps=linsolve(A,B);