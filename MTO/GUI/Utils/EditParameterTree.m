function changed = EditParameterTree(node)
% Apply a name/value edit; parameter labels remain read-only.
changed = false;
if isa(node.Parent, 'matlab.ui.container.Tree')
    changed = ~strcmp(node.NodeData.Name, node.Text);
    node.NodeData.Name = node.Text;
    return;
end
root = node.Parent;
index = find(root.Children == node, 1);
if mod(index, 2) == 1
    node.Text = node.NodeData;
    return;
end
parameters = root.NodeData.getParameter();
values = parameters(2:2:end);
if strcmp(values{index/2}, node.Text), return; end
values{index/2} = node.Text;
try
    root.NodeData.setParameter(values);
catch exception
    RefreshParameterTree(root);
    rethrow(exception);
end
RefreshParameterTree(root);
changed = true;
end
