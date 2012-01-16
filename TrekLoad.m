function TrekSet=TrekLoad(FileName,TrekSetIn);

tic;
TrekSet=TrekSetIn;
if isstruct(FileName)
            %!!!!!!!!!!!!!!!!Dopisat' pro to esli net treka vnutri
            %structury ili proverat' v TrekRecognize;
           if not(isfield(TrekSet,'trek'))
               TrekSet.trek=[];
           end;
           if isempty(TrekSet.trek)
               TrekSet=TrekRecognize(TrekSet.FileName+'.dat',TrekSet);    
           end;

 StartPosition=round((TrekSet.StartTime-FileName.StartTime)/TrekSet.tau)+1;
 EndPosition=min([StartPosition+TrekSet.size-1,numel(FileName.trek)]);
 TrekSet.trek=FileName.trek(StartPosition:EndPosition);

else
    switch TrekSet.type
        case 2
            switch TrekSet.FileType;
             case 'single';
                fid=fopen(FileName);
                StartPosition=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau);
                StartPosition=StartPosition*4;
                fseek(fid,StartPosition,'bof');
                [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
                fclose(fid);
                TrekSet.size=count;
             case 'int16';
                fid=fopen(FileName);
                StartPosition=round((TrekSet.StartTime-TrekSet.StartOffset)/TrekSet.tau);
                StartPosition=StartPosition*2;
                fseek(fid,StartPosition,'bof');
                [TrekSet.trek,count]=fread(fid,TrekSet.size,TrekSet.FileType);
                fclose(fid);
                TrekSet.size=count;
            end;
            fprintf('Loading time of %3.0f points=                               %7.4f  sec\n',count ,toc); 

            bool=(TrekSet.trek(:)>4095)|(TrekSet.trek(:)<0); OutRangeN=size(find(bool),1); 
            if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
            TrekSet.trek(bool,:)=[];  clear bool
            
            while TrekSet.trek(end)==0
                TrekSet.trek(end)=[];
            end;


        case 8
           TrekSet.trek=FileName; %in case FileName is struct type would be different. It changes in TrekRecognize
    end;
end;



TrekSet.size=numel(TrekSet.trek);

if size(TrekSet.trek,1)<size(TrekSet.trek,2)
    TrekSet.trek=TrekSet.trek'; %all arrays are vertical
end;
 

