function color=som_clustercolor(m, class, colorcode)

% SOM_CLUSTERCOLOR Sets map unit coloring according to classification
%
% syntax 1: color = som_clustercolor(m, class, [colorcode]) 
% syntax 2: color = som_clustercolor(class, colormatrix)
%
%  Input and output arguments ([]'s are optional):
%   m           (struct) map or topol struct
%               (cell array) of form {str,[m1 m2]} where str = 'hexa'
%                  or 'rect' and [m1 m2] = msize.
%   class       (matrix) Mxn matrix of integers (class labels)
%                  where M is the number of map units and each
%                  column gives some classification for the units. 
%   colorcode   (string) 'rgb1', 'rgb2' (default), 'rgb3', 'rgb4', 'hsv'.
%   colormatrix (matrix) Mx3 matrix of RGB triplets giving the
%                  initial color code for each unit.
%   color       (matrix) size Mx3xn of RGB triplets giving the
%                  resulting color code for each unit 
%    
% The function gives a color coding by class and location for the
% map units. The color is determined by calculating the mean of the 
% initial RGB values of units belonging to the same class. 
% 
% Function has two syntaxes: 
% 
% * If first argument gives the map topology, i.e. is map or topol struct
% or cell indicating the topology, the initial color coding of the
% units may be given by a string ('rgb1','rgb2','rgb3','rgb4', or 'hsv')
% which describe a predefined coloring scheme. (see SOM_COLORCODE).
% or an initial color matrix of size Mx3 with RGB triplets as rows.  
% * Another possibility is to give just the classification vector
% of size Mx1 and an initial color matrix of size Mx3 with RGB 
% triplets as rows.  
%
% EXAMPLE (requires Matlab Statistics Toolbox)
%
% % Do a 10-cluster single linkage hierachical clustering for SOM units
%    class=cluster(linkage(pdist(sM.codebook),'single'),10);
% % Color code the clusters 
%    C=som_clustercolor(sM, class, 'rgb2');
% % Visualize
%    som_show(sM,'color',C);
%
% See also SOM_COLORCODE, SOM_KMEANSCOLOR, SOM_CPLANE, SOM_SHOW

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta Johan 100200 

%%% Check arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(2, 3, nargin));   % check no. of input args is correct

% Check 1s argument 

% Class matrix?
if vis_valuetype(m, {'nxm'});
   colorcode=class; 
   class=m;
   if ~vis_valuetype(colorcode,{'nx3rgb',[size(class,1) 3]},'all'),
      error(['If map or topol is not specified the colorcode must be a' ...
            ' [size(class,1) 3] sized RGB matrix.']);
   end
else
   [tmp,ok,tmp]=som_set(m);
   if isstruct(m) && all(ok)
      switch m.type
      case 'som_topol'              % topol? 
         msize=m.msize;
         lattice=m.lattice;
      case 'som_map'   
         msize=m.topol.msize;         % map?
         lattice=m.topol.lattice;
      otherwise
         error('Invalid map or topol struct.');
      end
      % cell?  
   elseif iscell(m) && vis_valuetype(size(m),{[1 2]}),
      if vis_valuetype(m{2},{[1 2]}) && vis_valuetype(m{1},{'string'}),
         lattice=m{1};    
         msize=m{2}; 
      else
         error('Invalid map size information.');
      end
   else
      % not known type
      error('Invalid first argument!');
   end
   % Check map parameters
   switch lattice                   % lattice  
   case 'hexa' 
   case 'rect'
   otherwise
      error('Unknown lattice type');
   end
   if length(msize)>2               % dimension
      error('Only 2D maps allowed!');
   end
   % Check colorcode
   if nargin<3 || isempty(colorcode)
      colorcode='rgb2';
   end
end

% Check class
if any(class~=round(class))
   error('Class labels must be integer numbers.');
end

if min(class)<=0 
   error('Class numbers should be greater than 0');
end

if ischar(colorcode),
   switch colorcode
   case{'rgb1','rgb2','rgb3','rgb4','hsv'}
      colorcode=som_colorcode(m, colorcode);
   otherwise
      error(['Color code not known: should be ''rgb1'',''rgb2'',' ...
            ' ''rgb3'',''rgb4'' or ''hsv''.']);
   end
elseif ~vis_valuetype(colorcode,{'nx3rgb',[size(class,1) 3]},'all');
   error(['Invalid colorcode matrix: should be a ' ...
         '[length(class) 3] sized RGB matrix.']);
end

%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through all i classifications (columns)
for i=1:size(class,2), 
   % Get unique class labels in ith classification
   c=unique(class(:,i))'; % row vector for loop indexing
   % Go through all class in ith classification    
   for j=c;             
      index=(class(:,i)==j); 
      N=sum(index);
      colors=colorcode(index,:);
      % Calculate the mean color
      meancolor=repmat(mean(colors,1),N,1);
      % Select the original color that is closest to this mean
      dist=sum((meancolor-colors).^2,2);
      [tmp,min_dist_index]=min(dist);
      best_color=repmat(colors(min_dist_index,:),N,1);
      % Set the color to output variable
      color(index,:,i)=best_color;
   end
end
