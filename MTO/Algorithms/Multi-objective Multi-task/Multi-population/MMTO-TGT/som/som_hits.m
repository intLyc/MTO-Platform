function [hits] = som_hits(sMap, sData, mode)

%SOM_HITS Calculate the response of the given data on the map.
%
% hits = som_hits(sMap, sData, [mode])
%
%   h = som_hits(sMap,sData);
%   h = som_hits(sMap,sData,'fuzzy');
%
%  Input and output arguments ([]'s are optional): 
%   sMap     (struct) map struct
%            (matrix) codebook matrix, size munits x dim
%   sData    (struct) data struct
%            (matrix) data matrix, size dlen x dim
%   [mode]   (string) 'crisp' (default), 'kernel', 'fuzzy'
%
%   hits     (vector) the number of hits in each map unit, length = munits
%
% The response of the data on the map can be calculated e.g. in
% three ways, selected with the mode argument: 
%  'crisp'    traditional hit histogram
%  'kernel'   a sum of dlen neighborhood kernels, where kernel
%             is positioned on the BMU of each data sample. The 
%             neighborhood function is sMap.neigh and the
%             neighborhood width is sMap.trainhist(end).radius_fin
%             or 1 if this is empty or NaN
%  'fuzzy'    fuzzy response calculated by summing 1./(1+(q/a)^2)
%             for each data sample, where q is a vector containing
%             distance from the data sample to each map unit and 
%             a is average quantization error
% 
% For more help, try 'type som_hits' or check out online documentation.
% See also SOM_AUTOLABEL, SOM_BMUS.    

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_hits
%
% PURPOSE
%
% Calculate the response of the given data on the map.
%
% SYNTAX
%
%  hits = som_hits(sMap, sData)
%  hits = som_hits(M, D)
%  hits = som_hits(..., mode)
%
% DESCRIPTION
%
% Returns a vector indicating the response of the map to the data.
% The response of the data on the map can be calculated e.g. in
% three ways, selected with the mode argument: 
%  'crisp'    traditional hit histogram: how many times each map unit 
%             was the BMU for the data set
%  'kernel'   a sum of neighborhood kernels, where a kernel
%             is positioned on the BMU of each data sample. The 
%             neighborhood function is sMap.neigh and the
%             neighborhood width is sMap.trainhist(end).radius_fin
%             or 1 if this is not available 
%  'fuzzy'    fuzzy response calculated by summing 
%
%                            1
%                       ------------
%                       1 +  (q/a)^2
%
%             for each data sample, where q is a vector containing
%             distance from the data sample to each map unit and 
%             a is average quantization error
%
% REQUIRED INPUT ARGUMENTS
%
%   sMap              The vectors from among which the BMUs are searched
%                     for. These must not have any unknown components (NaNs).
%            (struct) map struct
%            (matrix) codebook matrix, size munits x dim
%                     
%   sData             The data vector(s) for which the BMUs are searched.
%            (struct) data struct
%            (matrix) data matrix, size dlen x dim
%
% OPTIONAL INPUT ARGUMENTS
%
%   mode     (string) The respond mode: 'crisp' (default), 'kernel'
%                     or 'fuzzy'. 'kernel' can only be used if 
%                     the first argument (sMap) is a map struct.                     
% 
% OUTPUT ARGUMENTS
% 
%   hits     (vector) The number of hits in each map unit.
%
% EXAMPLES
%
%  hits = som_hits(sM,D);
%  hits = som_hits(sM,D,'kernel');
%  hits = som_hits(sM,D,'fuzzy');
%
% SEE ALSO
% 
%  som_bmus      Find BMUs and quantization errors for a given data set.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 220997
% Version 2.0beta juuso 161199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

error(nargchk(2, 3, nargin));  % check no. of input args is correct

if isstruct(sMap), 
  switch sMap.type, 
   case 'som_map', munits = prod(sMap.topol.msize);
   case 'som_data', munits = size(sMap.data,1);
   otherwise, 
    error('Illegal struct for 1st argument.')
  end
else 
  munits = size(sMap,1); 
end
hits = zeros(munits,1);

if nargin<3, mode = 'crisp'; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% calculate BMUs
[bmus,qerrs] = som_bmus(sMap,sData,1);

switch mode, 
case 'crisp',    

 % for each unit, check how many hits it got
 for i=1:munits, hits(i) = sum(bmus == i); end
   
case 'kernel',

 % check that sMap really is a map 
 if ~isstruct(sMap) && ~strcmp(sMap.type,'som_map'), 
   error('Kernel mode can only be used for maps.');
 end	   

 % calculate neighborhood kernel  
 Ud = som_unit_dists(sMap.topol).^2;
 sTrain = sMap.trainhist(end); 
 if ~isempty(sTrain), 
   rad = sTrain.radius_fin; 
   if isempty(rad) || isnan(rad), rad = 1; end 
 else 
   rad = 1; 
 end    
 rad = rad^2;
 if rad==0, rad = eps; end % to avoid divide-by-0 errors
 switch sTrain.neigh, 
  case 'bubble',   H = (Ud<=rad); 
  case 'gaussian', H = exp(-Ud/(2*rad)); 
  case 'cutgauss', H = exp(-Ud/(2*rad)) .* (Ud<=rad);
  case 'ep',       H = (1-Ud/rad) .* (Ud<=rad);
 end
 
 % weight hits with neighborhood kernel
 hits = sum(H(bmus,:),1)';
   
case 'fuzzy',	

 % extract the two matrices (M, D) and the mask
 mask = [];
 if isstruct(sMap), 
   if strcmp(sMap.type,'som_data'), M = sMap.data; 
   else M = sMap.codebook; mask = sMap.mask;
   end
 else M = sMap;
 end
 if any(isnan(M(:))), 
   error('Data in first argument must not have any NaNs.'); 
 end

 if isstruct(sData), 
   switch sData.type, 
    case 'som_map', 
     D = sData.codebook; 
     if isempty(mask), mask = sData.mask; end
    case 'som_data', D = sData.data;
    otherwise, error('Illegal 2nd argument.');
   end	
 else D = sData;
 end
 [dlen dim] = size(D);   
 if isempty(mask), mask = ones(dim,1); end

 % scaling factor   
 a = mean(qerrs).^2;
 
 % calculate distances & bmus
 % (this is better explained in som_batchtrain and som_bmus)
 Known = ~isnan(D); D(find(~Known)) = 0; % unknown components  
 blen = min(munits,dlen); % block size 
 W1 = mask*ones(1,blen); W2 = ones(munits,1)*mask'; D = D'; Known = Known';
 i0 = 0; 
 while i0+1<=dlen,    
   inds = [(i0+1):min(dlen,i0+blen)]; i0 = i0+blen; % indeces   
   Dist = (M.^2)*(W1(:,1:length(inds)).*Known(:,inds)) ...
	  + W2*(D(:,inds).^2) ...
	  - 2*M*diag(mask)*D(:,inds); % squared distances
   hits = hits + sum(1./(1+Dist/a),2);   
 end  
 
 otherwise, 
  error(['Unknown mode: ' mode]);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

