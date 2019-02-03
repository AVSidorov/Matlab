function [Eradial,Epoloidal,EradialAbs,EpoloidalAbs,E,vec]=elm_data_EfieldAverager(tbl,GridSet,icri)
tic;
% tbl is set of sections of electric potential data x ntime
Ntime=size(tbl,2);
[Eradial,Epoloidal,vec]=elm_data_Efield(tbl(:,1),GridSet,icri);
EradialAbs=abs(Eradial);
EpoloidalAbs=abs(Epoloidal);
E=sqrt(Eradial.^2+Epoloidal.^2);
for t=2:Ntime
    [Er,Ep,vec]=elm_data_Efield(tbl(:,t),GridSet,icri);
    Eradial=Eradial+Er;
    Epoloidal=Epoloidal+Ep;
    EradialAbs=EradialAbs+abs(Er);
    EpoloidalAbs=EpoloidalAbs+abs(Ep);
    E=E+sqrt(Er.^2+Ep.^2);
end;
Eradial=Eradial/Ntime;
Epoloidal=Epoloidal/Ntime;
EradialAbs=EradialAbs/Ntime;
EpoloidalAbs=EpoloidalAbs/Ntime;
E=E/Ntime;
toc;
