function TrekSet=TrekStdVal(TrekSetIn);

tic;

fprintf('>>>>>>>>>TrekStdVal Started>>>>>>>>>\n');
TrekSet=TrekSetIn;




trek=TrekSet.trek;

OverSt=3;
MeanVal=mean(trek);
M=MeanVal;
StdVal=std(trek);
St=StdVal;
Thr=OverSt*StdVal; 



if isfield(TrekSet,'OverSt');
    if TrekSet.OverSt>0
        OverSt=TrekSet.OverSt;
    end;
end;

if isfield(TrekSet,'MeanVal')
        if TrekSet.MeanVal~=0
            MeanVal=TrekSet.MeanVal;
        end;
end;

if isfield(TrekSet,'StdVal')
        if TrekSet.StdVal>0
            StdVal=TrekSet.StdVal;
        end;
end;

if isfield(TrekSet,'Threshold')
      if TrekSet.Threshold>0
          Thr=TrekSet.Threshold/2; %/2 because Threshold is for FrontHigh,
                                   % which is generaly double noise amlitude.
      end;
end;

Positive=size(find(trek-(M+2*Thr)>0),1);  
Negative=size(find(trek-(M-2*Thr)<0),1); 

if Positive>Negative 
    PeakPolarity=1;
else
    PeakPolarity=-1;   
end; 


if (abs(M)<Thr)
    Noise=abs(trek)<Thr;
    StdVal=std(trek(Noise));
else
    trek=PeakPolarity*(trek-MeanVal);
    if M==MeanVal
        dSt=1;
        dM=1;
        while (dSt>0.1)||(dM>1e-4)
           Noise=abs(trek)<Thr;
           St=[St;std(trek(Noise))];
           M=[M;mean(trek(Noise))];           
           dM=abs(M(end)-M(end-1));
           dSt=abs(St(end)-St(end-1));
           trek=trek-M(end);
           if Thr==OverSt*St(end-1);
               Thr=OverSt*St(end);
           end;
        end;
        MeanVal=sum(M);
        fprintf('MeanVal is          = %7.4f\n', MeanVal);       
        fprintf('First mean search   = %7.4f  sec\n', toc); 
    end;
       Noise=abs(trek)<Thr;
       StdVal=std(trek(Noise));    
end;

TrekSet.trek=trek;
TrekSet.size=size(TrekSet.trek,1);  
TrekSet.MeanVal=MeanVal;
if not(isfield(TrekSet,'PeakPolarity'))
    TrekSet.PeakPolarity=PeakPolarity;
end;
TrekSet.StdVal=StdVal;




fprintf('Standard deviat     = %7.4f\n', StdVal);
fprintf('>>>>>>>>>TrekStdVal Finished>>>>>>>>>\n');
toc;








