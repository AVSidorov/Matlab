function TrekSet=Trek(TrekSet,varargin)

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');




%% Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet,varargin{:});

if TrekSet.type==0 
    return; 
end;


TrekSet=TrekLoad(TrekSet);
TrekSet=TrekStdVal(TrekSet);
TrekSet=TrekPickThr(TrekSet);
TrekSet.plot=false;
TrekSet=TrekMerge(TrekSet);
%return;

%TrekSet=TrekPickTime(TrekSet,0,pow2(21)*TrekSet.tau);

if TrekSet.type==0 
    return; 
end;

%Loading Standard Pulse
TrekSet.STP=StpStruct;

%% Block for Plasma treks
Pass=2;
TrekSet=TrekPickTime(TrekSet,15000,10000);
for passI=1:Pass
    TrekSet.Threshold=[];
    TrekSet.Plot=true;
    TrekSet=TrekPickThr(TrekSet);
    TrekSet=TrekPeakSearch(TrekSet);
    TrekSet=TrekBreakPoints(TrekSet);
    assignin('base',[inputname(1),'Pass',num2str(passI-1)],TrekSet);
%     TrekSet.Plot=false;
    TrekSet=TrekGetPeaksSid(TrekSet,passI); 
end;
CloseGraphs;   
assignin('base',[inputname(1),'Pass',num2str(Pass)],TrekSet);
   

%% Block for trek merging
    
%     TrekSet=TrekPickThr(TrekSet);
%     TrekSet=TrekStdVal(TrekSet);  
%     TrekSet=TrekMerge(TrekSet);
%     TrekSet=TrekPickTime(TrekSet,15000);
%     TrekSet=TrekPeakSearch(TrekSet,STP);
%     TrekSet=TrekBreakPoints(TrekSet,STP);
%     
%     save(TrekSet.name,'TrekSet');
%     eval(['T',TrekSet.name(1:2),'=TrekSet;']);
%     if exist(['m',num2str(TrekSet.Date),'_1.mat'])
%         save(['m',num2str(TrekSet.Date),'_1'],['T',TrekSet.name(1:2)],'-append');
%     else
%         save(['m',num2str(TrekSet.Date),'_1'],['T',TrekSet.name(1:2)]);
%     end;
%     CloseGraphs;
%     return;

%%

% neccessary for noise reduction in calibration treks
% MaxBlock=4.3e6;
% dT=TrekSet.tau*size(TrekSet.StandardPulse,1);

% trek=[]; 
% LastInd=0;
% 
% PartN=fix(TrekSet.size/MaxBlock)+1;
% for i=1:PartN 
% fprintf('==== Processing  Part %u of %u file %s\n',i,PartN,TrekSet.name);
%     TrekSet1=TrekSet;
% 
%     TrekSet1.size=min([TrekSet.size-(i-1)*MaxBlock;MaxBlock]);
%     TrekSet1.StartTime=TrekSet.StartTime+(i-1)*MaxBlock*TrekSet1.tau;
% 
%     %Loading trek data
%     TrekSet1=TrekLoad(FileName,TrekSet1);
% 
%     %Standard Deviation calulations and/or Peak Polarity Changing    
% %     TrekSet1=TrekStdVal(TrekSet1);
% %     TrekSet.MeanVal=TrekSet1.MeanVal;
% %     TrekSet.PeakPolarity=TrekSet1.PeakPolarity;           
% 
%     
% %     TrekSet.trek=TrekSet1.trek; return;
%     
%     
%     %Threshold Determination
%      if isempty(TrekSet.Threshold)
%          TrekSet1=TrekPickThr(TrekSet1);
%          TrekSet.Threshold=TrekSet1.Threshold;
%      else    
%          if TrekSet.Threshold<0
%              TrekSet1=TrekPickThr(TrekSet1);
%              TrekSet.Threshold=TrekSet1.Threshold;
%          end;
%      end;
%  
%    %Time re-setup for plasma treks. !!!!!!Think about moving this to header
%              TrekSet1=TrekPeakSearch(TrekSet1,STP);
%              TrekSet1=TrekBreakPoints(TrekSet1,STP);
%              TrekSet1=TrekPickTime(TrekSet1,TrekSet1.StartOffset,30000,5000);
% %              TrekSet1=TrekPickTime(TrekSet1,TrekSet1.StartOffset);
%              TrekSet1.Threshold=TrekSet1.Threshold*2; %after TrekPeakSearch
%              TrekSet.StartTime=TrekSet1.StartTime;
%              TrekSet.size=TrekSet1.size;
%              TrekSet1=TrekLoad(FileName,TrekSet1);
% 
% % assignin('base','trek',TrekSet1.trek);
% 
% for passI=1:Pass
% 
%      TrekSet1=TrekStdVal(TrekSet1);  
%      TrekSet1=TrekMerge(TrekSet1);
% 
%      TrekSet.MeanVal=TrekSet1.MeanVal;
%      TrekSet=TrekSet1;
%      
% 
%    
% %     
% %     %Searching for Indexes of potential Peaks
% 
%     
%       TrekSet1=TrekPeakSearch(TrekSet1,STP);
%       TrekSet1=TrekBreakPoints(TrekSet1,STP);
% %     pause;
% %     TrekSet1=TrekTops(TrekSet1);
%       
% % 
% %     %!!!Searching for Standard Pulse
% % 
%     %Getting Peaks
%      assignin('base',[inputname(1),'Pass',num2str(passI-1)],TrekSet1);
%      TrekSet1=TrekGetPeaksSid(TrekSet1,passI,STP);
%      TrekSet1.Threshold=TrekSet1.Threshold*2;
% end;




