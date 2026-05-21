function Cd = som_cldist(D,clinds1,clinds2,cldist,q,mask)

% SOM_CLDIST Distances between two clusters.
% 
%   Cd = som_cldist(Md,c1,c2,'single')
%   Cd = som_cldist(Md,c1,c2,'average')
%   Cd = som_cldist(Md,c1,c2,'complete')
%   Cd = som_cldist(Md,c1,c2,'neighf',H)
%   Cd = som_cldist(Md,c1,[],...)
%   Cd = som_cldist(D,c1,c2,'centroid',q,mask)
%   Cd = som_cldist(D,c1,c2,'ward',q,mask)
%   Cd = som_cldist(D,c1,[],...)
%
%  Input and output arguments ([]'s are optional):
%   D        (matrix) size dlen x dim, the data set
%            (struct) map or data struct
%   Md       (matrix) size dlen x dlen, mutual distance matrix, see SOM_MDIST
%   c1       (cell array) size n1 x 1, indices of clusters from which 
%                     the distances should be calculated, each cell
%                     contains indices of vectors that belong to that
%                     cluster (indices are between 1...dlen)
%   c2       (cell array) size n2 x 1, same as c1 but have the clusters
%                     to which the distances should be calculated
%            (empty)  c1 is used in place of c2
%   [q]      (scalar) distance norm, default = 2
%   [mask]   (vector) size dim x 1, the weighting mask, a vector of ones
%                     by default
%   H        (matrix) size dlen x dlen, neighborhood function values
%
%   Cd       (matrix) size n1 x n2, distances between the clusters
%
% See also SOM_MDIST. 

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/
 
% Version 2.0beta juuso 250800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dlen dim] = size(D); 
if nargin<5, q = 2; end
if nargin<6, mask = ones(dim,1); end
if ~iscell(clinds1), clinds1 = {clinds1}; end
if ~isempty(clinds2) && ~iscell(clinds2), clinds2 = {clinds2}; end

n1 = length(clinds1); 
n2 = length(clinds2); 
if n2>0, Cd = zeros(n1,n2); else Cd = zeros(n1); end
if n1==0, return; end

switch cldist, 
  
 % centroid distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 case 'centroid',  

  C1 = zeros(n1,dim); for i=1:n1, C1(i,:) = mean(D(clinds1{i},:),1); end
  C2 = zeros(n2,dim); for i=1:n2, C2(i,:) = mean(D(clinds2{i},:),1); end
  if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	diff = C1(i,:)-C1(j,:); 
	switch q, 
	 case 1,    Cd(i,j)=abs(diff)*mask;
	 case 2,    Cd(i,j)=sqrt((diff.^2)*mask);  
	 case Inf,  Cd(i,j)=max(diag(mask)*abs(diff),[],2);
	 otherwise, Cd(i,j)=((abs(diff).^q)*mask).^(1/q);
	end   
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	diff = C1(i,:)-C2(j,:); 
	switch q, 
	 case 1,    Cd(i,j)=abs(diff)*mask;
	 case 2,    Cd(i,j)=sqrt((diff.^2)*mask);  
	 case Inf,  Cd(i,j)=max(diag(mask)*abs(diff),[],2);
	 otherwise, Cd(i,j)=((abs(diff).^q)*mask).^(1/q);
	end   
      end
    end
  end

 % ward distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'ward',

  C1 = zeros(n1,dim); nn1 = zeros(n1,dim); 
  for i=1:n1, C1(i,:) = mean(D(clinds1{i},:),1); nn1(i) = length(clinds1{i}); end
  C2 = zeros(n2,dim); nn2 = zeros(n2,dim); 
  for i=1:n2, C2(i,:) = mean(D(clinds2{i},:),1); nn2(i) = length(clinds2{i}); end
  if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	diff = C1(i,:) - C1(j,:); 
	f = 2*nn1(i)*nn1(j) / (nn1(i)+nn1(j)); 
	switch q, 
	 case 1,    Cd(i,j)=f*abs(diff)*mask;
	 case 2,    Cd(i,j)=f*sqrt((diff.^2)*mask);  
	 case Inf,  Cd(i,j)=f*max(diag(mask)*abs(diff),[],2);
	 otherwise, Cd(i,j)=f*((abs(diff).^q)*mask).^(1/q);
	end   
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	diff = C1(i,:) - C2(j,:); 
	f = 2*nn1(i)*nn2(j) / (nn1(i)+nn2(j)); 
	switch q, 
	 case 1,    Cd(i,j)=f*abs(diff)*mask;
	 case 2,    Cd(i,j)=f*sqrt((diff.^2)*mask);  
	 case Inf,  Cd(i,j)=f*max(diag(mask)*abs(diff),[],2);
	 otherwise, Cd(i,j)=f*((abs(diff).^q)*mask).^(1/q);
	end   
      end
    end
  end  

 % single linkage distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'single',

  if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	vd = D(clinds1{i},clinds1{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = min(vd(fi)); else Cd(i,j) = Inf; end
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	vd = D(clinds1{i},clinds2{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = min(vd(fi)); else Cd(i,j) = Inf; end
      end
    end
  end

 % average linkage distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'average',
  
  if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	vd = D(clinds1{i},clinds1{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = mean(vd(fi)); else Cd(i,j) = Inf; end
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	vd = D(clinds1{i},clinds2{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = mean(vd(fi)); else Cd(i,j) = Inf; end
      end
    end
  end
    
 % complete linkage distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 case 'complete',
 
   if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	vd = D(clinds1{i},clinds1{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = max(vd(fi)); else Cd(i,j) = Inf; end
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	vd = D(clinds1{i},clinds2{j}); 
	fi = isfinite(vd(:));
	if any(fi), Cd(i,j) = max(vd(fi)); else Cd(i,j) = Inf; end
      end
    end
  end
 
 % neighborhood function linkage distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 case 'neighf',
  
  if n2==0, 
    for i=1:n1-1, 
      for j=i+1:n1, 
	vd = D(clinds1{i},clinds1{j}); 
	fi = isfinite(vd(:));
	if any(fi), 
	  hd = q(clinds1{i},clinds1{j}); 
	  hd = hd(fi); 
	  Cd(i,j) = sum(hd.*vd(fi))/sum(hd); 	  
	else Cd(i,j) = Inf; 
	end
      end
      Cd([(i+1):n1],i) = Cd(i,[(i+1):n1])';
    end
  else
    for i=1:n1, 
      for j=1:n2, 
	vd = D(clinds1{i},clinds2{j}); 
	fi = isfinite(vd(:));
	if any(fi), 
	  hd = q(clinds1{i},clinds2{j}); 
	  hd = hd(fi); 
	  Cd(i,j) = sum(hd.*vd(fi))/sum(hd); 	  
	else Cd(i,j) = Inf; 
	end
      end
    end
  end

 otherwise, error(['Unknown cluster distance metric: ' cldist]); 
end
  
return;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

