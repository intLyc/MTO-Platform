function H = som_neighf(sMap,radius,neigh,ntype)

%SOM_NEIGHF Return neighborhood function values.
%
% H = som_neighf(sMap,[radius],[neigh],[ntype]);
% 
%  Input and output arguments ([]'s are optional): 
%   sMap     (struct) map or topology struct
%   [radius] (scalar) neighborhood radius (by default, the last used value
%                     in sMap.trainhist is used, or 1 if that is unavailable)
%   [neigh]  (string) neighborhood function type (by default, ..., or 
%                     'gaussian' if that is unavailable)
%   [ntype]  (string) 'normal' (default), 'probability' or 'mirror'
%
%   H        (matrix) [munits x munits] neighborhood function values from 
%                     each map unit to each other map unit
%
% For more help, try 'type som_batchtrain' or check out online documentation.
% See also  SOM_MAKE, SOM_SEQTRAIN, SOM_TRAIN_STRUCT.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check arguments 

% defaults
rdefault = 1; 
ndefault = 'gaussian';
tdefault = 'normal';

% map 
switch sMap.type, 
 case 'som_map',   
   sTopol = sMap.topol; 
   sTrain = sMap.trainhist(end); 
   if isempty(sTrain.radius_fin) || isnan(sTrain.radius_fin), 
     rdefault = 1; 
   else
     rdefault = sTrain.radius_fin;
   end
   if ~isempty(sTrain.neigh) && ~isnan(sTrain.neigh), 
     ndefault = sTrain.neigh;
   end
 case 'som_topol', sTopol = sMap; 
end
munits = prod(sTopol.msize); 

% other parameters
if nargin<2 || isempty(radius), radius = rdefault; end
if nargin<3 || isempty(neigh), neigh = ndefault; end
if nargin<4 || isempty(ntype), ntype = tdefault; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize
                                   
% basic neighborhood 
Ud = som_unit_dists(sTopol);
Ud = Ud.^2;
radius = radius.^2;
if radius==0, radius = eps; end % zero neighborhood radius may cause div-by-zero error

switch ntype, 
case 'normal', 
    H = neighf(neigh,Ud,radius); 
case 'probability', 
    H = neighf(neigh,Ud,radius); 
    for i=1:munits, H(i,:) = H(i,:)/sum(H(i,:)); end
case 'mirror', % only works for 2-dim grid!!!
    H  = zeros(munits,munits);
    Co = som_unit_coords(sTopol); 
    for i=-1:1,
        for j=-1:1,
           Ud = gridmirrordist(Co,i,j);
           H  = H + neighf(neigh,Ud,radius); 
        end
    end    
end     

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function H = neighf(neigh,Ud,radius)

 switch neigh, 
 case 'bubble',   H = (Ud<=radius); 
 case 'gaussian', H = exp(-Ud/(2*radius)); 
 case 'cutgauss', H = exp(-Ud/(2*radius)) .* (Ud<=radius);
 case 'ep',       H = (1-Ud/radius) .* (Ud<=radius);
 end  
 return; 

function Ud = gridmirrordist(Co,mirrorx,mirrory)

 [munits,mdim] = size(Co); 
 if mdim>2, error('Mirrored neighborhood only works for 2-dim map grids.'); end
   
 % width and height of the grid
 dx = max(Co(:,1))-min(Co(:,1));
 dy = max(Co(:,2))-min(Co(:,2));

 % calculate distance from each location to each other location
 Ud = zeros(munits,munits);
 for i=1:munits, 
   inds = [i:munits]; 
   coi = Co(i,:); % take hexagonal shift into account
   coi(1) = coi(1)*(1-2*(mirrorx~=0)) + 2*dx*(mirrorx==1); % +mirrorx * step
   coi(2) = coi(2)*(1-2*(mirrory~=0)) + 2*dy*(mirrory==1); % +mirrory * step
   Dco = (Co(inds,:) - coi(ones(munits-i+1,1),:))'; 
   Ud(i,inds) = sqrt(sum(Dco.^2));
   Ud(inds,i) = Ud(i,inds)'; 
 end
 return; 


