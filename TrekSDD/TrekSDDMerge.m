function [TrekMerged,fit]=TrekSDDMerge(TrekSetIn,varargin)

%This function merges treks written in differen ADC channels with
%different ranges. 

%% initial check and loading input file
if isstruct(TrekSetIn)&&isfield(TrekSetIn,'Merged')&&TrekSetIn.Merged
    TrekMerged=TrekSetIn;
    fit=[];
    return;
elseif isstruct(TrekSetIn)&&isfield(TrekSetIn,'FileName')&&~isempty(TrekSetIn.FileName)
    if ~isempty(regexp(TrekSetIn.FileName,'^(\d{2,3}sxr)([2,3,4])?(.dat)$'))
        FileBase=regexprep(TrekSetIn.FileName,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$1');
        FileSufix=regexprep(TrekSetIn.FileName,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$2');
    end;
elseif ischar(TrekSetIn)    
    if ~isempty(regexp(TrekSetIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$'))
        FileBase=regexprep(TrekSetIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$1');
        FileSufix=regexprep(TrekSetIn,'^(\d{2,3}sxr)([2,3,4])?(.dat)$','$2');
    end;
end;


fix=false;


TrekSet=[];
StdVals=[];
for i=1:4
 if i==1 Ch=''; else Ch=num2str(i); end;
   FileName=[FileBase,Ch,'.dat'];
   if isempty(TrekSet)
       TrekSet=TrekSDDRecognize(FileName,varargin{:});
   else
      TrekSet(end+1)=TrekSDDRecognize(FileName,'Date',TrekSet(1).Date,... %was varagin{:} 
                                               'Shot',TrekSet(1).Shot,... %if argin is empty, then repeated input follows
                                               'Amp',TrekSet(1).Amp,...
                                               'StartOffset',TrekSet(1).StartOffset,...
                                               'StartPlasma',TrekSet(1).StartPlasma);
   end;
   TrekSet(end).Plot=false; 
   if TrekSet(end).type>0 
        TrekSet(end)=TrekLoad(TrekSet(end));
        TrekSet(end)=TrekSDDNoise(TrekSet(end));
        StdVals(end+1,1)=TrekSet(end).StdVal;
        TrekSet(end)=TrekPickTime(TrekSet(end),TrekSet(1).StartTime,TrekSet(1).size*TrekSet(1).tau);
    else
        TrekSet(end)=[];
    end;
end;                   

fileN=numel(TrekSet);

fit(1,:)=[1,0];

if fileN<2 
    TrekMerged=TrekSet;
    TrekMerged.Merged=false;
    fit=[];
    return;     
end;


[StdVals,index]=sortrows(StdVals,1);
TrekSet=TrekSet(index(end:-1:1));

TrekMerged=TrekSet(1);
% TrekMerged.Plot=true;
for i=2:fileN
    [TrekMerged,fit]=TrekSDDFitTreksCombine(TrekMerged,TrekSet(i));
end;
return;

% if TrekSet(1).Plot
    figure; 
    clr=[0,0,1;1,0,0;0,0,0;1,0,1];
    subplot(2,1,1);
    grid on; hold on;
    for i=1:fileN
        plot(TrekSet(i).trek*fit(i,1)+fit(i,2),'Color',clr(i,:));
    end;
    subplot(2,1,2);
    grid on; hold on;
    for i=2:fileN
        plot(TrekSet(i).trek*fit(i,1)+fit(i,2)-(TrekSet(i-1).trek*fit(i-1,1)+fit(i-1,2)),'Color',clr(i,:));
    end;
% end;