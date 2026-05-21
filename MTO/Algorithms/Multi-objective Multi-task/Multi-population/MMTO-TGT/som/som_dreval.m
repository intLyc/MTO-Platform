function [sig,cm,truex,truey] = som_dreval(sR,D,sigmea,inds1,inds2,andor)

% SOM_DREVAL Evaluate the significance of the given descriptive rule.
%
% [sig,Cm,truex,truey] = som_dreval(cR,D,sigmea,[inds1],[inds2],[andor]) 
% 
%  sR      (struct) a rule struct, or an array of rule structs
%  D       (matrix) the data, of size [dlen x nr]
%  sigmea  (string) significance measure ('accuracy','accuracyI','mutuconf'), 
%                   see definitions below
%  [inds1] (vector) indeces belonging to the group
%                   (by default: the whole data set) 
%  [inds2] (vector) indeces belonging to the contrast group
%                   (by default: the rest of the data set)
%  [andor] (string) 'and' or 'or': which conjunction operator to use
%                   to join the rules for each variable
%
%  sig     (scalar) significance of the rule
%  cm      (vector) length 4, vectorized confusion matrix ([a,c,b,d]: see below)
%  truex   (vector) binary vector indicating for each item in the 
%                   group whether it was true or not
%  truey   (vector) binary vector indicating for each item in the 
%                   contrast group whether it was true or not
%
% Descriptive rule significance is measured as the match between the 
% given groups (inds1 = G1, inds2 = G2) and the rule being true or false.
% 
%          G1    G2   
%       ---------------    accuracy  = (a+d) / (a+b+c+d)
% true  |  a  |   b   |    
%       |--------------    mutuconf  =  a*a  / ((a+b)(a+c)) 
% false |  c  |   d   | 
%       ---------------    accuracyI =   a   / (a+b+c)
%
% See also  SOM_DRSIGNIF, SOM_DRMAKE.

% Contributed to SOM Toolbox 2.0, March 4th, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 040302

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input arguments
if isstruct(D), 
  switch D.type, 
   case 'som_data', D = D.data; 
   case 'som_map',  D = D.codebook; 
  end
end
[dlen,dim] = size(D);
if nargin<4, inds1 = 1:dlen; end
if nargin<5, i = ones(dlen,1); i(inds1) = 0; inds2 = find(i); end
if nargin<6, andor = 'and'; end

% initialize
nr  = length(sR);
X   = D(inds1,:);
Y   = D(inds2,:); 
nx  = size(X,1);
ny  = size(Y,1);  
truex = ones(nx,1);
truey = ones(ny,1);

% go through the individual rules
for i=1:nr,  
  tx = (X(:,i)>=sR(i).low & X(:,i)<sR(i).high);
  tx(isnan(X(:,i))) = sR(i).nanis;     

  ty = (Y(:,i)>=sR(i).low & Y(:,i)<sR(i).high);
  ty(isnan(Y(:,i))) = sR(i).nanis;     

  switch andor, 
   case 'and', truex = (truex & tx); truey = (truey & ty);
   case 'or',  truex = (truex | tx); truey = (truey | ty);
  end    
end  

% evaluate criteria
tix = sum(truex(isfinite(truex)));
tiy = sum(truey(isfinite(truey))); 
cm  = [tix,nx-tix,tiy,ny-tiy];
sig = som_drsignif(sigmea,cm);

return; 
    

