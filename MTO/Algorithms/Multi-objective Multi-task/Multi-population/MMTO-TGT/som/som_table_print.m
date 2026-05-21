function T = som_table_print(sTable,fid,fmt)

%SOM_TABLE_PRINT Print a table to a file / standard output.
%  
% som_table_print(sTable,[fid],[fmt])
%  
%  som_table_print(sTable)
%  som_table_print(sTable,fid,'html')
%
%  Input and output arguments ([]'s are optional): 
%   sTable      (struct) a table struct (see SOM_TABLE_STRUCT)
%   [fid]       (scalar) a file id (from FOPEN, for example)
%               (empty)  by default standard output (fid=1) is used
%   [fmt]       (string) 'txt' (default), 'ps', 'pdf' or 'html'
%                        the output format type
%
% See also  SOM_TABLE_STRUCT, SOM_STATS_TABLE, SOM_STATS_REPORT.

% Contributed to SOM Toolbox 2.0, January 2nd, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 020102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2 || isempty(fid) || isnan(fid), fid = 1; end
if nargin<3 || isempty(fmt) || isnan(fmt), fmt = 'txt'; end

rowlines = 0; 
longtable = 0; 

T = rep_utils({'inserttable',sTable,rowlines,longtable},fmt,fid);

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
