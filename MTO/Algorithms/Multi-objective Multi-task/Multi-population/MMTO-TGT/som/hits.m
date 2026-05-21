function [hits,ninvalid] = hits(bmus, mmax, values)

%HITS Calculate number of occurances of each value.
%
% hits = hits(bmus,[mmax],[values])
%
%   h = hits(bmus);
%   h = hits(bmus,length(sM.codebook)); 
%
%  Input and output arguments ([]'s are optional): 
%   bmus     (vector) BMU indeces (or other similar) 
%   [mmax]   (scalar) maximum index, default value max(bmus)
%            (struct) map or topology struct from where the maximum
%                     index is acquired
%   [values] (vector) values associated with the data (default = 1)
%
%   hits     (vector) the number of occurances of each index
%                     (or if values are given, their sum for each index)
%   ninvalid (scalar) number of invalid indeces (NaN, Inf or 
%                     <=0 or > mmax)
%
% See also SOM_HITS, SOM_BMUS.    

% Copyright (c) 2002 by the SOM toolbox programming team.
% Contributed to SOM Toolbox by Juha Vesanto, April 24th, 2002
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 240402

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2 || isempty(mmax), 
  mmax = max(bmus);
elseif isstruct(mmax), 
  switch mmax.type, 
   case 'som_map',   mmax = prod(mmax.topol.msize);
   case 'som_topol', mmax = prod(mmax.msize);
   otherwise, 
    error('Illegal struct for 2nd argument.')
  end
end

if nargin<3, values = 1; end

valid_bmus = find(isfinite(bmus) & bmus>0 & bmus<=mmax); 
ninvalid = length(bmus)-length(valid_bmus); 

bmus = bmus(valid_bmus); 
if length(values)>length(bmus), values = values(valid_bmus); end
hits = full(sum(sparse(bmus,1:length(bmus),values,mmax,length(bmus)),2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

