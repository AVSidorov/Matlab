function StandardPeakWrite(StandardPulseNorm,FileName,Pass)
        if exist('StandPulse')==7
            PulseFolder=[cd,'\StandPulse\'];   
        else
            mkdir(cd,'StandPulse');
            PulseFolder=[cd,'\StandPulse\'];
        end;
        if isstr(FileName1)
            [path1,name1,ext1,versn1]=fileparts(FileName);
            StPeakFile=[PulseFolder,'StP',FileName,'P',num2str(Pass),'.dat'];
        else
            StPeakFile=[PulseFolder,'StP',FileName,'P',num2str(Pass),'.dat'];
        end;
        fid=fopen(StPeakFile,'w');
        fprintf(fid,'%5.3f\n',StandardPulseNorm);       
        fclose(fid);

