function [P,V,me,l] = pcaproj(D,arg1,arg2)

%PCAPROJ Projects data vectors using Principal Component Analysis.
%
% [P,V,me,l] = pcaproj(D, odim)
% P =          pcaproj(D, V, me)
%
%  Input and output arguments ([]'s are optional)
%   D      (matrix) size dlen x dim, the data matrix
%          (struct) data or map struct            
%   odim   (scalar) how many principal vectors are used
%  
%   P      (matrix) size dlen x odim, the projections
%   V      (matrix) size dim x odim, principal eigenvectors (unit length)
%   me     (vector) size 1 x dim, center point of D
%   l      (vector) size 1 x odim, the corresponding eigenvalues, 
%                   relative to total sum of eigenvalues
%                   
% See also SAMMON, CCA.

% Contributed to SOM Toolbox 2.0, February 2nd, 2000 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% juuso 191297 070200

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error(nargchk(2, 3, nargin)); % check the number of input arguments

% the data
if isstruct(D), 
  if strcmp(D.type,'som_map'), D=D.codebook; else D=D.data; end
end
[dlen dim] = size(D);

if nargin==2, 

  odim = arg1;
    
  % autocorrelation matrix
  A = zeros(dim);
  me = zeros(1,dim);
  for i=1:dim, 
    me(i) = mean(D(isfinite(D(:,i)),i)); 
    D(:,i) = D(:,i) - me(i); 
  end  
  for i=1:dim, 
    for j=i:dim, 
      c = D(:,i).*D(:,j); c = c(isfinite(c));
      A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
    end
  end
  
  % eigenvectors, sort them according to eigenvalues, and normalize
  [V,S]   = eig(A);
  eigval  = diag(S);
  [~,ind] = sort(abs(eigval)); 
  eigval  = eigval(flipud(ind));
  V       = V(:,flipud(ind)); 
  for i=1:odim, V(:,i) = (V(:,i) / norm(V(:,i))); end
  
  % take only odim first eigenvectors
  V = V(:,1:odim);
  l = abs(eigval)/sum(abs(eigval));
  l = l(1:odim); 

else % nargin==3, 

  V = arg1;
  me = arg2;
  odim = size(V,2);    
  D = D-me(ones(dlen,1),:);
  
end
  
% project the data using odim first eigenvectors
P = D*V;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
