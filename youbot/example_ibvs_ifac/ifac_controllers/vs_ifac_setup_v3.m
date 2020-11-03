clear;
set(0, 'DefaultFigureRenderer', 'painters');
 
addpath(genpath('/home/kika/matlab/toolbox/rvctools'));
addpath(genpath('/home/kika/Desktop/desktop/youbot_matlab/sl_youbot'));
cd /home/kika/Desktop/desktop/youbot_matlab/sl_youbot/controllers_comparation/ifac_controllers

%% Setup robot + camera models
mdl_youbot_mdh %%%%%!!! changed last link inertia
cam = CentralCamera('default');
P = mkgrid(2, 0.5, troty(pi/2) * transl(-0.35,0,2.1));  % marker position relative end-effector frame
q0 = -[3.3, 1.2, -1, 1.75, 6]';      % arm initial position

% Show arm-camera config and SETUP p, p_des image points
T = youbot_mdh.fkine(q0);
youbot_mdh.plot(q0');
p0 = cam.plot(P, 'pose', T);
p_des = [412 412 612 612; 412 612 612 412];


% Control setup
h = 0.003;  % dt-time for arm control loop
L = 0.003;   % dt-time for camera control loop
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

Upaw = [10 10 10 10 10];
Dnaw = -[10 10 10 10 10];
Kaw = diag([1 1 1 1 1])*1;
Ki =  diag([1 1 1 1 1])*0;


variation = 0.05;    %!!! Set a variation of parameters in dynamic controller
addMass = 0.3;      %!!! Add mass to end-link

% variation = 0.00;    %!!! Set a variation of parameters in dynamic controller
% addMass = 0.0;      %!!! Add mass to end-link


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD + nominal gravity
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD 
Kp = diag([50 50 50 50 50]);
Kv = diag([10 10 10 10 10]);

gvariation = 0.00;    %!!! Set a variation of parameters in dynamic controller
gaddMass = 0.0;      %!!! Add mass to end-link

controller_title = "pdg";
sim('D_vs_' + controller_title); close all force; controller_title = controller_title + "_ng";
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
ws1 = ws;
ctitles1 = controller_title;
plotCustom_v2(ws, controller_title, 1);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD + estimated gravity
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD 
    Kp = diag([50 50 50 50 50]);
    Kv = diag([10 10 10 10 10]);

gvariation = 0.05;    %!!! Set a variation of parameters in dynamic controller
gaddMass = 0.3;      %!!! Add mass to end-link

controller_title = "pdg";
sim('D_vs_' + controller_title); close all force; controller_title = controller_title + "_eg";
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
ws2 = ws;
ctitles2 = controller_title;
plotCustom_v2(ws, controller_title, 1);


% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Computed torque control
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Computed torque control
% q0 = -[3.3, 1.2, -1, 1.75, 1]';      %!!! arm initial position FOR TUNING
Kp = diag([0.5 0.5 0.5 0.5 0.5])*1.5;
Kv = diag([0.1 0.1 0.1 0.1 0.1])*1.5;

controller_title = "ctorque";
sim('D_vs_' + controller_title); close all force;
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
ws3 = ws;
ctitles3 = controller_title;
plotCustom_v2(ws, controller_title, 1);


% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDC
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDC
% omega = [1.2 1.2 1.1 1 0.9] * 7;
% Kp = diag(omega .^ 2);
% Kv = diag(omega .* 2);
% 
% Kp = diag([50 50 50 50 50])*2;
% Kv = diag([18 18 18 18 18])*2;

Kp = diag([50 50 50 50 50]);
Kv = diag([18 18 18 18 18]);


controller_title = "tdc";
sim('D_vs_' + controller_title); close all force;
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
ws4 = ws;
ctitles4 = controller_title;
plotCustom_v2(ws, controller_title, 1);


plotPoints(ws1, ws2, ws3, ws4, ctitles1,ctitles2,ctitles3,ctitles4);