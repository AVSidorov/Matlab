function TrekToPoisson(TrekSet)
 if not(isempty(TrekSet.peaks))   
   if max(size(TrekSet.peaks))>100  
     HistSet=HistPick(TrekSet.peaks,5);
     HistSet.name=TrekSet.name;
     PoissonSet=Poisson(HistSet.Hist);
     PoissonSet.name=TrekSet.name;
     assignin('base','PoissonSet',PoissonSet);
     evalin('base','Poissons(end+1)=PoissonSet;');
   end;
 end;
 