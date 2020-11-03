%MDL_YOUBOT Create model of KUKA youBot manipulator
%
% using standard DH conventions.
%
% Also define the workspace vectors:
%   qz         zero joint angle configuration
%   qr         arm along +ve x-axis configuration
%
%
% Notes::
% - SI units of metres are used.
% - Unlike most other mdl_xxx scripts this one is actually a function that
%   behaves like a script and writes to the global workspace.
%

% MODEL: KUKA, youbot, 5DOF, standard_DH

function r = mdl_youbot_mdh()
    
    deg = pi/180;
    
    a1 = 0.033;
    a2 = 0.155;
    a3 = 0.135;
    d1 = 0.147;
    d2 = 0.1136;
    d3 = 0;
    rl = 0.02; %!!! Just imaging radius of links.

    mass = [0.139 1.318 0.821 0.769 0.091];

    center_of_mass = [
        a1/2,   0,      -0.03
        a2/2,   0,      0
        a3/2,   0,      0
        0,      d2/2,   0
        0,      0,      0
    ];

    % in COG reference frame
    inertia = [
        [0,                 0,                  0.5*mass(1)*a1^2 0, 0, 0]
        [0.5*mass(2)*rl^2,  1/3*mass(2)*a2^2,   1/3*mass(2)*a2^2, 0, 0, 0]
        [0.5*mass(3)*rl^2, 	1/3*mass(3)*a3^2, 	1/3*mass(3)*a3^2, 0, 0, 0]
        [1/3*mass(4)*d2^2, 	0.5*mass(4)*rl^2, 	1/3*mass(4)*d2^2, 0, 0, 0]
        [1/3*mass(5)*d3^2,  1/3*mass(5)*d3^2,   0.5*mass(5)*rl^2, 0, 0, 0]
    ];

    clear L
    %            theta    d        a    alpha
    L(1) = Link([  0      0.147    0       0       0], 'modified');
    L(2) = Link([  0      0.       0.033   pi/2    0], 'modified');
    L(3) = Link([  0      0        0.155   0       0], 'modified');
    L(4) = Link([  0      0        0.135   0       0], 'modified');
    L(5) = Link([  0      0.1136       0   pi/2    0], 'modified');
    
    robot = SerialLink(L, 'name', 'youbot_mdh', 'manufacturer', 'KUKA');
    
    % add dynamics' parameters to the links
    links = robot.links;
    for i=1:5
         links(i).m = mass(i);
         links(i).r = center_of_mass(i,:);
         links(i).I = inertia(i, :);
    end

   
    % place the variables into the global workspace
    if nargin == 1
        r = robot;
    elseif nargin == 0
        assignin('caller', 'youbot_mdh', robot);
        assignin('caller', 'qz', [0 3*pi/4 -pi/4 0 0]); % zero angles
        assignin('caller', 'qr', [0 90 0 90 0]*deg); % vertical pose
    end
end