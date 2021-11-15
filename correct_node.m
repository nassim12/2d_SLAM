function [node] = correct_node(node, delta)
% apply the update from the optimization solution
% for 2D, position is adition
%the orientation needs normalization in case.
node.state(1) = node.state(1) + delta(1);
node.state(2) = node.state(2) + delta(2);
node.state(3) = normalize_theta(node.state(3) + delta(3));
