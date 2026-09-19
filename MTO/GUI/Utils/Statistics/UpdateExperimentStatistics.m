function UpdateExperimentStatistics(app)
%UPDATEEXPERIMENTSTATISTICS Render independent test results in the GUI table.
% Numerical routines are ComputeFriedmanHolm and ComputeWilcoxonTest.
if strcmp(app.EDataTypeDropDown.Value,'Reps') || isempty(app.EData),return;end
raw=app.EResultTableData;n=size(raw,1);k=size(raw,2);
app.ETableTest={};app.EUITable.Data=app.ETableView;
labels=app.EUITable.RowName;app.EUITable.RowName=labels(1:n);
mode=app.ETestTypeDropDown.Value;base=app.EAlgorithmDropDown.Value;
if strcmp(mode,'None') || isempty(raw),app.EupdateTableHighlight();return;end
if contains(mode,'Friedman')
 if contains(mode,'(all reps)'),kind='all reps';rankName='Ranking';
 else,kind='mean';rankName='Ranking';end
 result=ComputeFriedmanHolm(raw,base,app.EMetricMin,kind);
 % The overall test does not depend on the base algorithm or display format.
 key=struct('Data',raw,'Mode',kind,'Minimize',app.EMetricMin, ...
     'Metric',app.EDataTypeDropDown.Value,'Algorithms',{app.EUITable.ColumnName});
 previous=getappdata(app.EUITable,'MTOFriedmanPrinted');
 if ~isequaln(previous,key)
  if result.Valid
   fprintf('[Friedman %s] overall p=%.6g; N=%d comparison rows; k=%d; reps=%d; NaN failures=%d; NaN=worst.\n', ...
       kind,result.OverallP,result.N,result.K,result.Reps,result.FailedObservations);
   if strcmp(kind,'mean')
    fprintf('  Mean mode uses omitnan (successful runs only); all-failed cells rank worst; success counts range %d/%d to %d/%d.\n', ...
      min(result.SuccessCounts,[],'all'),result.Reps,max(result.SuccessCounts,[],'all'),result.Reps);
   end
  else
   fprintf('[Friedman %s] not computed: %s\n',kind,result.Reason);
  end
  setappdata(app.EUITable,'MTOFriedmanPrinted',key);
 end
 rows=repmat({''},2,k);
 if result.Valid
  rows(1,:)=arrayfun(@(x)sprintf('%.2f',x),result.MeanRanks,'UniformOutput',false);
  for i=setdiff(1:k,base)
   rows{2,i}=sprintf('%.4f',result.AdjustedP(i));
   if result.Significant(i),rows{2,i}=[rows{2,i},'*'];end
  end
 end
 rows{2,base}='Base';
 app.EUITable.RowName(n+1:n+2)={rankName;'p-value'};
 app.EUITable.Data=[app.ETableView;rows];
 app.ETableTest=rows;
else
 if k<2,app.EupdateTableHighlight();return;end
 if contains(mode,'Signed-rank'),kind='signed-rank';else,kind='rank-sum';end
 result=ComputeWilcoxonTest(raw,base,app.EMetricMin,kind);
 result.Symbols(strcmp(result.Symbols,'NA'))={''}; % Undefined tests are not equality.
 app.ETableTest=result.Symbols;
 view=cellfun(@(v,t)[v,repmat(' ',1,~isempty(t)),t],app.ETableView, ...
     result.Symbols,'UniformOutput',false);
 summary=cell(1,k);
 for i=1:k
  if i==base,summary{i}='Base';else,summary{i}=sprintf('%d / %d / %d',result.Counts(i,1:3));end
 end
 app.ETableTest(n+1,:)=summary;
 app.EUITable.RowName{n+1}='+ / - / =';
 app.EUITable.Data=[view;summary];
end
app.EupdateTableHighlight();
end
