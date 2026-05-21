function color = som_normcolor(data, clrmap)

%SOM_NORMCOLOR RGB values of indexed colors for a given dataset and colormap 
%  
% color = som_normcolor(data, [clrmap])
%
%  color = som_normcolor(data);
%  color = som_normcolor(data,jet(64));
%
%  Input and output arguments ([]'s are optional):
%   data     (struct) map or data struct
%            (matrix) size N x dim
%   [clrmap] (matrix) size N x 3, a valid colormap (an RGB value matrix)
%                     Default is current colormap. See COLORMAP.
%
%   color    (matrix) size N x 3 x dim, RGB matrix 
%
% Purpose of this function is to calculate fixed RGB colors that are similar
% to indexed colors with the specified colormap. This is because some
% SOM Toolbox visualization functions (as SOM_GRID) do not use indexed colors 
% if the underlying Matlab function (e.g. PLOT) do not use indexed colors
%
% EXAMPLE
%
% %%% Visualize three variables in a map using som_grid:
% %%% Give coordinates for the markers according to variables 1 and 2, and 
% %%% 'indexed colors' according to variable 3. 
%
% som_grid(map.topol.lattice,map.topol.msize,'Coord',map.codebook(:,1:2), ...
%          'markercolor', som_normcolor(map.codebook(:,3)));

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% juha 150799 johan 010999

%%%% check possible errors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(1,2,nargin));

if nargin < 2 || isempty(clrmap),
  clrmap=colormap;
elseif ~vis_valuetype(clrmap,{'nx3rgb'}),
  error('The specified colormap is invalid!');
end

d=size(clrmap,1);

if isstruct(data),
  m_names={'type';'codebook';'topol';'labels';'neigh';'mask';'trainhist';...
           'name';'comp_names';'comp_norm'};
  d_names=fieldnames(vis_struct);
  if length(fieldnames(data)) ~= length(d_names)  % data is not som_data_struct
    if length(fieldnames(data)) ~= length(m_names) % and not som_map_struct 
      error('Input argument is not a ''som_vis'' or ''som_map'' struct.')
    elseif ~all(strcmp(fieldnames(data),m_names))
      error('Input argument is not a ''som_vis'' or ''som_map'' struct.')
    else
      data=data.codebook;
    end
  elseif ~all(strcmp(fieldnames(data),dnames))
    error('Input argument is not a ''som_vis'' or ''som_map'' struct.')
  else
    data=data.data;
  end
end

if ~isnumeric(data) || ndims(data) ~= 2
  error('Data is not 2 dimensional numeric matrix.');
end

%%% action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data=som_normalize(data,'range');

for i=1:size(data,2),
  inds=~isnan(data(:,i));
  color(inds,:,i)=clrmap(round(data(inds,i)*(d-1))+1,:);
  color(~inds,:,i)=NaN;
end

  






