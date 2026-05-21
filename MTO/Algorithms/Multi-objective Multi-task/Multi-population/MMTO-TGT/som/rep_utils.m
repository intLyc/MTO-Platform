function aout = rep_utils(action,fmt,fid)

%REP_UTILS Utilities for print reports and report elements.
%  
% aout = rep_utils(action,fmt,[fid])
% 
%  Input and output arguments ([]'s are optional): 
%   action      (string)     action identifier
%               (cell array) {action,par1,par2,...}
%                            the action identifier, followed by action 
%                            parameters
%   [fmt]       (string)     format of output, 'txt' by default
%   [fid]       (scalar)     output file id, by default NaN in which
%                            case output is not written, only returned
%                            in aout
%   
%   aout        (varies)     output of the action
%
%  Here are the actions and their arguments: 
%  'printlines'   par1 (cellstr)   print par1, each cell on a new line
%  'header'       par1 (string)    print document header using par1 as title
%  'footer'                        print document footer
%  'compile'      par1 (string)    compile the named document (only 'ps' and 'pdf')
%  'inserttable'  par1 (struct)    print given table
%                 par2 (scalar)    print lines between rows if par2=1
%                 par3 (scalar)    use longtable format (only 'ps' and 'pdf')
%  'printfigure'  par1 (string)    print current figure to file, par1 = filename
%                 par2 (scalar)    used resolution (150 dpi by default)
%                 par3 (scalar)    if par3=1, insert figure in minipage
%  'insertfigure' par1 (string)    insert figure to report, par1 = filename of figure
%                 par2 (vector)    size 2 x 1, size of figure relative to page size 
%                                  NaN = automatic scaling
%                 par3 (scalar)    if par3=1, insert figure in minipage (only 'ps' and 'pdf')
%  'insertbreak'                   insert paragraph break into report 
%
% See also  REP_STATS.

% Contributed to SOM Toolbox 2.0, January 2nd, 2002 by Juha Vesanto
% Copyright (c) by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 020102

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

pars = {''}; 
if iscell(action), 
    if length(action)>1, pars = action(2:end); end
    action = action{1}; 
end

if nargin<2 || isempty(fmt), fmt = 'txt'; end
global REPORT_OUTPUT_FMT
REPORT_OUTPUT_FMT = fmt;

if nargin<3 || isempty(fid), fid = NaN; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

aout = []; 
printable = 0; 

switch action,
case 'printlines',
    aout = pars{1}; 
case 'header',     
    switch fmt, 
    case {'ps','pdf'}, aout = tex_startdocument(pars{1}); 
    case 'html',       aout = html_startpage(pars{1});
    case 'txt',        aout = cell(0);
    end 
    printable = 1; 
case 'footer', 
    switch fmt, 
    case {'ps','pdf'}, aout = tex_enddocument; 
    case 'html',       aout = html_endpage;
    case 'txt',        aout = cell(0);
    end 
    printable = 1; 
case 'compile',      aout = compiledocument(pars{1});
case 'inserttable',  aout = inserttable(pars{:}); printable = 1; 
case 'printfigure',  printfigure(pars{:});
case 'insertfigure', aout = insertfigure(pars{:}); printable = 1;
case 'insertbreak',  aout = insertbreak; printable = 1; 
case 'joinstr',      aout = joinstr(pars{:}); printable = 1; 
case 'rulestr',      aout = rulestr(pars{:}); printable = 1; 
case 'c_and_p_str',  aout = c_and_p_str(pars{:}); printable = 1; 
case 'p_str',        aout = p_str(pars{:}); printable = 1; 
end 

% if output file is given, print lines
if ~isnan(fid) && printable,
    if ~iscell(aout), aout = {aout}; end
    for i = 1:length(aout), fprintf(fid,'%s\n',fmtline(aout{i})); end
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% subfunctions

%% simple formatter strings

function s = joinstr(cs, sep1, sep2)
  if nargin==1, sep1 = ', '; sep2 = ' and '; end
  if nargin<3, sep2 = sep1; end
  if isempty(cs), 
    s = '';     
  elseif strcmp(sep1,'\n'), 
    if size(cs,1)==1, cs = cs'; end
    s = char(cs); 
  else
    s = cs{1}; 
    for i=2:length(cs)-1, s = [s sep1 cs{i}]; end
    if length(cs)>1, s = [s sep2 cs{end}]; end
  end
  return; 

function str = c_and_p_str(n,m)

  % return a string of form # (%), e.g. '23 (12%)'
  if n==m, p = '100'; 
  elseif n==0, p = '0';
  else p = sprintf('%.2g',100*n/m);
  end
  str = sprintf('%d (%s%%)',round(n),p); 
  return;
  
function str = p_str(p)
  % return a string of form %, e.g. '12%'
  if round(p*100)>=100, p = sprintf('%3g',100*p); 
  elseif abs(p)<eps, p = '0';
  else p = sprintf('%.2g',100*p);
  end
  str = sprintf('%s%%',p); 
  return;

function cs = rulestr(sR,cnames)
  global REPORT_OUTPUT_FMT
  switch REPORT_OUTPUT_FMT
   case {'ps','pdf'}, [~,geq,~,m,less,in] = deal('\leq','\geq','\inf','$','<','\in'); 
   case 'html',  [~,geq,~,m,less,in]  = deal('&lt;=','&gt;=','Inf',' ','&lt;',' '); 
   case 'txt', [~,geq,~,m,less,in]  = deal('<=','>=','inf',' ','<',''); 
  end
  nr = length(sR); 
  cs = cell(nr,1); 
  fmt = '%.2g'; 
  if nargin<2, cnames = {sR.name}; end
  if isempty(cnames), cnames = cell(nr,1); cnames(:) = {''}; end 
  for i=1:nr,       
    low  = sR(i).low; 
    high = sR(i).high; 
    switch isfinite(low) + 2*isfinite(high), 
     case 0, cs{i} = [cnames{i} ' ' 'any']; 
     case 1, cs{i} = [cnames{i} ' ' m geq sprintf(fmt,low) m];
     case 2, cs{i} = [cnames{i} ' ' m less sprintf(fmt,high) m]; 
     case 3, cs{i} = [cnames{i} ' ' m in '[' sprintf(fmt,low) ',' sprintf(fmt,high) ']' m];
    end
  end
  return; 

%% print figure

function imgfmt = fmt2imgfmt
  global REPORT_OUTPUT_FMT
  switch REPORT_OUTPUT_FMT, 
  case 'ps',   imgfmt = 'ps'; 
  case 'pdf',  imgfmt = 'pdf'; 
  case 'html', imgfmt = 'png'; 
  case 'txt',  imgfmt = ''; 
  end
  return; 

function printfigure(fname,resolution)
  if nargin<2, resolution = 150; end
  fnameps = [fname '.ps']; 
  switch fmt2imgfmt,
  case 'ps',  
      print('-dpsc2',fnameps); 
  case 'pdf', 
      print('-dpsc2',fnameps);       
      eval(sprintf('!ps2pdf %s',fnameps));  
  case 'gif',       
      print('-dpsc2',fnameps);              
      cmd = 'pstogif'; 
      opt = sprintf('-depth 1 -density %d',resolution); 
      unix(sprintf('%s %s -out %s %s',cmd,opt,[fname '.gif'],fnameps));
  case 'png',
      opt = sprintf('-r%d',resolution); 
      print('-dpng',opt,[fname '.png']);
  end
  return; 

%% headers and footers, and compilation

function cs = tex_startdocument(title)
  % tex document headers
  global REPORT_OUTPUT_FMT
  cs = cell(0); 
  cs{end+1} = '\documentclass[10pt,a4paper]{article}'; 
  cs{end+1} = '\usepackage[dvips]{epsfig,graphicx,color}'; 
  cs{end+1} = '\usepackage{float,graphics,subfigure}'; 
  cs{end+1} = '\usepackage{multirow,rotating,portland,lscape,longtable,pifont}'; 
  cs{end+1} = '\usepackage[T1]{fontenc}'; 
  if strcmp(REPORT_OUTPUT_FMT,'pdf'), cs{end+1} = '\usepackage{pslatex}'; end
  cs{end+1} = '\usepackage[english]{babel}'; 

  cs{end+1} = '\oddsidemargin 0 mm';
  cs{end+1} = '\evensidemargin 0 mm';
  cs{end+1} = '\textwidth 17 cm';
  cs{end+1} = '\topmargin 0 mm';
  cs{end+1} = '\textheight 21 cm';
  cs{end+1} = '\voffset 0 mm';

  cs{end+1} = '\begin{document}'; 
  cs{end+1} = ['\title{' title '}']; 
  cs{end+1} = '\maketitle'; 
  %cs{end+1} = '\tableofcontents'; 
  %cs{end+1} = '\clearpage'; 
  return;

function cs = tex_enddocument
  cs = cell(0);
  cs{end+1} = '\end{document}';
  return; 

function cs = html_startpage(title)
  % print HTML document headers
  cs = cell(0);
  cs{end+1} = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">';
  cs{end+1} = '<HTML>';
  cs{end+1} = '<HEAD>';
  cs{end+1} = sprintf('  <TITLE>%s</TITLE>',title);
  cs{end+1} = '</HEAD>';
  cs{end+1} = '<BODY bgcolor=white vlink="#000033" link="#0000ff" text="#000000">';
  if ~isempty(title), cs{end+1} = sprintf('<H1>%s</H1>',title); end
  return;

function cs = html_endpage
  % print HTML document footers
  cs = cell(0);
  cs{end+1} = '<P><HR>';
  cs{end+1} = '</BODY>';
  cs{end+1} = '</HTML>';
  return;

function files = compiledocument(filename)
  global REPORT_OUTPUT_FMT
  switch REPORT_OUTPUT_FMT, 
   case 'pdf', 
    eval(sprintf('!pdflatex --interaction batchmode %s.tex',filename));
    eval(sprintf('!pdflatex --interaction batchmode %s.tex',filename));
    %eval(sprintf('!acroread %s.pdf &',filename)); 
    files = {[filename '.aux'],[filename '.log'],[filename '.out'],[filename '.pdf']}; 
   case 'ps', 
    eval(sprintf('!latex --interaction batchmode %s.tex',filename));
    eval(sprintf('!latex --interaction batchmode %s.tex',filename));
    eval(sprintf('!dvips %s.dvi',filename)); 
    eval(sprintf('!ps2pdf %s.ps',filename));
    %eval(sprintf('!ghostview %s.ps &',filename)); 
    files = {[filename '.aux'],[filename '.log'],[filename '.out'],[filename '.dvi'],[filename '.pdf']}; 
   case 'html',   
   case 'txt',
  end
  return; 


function vstr = defaultformat(val)  
  global REPORT_OUTPUT_FMT
  if ischar(val),        vstr = val; 
  elseif iscellstr(val), vstr = char(val); 
  elseif isempty(val),   vstr = ''; 
  elseif isnumeric(val), 
    if val==round(val), fmt = '%d'; else fmt = '%.3g'; end 
    if abs(val)<=eps, vstr = '0'; else vstr = sprintf(fmt,val); end
  elseif isstruct(val) && isfield(val,'values') && isfield(val,'headers'), 
    % a table
    vstr = joinstr(inserttable(val,0),'\n');
    if any(strcmp(REPORT_OUTPUT_FMT,{'ps','pdf'})), 
      vstr= inserttominipage(vstr); 
    end
  else
    vstr = ''; fprintf(1,'defaultformat unable to handle input\n');     
    whos val
  end
  return; 

%% report elements (list, table, image, link)

function str = fmtline(str)
  % replace some formatting elements depeding on output format
  global REPORT_OUTPUT_FMT
  if isempty(str), str = ''; return; end
  switch REPORT_OUTPUT_FMT, 
   case {'ps','pdf'}, 
     str = strrep(str,'<B>',  '{\bf ');
     str = strrep(str,'<I>',  '{\em ');
     str = strrep(str,'<TT>', '{\tt ');
     str = strrep(str,'</B>', '}');
     str = strrep(str,'</I>', '}');
     str = strrep(str,'</TT>','}');
     str = strrep(str,'#','\#'); 
     str = strrep(str,'%','\%');
   case 'html', % nil
   case 'txt', 
     str = strrep(str,'<B>',  '*');
     str = strrep(str,'<I>',  '*');
     str = strrep(str,'<TT>', '');
     str = strrep(str,'</B>', '*');
     str = strrep(str,'</I>', '*');
     str = strrep(str,'</TT>','');
  end
  return;

function cs = insertbreak
    global REPORT_OUTPUT_FMT
    cs = cell(0); 
    switch REPORT_OUTPUT_FMT
    case {'ps','pdf'}, cs{end+1} = '';
    case 'html', cs{end+1} = '<P>';
    case 'txt', cs{end+1} = ''; 
    end   
    return;
    
function insertlist(list,enum)
  % make list
  global REPORT_OUTPUT_FMT
  if nargin<2, enum = 0; end
  cs = cell(0);
  switch REPORT_OUTPUT_FMT
   case {'ps','pdf'}, 
    if enum, tag = 'enumerate'; else tag = 'itemize'; end
    starttag = ['\begin{' tag '}'];
    listtag = '\item ';
    endtag = ['\end{' tag '}'];
   case 'html', 
    if enum, tag = 'OL'; else tag = 'UL'; end
    starttag = ['<' tag '>'];
    listtag = '<LI>';
    endtag = ['</' tag '>'];   
   case 'txt',
    starttag = ''; 
    listtag = '- ';
    endtag = ''; 
  end
  cs{end+1} = starttag;
  for i=1:length(list), cs{end+1} = sprintf('%s %s',listtag,list{i}); end
  cs{end+1} = endtag; 
  return;

function csout = tablerow(cs,emp,span)
  % construct one table row
  global REPORT_OUTPUT_FMT
  if nargin<2 || isempty(emp), emp = 'none'; end
  if nargin<3 || isempty(span), span = ones(length(cs),2); end
  rowspan = span(:,1); colspan = span(:,2);
  switch emp,
   case 'bold',   emp1 = '<B>';  emp2 = '</B>'; 
   case 'italic', emp1 = '<I>';  emp2 = '</I>'; 
   case 'fixed',  emp1 = '<TT>'; emp2 = '</TT>';           
   case 'none',   emp1 = '';     emp2 = ''; 
   case 'header', emp1 = '';     emp2 = ''; tag = 'TH';
  end      
  csout = cell(0); 
  switch REPORT_OUTPUT_FMT, 
   case {'pdf','ps'}, 
    %switch emp,
    % case 'bold',   emp1 = '{\bf '; emp2 = '}'; 
    % case 'italic', emp1 = '{\em '; emp2 = '}'; 
    % case 'fixed',  emp1 = '{\tt '; emp2 = '}';       
    % case 'none',   emp1 = '';      emp2 = ''; 
    %end    
    s0 = ''; 
    for i=1:length(cs), 
      if rowspan(i) && colspan(i), 
	 sp1 = ''; sp2 = '';
         if colspan(i)>1, sp1 = [sp1 ' \multicolumn{' num2str(colspan(i)) '}{|c|}{']; sp2 = [sp2 '}']; end
         if rowspan(i)>1, sp1 = [sp1 ' \multirow{' num2str(rowspan(i)) '}{2cm}{']; sp2 = [sp2 '}']; end
	 s = s0; 
	 content = cellstr(defaultformat(cs{i})); 
	 csout{end+1} = [s sp1 emp1 content{1}]; 
	 for j=2:length(content), csout{end+1} = content{j}; end
	 csout{end} = [csout{end} emp2 sp2]; 
	 s0 = ' & '; 
      end
    end
    csout{end} = [csout{end} ' \\']; 
   case 'html', 
    tag = 'TD';
    csout{end+1} = '<TR>';     
    for i=1:length(cs),
      if rowspan(i) && colspan(i), 
         sp = '';
         if rowspan(i)>1, sp = [sp ' ROWSPAN=' num2str(rowspan(i))]; end
         if colspan(i)>1, sp = [sp ' COLSPAN=' num2str(colspan(i))]; end
         s = sprintf('<%s%s>%s',tag,sp,emp1);
	     content = cellstr(defaultformat(cs{i})); 
	     csout{end+1} = [s content{1}]; 
	     for j=2:length(content), csout{end+1} = content{j}; end
	     csout{end} = [csout{end} emp2 '</' tag '>']; 
      end
    end
    csout{end+1} = '</TR>'; 
   case 'txt',
    for i=1:length(cs), csout{end+1} = defaultformat(cs{i}); end
  end
  return;  

function cs = inserttable(sTable,rowlines,long)
  % put table contents to cellstr
  global REPORT_OUTPUT_FMT  
  if nargin<2, rowlines = 1; end
  if nargin<3, long = 0; end
  [rows cols] = size(sTable.values);
  cs = cell(0); 
  if isempty(sTable.colfmt), cf = 'c'; sTable.colfmt = cf(ones(1,cols)); end
  if isempty(sTable.span), sTable.span = ones([rows cols 2]); end  
  switch REPORT_OUTPUT_FMT
   case {'ps','pdf','tex','latex'}
    li1 = ' \hline';  
    if rowlines>0, li2 = li1; li3 = li1; 
    elseif rowlines==0, li2 = ''; li3 = li1; 
    else li1 = ''; li2 = ''; li3 = '';  
    end
    if long, tbl = 'longtable'; else tbl = 'tabular'; end
    cs{end+1} = ['\begin{' tbl '}{' sTable.colfmt '}' li1];
    if ~isempty(sTable.headers), 
      row = tablerow(sTable.headers,'bold'); 
      for i=1:length(row), cs{end+1} = row{i}; end
      cs{end} = [cs{end} li1 li2]; 
    end
    for i=1:rows, 
      row = tablerow(sTable.values(i,:),'',squeeze(sTable.span(i,:,:))); 
      for i=1:length(row), cs{end+1} = row{i}; end
      cs{end} = [cs{end} li2]; 
    end 
    if ~rowlines, cs{end} = [cs{end} li3]; end
    cs{end+1} = ['\end{' tbl '}'];
   case 'html'
    cs{end+1} = ['<TABLE BORDER=' num2str(rowlines>0) '>'];
    if ~isempty(sTable.headers), 
      row = tablerow(sTable.headers,'header'); 
      for i=1:length(row), cs{end+1} = row{i}; end
    end
    for i=1:rows, 
      row = tablerow(sTable.values(i,:),'',squeeze(sTable.span(i,:,:))); 
      for i=1:length(row), cs{end+1} = row{i}; end
    end
    cs{end+1} = '</TABLE>';
   case 'txt'
    cT = [sTable.headers(:)'; sTable.values]; 
    A = cell2char(cT); 
    for i=1:size(A,1), cs{end+1} = A(i,:); end        
  end  
  return;

function A = cell2char(T)

  [nrow,ncol] = size(T); 
  rowsep = 0; 
  colsep = 1;

  % change to strings
  for i=1:nrow, 
    for j=1:ncol, 
      t = T{i,j};
      if ischar(t),        % ok
      elseif isempty(t),   T{i,j} = ''; 
      elseif isstruct(t),  % ??
      elseif iscell(t),    T{i,j} = cell2char(t); 
      elseif isnumeric(t), T{i,j} = num2str(t,3); 
      end
    end
  end

  % widths of columns and heights of rows 
  HW = ones(nrow,ncol,2);
  for i=1:nrow, for j=1:ncol, HW(i,j,:) = size(T{i,j}); end, end
  colw = max(HW(:,:,2),[],1); 
  rowh = max(HW(:,:,1),[],2); 

  % the table itself
  A = char(32*ones(sum(rowh)+rowsep*(nrow-1),sum(colw)+colsep*(ncol-1)));
  for i=1:nrow, 
    for j=1:ncol,
      i0 = (i-1)*rowsep+sum(rowh(1:i-1));
      j0 = (j-1)*colsep+sum(colw(1:j-1)); 
      S = char(32*ones(rowh(i),colw(j))); 
      si = size(T{i,j}); S(1:si(1),1:si(2)) = T{i,j}; 
      A(i0+[1:rowh(i)],j0+[1:colw(j)]) = S; 
    end
  end
  return; 
  

function s = inserttominipage(s,width)
  if nargin<2 || isempty(width) || isnan(width), width = 1; end
  width = ['{' num2str(width) '\columnwidth}'];
  mp1 = '\begin{minipage}[t]'; mp2 = '\end{minipage}';   
  if size(s,1)==1, s = [mp1 width s mp2];
  else s = char({[mp1 width]; s; mp2});
  end
  return; 
  
function cs = insertfigure(fname,boxsize,inminipage)
  global REPORT_OUTPUT_FMT
  if nargin<2, boxsize = [NaN 1]; end
  if nargin<3, inminipage = 0; end
  htmlpagewidth = 800;
  si = cell(0); 
  switch REPORT_OUTPUT_FMT,     
   case {'ps','pdf'}, 
    if ~isnan(boxsize(1)), si{end+1} = ['height=' num2str(boxsize(1)) '\textheight']; end
    if ~isnan(boxsize(2)), si{end+1} = ['width=' num2str(boxsize(2)) '\columnwidth']; end
    if length(si), si = [', ' joinstr(si, ', ', ', ')]; end
   case 'html', 
    if ~isnan(boxsize(1)), si{end+1} = ['HEIGHT=' num2str(htmlpagewidth*boxsize(1))]; end
    if ~isnan(boxsize(2)), si{end+1} = ['WIDTH=' num2str(htmlpagewidth*boxsize(2))]; end   
    if length(si), si = [' ' joinstr(si, ' ', ' ')]; end
   case 'txt', 
    % nil 
  end    
  switch REPORT_OUTPUT_FMT,     
   case 'ps',   s = ['\epsfig{file=./' fname '.ps ' si '}']; 
   case 'pdf',  s = ['\includegraphics[' si ']{./' fname '.pdf}'];
   case 'html', 
    fn = [fname '.' fmt2imgfmt]; 
    s = ['<IMG SRC="' fn '" ALIGN="center" ALT="' fname '"' si '>'];
    s = makelinkfrom(fn,s); 
   case 'txt', 
    s = ['[image:' fname ']'];
  end
  switch REPORT_OUTPUT_FMT, 
   case {'ps','pdf'},
    if inminipage, s = inserttominipage(s,boxsize(2)); end
   case 'html', 
    s = ['<CENTER>' s '</CENTER>']; 
   case 'txt', 
    % nil
  end
  cs = {s};
  return;

function str = makelinkfrom(linkto,anchor)  
  global REPORT_OUTPUT_FMT
  if iscell(linkto), 
    if strcmp(REPORT_OUTPUT_FMT,'html'), linkto = joinstr(linkto,'','#'); 
    else linkto = joinstr(linkto,'',''); 
    end
  end
  switch REPORT_OUTPUT_FMT,  
   case 'pdf',  str = ['\hyperlink{' linkto '}{' anchor '}'];
   case 'ps',   str = [anchor ' (p.\pageref{' linkto '})']; 
   case 'html', str = ['<a href="' linkto '">' anchor '</a>']; 
   case 'txt', str = ''; 
  end
  return; 
      
function str = makelinkto(linkname)
  global REPORT_OUTPUT_FMT
  switch REPORT_OUTPUT_FMT,  
   case 'pdf', 
    fmt = '\pdfdest name {%s} fit \pdfoutline goto name {%s} {%s}'; 
    str = sprintf(fmt,linkname,linkname,linkname);
   case 'ps',   str = ['\label{' linkname '}']; 
   case 'html', str = ['<a name="' linkname '"> </a>']; 
   case 'txt', str = ''; 
  end
  return;

