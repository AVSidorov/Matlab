function astra_plot_gsef(gsef)

    gsef.Rb=[gsef.Rb;gsef.Rb(1)];
    gsef.Zb=[gsef.Zb;gsef.Zb(1)];
    
    figure('Units','normalized','OuterPosition',[0,0,1,1],'Tag','gsef_fields');
    ha1=subplot(2,2,1);
    grid on; hold on;
    surf(gsef.XX,gsef.YY,gsef.PSI,'FaceColor','none','EdgeColor','interp');
    view(2);
    axis equal;
    plot(gsef.Rb,gsef.Zb,'r','LineWidth',2);
    set(gca,'FontSize',14)
    title('\Psi','FontSize',20,'FontWeight','bold');
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');

    ha2=subplot(2,2,2);
    grid on; hold on;
    surf(gsef.XX,gsef.YY,gsef.B_T,'FaceColor','interp','EdgeColor','interp');
    view(2);
    axis equal;
    plot(gsef.Rb,gsef.Zb,'r','LineWidth',2);
    set(gca,'FontSize',14)
    title('B_T','FontSize',20,'FontWeight','bold');
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');
    
    ha3=subplot(2,2,3);
    grid on; hold on;
    surf(gsef.XX,gsef.YY,gsef.B_R,'FaceColor','interp','EdgeColor','interp');
    view(2);
    axis equal;
    plot(gsef.Rb,gsef.Zb,'r','LineWidth',2);
    set(gca,'FontSize',14)
    title('B_R','FontSize',20,'FontWeight','bold');
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');

    ha4=subplot(2,2,4);
    grid on; hold on;
    surf(gsef.XX,gsef.YY,gsef.B_Z,'FaceColor','interp','EdgeColor','interp');
    view(2);
    axis equal;
    plot(gsef.Rb,gsef.Zb,'r','LineWidth',2);
    set(gca,'FontSize',14)
    title('B_Z','FontSize',20,'FontWeight','bold');
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');
    
    fig2=figure('Units','normalized','OuterPosition',[0,0,1,1],'Tag','gsef_plots');
    ha1=subplot(2,3,1);
    grid on; hold on;
    surf(gsef.XX,gsef.YY,gsef.PSI,'FaceColor','none','EdgeColor','interp');
    view(2);
    axis equal;
    plot(gsef.Rb,gsef.Zb,'r','LineWidth',2);
    set(gca,'FontSize',14)
    title('\Psi','FontSize',20,'FontWeight','bold');
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');

    ha2=subplot(2,3,2);
    plot(gsef.PSIn_grid,gsef.pressure,'LineWidth',2);
    grid on; hold on;
    set(gca,'FontSize',14)
    title('Pressure, n*T','FontSize',20,'FontWeight','bold');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('P, m^{-3}*eV','FontSize',20,'FontWeight','demi');
    
    ha3=subplot(2,3,3);
    plot(gsef.PSIn_grid,gsef.qprof,'r','LineWidth',2);
    grid on; hold on;
    set(gca,'FontSize',14)
    title('q Safety factor','FontSize',20,'FontWeight','bold');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('q, n*T','FontSize',20,'FontWeight','demi');

    ha4=subplot(2,3,4);
    plot(gsef.PSIn_grid,gsef.ipol_grid,'m','LineWidth',2);
    grid on; hold on;
    set(gca,'FontSize',14)
    title('poloidal current function, R*B_T','FontSize',20,'FontWeight','bold');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('ipol, m*T','FontSize',20,'FontWeight','demi');

    ha5=subplot(2,3,5);
    plot(gsef.PSIn_grid,gsef.dum1,'k','LineWidth',2);
    grid on; hold on;
    set(gca,'FontSize',14)
    title('dum1','FontSize',20,'FontWeight','bold');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('dum1','FontSize',20,'FontWeight','demi');
    
    ha6=subplot(2,3,6);
    plot(gsef.PSIn_grid,gsef.dum2,'k','LineWidth',2);
    grid on; hold on;
    set(gca,'FontSize',14)
    title('dum2','FontSize',20,'FontWeight','bold');
    xlabel('\rho','FontSize',20,'FontWeight','demi');
    ylabel('dum2','FontSize',20,'FontWeight','demi');