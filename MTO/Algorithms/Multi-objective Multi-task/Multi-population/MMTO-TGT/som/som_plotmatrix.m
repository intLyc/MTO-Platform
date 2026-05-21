function som_plotmatrix(sM,D,Col,comps)

%SOM_PLOTMATRIX Visualize pairwise scatter plots and histograms.
%
%  som_plotmatrix(sM,[sD],[Col],[comps])
% 
%  Input and output arguments ([]'s are optional):
%   sM       (struct) map struct
%   [sD]     (struct) data struct, corresponding to the map
%            (matrix) data matrix (size dlen x dim)
%   [Col]    (matrix) size munits x 3, color for each map unit
%   [comps]  (vector) which components to plot (1:dim by default)
%
% See also: SOM_SHOW, SOM_ORDER_CPLANES.

% Copyright (c) 2000 by the SOM toolbox programming team.
% Contributed to SOM Toolbox on June 16th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 140600

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% sM
[munits dim] = size(sM.codebook); 
M = sM.codebook;

% sD
if nargin>1 && ~isempty(D), 
  if isstruct(D), D = D.data; end
  bmus = som_bmus(sM,D);
else D = []; bmus = []; 
end

% Col
if nargin<3 || isempty(Col), Col = som_colorcode(sM); end
if ischar(Col), Col = som_colorcode(sM,Col); end

% comps
if nargin<4 || isempty(comps), comps = 1:dim; end
n = length(comps)+1;

% histogram bins
if ~isempty(D), C=D; else C=M; end
cHbins = cell(dim,1);
cAxis = cell(dim,1);
for i=1:dim, 
  if ~isempty(D), mima = [min(D(:,i)),max(D(:,i))];
  else mima = [min(M(:,i)),max(M(:,i))];
  end
  cAxis{i} = mima; 
  [dummy,cHbins{i}] = hist(mima,20);   
end

nt = 4; % number of ticks in scatter plots

% visualization
clf
for i=1:n, 
  for j=1:n, 
    subplot(n,n,(i-1)*n+j); 
    if j==1 && i==1, 
      h=som_cplane(sM,Col); set(h,'edgecolor','none')
    elseif i==1, 
      ind = comps(j-1); 
      b  = cHbins{ind};      
      hs = hist(M(:,ind),b); 
      h  = bar(b,hs,0.8); set(h,'EdgeColor','none','FaceColor','k'); 
      axis on, axis tight
      set(gca,'XTick',[],'Box','on');
      title(sM.comp_names{ind});
    elseif j==1, 
      ind = comps(i-1); 
      if ~isempty(D), 
	b  = cHbins{ind}; 
	hs = hist(D(:,ind),b); 
	h  = bar(b,hs,0.8); set(h,'EdgeColor','none','FaceColor','k'); 
	axis on, axis tight	
	set(gca,'XTick',[],'Box','on');
	ylabel(sM.comp_names{ind})
      else
	text(0.5,0.5,sM.comp_names{ind});
	axis off
      end
    elseif i==j, 
      ind = comps(i-1); 
      h=som_cplane(sM,M(:,ind)); 
      set(h,'edgecolor','none')
      a = cAxis{ind}; 
      caxis(a); v = unique([a, min(M(:,ind)), max(M(:,ind))]); 
      vn=som_denormalize(v,sM.comp_norm{ind})'; 
      h=colorbar('vert');
      set(h,'YTick',v,'YTickLabel',cellstr(num2str(vn,2)));
    elseif i<j || ~isempty(D), 
      if i>j, i1 = i-1; i2 = j-1; else i1 = j-1; i2 = i-1; end
      ind1 = comps(i1); ind2 = comps(i2); 
      if i<j, 
	som_grid(sM,'coord',M(:,[ind1 ind2]),'markersize',2,'MarkerColor',Col);
      else
	som_grid('rect',[size(D,1) 1],'coord',D(:,[ind1 ind2]),...
		 'Line','none','MarkerColor',Col(bmus,:),'Markersize',2);	
	%cla; hold on
	%for k=1:max(bmus), 
	%  inds = find(bmus==k); 
	%  if any(inds), 
	%    som_grid('rect',[length(inds) 1],'coord',D(inds,[ind1 ind2]),...
	%	     'Line','none','MarkerColor',Col(k,:),'Markersize',2);	
	%  end
	%end
      end	      
      a = [cAxis{ind1} cAxis{ind2}]; axis(a); 
      x = linspace(a(1),a(2),nt); xn = som_denormalize(x,sM.comp_norm{ind1})';
      set(gca,'XTick',x,'XTickLabel',cellstr(num2str(xn,2)));
      y = linspace(a(3),a(4),nt); yn = som_denormalize(y,sM.comp_norm{ind2})';
      set(gca,'YTick',y,'YTickLabel',cellstr(num2str(yn,2)));
      xlabel(sM.comp_names{ind1}), ylabel(sM.comp_names{ind2})
    end    
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

