function sT = som_table_modify(sT,action,arg1,arg2,arg3)

%SOM_TABLE_MODIFY Modify table: add or remove columns or rows.
%  
% sTable = som_table_modify(sTable,action,arg1,[arg2],[arg3])
% 
%  Input and output arguments ([]'s are optional): 
%   sTable      (struct) table struct
%   action      (string) action id (see below).
%   arg1        (varies) Depending on action, 1 to 3 arguments
%   [arg2]      (varies) are needed. See below.
%   [arg3]      (varies) 
%
%   sTable      (struct) the modified table struct
%
%  Actions and their arguments:
%   'addcol'    Add one or several new columns.
%               arg1 (cell array) new values
%                    (char)       new values (a single column can be given)
%                    (matrix)     new values
%               arg2 (cell array) new headers
%               arg3 (scalar)     at which position the new columns 
%                                 should be inserted (at the end by default)
%   'addrow'    Add one or several new rows.
%               arg1 (cell array) new values
%                    (char)       new values (a single row can be given)
%                    (matrix)     new values
%               arg2 (scalar)     at which position the new rows 
%                                 should be inserted (at the end by default)
%   'removecol' Remove one or several columns.           
%               arg1 (vector)     indeces of columns to be removed
%   'removerow' Remove one or several rows.           
%               arg1 (vector)     indeces of rows to be removed
% 
% See also  SOM_TABLE_STRUCT, SOM_TABLE_PRINT.

% Contributed to SOM Toolbox 2.0, January 4th, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 040102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nrT,ncT] = size(sT.values); 

switch action, 
 case 'addcol', 
  values = arg1; 
  if ischar(values), values = cellstr(values); end
  if isnumeric(values), values = num2cell(values); end
  spans  = ones([size(values) 2]);
  [nr,nc] = size(values); 
  if nargin<4, header = cell(1,nc); header(:) = {''}; else header = arg2; end
  if ischar(header), header = cellstr(header); end
  if nargin<5, where = ncT+1; else  where  = arg3; end
  if nrT ~= nr, 
    error('Mismatch between sizes of given table and additional columns')
  else
    sT.headers = [sT.headers(:,1:where-1), header, sT.headers(:,where:end)]; 
    sT.values  = [sT.values(:,1:where-1), values, sT.values(:,where:end)]; 
    sT.span    = [sT.span(:,1:where-1,:), spans, sT.span(:,where:end,:)]; 
  end
 case 'addrow', 
  values  = arg1; 
  if ischar(values), values = cellstr(values); end
  if isnumeric(values), values = num2cell(values); end
  [nr,nc] = size(values); 
  spans   = ones([size(values) 2]);
  if nargin<4, where = nrT+1; else where  = arg2; end
  if ncT ~= nc, 
    error('Mismatch between sizes of given table and additional rows')
  else
    sT.values = [sT.values(1:where-1,:); values; sT.values(where:end,:)]; 
    sT.span   = [sT.span(1:where-1,:,:); spans; sT.span(where:end,:,:)]; 
  end
 case 'removecol',
  where      = setdiff(1:ncT,arg1);     
  sT.values  = sT.values(:,where); 
  sT.headers = sT.headers(:,where); 
  sT.span    = sT.span(:,where,:); 
 case 'removerow',
  where      = setdiff(1:nrT,arg1);     
  sT.values  = sT.values(where,:); 
  sT.headers = sT.headers(where,:); 
  sT.span    = sT.span(where,:,:); 
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
