
iiwa14 = importrobot('./iiwa_description/urdf/iiwa14.urdf');
% smimport(iiwa14);
iiwa14.Gravity = [0 0 -9.80665];

objectPos = 0.3;
objectPos1 = 0.0;
refPos = 0.2;
refPos1 = 0.2;

mdl_LWR_nofriction;
q0 = zeros(7,1);