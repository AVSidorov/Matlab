function STP=PulseStruct(PulseFile)
%This function makes pulse struct
%that contains pulse and its parameters

if isstr(PulseFile) 
 if exist(PulseFile,'file');
         Pulse=load(PulseFile);
 else     
     disp('Standart pulse file not found');
     STP=[];
     return;
 end;
else
    Pulse=PulseFile;
end;

if size(Pulse,2)>size(Pulse,1)
    Pulse=Pulse'; %make vertical
end;

if size(Pulse,2)==1
    Pulse(:,2)=Pulse(:,1);
    Pulse(:,1)=1:size(Pulse,1);
end;

[maxV,maxInd]=max(Pulse(:,2));

%normalize pulse
Pulse(:,2)=Pulse(:,2)/maxV;

[minV,minInd]=min(Pulse(:,2));

%% calculating time properties
 %MaxTime
 MaxTimeInd=find(Pulse(:,2)>=1,1,'first');
 MaxTime=interp1(Pulse(MaxTimeInd-1:MaxTimeInd,2),Pulse(MaxTimeInd-1:MaxTimeInd,1),1);
 
 %startTime
 stInd=find(Pulse(:,2)>0,1,'first');
 if stInd>1
    stTime=interp1(Pulse(stInd-1:stInd,2),Pulse(stInd-1:stInd,1),0);
 else
     stTime=0;
 end;
 
 % FWHM
stFWHMInd=find(Pulse(:,2)>=0.5,1,'first');
endFWHMInd=find(Pulse(:,2)>=0.5,1,'last');
stFWHM=interp1(Pulse(stFWHMInd-1:stFWHMInd,2),Pulse(stFWHMInd-1:stFWHMInd,1),0.5);
endFWHM=interp1(Pulse(endFWHMInd:endFWHMInd+1,2),Pulse(endFWHMInd:endFWHMInd+1,1),0.5);
STP.FWHM=endFWHM-stFWHM;

%Prepare points 10% 
st10Ind=find(Pulse(:,2)>=0.1,1,'first');
end10Ind=find(Pulse(:,2)>=0.1,1,'last');
st10=interp1(Pulse(st10Ind-1:st10Ind,2),Pulse(st10Ind-1:st10Ind,1),0.1);
end10=interp1(Pulse(end10Ind:end10Ind+1,2),Pulse(end10Ind:end10Ind+1,1),0.1);

% Prepare 90%
st90Ind=find(Pulse(:,2)>=0.9,1,'first');
end90Ind=find(Pulse(:,2)>=0.9,1,'last');
st90=interp1(Pulse(st90Ind-1:st90Ind,2),Pulse(st90Ind-1:st90Ind,1),0.9);
end90=interp1(Pulse(end90Ind:end90Ind+1,2),Pulse(end90Ind:end90Ind+1,1),0.9);

% Prepare 1%
st1Ind=find(Pulse(:,2)>=0.01,1,'first');
end1Ind=find(Pulse(:,2)>=0.01,1,'last');
if st1Ind>1
    st1=interp1(Pulse(st1Ind-1:st1Ind,2),Pulse(st1Ind-1:st1Ind,1),0.01);
else
    st1=0;
end;
if end1Ind<size(Pulse,1)   
    end1=interp1(Pulse(end1Ind:end1Ind+1,2),Pulse(end1Ind:end1Ind+1,1),0.01);
else
    end1=Pulse(end,1);
end


%% Output
STP.Pulse=Pulse;

% Full Widtdh, Front, Tail
STP.StartTime=stTime;
STP.MaxTime=MaxTime;
STP.PeakingTime=MaxTime-stTime;
STP.PeakingTime1=MaxTime-st1;
STP.Width10=end10-st10;
STP.Width1=end1-st1;
STP.Front=st90-st10;
STP.Tail=end10-end90;


STP.FlatTop=end90-st90;
STP.Min=minV;
STP.Max=1;
SP=SpecialTreks(Pulse(:,2));
STP.MaxStruct=SP;
