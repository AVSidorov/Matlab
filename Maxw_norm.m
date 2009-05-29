function MaxwNorm=Maxw_Norm(Maxw);
%This Program makes normalized spectr with amplitude equal 1
%from given "measured" "Maxwellian" spectr. 

Maxw(:,3)=Maxw(:,3).*1e5;
MaxwNorm=Maxw;
for i=1:9
    StI=(i-1)*12+2;
    EndI=i*12;
%     [Max_M,Max_Ind]=max(Maxw(StI:EndI,3));
%     Maxw_i=interp1(Maxw(StI+Max_Ind-3:StI+Max_Ind+2,2),Maxw(StI+Max_Ind-3:StI+Max_Ind+2,3),[Maxw(StI+Max_Ind-3,2):(Maxw(StI+Max_Ind+2,2)-Maxw(StI+Max_Ind-3,2))/100:Maxw(StI+Max_Ind+2,2)],'spline');
    Maxw_i=interp1(Maxw(StI:EndI,2),Maxw(StI:EndI,3),[Maxw(StI,2):(Maxw(EndI,2)-Maxw(StI,2))/1000:Maxw(EndI,2)],'spline');
    Max_i=max(Maxw_i);
    MaxwNorm(StI:EndI,3)=Maxw(StI:EndI,3)./Max_i;

    sf=figure;
    semilogy(Maxw(StI:EndI,2),Maxw(StI:EndI,3),'-*b');
    hold on; 
    semilogy([Maxw(StI,2):(Maxw(EndI,2)-Maxw(StI,2))/1000:Maxw(EndI,2)],Maxw_i,'r');
    semilogy(MaxwNorm(StI:EndI,2),MaxwNorm(StI:EndI,3),'->g');
    pause;
    close(sf);
    clear Maxw_i Max_i
end;
