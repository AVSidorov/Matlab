function coeffs=density_CrParamsToCoeffs(delta,Rlcs,dCzero,limSide)
    Rdia=7.9;
    
    coeffsD=poly([0 dCzero Rlcs]);
    coeffs0=polyint(coeffsD);
        
    k=(limSide*(Rdia-Rlcs)-delta)/polyval(coeffs0,Rlcs);
    coeffs=polyint(k*coeffsD,delta);   
   
end