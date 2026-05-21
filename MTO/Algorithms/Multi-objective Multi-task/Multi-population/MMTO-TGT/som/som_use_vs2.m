function som_use_vs2()

% SOM_USE_VS2  Use SOM Toolbox version 2.
%
% Removes SOM Toolbox version 1 from the path and adds version 2
% there instead. You can use function SOM_VS1TO2 to convert 
% any version 1 structs to the corresponding version 2 structs.
%
% See also  SOM_USE_VS1, SOM_VS1TO2, SOM_VS2TO1, PATHTOOL.

s=path; p=findstr(s,'somtoolbox'); 
while any(p), 
  p=p(1); 
  i=p; while i<length(s) && ~strcmp(s(i),':'), i=i+1; end
  if strcmp(s(i),':'), i=i-1; end
  j=p; while j>1         && ~strcmp(s(j),':'), j=j-1; end
  if strcmp(s(j),':'), j=j+1; end
  r=s(j:i);
  rmpath(r);
  s=path; p=findstr(s,'somtoolbox'); 
end

addpath /share/somtoolbox/www/package/codes2

fprintf(1,'Version 2 of SOM Toolbox now in use.\n');
fprintf(1,'Latest changes to SOM Toolbox: August 22nd 2000\n');
fprintf(1,' see /share/somtoolbox/vs2/changelog.txt\n');
fprintf(1,'Use som_vs1to2 function to convert any vs1 structs to vs2.\n')

