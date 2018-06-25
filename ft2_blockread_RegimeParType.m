function block=ft2_blockread_RegimeParType(fid)
n=fread(fid,1,'uint8');
block.Name=char(fread(fid,n)');
n=fread(fid,1,'uint8');
block.Units=char(fread(fid,n)');
block.Value=fread(fid,1,'single');
