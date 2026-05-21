function sig = som_drsignif(sigmea,Cm)

% SOM_DRSIGNIF Significance measure from confusion matrix between two clusters and a rule.
%
% sig = som_drsignif(sigmea,Cm)
% 
%  sigmea   (string) significance measure: 'accuracy', 
%                    'mutuconf' (default), or 'accuracyI'.
%                    (See definitions below).
%  Cn                Vectorized confusion matrix, or a matrix of such vectors.
%           (vector) [a, c, b, d] (see below)
%           (matrix) [[a1,c1,b1,d1], ..., [an,cn,bn,dn]]
%
%  sig      (vector) length=n, significance values 
%
% The confusion matrix Cm below between group (G) and contrast group (not G)
% and rule (true - false) is used to determine the significance values:
%
%          G    not G    
%       ---------------    accuracy  = (a+d) / (a+b+c+d)
% true  |  a  |   b   |    
%       |--------------    mutuconf  =  a*a  / ((a+b)(a+c)) 
% false |  c  |   d   | 
%       ---------------    accuracyI =   a   / (a+b+c)
%
% See also  SOM_DREVAL, SOM_DRMAKE.

% Contributed to SOM Toolbox 2.0, March 4th, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 040302

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

true_x     = Cm(:,1); % x     = in group
false_x    = Cm(:,2); % false = rule is false
true_y     = Cm(:,3); % true  = rule is true
false_y    = Cm(:,4); % y     = not in group

true_items = true_x + true_y; 
x_items    = true_x + false_x; 
all_items  = true_x + false_x + true_y + false_y; 
true_or_x  = x_items + true_items - true_x; 

switch sigmea, 
case 'mutuconf',
    % mutual confidence, or relevance (as defined in WSOM2001 paper)
    sig = zeros(size(true_x)); 
    i = find(true_items>0 & x_items>0); 
    sig(i) = (true_x(i).^2) ./ (true_items(i).*x_items(i)); 
case 'accuracy', 
    % accuracy 
    sig = (true_x + false_y) ./ all_items;
case 'accuracyI', 
    % accuracy such that false_y is left out of consideration
    sig = true_x./true_or_x;
otherwise, 
    error(['Unrecognized significance measures: ' sigmea]);
end 

return;
