function [sTo] = som_autolabel(sTo, sFrom, mode, inds)

%SOM_AUTOLABEL Automatical labeling, or clearing of labels.
%
% sTo = som_autolabel(sTo, sFrom, [mode], [inds])
%
%   sM = som_autolabel(sM,sD);      
%   sD = som_autolabel(sD,sM);   
%   sM = som_autolabel(sM,sD,'vote',[5]);
%
%  Input and output arguments ([]'s are optional): 
%   sTo      (struct) data or map struct to which the labels are put,
%                     the modified struct is returned
%   sFrom    (struct) data or map struct from which the labels are taken
%   [mode]   (string) labeling algorithm: 'add' (the default), 'freq' 
%                     or 'vote'
%   [inds]   (vector) the column-indexes of the labels that are to be
%                     used in the operation (e.g. [2] would mean to use
%                     only the second column of labels array in sFrom) 
% 
% The modes:
%  'add':   all labels from sFrom are added to sTo (even multiple
%           copies of same)  
%  'add1':  only one instance of each label is kept
%  'freq':  only one instance of each label is kept and '(#)', where 
%           # is the frequency of the label, is added to the end of 
%           the label. Labels are ordered according to frequency. 
%  'vote':  only the label with most instances is kept
%
% NOTE: The operations are only performed for the new labels. 
%       The old labels in sTo are left as they are.
% NOTE: all empty labels ('') are ignored.
%
% For more help, try 'type som_autolabel' or check out online documentation.
% See also SOM_LABEL, SOM_BMUS, SOM_SHOW_ADD, SOM_SHOW.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_autolabel
%
% PURPOSE
%
% Automatically label to map/data structs based on given data/map.
%
% SYNTAX
%
%  sTo = som_autolabel(sTo, sFrom)
%  sTo = som_autolabel(sTo, sFrom, 'add')
%  sTo = som_autolabel(sTo, sFrom, 'freq')
%  sTo = som_autolabel(sTo, sFrom, 'vote')
%  sTo = som_autolabel(..., inds)
%
% DESCRIPTION
%
% This function automatically labels given map/data struct based on an
% already labelled data/map struct. Basically, the BMU of each vector in the
% sFrom struct is found from among the vectors in sTo, and the vectors in
% sFrom are added to the corresponding vector in the sTo struct. The actual
% labels to add are selected based on the mode ('add', 'freq' or 'vote').
%
%  'add'  :  all labels from sFrom are added to sTo - even if there would 
%            be multiple instances of the same label
%  'add1' :  only one instance of each label is kept
%  'freq' :  only one instance of each label is kept and '(#)', where 
%            # is the frequency of the label, is added to the end of 
%            the label. Labels are ordered according to frequency. 
%  'vote' :  only the label with most instances is added
%
% Note that these operations do not effect the old labels of sTo: they 
% are left as they were.  
% 
% NOTE: empty labels ('') are ignored.
%
% REQUIRED INPUT ARGUMENTS
%
%   sTo    (struct) data or map struct to which the labels are put 
%   sFrom  (struct) data or map struct from which the labels are taken
%
% OPTIONAL INPUT ARGUMENTS 
%
%   mode   (string) The mode of operation: 'add' (default), 
%                   'add1', 'freq' or 'vote'
%   inds   (vector) The columns of the '.labels' field in sFrom to be 
%                   used in operation
%
% OUTPUT ARGUMENTS
% 
%   sTo    (struct) the given data/map struct with modified labels
% 
% EXAMPLES
%
% To label a trained map based on (labelled) training data, just do
%
%  sM = som_autolabel(sM,sD);      
%
% This operation is sometimes called "calibration" in the literature.
% You can also do this the other way around: use a labelled map to 
% label a data set: 
%
%  sD = som_autolabel(sD,sM);   
%
% If you only want a single instance of each label, use the 'freq' mode: 
%
%  sM = som_autolabel(sM,sD,'freq');
%
% If you already have labels in the struct, and want to perform 'freq' on 
% them, do the following: 
%
%  sMtemp = som_label(sM,'clear','all'); % make a map struct with no labels
%  sM = som_autolabel(sMtemp,sM,'freq'); % add labels to it
%
% The third mode 'vote' votes between the labels and only adds the one
% which is most frequent. If two labels are equally frequent, one or the
% other is chosen based on which appears first in the list.
%
%  sM = som_autolabel(sM,sD,'vote');
%
% The lat argument is useful if you have specific labels in each column
% of the '.labels' field. For example, the first column might be an
% identifier, the next a typecode and the last a year. In this case, you
% might want to label the map based only on the typecode: 
% 
%  sM  = som_autolabel(sM,sD,'vote',2);
%
% SEE ALSO
% 
%  som_label     Give/remove labels from a map/data set.
%  som_bmus      Find BMUs from the map for the given set of data vectors.
%  som_show      Show map planes.
%  som_show_add  Add for example labels to the SOM_SHOW visualization.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 101297 
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(2, 4, nargin));  % check no. of input args is correct

% sTo
todata = strcmp(sTo.type,'som_data');

% sFrom 
[~, m] = size(sFrom.labels);

% mode
if nargin<3 || isempty(mode), mode = 'add'; end

% inds
if nargin<4, inds = 1:m; end
inds = inds(find(inds>0 & inds<=m));
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get a list of the labels to be added to each vector

% calculate BMUs
if todata, bmus = som_bmus(sFrom,sTo,1);
else bmus = som_bmus(sTo,sFrom,1); end

% for each vector in sTo, make a list of all new labels
Labels = cell(size(sTo.labels,1),1);
for d=1:length(bmus), 
  m = bmus(d); 
  if todata, t = d; f = m; else t = m; f = d; end
  if ~isnan(m), 
    % add the labels
    for j=1:length(inds), 
      if ~isempty(sFrom.labels{f,inds(j)}), 
        Labels{t}{length(Labels{t})+1} = sFrom.labels{f,inds(j)}; 
      end
    end 
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% insert the labels to sTo


if strcmp(mode,'add1') || strcmp(mode,'freq') || strcmp(mode,'vote'),

  % modify the Labels array apprpriately
  
  for i=1:length(Labels),
    
    % calculate frequency of each label in each node
    new_labels = {};
    new_freq = [];
    for j=1:length(Labels{i}),
      if isempty(Labels{i}{j}), % ignore
      elseif ~any(strcmp(Labels{i}{j},new_labels)), % a new one!
	k = length(new_labels) + 1;
	new_labels{k} = Labels{i}{j};
	new_freq(k) = sum(strcmp(new_labels{k},Labels{i}));
      else % an old one, ignore       
      end
    end
    
    % based on frequency, select label(s) to be added 
    if length(new_labels) > 0,
      if strcmp(mode,'add1'), 
	Labels{i} = new_labels;
      else
      
	% sort labels according to frequency
	[~, order] = sort(1./(1+new_freq));
	new_labels = new_labels(order);
	new_freq = new_freq(order);
	
	switch mode,
	 case 'freq', 
	  % replace each label with 'label(#)' where # is the frequency
	  for j=1:length(new_labels), 
	    labf = sprintf('%s(%d)',new_labels{j},new_freq(j));
	    new_labels{j} = labf;
	  end
	  Labels{i} = new_labels;
	 case 'vote',
	  % place only the one with most votes 
	  Labels{i} = {new_labels{1}};
	end 
      end 
    end
    
  end

end

sTo = som_label(sTo,'add',[1:length(Labels)]',Labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




