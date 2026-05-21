function [Class,P]=knn_old(Data, Proto, proto_class, K)

%KNN_OLD A K-nearest neighbor classifier using Euclidean distance 
%
% [Class,P]=knn_old(Data, Proto, proto_class, K)
%
%  [sM_class,P]=knn_old(sM, sData, [], 3);
%  [sD_class,P]=knn_old(sD, sM, class);
%  [class,P]=knn_old(data, proto, class);
%  [class,P]=knn_old(sData, sM, class,5);
%
%  Input and output arguments ([]'s are optional): 
%   Data   (matrix) size Nxd, vectors to be classified (=classifiees)
%          (struct) map or data struct: map codebook vectors or
%                   data vectors are considered as classifiees.
%   Proto  (matrix) size Mxd, prototype vector matrix (=prototypes)
%          (struct) map or data struct: map codebook vectors or
%                   data vectors are considered as prototypes.
%   [proto_class] (vector) size Nx1, integers 1,2,...,k indicating the
%                   classes of corresponding protoptypes, default: see the 
%                   explanation below. 
%   [K]    (scalar) the K in KNN classifier, default is 1
% 
%   Class  (matrix) size Nx1, vector of 1,2, ..., k indicating the class 
%                   desicion according to the KNN rule
%   P      (matrix) size Nxk, the relative amount of prototypes of 
%                   each class among the K closest prototypes for
%                   each classifiee.
%
% If 'proto_class' is _not_ given, 'Proto' _must_ be a labeled SOM
% Toolbox struct. The label of the data vector or the first label of
% the map model vector is considered as class label for th prototype
% vector. In this case the output 'Class' is a copy of 'Data' (map or
% data struct) relabeled according to the classification.  If input
% argument 'proto_class' _is_ given, the output argument 'Class' is
% _always_ a vector of integers 1,2,...,k indiacating the class.
%
% If there is a tie between representatives of two or more classes
% among the K closest neighbors to the classifiee, the class is
% selected randomly among these candidates.
%
% IMPORTANT
% 
% ** Even if prototype vectors are given in a map struct the mask _is not 
%    taken into account_ when calculating Euclidean distance
% ** The function calculates the total distance matrix between all
%    classifiees and prototype vectors. This results to an MxN matrix; 
%    if N is high it is recommended to divide the matrix 'Data'
%    (the classifiees) into smaller sets in order to avoid memory
%    overflow or swapping. Also, if K>1 this function uses 'sort' which is
%    considerably slower than 'max' which is used for K==1.
%
% See also KNN, SOM_LABEL, SOM_AUTOLABEL

% Contributed to SOM Toolbox 2.0, February 11th, 2000 by Johan Himberg
% Copyright (c) by Johan Himberg
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta Johan 040200

%% Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This must exist later
classnames='';

% Check K 
if nargin<4 || isempty(K),
  K=1;
end

if ~vis_valuetype(K,{'1x1'})
  error('Value for K must be a scalar.');
end

% Take data from data or map struct

if isstruct(Data);
  if isfield(Data,'type') && ischar(Data.type),
  else
    error('Invalid map/data struct?');
  end
  switch Data.type
   case 'som_map'
    data=Data.codebook;
   case 'som_data'
    data=Data.data;
  end
else
  % is already a matrix
  data=Data;
end

% Take prototype vectors from prototype struct

if isstruct(Proto),
  
  if isfield(Proto,'type') && ischar(Proto.type),
  else
    error('Invalid map/data struct?');
  end
  switch Proto.type
   case 'som_map'
    proto=Proto.codebook;
   case 'som_data'
    proto=Proto.data;
  end
else
  % is already a matrix
  proto=Proto; 
end

% Check that inputs are matrices
if ~vis_valuetype(proto,{'nxm'}) || ~vis_valuetype(data,{'nxm'}),
  error('Prototype or data input not valid.')
end

% Record data&proto sizes and check their dims 
[N_data dim_data]=size(data); 
[N_proto dim_proto]=size(proto);
if dim_proto ~= dim_data,
  error('Data and prototype vector dimension does not match.');
end

% Check if the classes are given as labels (no class input arg.)
% if they are take them from prototype struct

if nargin<3 || isempty(proto_class)
  if ~isstruct(Proto)
    error(['If prototypes are not in labeled map or data struct' ...
	   'class must be given.']);  
    % transform to interger (numerical) class labels
  else
    [proto_class,classnames]=class2num(Proto.labels); 
  end
end

% Check class label vector: must be numerical and of integers
if ~vis_valuetype(proto_class,{[N_proto 1]});
  error(['Class vector is invalid: has to be a N-of-data_rows x 1' ...
	 ' vector of integers']);
elseif sum(fix(proto_class)-proto_class)~=0
  error('Class labels in vector ''Class'' must be integers.');
end

% Find all class labels
ClassIndex=unique(proto_class);
N_class=length(ClassIndex); % number of different classes  

% Calculate euclidean distances between classifiees and prototypes
d=distance(proto,data);

%%%% Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if K==1,   % sort distances only if K>1
  
  % 1NN
  % Select the closest prototype
  [~,proto_index]=min(d);
  class=proto_class(proto_index);

else 
  
  % Sort the prototypes for each classifiee according to distance
  [~,proto_index]=sort(d);
  
  %% Select K closest prototypes
  proto_index=proto_index(1:K,:);
  knn_class=proto_class(proto_index);
  for i=1:N_class,
    classcounter(i,:)=sum(knn_class==ClassIndex(i));
  end
  
  %% Vote between classes of K neighbors 
  [winner,vote_index]=max(classcounter);
  
  %% Handle ties
  
  % set index to clases that got as amuch votes as winner
  
  equal_to_winner=(repmat(winner,N_class,1)==classcounter);
  
  % set index to ties
  tie_index=find(sum(equal_to_winner)>1); % drop the winner from counter 
  
  % Go through equal classes and reset vote_index randomly to one
  % of them 
  
  for i=1:length(tie_index),
    tie_class_index=find(equal_to_winner(:,tie_index(i)));
    fortuna=randperm(length(tie_class_index));
    vote_index(tie_index(i))=tie_class_index(fortuna(1));
  end
  
  class=ClassIndex(vote_index);
end

%% Build output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relative amount of classes in K neighbors for each classifiee

if K==1,
  P=zeros(N_data,N_class);
  if nargout>1,
    for i=1:N_data,
      P(i,ClassIndex==class(i))=1;
    end
  end
else
  P=classcounter'./K;
end

% xMake class names to struct if they exist
if ~isempty(classnames),
  Class=Data;
  for i=1:N_data,
    Class.labels{i,1}=classnames{class(i)};
  end
else
  Class=class;
end


%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

function [nos,names] = class2num(class)

% Change string labels in map/data struct to integer numbers

names = {};
nos = zeros(length(class),1);
for i=1:length(class)
  if ~isempty(class{i}) && ~any(strcmp(class{i},names))
    names=cat(1,names,class(i));
  end
end

tmp_nos = (1:length(names))';
for i=1:length(class)
  if ~isempty(class{i})
    nos(i,1) = find(strcmp(class{i},names));    
  end
end

function d=distance(X,Y)

% Euclidean distance matrix between row vectors in X and Y

U=~isnan(Y); Y(~U)=0;
V=~isnan(X); X(~V)=0;
d=X.^2*U'+V*Y'.^2-2*X*Y';
