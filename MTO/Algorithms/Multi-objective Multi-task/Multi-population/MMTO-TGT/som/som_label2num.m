function [nos,names] = som_label2num(L)

%SOM_LABEL2NUM Recodes textual data labels to interger class labels 
%
% [class,names]=class2num(L)
%
%  [class,names]=class2num(sData)
%  [class,names]=class2num(sMap)
%  [class,names]=class2num(sData.labels);
%
%  Input and output arguments ([]'s are optional): 
%   
%   L      (map struct, data struct, 
%           Nx1 cell array of strings, 
%           a Nxn char array)           textual labels
%   class  (vector) Nx1 vector of integers where N is the number of original text labels
%   names  (cell)   kx1 array of strings where names(i) correspons to integer label i
%
% See also KNN

% Contributed to SOM Toolbox 2.0, October 29th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta Johan 291000

%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(L);
   if isfield(L,'type') && ischar(L.type),
   else
      error('Invalid map/data struct?');
   end
   switch L.type
   case {'som_map', 'som_data'}
      class=L.labels(:,1);
   otherwise error('Invalid map/data struct?');
   end
elseif vis_valuetype(L,{'cellcolumn_of_char'}),
   class=L;
elseif vis_valuetype(L,{'chararray'}),
   class=cellstr(L);   
else
   error('Input must be an Nx1 cell array of strings, a char array, a map struct or a data struct.');   
end

names = {};
nos = zeros(length(class),1);
for i=1:length(class),
   if ~isempty(class{i}) && ~any(strcmp(class{i},names)),
      names=cat(1,names,class(i));
   end
end

tmp_nos = (1:length(names))';
for i=1:length(class),
   if ~isempty(class{i}),
      nos(i,1) = find(strcmp(class{i},names));    
   end
end

if any(nos==0),
   nos=nos+1;
   names(2:end+1)=names;
   names{1}='';
end



