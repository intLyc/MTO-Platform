function sD = som_fillnans(sD,sM,bmus)

% SOM_FILLNANS Replaces NaNs in the data matrix with values from
%              SOM prototypes. 
%
%   sD = som_fillnans(sD,sM, [bmus])
%
%      sD      (struct) data struct
%              (matrix) size dlen x dim
%      sM      (struct) data struct, with .data of size dlen x dim
%              (matrix) size dlen x dim, a matrix from which 
%                       the values are taken from directly
%              (struct) map struct: replacement values are taken from 
%                       sM.codebook(bmus,:)
%      [bmus]  (vector) BMU for each data vector (calculated if not specified)
%
% See also  SOM_MAKE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(sD), 
  [dlen dim] = size(sD.data); 
  nans = find(isnan(sD.data)); 
else
  [dlen dim] = size(sD); 
  nans = find(isnan(sD)); 
end

if nargin<3, 
  bmus = som_bmus(sM,sD);   
end

if isstruct(sM) && strcmp(sM.type,'som_map'),
  sM = sM.codebook(bmus,:); 
elseif isstruct(sM), 
  sM = sM.data(bmus,:);   
else
  sM = sM(bmus,:);
end
me = mean(sM); 

if any(size(sM) ~= [dlen dim]), 
  error('Invalid input arguments.')
end

if isstruct(sD), 
  sD.data(nans) = sM(nans); 
else
  sD(nans) = sM(nans); 
end
  
return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