%%%%%%%%%%%%%%%making trek whithout noise spaces%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if not(isempty(TrekSet1.peaks))>0
%         bool=(TrekSet1.peaks(:,2)>(TrekSet1.StartTime+dT))&...
%              (TrekSet1.peaks(:,2)<(TrekSet1.StartTime+TrekSet1.size*TrekSet1.tau-2*dT));
%         StartTime=TrekSet1.peaks(bool,2)-dT;
%         EndTime=TrekSet1.peaks(bool,2)+2*dT;
%         if not(isempty(StartTime))
%             NCross=1;
% 
%             while NCross>0
%                 StartTimeSh=circshift(StartTime,-1);
%                 StartTimeSh(end)=[];
%                 delta=EndTime(1:end-1)-StartTimeSh;
%                 Ind=find(delta>=0);
%                 NCross=size(Ind,1);
%                 EndTime(Ind)=[];
%                 StartTime(Ind+1)=[];
%             end;
% 
%             StartInd=fix((StartTime-TrekSet1.StartTime)/TrekSet1.tau)+1;
%             EndInd=fix((EndTime-TrekSet1.StartTime)/TrekSet1.tau)+1;
%             Intervs=EndInd-StartInd;
%             Intervs=Intervs+5;
%             NInterv=size(StartInd,1);
%             NPoints=sum(Intervs);
%             trek=[trek;zeros(NPoints,1)];
%             for ii=1:NInterv
%                 trek(LastInd+2)=StartTime(ii)/1e6;
%                 trek(LastInd+3:LastInd+Intervs(ii)-2)=TrekSet1.trek(StartInd(ii):EndInd(ii));
%                 trek(LastInd+Intervs(ii)-1)=EndTime(ii)/1e6;
%                 LastInd=LastInd+Intervs(ii);
%             end;
%         end;
%     end;

%       TrekSet.peaks=TrekSet1.peaks;
%       TrekSet.StdVal=(TrekSet.StdVal*(i-1)+TrekSet1.StdVal)/i;
%       TrekSet.Threshold=(TrekSet.Threshold*(i-1)+TrekSet1.Threshold)/i;
%     clear StartTime EndTime StartInd EndInd bool StartTimeSh delta Ind TrekSet1 ii NCross;
% end;
% 
% % FileName=['shr',FileName];
% % fid=fopen(FileName,'w');
% % fwrite(fid,trek,'single');
% % fclose(fid);
% 
% TrekSet=rmfield(TrekSet,'Plot');
% if isfield(TrekSet,'trek')
%     TrekSet=rmfield(TrekSet,'trek');
% end;
% TrekSet=TrekChargeQX(TrekSet);
%  assignin('base','TrekSet',TrekSet);
%  if not(evalin('base','exist(''Treks'')'))
%      evalin('base','Treks=[];');
%  end;
% %  evalin('base','Treks=[Treks;TrekSet];');
% fprintf('>>>>>>>>>>>>>>>>>>>> Trek finished\n');
% toc;
% fprintf('\n \n');
% CloseGraphs; 
% N='17';
% points=8000000;
% tau=0.02;
% combStr=['p',N,'=['];
% tic
% fid = fopen([N,'sxr.dat']); trek = fread(fid,inf,'single'); fclose(fid); clear fid; trek(end-8:end)=[];
% toc
% partN=fix(size(trek,1)/points);
% for i=1:partN-1
%     eval(['ProcessingTrekClb(trek(',num2str((i-1)*points+1),':',num2str(i*points),'));']);
%     combStr=[combStr,'p',N,'T',num2str(round((i-1)*points*tau/1000)),'d',num2str(round(i*points*tau/1000)),'ms;'];
% end;
%     eval(['ProcessingTrekClb(trek(',num2str((partN-1)*points+1),':end));']);
%     combStr=[combStr,'p',N,'T',num2str(round((partN-1)*points*tau/1000)),'d',num2str(round(size(trek,1)*tau/1000)),'ms];'];
% clear trek partN i tau;
% evalin('base',combStr);
% clear combStr;
% evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5);']);
% evalin('base',['[spec',N,',spec',N,'Int]=sid_hist(p',N,',5,spec',N,'Int/50,spec',N,'Int/5);']);
% evalin('base',['Poisson(spec',N,');']);


 