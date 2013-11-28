function TrekSet=TrekSDDPeakSearch(TrekSetIn,EndOut)

tic;
disp('>>>>>>>>TrekPeakSearch started');

TrekSet=TrekSetIn;


if nargin<2
    EndOut=true;
end;



OverSt=TrekSet.OverSt;
trek=TrekSet.trek;
trSize=TrekSet.size;
%% working with special diferential
longD=TrekSet.trek-circshift(TrekSet.trek,TrekSet.STP.FrontN);
longD(1:TrekSet.STP.FrontN)=0;
if isfield(TrekSet,'ThresholdLD')
    ThresholdLD=TrekSet.ThresholdLD;
else
    ThresholdLD=[];
end;
if isempty(ThresholdLD)
   NoiseSet=NoiseFit(longD);
   ThresholdLD=NoiseSet.Threshold+NoiseSet.MeanVal;
end;
SelectedBool=longD>=ThresholdLD;%&trek<TrekSet.MaxSignal;
SelectedInd=find(SelectedBool);
SelectedN=numel(SelectedInd);

%% =====  End                                  

TrekSet.ThresholdLD=ThresholdLD;
TrekSet.SelectedPeakInd=SelectedInd;
TrekSet.PeakOnFrontInd=[];
TrekSet.LongFrontInd=[];
TrekSet.strictStInd=SelectedInd-TrekSet.STP.MaxInd;
TrekSet.strictStInd(TrekSet.strictStInd<1)=1;
TrekSet.strictEndInd=SelectedInd;

%% ===== End information
if EndOut %to avoid statistic typing in short calls
    fprintf('=====  Search of peak tops      ==========\n');
    fprintf('The number of measured points  = %7.0f during %7.0f us \n',trSize,trSize*TrekSet.tau);
    fprintf('Threshold is %3.1f*%5.3f = %5.3f \n',ThresholdLD/TrekSet.StdVal,TrekSet.StdVal,ThresholdLD);
    fprintf('OverSt is %3.1f\n',OverSt);
%     fprintf('The total number of maximum = %7.0f \n',MaxND);
    fprintf('The number of selected peaks = %7.0f \n',SelectedN);
%    fprintf('The number peaks selected on Front= %7.0f \n',PeakOnFrontN);
    fprintf('>>>>>>>>>>>>>>>>>>>>>>Search by Front Finished\n');
end;
%%
fprintf('TrekSDDPeakSearch time %3.2f\n',toc);
%% end plot
 if TrekSet.Plot&&EndOut
   figure;
   plot(TrekSet.trek);
   s='trek';
   grid on; hold on;
   if not(isempty(SelectedInd))
       plot(SelectedInd,TrekSet.trek(SelectedInd),'.r');
       s=char(s,'SelectedInd');
   end;
   warning off; 
   legend(s);
   warning on;
      pause;
%        close(gcf);
 end;





