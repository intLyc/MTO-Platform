function sD = som_modify_dataset(sD,action,varargin)

%SOM_MODIFY_DATASET Add or remove components or samples to/from a data struct.
%
% sD = som_modify_dataset(sD, 'addcomp', D, [indsto], [cnames})
% sD = som_modify_dataset(sD, 'addsamp', D, [indsto], ['norm'])
% sD = som_modify_dataset(sD, 'removecomp', [inds])
% sD = som_modify_dataset(sD, 'removesamp', inds)
% sD = som_modify_dataset(sD, 'extractcomp', [inds])
% sD = som_modify_dataset(sD, 'extractsamp', inds)
% sD = som_modify_dataset(sD, 'movecomp', inds, indsto)
% sD = som_modify_dataset(sD, 'movesamp', inds, indsto)
%
%  Input and output arguments ([]'s are optional)
%   sD      (struct) data struct
%   action  (string) 'addcomp', 'addsamp', 'removecomp', 'removesamp', 
%                    'extractcomp', 'extractsamp', 'movecomp', or 'movesamp' 
%
%   other input arguments depend on the action
%
%   'addcomp': 
%   D        (matrix) data matrix, size [dlen x d]
%            (struct) data struct, size of .data field [dlen x d]
%   [indsto] (vector) new indeces of the components, length=d
%   [cnames] (cellstr) of size d x 1, the component names
%
%   'addsamp': 
%   D        (matrix) data matrix, size [n x dim] 
%   [indsto] (vector) new indeces of the samples, length=n
%   ['norm'] (string) specified if the normalization procedure
%                     should be applied to the new samples
%
%   'removecomp', 'extractcomp': 
%   [inds]   (vector) indeces of the components to be removed/extracted. 
%                     If not given, a prompt will appear from which the
%                     user can select the appropriate components.
%
%   'removesamp', 'extractsamp': 
%   inds     (vector) indeces of the samples to be removed/extracted
%
%   'movecomp', 'movesamp': 
%   inds     (vector) indeces of the components/samples to be moved
%   indsto   (vector) new indeces of the components/samples 
%
% See also SOM_DATA_STRUCT.

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on June 16th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 200400 160600 280800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

[dlen dim] = size(sD.data);

switch action, 
  case 'addcomp',  
    D = varargin{1};     
    if isstruct(D), [n d] = size(D.data); else [n d] = size(D); end
    if n ~= dlen, error('The number of samples in the data struct and new data should match.'); end
    indsto = []; 
    cnames = []; 
    for i=2:length(varargin), 
      if isnumeric(varargin{i}), 
	indsto = varargin{i}; 
	if length(indsto) ~= d, 
	  error('The number of indeces should match the number of new components'); 
	end
      else
	if ischar(varargin{i}), cnames = cellstr(varargin{i}); 
	elseif iscellstr(varargin{i}), cnames = varargin{i}; 
	else
	  error(['[som_modify_dataset] Unrecognized argument #' num2str(i+1)]); 
	end	
	if length(cnames) ~= d, 
	  error('The number of component names should match the number of new components'); 
	end
      end
    end
 case 'addsamp',
  D = varargin{1};
  if isstruct(D), 
    lab = D.labels; 
    if isfield(D,'data'), D = D.data; else D = D.codebook; end
  else lab = []; 
  end
  [n d] = size(D); 
  if d ~= dim, 
    error(['The dimensions of the old and new data sets should match.']); 
  end
  norm = 0; 
  indsto = []; 
  for i=2:length(varargin),
    if ischar(varargin{i}) && strcmp(varargin{i},'norm'), norm = 1; 
    elseif isnumeric(varargin{i}), 
      indsto = varargin{i}; 
      if length(indsto) ~= n, 
	error(['The number of new indeces should match the number of new' ...
	       ' samples']); 
      end
    else
      warning(['[som_modify_dataset] Ignoring unrecognized argument #', ...
	       num2str(i+2)]);
    end
  end
 case 'removecomp',
  if length(varargin)>0, 
    inds = varargin{1};
  else
    [inds, ok] = listdlg('ListString',sD.comp_names, 'PromptString', ...
                         'Components', 'Name', 'Remove components', 'uh', 25);
    if ~ok, return; end
  end
  if min(inds)<1 || max(inds)>dim, 
    error('The component indeces must be within [1,dim]'); 
  end
 case 'removesamp',
  inds = varargin{1};
  if min(inds)<1 || max(inds)>dlen, 
    error('The sample indeces must be within [1,dlen]'); 
  end
 case 'extractcomp',
  if length(varargin)>0, 
    inds = varargin{1};
  else
    [inds, ok] = listdlg('ListString',sD.comp_names, 'PromptString',... 
                         'Components', 'Name', 'Extract components', 'uh', 25);
    if ~ok, return; end
  end
  if min(inds)<1 || max(inds)>dim, 
    error('The component indeces must be within [1,dim]'); 
  end
 case 'extractsamp',
  inds = varargin{1};
  if min(inds)<1 || max(inds)>dlen, 
    error('The sample indeces must be within [1,dlen]'); 
  end
 case 'movecomp',
  inds = varargin{1};
  indsto = varargin{2};
  if min(inds)<1 || max(inds)>dim || min(indsto)<1 || max(indsto)>dim, 
    error('The component indeces must be within [1,dim]'); 
  end
 case 'movesamp',
  inds = varargin{1};
  indsto = varargin{2};
  if min(inds)<1 || max(inds)>dlen || min(indsto)<1 || max(indsto)>dlen, 
    error('The sample indeces must be within [1,dlen]'); 
  end
 otherwise, 
  error('Unrecognized action mode');
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

switch action, 
  case 'addcomp', 
    if isstruct(D),       
      sD.data = [sD.data, D.data]; 
      sD.comp_names(dim+[1:d]) = D.comp_names; 
      sD.comp_norm(dim+[1:d]) = D.comp_norm; 
      sD = som_label(sD,'add',1:dlen,D.labels);
    else
      sD.data = [sD.data, D];
      if isempty(cnames), 
	for i=1:d, sD.comp_names(dim+i) = {sprintf('Variable%d',i+dim)}; end
      else
	sD.comp_names(dim+[1:d]) = cnames; 
      end
      for i=1:d, sD.comp_norm(dim+i) = {[]}; end
    end
    if ~isempty(indsto), 
      sD = som_modify_dataset(sD,'movecomp',dim+[1:d],indsto);
    end

  case 'addsamp', 
    if norm, D = som_normalize(D,sD); end
    sD.data = [sD.data; D]; 
    nl = size(sD.labels,2); 
    sD.labels(dlen+[1:n],1:nl) = {''};
    if ~isempty(lab), 
      nl2 = size(lab,2); 
      if nl2>nl, sD.labels(1:dlen,nl+[1:(nl2-nl)]) = {''}; end
      sD.labels(dlen+[1:n],1:nl2) = lab; 
    end
    if ~isempty(indsto), 
      sD = som_modify_dataset(sD,'movesamp',dlen+[1:n],indsto);
    end

  case 'removecomp', 
    includeinds = 1:dim; 
    includeinds(inds) = 0; 
    sD = som_modify_dataset(sD,'extractcomp',find(includeinds));

  case 'removesamp', 
    includeinds = 1:dlen; 
    includeinds(inds) = 0; 
    sD = som_modify_dataset(sD,'extractsamp',find(includeinds));

  case 'extractcomp', 
    sD.data = sD.data(:,inds);
    sD.comp_names = sD.comp_names(inds);
    sD.comp_norm = sD.comp_norm(inds);    

  case 'extractsamp', 
    sD.data = sD.data(inds,:);
    sD.labels = sD.labels(inds,:);

  case 'movecomp', 
    [indsto,order] = sort(indsto);
    inds = inds(order);
    oldinds = 1:dim; 
    oldinds(inds) = 0; 
    newinds = oldinds(oldinds>0);
    for i=1:length(indsto),
      ifrom = inds(i); ito = indsto(i);
      if ito==1, newinds = [ifrom, newinds];
      else newinds = [newinds(1:ito-1), ifrom, newinds(ito:end)];
      end
    end
    sD.data = sD.data(:,newinds); 
    sD.comp_names = sD.comp_names(:,newinds); 
    sD.comp_norm = sD.comp_norm(:,newinds); 

  case 'movesamp', 
    [indsto,order] = sort(indsto);
    inds = inds(order);
    oldinds = 1:dim; 
    oldinds(inds) = 0; 
    newinds = oldinds(oldinds>0);
    for i=1:length(indsto),
      ifrom = inds(i); ito = indsto(i);
      if ito==1, newinds = [ifrom, newinds];
      else newinds = [newinds(1:ito-1), ifrom, newinds(ito:end)];
      end
    end
    sD.data = sD.data(newinds,:);
    sD.labels = sD.labels(newinds,:);

end

%som_set(sD);


