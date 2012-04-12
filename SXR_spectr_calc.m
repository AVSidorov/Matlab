function [Spectr,Ni]=SXR_spectr_calc(ne,Te,varargin)
%calculates Thermal Bremsstrahlung and recombination spectra 
Ni=[];
Ew=[];

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    disp('incorrect number of input arguments');
    return;
else
   for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
%     switch varargin(1+2*(i-1))
%         case 'Ni'
%             Ni=varargin(2*i);
%         case 'Ew'
%             Ew=varagin(2*i);
%       end;
%    end;
    end;
end;

if isempty(Ni)
    Ni=Species_by_Zeff;
end;
if isempty(Ew)
    Ew=250:10:10000;
end;

Jb=zeros(size(Ew));
Jr=zeros(size(Ew));
for i=1:max(size(Ni))
    Z=Ni(i,1);
    ni=Ni(i,2)*ne;
    [jb(:,i),jr(:,i)]=J_calc(ne,ni,Z,Te,Ew);
    Jb(:)=Jb(:)+jb(:,i);
    Jr(:)=Jr(:)+jr(:,i);
end;    

% figure;
    semilogy(Ew,Jb(:),'-g','LineWidth',2);
    hold on; grid on;
    semilogy(Ew,Jr(:),'-b','LineWidth',2);
    semilogy(Ew,Jb(:)+Jr(:),'-r','LineWidth',3);
    semilogy(Ew,jb(:,find(Ni(:,1)==1)),'-c','LineWidth',2);
        
Spectr(:,1)=Ew;
Spectr(:,2)=Jb(:)+Jr(:);