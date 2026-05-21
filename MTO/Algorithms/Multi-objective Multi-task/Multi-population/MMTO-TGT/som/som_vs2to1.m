function sS = som_vs2to1(sS)

%SOM_VS2TO1 Convert version 2 struct to version 1.
%
% sSold = som_vs2to1(sSnew)
%
%  sMold = som_vs2to1(sMnew);  
%  sDold = som_vs2to1(sDnew);  
%
%  Input and output arguments: 
%   sSnew   (struct) a SOM Toolbox version 2 struct
%   sSold   (struct) a SOM Toolbox version 1 struct
%
% For more help, try 'type som_vs2to1' or check out online documentation.
% See also  SOM_SET, SOM_VS1TO2.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_vs2to1
%
% PURPOSE
%
% Converts SOM Toolbox version 2 structs to version 1 structs.
%
% SYNTAX
%
%  sS1 = som_vs2to1(sS2)
%
% DESCRIPTION
%
% This function is offered to allow the change of new map and data structs
% to old ones. There are quite a lot of changes between the versions,
% especially in the map struct, and this function makes it possible to 
% use the old functions with new structs.
%
% Note that part of the information is lost in the conversion. Especially, 
% training history is lost, and the normalization is, except in the simplest
% cases (like all have 'range' or 'var' normalization) screwed up.
%
% REQUIRED INPUT ARGUMENTS
%
%  sS2       (struct) som SOM Toolbox version 2.0 struct (map, data, 
%                     training or normalization struct)
%
% OUTPUT ARGUMENTS
% 
%  sS1       (struct) the corresponding SOM Toolbox version 2.0 struct
%
% EXAMPLES
%
%  sM = som_vs2to1(sMnew);
%  sD = som_vs2to1(sDnew);
%  sT = som_vs2to1(sMnew.trainhist(1));
%
% SEE ALSO
% 
%  som_set          Set values and create SOM Toolbox structs.
%  som_vs1to2       Transform structs from 1.0 version to 2.0.   

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 1, nargin));   % check no. of input arguments is correct

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set field values
  
switch sS.type, 
 case 'som_map',
  msize = sS.topol.msize; 
  [munits dim] = size(sS.codebook);
  
  % topology
  if strcmp(sS.topol.shape,'sheet'), shape = 'rect'; 
  else shape = sS.shape; 
  end
  
  % labels
  labels = cell(munits,1);
  nl = size(sS.labels,2);
  for i=1:munits, 
    labels{i} = cell(nl,1);      
    for j=1:nl, labels{i}{j} = sS.labels{i,j}; end
  end
  
  % trainhist 
  tl = length(sS.trainhist); 
  if tl==0 || strcmp(sS.trainhist(1).algorithm,'lininit'), 
    init_type = 'linear';
  else
    init_type = 'random';
  end
  if tl>1, 
    for i=2:tl, 
      train_seq{i-1} = som_vs2to1(sS.trainhist(i));
    end
    train_type = sS.trainhist(tl).algorithm; 
  else
    train_seq = [];
    train_type = 'batch';
  end 
  if tl>0, data_name = sS.trainhist(tl).data_name; else data_name = ''; end
  
  % component normalizations 
  sN = convert_normalizations(sS.comp_norm);   
  if strcmp(sN.name,'som_hist_norm'), 
    sS.codebook = redo_hist_norm(sS.codebook,sS.comp_norm,sN);
  end
  
  % map 
  sSnew = struct('init_type', 'linear', 'train_type', 'batch', 'lattice' ,...
		 'hexa', 'shape', 'rect', 'neigh', 'gaussian', 'msize', msize, ...
		 'train_sequence', [], 'codebook', [], 'labels', [], ...
		 'mask', [], 'data_name', 'unnamed', 'normalization', [], ...
		 'comp_names', [], 'name', 'unnamed');
  sSnew.init_type = init_type;
  sSnew.train_type = train_type;
  sSnew.lattice = sS.topol.lattice;
  sSnew.shape = shape;
  sSnew.neigh = sS.neigh;
  sSnew.msize = sS.topol.msize;
  sSnew.train_sequence = train_seq;
  sSnew.codebook = reshape(sS.codebook,[sS.topol.msize dim]);
  sSnew.labels = labels;
  sSnew.mask = sS.mask;
  sSnew.data_name = data_name;
  sSnew.normalization = sN;
  sSnew.comp_names = sS.comp_names;
  sSnew.name = sS.name;
  
 case 'som_data',
  [dlen dim] = size(sS.data);
  
  % component normalizations
  sN = convert_normalizations(sS.comp_norm); 
  if strcmp(sN.name,'som_hist_norm'), 
    sS.codebook = redo_hist_norm(sS.codebook,sS.comp_norm,sN);
  end
  
  % data
  sSnew = struct('data', [], 'name', '', 'labels' , [], 'comp_names', ...
		 [], 'normalization', []);
  sSnew.data = sS.data;
  sSnew.name = sS.name;
  sSnew.labels = sS.labels;
  sSnew.comp_names = sS.comp_names;
  sSnew.normalization = sN;
  
 case 'som_norm',     
  sSnew = struct('name','som_var_norm','inv_params',[]);
  
  switch sS.method, 
   case 'var',   sSnew.name = 'som_var_norm';
   case 'range', sSnew.name = 'som_lin_norm';
   case 'histD', sSnew.name = 'som_hist_norm';
   otherwise, 
    warning(['Method ' method ' does not exist in version 1.'])
  end

  if strcmp(sS.status,'done'),   
    switch sS.method, 
     case 'var', 
      sSnew.inv_params = zeros(2,1);
      sSnew.inv_params(1) = sS.params(1);
      sSnew.inv_params(2) = sS.params(2);
     case 'range', 
      sSnew.inv_params = zeros(2,1);
      sSnew.inv_params(1) = sS.params(1);
      sSnew.inv_params(2) = sS.params(2) + sS.params(1);
     case 'histD',
      bins = length(sS.params);
      sSnew.inv_params = zeros(bins+1,1) + Inf;
      sSnew.inv_params(1:bins,i) = sS.params;
      sSnew.inv_params(end,i) = bins; 
    end
  end
  
 case 'som_train', 
  sSnew = struct('algorithm', sS.algorithm, 'radius_ini', ...
		 sS.radius_ini, 'radius_fin', sS.radius_fin, 'alpha_ini', ...
		 sS.alpha_ini, 'alpha_type', sS.alpha_type, 'trainlen', sS.trainlen, ...
		 'qerror', NaN, 'time', sS.time);
  
 case 'som_topol', 
  disp('Version 1 of SOM Toolbox did not have topology structure.\n');
  
 otherwise, 
  
  error('Unrecognized struct.');
