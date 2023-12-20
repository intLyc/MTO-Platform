function [Xnew, model] = ftProc_pca_tr(X, Y, param)
%ftProc_pca_tr Training Principal Component Analysis (PCA).
%	[Xnew, model] = ftProc_pca_tr(X,Y,param)
%	X: a matrix, each sample is a row. Y is useless.
% 	XNEW is a matrix, each row is the PCA feature of a sample in X.
%	MODEL is the struct containing coefficients of PCA.
%	PARAM is a struct of the parameters for PCA, it can contain:
%		pcaCoef: if 0, extract all principal components;
%			elseif integer, extract pcaCoef PCs;
%			else >0 and <1, extract PC with energy ratio of pcaCoef. Default 0.

%	Copyright 2015 Ke YAN, Tsinghua Univ. http://yanke23.tk, xjed09@gmail.com

pcaCoef = 0;

defParam

[nSmp, nFt] = size(X);
mu = mean(X, 1);
% for p = 1:train_num % dealing with out of memory error
% 	ft(:,p) = ft(:,p)-mu_total0;
% end
X = bsxfun(@minus, X, mu);

% select the faster way to do PCA
if nFt > nSmp
    [V1, D1] = eig(X * X' / (nFt - 1));
else
    [V1, D1] = eig(X' * X / (nFt - 1));
end
D1 = diag(D1);
[evs, I] = sort(D1, 'descend');
V1 = V1(:, I);

D1 = cumsum(evs);
D1 = D1 / D1(end);
% calculate the dimension of the data after PCA projection
if pcaCoef == 0
    postPcaDim = min(nSmp, nFt);
elseif pcaCoef > 0 && pcaCoef < 1
    pcaRate = pcaCoef;
    postPcaDim = nnz(D1 < pcaRate) + 1;
elseif pcaCoef >= 1 && floor(pcaCoef) == pcaCoef
    postPcaDim = pcaCoef;
end

V1 = V1(:, 1:postPcaDim);
if nFt > nSmp
    W_prj = X' * V1; % W_pca: nFt-by-postPcaDim
else
    W_prj = V1;
end
W_prj = bsxfun(@rdivide, W_prj, sqrt(sum(W_prj.^2, 1)));
clear V1

% Enforce a sign convention on the coefficients - the largest element in each
% column will have a positive sign. -- borrowed from princomp
[~, maxind] = max(abs(W_prj), [], 1);
colsign = sign(W_prj(maxind + (0:nFt:(postPcaDim - 1) * nFt)));
W_prj = W_prj .* repmat(colsign, nFt, 1);

% project X to PCA subspace
Xnew = X * W_prj;

model.mu = mu;
model.W_prj = W_prj;
model.eigVals = evs;
model.postPcaDim = postPcaDim;
model.param = param;

end
