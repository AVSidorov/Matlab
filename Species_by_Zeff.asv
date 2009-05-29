function Ni=Species_by_Zeff(Zeff);


if nargin<1
    Zeff=input('Input Zeff. Default is 3\n');
    if isempty(Zeff)
        Zeff=3;
    end;
end;

Ni=[];

Ni(1,1)=1;
part=input('Input density Part of Hydrogen\n Default is 0.7\n');
if isempty(part)
    Ni(1,2)=0.7;
else
    Ni(1,2)=part;
end;

Z=1;
Zeff_tmp=0;

exitstr='n';
while exitstr~='y'


    z_cor=0;
    while z_cor<1
        fprintf('Previous charge is %3.0g\n',Z);
        z=input('Input charge of ion specie.\n Default is next charge state\n');
        if isempty(z)
            Z=Z+1;
        else
            Z=round(z);
        end;
    
        if not(isempty(find(Ni(:,1)==Z)))
            err_str=input('Default will be last value of specie part changed.\n If input error enter any value\n','s');
            if isempty(err_str)
                Ind=find(Ni(:,1)==Z);
                p_cor=0;
                while p_cor<1
                    part=input('Input density Part of element.\n Default is completing to full Zeff and Charge. Hydrogen part may be corrected\n');
                    if isempty(part)
                        if Z>1
                            Q=sum(Ni(2:end,1).*Ni(2:end,2))-Ni(Ind,1)*Ni(Ind,2);
                            Zeff_t=sum((Ni(2:end,1).^2).*Ni(2:end,2))-Ni(Ind,1)^2*Ni(Ind,2);
                            Ni(Ind,2)=(Zeff-1-Zeff_t+Q)/(Z^2-Z);
                            Ni(1,2)=1-Q-Ni(Ind,2)*Z;
                            z_cor=2;
                            if (Ni(Ind,2)<0)|(Ni(1,2)<0)
                                
                            end;
                                p_cor=1;
                        end;
                    else
                        if 1>=(sum(Ni(1:end,1).*Ni(1:end,2))-Ni(Ind,1)*Ni(Ind,2)+part*Z);
                            Ni(Ind,2)=part;
                            p_cor=1;
                            z_cor=2;
                        else
                            fprintf('Too much. Charge will be unbalanced\n');
                        end;
                    end;
                end;
            end;
        else
            if Z>1
                z_cor=1;
            end;
        end;
    end;

    if z_cor==1;
        Ni(end+1,1)=Z;
    
        p_cor=0;
        
        while p_cor<1
            part=input('Input density Part of element.\n Default is completing to full Zeff and Charge. Hydrogen part may be corrected\n');
            if isempty(part)
                %Ind=find(Ni(1:end-1,1)~=1);
                %Q=sum(Ni(Ind,1).*Ni(Ni(Ind,2));
                %Zeff_t=sum((Ni(Ind,1).^2).*Ni(Ind,2));
                %Ni(end,2)=(Zeff-1-Zeff_t+Q)/(Z^2-Z);
                %Ni(find(Ni(:,1)==1),2)=1-Q-Ni(end,2)*Z;     
                Q=sum(Ni(2:end-1,1).*Ni(2:end-1,2));
                Zeff_t=sum((Ni(2:end-1,1).^2).*Ni(2:end-1,2));
                Ni(end,2)=(Zeff-1-Zeff_t+Q)/(Z^2-Z);
                Ni(1,2)=1-Q-Ni(end,2)*Z;
                if Ni(end,2)<0
                    Ni(end,:)=[];
                end;
                    p_cor=1;
            else
                if 1>=(sum(Ni(1:end-1,1).*Ni(1:end-1,2))+part*Z)
                    Ni(end,2)=part;
                    p_cor=1;
                else
                    fprintf('Too much. Charge will be unbalanced\n');
                end;
            end;
        end;
    end;
    
    Ni=sortrows(Ni);
    Zeff_tmp=sum((Ni(:,1).^2).*Ni(:,2));
    Charge=sum(Ni(:,1).*Ni(:,2));
    Ni
    fprintf('Free charge is %7.5g\n',(1-Charge));
    fprintf('Zeff  is %7.5g\n',Zeff_tmp);
    fprintf('Zeff  required %7.5g\n',Zeff);
    if Zeff_tmp>Zeff
        fprintf('Please reduce species part. Zeff is too high\n');
    end;
    if (Charge==1)&(Zeff_tmp==Zeff) 
        exitstr='y';
    else
        exitstr='n';
    end   
    %exitstr=input('Exit? y/[n]\n','s');
    %exitstr=lower(exitstr);
    %if isempty(exitstr) exitstr='n'; end;  
end;
