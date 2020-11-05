function geqdsk_plot(In)

    %%Construct R-Z mesh
    r=zeros(In.nyefit,In.nxefit);
    z=r;

    for i=1:In.nxefit
        r(:,i)=In.rgrid1+(i-1)*In.xdim/(In.nxefit-1);
    end;

    for i=1:In.nyefit
        z(i,:)=(In.zmid-0.5*In.zdim)+(i-1)*In.zdim/(In.nyefit-1);
    end
    
    figure('Units','normalize','OuterPosition',[0 0 1 1]);
    subplot(2,3,1)
    contour(r,z,In.psi,100)
    axis equal
    grid on; hold on;
    % set(gca,'XLim',[0 1]);
    plot(In.xlim,In.ylim,'.k-','LineWidth',2);
    plot(In.rbdry,In.zbdry,'.r-','LineWidth',2);
    plot(In.rcentr,0,'*r','MarkerSize',15,'LineWidth',3);
    plot(In.rmagx,In.zmagx,'xk','MarkerSize',15,'LineWidth',3);
    set(gca,'Clim',[min([In.simagx,In.sibdry]),max([In.simagx,In.sibdry])]);
    % legend({'\Psi','Wall/limiter','Plasma boundary','Vacuum axis','Magnet axis'},'FontSize',20,'FontWeight','demi');
    title({'\parbox[b]{100mm}{\centering g037893.00185}', '\parbox[b]{100mm}{\centering  $\Psi$, wall/limiter, plasma boundary, Vacuum \& Magnet axes}'},'FontSize',20,'FontWeight','bold','Interpreter','latex');
    set(gca,'FontSize',14)
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');
    
    rho=linspace(0,1,In.nxefit);
    
    subplot(2,3,2)
    grid on; hold on;
    plot(rho,In.pres,'b','LineWidth',2);
    set(gca,'FontSize',14)
    title('Pressure','FontSize',20,'FontWeight','demi');
    xlabel('\rho, m','FontSize',20,'FontWeight','demi');
    ylabel('pressure, cm^{-3}*eV','FontSize',20,'FontWeight','demi');
    
    subplot(2,3,3)
    grid on; hold on;
    plot(rho,In.qpsi,'r','LineWidth',2);
    plot(0,1,'+r','MarkerSize',10);
    set(gca,'FontSize',14)
    title('Safety factor','FontSize',20,'FontWeight','demi');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('q','FontSize',20,'FontWeight','demi');

    subplot(2,3,4)
    grid on; hold on;
    plot(rho,In.fpol,'k','LineWidth',2);
    set(gca,'FontSize',14)
    title('Poloidal current function','FontSize',20,'FontWeight','demi');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('fpol, m*T','FontSize',20,'FontWeight','demi');

    subplot(2,3,5)
    grid on; hold on;
    plot(rho,In.ffprim,'k','LineWidth',2);
    set(gca,'FontSize',14)
    title('ffprim','FontSize',20,'FontWeight','demi');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('','FontSize',20,'FontWeight','demi');

    subplot(2,3,6)
    grid on; hold on;
    plot(rho,In.pprime,'k','LineWidth',2);
    set(gca,'FontSize',14)
    title('pprime','FontSize',20,'FontWeight','demi');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('','FontSize',20,'FontWeight','demi');