%function TrekIntegr(FileName1,PeakFileName);
function TrekIntegr1(PeakFileName);
offset=input('Input Trek time offset us defualt is 14600\n');
if isempty(offset) offset=14600; end;  
MaxAmp=input('Input Maximum Peak Amplitude defualt is 2500\n');
if isempty(MaxAmp) MaxAmp=2500; end;  
MinAmp=input('Input Minimum Peak Amplitude defualt is 0\n');
if isempty(MinAmp) MinAmp=0; end;  
CalAmp=input('Input Calibration Amplitude for 5.9 keV defualt is 1641\n');
if isempty(CalAmp) CalAmp=1641; end;  
CalAmplf=input('Input  Amplfication of Calibration defualt is 11\n');
if isempty(CalAmplf) CalAmplf=11; end;  
MesAmplf=input('Input  Amplfication of Measure defualt is 35\n');
if isempty(MesAmplf) MesAmplf=35; end;  
CalK=input('Input Energy Calibration  Koeff defualt is 1\n');
if isempty(CalK) CalK=1; end;  

tic;
 if isstr(PeakFileName) 
%      fid = fopen(PeakFileName, 'r');    line = fgetl(fid);     peaks=[]; 
%      while not(feof(fid))  
%          peaks=[peaks; fscanf(fid,'%g',7)'];    
%      end; 
%      fclose(fid); 
    peaks=load(PeakFileName);
 else    
     if nargin==2 peaks=PeakFileName; end;
 end;  
fprintf('Time of load %4.2f\n', toc);
OutLimits=(peaks(:,5)>MaxAmp)|(peaks(:,5)<MinAmp)
peaks(OutLimits,:)=[];
coinc=find(peaks(:,3)==0);
peaks(coinc,5)=peaks(coinc+1,5);
peaks(coinc+1,:)=[];

peaks(:,5)=peaks(:,5)*CalK*5.9*CalAmplf/(CalAmp*MesAmplf);
tic;
TrekSum=cumsum(peaks(:,5));
IntTrek(:,1)=[peaks(1,2):0.025:peaks(end,2)]';
% IntTrek(:,2)=interp1(peaks(:,2),TrekSum,IntTrek(:,1),'nearest');
IntTrek(:,2)=interp1(peaks(:,2),TrekSum,IntTrek(:,1));
fprintf('Time of Integration %4.2f\n', toc);

Flux(:,1)=offset+IntTrek(:,1);

exitstr='n';
while exitstr~='y'
    Window=input('Input Window Size in us default is 1000\n');
    if isempty(Window) Window=1000; end;  
    Window=Window/0.025;

    tic;
    IntTrekSh(:,2)=circshift(IntTrek(:,2),Window); IntTrekSh(1:Window,2)=0;
    Flux(:,2)=(IntTrek(:,2)-IntTrekSh(:,2))/Window;
    fprintf('Time of Flux Calculation %4.2f\n', toc);
    tic;
    SmParam=input('Input Smooth Time in us default is 1 NO SMOOTH\n');
    if isempty(SmParam) SmParam=1; end;  
    SmParam=SmParam/0.025;
    Flux(:,3)=smooth(Flux(:,2),SmParam);
    fprintf('Time of Smoothing %4.2f\n', toc);
    tic;
    FluxFolder=[cd,'\FLUX\'];
    if isstr(PeakFileName)
        [path,name,ext,versn]=fileparts(PeakFileName);
        FileName=[FluxFolder,'F',name(regexp(name,'[0-9]')),'W',num2str(Window*0.025),'usSm',num2str(SmParam*0.025),'us.dat'];
      else
          
     end;
     fid=fopen(FileName,'w');
     fprintf(fid,'%5.3f %5.3f %5.3f\n',Flux(1:Window*0.025:end,:)');       
     fclose(fid);
     fprintf('Time of writing file %4.2f\n', toc);

     figure('name',FileName);
        plot(Flux(:,1),Flux(:,2)); hold on;
        plot(Flux(:,1),Flux(:,3),'g','linewidth',3);
    
    exitstr=input('Exit? y/[n]\n','s');
    exitstr=lower(exitstr);
    if isempty(exitstr) exitstr='n'; end;  
end;