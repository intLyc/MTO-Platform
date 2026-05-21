function som_stats_report(csS,fname,fmt,texonly)

% SOM_STATS_REPORT Make report of the statistics.
%  
% som_stats_report(csS, fname, fmt, [standalone])
%
%  som_stats_report(csS, 'data_stats', 'ps')
%
%  Input and output arguments ([]'s are optional): 
%   csS          (cell array) of statistics structs
%                (struct) a statistics struct
%   fname        (string) output file name (without extension)
%                (cellstr) {direc, fname}
%   fmt          (string) report format: 'ps', 'pdf', 'html' or 'txt'
%   [texonly]    (any)    for 'ps' and 'pdf' formats: if 4th argument 
%                         is given, only the tex file is written 
%                         (w/o document start/end), and it is not compiled
%
% See also  SOM_STATS, SOM_STATS_PLOT, SOM_STATS_TABLE, SOM_TABLE_PRINT, REP_UTILS.

% Contributed to SOM Toolbox 2.0, December 31st, 2001 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 311201

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if isstruct(csS), csS = {csS}; end
dim = length(csS);
if iscell(fname), direc = fname{1}; fname = fname{2}; else direc = '.'; end
if nargin<4, texonly = 0; else texonly = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% additional analysis
continuity = zeros(dim,1);
for i=1:dim, continuity(i) = csS{i}.nunique / csS{i}.nvalid; end

entropy_rel = zeros(dim,1);
for i=1:dim, 
    c = csS{i}.hist.counts; 
    if length(c) < 2 || all(c==0), entropy(i) = 0; 
    else
        maxent = log(length(c));
        c = c(c>0)/sum(c);
        entropy_rel(i) = -sum(c.*log(c)) / maxent;
    end 
end

% meta-statistics
values  = {'Number of variables',dim; ...
           'Number of samples',csS{1}.ntotal; ...
           'Valid values',c_and_p_str(count_total(csS,'nvalid'),dim*csS{1}.ntotal); ...
           'Mean(#unique / #valid)',mean(continuity); ...
           'Mean relative entropy',mean(entropy_rel)};
           %'Dataset name',sD.name; 'Report generated',datestr(now);          
sTdset = som_table_struct(values);

% statistics tables
[sTstats,csThist] = som_stats_table(csS); 
sTstats = som_table_modify(sTstats,'addcol',entropy_rel,{'entropy'});

% write report
if isempty(fname), fid = 1; 
else 
    switch fmt,
    case {'ps','pdf'}, ending = '.tex'; 
    case 'html', ending = '.html'; 
    case 'txt', ending = '.txt'; 
    end 
    fid = fopen([direc '/' fname ending],'w'); 
end
if ~texonly, rep_utils('header',fmt,fid); end

rep_utils({'inserttable',sTdset,1,0},fmt,fid);
rep_utils({'insertbreak'},fmt,fid);
rep_utils({'inserttable',sTstats,1,0},fmt,fid);
rep_utils({'insertbreak'},fmt,fid);
som_stats_plot(csS,'stats'); 
rep_utils({'printfigure',[direc '/histograms']},fmt);
rep_utils({'insertfigure','histograms'},fmt,fid);
for i=1:dim, 
    rep_utils({'insertbreak'},fmt,fid);
    rep_utils({'inserttable',csThist{i},1,0},fmt,fid);
end 

if ~texonly, rep_utils('footer',fmt,fid); end
if fid~=1, fclose(fid); end

if ~texonly && any(strcmp(fmt,{'ps','pdf'})), rep_utils('compile',fmt); end
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

function a = count_total(csS,field)
  % count total of the field values
  a = 0; for i=1:length(csS), a = a + getfield(csS{i},field); end
  return;
  
function str = c_and_p_str(n,m)
  % return a string of form # (%), e.g. '23 (12%)'
  if n==m, p = '100'; 
  elseif n==0, p = '0';
  else p = sprintf('%.2g',100*n/m);
  end
  str = sprintf('%d (%s%%)',round(n),p); 
  return;

  
