# Gaussian Belief Propagation Algorithm for the DC State Estimation Model 

## The System Model
We present the solution of the DC state estimation (SE) problem using the Gaussian belief propagation (BP) algorithm. The DC SE model is described by the system of linear functions with real coefficients and variables. The DC model is obtained by linearisation of the non-linear model, and ignores the reactive powers and transmission losses and takes into account only the active powers. Therefore, the DC SE takes only bus voltage angles as state variables.

The measurement model can be described as the system of equations:

![equation](https://latex.codecogs.com/gif.latex?%5Cmathbf%7Bz%7D%20%3D%20%5Cmathbf%7Bh%7D%28%5Cmathbf%7Bx%7D%29&plus;%5Cmathbf%7Bu%7D)

where **x** is the vector of the state variables, **h**(**x**) is the vector of measurement functions, **z** s the vector of measurement values, and **u** is the vector of uncorrelated measurement errors. The SE problem in transmission grids is commonly an overdetermined system of equations. Note that phase shifting transformers are neglected.

The set of DC model measurements involves only active power flows and active power injection from legacy measurements, and without loss of generality, we can include a bus voltage angle from phasor measurement units (PMUs). The DC state estimate, which is a solution to the weighted least-squares problem is obtained through the non-iterative procedure by solving the system of linear equations:

![wls](https://latex.codecogs.com/gif.latex?%28%5Cmathbf%7BH%7D%5ET%5Cmathbf%7BW%7D%5Cmathbf%7BH%7D%29%5Cmathbf%7Bx%7D%20%3D%20%5Cmathbf%7BH%7D%5ET%5Cmathbf%7BW%7D%5Cmathbf%7Bz%7D)

where **H** is the Jacobian matrix of linear functions or the coefficient matrix for our system, and **W** is a diagonal matrix containing inverses of measurement variances. 

Further, the solution to the problem can be found via maximization of the likelihood function which is defined via likelihoods of independent measurements, and that can be efficiently solved utilizing factor graphs and the Gaussian BP algorithm. 

## Input Data
Input data is located in the dataSE.mat file, and can be created using MATLAB package Measurement_Configuration. The structure of the input keeps the general format of the State_Estimation MATLAB package and contains:
1. dataSE.system - contains general information about the power system:
   - bus (bus number, initial value of voltage magnitude and angle, shunt element data);
   - line (from bus to bus, resistance, inductance, charging susceptance);
   - transformer (from bus to bus, resistance, inductance, tap ratio);
   - slack (bus number, angle value);
   - baseMVA;
2. dataSE.legacy - contains legacy measurements:
   - flow (from bus to bus, measurement value, turn on/off, standard deviation, exact value if exists);
   - injection (bus, measurement value, turn on/off, standard deviation, exact value if exists);
3. dataSE.pmu - contains phasor measurements:
   - voltage (bus, measurement value, turn on/off, standard deviation, exact value if exists);


 ## User Options
1. Post-Processing Options:
   - **user.radius** - compute spectral radius for synchronous and randomized damping scheduling, if the spectral radius is less than 1 the BP algorithm converges;
   - **user.error**  - compute mean absolute error, root mean square error and weighted residual sum of squares for the solution;

2. Design of Iteration Scheme:
   - **user.stop** - the BP algorithm in the iteration loop is running until the criterion is reached, where the criterion is applied on the vector of mean-value messages from factor nodes to variable nodes in two consecutive iterations;
   - **user.maxi** - the upper limit on BP iterations;

3. Convergence Parameters:
   - **user.prob** - a Bernoulli random variable with probability "prob" independently sampled for each mean value message from indirect factor node to a variable node, with values between 0 and 1;
   - **user.alph** - the damped message is evaluated as a linear combination of the message from the previous and the current iteration,
               with weights "alph" and 1 - "alph", where "alph" is between 0 and 1;

Note: We use an improved BP algorithm that applies synchronous scheduling with randomized damping. The randomized damping parameter pairs lead to a trade-off between the number of non-converging simulations and the rate of convergence. In general, for the selection of "prob" and "alph" for which only a small fraction of messages are combined with their values in a previous iteration, and that is a case for "prob" close to 0 or "alph" close to 1, we observe a large number of non-converging simulations.

4. Virtual Factor Nodes
   - **user.vari** - the variance value of the virtual factor nodes;

Note: The virtual factor node is a singly-connected factor node used if the variable node is not directly measured. In a usual scenario, without prior knowledge, the variance of virtual factor nodes tend to infinity. 

## Examples
 - dc_ieee14_15_5: IEEE 14-bus test case with 14 buses, 15 lines and 5 transformes
 - dc_ieee118_177_9: IEEE 118-bus test case with 118 buses, 177 lines and 9 transformes 
 - dc_ieee300_304_107 IEEE 300-bus test case with 300 buses, 304 lines and 107 transformes
 - dc_data1354_1757_234: power system with 1354 buses, 1757 lines and 234 transformes
 - dc_toy_3_3_0: toy example with 3 buses and 3 lines given in [arxiv.org](https://arxiv.org/pdf/1811.08355.pdf)


## More information: 
- M. Cosovic and D. Vukobratovic, "Distributed Gauss-Newton Method for State Estimation Using Belief Propagation," in IEEE Transactions on  Power Systems, vol. 34, no. 1, pp. 648-658, Jan. 2019. [arxiv.org](https://arxiv.org/pdf/1702.05781.pdf)
- M. Cosovic, "Design and Analysis of Distributed State Estimation Algorithms Based on Belief Propagation and Applications in Smart Grids." arXiv preprint arXiv:1811.08355 (2018). [Appendix B](https://arxiv.org/pdf/1811.08355.pdf)

## Citations
If you have used the model in publications, we would appreciate citations to the following paper:

M. Cosovic and D. Vukobratovic, "Fast real-time DC state estimation in electric power systems using belief propagation," 2017 IEEE International Conference on Smart Grid Communications (SmartGridComm), Dresden, 2017, pp. 207-212.
