function [TrekSet,Ind,FIT,Ch]=TrekSDDManualPeakSearch(TrekSet,Ind,FIT)
Ch=0;
if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;
while Ch~=1&&Ch~=3
x=Ind-STP.size:Ind+STP.size;
x(x<1|x>TrekSet.size)=[];
Xbool=false(size(TrekSet.trek));
Xbool(x)=true;
SelectedBool=false(size(TrekSet.trek));
SelectedBool(TrekSet.SelectedPeakInd)=true;
SelectedInds=find(SelectedBool&Xbool);

SubtractInd=[1:FIT.FitPulseN]+Ind-STP.MaxInd;
SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
SubtractIndPulse=SubtractInd-Ind+STP.MaxInd;

PulseSubtract=FIT.FitPulse*FIT.A;

%%
fprintf('Ind is %d\n',Ind);
fprintf('Shift is %5.3f\n',FIT.Shift);
%%
h=figure;
plot(x,TrekSet.trek(x),'.b-');
grid on; hold on;
if isfield(FIT,'FitIndStrict');
    plot(FIT.FitIndStrict,TrekSet.trek(FIT.FitIndStrict),'ob');
end;

plot(Ind,TrekSet.trek(Ind),'*r');
plot(SelectedInds,TrekSet.trek(SelectedInds),'.r');
plot([Ind-FIT.Shift,Ind-FIT.Shift],[0,FIT.A],'r');
plot(SubtractInd,PulseSubtract(SubtractIndPulse)+FIT.B,'r');
if isfield(FIT,'FitIndPulseStrict');
    plot(FIT.FitIndPulseStrict+Ind-TrekSet.STP.MaxInd,PulseSubtract(FIT.FitIndPulseStrict),'.r');
end;
%%
disp('What to do?');
disp('If ''s'' skip fit');
disp('If empty  change all params');
disp('If ''s'' skip');
disp('If ''i'' change Ind');
disp('If ''n'' jump to next Ind');
disp('If ''p'' jump to previous Ind');
disp('If ''c'' make fit with current params');
s=input('Make you choice\n','s');
s=lower(s);
switch s
    case ''
        fprintf('Input Ind. Default is %d\n',Ind);
        Indn=input('Ind is ');
        if isempty(Indn)
            Indn=Ind;
        end;
        Ind=Indn;
        
        fprintf('Input ShiftRangeL\n')
        if isfield(FIT,'ShiftRangeL');
            fprintf('Default is %d\n',FIT.ShiftRangeL);
        end;
        ShiftRangeL=input('ShiftRangeL is ');
        if isempty(ShiftRangeL)&&isfield(FIT,'ShiftRangeL')
            ShiftRangeL=FIT.ShiftRangeL;
        end;
        FIT.ShiftRangeL=ShiftRangeL;
        
        fprintf('Input ShiftRangeR\n')
        if isfield(FIT,'ShiftRangeR');
            fprintf('Default is %d\n',FIT.ShiftRangeR);
        end;
        ShiftRangeR=input('ShiftRangeR is ');
        if isempty(ShiftRangeR)&&isfield(FIT,'ShiftRangeR')
            ShiftRangeR=FIT.ShiftRangeR;
        end;
        FIT.ShiftRangeR=ShiftRangeR;
        
        fprintf('Input StrictInd. Format is [*:/,***]\n')
        if isfield(FIT,'FitIndStrict');
            fprintf('Default is [%d:%d]\n',FIT.FitIndStrict(1),FIT.FitIndStrict(end));
        end;
        FitIndStrict=input('StrictInd is ');
        if isempty(FitIndStrict)&&isfield(FIT,'FitIndStrict')
            FitIndStrict=FIT.FitIndStrict;
        end;
        FIT.FitIndStrict=FitIndStrict;
        
        fprintf('Input PulseStrictInd. Format is [*:/,***]\n')
        if isfield(FIT,'FitIndPulseStrict');
            fprintf('Default is [%d:%d]\n',FIT.FitIndPulseStrict(1),FIT.FitIndPulseStrict(end));
        end;
        FitIndPulseStrict=input('PulseStrictInd is ');
        if isempty(FitIndPulseStrict)&&isfield(FIT,'FitIndPulseStrict')
            FitIndPulseStrict=FIT.FitIndPulseStrict;
        end;
        FIT.FitIndPulseStrict=FitIndPulseStrict;

        fprintf('Input pulse Amplitude\n')
        if isfield(FIT,'A');
            fprintf('Default is %4.0f\n',FIT.A);
        end;
        A=input('Amplitude is ');
        if isempty(A)&&isfield(FIT,'A')
            A=FIT.A;
        end;
        FIT.A=A;
        if ~(isfield(FIT,'B')&&~isempty(FIT.B))
            FIT.B=0;
        end;
        FitPulse=TrekSDDGetFitPulse(STP,0);
        FIT.FitPulse=FitPulse;
        FIT.Shift=0;
        FIT=TrekGetFitInd(TrekSet,Ind,FIT);
        FitIndPulse=FIT.FitIndPulse;
        FitInd=FIT.FitInd;
        if FIT.FitFast
            A=sum(FitPulse(FitIndPulse).*TrekSet.trek(FitInd))/sum(FitPulse(FitIndPulse).^2);
            B=0;
        else
            p=polyfit(FitPulse(FitIndPulse),TrekSet.trek(FitInd),1);
            A=p(1);
            B=p(2);
        end; 
        FIT.A=A;
        FIT.B=B;
        Ch=2;
    case 's'    
        Ch=1;
    case 'n'
        Ind=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd>Ind,1,'first'));
        FIT.FitIndStrict=[];
        FIT.FitIndPulseStrict=[];
        FIT.ShiftRangeL=[];
        FIT.ShiftRangeR=[];
        Ch=3;
    case 'p'
        Ind=TrekSet.SelectedPeakInd(find(TrekSet.SelectedPeakInd<Ind,1,'last'));
        FIT.FitIndStrict=[];
        FIT.FitIndPulseStrict=[];
        FIT.ShiftRangeL=[];
        FIT.ShiftRangeR=[];
        Ch=3;        
    case 'c'
        Ch=3;
end;
if exist('h','var')&&~isempty(h)&&ishandle(h)
    close(h);        
end;
end;