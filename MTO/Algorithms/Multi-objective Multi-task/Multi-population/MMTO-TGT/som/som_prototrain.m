function [sM,sTrain] = som_prototrain(sM, D)

%SOM_PROTOTRAIN  Use sequential algorithm to train the Self-Organizing Map.
%
% [sM,sT] = som_prototrain(sM, D)
% 
%  sM = som_prototrain(sM,D);
%
%  Input and output arguments: 
%   sM      (struct) map struct, the trained and updated map is returned
%           (matrix) codebook matrix of a self-organizing map
%                    size munits x dim or  msize(1) x ... x msize(k) x dim
%                    The trained map codebook is returned.
%   D       (struct) training data; data struct
%           (matrix) training data, size dlen x dim
%
% This function is otherwise just like SOM_SEQTRAIN except that
% the implementation of the sequential training algorithm is very 
% straightforward (and slower). This should make it easy for you 
% to modify the algorithm, if you want to. 
%
% For help on input and output parameters, try 
% 'type som_prototrain' or check out the help for SOM_SEQTRAIN.
% See also SOM_SEQTRAIN, SOM_BATCHTRAIN.

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 080200 130300
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check input arguments

% map 
struct_mode = isstruct(sM);
if struct_mode, 
  M = sM.codebook; 
  sTopol = sM.topol; 
  mask = sM.mask; 
  msize = sTopol.msize;
  neigh = sM.neigh;
else  
  M = sM; orig_size = size(M);
  if ndims(sM) > 2, 
    si = size(sM); dim = si(end); msize = si(1:end-1);
    M = reshape(sM,[prod(msize) dim]);
  else
    msize = [orig_size(1) 1]; dim = orig_size(2);
  end
  sM = som_map_struct(dim,'msize',msize); sTopol = sM.topol;
  mask = ones(dim,1);
  neigh = 'gaussian';
end
[munits dim] = size(M); 

% data
if isstruct(D), data_name = D.name; D = D.data; 
else data_name = inputname(2); 
end
D = D(find(sum(isnan(D),2) < dim),:); % remove empty vectors from the data
[dlen ddim] = size(D);                % check input dimension
if dim ~= ddim, error('Map and data input space dimensions disagree.'); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize (these are default values, change as you will)

% training length
trainlen = 20*dlen; % 20 epochs by default

% neighborhood radius
radius_type = 'linear';
rini = max(msize)/2;
rfin = 1;

% learning rate
alpha_type = 'inv'; 
alpha_ini = 0.2;

% initialize random number generator
rand('state',sum(100*clock));

% tracking 
start = clock; trackstep = 100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

Ud = som_unit_dists(sTopol); % distance between map units on the grid
mu_x_1 = ones(munits,1);     % this is used pretty often

for t = 1:trainlen, 

  %% find BMU
  ind = ceil(dlen*rand(1)+eps);       % select one vector
  x = D(ind,:);                       % pick it up
  known = ~isnan(x);                  % its known components
  Dx = M(:,known) - x(mu_x_1,known);  % each map unit minus the vector
  dist2 = (Dx.^2)*mask(known);        % squared distances  
  [qerr bmu] = min(dist2);            % find BMU

  %% neighborhood  
  switch radius_type, % radius
   case 'linear', r = rini+(rfin-rini)*(t-1)/(trainlen-1);
  end
  if ~r, r=eps; end % zero neighborhood radius may cause div-by-zero error  
  switch neigh, % neighborhood function 
  case 'bubble',   h = (Ud(:,bmu) <= r);
  case 'gaussian', h = exp(-(Ud(:,bmu).^2)/(2*r*r)); 
  case 'cutgauss', h = exp(-(Ud(:,bmu).^2)/(2*r*r)) .* (Ud(:,bmu) <= r);
  case 'ep',       h = (1 - (Ud(:,bmu).^2)/(r*r)) .* (Ud(:,bmu) <= r);
  end  

  %% learning rate
  switch alpha_type,
   case 'linear', a = (1-t/trainlen)*alpha_ini;
   case 'inv',    a = alpha_ini / (1 + 99*(t-1)/(trainlen-1));
   case 'power',  a = alpha_ini * (0.005/alpha_ini)^((t-1)/trainlen); 
  end
  
  %% update
  M(:,known) = M(:,known) - a*h(:,ones(sum(known),1)).*Dx;
			 
  %% tracking
  if t==1 || ~rem(t,trackstep),
    elap_t = etime(clock,start); tot_t = elap_t*trainlen/t; 
    % fprintf(1,'\rTraining: %3.0f/ %3.0f s',elap_t,tot_t)
  end
  
end; % for t = 1:trainlen
fprintf(1,'\n');

% outputs
sTrain = som_set('som_train','algorithm','proto',...
		 'data_name',data_name,...
		 'neigh',neigh,...
		 'mask',mask,...
		 'radius_ini',rini,...
		 'radius_fin',rfin,...
		 'alpha_ini',alpha_ini,...
		 'alpha_type',alpha_type,...
		 'trainlen',trainlen,...
		 'time',datestr(now,0));

if struct_mode, 
  sM = som_set(sM,'codebook',M,'mask',mask,'neigh',neigh);
  sM.trainhist(end+1) = sTrain;
else
  sM = reshape(M,orig_size);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




