function som_use_vs1()

% SOM_USE_VS1  Use SOM Toolbox version 1.
%
% Removes SOM Toolbox version 2 from the path and adds version 1 there
% instead. Before doing this, remember to convert any version 2 structs you
% will need to the corresponding version 1 structs using function SOM_VS2TO1.
%
% See also  SOM_USE_VS2, SOM_VS1TO2, SOM_VS2TO1, PATHTOOL.

rmpath /share/somtoolbox/www/package/codes2

s=path; 
p=findstr(s,'/share/matlab5'); p=p(1);
i=p+12; while ~strcmp(s(i),'/'), i=i+1; end
r=strcat(s(p:i),'toolbox/somtoolbox');
addpath(r)

fprintf(1,'Version 1 of SOM Toolbox now in use.\n');
fprintf(1,'Use som_vs2to1 function to convert any vs2 structs to vs1.\n')
