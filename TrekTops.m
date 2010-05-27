function TrekSet=TrekTops(TrekSetIn)
%Description see Tops.m
%wrap for Tops.m

TrekSet=TrekSetIn;
PeakSet=Tops(TrekSet.trek,TrekSet.Plot);


TrekSet.PeakOnFrontInd=PeakSet.PeakOnFrontInd;
TrekSet.SelectedPeakInd=PeakSet.SelectedPeakInd;
TrekSet.Threshold=PeakSet.Threshold;      