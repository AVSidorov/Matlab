function TrekSet=TrekOverloadFind(TrekSet)
trek=TrekSet.trek;
OverloadBool=trek(1:end)>=TrekSet.MaxSignal;
PartSet=PartsSearch(OverloadBool,5,5);
TrekSet.OverloadStart=PartSet.SpaceEnd;
TrekSet.OverloadEnd=PartSet.SpaceStart;
