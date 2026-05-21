function [C,P]=knn(d, Cp, K)

%KNN K-Nearest Neighbor classifier using an arbitrary distance matrix
%
%  [C,P]=knn(d, Cp, [K])
%
%  Input and output arguments ([]'s are optional): 
%   d     (matrix) of size NxP: This is a precalculated dissimilarity (distance matrix).
%           P is the number of prototype vectors and N is the number of data vectors
%           That is, d(i,j) is the distance between data item i and prototype j.
%   Cp    (vector) of size Px1 that contains integer class labels. Cp(j) is the class of 
%            jth prototype.
%   [K]   (scalar) the maximum K in K-NN classifier, default is 1
%   C     (matrix) of size NxK: integers indicating the class 
%           decision for data items according to the K-NN rule for each K.
%           C(i,K) is the classification for data item i using the K-NN rule
%   P     (matrix) of size NxkxK: the relative amount of prototypes of 
%           each class among the K closest prototypes for each classifiee. 
%           That is, P(i,j,K) is the relative amount of prototypes of class j 
%           among K nearest prototypes for data item i.
%
% If there is a tie between representatives of two or more classes
% among the K closest neighbors to the classifiee, the class i selected randomly 
% among these candidates.
%
% IMPORTANT  If K>1 this function uses 'sort' which is considerably slower than 
%            'max' which is used for K=1. If K>1 the knn always calculates 
%            results for all K-NN models from 1-NN up to K-NN.   
%
% EXAMPLE 1 
%
% sP;                           % a SOM Toolbox data struct containing labeled prototype vectors
% [Cp,label]=som_label2num(sP); % get integer class labels for prototype vectors                 
% sD;                           % a SOM Toolbox data struct containing vectors to be classified
% d=som_eucdist2(sD,sP);        % calculate euclidean distance matrix
% class=knn(d,Cp,10);           % classify using 1,2,...,10-rules
% class(:,5);                   % includes results for 5NN 
% label(class(:,5))             % original class labels for 5NN
%
% EXAMPLE 2 (leave-one-out-crossvalidate KNN for selection of proper K)
%
% P;                          % a data matrix of prototype vectors (rows)
% Cp;                         % column vector of integer class labels for vectors in P 
% d=som_eucdist2(P,P);        % calculate euclidean distance matrix PxP
% d(eye(size(d))==1)=NaN;     % set self-dissimilarity to NaN:
%                             % this drops the prototype itself away from its neighborhood 
%                             % leave-one-out-crossvalidation (LOOCV)
% class=knn(d,Cp,size(P,1));  % classify using all possible K
%                             % calculate and plot LOOC-validated errors for all K
% failratep = ...
%  100*sum((class~=repmat(Cp,1,size(P,1))))./size(P,1); plot(1:size(P,1),failratep) 

% See also SOM_LABEL2NUM, SOM_EUCDIST2, PDIST. 
%
% Contributed to SOM Toolbox 2.0, October 29th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta Johan 291000

%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check K 
if nargin<3 || isempty(K),
  K=1;
end

if ~vis_valuetype(K,{'1x1'})
  error('Value for K must be a scalar');
end

% Check that dist is a matrix
if ~vis_valuetype(d,{'nxm'}),
  error('Distance matrix not valid.')
end

[N_data N_proto]=size(d);

% Check class label vector: must be numerical and of integers
if ~vis_valuetype(Cp,{[N_proto 1]});
  error(['Class vector is invalid: has to be a N-of-data_rows x 1' ...
	 ' vector of integers']);
elseif sum(fix(Cp)-Cp)~=0
  error('Class labels in vector ''Cp'' must be integers.');
end

if size(d,2) ~= length(Cp),
  error('Distance matrix and prototype class vector dimensions do not match.');
end

% Check if the classes are given as labels (no class input arg.)
% if they are take them from prototype struct

% Find all class labels
ClassIndex=unique(Cp);
N_class=length(ClassIndex); % number of different classes  


%%%% Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if K==1,   % sort distances only if K>1
  
  % 1NN
  % Select the closest prototype
  [~,proto_index]=min(d,[],2); 
  C=Cp(proto_index);

else 
  
  % Sort the prototypes for each classifiee according to distance
  [~, proto_index]=sort(d);
  
  %% Select up to K closest prototypes
  proto_index=proto_index(1:K,:);
  knn_class=Cp(proto_index);
  for i=1:N_class,
    classcounter(:,:,i)=cumsum(knn_class==ClassIndex(i));
  end
  
  %% Vote between classes of K neighbors 
  [winner,vote_index]=max(classcounter,[],3);
  
  %%% Handle ties
  
  % Set index to classes that got as much votes as winner
  
  equal_to_winner=(repmat(winner,[1 1 N_class])==classcounter);
 
  % set index to ties
  [tie_indexi,tie_indexj]=find(sum(equal_to_winner,3)>1); % drop the winner from counter 
  
  % Go through tie cases and reset vote_index randomly to one
  % of them 
  
  for i=1:length(tie_indexi),
    tie_class_index=find(squeeze(equal_to_winner(tie_indexi(i),tie_indexj(i),:)));
    fortuna=randperm(length(tie_class_index));
    vote_index(tie_indexi(i),tie_indexj(i))=tie_class_index(fortuna(1));
  end
  
  C=ClassIndex(vote_index)';
end

%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relative amount of classes in K neighbors for each classifiee

if K==1,
  P=zeros(N_data,N_class);
  if nargout>1,
    for i=1:N_data,
      P(i,ClassIndex==C(i))=1;
    end
  end
else
  P=shiftdim(classcounter,1)./repmat(shiftdim(1:K,-1), [N_data N_class 1]);
end

