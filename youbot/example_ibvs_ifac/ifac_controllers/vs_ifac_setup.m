clear;

addpath(genpath('/home/kika/matlab/toolbox/rvctools'));
addpath(genpath('/home/kika/Desktop/desktop/youbot_matlab/sl_youbot'));

%% Setup robot + camera models
mdl_youbot_mdh
cam = CentralCamera('default');
P = mkgrid(2, 0.5, troty(pi/2) * transl(-0.35,0,2));  % marker position relative end-effector frame
q0 = -[3.3, 1.2, -1, 1.75, 6]';      % arm initial position

% Show arm-camera config and SETUP p, p_des image points
T = youbot_mdh.fkine(q0);
youbot_mdh.plot(q0');
p0 = cam.plot(P, 'pose', T);
p_des = [412 412 612 612; 412 612 612 412];


% Control setup
h = 0.005;  % dt-time for arm control loop
L = 0.005;   % dt-time for camera control loop
model_time = 6;


%% lambda config (IBVS controller)
lambda0 = 6;
lambdainf = 2;
lambda0l = 30;
mu = 5;
v_z = 1;    % turn ON or OFF v_z

config_lambda = [lambda0 lambdainf lambda0l mu v_z];


% % % I'm isolated from the world 
% % % by a dead brick wall 
% % % when the noise is outside 
% % % I make louder pinkfloyd

% %% Simulation and ploting
% % PD
% Kp = diag([4   4   4 4 30]) * 20;
% Kv = diag([2    2   2 2 20]) * 1;
% % 
% controller_title = "pd";
% sim('vs_' + controller_title); close all force;
% namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
% vs_plot;
% q1 = -[3 1 -1 1 0.2]';
% 
% % % PD+gravity
% Kp = diag([4   4   4 4 30]);
% Kv = diag([2    2   2 2 20]);
% 
% controller_title = "pd_gravity";
% sim('vs_' + controller_title); close all force;
% namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
% vs_plot;

% %% Computed torue control
% omega = [1 1 1 1 0.5] * 10;
% Kp = diag(omega .^ 2)
% Kv = diag(omega .* 2)
% 
% 
%% TDC
Kp = diag([10 10 20 20 20])^2;
Kv = diag([10 10 20 20 20])*2;
% q1 = -[3 1 -1 1 0.2]';

% 
controller_title = "tdc";
% Kv = diag([2    2   2 2 20]) * 5;

sim('vs_' + controller_title); close all force;
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
vs_plot;



