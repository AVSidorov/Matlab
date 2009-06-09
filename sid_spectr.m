function spectr=sid_spectr(peaks,SpecStep,SpecInterval,SmoothParam);
if nargin==1  
    [spectr,SpecInterval,SpecStep]=sid_hist(peaks,5);
    SmoothParam=1;
end;
if nargin==2|isempty(SpecInterval);  
    [spectr,SpecInterval,SpecStep]=sid_hist(peaks,5,SpecStep);
    if nargin==2; SmoothParam=1; end;
end;
if nargin==3  
    spectr=sid_hist(peaks,5,SpecStep,SpecInterval);
    SmoothParam=1;  
end;
if nargin==4  
    spectr=sid_hist(peaks,5,SpecStep,SpecInterval);
end;

spectr(:,2)=smooth(spectr(:,2),SmoothParam);
spectr(:,3)=sqrt(spectr(:,2));
TimeInterval=peaks(end,2)-peaks(1,2);
spectr(:,2)=spectr(:,2)/SpecInterval/(TimeInterval/1000);
spectr(:,3)=spectr(:,3)/SpecInterval/(TimeInterval/1000);
