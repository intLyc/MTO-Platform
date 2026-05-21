function bmu_colors=som_bmucolor(bmus, m, colors)

% SOM_BMUCOLOR Returns the colors of the bmus according to a map colorcode
%
% bmu_colors=som_bmucolor(bmus, msize, colors);
%
% INPUT ARGUMENTS ([]'s are optional)
%
% bmus   (matrix) Nx1 vector of BMU indexes
% msize  (map struct, topol struct or 1x2 vector) 
%          gives the map grid size 
% colors (matrix) colormap(s): munits x 3 x d matrix of RGB vectors
%
% OUTPUT ARGUMENTS 
%
% bmu_colors (Nx3xd matrix) color of the data point according to its BMU's 
%              color(s).
%
% Idea is to get a color for each data point that links it to its BMU. 
%
% EXAMPLE
%
% We want to show how an time series is projected  to a map. Instead of 
% a trajectory, we use 'color linking'
%
% map=som_make(multi_dim_signal); 
% bmus=som_bmu(map,multi_dim_signal);
% Colors=som_bmucolor(bmus, map, som_colorcode(map,'rgb1'));
% colorsignal(Colors, multi_dim_signal);
%
% See also SOM_COLORCODE.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0alpha Johan 170699

%% Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(3, 3, nargin))   % check no. of input args is correct

% Check map grid size

if vis_valuetype(m,{'1x2'}),
  msize=m;  
else
  [tmp,ok,tmp]=som_set(m);
  if isstruct(m) && all(ok)        % check m type
    switch m.type
    case 'som_topol'
      msize=m.msize;
      lattice=m.lattice;
    case 'som_map'
      msize=m.topol.msize;
      lattice=m.topol.lattice;
    otherwise
      error('Invalid map or topol struct.');
    end
  end
end  

if length(msize)>2
  error('Only 2D maps allowed!');
end

n=prod(msize)

% Check colorcode size

if ~vis_valuetype(colors,{'nx3xdimrgb','nx3rgb'})
  error('Colorcode matrix not valid!');
end

% Check bmu vector

if ~vis_valuetype(bmus,{'nx1'}),
  error('Need a column vector of BMU indexes!');
else
  bmus=round(bmus);
  if max(bmus) > n || min(bmus) < 1
    error('BMU indexes exeed the map size!')
  end
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bmu_c=colors(bmus,:,:);

%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


bmu_colors=squeeze(bmu_c);

