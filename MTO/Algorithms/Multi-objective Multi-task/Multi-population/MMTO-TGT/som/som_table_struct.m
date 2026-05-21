function sTable = som_table_struct(values,headers,span,colfmt)

%SOM_TABLE_STRUCT Create a table struct.
%  
% sTable = som_table_struct(values,[headers],[span],[colfmt])
% 
%  Input and output arguments ([]'s are optional): 
%   values      (cell array) size nrow x ncol, the contents of the table 
%               (char array) size nrow x *
%               (matrix)     size nrow x ncol
%   [headers]   (cell array) size 1 x ncol, header row of the table 
%               (empty)      by default, empty headers are used ('')
%   [span]      (matrix)     size nrow x ncol x 2, span of each cell of the 
%                            table: span(:,:,1) gives horizontal span and 
%                            span(:,:,2) gives vertical span. If the value
%                            for a cell is greater than 1, it should be 
%                            followed by a corresponding number of zeros
%                            for the following cells (left or down)
%               (empty)      by default ones(nrow,ncol,1)
%   [colfmt]    (string)     the format of each column as given in LaTeX, 
%                            only used if the table is printed as 'ps' or 'pdf', 
%                            by default colfmt = ''
%   
%   sTable      (struct)     the table struct, with the following fields:
%         .headers  (cell array) header row, size 1 x ncol
%         .values   (cell array) values,  size nrow x ncol
%         .span     (matrix)     span of each cell, size nrow x ncol x 2
%
% See also  SOM_TABLE_MODIFY, SOM_TABLE_PRINT.

% Contributed to SOM Toolbox 2.0, December 31st, 2001 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 311201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ischar(values), values = cellstr(values); 
elseif isnumeric(values), values = num2cell(values); 
end
[nrow,ncol] = size(values);

if nargin<2 || isempty(headers), headers = cell(1,ncol); headers(:) = {''}; end
if ischar(headers), headers = cellstr(headers); end

if nargin<3 || isempty(span), span = ones(nrow,ncol,2); end
if sum(span(:)) > 2*nrow*ncol, 
  warning('span matrix has overlapping cells')
elseif sum(span(:)) < 2*nrow*ncol,
  warning('span matrix has noncontinuous cells')
end

if nargin<4 || isempty(colfmt), colfmt = ''; end
    
sTable = struct('colfmt','','headers',[],'values',[],'span',[]); 
sTable.colfmt  = colfmt; 
sTable.headers = headers; 
sTable.span    = span;
sTable.values  = values; 

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
