function som_projections_plot(pmode,varargin)

% SOM_PROJECTIONS_PLOT Projection visualizations.
%
% som_projections_plot(pmode,varargin)
%
%   [cPCAarg, Pdata, Pproto] = som_projections(D,sM);
%   som_projections_plot('scatter',Pdata(:,1:3))
%   som_projections_plot('scatter',Pproto(:,1:3),Pproto(:,5:7),5,sM)
%   som_projections_plot('residuals',Pdata(:,1:4))
%   som_projections_plot('scree',cPCAarg{3})
%
% The other arguments depend on the pmode:
%
%  pmode = 'scatter'
%
%     arg1: Co     (matrix) coordinates
%     arg2: color  (matrix) color vectors
%                  (string) colorstring ('k' by default)
%     arg3: psize  (scalar) point size
%     arg4: sT     (struct) topology struct, if map grid is drawn
%  
%  pmode = 'residuals'
%
%     arg1: Co     (matrix) coordinates (2 first columns) + residuals (the rest)
%     arg2: color  (string) colorstring ('k' by default)
%
%  pmode = 'scree'
%
%     arg1: eigval (vector) vector of eigenvalues
%      
% See also  SOM_PROJECTIONS.

switch pmode, 
case 'scatter', 
    Co = varargin{1}; 
    if length(varargin)>1, color = varargin{2}; else color = 'k'; end
    if length(varargin)>2, psize = varargin{3}; else psize = 5; end
    if length(varargin)>3, sT = varargin{4}; else sT = []; end
    if isstruct(sT) && strcmp(sT.type,'som_map'), sT = sT.topol; end
    
    if isempty(sT),
        som_grid({'rect',[size(Co,1) 1]},'Coord',Co,'Markercolor',color,'line','none','markersize',psize);
    else
        if ischar(color), lcolor = color; else lcolor = 'k'; end
        som_grid(sT,'Coord',Co,'Markercolor',color,'markersize',psize,'linecolor',lcolor); 
    end 
    
case 'residuals',
    CoRes = varargin{1}; 
    n = size(CoRes,1); 
    if length(varargin)>1, color = varargin{2}; else color = 'k'; end
    Co = CoRes(:,1:2); Co(end+1,:) = NaN; 
    res = sqrt(sum(CoRes(:,3:end).*CoRes(:,3:end),2)); 
    h=plot(Co(:,1),Co(:,2),'k.'); set(h,'color',color);
    Co(end+1,:) = NaN;
    res = [res; 0; NaN];  
    i = [1:n; 1:n; (n+1)+zeros(1,n)]; i = i(:); 
    j = [(n+1)+zeros(1,n); 1:n; (n+2)+zeros(1,n)]; j = j(:);  
    h = line(Co(i,1),Co(i,2),res(j)); set(h,'color',color);
    axis tight, axis equal, view(3)
    
case 'scree', 
    eigval = varargin{1};
    if size(eigval,1)>1, eigval = eigval'; end
    eigval = eigval / sum(eigval); 
    cumeig = cumsum(eigval);
    bar(cumeig,0.1)
    i = find(cumeig>=0.75); i75 = i(1); 
    hold on
    plot([0 2],cumeig([2 2]),'r-',[0 i75],cumeig([i75 i75]),'r-');
    set(gca,'YTick',unique([0:0.1:1 cumeig(2) cumeig(i75)]));  
    axis tight, grid on

end 

