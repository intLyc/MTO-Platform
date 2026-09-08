function ExportTestPlot(app)
% Copy the current Test axes into a standalone figure.
% Edit this file to customize the plot; app provides the current GUI data and controls.

f = figure();
axes2 = copyobj(app.TUIAxes, f);
set(axes2,'units','default','position','default');
set(axes2,'OuterPosition',[0,0,1,1]);
end
