classdef SXR_spectrum
    properties
        Spec;
        SpecBe;
        SpecBeSm;
        Te;
        Ne;
        Ni;
        Zeff;
        K;
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
            obj.Ne=1e19;
            if isempty(obj.Te)
                Te=input('input electron temperature in eV. Default is 500eV\n');
            else
                Te=obj.Te;
            end;
            if isempty(Te)
                obj.Te=500;
            else
                obj.Te=Te;
            end;
            if isempty(obj.Ni)
                [obj.Ni,obj.Zeff]=Species_by_Zeff;
            end;
            try
                S=load('Be.mat', 'Be');
                obj.Be=S.Be;
            catch err
            end
            try
                S=load('P10.mat', 'P10');
                obj.P10=S.P10;
            catch err
            end
            obj.Transition=obj.Be;
            obj.Transition(:,2)=obj.Be(:,2).*(1-obj.P10(:,2));
            obj.Spec=SXR_spectr_calc(obj.Ne,obj.Te,'Ni',obj.Ni,'Ew',obj.Be(:,1));
            obj.SpecBe=obj.Spec;
            obj.SpecBe(:,2)=obj.Spec(:,2).*obj.Transition(:,2);
            
            if isempty(obj.K)
                K=input('Input poisson coefficent or FWHM in procents/100 (0<FWHM<1). Default is 15%\n');
            else
                K=obj.K;
            end;
            if isempty(K)
                obj.K=2*5.9/(0.15*5.9)^2;
            elseif K<1
                obj.K=2*5.9/(0.15*5.9)^2;
            end;
            obj.SpecBeSm=obj.SpecBe;
            obj.SpecBeSm(:,2)=Poisson_smooth([obj.SpecBe(:,1)/1000,obj.SpecBe(:,2)],obj.K);
        end
    end
end %classdef