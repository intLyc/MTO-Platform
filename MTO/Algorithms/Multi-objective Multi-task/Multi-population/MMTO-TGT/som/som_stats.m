function csS = som_stats(D,varargin)

%SOM_STATS Calculate descriptive statistics for the data.
%  
% csS = som_stats(D,[sort]); 
% 
%  csS = som_stats(D); 
%  csS = som_stats(D,'nosort'); 
%  som_table_print(som_stats_table(csS))
%
%  Input and output arguments ([]'s are optional): 
%   D           (matrix) a matrix, size dlen x dim
%               (struct) data or map struct
%   [sort]      (string) 'sort' (default) or 'nosort'
%                        If 'nosort' is specified, the data is not 
%                        sorted, and therefore the values of
%                        nunique, uvalues, ucount, fvalues, fcount, and tiles fields 
%                        are not calculated. This may be useful if
%                        there is a very large amount of data, and
%                        one wants to reduce calculation time.
%
%   csS         (cell array) size dim x 1, of statistics structs with 
%                        the following fields
%      .type             (string) 'som_stat'
%      .name             (string) name of the variable
%      .normalization    (struct array) variable normalization (see SOM_NORMALIZE)
%      .ntotal           (scalar) total number of values
%      .nvalid           (scalar) number of valid values (not Inf or NaN)
%      .min              (scalar) minimum value 
%      .max              (scalar) maximum value 
%      .mean             (scalar) mean value (not Inf or NaN)
%      .std              (scalar) standard deviation (not Inf or NaN)
%      .nunique          (scalar) number of unique values
%      .mfvalue          (vector) most frequent value
%      .mfcount          (vector) number of occurances of most frequent value
%      .values           (vector) at most MAXDISCRETE (see below) sample values 
%      .counts           (vector) number of occurances for each sampled value
%      .tiles            (vector) NT-tile values, for example
%                                    NT=4   for quartiles: 25%, 50% and 75%
%                                    NT=100 for percentiles: 1%, 2%, ... and 99%
%      .hist             (struct) histogram struct with the following fields
%           .type        (string) 'som_hist'
%           .bins        (vector) histogram bin centers 
%           .counts      (vector) count of values in each bin
%           .binlabels   (cellstr) labels for the bins (denormalized bin
%                                  center values)
%           .binlabels2  (cellstr) labels for the bins (denormalized bin
%                                  edge values, e.g. '[1.4,2.5['
%
%   Constants: 
%      MAXDISCRETE = 10
%      NT          = 10
%
% See also  SOM_STATS_PLOT, SOM_STATS_TABLE, SOM_TABLE_PRINT, SOM_STATS_REPORT.

% Contributed to SOM Toolbox 2.0, December 31st, 2001 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 311201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% arguments

% default values
nosort      = 0; 
nbins       = 10; 
maxdiscrete = 20; 
ntiles      = 10; 

% first argument
if isstruct(D), 
    switch D.type, 
    case 'som_map',  cn = D.comp_names; sN = D.comp_norm; D = D.codebook; 
    case 'som_data', cn = D.comp_names; sN = D.comp_norm; D = D.data; 
    otherwise, error('Invalid first argument')
    end    
else
    cn = cell(size(D,2),1); 
    cn(:) = {'Variable'};
    for i=1:length(cn), cn{i} = sprintf('%s%d',cn{i},i); end    
    sN = cell(size(D,2),1); 
end
[dlen dim] = size(D);

% other arguments

if length(varargin)>0, 
  if strcmp(varargin{1},'nosort'), nosort = 1; end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% action

sStat = struct('type','som_stat','name','','normalization',[],...
               'min',NaN,'max',NaN,'mean',NaN,'std',NaN,...
               'nunique',NaN,'values',[],'counts',[],'mfvalue',NaN,'mfcount',NaN,'tiles',[],...
               'ntotal',dlen,'nvalid',NaN,'hist',[]);
csS = cell(0);
           
for i=1:dim, 
    sS = sStat;
    sS.name = cn{i};
    sS.normalization = sN{i}; 
    x = D(:,i); 
    x(find(~isfinite(x))) = [];
    % basic descriptive statistics
    sS.nvalid = length(x);
    if length(x), 
        sS.min  = min(x);
        sS.max  = max(x);
        sS.mean = mean(x);  
        sS.std = std(x);
        bins = [];
        if ~nosort, 
            xsorted    = sort(x);
            % number of unique values
            repeated   = (xsorted(1:end-1)==xsorted(2:end));
            j          = [1; find(~repeated)+1];         
            xunique    = xsorted(j); 
            sS.nunique = length(xunique);           
            ucount     = diff([j; length(xsorted)+1]);
            % most frequent value
            [fcount,j] = max(ucount);
            sS.mfvalue = xunique(j);
            sS.mfcount = fcount;
            % -tiles (k*100/ntiles % of values, k=1..)
            pickind    = round(linspace(1,sS.nvalid,ntiles+1)); 
            pickind    = pickind(2:end-1);
            sS.tiles   = xsorted(pickind);
            if sS.nunique <= sS.nvalid/2, 
                % unique values
                sS.values = xunique; 
	            sS.counts = ucount; 
                bins = sS.values; 
            else
                % just maxdiscrete values, evenly  picked
                pickind    = round(linspace(1,sS.nunique,maxdiscrete));
                sS.values  = xunique(pickind);
                sS.counts  = ucount(pickind);
 	    
                %% OPTION 2: maxdiscrete most frequent values
                %[v,j]     = sort(ucount); 
                %pickind   = j(1:maxdiscrete);             
                %sS.values = xunique(pickind);
                %sS.counts = ucount(pickind);

                % OPTION 3: representative values - calculated using k-means
                %[y,bm,qe] = kmeans(x,maxdiscrete);
               %sS.values = y; 
                %sS.counts = full(sum(sparse(bm,1:length(bm),1,maxdiscrete,length(bm)),2));
            end 
        end 
        if isempty(bins), 
            bins = linspace(sS.min,sS.max,nbins+1); 
            bins = (bins(1:end-1)+bins(2:end))/2; 
        end
        sS.hist = som_hist(x,bins,sS.normalization);    
    else
        sS.hist = som_hist(x,0);
    end
    csS{end+1} = sS; 
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% subfunctions

function sH = som_hist(x,bins,sN)

    binlabels  = []; 
    binlabels2 = []; 
    if nargin<2 || isempty(bins) || any(isnan(bins)), 
        bins = linspace(min(x),max(x),10);    
    end
    if isstruct(bins), 
        bins = sH.bins; 
        binlabels  = sH.binlabels;
        binlabels2 = sH.binlabels2;
    end 
    if nargin<3, sN = []; end

    sH = struct('type','som_hist','bins',bins,'counts',[],...
                'binlabels',binlabels,'binlabels2',binlabels2);                         
            
    if length(bins)==1,
        sH.counts = [length(x)];
        edges = bins;
    elseif length(x),
        edges = (bins(1:end-1)+bins(2:end))/2;
        counts = histc(x,[-Inf; edges(:); Inf]);
        sH.counts = counts(1:end-1);       
    end 

    if isempty(sH.binlabels),
        b = som_denormalize(bins(:),sN); 
        sH.binlabels = numtostring(b,4);
    end 

    if isempty(sH.binlabels2),
        if length(edges)==1, 
            sH.binlabels2 = numtostring(som_denormalize(edges,sN),2);
            if length(bins)>1, 
              sH.binlabels2 = sH.binlabels2([1 1]);
              sH.binlabels2{1} = [']' sH.binlabels2{1} '['];
              sH.binlabels2{2} = ['[' sH.binlabels2{2} '['];
            end 
        else
            if size(edges,1)==1, edges = edges'; end
            bstr = numtostring(som_denormalize(edges,sN),4);
            sH.binlabels2 = bstr([1:end end]);
            sH.binlabels2{1} = [bstr{1} '['];
            for i=2:length(sH.binlabels2)-1,
                sH.binlabels2{i} = ['[' bstr{i-1} ',' bstr{i} '[']; 
            end 
            sH.binlabels2{end} = ['[' bstr{end}];
        end         
    end 
    
    if 0, 
        if length(bins)==1, sH.binlabels2 = {'constant'}; 
        else    
            ntiles = 10; 
            plim = [1:ntiles-1] / ntiles; 
            cp = cumsum(sH.counts)/sum(sH.counts);
            [dummy,i] = histc(cp,[-Inf plim Inf]);            
            l2 = cell(length(bins),1);            
            for j=1:length(bins), l2{j} = sprintf('Q%d',i(j)); end
            if i(1) > 1, l2{1} = ['...' l2{1}]; end            
            k = 0; 
            for j=2:length(bins), 
                if i(j)==i(j-1), 
                    if k==0, l2{j-1} = [l2{j-1} '.1']; k = 1; end
                    k = k + 1; 
                    l2{j} = [l2{j} '.' num2str(k)]; 
                else k = 0; end
            end 
            if i(end) < ntiles, l2{end} = [l2{end} '...']; end
            sH.binlabels2 = l2; 
        end 
    end    

    return;

function vstr = numtostring(v,d)

    r = max(v)-min(v); 
    if r==0, r=1; end
    nearzero = (abs(v)/r < 10.^-d);
    i1 = find(v > 0 & nearzero); 
    i2 = find(v < 0 & nearzero);     
    vstr = strrep(cellstr(num2str(v,d)),' ','');
    vstr(i1) = {'0.0'};
    vstr(i2) = {'-0.0'};
    return;

