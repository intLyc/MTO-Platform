function som_info(sS,level)

%SOM_INFO Displays information on the given SOM Toolbox struct.
% 
% som_info(sS,[level])
%
%  som_info(sMap);
%  som_info(sData,3);
%  som_info({sMap,sData});
%  som_info(sMap.comp_norm{2}); 
%
%  Input and output arguments ([]'s are optional): 
%   sS       (struct) SOM Toolbox struct 
%            (cell array of structs) several structs in a cell array
%   [level]  (scalar) detail level (1-4), default = 1
%
% For more help, try 'type som_info' or check out online documentation.
% See also SOM_SET.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_info
%
% PURPOSE
%
% Display information of the given SOM Toolbox struct(s).
%
% SYNTAX
%
%  som_info(sM)
%  som_info({sM,sD})
%  som_info(...,level)
%
% DESCRIPTION
%
% Display the contents of the given SOM Toolbox struct(s). Information
% of several structs can be shown if the structs are given in a cell 
% array. The level of detail can be varied with the second argument.
% The number of different levels varies between structs. For map and 
% data structs, not only the fields, but also some statistics of the 
% vectors ('.data' and '.codebook' fields) is displayed. 
%
%   map struct
%    level 1: name, dimension, topology, dimension, neigborhood function,
%             mask and training status
%    level 2: ..., training history
%    level 3: ..., vector component names, statistics and normalization status
%    level 4: ..., vector component normalizations
%
%   data struct:
%    level 1: name, dimension, data set completeness statistics
%    level 2: ..., vector component names, statistics and normalization status
%    level 3: ..., vector component normalizations
%    level 4: ..., label statistics
%    
%   topology struct: 
%    level 1: all fields
%
%   train struct: 
%    level 1: all fields
%
%   normalization struct: 
%    level 1: method, status
%    level 2: ..., parameters
%    
% REQUIRED INPUT ARGUMENTS
%
%   sS       (struct) SOM Toolbox struct 
%            (cell array of structs) several structs in a cell array
%  
% OPTIONAL INPUT ARGUMENTS 
%
%   level    (scalar) detail level (1-4), default = 1
%
% EXAMPLES
%
%  som_info(sM)
%  som_info(sM,4)
%  som_info(sM.trainhist)
%  som_info(sM.comp_norm{3})
%
% SEE ALSO
% 
%  som_set        Set fields and create SOM Toolbox structs.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta ecco 110997
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(1, 2, nargin))  % check no. of input args is correct

if ~isstruct(sS),
  if ~iscell(sS) || ~isstruct(sS{1}), 
    error('Invalid first input argument.')
  end
  csS = sS;
else
  l = length(sS);   
  csS = cell(l,1); 
  for i=1:l, csS{i} = sS(i); end
end

if nargin<2 || isempty(level) || isnan(level), level = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% print struct information

