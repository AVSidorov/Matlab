function Amp=Trek2Amp1(TrekSet);
HI=0.2;

AmpCol=5;



peaks=TrekSet.peaks;
peaks(:,AmpCol)=peaks(:,AmpCol)/TrekSet.Amp/5.9;
QCol=size(peaks,2)+1;
peaks(:,end+1)=TrekSet.charge;
peaks=sortrows(peaks,QCol);
    

dQ=50;
range=peaks(end,QCol)-peaks(1,QCol);
N=round(range/dQ);
IN=zeros(7,1);
Amp=[];

for i=1:N
    bool=peaks(:,QCol)>=peaks(1,QCol)+(i-1)*dQ&peaks(:,QCol)<=peaks(1,QCol)+i*dQ;
    Q=peaks(1,QCol)+i*dQ-dQ/2;
    Ind=find(bool);
    if max(size(Ind))>=1000

        Hist=sid_hist(peaks(Ind,AmpCol),1,HI,HI);
        [Ps,IN]=Poisson(Hist,IN);

        Amp(end+1,1)=TrekSet.Date;
        Amp(end,2)=TrekSet.Shot;
        Amp(end,3)=TrekSet.P;
        Amp(end,4)=TrekSet.HV;
        Amp(end,5)=mean(peaks(Ind,QCol));
        Amp(end,6)=Q;
        % Amp(i,5)=mean(peaks(Ind,QCol+1));
        % Amp(i,6)=mean(peaks(Ind,QCol+2));
        % Amp(i,7)=mean(peaks(Ind,QCol+3));
        Amp(end,7)=Ps.Wmain;
        Amp(end,8)=Ps.SigmaMainP;
        Amp(end,9)=max(size(Ind));

        figure(gcf);

        ch=input(['Step ',num2str(i),'. For exit not empty input.\n'],'s');
        if not(isempty(ch)) close(gcf); return; end;

        close(gcf);
        IN(1)=Ps.W1;
        IN(2)=Ps.Sigma1;
        IN(5)=Ps.W41;
    end;    
end;



