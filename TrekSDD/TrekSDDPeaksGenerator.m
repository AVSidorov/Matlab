function TrekSet=TrekSDDPeaksGenerator(TrekSet,varargin)
% This function generates peaks array in same format as TrekSDDGetPeaks
% This peaks array can be used in TrekSDDMakeTrek
N=1000;
Amp=1000;
TimeStep=TrekSet.STP.size*TrekSet.tau;
AmpNoise=0.0;
AmpNoiseType='unif'; % see random function. Assumes using  'unif' and 'norm'
TimeStepNoise=0.01;
TimeStepType='norm';
TimeStart=TrekSet.STP.size*TrekSet.tau;
E=[200:15000]';
Te=550;
dBe=58;

TrekSet.FileName='';
TrekSet.name='Generated';
TrekSet.Date=str2num(datestr(now,'yymmdd'));
TrekSet.Shot=[];
TrekSet.Amp=[];

if isfield(TrekSet,'StartPlasma')&&~isempty(TrekSet.StartPlasma)
    TimeStart=TimeStart+TrekSet.StartPlasma;
end;

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    return;
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;
TrekSet.StartPlasma=TimeStart-TrekSet.STP.size*TrekSet.tau;
TrekSet.peaks=zeros(N,7);

if strcmpi(AmpNoiseType,'trek')
    Maxw=exp(-E/Te);
    Absorption=AbsorptionSDD(dBe,E);
    pdf=[E,Absorption(:,2).*Maxw];
    TrekSet.peaks(:,5)=curvernd(pdf,N,1);
    TrekSet.StdVal=100;
    TrekSet.Threshold=500;
elseif strcmpi(TimeStepType,'doubled')&&exist('Amp1','var')&&~isempty(Amp1)    
     TrekSet.peaks(1:2:N,5)=random('norm',Amp,AmpNoise,numel(1:2:N),1);
     TrekSet.peaks(2:2:N,5)=random('norm',Amp1,AmpNoise,numel(2:2:N),1);
else
    TrekSet.peaks(:,5)=random('norm',Amp,AmpNoise,N,1);
end;

if strcmpi(TimeStepType,'trek')
    t=random('unif',0,TimeStep*N,N,1);
    t=sortrows(t);
    TrekSet.peaks(:,2)=TimeStart+t;
elseif strcmpi(TimeStepType,'doubled')
     TrekSet.peaks(1:2:N,2)=TimeStart+[1:2:N]'*TrekSet.STP.size*TrekSet.tau/2+random('norm',0.0,TimeStepNoise,numel(1:2:N),1);
     TrekSet.peaks(2:2:N,2)=TrekSet.peaks([2:2:N]-1,2)+TimeStep;
else
%     if TimStepType=='fix'||TimStepType=='fixed'   
     TrekSet.peaks(:,2)=TimeStart+[1:N]'*TimeStep+random(TimeStepType,0.0,TimeStepNoise,N,1);
end;

TrekSet.peaks(:,1)=round((TrekSet.peaks(:,2)-TrekSet.StartTime)/TrekSet.tau);
TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2));
