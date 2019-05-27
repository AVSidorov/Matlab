orig_state=warning;
warning('off','all');
V=[]; 
% parfor nx=29:29
  for nx=28:-1:2
    disp(nx);
     tic;
     tic;N=elm_data_getFluxSurface(nx,1:length(time),1,'Dnsvct.mat',GridSet);toc;
     dN=elm_data_getFluctuations(N);
     tic;corrLag=elm_data_getRotationSpeed(dN,[],nx,GridSet,icri);toc;
     Velocity(nx,:)=elm_data_getRotationVelocity(corrLag,[],nx,GridSet,icri);
 end
 warning(orig_state);