function tW=QTimeSearch(TrekSet);

% Spec0=SpectrDeadTime(TrekSet,20,0);
% notscale=figure;
% grid on; hold on;
% plot(Spec0.Hist(:,1),Spec0.Hist(:,2),'.r-');
% 
% 
% for dt=[1,2,5,10,20,50,100,200];
%     Spec=SpectrDeadTime(TrekSet,20,dt);
%     Spec1=SpectrDeadTimeIn(TrekSet,20,dt);
%     
%     figure(notscale);
%     plot(Spec.Hist(:,1),Spec.Hist(:,2),'.b-');
%     plot(Spec1.Hist(:,1),Spec1.Hist(:,2),'.k-');
% 
%     figure;
%     grid on; hold on;
%     title(['Dead time is ',num2str(dt,'%3.0f'),'us']);
%     plot(Spec0.Hist(:,1),Spec0.Hist(:,2)./max(Spec0.Hist(:,2)),'.r-');
%     plot(Spec.Hist(:,1),Spec.Hist(:,2)./max(Spec.Hist(:,2)),'.b-');
%     plot(Spec1.Hist(:,1),Spec1.Hist(:,2)./max(Spec1.Hist(:,2)),'.k-');
%     pause;
%     close(gcf);
% end;

peaks=TrekSet.peaks;
if peaks(1,3)~=0
    peaks(2:end,3)=diff(peaks(:,2)); peaks(1,3)=0; 
end;

dT=(peaks(end,2)-peaks(1,2))/size(peaks,1);

%  notscale=figure;
%  grid on; hold on;
 HistSet=HistPick(peaks,5);
 NI=round(size(peaks,1)/1000);
 HI=HistSet.HI;
 HS=max([HistSet.HS,1]);
 [PoissonSet,IN]=Poisson(HistSet.Hist);
 tW(1,1)=0;
 tW(1,2)=mean(peaks(:,3));
 tW(1,3)=max(peaks(:,3))-min(peaks(:,3));
 tW(1,4)=max(size(peaks));
 tW(1,5)=PoissonSet.Wmain;
 tW(1,6)=PoissonSet.SigmaMainP;

 figure(gcf);
 Inp=input('Close?\n');
 if isempty(Inp)
     close(gcf);
 end;
%  plot(Hist(:,1),Hist(:,2)/10,'.r-');
for k=NI:-1:2
 bool=(peaks(:,3)>=-dT*log(k/NI))&(peaks(:,3)<=-dT*log((k-1)/NI));
 if max(size(find(bool)))>100
     Hist=sid_hist(peaks(bool,5),1,HS,HI);
     [PoissonSet,IN]=Poisson(Hist,IN);
     figure(gcf);
     Inp=input('Close?\n');
     if isempty(Inp)
         close(gcf);
     end;
     tW(end+1,1)=-(dT*log(k/NI)+dT*log((k-1)/NI))/2;
     tW(end,2)=mean(peaks(bool,3));
     tW(end,3)=-dT*log((k-1)/NI)+dT*log(k/NI);
     tW(end,4)=max(size(find(bool)));
     tW(end,5)=PoissonSet.Wmain;
     tW(end,6)=PoissonSet.SigmaMainP;
    %  plot(Hist(:,1),Hist(:,2),'.b-');
    %  pause;
 end;
end;
  bool=peaks(:,3)>=-dT*log(1/NI);
  Hist=sid_hist(peaks(bool,5),1,HS,HI);
  PoissonSet=Poisson(Hist,IN);
  figure(gcf);
  Inp=input('Close?\n');
  if isempty(Inp)
      close(gcf);
  end;

  tW(end+1,1)=(max(peaks(:,3))-dT*log(1/NI))/2;
  tW(end,2)=mean(peaks(bool,3));
  tW(end,3)=max(peaks(bool,3))+dT*log(1/NI);
  tW(end,4)=max(size(find(bool)));
  tW(end,5)=PoissonSet.Wmain;
  tW(end,6)=PoissonSet.SigmaMainP;
