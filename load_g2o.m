function [nodes, edges] = load_g2o(file)
%1-read the file and return a set of nodes and the set of edges
nodes={};
edges={};
data= fopen(file);
%check if something is wrong
if (data<0)
    error(['load_g2o:Cannot open data file...', file]);
end
% successfully opened the file
%go through the columns and store the data
cols=textscan(data,'%s', 'delimiter', '\n');
fclose(data);
rows=cols{1};
n = size(rows,1);
index_v = 1;
index_e =1;
for i=1:n
    row_i=rows{i};
    if strcmp('VERTEX_SE2',row_i(1:10))%g2o contains two types of measurements
        % 'VERTEX_SE2' and 'EDGE_SE2' for 2D 
        vertex_SE2 = textscan(row_i,'%s %d %f %f %f',1);
        node.id = vertex_SE2{2};
        node.state = [vertex_SE2{3} vertex_SE2{4} vertex_SE2{5}]; %x, y, theta
        nodes{index_v} = node; 
        index_v = index_v +1;
    elseif strcmp('EDGE_SE2',row_i(1:8))
        edge_SE2 = textscan(row_i,'%s %d %d %f %f %f %f %f %f %f %f %f',1);
        edge.id1 = edge_SE2{2}; %idout
        edge.id2 = edge_SE2{3}; %idin
        edge.meas = [edge_SE2{4} edge_SE2{5} edge_SE2{6}]; %dx, dy, dtheta
        edge.info = [edge_SE2{7} edge_SE2{8} edge_SE2{9};% this is the information matrix
            edge_SE2{8} edge_SE2{10} edge_SE2{11};
            edge_SE2{9} edge_SE2{11} edge_SE2{12}];
        edges{index_e} = edge;
        index_e = index_e +1;
    end
end



