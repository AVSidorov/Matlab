function [block,blength]=readFT2(filename)
blength=[];
f=fopen(filename,'r','n','windows-1251');

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.ShotDate=char(fread(f,n)');  %  Дата выстрела
fseek(f,8-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.ShotTime=char(fread(f,n)');  %  Время выстрела
fseek(f,8-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ShotNumber=fread(f,1,'int16'); % Номер выстрела
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.RegimeName=char(fread(f,n)');%Тип режима
fseek(f,32-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
fseek(f,320,'cof'); %skip RegimeParameters
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.CommentString=char(fread(f,n)'); % Строка комментариев
fseek(f,80-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Parameters=fread(f,16,'single'); % Зарезервированные параметры
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
fseek(f,320,'cof'); %skip Diagnostics
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.ChannelName=char(fread(f,n)');  % Имя Канала
fseek(f,32-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.Rate=fread(f,1,'uint16'); % период измерения по одному каналу, мкс
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.InTime=fread(f,1,'uint16'); % промежуток времени измерений, мс
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.Shift=fread(f,1,'single'); % Время первого измерения, мкс
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ChannelNumber=fread(f,1,'uint8'); % Номер канала в программе
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.NumberInTable=fread(f,1,'uint8'); % Номер входа на платах соответствующий каналу
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.BlockNumber=fread(f,1,'uint8'); % Номер блока двнных если канал поделен на
blength(end,2)=ftell(f)-1;            % блоки по 2048 точки   =0 если нет такого деления

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.ADCRange=fread(f,1,'uint16');   % Диапазон счетов АЦП 
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Statistics=fread(f,1)~=0;       % Подтверждение первичной стат. обработки данных
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.DataMin=fread(f,1,'int16');     % минимальное значение
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.DataMax=fread(f,1,'int16');     % максимальное значение
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.DataZero=fread(f,1,'single');   % Средний ноль канала
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.SigmaDataZero=fread(f,1,'single');   % его дисперсия
blength(end,2)=ftell(f)-1;

%   {калибровка измерений}
%   { U(V):=UShift+Umin+(Data-Zero*DataZero)*(Umax-Umin)*UCoeff/Range }
blength(end+1,1)=ftell(f);
block.Umin=fread(f,1,'single');   % {mV}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Umax=fread(f,1,'single');   % {mV}{Сигналы, соответствующие 0 и Range отсчетам на странице}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.UShift=fread(f,1,'single');   % {mV} {сдвиг диапазона измерений на странице (=0)}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.UCoeff=fread(f,1,'single');   % {Вольты канала/Счеты АЦП}
blength(end,2)=ftell(f)-1;

%   {вычисление измеряемой величины}
%   { Value:= Value0+(U-U0)*ValueCoeff;}
blength(end+1,1)=ftell(f);
block.U0=fread(f,1,'single');   % 
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Value0=fread(f,1,'single');   % {значение измеряемой величины при U=U0}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ValueCoeff=fread(f,1,'single');   % {dValue/dU}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.Units=char(fread(f,n)'); % {единицы измерений величины}
fseek(f,4-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.tau=fread(f,1,'single'); % {постоянная интегрирования}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Data=fread(f,2048,'int16');
blength(end,2)=ftell(f)-1;

fclose(f);

% 
%  DiagType = record
%   Name : String[8];
%   Enabled : Boolean;
%  end;

%   ShotDate:String[8]; //  Дата выстрела
%   ShotTime:String[8]; //  Время выстрела
%   ShotNumber:SmallInt; // Номер выстрела
%   RegimeName: String[32]; // Тип режима
%   RegimeParameters : Array[1..16] of RegimeParType; // Параметры режима
%   CommentString: String[80]; // Строка комментариев
%   Parameters: array[1..16] of Single; // Зарезервированные параметры
%   Diagnostics: array[1..32] of DiagType; // Диагностики
% 
% 
%   ChannelName : String[32]; // Имя Канала
% 
%   Rate : Word; // период измерения по одному каналу, мкс
%   InTime : Word; // промежуток времени измерений, мс
%   Shift : Single; // Время первого измерения, мкс
% 
%   ChannelNumber:byte; // Номер канала в программе
%   NumberInTable:byte; // Номер входа на платах соответствующий каналу
% 
%   BlockNumber: byte; // Номер блока двнных если канал поделен на
%               // блоки по 2048 точки   =0 если нет такого деления
% 
%   ADCRange : Word; // Диапазон счетов АЦП
% 
%   Statistics : Boolean; //  Подтверждение первичной стат. обработки данных
%    DataMin:SmallInt; // минимальное значение
%    DataMax:SmallInt; // максимальное значение
%    DataZero:Single; //  Средний ноль канала
%    SigmaDataZero:Single; // его дисперсия
% 
%   {калибровка измерений}
%   { U(V):=UShift+Umin+(Data-Zero*DataZero)*(Umax-Umin)*UCoeff/Range }
%   Umin:     Single;   {mV}
%   Umax:     Single;   {mV}
%                    {Сигналы, соответствующие 0 и Range отсчетам на странице}
%   UShift:   Single;   {mV}
%                    {сдвиг диапазона измерений на странице (=0)}
%   UCoeff:   Single;
%                    {Вольты канала/Счеты АЦП}
% 
%   {вычисление измеряемой величины}
%   { Value:= Value0+(U-U0)*ValueCoeff;}
%   U0:             single;
%   Value0:         single;   {значение измеряемой величины при U=U0}
%   ValueCoeff:     single;   {dValue/dU}
%   Units:          string[4];  {единицы измерений величины}
%   tau:            single;   {постоянная интегрирования}
% 
%   Data : Array[1..2048] of SmallInt;
% 
