function coeffs=density_CrParamsToCoeffs(delta,Rlcs,dCzero,dCrlcs,limSide)
    Rdia=7.9;
    coeffs=zeros(1,5);
    if Rlcs>Rdia
        return;
    end;
    rootRlcs=Rlcs-dCrlcs/Rlcs/(Rlcs-dCzero);
    coeffsD=poly([0 dCzero rootRlcs]);
    rootsD=roots(polyder(coeffsD));
    
    coeffs0=polyint(coeffsD);
        
    k(1)=(limSide*(Rdia-Rlcs)-delta)/polyval(coeffs0,Rlcs);
    k(2)=(1-eps)/max(abs(polyval(coeffsD,rootsD)));
    k(3)=(-limSide*(Rdia-Rlcs)-delta)/polyval(coeffs0,Rlcs);
    
    k(k<=0)=[];
    k=min(k);
    
    coeffs=polyint(k*coeffsD,delta);   
end