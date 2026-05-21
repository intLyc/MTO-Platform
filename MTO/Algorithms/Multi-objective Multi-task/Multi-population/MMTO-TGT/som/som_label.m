function [sTo] = som_label(sTo, mode, inds, labels)

%SOM_LABEL Give/clear labels to/from map or data struct.
%
% sTo = som_label(sTo, mode, inds [, labels])
% 
%   sD = som_label(sD,'add',20,'a_label');
%   sM = som_label(sM,'replace',[2 4],'a_label');
%   sM = som_label(sM,'add',som_bmus(sM,x),'BMU');
%   sD = som_label(sD,'prune',[1:10]');
%   sM = som_label(sM,'clear','all');         
%
%  Input and output arguments ([]'s are optional): 
%   sTo      (struct) data or map struct to which the labels are put 
%   mode     (string) 'add' or 'replace' or 'prune' or 'clear'
%   inds     (vector) indeces of the vectors to which the labels
%                     are put. Note: this must be a column vector!
%            (matrix) subscript indeces to the '.labels' field. The vector 
%                     is given by the first index (e.g. inds(i,1)). 
%            (string) for 'prune' and 'clear' modes, the string 'all'
%                     means that all vectors should be pruned/cleared
%   [labels]          The labels themselves. The number of rows much match 
%                     the number of given indeces, except if there is either
%                     only one index or only one label. If mode is
%                     'prune' or 'clear', labels argument is ignored.
%            (string) Label.
%            (string array) Each row is a label.
%            (cell array of strings) All labels in a cell are handled 
%                     as a group and are applied to the same vector given 
%                     on the corresponding row of inds.
%
% Note: If there is only one label/index, it is used for each specified
% index/label.
%
% For more help, try 'type som_label' or check out online documentation.
% See also  SOM_AUTOLABEL, SOM_SHOW_ADD, SOM_SHOW.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_label
%
% PURPOSE
%
% Add (or remove) labels to (from) map and data structs.
%
% SYNTAX
%
%  sTo = som_label(sTo, 'clear', inds)
%  sTo = som_label(sTo, 'prune', inds)
%  sTo = som_label(sTo, 'add', inds, labels)
%  sTo = som_label(sTo, 'replace', inds, labels)
%
% DESCRIPTION
%
% This function can be used to give and remove labels in map and data
% structs. Of course the same operation could be done by hand, but this
% function offers an alternative and hopefully slightly user-friendlier
% way to do it.
%
% REQUIRED INPUT ARGUMENTS
%
%   sTo    (struct) data or map struct to which the labels are put 
%   mode   (string) The mode of operation. 
%                    'add'     : adds the given labels
%                    'clear'   : removes labels
%                    'replace' : replaces current labels with given
%                                labels; basically same as 'clear'
%                                followed by 'add'
%                    'prune'   : removes empty labels ('') from between
%                                non-empty labels, e.g. if the labels of
%                                a vector were {'A','','','B','','C'}
%                                they'd become {'A','B','C'}. Some empty
%                                labels may be left at the end of the list.
%
%   inds            Identifies the vectors to which the operation
%                   (given by mode) is applied to.
%          (vector) Linear indexes of the vectors, size n x 1.
%                   Notice! This should be a column vector!
%          (matrix) The labels are in a cell matrix. By giving matrix 
%                   argument for inds, you can address this matrix
%                   directly. The first index gives the vector and the
%                   second index the vertical position of the label in
%                   the labels array. Size n x 2, where n is the 
%                   number of labels. 
%          (string) for 'prune' and 'clear' modes, the string 'all'
%                   means that all vectors should be pruned/cleared
%
% OPTIONAL INPUT ARGUMENTS 
%
%   [labels]        The labels themselves. The number of rows much match 
%                   the number of given indeces, except if there is either
%                   only one index or only one label. 
%          (string) Label, e.g. 'label'
%          (string array) Each row is a label, 
%                   e.g. ['label1'; 'label2'; 'label3']
%          (cell array of strings) All labels in a cell are handled 
%                   as a group and are applied to the same vector given 
%                   on the corresponding row of inds.
%                   e.g. three labels: {'label1'; 'label2'; 'label3'}
%                   e.g. a group of labels: {'label1', 'label2', 'label3'}
%                   e.g. three groups: {{'la1'},{'la21','la22'},{'la3'}
%
% OUTPUT ARGUMENTS
% 
%   sTo    (struct) the given data/map struct with modified labels
% 
% EXAMPLES
%
%  This is the basic way to add a label to map structure:
%   sMap = som_label(sMap,'add',3,'label');
%
%  The following examples have identical results: 
%   sMap = som_label(sMap,'add',[4; 13], ['label1'; 'label2']);
%   sMap = som_label(sMap,'add',[4; 13], {{'label1'};{'label2'}});
%
%  Labeling the BMU of a vector x (and removing any old labels)
%   sMap = som_label(sMap,'replace',som_bmus(sMap,x),'BMU');
%
%  Pruning labels 
%   sMap = som_label(sMap,'prune','all');
%
%  Clearing labels from a struct
%   sMap = som_label(sMap,'clear','all');
%   sMap = som_label(sMap,'clear',[1:4, 9:30]');
%
% SEE ALSO
% 
%  som_autolabel   Automatically label a map/data set.
%  som_show        Show map planes.
%  som_show_add    Add for example labels to the SOM_SHOW visualization.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(3, 4, nargin));  % check no. of input args is correct

% sTo
switch sTo.type, 
case 'som_map',  [dlen dim] = size(sTo.codebook);
case 'som_data', [dlen dim] = size(sTo.data);
end
maxl = size(sTo.labels,2); % maximum number of labels for a single vector

% inds
if ischar(inds) && strcmp(inds,'all'), 
  inds = [1:dlen]'; 
end
if length(inds)>2 && size(inds,2)>2, inds = inds'; end
ni = size(inds,1);
n = ni; 

% labels
if nargin==4, 
  % convert labels to a cell array of cells
  if ischar(labels), labels = cellstr(labels); end
  if iscellstr(labels), 
    tmplab = labels; 
    nl = size(labels,1);
    labels = cell(nl,1);  
    for i=1:nl, 
      if ~iscell(tmplab{i}) 
	if ~isempty(tmplab{i}), labels{i} = tmplab(i,:);
	else labels{i} = {}; end
      else
	labels(i) = tmplab(i);
      end
    end
    clear tmplab;
  end
  nl = size(labels,1);    
end

% the case of a single label/index
if any(strcmp(mode,{'add','replace'})),
  n = max(nl,ni);   
  if n>1, 
    if ni==1, 
      inds = zeros(n,1)+inds(1); 
    elseif nl==1,
      label = labels{1}; 
      labels = cell(n,1); 
      for i=1:n, labels{i} = label; end
    elseif ni ~= nl,
      error('The number of labels and indexes does not match.'); 
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

switch mode,   
 case 'clear',
  if size(inds,2)>2, 
    inds = inds(find(inds(:,2)<=maxl),:); % ignore if subindex is out-of-range
    inds = sub2ind([dlen maxl],inds(:,1),inds(:,2)); 
    sTo.labels{inds} = []; 
  else
    sTo.labels(inds,:) = cell(n,maxl); 
  end
 case 'prune', 
  if size(inds,2)==1, 
    % subindex gives the index from which the pruning is started
    inds = [inds, ones(n,1)]; % from 1 by default
  end 
  select = ones(1,maxl);     
  for i=1:n, 
    v = inds(i,1); s = inds(i,2); select(:) = 1; 
    for j=s:maxl, select(j) = ~isempty(sTo.labels{v,j}); end
    if ~all(select), 
      labs = cell(1,maxl); 
      labs(1:sum(select)) = sTo.labels(v,find(select));
      sTo.labels(v,:) = labs; 
    end
  end
 case 'add', 
  if size(inds,2)==1, 
    % subindex gives the index from which the adding is started
    inds = [inds, ones(n,1)]; % from 1 by default
  end 
  for i=1:n, 
    v = inds(i,1); s = inds(i,2); l = length(labels{i});
    for j=1:l, 
      while s<=size(sTo.labels,2) && ~isempty(sTo.labels{v,s}), s=s+1; end
      sTo.labels{v,s} = labels{i}{j}; 
      s=s+1; 
    end
  end
 case 'replace', 
  if size(inds,2)==1, 
    % subindex gives the index from which the replacing is started
    inds = [inds, ones(n,1)]; % from 1 by default
  end 
  for i=1:n, 
    v = inds(i,1); s = inds(i,2); l = length(labels(i)); 
    for j=1:l, sTo.labels{v,s-1+j} = labels{i}{j}; end 
  end
 otherwise
  error(['Unrecognized mode: ' mode]);
end

sTo.labels = remove_empty_columns(sTo.labels);

[dlen maxl] = size(sTo.labels);
for i=1:dlen, 
  for j=1:maxl, 
    if isempty(sTo.labels{i,j}) && ~ischar(sTo.labels{i,j}), 
      sTo.labels{i,j} = ''; 
    end
  end
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function labels = remove_empty_columns(labels)

  [dlen maxl] = size(labels);
  
  % find which columns are empty
  cols = zeros(1,maxl); 
  for i=1:dlen, 
    for j=1:maxl,
      cols(j) = cols(j) + ~isempty(labels{i,j}); 
    end
  end
  while maxl>0 && cols(maxl)==0, maxl = maxl-1; end % check starting from end

  if maxl==0, labels = cell(dlen,1); 
  elseif maxl<size(labels,2), labels = labels(:,1:maxl); 
  else % ok
  end
  % end of remove_empty_columns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
