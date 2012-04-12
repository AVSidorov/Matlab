classdef SXR_spectrum
    properties
        Spec;
        SpecBe;
        SpecBeSm;
        Te;
        Ne;
        Ni;
        Zeff;
        PoissonK;
        Be;
        P10;
        Transition;
    end
    methods
        function obj=SXR_spectrum(varargin)
            nargsin=size(varargin,2);
            if ~isempty(varargin)&&mod(nargsin,2)~=0
                disp('incorrect number of input arguments');
                obj=[];
            else
               for i=1:fix(nargsin/2) 
                eval(['obj.',varargin{1+2*(i-1)},'=varargin{2*i};']);
               end;
            end;
            Te=[];
            if isempty(obj.Te)
                Te=input('input electron temperature in eV. Default is 500eV\n');
            end;
            if isempty(Te)
                obj.Te=500;
            else
                obj.Te=Te;
            end;
            if isempty(obj.Ni)
                [obj.Ni,obj.Zeff]=Species_by_Zeff;
            end;
        end
    end
end %classdef