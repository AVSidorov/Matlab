%function TrekIntegr(FileName1,PeakFileName);

function TrekIntegr2;

OffsetDef=27000;
CalAmpDef=2150;

FileCount=0;
continuestr='n';
while continuestr~='y'

    FileCount=FileCount+1;

    tic;
    PeakFileName=input('Input Name of Peak File as String\n');
    peak=load(PeakFileName);
    fprintf('Time of load %4.2f\n', toc);

    offset=input(['Input Trek time offset us defualt is ',num2str(OffsetDef,'%5.0f'),'\n']);
    if isempty(offset) offset=OffsetDef; end;  
    
    MaxAmp=input('Input Maximum Peak Amplitude defualt is 2500\n');
    if isempty(MaxAmp) MaxAmp=2500; end;  
    
    MinAmp=input('Input Minimum Peak Amplitude defualt is 0\n');
    if isempty(MinAmp) MinAmp=0; end;  
    
    CalAmp=input(['Input Calibration Amplitude for 5.9 keV defualt is ',num2str(CalAmpDef,'%4.0f'),'\n']);
    if isempty(CalAmp) CalAmp=CalAmpDef; end;  
    
    CalAmplf=input('Input  Amplfication of Calibration defualt is 11\n');
    if isempty(CalAmplf) CalAmplf=11; end;  
    
    MesAmplf=input('Input  Amplfication of Measure defualt is 35\n');
    if isempty(MesAmplf) MesAmplf=35; end;  
    
    CalK=input('Input Energy Calibration  Koeff defualt is 1\n');
    if isempty(CalK) CalK=1; end;  

    peak(:,2)=peak(:,2)+offset;
    OutLimits=(peak(:,5)>MaxAmp)|(peak(:,5)<MinAmp);
    peak(OutLimits,:)=[];
    
    coinc=find(peak(:,3)==0);
    peak(coinc,5)=peak(coinc+1,5);
    peak(coinc+1,:)=[];

    peak(:,5)=peak(:,5)*CalK*5.9*CalAmplf/(CalAmp*MesAmplf);

    
    Data(FileCount,1)=min(peak(:,5));
    Data(FileCount,2)=max(peak(:,5));
    Data(FileCount,3)=CalK;
    Data(FileCount,4)=MesAmplf;
    Data(FileCount,5)=str2num(PeakFileName(regexp(PeakFileName,'[0-9]')));
    Data(FileCount,6)=offset;

    PeakN=size(peak,1);
    peaks(1:PeakN,:,FileCount)=peak;
    clear peak;
    continuestr=input('Continue? y/[n]\n','s');
    continuestr=lower(continuestr);
    if isempty(continuestr) continuestr='n'; end;  
end;

tic;
SpectrIntMin=max(Data(:,1));
SpectrIntMin1=input(['Input Minimum Energy in keV of Spectral Window by peaks is ',num2str(SpectrIntMin),'\n']);
if ~isempty(SpectrIntMin1) SpectrIntMin=SpectrIntMin1; end;

SpectrIntMax=min(Data(:,2));
SpectrIntMax1=input(['Input Maximum Energy in keV of Spectral Window by peaks is ',num2str(SpectrIntMax),'\n']);
if ~isempty(SpectrIntMax1) SpectrIntMax=SpectrIntMax1; end;

for i=1:FileCount
    OutLimits=(peaks(:,5,i)<SpectrIntMin)|(peaks(:,5,i)>SpectrIntMax);
    peaks(OutLimits,:,i)=0;
    peaks(:,:,i)=sortrows(peaks(:,:,i),2);
    PeakSum(:,i)=cumsum(peaks(:,5,i));
    StartInd=min(find(PeakSum(:,i)>0));
    SizeN=size([peaks(StartInd,2,i):0.025:peaks(end,2,i)]',1);
    IntTrek(1:SizeN,1,i)=[peaks(StartInd,2,i):0.025:peaks(end,2,i)]';
    IntTrek(1:SizeN,2,i)=interp1(peaks(StartInd:end,2,i),PeakSum(StartInd:end,i),IntTrek(1:SizeN,1,i));
    fprintf('Time of Integration %4.2f\n', toc);
end;



if exist('FLUX')==7
    PulseFolder=[cd,'\FLUX\'];
else
    mkdir(cd,'FLUX');
    PulseFolder=[cd,'\FLUX\'];
end;

exitstr='n';

while exitstr~='y'
    Window=input('Input Window Size in us default is 1000\n');
    if isempty(Window) Window=1000; end;  
    Window=Window/0.025;

    tic;
    for i=1:FileCount
       IntTrekSh(:,2,i)=circshift(IntTrek(:,2,i),Window); IntTrekSh(1:Window,2,i)=0;
       Flux(:,1,i)=IntTrek(:,1,i);
       Flux(:,2,i)=(IntTrek(:,2,i)-IntTrekSh(:,2,i))/Window;
       fprintf('Time of Flux Calculation %4.2f\n', toc);
       tic;
       FileName=[FluxFolder,'F',num2str(Data(i,5),'%03.0f'),'W',num2str(Window*0.025/1000,'%2.1f'),'msS',num2str(SpectrIntMin,'%1.1f'),'-',num2str(SpectrIntMax,'%1.1f'),'keV.dat'];
       WriteLimits=find((Flux(:,2,i)>=0)&(Flux(:,1,i)>Data(i,6)));
       WriteLimits=WriteLimits(1:Window*0.025:end);
       fid=fopen(FileName,'w');
       fprintf(fid,'%3.3f %3.5f\n',Flux(WriteLimits,:,i)');       
       fclose(fid);
       fprintf('Time of writing file %4.2f\n', toc);

       figure('name',FileName);
        plot(Flux(WriteLimits,1,i),Flux(WriteLimits,2,i)); hold on;
    end;
    
    exitstr=input('Exit? y/[n]\n','s');
    exitstr=lower(exitstr);
    if isempty(exitstr) exitstr='n'; end;  
end;