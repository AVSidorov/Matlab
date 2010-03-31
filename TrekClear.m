function TrekClear(TrekSet);

MaxBlock=3e6;

FileName=[TrekSet.name,'.dat']

TrekSet=TrekRecognize(FileName,TrekSet);

if TrekSet.type==0 return; end;

PartN=fix(TrekSet.size/MaxBlock)+1;

dT=TrekSet.tau*size(TrekSet.StandardPulse,1);

trek=[];
LastInd=0;
for i=1:PartN 
    fprintf('==== Processing  Part %u of %u file %s\n',i,PartN,TrekSet.name);
    
    TrekSet1=TrekSet;

    TrekSet1.size=min([TrekSet.size-(i-1)*MaxBlock;MaxBlock]);
    TrekSet1.StartTime=TrekSet.StartTime+(i-1)*MaxBlock*TrekSet1.tau;
    
    %Loading trek data
    TrekSet1=TrekLoad(FileName,TrekSet1);
    if isfield(TrekSet1,'MeanVal')
        if TrekSet1.MeanVal~=0
            TrekSet1.trek=TrekSet1.PeakPolarity*(TrekSet1.trek-TrekSet1.MeanVal);
        else
            TrekSet1=TrekStdVal(TrekSet1);
            TrekSet.MeanVal=TrekSet1.MeanVal;
            TrekSet.PeakPolarity=TrekSet1.PeakPolarity;           
        end;
    else
        TrekSet1=TrekStdVal(TrekSet1);
        TrekSet.MeanVal=TrekSet1.MeanVal;
        TrekSet.PeakPolarity=TrekSet1.PeakPolarity;           
    end;
    
    bool=(TrekSet1.peaks(:,2)>(TrekSet1.StartTime+dT))&...
         (TrekSet1.peaks(:,2)<(TrekSet1.StartTime+TrekSet1.size*TrekSet1.tau-2*dT));
    StartTime=TrekSet1.peaks(bool,2)-dT;
    EndTime=TrekSet1.peaks(bool,2)+2*dT;
   
    if not(isempty(StartTime))
        NCross=1;

        while NCross>0
            StartTimeSh=circshift(StartTime,-1);
            StartTimeSh(end)=[];
            delta=EndTime(1:end-1)-StartTimeSh;
            Ind=find(delta>=0);
            NCross=size(Ind,1);
            EndTime(Ind)=[];
            StartTime(Ind+1)=[];
        end;

        StartInd=fix((StartTime-TrekSet1.StartTime)/TrekSet1.tau);
        EndInd=fix((EndTime-TrekSet1.StartTime)/TrekSet1.tau);
        Intervs=EndInd-StartInd;
        Intervs=Intervs+5;
        NInterv=size(StartInd,1);
        NPoints=sum(Intervs);
        trek=[trek;zeros(NPoints,1)];
        for ii=1:NInterv
            trek(LastInd+2)=StartTime(ii)/1e6;
            trek(LastInd+3:LastInd+Intervs(ii)-2)=TrekSet1.trek(StartInd(ii):EndInd(ii));
            trek(LastInd+Intervs(ii)-1)=EndTime(ii)/1e6;
            LastInd=LastInd+Intervs(ii);
        end;    
        clear StartTime EndTime StartInd EndInd bool StartTimeSh delta Ind TrekSet1 ii NCross;
    else
        clear StartTime EndTime  bool TrekSet1;        
    end;
end;
FileName=['shr',FileName];
fid=fopen(FileName,'w');
fwrite(fid,trek,'single');
fclose(fid);