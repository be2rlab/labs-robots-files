addpath(genpath('/home/kika/MATLAB Add-Ons/Toolboxes'))
addpath(genpath('/home/kika/phd/icra2020'))

% mdl_LWR
mdl_LWR_nofriction
cam = CentralCamera('default');
P = mkgrid(2, 0.5, troty(pi/2)*transl(-0., 0., 2.4)*trotz(-pi/2));  % marker position relative end-effector frame
% q0 = [0 -pi/4 0 pi/2 0 pi/4 -pi/2];      % arm initial position
q0 = [0,0,0,pi/2,0,0,0];      % arm initial position
q0 = [0,0,0,pi/2,0,-pi/2,0];
qf = [0,-pi/4,0,2*pi/4,0,-pi/4,0];

qf = [0,-pi/4,0,2*pi/4,0,-pi/12,0];
q0 = qf

q0 = [pi/8,0,0,pi/4,0,-pi/8,0];
q0 = zeros(7,1);

T = LWR.fkine(q0);
p = cam.plot(P, 'pose', T);
LWR.plot(q0);

x0 = [T.t', tr2rpy(T)];

% R = SE3.Rz(pi);

syms q1 q2 q3 q4 q5 q6 q7
q = [q1, q2, q3, q4, q5, q6, q7];




