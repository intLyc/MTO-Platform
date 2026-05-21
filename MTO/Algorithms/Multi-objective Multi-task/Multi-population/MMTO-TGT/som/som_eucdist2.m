function d=som_eucdist2(Data, Proto)

%SOM_EUCDIST2 Calculates matrix of squared euclidean distances between set of vectors or map, data struct
%
% d=som_eucdist2(D, P)
%
%  d=som_eucdist(sMap, sData);
%  d=som_eucdist(sData, sMap);
%  d=som_eucdist(sMap1, sMap2);
%  d=som_eucdist(datamatrix1, datamatrix2);
%
%  Input and output arguments ([]'s are optional): 
%   D (matrix) size Nxd
%     (struct) map or data struct
%   P (matrix) size Pxd
%     (struct) map or data struct
%   d (matrix) distance matrix of size NxP 
%
% IMPORTANT
%
% * Calculates _squared_ euclidean distances
% * Observe that the mask in the map struct is not taken into account while 
%   calculating the euclidean distance
%
% See also KNN, PDIST.

% Contributed to SOM Toolbox 2.0, October 29th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta Johan 291000

%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(Data);
  if isfield(Data,'type') && ischar(Data.type)
  else
    error('Invalid map/data struct?');
  end
  switch Data.type
   case 'som_map'
    data=Data.codebook;
   case 'som_data'
    data=Data.data;
  end
else
  % is already a matrix
  data=Data;
end

% Take prototype vectors from prototype struct

if isstruct(Proto),
  
  if isfield(Proto,'type') && ischar(Proto.type),
  else
    error('Invalid map/data struct?');
  end
  switch Proto.type
   case 'som_map'
    proto=Proto.codebook;
   case 'som_data'
    proto=Proto.data;
  end
else
  % is already a matrix
  proto=Proto; 
end

% Check that inputs are matrices
if ~vis_valuetype(proto,{'nxm'}) || ~vis_valuetype(data,{'nxm'}),
  error('Prototype or data input not valid.')
end

% Record data&proto sizes and check their dims 
[N_data dim_data]=size(data); 
[N_proto dim_proto]=size(proto);
if dim_proto ~= dim_data,
  error('Data and prototype vector dimension does not match.');
end

% Calculate euclidean distances between classifiees and prototypes
d=distance(data,proto);

%%%% Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d=distance(X,Y);

% Euclidean distance matrix between row vectors in X and Y

U=~isnan(Y); Y(~U)=0;
V=~isnan(X); X(~V)=0;
d=abs(X.^2*U'+V*Y'.^2-2*X*Y');
