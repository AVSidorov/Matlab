function sxr_write(FileName,Data);
fid=fopen(FileName,'w');
fprintf(fid,'Time SXR1 SXR2 SXR3 SXR4 SXR5 SXR6 SXR7 SXR8 SXR9 SXR10 SXR11 SXR12 SXR13 SXR14\n'); 
fprintf(fid,'%8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n' ,Data');
fclose(fid);  
end;