function [Ym,N]=TrekNoiseSpectra(TrekSet,varargin)
NFFT=pow2(21);
Ym = zeros(NFFT,1);
N=0;

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    error('incorrect number of input arguments');
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;

if TrekSet.size>0
    nl=TrekNullLineRunAvrFit(TrekSet);
    Ind=find(abs(TrekSet.trek-nl)<=TrekSet.OverSt*TrekSet.StdVal);
    if ~isempty(Ind)
        N=N+1;
        if numel(Ind)<=NFFT
            Y = fft(TrekSet.trek(Ind)/TrekSet.Amp,NFFT)/numel(Ind);
            else
            Y = fft(TrekSet.trek(Ind(1:NFFT))/TrekSet.Amp,NFFT)/NFFT;
        end;
        Ym=(Ym*(N-1)+abs(Y))/N;
    end;
end;
