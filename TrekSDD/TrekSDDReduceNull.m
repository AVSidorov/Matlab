function TrekSet=TrekSDDReduceNull(TrekSetMain,TrekSetNull,varargin)
TrekSet=TrekRecognize(TrekSetMain,varargin{:});
TrekSet.Plot=false;
if TrekSet.type>0 
    TrekSet=TrekLoad(TrekSet);
end;
TrekSetNull=TrekRecognize(TrekSetNull,varargin{:});
if TrekSetNull.type>0 
    TrekSetNull=TrekLoad(TrekSetNull);
end;
TrekSet.trek=TrekSet.trek-TrekSetNull.trek;