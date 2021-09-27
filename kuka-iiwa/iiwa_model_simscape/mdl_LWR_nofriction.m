%MDL_LWR Create model of Kuka LWR manipulator
%
% MDL_LWR is a script that creates the workspace variable KR5 which
% describes the kinematic characteristics of a Kuka KR5 manipulator using
% standard DH conventions.
%
% Also define the workspace vectors:
%   qz        all zero angles
%
% Notes::
% - SI units of metres are used.
%
% Reference::
% - Identifying the Dynamic Model Used by the KUKA LWR: A Reverse Engineering Approach
%   Claudio Gaz Fabrizio Flacco Alessandro De Luca
%   ICRA 2014
%
% See also mdl_kr5, mdl_irb140, mdl_puma560, SerialLink.

% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

% MODEL: Kuka, LWR, 7DOF, standard_DH

d1 =0.4; d2 = 0.39;
deg = pi/180;

%All link lengths and offsets are measured in m
clear L
%            theta    d           a       alpha
% links = [
% 	    Link([0        0           0       pi/2])
%         
% 		Link([0        0           0      -pi/2])
% 		Link([0        d1          0      -pi/2])
%         
% 		Link([0        0           0       pi/2])
% 		Link([0        d2          0       pi/2])
%         
% 		Link([0        0           0       -pi/2])
% 		Link([0        0           0       0])
% 	];

% all parameters are in SI units: m, radians, kg, kg.m2, N.m, N.m.s etc.
L(1) = Revolute('d', 0, ...   % link length (Dennavit-Hartenberg notation)
    'a', 0, ...               % link offset (Dennavit-Hartenberg notation)
    'alpha', pi/2, ...        % link twist (Dennavit-Hartenberg notation)
    'I', [0.0038166, 0.0038166, 0.0036, 0, 0, 0], ... % inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
    'r', [0, -0.03, 0.12], ...       % distance of ith origin to center of mass [x,y,z] in link reference frame
    'm', 4, ...               % mass of link
    'qlim', [-120 120]*deg );

L(2) = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, ...
    'I', [0.05, 0.018, 0.044, 0, 0, 0], ...
    'r', [0.0003, 0.059, 0.042], ...
    'm', 4, ...
    'qlim', [-170 170]*deg );

L(3) = Revolute('d', d1, 'a', 0, 'alpha', -pi/2, ...
    'I', [0.08, 0.075, 0.01, 0, 0, 0], ...
    'r', [0, 0.03, 0.13], ...
    'm', 3, ...
    'qlim', [-120 120]*deg );

L(4) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, ...
    'I', [0.03, 0.01, 0.029, 0, 0, 0], ...
    'r', [0, 0.007, 0.034], ...
    'm', 2.7, ...
    'qlim', [-170 170]*deg );

L(5) = Revolute('d', d2, 'a', 0, 'alpha', pi/2, ...
    'I', [0.02, 0.018, 0.005, 0, 0, 0], ...
    'r', [0.0001, 0.021, 0.076], ...
    'm', 1.7, ...
    'qlim', [-120 120]*deg );

L(6) = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, ...
    'I', [0.005, 0.0036, 0.0047, 0, 0, 0], ...
    'r', [0, 0.0006, 0.0004], ...
    'm', 1.8, ...
    'qlim', [-176 175]*deg );

L(7) = Revolute('d', 0, 'a', 0, 'alpha', 0, ...
    'I', [0.001, 0.001, 0.001, 0, 0, 0], ...
    'r', [0, 0, 0.02], ...
    'm', 0.3, ...
    'qlim', [-180 180]*deg );

LWR=SerialLink(L, 'name', 'Kuka LWR');

qz = [0 0 0 0 0 0 0];
