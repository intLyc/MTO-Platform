function sS = som_vs1to2(sS)

%SOM_VS1TO2 Convert version 1 structure to version 2.
%
% sSnew = som_vs1to2(sSold)
%
%  sMnew = som_vs1to2(sMold);  
%  sDnew = som_vs1to2(sDold);  
%
%  Input and output arguments: 
%   sSold   (struct) a SOM Toolbox version 1 structure
%   sSnew   (struct) a SOM Toolbox version 2 structure
%
% For more help, try 'type som_vs1to2' or check out online documentation.
% See also  SOM_SET, SOM_VS2TO1.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_vs1to2
%
% PURPOSE
%
% Transforms SOM Toolbox 1 version structs from to 2 version structs.
%
% SYNTAX
%
%  sS2 = som_vs1to2(sS1)
%
% DESCRIPTION
%
% This function is offered to allow the change of old map and data structs
% to new ones. There are quite a lot of changes between the versions,
% especially in the map struct, and this function makes it easy to update 
% the structs.
%
% WARNING!
%
% 'som_unit_norm' normalization type is not supported by version 2,
% so this type of normalization will be lost.
%
% REQUIRED INPUT ARGUMENTS
%
%  sS1       (struct) any SOM Toolbox version 1 struct (map, data, 
%                     training or normalization struct)
%
% OUTPUT ARGUMENTS
% 
%  sS2       (struct) the corresponding SOM Toolbox 2 version struct
%
% EXAMPLES
%
%  sM = som_vs1to2(sMold);
%  sD = som_vs1to2(sDold);
%  sT = som_vs1to2(sMold.train_sequence{1});
%  sN = som_vs1to2(sDold.normalization); 
%
% SEE ALSO
% 
%  som_set          Set values and create SOM Toolbox structs.
%  som_vs2to1       Transform structs from version 2.0 to 1.0.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 1, nargin));   % check no. of input arguments is correct

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set field values

if isfield(sS,'codebook'), type='som_map'; 
elseif isfield(sS,'data'), type='som_data'; 
elseif isfield(sS,'algorithm'), type = 'som_train';
elseif isfield(sS,'inv_params'), type = 'som_norm'; 
else
  error('Unrecognized input struct.'); 
end

