function [sTstats,csThist] = som_stats_table(csS,histlabel)

%SOM_STATS_TABLE Statistics table.
%  
% [sTstats,csThist] = som_stats_table(csS)
% 
%   sTstats = som_stats_table(csS); 
%   som_table_print(sTstats);
%  
%  Input and output arguments ([]'s are optional): 
%   csS           (cell array) of statistics structs
%                 (struct) a statistics struct
%
%   sTstats       (struct) a table struct with basic descriptive 
%                          statistics for each variable
%   csThist       (cell array) of table structs, with histograms for
%                          each variable
%
% See also  SOM_STATS, SOM_STATS_PLOT, SOM_TABLE_PRINT, SOM_STATS_REPORT.

% Contributed to SOM Toolbox 2.0, December 31st, 2001 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 311201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% arguments

if isstruct(csS), csS = {csS}; end
dim = length(csS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% action

sTable = struct('colfmt','','headers',[],'values',[],'span',[]); 

% summary table of all variables
sT = sTable; 
sT.headers = {'name','min','mean','max','std','missing'};
if ~isnan(csS{1}.nunique), sT.headers{end+1} = 'unique'; end
%if length(col_values), sT.headers = [sT.headers, col_headers]; end
sT.values  = cell(dim,length(sT.headers));
sT.span    = ones([size(sT.values) 2]); 

%if length(col_values), sT.values(:,end-size(col_values,2)+1:end) = col_values; end 
%if length(col_spans),  sT.span(:,end-size(col_spans,2)+1:end,:)  = col_spans;  end 

for i=1:dim, 
    sT.values{i,1} = csS{i}.name;
    v = [csS{i}.min,csS{i}.mean,csS{i}.max,csS{i}.std];
    v = som_denormalize(v,csS{i}.normalization); 
    vstr = numtostring(v,6);
    sT.values(i,2:5) = vstr'; 
    sT.values{i,6} = c_and_p_str(csS{i}.ntotal-csS{i}.nvalid,csS{i}.ntotal); 
    if ~isnan(csS{1}.nunique),
        sT.values{i,7} = c_and_p_str(csS{i}.nunique,csS{i}.nvalid);
    end
end
sTstats = sT; 

% histograms
csThist = cell(dim,1); 
for i=1:dim, 
    sH     = csS{i}.hist; 
    nvalid = csS{i}.nvalid;
    nbins  = length(sH.bins); 
    sT         = sTable; 
    sT.headers = {[csS{i}.name ' values'],'frequency #','frequency %'};
    sT.values  = cell(nbins,length(sT.headers));  
    sT.span    = ones(nbins,length(sT.headers),2);
    for j=1:nbins,         
        if length(sH.bins) < csS{i}.nunique, sT.values{j,1} = sH.binlabels2{j};
        else sT.values{j,1} = sH.binlabels{j}; end
        sT.values{j,2} = sprintf('%d',round(sH.counts(j)));
        sT.values{j,3} = p_str(sH.counts(j)/nvalid);
    end     
    csThist{i} = sT; 
end   
   
return; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% subfunctions

function vstr = numtostring(v,d)

    tp = (size(v,2)>1);  
    if tp, v = v'; end
    nearzero = (abs(v)/(max(v)-min(v)) < 10.^-d);
    i1 = find(v > 0 & nearzero); 
    i2 = find(v < 0 & nearzero);     
    vstr = strrep(cellstr(num2str(v,d)),' ','');
    vstr(i1) = {'0.0'};
    vstr(i2) = {'-0.0'};
    if tp, vstr = vstr'; end
    return;

function str = c_and_p_str(n,m)
  % return a string of form # (%), e.g. '23 (12%)'
  if     n==m, p = '100'; 
  elseif n==0, p = '0';
  else         p = sprintf('%.2g',100*n/m);
  end
  str = sprintf('%d (%s%%)',round(n),p); 
  return;

function str = p_str(p)
  % return a string of form %, e.g. '12%'
  if round(p*100)>100,  p = sprintf('%3g',100*p); 
  elseif p==1,          p = '100';
  elseif abs(p)<eps,    p = '0';
  else                  p = sprintf('%.2g',100*p);
  end
  str = sprintf('%s%%',p); 
  return;
