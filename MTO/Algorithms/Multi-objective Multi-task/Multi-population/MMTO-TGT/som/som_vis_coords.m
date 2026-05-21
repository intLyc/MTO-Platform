function unit_coord=som_vis_coords(lattice, msize)

%SOM_VIS_COORDS Unit coordinates used in visualizations.
% 
% Co = som_vis_coords(lattice, msize)
%
%  Co = som_vis_coords('hexa',[10 7])
%  Co = som_vis_coords('rectU',[10 7])
%
%  Input and output arguments: 
%   lattice   (string) 'hexa', 'rect', 'hexaU' or 'rectU'
%   msize     (vector) grid size in a 1x2 vector    
%
%   Co        (matrix) Mx2 matrix of unit coordinates, where 
%               M=prod(msize) for 'hexa' and 'rect', and 
%               M=(2*msize(1)-1)*(2*msize(2)-1) for 'hexaU' and 'rectU'
%
% This function calculates the coordinates of map units on a 'sheet'
% shaped map with either 'hexa' or 'rect' lattice as used in the
% visualizations. Note that this slightly different from the
% coordinates provided by SOM_UNIT_COORDS function. 
%
% 'rectU' and 'hexaU' gives the coordinates of both units and the
% connections for u-matrix visualizations.
%
% For more help, try 'type som_vis_coords' or check out online documentation.
% See also SOM_UNIT_COORDS, SOM_UMAT, SOM_CPLANE, SOM_GRID.

%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PURPOSE 
% 
% Returns coordinates of the map units for map visualization
%
% SYNTAX
%
%  Co = som_vis_coords(lattice, msize)
%
% DESCRIPTION
%
% This function calculates the coordinates of map units in 'hexa' and
% 'rect' lattices in 'sheet' shaped map for visualization purposes. It
% differs from SOM_UNIT_COORDS in the sense that hexagonal lattice is
% calculated in a "wrong" way in order to get integer coordinates for
% the units. Another difference is that it may be used to calculate
% the coordinates of units _and_ the center points of the lines
% connecting them (edges) by using 'hexaU' or 'rectU' for lattice. 
% This property may be used for drawing u-matrices.
%
% The unit number 1 is set to (ij) coordinates (1,1)+shift
%                 2                            (2,1)+shift
%
%  ... columnwise
% 
%             n-1th                        (n1-1,n2)+shift
%             nth                            (n1,n2)+shift
%
% where grid size = [n1 n2] and shift is zero, except for 
% the even lines of 'hexa' lattice, for which it is +0.5.
%
% For 'rectU' and 'hexaU' the unit coordinates are the same and the
% coordinates for connections are set according to these. In this case
% the ordering of the coordinates is the following:
%   let
%     U  = som_umat(sMap); U=U(:); % make U a column vector
%     Uc = som_vis_coords(sMap.topol.lattice, sMap.topol.msize); 
%   now the kth row of matrix Uc, i.e. Uc(k,:), contains the coordinates 
%   for value U(k). 
%
% REQUIRED INPUT ARGUMENTS 
%
%  lattice  (string) The local topology of the units: 
%                    'hexa', 'rect', 'hexaU' or 'rectU'
%  msize    (vector) size 1x2, defining the map grid size. 
%                    Notice that only 2-dimensional grids
%                    are allowed.
%
% OUTPUT ARGUMENTS
% 
%  Co       (matrix) size Mx2, giving the coordinates for each unit.
%                    M=prod(msize) for 'hexa' and 'rect', and 
%                    M=(2*msize(1)-1)*(2*msize(2)-1) for 'hexaU' and 'rectU'
%
% FEATURES
% 
% Only 'sheet' shaped maps are considered. If coordinates for 'toroid'
% or 'cyl' topologies are required, you must use SOM_UNIT_COORDS
% instead.
%
% EXAMPLES
%
% Though this is mainly a subroutine for visualizations it may be
% used, e.g., in the following manner:
%
% % This makes a hexagonal lattice, where the units are rectangular
% % instead of hexagons.
%    som_cplane('rect',som_vis_coords('hexa',[10 7]),'none');
%
% % Let's make a map and calculate a u-matrix: 
%    sM=som_make(data,'msize',[10 7],'lattice','hexa');
%    u=som_umat(sM); u=u(:);
% % Now, these produce equivalent results:
%    som_cplane('hexaU',[10 7],u);
%    som_cplane(vis_patch('hexa')/2,som_vis_coords('hexaU',[10 7]),u);
%
% SEE ALSO
%
% som_grid         Visualization of a SOM grid
% som_cplane       Visualize a 2D component plane, u-matrix or color plane
% som_barplane     Visualize the map prototype vectors as bar diagrams
% som_plotplane    Visualize the map prototype vectors as line graphs
% som_pieplane     Visualize the map prototype vectors as pie charts
% som_unit_coords  Locations of units on the SOM grid

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 2.0beta Johan 201099 juuso 261199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~vis_valuetype(msize,{'1x2'}),
  error('msize must be a 1x2 vector.')
end

if vis_valuetype(lattice,{'string'})
  switch lattice
  case {'hexa', 'rect'}
    munits=prod(msize);
    unit_coord(:,1)=reshape(repmat((1:msize(2)),msize(1),1),1,munits)';
    unit_coord(:,2)=repmat((1:msize(1))',msize(2),1);
    if strcmp(lattice,'hexa')
      % Move even rows by .5
      d=rem(unit_coord(:,2),2) == 0;   
      unit_coord(d,1)=unit_coord(d,1)+.5;
    end
  case {'hexaU','rectU'}
    msize=2*msize-1; munits=prod(msize);
    unit_coord(:,1)=reshape(repmat((1:msize(2)),msize(1),1),1,munits)';
    unit_coord(:,2)=repmat((1:msize(1))',msize(2),1);
    if strcmp(lattice,'hexaU')
      d=rem(unit_coord(:,2),2) == 0;   
      unit_coord(d,1)=unit_coord(d,1)+.5;
      d=rem(unit_coord(:,2)+1,4) == 0; 
      unit_coord(d,1)=unit_coord(d,1)+1;
    end
    unit_coord=unit_coord/2+.5;
  otherwise
    error([ 'Unknown lattice ''' lattice '''.']);
  end
else
  error('Lattice must be a string.');
end
