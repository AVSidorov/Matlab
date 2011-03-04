function TrekSet=Param2TrekSet(TrekSetIn,AllPrms);
TrekSet=TrekSetIn;
% settings of AllPrms array it may be AllPrms AmpPVQ AmpHV etc
DateCol=0;
NCol=1;
PCol=5;
dPCol=7;
HVCol=11;
AmpCol=10;


Ns=TrekSet.name(1:2);
N=str2num(Ns);
Ind=find(AllPrms(:,NCol)==N);
disp(Ns);

if isempty(Ind) 
    return;
else
    if max(size(Ind))>1
        return;
    else
        if DateCol>0 
            Date=AllPrms(Ind,DateCol);
        else
            Date=100405;
        end;
       if AmpCol>0
           Amp=AllPrms(Ind,AmpCol);
       else
           Amp=32.85;
       end;
       if dPCol>0
           P=AllPrms(Ind,PCol)+AllPrms(Ind,dPCol)+1;
       else
           P=AllPrms(Ind,PCol)+1;   
       end;
       HV=AllPrms(Ind,HVCol);
    end;
end;

peaks=TrekSet.peaks;

if min(size(peaks))>0
    if peaks(1,3)~=0
        peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
    end;
end;

TrekSet.peaks=peaks;
TrekSet.Date=Date;
TrekSet.Shot=N;
TrekSet.Amp=Amp;
TrekSet.HV=HV;
TrekSet.P=P;
TrekSet=TrekChargeQX(TrekSet);

