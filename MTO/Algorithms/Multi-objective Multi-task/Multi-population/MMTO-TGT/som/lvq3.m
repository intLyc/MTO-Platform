function codebook = lvq3(codebook,data,rlen,alpha,win,epsilon)

%LVQ3 trains codebook with LVQ3 -algorithm
%
% sM = lvq3(sM,D,rlen,alpha,win,epsilon)
%
%   sM = lvq3(sM,sD,50*length(sM.codebook),0.05,0.2,0.3);
%
%  Input and output arguments: 
%   sM      (struct) map struct, the class information must be 
%                    present on the first column of .labels field
%   D       (struct) data struct, the class information must
%                    be present on the first column of .labels field
%   rlen    (scalar) running length
%   alpha   (scalar) learning parameter, e.g. 0.05
%   win     (scalar) window width parameter, e.g. 0.25
%   epsilon (scalar) relative learning parameter, e.g. 0.3
%
%   sM      (struct) map struct, the trained codebook
%
% NOTE: does not take mask into account.
%
% For more help, try 'type lvq3', or check out online documentation.
% See also LVQ1, SOM_SUPERVISED, SOM_SEQTRAIN.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvq3
%
% PURPOSE
%
% Trains codebook with the LVQ3 -algorithm (described below).
%
% SYNTAX
%
% sM = lvq3(sM, data, rlen, alpha, win, epsilon)
%
% DESCRIPTION
%
% Trains codebook with the LVQ3 -algorithm. Codebook contains a number
% of vectors (mi, i=1,2,...,n) and so does data (vectors xj, j=1,2,...k).
% Both vector sets are classified: vectors may have a class (classes are
% set to data- or map -structure's 'labels' -field. For each xj the two 
% closest codebookvectors mc1 and mc2 are searched (euclidean distances
% d1 and d2). xj must fall into the zone of window. That happens if:
%
%    min(d1/d2, d2/d1) > s, where s = (1-win) / (1+win).
%
% If xj belongs to the same class of one of the mc1 and mc1, codebook
% is updated as follows (let mc1 belong to the same class as xj):
%    mc1(t+1) = mc1(t) + alpha * (xj(t) - mc1(t))
%    mc2(t+1) = mc2(t) - alpha * (xj(t) - mc2(t))
% If both mc1 and mc2 belong to the same class as xj, codebook is
% updated as follows:
%    mc1(t+1) = mc1(t) + epsilon * alpha * (xj(t) - mc1(t))
%    mc2(t+1) = mc2(t) + epsilon * alpha * (xj(t) - mc2(t))
% Otherwise updating is not performed.
%
% Argument 'rlen' tells how many times training -sequence is performed.
%
% Argument 'alpha' is recommended to be smaller than 0.1 and argument
% 'epsilon' should be between 0.1 and 0.5.
%
% NOTE: does not take mask into account.
%
% REFERENCES
%
% Kohonen, T., "Self-Organizing Map", 2nd ed., Springer-Verlag, 
%    Berlin, 1995, pp. 181-182.
%
% See also LVQ_PAK from http://www.cis.hut.fi/research/som_lvq_pak.shtml
% 
% REQUIRED INPUT ARGUMENTS
%
%  sM                The data to be trained.
%          (struct)  A map struct.
%
%  data              The data to use in training.
%          (struct)  A data struct.
%
%  rlen    (integer) Running length of LVQ3 -algorithm.
%                    
%  alpha   (float)   Learning rate used in training, e.g. 0.05
%
%  win     (float)   Window length, e.g. 0.25
%  
%  epsilon (float)   Relative learning parameter, e.g. 0.3
%
% OUTPUT ARGUMENTS
%
%  sM          Trained data.
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
%  lvq1             Use LVQ1 algorithm for training.
%  som_supervised   Train SOM using supervised training.
%  som_seqtrain     Train SOM with sequential algorithm.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Parhankangas
% Copyright (c) by Juha Parhankangas
% http://www.cis.hut.fi/projects/somtoolbox/

% Juha Parhankangas 310100 juuso 020200

NOTFOUND = 1;

cod = codebook.codebook;
dat = data.data;

c_class = codebook.labels(:,1);
d_class = data.labels(:,1);

s = (1-win)/(1+win);

x = size(dat,1);
y = size(cod,2);

c_class=class2num(c_class);
d_class=class2num(d_class);

ONES=ones(size(cod,1),1);

for t=1:rlen
  fprintf('\rTraining round: %d/%d',t,rlen);
  tmp = NaN*ones(x,y);
 
  for j=1:x
    flag = 0;
    mj = 0;
    mi = 0;
    no_NaN=find(~isnan(dat(j,:)));
    di=sqrt(sum([cod(:,no_NaN) - ONES*dat(j,no_NaN)].^2,2));
    [~, ind1] = min(di);
    di(ind1)=Inf;
    [~,ind2] =  min(di);    
  
    %ind2=ind2+1;

    if d_class(j) && d_class(j)==c_class(ind1)
      mj = ind1;
      mi = ind2;
      if d_class(j)==c_class(ind2)
        flag = 1;
      end
    elseif d_class(j) && d_class(j)==c_class(ind2)
      mj = ind2;
      mi = ind1;
      if d_class(j)==c_class(ind1)
        flag = 1;
      end
    end

    if mj && mi
      if flag
        tmp([mj mi],:) = cod([mj mi],:) + epsilon*alpha*...
                       (dat([j j],:) - cod([mj mi],:));
      else
        tmp(mj,:) = cod(mj,:) + alpha * (dat(j,:)-cod(mj,:));
        tmp(mi,:) = cod(mi,:) - alpha * (dat(j,:)-cod(mj,:));
      end
    end  
  end    
  inds = find(~isnan(sum(tmp,2)));
  cod(inds,:) = tmp(inds,:);
end
fprintf(1,'\n');

sTrain = som_set('som_train','algorithm','lvq3',...
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





