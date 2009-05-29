function sxr_tables1(TableFile);
if isstr(TableFile)
    Notn=load(TableFile);
else
    if TableFile~=0
        Notn=TableFile;
    else
        tic;
        for Te=0.1:0.01:1.5
            for dBe=100:100:700
                F=inline(['(0.0136./T)^0.5.*exp(-x./T).*exp(-0.12.*d./x.^3.12).*(1-exp(-345.55./x.^2.7))'],'x','T','d');
                N(round((Te-0.1)/0.01+1),1)=Te*1000;
                N(round((Te-0.1)/0.01+1),dBe/100+1)=quadl(F,0.001,20,10e-11,[],Te,dBe);
            end;
        end;
        fprintf('Table calculation %3.2fsec\n',toc);
        Notn(:,1)=N(:,1);
        for i=2:8
           Notn(:,i)=N(:,2)./N(:,i);
        end;
    end;
end;
NSize=size(Notn,1); 
exitstr='n';
%if isempty(Ratio) Ratio=3; end;
Ratio=3;
while exitstr~='y'
    BeThk=input('Input second Be foil thikness in um \nFirst is 100um Default 200 um\n');
    if isempty(BeThk) BeThk=200; end;
    fprintf('Input Signal Ratio Default is %2.4f\n',Ratio);
    Ratio1=input('');
    if isempty(Ratio1) Ratio=Ratio; else Ratio=Ratio1; end;
 i=1;
 while Ratio<Notn(i,round(BeThk/100)+1)
    i=i+1;
 end;
 Te=Notn(i-1,1)+(Notn(i,1)-Notn(i-1,1))*(Ratio-Notn(i-1,round(BeThk/100)+1))/(Notn(i,round(BeThk/100)+1)-Notn(i-1,round(BeThk/100)+1));
 fprintf('Te is %4.0feV\n',Te);
    
 exitstr=input('Exit? y/[n]\n','s');
 exitstr=lower(exitstr);
 if isempty(exitstr) exitstr='n'; end;  
end;