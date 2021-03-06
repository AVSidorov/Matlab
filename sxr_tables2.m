function Te=sxr_tables2(TableFile,Ratio,BeThk);
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
 if Ratio>0
 i=1;
 while (Ratio<Notn(i,round(BeThk/100)+1))&(i~=NSize)
    if i<NSize  i=i+1; end;
 end;
 if (i>1)&(i<=NSize)
     Te=Notn(i-1,1)+(Notn(i,1)-Notn(i-1,1))*(Ratio-Notn(i-1,round(BeThk/100)+1))/(Notn(i,round(BeThk/100)+1)-Notn(i-1,round(BeThk/100)+1));
 else
     Te=-1;
 end;
 if Te>2500 Te=-2; end;
 else
     Te=-3;
 end;