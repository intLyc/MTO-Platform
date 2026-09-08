function RefreshParameterTree(node, parameters)
% Keep a parameter tree aligned with the values accepted by its algorithm or problem.
if nargin < 2, parameters = node.NodeData.getParameter(); end
if numel(node.Children) ~= numel(parameters)
    delete(node.Children);
    for i = 1:numel(parameters), uitreenode(node); end
end
for i = 1:2:numel(parameters)
    label = ['[ ', parameters{i}, ' ]'];
    node.Children(i).Text = label;
    node.Children(i).NodeData = label;
    node.Children(i+1).Text = parameters{i+1};
end
end
