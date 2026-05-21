function codebook=lvq1(codebook, data, rlen, alpha)

%LVQ1 Trains a codebook with the LVQ1 -algorithm.
%
%  sM = lvq1(sM, D, rlen, alpha)
%
%   sM = lvq1(sM,sD,30*length(sM.codebook),0.08);
%
%  Input and output arguments: 
%   sM    (struct) map struct, the class information must be 
%                  present on the first column of .labels field
%   D     (struct) data struct, the class information must
%                  be present on the first column of .labels field
%   rlen  (scalar) running length
%   alpha (scalar) learning parameter
%
%   sM    (struct) map struct, the trained codebook
%
% NOTE: does not take mask into account.
% 
% For more help, try 'type lvq1', or check out online documentation. 
% See also LVQ3, SOM_SUPERVISED, SOM_SEQTRAIN.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvq1
%
% PURPOSE
%
% Trains codebook with the LVQ1 -algorithm (described below).
%
% SYNTAX
%
%  sM = lvq1(sM, D, rlen, alpha)
%
% DESCRIPTION
%
% Trains codebook with the LVQ1 -algorithm. Codebook contains a number
% of vectors (mi, i=1,2,...,n) and so does data (vectors xj,
% j=1,2,...,k).  Both vector sets are classified: vectors may have a
% class (classes are set to the first column of data or map -structs'
% .labels -field). For each xj there is defined the nearest codebook
% -vector index c by searching the minimum of the euclidean distances
% between the current xj and codebook -vectors:
%
%    c = min{ ||xj - mi|| },  i=[1,..,n], for fixed xj
%         i
% If xj and mc belong to the same class, mc is updated as follows:
%    mc(t+1) = mc(t) + alpha * (xj(t) - mc(t))
% If xj and mc belong to different classes, mc is updated as follows:
%    mc(t+1) = mc(t) - alpha * (xj(t) - mc(t))
% Otherwise updating is not performed.
% 
% Argument 'rlen' tells how many times training sequence is performed.
% LVQ1 -algorithm may be stopped after a number of steps, that is
% 30-50 times the number of codebook vectors.
%
% Argument 'alpha' is the learning rate, recommended to be smaller
% than 0.1.
%
% NOTE: does not take mask into account.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 176-179.
%
% See also LVQ_PAK from http://www.cis.hut.fi/research/som_lvq_pak.shtml
%   
% REQUIRED INPUT ARGUMENTS
%
%  sM                The data to be trained.
%          (struct)  A map struct.
%
%  D                 The data to use in training.
%          (struct)  A data struct.
%
%  rlen    (integer) Running length of LVQ1 -algorithm.
%                    
%  alpha   (float)   Learning rate used in training.
%
% OUTPUT ARGUMENTS
%
%  codebook          Trained data.
%          (struct)  A map struct.
%
% EXAMPLE
%
%   lab = unique(sD.labels(:,1));         % different classes
%   mu = length(lab)*5;                   % 5 prototypes for each    
%   sM = som_randinit(sD,'msize',[mu 1]); % initial prototypes
%   sM.labels = [lab;lab;lab;lab;lab];    % their classes
%   sM = lvq1(sM,sD,50*mu,0.05);          % use LVQ1 to adjust
%                                         % the prototypes      
%   sM = lvq3(sM,sD,50*mu,0.05,0.2,0.3);  % then use LVQ3 
%
% SEE ALSO
% 
%  lvq3             Use LVQ3 algorithm for training.
%  som_supervised   Train SOM using supervised training.
%  som_seqtrain     Train SOM with sequential algorithm.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 310100 juuso 020200

cod = codebook.codebook;
c_class = class2num(codebook.labels(:,1));

dat = data.data;
d_class = class2num(data.labels(:,1));

x=size(dat,1);
y=size(cod,2);

ONES=ones(size(cod,1),1);

for t=1:rlen

  fprintf(1,'\rTraining round: %d',t);
  tmp=NaN*ones(x,y);

  for j=1:x
    no_NaN=find(~isnan(dat(j,:)));
    di = sqrt(sum([cod(:,no_NaN)  - ONES*dat(j,no_NaN)].^2,2));

    [~,ind] = min(di);

    if d_class(j) && d_class(j) == c_class(ind) % 0 is for unclassified vectors
      tmp(ind,:) = cod(ind,:) + alpha * (dat(j,:) - cod(ind,:));
    elseif d_class(j)
      tmp(ind,:) = cod(ind,:) - alpha*(dat(j,:) - cod(ind,:));
    end
  end

  inds = find(~isnan(sum(tmp,2)));
  cod(inds,:) = tmp(inds,:);
end

codebook.codebook = cod;

sTrain = som_set('som_train','algorithm','lvq1',...
		 'data_name',data.name,...
		 'neigh','',...
		 'mask',ones(y,1),...
		 'radius_ini',NaN,...
		 'radius_fin',NaN,...
		 'alpha_ini',alpha,...
		 'alpha_type','constant',...
		 'trainlen',rlen,...
		 'time',datestr(now,0));
codebook.trainhist(end+1) = sTrain;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nos = class2num(class)

names = {};
nos = zeros(length(class),1);

for i=1:length(class)
  if ~isempty(class{i}) && ~any(strcmp(class{i},names))
    names=cat(1,names,class(i));
  end
end

tmp_nos = (1:length(names))';

for i=1:length(class)
  if ~isempty(class{i})
    nos(i,1) = find(strcmp(class{i},names));    
  end
end



