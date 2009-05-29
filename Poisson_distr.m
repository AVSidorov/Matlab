function P=Poisson_distr(K,W0,W)
P=K*exp(-K.*W0).*(K.*W0).^(K.*W(:))./gamma(K.*W(:)+1);