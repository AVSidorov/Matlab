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
    fprintf('Previous charge is %3.0g\n',Z);
    z=input('Input charge of ion specie.\n Default is next charge state\n');
    if isempty(z)
        Z=Z+1;
    else
        Z=round(z);
        if Z==0 
            Z=2;
        end;
    end;
    
    if isempty(find(Ni(:,1)==Z))
        Ni(end+1,1)=Z;
    end

    Ni=sortrows(Ni);

        
    Zeff_tmp=sum((Ni(:,1).^2).*Ni(:,2));
    Charge=sum(Ni(:,1).*Ni(:,2));
        
    Ind=find(Ni(:,1)==Z);

    Q=sum(Ni(2:end,1).*Ni(2:end,2))-Ni(Ind,1)*Ni(Ind,2);
    Zeff_t=sum((Ni(2:end,1).^2).*Ni(2:end,2))-Ni(Ind,1)^2*Ni(Ind,2);
    part_Z=(Zeff-1-Zeff_t+Q)/(Z^2-Z);
    part_H=1-Q-part_Z*Z;
       
    fprintf('Full charge is %7.5g\n',Charge);
    fprintf('Zeff  is %7.5g\n',Zeff_tmp);
    fprintf('To complete to required Zeff (Default) relative density of:\r Z=%3.0g is %7.5g\r Hydrogen is %7.5g\n',Z,part_Z,part_H); 
 
    p_cor=0;
    while p_cor<1
        part=input('Input density Part of element.\n Default is completing to full Zeff and Charge. Hydrogen part may be corrected\n');
        if isempty(part)
            Ni(Ind,2)=part_Z;
            Ni(1,2)=part_H;
            p_cor=1;
        else
            if part<part_Z
                Ni(Ind,2)=part;
                p_cor=1;
            else
                fprintf('Part density is incorrect\n');
            end;
        end;
    end;
        
    
    Zeff_tmp=sum((Ni(:,1).^2).*Ni(:,2));
    Charge=sum(Ni(:,1).*Ni(:,2));
    Ni
    fprintf('Full charge is %7.5g\n',Charge);
    fprintf('Zeff  is %7.5g\n',Zeff_tmp);

    if (Charge==1)&(Zeff_tmp==Zeff) 
        exitstr='y';
    else
        exitstr='n';
    end   
end;
