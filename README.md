# 2d_SLAM
Smoothing-based SLAM for 2D LiDAR data in g2o format.

This is a simple implementation of the smoothing-based SLAM taken from Dr. Patrick Geneva 
who has taken Luca Carlone's preprocessed data as a g2o file. the original data is a LiDAR 2D measurements
but here is simplig=fied to a g2o file format. the optimizer follows the paper "A TUTORIAL ON GRAPH-BASED SLAM" by Grisetti et al.
if you want to modify the code for another set of data please be careful whemn loading the measurements and refer to g2o file 
format then compare to your data.
steps required for graph-based SLAM:
1-Load the trajectory
2-Create the graph (includes nodes, edges between nodes)
3-Normalize for rotation angle 
4-Determine the residual error and the corresponding Jacobians (for node i and node j)
5-construct the Hessian and the weighted least-squares problem.
6-Solve
7-Correct the nodes 
8- Test if the convergence condition is attained exit, or goto step(3).

This simple optimizer is able to converge in 31 iteration for MIT dataset, 6 iterations in M3500 dataset and 5 iteration in the Intel dataset. 
Results for Intel Dataset:


![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/Intel_unoptimized.png) 
![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/Intel_optimized.png)


Results for M3500 Dataset:

![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/M3500_unoptimized.png) 
![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/M3500_optimized.png)


Results for MIT Dataset:

![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/MIT_unoptimized.png) 
![alt text](https://github.com/nassim12/2d_SLAM/blob/main/figures/MIT_optimized.png)

Execution:
Execute the slam.m in MATLAB, select the data filename that exist in the data folder and comment others.


note: the QR factorization for sparse Hessian had some issue therefore we eliminated it.
