function TrekSet=TrekPeakReSearch(TrekSetIn);

% 
% 
%         if  (max(trek(DisturbInd))-min(trek(DisturbInd)))>2*TrekSet.Threshold
% 
%             TrekSet.SelectedPeakFrontN(TrekSet.SelectedPeakInd>SubtractInd(SubtractIndPulse==MaxInd)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
%             TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd>SubtractInd(SubtractIndPulse==MaxInd)&TrekSet.SelectedPeakInd<=SubtractInd(end))=[];
%             TrekSet.PeakOnFrontInd(TrekSet.PeakOnFrontInd>SubtractInd(SubtractIndPulse==MaxInd)&TrekSet.PeakOnFrontInd<=SubtractInd(end))=[];
%             TrekSet.PeakOnTailInd(TrekSet.PeakOnTailInd>SubtractInd(SubtractIndPulse==MaxInd)&TrekSet.PeakOnTailInd<=SubtractInd(end))=[];
%             TrekSet.LongFrontInd(TrekSet.LongFrontInd>SubtractInd(SubtractIndPulse==MaxInd)&TrekSet.LongFrontInd<=SubtractInd(end))=[]; 
% 
%             TrekSet1=TrekSet;
%             TrekSet1.Plot=false;
%             TrekSet1.trek=[TrekSet.StdVal;-TrekSet.StdVal;0;trek(SubtractInd(SubtractIndPulse>MaxInd))];
%             %first 3 points is necessary for making
%             %minimum before pulse 
%             TrekSet1.size=numel(TrekSet1.trek);
%             TrekSet1.SelectedPeakInd=[];
%             TrekSet1.SelectedPeakFrontN=[];
%             TrekSet1.PeakOnFrontInd=[];
%             TrekSet1.PeakOnTailInd=[];
%             TrekSet1.LongFrontInd=[];
%             TrekSet1.Threshold=2*TrekSet.Threshold;
%             TrekSet1=TrekPeakSearch(TrekSet1);
% 
%             TrekSet1.SelectedPeakInd=TrekSet1.SelectedPeakInd-1+SubtractInd(MaxInd+1)-3;
%             TrekSet1.PeakOnFrontInd=TrekSet1.PeakOnFrontInd-1+SubtractInd(MaxInd+1)-3;
%             TrekSet1.PeakOnTailInd=TrekSet1.PeakOnTailInd-1+SubtractInd(MaxInd+1)-3;
%             TrekSet1.LongFrontInd=TrekSet1.LongFrontInd-1+SubtractInd(MaxInd+1)-3;
% 
%             for IndI=1:numel(TrekSet1.SelectedPeakInd)
%                 if isempty(find(TrekSet1.SelectedPeakInd(IndI)==TrekSet.SelectedPeakInd(:)))
%                     TrekSet.SelectedPeakInd(end+1)=TrekSet1.SelectedPeakInd(IndI);
%                     TrekSet.SelectedPeakFrontN(end+1)=TrekSet1.SelectedPeakFrontN(IndI);                                    
%                     [TrekSet.SelectedPeakInd,index]=sortrows(TrekSet.SelectedPeakInd);
%                     TrekSet.SelectedPeakFrontN=TrekSet.SelectedPeakFrontN(index,:);
%                 end;
%             end;
% 
%             for IndI=1:numel(TrekSet1.PeakOnFrontInd)
%                 if isempty(find(TrekSet1.PeakOnFrontInd(IndI)==TrekSet.PeakOnFrontInd(:)))
%                     TrekSet.PeakOnFrontInd(end+1)=TrekSet1.PeakOnFrontInd(IndI);
%                     TrekSet.PeakOnFrontInd=sortrows(TrekSet.PeakOnFrontInd);
%                 end;
%             end;
% 
%             for IndI=1:numel(TrekSet1.PeakOnTailInd)
%                 if isempty(find(TrekSet1.PeakOnTailInd(IndI)==TrekSet.PeakOnTailInd(:)))
%                     TrekSet.PeakOnTailInd(end+1)=TrekSet1.PeakOnTailInd(IndI);
%                     TrekSet.PeakOnTailInd=sortrows(TrekSet.PeakOnFrontInd);
%                 end;
%             end;
% 
%             for IndI=1:numel(TrekSet1.LongFrontInd)
%               if isempty(find(TrekSet1.LongFrontInd(IndI)==TrekSet.LongFrontInd(:)))
%                     TrekSet.LongFrontInd(end+1)=TrekSet1.LongFrontInd(IndI);
%                     TrekSet.LongFrontInd=sortrows(TrekSet.LongFrontInd);
%                 end;
%             end;
%             PeakN=numel(TrekSet.SelectedPeakInd); %because number of markers can change if TrekPeakSearch will be called
% 
%         end;

      
