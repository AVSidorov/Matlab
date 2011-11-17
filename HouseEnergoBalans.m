function HouseEnergoBalans(Tstreet);
%House geometry
Swall=700-200/7;    %[m^2] full area including bootom and roof
Swindow=200/7;      %[m^2] by SNiP Swindow must be at least 1/8 from square of living area from 60N at least 1/6.6
Lwall=0.5;          %[m] Wall width
V=000;             %[m^3] House volume

%House material
KTwall=0.8 ;        %[W/m/K] 
                    % for best insulators penopolisterol and mineral vata
                    % 0.03-0.055 kirpich 0.8 beton 1.16 beton light 0.35 
                    % beton porist 0.2 derevo 0.15-0.17 stal 47
KTwindow=2;         %[W/m^2/K] for steklopaket
Cwater=4.2e3;       %[J/kg/K]
Cair=1.2e3;         %[J/m^3/K] C=1.005-1.03 kJ/kg/K ro=1.2kg/m^3 (at 20C)
Mwater=1000;         %[kg]


sgm=5.6704e-8;      %[W/m^2/K^4] Stefan-Bolzman equation constant;

To=20;            %[C] starting T   
Pin=347;          %[W] power of heating
                  %347W if 250kWh/month electropower consumtion in house appartment



Prad=zeros(numel(Tstreet),1);
Pout=Prad;

T=zeros(numel(Tstreet)+1,1);
T(1)=To;
for i=1:numel(Tstreet)
    Prad(i)=(Swall+Swindow)*0.8*sgm*((273.15+Tstreet(i))^4-(273.15+T(i))^4);
    Pout(i)=(KTwall*Swall/Lwall+KTwindow*Swindow)*(Tstreet(i)-T(i));
    T(i+1)=T(i)+(Pin+Prad(i)+Pout(i))/(Cair*V+Cwater*Mwater);
end;

figure;
    subplot(2,1,1);
        grid on; hold on;
        plot(Tstreet);
        plot([0:numel(Tstreet)],T,'r');
    subplot(2,1,2);
        grid on; hold on;
        plot(Prad,'b');
        plot(Pout,'r');
        

% CloseGraphs;

