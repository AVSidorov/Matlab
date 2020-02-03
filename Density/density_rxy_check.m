function [ok,bool]=density_rxy_check(rxy)
rxy=rxy(isfinite(rxy(:,1))&isfinite(rxy(:,2))&isfinite(rxy(:,3)),:);
deltaCentr=sqrt(diff(rxy(:,2)).^2+diff(rxy(:,3)).^2);
bool=diff(rxy(:,1))>deltaCentr;
ok=all(bool);
