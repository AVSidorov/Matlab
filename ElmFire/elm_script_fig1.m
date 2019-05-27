set(gca,'DataAspectRatio',[1,1,5e-4]);
set(gca,'FontSize',20)
set(gca,'FontWeight','demi')
title({'\parbox[b]{100mm}{\centering AltukhovHR}' '\parbox[b]{100mm}{\centering$\sqrt{<\delta N^2>_{Time\,Averaged\;Toroidal\,Averaged}}$}' '\parbox[b]{100mm}{\centering$\delta N=(N-<N>_{flux\,surface\,avr\,time\,avr})/<N>$}'},'FontSize',24,'FontWeight','bold','Interpreter','latex');
xlabel('x, cm','FontSize',20,'FontWeight','demi');
ylabel('y, cm','FontSize',20,'FontWeight','demi');