function peaks=TrekSDDAmplitudesByFilter(PeaksInd,treks,Pulses,fwhms,Thresholds)

trSize=size(treks,1);


ex=false;
while ~ex
    %deterimine iterval to previouse and next
    Ibefore=zeros(size(PeaksInd));
    Ibefore(2:end)=PeaksInd(2:end)-PeaksInd(1:end-1);
    Ibefore(1)=PeaksInd(1);

    Iafter=zeros(size(PeaksInd));
    Iafter(end)=trSize-PeaksInd(end);
    Iafter(1:end-1)=PeaksInd(2:end)-PeaksInd(1:end-1);

    n=min(size(treks));
    Amps=zeros(size(PeaksInd,1),2*n);
    for i=1:n
        Amps(:,1+(i-1)*2)=treks(PeaksInd(:,1),i);
        trek=treks(:,i);
        fwhm=fwhms(i);
        Pulse=Pulses(:,i);
        [M,MI]=max(Pulse);

        Dbefore=zeros(size(PeaksInd));
        Dbefore(1,1)=min([fwhm,PeaksInd(1)-1]);

        for ii=2:numel(PeaksInd)
            Dbefore(ii,1)=min([fwhm,Ibefore(ii)-fwhm]);
        end;

        Dafter=zeros(size(PeaksInd));
        Dafter(end,1)=min([fwhm,trSize-PeaksInd(end)]);
        for ii=1:numel(PeaksInd)-1
            Dafter(ii,1)=min([fwhm,Iafter(ii)-fwhm]);
        end;



        %% determine amplitude by integral
        Amp=zeros(size(PeaksInd));
        for ii=1:numel(PeaksInd)
           Amp(ii,1)=sum(trek(PeaksInd(ii)-Dbefore(ii):PeaksInd(ii)+Dafter(ii)))/sum(Pulse(MI-Dbefore(ii):MI+Dafter(ii))); 
        end;

        Amps(:,2+(i-1)*2)=Amp;
    end;
    Amp=Amps(:,1);
    for i=1:n
        bool=Ibefore>1.5*fwhms(i)&Iafter>1.5*fwhms(i);
        Amp(bool)=Amps(bool,2+(i-1)*2);
    end;
    Ind=find(Amp<Thresholds(end));
    if ~isempty(Ind)
        PeaksInd(Ind)=[];
    else
        ex=true;
    end;
end;
peaks(:,1)=PeaksInd;
peaks(:,5)=Amp;