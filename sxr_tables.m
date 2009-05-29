function [Notn]=sxr_tables;
tic;
for Te=0.1:0.01:1.5
    for dBe=100:100:700
        F=inline(['(0.0136./T)^0.5.*exp(-x./T).*exp(-0.12.*d./x.^3.12).*(1-exp(-345.55./x.^2.7))'],'x','T','d');
        N(round((Te-0.1)/0.01+1),1)=Te*1000;
        N(round((Te-0.1)/0.01+1),dBe/100+1)=quadl(F,0.001,20,10e-15,[],Te,dBe);
    end;
end;
fprintf('Table calculation %3.2fsec\n',toc);
Notn(:,1)=N(:,1);
Notn1(:,1)=N(:,1);
for i=2:8
   Notn(:,i)=N(:,2)./N(:,i);
   Notn1(:,i)=N(:,i)./N(:,2);
end;
Notn1=Notn1';
fid=fopen('sxr_table.dat','w');
fprintf(fid,'%4.0f %4.0f %4.5f %4.5f %4.5f %4.5f %4.5f %4.5f\n',Notn'); 
fclose(fid);
save('sxr_table1.dat','-ascii','Notn1')