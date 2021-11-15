function [] = plot_graph(figure, nodes, color)
set(0, 'CurrentFigure', figure);
% get the nodes to plot
for i=2:length(nodes)-1
    node_i = nodes{i-1};
    node_j = nodes{i};
    plot([node_i.state(1) node_j.state(1)], [node_i.state(2) node_j.state(2)], ['.-',color], 'LineWidth', 2 ); hold on;
end
   plot(nodes{1}.state(1), nodes{1}.state(2), 'rp', 'LineWidth', 3 ); hold on;
   node = nodes{length(nodes)};
   plot(node.state(1), node.state(2), 'kp', 'LineWidth', 3 ); hold on;
        