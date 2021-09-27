clear;
 
mdl_youbot_mdh
q0 = -[3.3, 1.2, -1, 1.75, 6]';      % arm initial position

% Control setup
h = 0.003;  % dt-time for arm control loop
L = 0.003;   % dt-time for camera control loop
model_time = 6;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD 
Upaw = [10 10 10 10 10];
Dnaw = -[10 10 10 10 10];
Kaw = diag([1 1 1 1 1])*1;
Ki =  diag([1 1 1 1 1])*0;

Kp = diag([50 50 50 50 50]);
Kv = diag([10 10 10 10 10]);