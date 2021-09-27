clear;

addpath(genpath('/home/kika/matlab/toolbox/rvctools'));
addpath(genpath('/home/kika/Desktop/desktop/youbot_matlab/sl_youbot'));

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

% %% Simulation and ploting
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD
Kp = diag([4   4   4 100 0.05]) * 20;
Kv = diag([2    2   2 100 0.02]) * 1;

Kp = diag([50 50 50 50 100]);
Kv = diag([10 10 10 10 50]);



Kp = [2    10 1 1 1];
Kv = [0.5  3 1 1 1];
sim('vs_cc_setup')

controller_title = "pd";
sim('vs_' + controller_title); close all force;
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
plotCustom_v2(ws, controller_title);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD + gravity
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD + gravity
Kp = diag([4   4   4 4 30]);
Kv = diag([2    2   2 2 20]);

controller_title = "pd_gravity";
sim('vs_' + controller_title); close all force;
namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
plotCustom_v2(ws, controller_title);

% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Computed torque control
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Computed torque control
% omega = [3 3 4 9 10] * 10;
% Kp = diag(omega .^ 2);
% Kv = diag(omega .* 2);
% Kp(5,5) = 1000;
% Kv(5,5) = 100000000;
% 
% controller_title = "computed_torque";
% sim('vs_' + controller_title); close all force;
% namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
% plotCustom_v2(ws, controller_title);
% 
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDC
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDC
% Kp = diag([10 13 13 9 15])^2;
% Kv = diag([10 13 13 9 15])*2;
% 
% controller_title = "tdc";
% sim('vs_' + controller_title); close all force;
% namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
% plotCustom_v2(ws, controller_title);arc
% 
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CC
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CC
W =     diag([50 50 100 100 100]);
Sigma = diag([200 200 300 300 300]);
K1 =    diag([0.03 0.03 0.05 0.08 5]);
% 
% controller_title = "cc";
% sim('vs_' + controller_title); close all force;
% namespace = controller_title + '_ws'; save(controller_title + '_ws'); ws = sim_namespace(controller_title + '_ws');
% plotCustom_v2(ws, controller_title);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % f = figure(1);
% % hold on;
% % controller_title = "pd";
% % ws = sim_namespace(controller_title + '_ws');
% % ws = ws.q_e.getsamples([1:1000])
% % subplot(2,1,1);
% % plot(ws.q_e);
% % subplot(2,1,2);
% % plot(ws.dq_e);
% % 
% % controller_title = "pd_gravity";
% % ws = sim_namespace(controller_title + '_ws');ws.dq_e.TimeInfo.setlength(1000)
% % ws = ws.dq_e.TimeInfo.setlength(1000);
% % subplot(2,1,1);
% % plot(ws.q_e);
% % subplot(2,1,2);
% % plot(ws.dq_e);
% % 
% % controller_title = "computed_torque";
% % ws = sim_namespace(controller_title + '_ws');ws.dq_e.TimeInfo.setlength(1000)
% % ws = ws.dq_e.TimeInfo.setlength(1000);
% % subplot(2,1,1);
% % plot(ws.q_e);
% % subplot(2,1,2);
% % plot(ws.dq_e);
% % 
% % controller_title = "tdc";
% % ws = sim_namespace(controller_title + '_ws');ws.dq_e.TimeInfo.setlength(1000)
% % ws = ws.dq_e.TimeInfo.setlength(1000);
% % subplot(2,1,1);
% % plot(ws.q_e);
% % subplot(2,1,2);
% % plot(ws.dq_e);
% % 
% % subplot(2,1,1);
% % legend("pd", "pd plus gravity", "computed torque", "tdc");
% % hold off;
% % 
% % for i = 1:2
% %     f.Children(i).Title.String = '';
% %     f.Children(i).YLabel.Interpreter = 'latex';
% %     f.Children(i).YLabel.FontSize = 20;
% %     f.Children(i).XLabel.String = "t, s";
% %     f.Children(i).XLabel.FontSize = 20;
% %     
% %     f.Children(i).YLabel.Position(1) = -0.45;
% %     f.Children(i).LineWidth = 1;
% %     for j = 1:length(f.Children(i).Children)
% %         f.Children(i).Children(j).LineWidth = 2;ws.dq_e.TimeInfo.setlength(2)
% %     end
% % end
% % f.Children(1).YLabel.String = "$\tilde{q}$";
% % f.Children(2).YLabel.String = "$\tilde{\dot{q}}$";
% % 
