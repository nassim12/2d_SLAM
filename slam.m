clear all;
close all;

fig = figure(1);
disp('LOADING the DATA ...');
[nodes, edges] =load_g2o('data\input_INTEL_g2o.g2o');
% [nodes, edges] =load_g2o('data\input_M3500_g2o.g2o');
% [nodes, edges] =load_g2o('data\input_MITb_g2o.g2o');


plot_graph(fig, nodes, '-r');
title('2D SLAM smoothing-based initial graph.');
legend('Initial Trajectory');
for i=1:length(nodes)
nodes{i}.state(3) = normalize_theta(nodes{i}.state(3));  
end


% build the optimization problem
disp('Smoothing operation in process...');
iteration = 0;
delta_norm = 1;

while delta_norm > 1e-2
    H = zeros(3 *length(nodes));
    b = zeros(3 *length(nodes),1);
    for i=1:length(edges)
        edge = edges{i};
        node1 = get_node(nodes, edge.id1);
        node2 = get_node(nodes, edge.id2);
        id1 = edge.id1;
        id2 = edge.id2; 
    % residual calculation
    % start with orientation
        theta_i = node1.state(3);
        theta_j = node2.state(3);
        R_i = [cos(theta_i) -sin(theta_i); 
                sin(theta_i) cos(theta_i)];
%       R_j = [cos(theta_j) -sin(theta_j); 
%            sin(theta_j) cos(theta_j)];  
        theta_i_j = edge.meas(3);
%       R_i_j = [cos(theta_i_j) -sin(theta_i_j); 
%            sin(theta_i_j) cos(theta_i_j)];
% orientation error
        delta_theta = normalize_theta(theta_i_j - normalize_theta(theta_j - theta_i));
%        res_R = R_i_j' * R_i' * R_j;
% position error
        p_1 = node1.state(1:2)';
        p_2 = node2.state(1:2)';
        p2_1 = edge.meas(1:2)';
        delta_p = p2_1  - R_i' *(p_2 - p_1);
    
    % compute Jacobians node i
        dx1_theta_i = -sin(theta_i) * (node2.state(1) - node1.state(1)) + cos(theta_i) * (node2.state(2) - node1.state(2));
        dy1_theta_i = -cos(theta_i) * (node2.state(1) - node1.state(1)) - sin(theta_i) * (node2.state(2) - node1.state(2));
    
        Aij = [-cos(theta_i), -sin(theta_i), dx1_theta_i;
                sin(theta_i), -cos(theta_i), dy1_theta_i;
                 0, 0, -1];
    % Jacobian with respect to J
        Bij = [cos(theta_i), sin(theta_i), 0;
              -sin(theta_i), cos(theta_i), 0;
                0, 0, 1];
    % build the HESSIAN
        info = edge.info;
        H(3*id1+1:3*id1+3,3*id1+1:3*id1+3) = H(3*id1+1:3*id1+3,3*id1+1:3*id1+3) + Aij'*info*Aij;
        H(3*id1+1:3*id1+3,3*id2+1:3*id2+3) = H(3*id1+1:3*id1+3,3*id2+1:3*id2+3) + Aij'*info*Bij;
        H(3*id2+1:3*id2+3,3*id1+1:3*id1+3) = H(3*id2+1:3*id2+3,3*id1+1:3*id1+3) + Bij'*info*Aij;
        H(3*id2+1:3*id2+3,3*id2+1:3*id2+3) = H(3*id2+1:3*id2+3,3*id2+1:3*id2+3) + Bij'*info*Bij;
        
   % build the residual array
        b(3*id1+1:3*id1+3,1) = b(3*id1+1:3*id1+3,1) +  Aij' * info * [delta_p; delta_theta];
        b(3*id2+1:3*id2+3,1) = b(3*id2+1:3*id2+3,1) +  Bij' * info * [delta_p; delta_theta];
    end
    H(1:3, 1:3) = 1e4* eye(3);
    x = H\b;
    delta_norm = norm(x);
    iteration = iteration + 1;
    fprintf('In iteration: %d \n',iteration);
    fprintf('Correction delta = %.4f\n',delta_norm);
    for i=1:length(nodes)
        nodes{i} = correct_node(nodes{i}, x(3*(i-1)+1:3*(i-1)+3,1));  
    end
end
disp('finished the optimization successfully');
fig = figure(2);
plot_graph(fig, nodes, 'b');
title('2D SLAM smoothing-based');
legend('Optimized trajectory');


    
  
        
        