for c=1:length(csS), 
 sS = csS{c};
 fprintf(1,'\n');
 
 switch sS.type, 
 case 'som_map', 
  mdim = length(sS.topol.msize);
  [munits dim] = size(sS.codebook);
  t    = length(sS.trainhist);  
  if t==0, st='uninitialized'; 
  elseif t==1, st = 'initialized';
  else st = sprintf('initialized, trained %d times',t-1);
  end

  % level 1
  fprintf(1,'Struct type                           : %s\n', sS.type);
  fprintf(1,'Map name                              : %s\n', sS.name);
  fprintf(1,'Input dimension                       : %d\n', dim);
  fprintf(1,'Map grid size                         : ');
  for i = 1:mdim - 1, fprintf(1,'%d x ',sS.topol.msize(i)); end
  fprintf(1,'%d\n', sS.topol.msize(mdim));
  fprintf(1,'Lattice type (rect/hexa)              : %s\n', sS.topol.lattice);
  fprintf(1,'Shape (sheet/cyl/toroid)              : %s\n', sS.topol.shape);
  fprintf(1,'Neighborhood type                     : %s\n', sS.neigh);
  fprintf(1,'Mask                                  : ');
  if dim,
    for i = 1:dim-1, fprintf(1,'%d ',sS.mask(i)); end; 
    fprintf(1,'%d\n',sS.mask(dim));
  else fprintf(1,'\n');
  end
  fprintf(1,'Training status                       : %s\n', st);
   
  % level 1,
  status = cell(dim,1);
  for i=1:dim, 
    n = length(sS.comp_norm{i});
    if n, 
      uninit = strcmp('uninit',{sS.comp_norm{i}.status});
      done   = strcmp('done',{sS.comp_norm{i}.status});
      undone = strcmp('undone',{sS.comp_norm{i}.status});
      if sum(uninit)==n, status{i} = 'none';
      elseif sum(done)==n, status{i} = 'done';
      elseif sum(undone)==n, status{i} = 'undone';
      else status{i} = 'partial';
      end
    else status{i} = 'no normalization'; end
  end
  if level>1, 
    fprintf(1,'\nVector components\n');
    M = sS.codebook;
    fprintf(1,' #   name          mask     min    mean     max     std  normalization\n');
    fprintf(1,' --- ------------  ----  ------  ------  ------  ------  -------------\n');
    for i = 1:dim,
      fprintf(1,' %-3d %-12s  %-4.2f  %6.2g  %6.2g  %6.2g  %6.2g  %s\n', ...
              i,sS.comp_names{i}, sS.mask(i), ...
              min(M(:,i)),mean(M(:,i)),max(M(:,i)),std(M(:,i)),status{i});
    end
  end

  % level 3
  if level>2,
    fprintf(1,'\nVector component normalizations\n');
    fprintf(1,' #   name          method (i=uninit,u=undone,d=done)\n');
    fprintf(1,' --- ------------  ---------------------------------------\n');
    for i=1:dim,  
      fprintf(1,' %-3d %-12s  ',i,sS.comp_names{i});
      n = length(sS.comp_norm{i}); 
      for j=1:n, 
        m = sS.comp_norm{i}(j).method;
        s = sS.comp_norm{i}(j).status;
        if strcmp(s,'uninit'), c='i'; 
        elseif strcmp(s,'undone'), c='u'; 
        else c='d';
        end
        fprintf(1,'%s[%s] ',m,c);
      end
      fprintf(1,'\n');
    end
  end
  
  % level 4
  if level>3,
    fprintf(1,'\nTraining history\n');
    fprintf(1,'Algorithm Data          Trainlen Neigh.f. Radius     Alpha (type)   Date\n');
    fprintf(1,'--------- ------------- -------- -------- ---------- -------------- --------------------\n');	       
    for i=1:t, 
      sT = sS.trainhist(i);
      fprintf(1,'%8s  %13s %8d %8s %4.2f->%4.2f %5.3f (%6s) %s\n',...
	      sT.algorithm,sT.data_name,sT.trainlen,...
	      sT.neigh,sT.radius_ini,sT.radius_fin,sT.alpha_ini,sT.alpha_type,sT.time);      
      %for j = 1:length(sT.mask)-1, fprintf(1,'%d ',sT.mask(j)); end; 
      %if ~isempty(sT.mask), fprintf(1,'%d\n',sT.mask(end)); else fprintf(1,'\n'); end
    end
  end

 case 'som_data',

  [dlen dim] = size(sS.data);
  if dlen*dim
    if dim>1, ind = find(~isnan(sum(sS.data,2)));
    else ind = find(~isnan(sS.data));
    end
  else ind = []; end
  complete = size(sS.data(ind,:),1);
  partial  = dlen - complete;
  values   = numel(sS.data);
  missing  = sum(sum(isnan(sS.data))); 

  % level 1  
  fprintf(1,'Struct type             : %s\n', sS.type);
  fprintf(1,'Data name               : %s\n', sS.name);
  fprintf(1,'Vector dimension        : %d\n', dim);
  fprintf(1,'Number of data vectors  : %d\n', dlen);
  fprintf(1,'Complete data vectors   : %d\n', complete);
  fprintf(1,'Partial data vectors    : %d\n', partial);  
  if values, r = floor(100 * (values - missing) / values); else r = 0; end
  fprintf(1,'Complete values         : %d of %d (%d%%)\n', ...
          values-missing, values, r); 

  % level 2,
  status = cell(dim,1);
  for i=1:dim, 
    n = length(sS.comp_norm{i});
    if n, 
      uninit = strcmp('uninit',{sS.comp_norm{i}.status});
      done   = strcmp('done',{sS.comp_norm{i}.status});
      undone = strcmp('undone',{sS.comp_norm{i}.status});
      if sum(uninit)==n, status{i} = 'none';
      elseif sum(done)==n, status{i} = 'done';
      elseif sum(undone)==n, status{i} = 'undone';
      else status{i} = 'partial';
      end
    else status{i} = 'no normalization'; end
  end
  if level>1, 
    fprintf(1,'\nVector components\n');
    D = sS.data;
    fprintf(1,' #   name            min     mean     max     std  missing      normalization\n');
    fprintf(1,' --- ------------  ------  ------  ------  ------  -----------  -------------\n');
    for i = 1:dim,
      known = find(~isnan(D(:,i))); 
      miss = dlen-length(known);
      switch length(known), 
       case 0, mi = NaN; me = NaN; ma = NaN; st = NaN; 
       case 1, mi = D(known,i); me = mi; ma = mi; st = 0;
       otherwise, 
	mi = min(D(known,i)); ma = max(D(known,i)); 
	me = mean(D(known,i)); st = std(D(known,i)); 
      end
      fprintf(1,' %-3d %-12s  %6.2g  %6.2g  %6.2g  %6.2g  %5d (%2d%%)  %s\n', ...
              i,sS.comp_names{i},mi,me,ma,st,miss,floor(100*miss/dlen),status{i});
    end
  end

  % level 3
  if level>2,
    fprintf(1,'\nVector component normalizations\n');
    fprintf(1,' #   name          method (i=uninit,u=undone,d=done)\n');
    fprintf(1,' --- ------------  ---------------------------------------\n');
    for i=1:dim,  
      fprintf(1,' %-3d %-12s  ',i,sS.comp_names{i});
      n = length(sS.comp_norm{i});         
      for j=1:n, 
        m = sS.comp_norm{i}(j).method;
        s = sS.comp_norm{i}(j).status;
        if strcmp(s,'uninit'), c='i'; 
        elseif strcmp(s,'undone'), c='u'; 
        else c='d';
        end
        fprintf(1,'%s[%s] ',m,c);
      end
      fprintf(1,'\n');
    end
  end

  % level 4
  if level>3,
    m = size(sS.labels,2);
    fprintf(1,'\nLabels\n');   
    if isempty(sS.label_names),       
      labs = {''}; freq = 0; 
      for i=1:dlen*m, 
	l = sS.labels{i}; 
	if isempty(l), freq(1) = freq(1)+1; 
	else 
	  k = find(strcmp(labs,l)); 
	  if isempty(k), labs{end+1} = l; freq(end+1) = 1; 
	  else freq(k)=freq(k)+1;
	  end
	end
      end
      emp = freq(1); 
      uni = length(freq)-1;
      if uni>0, tot = sum(freq(2:end)); else tot = 0; end
      fprintf(1,' Total: %d\n Empty: %d\n Unique: %d\n',tot,emp,uni);
    else
      for j=1:m, 
	labs = {''}; freq = 0; 
	for i=1:dlen, 
	  l = sS.labels{i,j}; 
	  if isempty(l), freq(1) = freq(1)+1; 
	  else 
	    k = find(strcmp(labs,l)); 
	    if isempty(k), labs{end+1} = l; freq(end+1) = 1; 
	    else freq(k)=freq(k)+1;
	    end
	  end
	end
	emp = freq(1); 
	uni = length(freq)-1;
	if uni>0, tot = sum(freq(2:end)); else tot = 0; end
	fprintf(1,' [%s] Total / empty / unique: %d / %d / %d\n', ...
		sS.label_names{j},tot,emp,uni); 
      end
    end
  end
  
 case 'som_topol', 

  mdim = length(sS.msize);
 
  % level 1
  fprintf(1,'Struct type                           : %s\n',sS.type);
  fprintf(1,'Map grid size                         : ');
  for i = 1:mdim - 1, fprintf(1,'%d x ',sS.msize(i)); end
  fprintf(1,'%d\n', sS.msize(mdim));
  fprintf(1,'Lattice type (rect/hexa)              : %s\n', sS.lattice);
  fprintf(1,'Shape (sheet/cyl/toroid)              : %s\n', sS.shape);

 case 'som_train', 

  % level 1
  fprintf(1,'Struct type                           : %s\n',sS.type);
  fprintf(1,'Training algorithm                    : %s\n',sS.algorithm);
  fprintf(1,'Training data                         : %s\n',sS.data_name);
  fprintf(1,'Neighborhood function                 : %s\n',sS.neigh);
  fprintf(1,'Mask                                  : ');
  dim = length(sS.mask);
  if dim, 
    for i = 1:dim-1, fprintf(1,'%d ',sS.mask(i)); end; 
    fprintf(1,'%d\n',sS.mask(end));
  else fprintf(1,'\n'); end
  fprintf(1,'Initial radius                        : %-6.1f\n',sS.radius_ini);
  fprintf(1,'Final radius                          : %-6.1f\n',sS.radius_fin);
  fprintf(1,'Initial learning rate (alpha)         : %-6.1f\n',sS.alpha_ini);
  fprintf(1,'Alpha function type (linear/inv)      : %s\n',sS.alpha_type);
  fprintf(1,'Training length                       : %d\n',sS.trainlen);
  fprintf(1,'When training was done                : %s\n',sS.time);

  case 'som_norm', 
   
   % level 1
   fprintf(1,'Struct type                           : %s\n',sS.type);
   fprintf(1,'Normalization method                  : %s\n',sS.method);
   fprintf(1,'Status                                : %s\n',sS.status);
   
   % level 2
   if level>1, 
     fprintf(1,'Parameters:\n');
     sS.params
   end
   
  case 'som_grid', 
   
   % level 1
   fprintf(1,'Struct type                           : %s\n',sS.type);
   if ischar(sS.neigh), 
     fprintf(1,'Connections                           : [%d %d], %s, %s\n',...
	     sS.msize(1),sS.msize(2),sS.neigh,sS.shape);
   else
     fprintf(1,'Connections                           : [%d %d] %d lines\n',...
	     sS.msize(1),sS.msize(2),sum(sS.neigh));
   end
   fprintf(1,'Line                                  : %s\n',sS.line);
   if length(sS.marker)==1, 
     fprintf(1,'Marker                                : %s\n',sS.marker);
   else
     fprintf(1,'Marker                                : varies\n');
   end
   fprintf(1,'Surf                                  : ');
   if isempty(sS.surf), fprintf(1,'off\n'); else fprintf(1,'on\n'); end
   fprintf(1,'Labels                                : ');
   if isempty(sS.label), fprintf(1,'off\n'); 
   else fprintf(1,'on (%d)\n',sS.labelsize); end
   
 end

 fprintf(1,'\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
