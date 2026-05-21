function Ne = som_neighbors(sM,k)

% Ne = som_neighbors(sM,neigh)
%
% sM      (struct) map or data struct
%         (matrix) data matrix, size n x dim
% [neigh] (string) 'kNN' or 'Nk' (which is valid for a SOM only)
%                  for example '6NN' or 'N1'
%                  default is '10NN' for a data set and 'N1' for SOM
%
% Ne      (matrix) size n x n, a sparse matrix
%                  indicating the neighbors of each sample by value 1 
%                  (note: the unit itself also has value 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(sM), 
  switch sM.type, 
   case 'som_map',  M = sM.codebook; 
   case 'som_data', M = sM.data; sM = []; 
  end
else
  M = sM; 
  sM = []; 
end

n = size(M,1);


  
  kmus = som_bmus(M,M,1:k);
  Ne = sparse(n,n);
  for i=1:n, Ne(i,kmus(i,:)) = 1; end

%Ne([0:n-1]*n+[1:n]) = 0; % remove self from neighbors

return;