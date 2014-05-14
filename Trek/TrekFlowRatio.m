function r=TrekFlowRatio(TrekSet1,TrekSet2,varargin)
r=[];
Estart=500;
Eend=10000;
Estep=50;
Tstart=15000;
Tend=55000;
Tstep=1000;
dTstart=1;
dTend=100;
dTendFit=10;
dTstep=1;
SpecWindow=3000;

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    error('incorrect number of input arguments');
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;

peaks1=peaksPrepare(TrekSet1);
peaks2=peaksPrepare(TrekSet2);
bool1=peaks1(:,2)>=Tstart&peaks1(:,2)<=Tend;
bool2=peaks2(:,2)>=Tstart&peaks2(:,2)<=Tend;
r=[r;numel(peaks2(bool2,1))/numel(peaks1(bool1,1))];

Hist1=HistOnNet(peaks1(:,2),[Tstart:Tstep:Tend]);
Hist2=HistOnNet(peaks2(:,2),[Tstart:Tstep:Tend]);
bool=Hist1(:,2)>10&Hist2(:,2)>10;
r=[r;Hist2(bool,2)./Hist1(bool,2)];
Hist1=HistOnNet(peaks1(:,2),[Tstart:SpecWindow:Tend]);
Hist2=HistOnNet(peaks2(:,2),[Tstart:SpecWindow:Tend]);
bool=Hist1(:,2)>0&Hist2(:,2)>0;
r=[r;Hist2(bool,2)./Hist1(bool,2)];
for i=1:fix((Tend-Tstart)/SpecWindow)
    bool1=peaks1(:,2)>=Tstart+(i-1)*SpecWindow&peaks1(:,2)<=Tstart+i*SpecWindow;
    bool2=peaks2(:,2)>=Tstart+(i-1)*SpecWindow&peaks2(:,2)<=Tstart+i*SpecWindow;

    Hist1=HistOnNet(peaks1(bool1,5),[Estart:Estep:Eend]);
    Hist2=HistOnNet(peaks2(bool2,5),[Estart:Estep:Eend]);
    if sum(Hist1(:,2)>=50)&&sum(Hist2(:,2)>=50)&&max(Hist1(:,2)>=4)&&max(Hist2(:,2)>=4)
        bool=Hist1(:,2)>0&Hist2(:,2)>0;
        r=[r;mean(Hist2(bool,2)./Hist1(bool,2))];
        r=[r;sum(Hist1(:,2).*Hist2(:,2))/sum(Hist1(:,2).^2)];
        
       
        fit1=TrekHistAnalysis(peaks1,'Tstart',Tstart+(i-1)*SpecWindow,'Tend',Tstart+i*SpecWindow,'Plot',false);
        fit2=TrekHistAnalysis(peaks2,'Tstart',Tstart+(i-1)*SpecWindow,'Tend',Tstart+i*SpecWindow,'Plot',false);
        r=[r;fit2(1)/fit1(1)];
    end;

    
end;


%% 
function peaks=peaksPrepare(TrekSet)
if isstruct(TrekSet)
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)    
        peaks=TrekSet.peaks;
    else        
        error('peaks is empty');
    end;
    switch TrekSet.Amp
    case 9
        peaks(:,5)=5900*peaks(:,5)/2175;
    case 6
        peaks(:,5)=5900*peaks(:,5)/1432.28;
    case 4
        peaks(:,5)=5900*peaks(:,5)/958.9;
    end;
else 
    peaks=TrekSet;
end;
peaks=sortrows(peaks,2);
peaks(1,3)=0;
peaks(2:end,3)=diff(peaks(:,2));
