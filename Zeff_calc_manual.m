function [Ni,Zeff]=Zeff_calc_manual(ne);
ne_def=3e13;
Ni=[];
if nargin<1
    ne=ne_def;
end;
fprintf('Ne=%5.3e Inputed.\n',ne);
if ne==0
    fprintf('Ne will by calculated by full charge.\n');
end;

Z=0;

exitstr='n';
while exitstr~='y'


    z=input('Input charge of ion specie.\n Default is next charge state\n');
    if isempty(z)
        Z=Z+1;
    else
        Z=z;
    end;
    
    Ni(end+1,1)=Z;
    
    part=input('Input density Part of element.\n Default is input by absolute density.\n');
    if isempty(part)
        ni=input('Input concentration in cm^-3 units.\n Default is comleting to full charge.\n');
        if isempty(ni)
            if ne==0
                Ni(end,2)=1;
                ne=ne_def;
            else
                Ni(end,2)=(1-sum(Ni(1:end-1,1).*Ni(1:end-1,2)))/Z;
            end;
        else
            Ni(end,2)=ni/ne;
        end;
    else
        Ni(end,2)=part;
    end;
    fprintf('Free charge is %5.3d\n',(1-sum(Ni(:,1).*Ni(:,2))));
    if sum(Ni(:,1).*Ni(:,2))<1 
        exitstr='n';
    else
        exitstr='y';
    end   
    %exitstr=input('Exit? y/[n]\n','s');
    %exitstr=lower(exitstr);
    %if isempty(exitstr) exitstr='n'; end;  
end;
Ni
Zeff=sum((Ni(:,1).^2).*Ni(:,2));
fprintf('Zeff is %3.2d\n',Zeff);