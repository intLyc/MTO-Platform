function [Err,sPropTotal,sPropMunits,sPropComps] = som_distortion3(sM,D,rad)

%SOM_DISTORTION3 Map distortion measures.
%  
% [sE,Err] = som_distortion3(sM,[D],[rad]);
% 
%  sE = som_distortion3(sM); 
%
%  Input and output arguments ([]'s are optional): 
%   sM          (struct) map struct
%   [D]         (matrix) a matrix, size dlen x dim
%               (struct) data or map struct
%                        by default the map struct is used
%   [rad]       (scalar) neighborhood radius, looked from sM.trainhist
%                        by default, or = 1 if that has no valid values
%                           
%   Err         (matrix) size munits x dim x 3
%                        distortion error elements (quantization error, 
%                        neighborhood bias, and neighborhood variance)
%                        for each map unit and component
%   sPropTotal  (struct) .n   = length of data
%                        .h   = mean neighborhood function value
%                        .err = errors
%   sPropMunits (struct) .Ni  = hits per map unit
%                        .Hi  = sum of neighborhood values for each map unit
%                        .Err = errors per map unit
%   sPropComps  (struct) .e1  = total squared distance to centroid
%                        .eq  = total squared distance to BMU
%                        .Err = errors per component
%
% See also  SOM_QUALITY.

% Contributed to SOM Toolbox 2.0, January 3rd, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 030102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% arguments

% map
[munits dim] = size(sM.codebook);

% neighborhood radius
if nargin<3, 
  if ~isempty(sM.trainhist), 
    rad = sM.trainhist(end).radius_fin; 
  else 
    rad = 1; 
  end
end
if rad<eps, rad = eps; end
if isempty(rad) || isnan(rad), rad = 1; end

% neighborhood function
Ud = som_unit_dists(sM.topol); 
switch sM.neigh, 
 case 'bubble',   H = (Ud <= rad);
 case 'gaussian', H = exp(-(Ud.^2)/(2*rad*rad)); 
 case 'cutgauss', H = exp(-(Ud.^2)/(2*rad*rad)) .* (Ud <= rad);
 case 'ep',       H = (1 - (Ud.^2)/rad) .* (Ud <= rad);
end  
Hi = sum(H,2); 

% data
if nargin<2, D = sM.codebook; end
if isstruct(D), D = D.data; end
[dlen dim] = size(D);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% quality measures

% find Voronoi sets, and calculate their properties

[bmus,qerr] = som_bmus(sM,D); 
M  = sM.codebook; 
Vn = M; 
Vm = M; 
Ni = zeros(munits,dim);
for i=1:munits, 
  inds    = find(bmus==i);   
  Ni(i,:) = sum(isfinite(D(inds,:)),1);                      % size of Voronoi set
  if any(Ni(i,:)), Vn(i,:) = centroid(D(inds,:),M(i,:)); end % centroid of Voronoi set  
  Vm(i,:) = centroid(M,M(i,:),H(i,:)');                      % centroid of neighborhood
end

HN = repmat(Hi,1,dim).*Ni; 

%% distortion

% quantization error (in each Voronoi set and for each component)

Eqx           = zeros(munits,dim); 
Dx            = (Vn(bmus,:) - D).^2; 
Dx(isnan(Dx)) = 0; 
for i = 1:dim, 
  Eqx(:,i)    = full(sum(sparse(bmus,1:dlen,Dx(:,i),munits,dlen),2)); 
end
Eqx           = repmat(Hi,1,dim).*Eqx; 
  
% bias in neighborhood (in each Voronoi set / component)

Enb = (Vn-Vm).^2;
Enb = HN.*Enb; 

% variance in neighborhood (in each Voronoi set / component)

Env = zeros(munits,dim);
for i=1:munits, Env(i,:) = H(i,:)*(M-Vm(i*ones(munits,1),:)).^2; end
Env = Ni.*Env; 

% total distortion (in each Voronoi set / component)

Ed = Eqx + Enb + Env;

%% other error measures

% squared quantization error (to data centroid)

me            = centroid(D,mean(M));
Dx            = D - me(ones(dlen,1),:); 
Dx(isnan(Dx)) = 0; 
e1            = sum(Dx.^2,1); 

% squared quantization error (to map units)

Dx            = D - M(bmus,:);
Dx(isnan(Dx)) = 0; 
eq            = sum(Dx.^2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% output

% distortion error matrix

Err  = zeros(munits,dim,5); 
Err(:,:,1) = Eqx; 
Err(:,:,2) = Enb; 
Err(:,:,3) = Env; 

% total errors

sPropTotal = struct('n',sum(Ni),'h',mean(Hi),'e1',sum(e1),'err',sum(sum(Err,2),1));

% properties of map units

sPropMunits = struct('Ni',[],'Hi',[],'Err',[]); 
sPropMunits.Ni  = Ni; 
sPropMunits.Hi  = Hi; 
sPropMunits.Err = squeeze(sum(Err,2));

% properties of components

sPropComps = struct('Err',[],'e1',[],'eq',[]);
sPropComps.Err = squeeze(sum(Err,1));
sPropComps.e1  = e1; 
sPropComps.eq  = eq;


return; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% subfunctions

function v = centroid(D,default,weights)
  
  [n dim] = size(D);
  I       = sparse(isnan(D));
  D(I)    = 0;
  
  if nargin==3, 
    W    = weights(:,ones(1,dim)); 
    W(I) = 0; 
    D    = D.*W;
    nn   = sum(W,1);
  else
    nn   = n-sum(I,1);
  end 

  c    = sum(D,1);
  v    = default; 
  i    = find(nn>0); 
  v(i) = c(i)./nn(i);
      
  return; 


function vis

  figure
  som_show(sM,'color',{Hi,'Hi'},'color',{Ni,'hits'},...
           'color',{Ed,'distortion'},'color',{Eqx,'qxerror'},...
           'color',{Enb,'N-bias'},'color',{Env,'N-Var'});

  ed = Eqx + Enb + Env;
  i = find(ed>0); 
  eqx = 0*ed; eqx(i) = Eqx(i)./ed(i);
  enb = 0*ed; enb(i) = Enb(i)./ed(i);
  env = 0*ed; env(i) = Env(i)./ed(i);

  figure
  som_show(sM,'color',Hi,'color',Ni,'color',Ed,...
           'color',eqx,'color',enb,'color',env); 


