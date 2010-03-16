function Ratio=RelAmp(AmpBase,AmpRel);

for i=1:size(AmpBase,1)-1;
   tmp=AmpBase(i,2);
   for ii=1:size(AmpBase,1)-i
    if AmpBase(i,1)==AmpBase(i+ii,1)
      tmp=[tmp;AmpBase(i+ii,2)];
      AmpBase(i+ii,1)=0;
      AmpBase(i+ii,2)=AmpBase(i,2);
    else
      break;
    end;    
   end;
   AmpBase(i,2)=mean(tmp);
end;
bool=AmpBase(:,1)==0;
AmpBase(bool,:)=[];

for i=1:size(AmpRel,1)-1;
   tmp=AmpRel(i,2);
   for ii=1:size(AmpRel,1)-i
    if AmpRel(i,1)==AmpRel(i+ii,1)
      tmp=[tmp;AmpRel(i+ii,2)];
      AmpRel(i+ii,1)=0;
      AmpRel(i+ii,2)=AmpRel(i,2);
    else
      break;
    end;    
   end;
   AmpRel(i,2)=mean(tmp);
end;
bool=AmpRel(:,1)==0;
AmpRel(bool,:)=[];

StartHV=max([AmpBase(1,1),AmpRel(1,1)]);
EndHV=min([AmpBase(end,1),AmpRel(end,1)]);
Ratio(:,1)=[StartHV:25:EndHV];
bool1=AmpBase(:,1)>=StartHV&AmpBase(:,1)<=EndHV;
bool2=AmpRel(:,1)>=StartHV&AmpRel(:,1)<=EndHV;
A1=interp1(AmpBase(bool1,1),AmpBase(bool1,2),Ratio(:,1),'linear');
A2=interp1(AmpRel(bool2,1),AmpRel(bool2,2),Ratio(:,1),'linear');
Ratio(:,2)=A2./A1;


