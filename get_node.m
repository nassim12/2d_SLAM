function [node] = get_node(nodes, id)
% got through the nodes set to extract the corresponding node to that id
for i=1:length(nodes)
    if nodes{i}.id==id
        node = nodes{i};
        return
    end
end
fprintf('ERROR: Cannot find the node with id %d', id);

