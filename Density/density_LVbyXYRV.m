function LV=density_LVbyXYRV(XYRV)
    LV(:,1)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
    LV(:,2)=(XYRV(1:end-1,4)+XYRV(2:end,4))/2;