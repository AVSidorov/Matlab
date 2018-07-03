function dtbl=elm_data_getFluctuations(tbl,mode)
% This function gets relative fluctuations of given data
% input table  are three dimensional and has to contain flux surface data
% The dimensions are poloidal x toroidal x time
% mode determs the type calculating of mean value 
%  'section' - each toroidal cross section 
%  'surface'- full flux surface all sections thru the torus            
%  'all'    - all the points in tbl
SectionMean=mean(tbl);
SurfaceMean=mean(SectionMean);
AllMean=mean(tbl(:));

SectionMean=repmat(SectionMean,size(tbl,1),1);
SurfaceMean=repmat(SurfaceMean,size(tbl,1),size(tbl,2));

if nargin<2
    mode='surface';
end;

mode=lower(mode);
switch mode
    case 'section'
        dtbl=(tbl-SectionMean)./SectionMean;        
    case 'surface'
        dtbl=(tbl-SurfaceMean)./SurfaceMean;
    case 'all'
        dtbl=(tbl-AllMean)./AllMean;        
end