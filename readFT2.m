function [block,blength]=readFT2(filename)
blength=[];
f=fopen(filename,'r','n','windows-1251');

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.ShotDate=char(fread(f,n)');  %  ���� ��������
fseek(f,8-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.ShotTime=char(fread(f,n)');  %  ����� ��������
fseek(f,8-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ShotNumber=fread(f,1,'int16'); % ����� ��������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.RegimeName=char(fread(f,n)');%��� ������
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
block.CommentString=char(fread(f,n)'); % ������ ������������
fseek(f,80-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Parameters=fread(f,16,'single'); % ����������������� ���������
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
block.ChannelName=char(fread(f,n)');  % ��� ������
fseek(f,32-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.Rate=fread(f,1,'uint16'); % ������ ��������� �� ������ ������, ���
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.InTime=fread(f,1,'uint16'); % ���������� ������� ���������, ��
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.Shift=fread(f,1,'single'); % ����� ������� ���������, ���
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ChannelNumber=fread(f,1,'uint8'); % ����� ������ � ���������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.NumberInTable=fread(f,1,'uint8'); % ����� ����� �� ������ ��������������� ������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.BlockNumber=fread(f,1,'uint8'); % ����� ����� ������ ���� ����� ������� ��
blength(end,2)=ftell(f)-1;            % ����� �� 2048 �����   =0 ���� ��� ������ �������

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.ADCRange=fread(f,1,'uint16');   % �������� ������ ��� 
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Statistics=fread(f,1)~=0;       % ������������� ��������� ����. ��������� ������
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),2); % compensate aligning by Delphi
if n~=0
    fseek(f,2-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.DataMin=fread(f,1,'int16');     % ����������� ��������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.DataMax=fread(f,1,'int16');     % ������������ ��������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.DataZero=fread(f,1,'single');   % ������� ���� ������
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.SigmaDataZero=fread(f,1,'single');   % ��� ���������
blength(end,2)=ftell(f)-1;

%   {���������� ���������}
%   { U(V):=UShift+Umin+(Data-Zero*DataZero)*(Umax-Umin)*UCoeff/Range }
blength(end+1,1)=ftell(f);
block.Umin=fread(f,1,'single');   % {mV}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Umax=fread(f,1,'single');   % {mV}{�������, ��������������� 0 � Range �������� �� ��������}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.UShift=fread(f,1,'single');   % {mV} {����� ��������� ��������� �� �������� (=0)}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.UCoeff=fread(f,1,'single');   % {������ ������/����� ���}
blength(end,2)=ftell(f)-1;

%   {���������� ���������� ��������}
%   { Value:= Value0+(U-U0)*ValueCoeff;}
blength(end+1,1)=ftell(f);
block.U0=fread(f,1,'single');   % 
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.Value0=fread(f,1,'single');   % {�������� ���������� �������� ��� U=U0}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
block.ValueCoeff=fread(f,1,'single');   % {dValue/dU}
blength(end,2)=ftell(f)-1;

blength(end+1,1)=ftell(f);
n=fread(f,1,'uint8'); % need to correct read Delphi string. First byte is string length 
block.Units=char(fread(f,n)'); % {������� ��������� ��������}
fseek(f,4-n,'cof'); % need to compensate full field length
blength(end,2)=ftell(f)-1;

n=mod(ftell(f),4); % compensate aligning by Delphi
if n~=0
    fseek(f,4-n,'cof');
end;

blength(end+1,1)=ftell(f);
block.tau=fread(f,1,'single'); % {���������� ��������������}
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

%   ShotDate:String[8]; //  ���� ��������
%   ShotTime:String[8]; //  ����� ��������
%   ShotNumber:SmallInt; // ����� ��������
%   RegimeName: String[32]; // ��� ������
%   RegimeParameters : Array[1..16] of RegimeParType; // ��������� ������
%   CommentString: String[80]; // ������ ������������
%   Parameters: array[1..16] of Single; // ����������������� ���������
%   Diagnostics: array[1..32] of DiagType; // �����������
% 
% 
%   ChannelName : String[32]; // ��� ������
% 
%   Rate : Word; // ������ ��������� �� ������ ������, ���
%   InTime : Word; // ���������� ������� ���������, ��
%   Shift : Single; // ����� ������� ���������, ���
% 
%   ChannelNumber:byte; // ����� ������ � ���������
%   NumberInTable:byte; // ����� ����� �� ������ ��������������� ������
% 
%   BlockNumber: byte; // ����� ����� ������ ���� ����� ������� ��
%               // ����� �� 2048 �����   =0 ���� ��� ������ �������
% 
%   ADCRange : Word; // �������� ������ ���
% 
%   Statistics : Boolean; //  ������������� ��������� ����. ��������� ������
%    DataMin:SmallInt; // ����������� ��������
%    DataMax:SmallInt; // ������������ ��������
%    DataZero:Single; //  ������� ���� ������
%    SigmaDataZero:Single; // ��� ���������
% 
%   {���������� ���������}
%   { U(V):=UShift+Umin+(Data-Zero*DataZero)*(Umax-Umin)*UCoeff/Range }
%   Umin:     Single;   {mV}
%   Umax:     Single;   {mV}
%                    {�������, ��������������� 0 � Range �������� �� ��������}
%   UShift:   Single;   {mV}
%                    {����� ��������� ��������� �� �������� (=0)}
%   UCoeff:   Single;
%                    {������ ������/����� ���}
% 
%   {���������� ���������� ��������}
%   { Value:= Value0+(U-U0)*ValueCoeff;}
%   U0:             single;
%   Value0:         single;   {�������� ���������� �������� ��� U=U0}
%   ValueCoeff:     single;   {dValue/dU}
%   Units:          string[4];  {������� ��������� ��������}
%   tau:            single;   {���������� ��������������}
% 
%   Data : Array[1..2048] of SmallInt;
% 