end

sS = sSnew;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function sN = convert_normalizations(cnorm)

  dim = length(cnorm);
  sN = struct('name','som_var_norm','inv_params',[]);
    
  % check that there is exactly one normalization per component
  % and that their status and method is the same
  ok = 1;
  nof = zeros(dim,1);
  for i=1:dim, nof(i) = length(cnorm{i}); end
  if any(nof>1), ok=0; 
  elseif any(nof==1) && any(nof==0), ok=0;
  elseif any(nof>0), 
    status = cnorm{1}.status;
    method = cnorm{1}.method;
    for i=2:dim, 
      if ~strcmp(cnorm{i}.status,status) || ~strcmp(cnorm{i}.method,method), 
	ok = 0; 
      end
    end    
  elseif all(nof==0), 
    return;
  end
  if ~ok, 
    warning(['Normalization could not be converted. All variables can' ...
	     ' only be normalized with a single, and same, method.']);
    return;
  end  
  
  % method name
  switch method, 
   case 'var', sN.name = 'som_var_norm';
   case 'range', sN.name = 'som_lin_norm';
   case 'histD', sN.name = 'som_hist_norm';
   otherwise, 
    warning(['Normalization could not be converted. Method ' method ...
	     'does not exist in version 1.']);
    return;
  end

  % if not done, inv_params is empty
  if ~strcmp(status,'done'), return; end  
   
  % ok, make the conversion  
  switch method, 
   case 'var',   
    sN.inv_params = zeros(2,dim);
    for i=1:dim, 
      sN.inv_params(1,i) = cnorm{i}.params(1);
      sN.inv_params(2,i) = cnorm{i}.params(2);
    end
   case 'range',
    sN.inv_params = zeros(2,dim);
    for i=1:dim, 
      sN.inv_params(1,i) = cnorm{i}.params(1);
      sN.inv_params(2,i) = cnorm{i}.params(2) + cnorm{i}.params(1);
    end
   case 'histD',     
    bins = zeros(dim,1); 
    for i=1:dim, bins(i) = length(cnorm{i}.params); end
    m = max(bins); 
    sN.inv_params = zeros(m+1,dim) + Inf;
    for i=1:dim, 
      sN.inv_params(1:bins(i),i) = cnorm{i}.params;
      if bins(i)<m, sN.inv_params(bins(i)+1,i) = NaN; end
      sN.inv_params(end,i) = bins(i); 
    end
  end

function D = redo_hist_norm(D,cnorm,sN)

  dim = size(D,2);

  % first - undo the new way
  for i=1:dim, 
    bins = length(cnorm{i}.params);
    D(:,i) = round(D(:,i)*(bins-1)+1);
    inds = find(~isnan(D(:,i)) & ~isinf(D(:,i)));
    D(inds,i) = cnorm{i}.params(D(inds,i));
  end  
  % then - redo the old way
  n_bins = sN.inv_params(size(sN.inv_params,1),:);
  for j = 1:dim,        
    for i = 1:size(D, 1)
      if ~isnan(D(i, j)),
	[d ind] = min(abs(D(i, j) - sN.inv_params(1:n_bins(j), j)));
	if (D(i, j) - sN.inv_params(ind, j)) > 0 && ind < n_bins(j),
	  D(i, j) = ind + 1;   
	else                   
	  D(i, j) = ind;
	end
      end
    end
  end
  D = D * sparse(diag(1 ./ n_bins));