switch type, 
 case 'som_map',
  msize = sS.msize; munits = prod(msize); dim = numel(sS.codebook)/munits; 
  M = reshape(sS.codebook,[munits dim]);

  % topology
  if strcmp(sS.shape,'rect'), shape = 'sheet'; else shape = sS.shape; end
  sTopol = struct('type','som_topol','msize',msize,'lattice',sS.lattice,'shape',shape);
  
  % labels
  labels = cell(munits,1);
  for i=1:munits, 
    for j=1:length(sS.labels{i}), labels{i,j} = sS.labels{i}{j}; end
  end
  
  % trainhist
  tl = length(sS.train_sequence); 
  if strcmp(sS.init_type,'linear'); alg = 'lininit'; else alg = 'randinit'; end
  trh = struct('type','som_train');
  trh.algorithm = alg;
  trh.neigh = sS.neigh;
  trh.mask = sS.mask;
  trh.data_name = sS.data_name; 
  trh.radius_ini = NaN;
  trh.radius_fin = NaN;
  trh.alpha_ini = NaN; 
  trh.alpha_type = '';
  trh.trainlen = NaN;
  trh.time = '';
  for i=1:tl, 
    trh(i+1) = som_vs1to2(sS.train_sequence{i});     
    trh(i+1).mask = sS.mask;
    trh(i+1).neigh = sS.neigh;
    trh(i+1).data_name = sS.data_name;
  end
  
  % component normalizations
  cnorm = som_vs1to2(sS.normalization); 
  if isempty(cnorm), 
    cnorm = cell(dim,1);
  elseif length(cnorm) ~= dim, 
    warning('Incorrect number of normalizations. Normalizations ignored.\n');	    
    cnorm = cell(dim,1);
  else
    if strcmp(cnorm{1}.method,'histD'),
      M = redo_hist_norm(M,sS.normalization.inv_params,cnorm);
    end
  end     
  
  % map
  sSnew = struct('type','som_map');
  sSnew.codebook = M;
  sSnew.topol = sTopol;
  sSnew.labels = labels;
  sSnew.neigh = sS.neigh;
  sSnew.mask = sS.mask;
  sSnew.trainhist = trh;
  sSnew.name = sS.name;
  sSnew.comp_norm = cnorm;
  sSnew.comp_names = sS.comp_names;
  
 case 'som_data',
  [dlen dim] = size(sS.data);
  
  % component normalizations
  cnorm = som_vs1to2(sS.normalization);
  if isempty(cnorm), 
    cnorm = cell(dim,1);
  elseif length(cnorm) ~= dim, 
    warning('Incorrect number of normalizations. Normalizations ignored.\n');
    cnorm = cell(dim,1);
  else
    if strcmp(cnorm{1}.method,'histD'),
      sS.data = redo_hist_norm(sS.data,sS.normalization.inv_params,cnorm);
    end     
  end

  % data
  sSnew = struct('type','som_data');
  sSnew.data = sS.data;
  sSnew.name = sS.name;
  sSnew.labels = sS.labels;
  sSnew.comp_names = sS.comp_names;
  sSnew.comp_norm = cnorm;
  sSnew.label_names = []; 
  
 case 'som_norm',       
  if isempty(sS.inv_params), 
    sSnew = []; 
  else 
    dim = size(sS.inv_params,2);      
    sSnew = cell(dim,1);
    switch sS.name, 
     case 'som_var_norm',  method = 'var'; 
     case 'som_lin_norm',  method = 'range'; 
     case 'som_hist_norm', method = 'histD'; 
     case 'som_unit_norm', method = '';
      warning(['Normalization method ''som_unit_norm'' is not available' ...
	       ' in version 2 of SOM Toolbox.\n']);
    end
    if ~isempty(method), 
      for i=1:dim, 
	sSnew{i} = struct('type','som_norm');
	sSnew{i}.method = method;
	sSnew{i}.params = [];
	sSnew{i}.status = 'done';
	switch method, 
	 case 'var',   
	  me = sS.inv_params(1,i); st = sS.inv_params(2,i);
	  sSnew{i}.params = [me, st];
	 case 'range', 
	  mi = sS.inv_params(1,i); ma = sS.inv_params(2,i); 
	  sSnew{i}.params = [mi, ma-mi]; 
	 case 'histD',
	  vals = sS.inv_params(1:(end-1),i);
	  bins = sum(isfinite(vals));
	  vals = vals(1:bins);
	  sSnew{i}.params = vals;
	end	  
      end
    end
  end
  
 case 'som_train', 
  sSnew = struct('type','som_train');
  sSnew.algorithm = sS.algorithm;
  sSnew.neigh = 'gaussian';
  sSnew.mask = [];
  sSnew.data_name = 'unknown'; 
  sSnew.radius_ini = sS.radius_ini;
  sSnew.radius_fin = sS.radius_fin;
  sSnew.alpha_ini = sS.alpha_ini;
  sSnew.alpha_type = sS.alpha_type;
  sSnew.trainlen = sS.trainlen;
  sSnew.time = sS.time;
  
 case 'som_topol', 
  disp('Version 1.0 of SOM Toolbox did not have topology structure.\n');
 
 case {'som_grid','som_vis'}
  disp('Version 1.0 of SOM Toolbox did not have visualization structs.\n');
  
 otherwise, 
  
  error('Unrecognized struct.');
end

sS = sSnew;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function D = redo_hist_norm(D,inv_params,cnorm)

  dim = size(D,2);

  % first - undo the old way
  n_bins = inv_params(end,:);
  D   = round(D * sparse(diag(n_bins)));
  for i = 1:dim,
    if any(isnan(D(:, i))), D(isnan(D(:, i)), i) = n_bins(i); end
    D(:, i) = inv_params(D(:, i), i);
  end
  % then - redo the new way
  for i=1:dim, 
    bins = length(cnorm{i}.params);
    x = D(:,i);
    inds = find(~isnan(x) & ~isinf(x))';
    for j = inds, 
      [dummy ind] = min(abs(x(j) - cnorm{i}.params));
      if x(j) > cnorm{i}.params(ind) && ind < bins, x(j) = ind + 1;  
      else x(j) = ind;
      end
    end
    D(:,i) = (x-1)/(bins-1);
  end




