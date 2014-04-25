function YY=NoiseFFT(data)
N=numel(data);
n=nextpow2(N);
for i=10:n
    for ii=1:fix(N/2^i)
        y=data(1+2^i*(ii-1):2^i*ii);
        Y(:,ii)=fft(y,2^i)/2^i;
    end;
    YY{i}=mean(Y');
    clear Y;
end;