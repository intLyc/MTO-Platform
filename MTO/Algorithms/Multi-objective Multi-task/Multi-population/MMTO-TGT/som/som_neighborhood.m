function Ne = som_neighborhood(Ne1,n)

%SOM_NEIGHBORHOOD Calculate neighborhood matrix.
%
% Ne = som_neighborhood(Ne1,n)
% 
%  Ne = som_neighborhood(Ne1);
%  Ne = som_neighborhood(som_unit_neighs(topol),2);
%
%  Input and output arguments ([]'s are optional): 
%   Ne1       (matrix, size [munits m]) a sparse matrix indicating
%                      the units in 1-neighborhood for each map unit
%   [n]       (scalar) maximum neighborhood which is calculated, default=Inf
% 
%   Ne        (matrix, size [munits munits]) neighborhood matrix,
%                      each row (and column) contains neighborhood
%                      values from the specific map unit to all other
%                      map units, or Inf if the value is unknown.
%
% For more help, try 'type som_neighborhood' or check out online documentation.
% See also SOM_UNIT_NEIGHS, SOM_UNIT_DISTS, SOM_UNIT_COORDS, SOM_CONNECTION.

%%%%%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_neighborhood
%
% PURPOSE
%
% Calculate to which neighborhood each map unit belongs to relative to
% each other map unit, given the units in 1-neighborhood of each unit.
%
% SYNTAX
%
%  Ne = som_neighborhood(Ne1);
%  Ne = som_neighborhood(Ne1,n);
%
% DESCRIPTION
%
% For each map unit, finds the minimum neighborhood to which it belongs
% to relative to each other map unit. Or, equivalently, for each map 
% unit, finds which units form its k-neighborhood, where k goes from 
% 0 to n. 
%
% The neighborhood is calculated iteratively using the reflexivity of
% neighborhood.
%     let  N1i  be the 1-neighborhood set a unit i
% and let  N11i be the set of units in the 1-neighborhood of any unit j in N1i
%     then N2i  (the 2-neighborhood set of unit i) is N11i \ N1i
%
% Consider, for example, the case of a 5x5 map. The neighborhood in case of
% 'rect' and 'hexa' lattices (and 'sheet' shape) for the unit at the
% center of the map are depicted below: 
% 
%   'rect' lattice           'hexa' lattice
%   --------------           --------------
%   4  3  2  3  4            3  2  2  2  3
%   3  2  1  2  3             2  1  1  2  3
%   2  1  0  1  2            2  1  0  1  2
%   3  2  1  2  3             2  1  1  2  3
%   4  3  2  3  4            3  2  2  2  3
% 
% Because the iterative procedure is rather slow, the neighborhoods 
% are calculated upto given maximal value. The uncalculated values
% in the returned matrix are Inf:s.
% 
% REQUIRED INPUT ARGUMENTS
% 
%  Ne1   (matrix) Each row contains 1, if the corresponding unit is adjacent 
%                 for that map unit, 0 otherwise. This can be calculated 
%                 using SOM_UNIT_NEIGHS. The matrix can be sparse.
%                 Size munits x munits.
%
% OPTIONAL INPUT ARGUMENTS
%
%  n     (scalar) Maximal neighborhood value which is calculated, 
%                 Inf by default (all neighborhoods).
%
% OUTPUT ARGUMENTS
%
%  Ne    (matrix) neighborhood values for each map unit, size is
%                 [munits, munits]. The matrix contains the minimum
%                 neighborhood of unit i, to which unit j belongs, 
%                 or Inf, if the neighborhood was bigger than n.
%
% EXAMPLES
%
%  Ne = som_neighborhood(Ne1,1);    % upto 1-neighborhood
%  Ne = som_neighborhood(Ne1,Inf);  % all neighborhoods
%  Ne = som_neighborhood(som_unit_neighs(topol),4);
%
% SEE ALSO
% 
%  som_unit_neighs   Calculate units in 1-neighborhood for each map unit.
%  som_unit_coords   Calculate grid coordinates.
%  som_unit_dists    Calculate interunit distances.
%  som_connection    Connection matrix.

% Copyright (c) 1999-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 1.0beta juuso 141097
% Version 2.0beta juuso 101199

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check arguments 

error(nargchk(1, 2, nargin));

if nargin<2, n=Inf; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

% initialize
if issparse(Ne1), Ne = full(Ne1); else Ne = Ne1; end
clear Ne1
[munits dummy] = size(Ne);
Ne(find(Ne==0)) = NaN;
for i=1:munits, Ne(i,i)=0; end

% Calculate neighborhood distance for each unit using reflexsivity
% of neighborhood: 
%   let  N1i be the 1-neighborhood set a unit i
%   then N2i is the union of all map units, belonging to the 
%        1-neighborhood of any unit j in N1i, not already in N1i
k=1; 
if n>1, 
  fprintf(1,'Calculating neighborhood: 1 '); 
  N1 = Ne; 
  N1(find(N1~=1)) = 0;   
end
while k<n && any(isnan(Ne(:))),
  k=k+1;
  fprintf(1,'%d ',k);
  for i=1:munits,
    candidates = isnan(Ne(i,:));              % units not in any neighborhood yet
    if any(candidates), 
      prevneigh = find(Ne(i,:)==k-1);         % neighborhood (k-1)
      N1_of_prevneigh = any(N1(prevneigh,:)); % union of their N1:s
      Nn = find(N1_of_prevneigh & candidates); 
      if length(Nn), Ne(i,Nn) = k; Ne(Nn,i) = k; end
    end
  end
end
if n>1, fprintf(1,'\n'); end

% finally replace all uncalculated distance values with Inf
Ne(find(isnan(Ne))) = Inf;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% faster version? 

l = size(Ne1,1); Ne1([0:l-1]*(l+1)+1) = 1; Ne = full(Ne1); M0 = Ne1; k = 2; 
while any(Ne(:)==0), M1=(M0*Ne1>0); Ne(find(M1-M0))=k; M0=M1; k=k+1; end
Ne([0:l-1]*(l+1)+1) = 0;
