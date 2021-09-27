% a = very_gravity
% a.run


q_0 = [];
for i = 1:100
    qi = [
        rand() * 5.7;
        rand() * 2.5;
        rand() * 4.9 - 4.9;
        rand() * 3.3;
        rand() * 5.5
    ]';
    q_0(i,:) = qi;
end

options = optimoptions('fmincon', 'Display','iter','UseParallel',true,'MaxFunctionEvaluations',150000, 'MaxIterations', 3000, 'Algorithm','interior-point');
[theta,fval,exitflag,output] = fmincon(@objfun, q_0, [],[],[],[],[],[], @constr, options);

theta
fval

function cnd = objfun(q)
    cnd = condOmega(q);
end

function [c, ceq] = constr(q)
    [~, c, ceq] = condOmega(q);
end

function [cnd, c, ceq] = condOmega(q)

q_max = [5.8   2.6  -0.03   2.4   5.6];
q_min = [0.03   0.03  -5   0.03   0.13];
dq_max = [2 1.5 3 3 3.5];
ddq_max = [1.4 1.4 2 2.5 2.5];
%   Cartesian space
R = 0.1;    % radius of the cylinder around manipulator
h = 0.25;    % hight of the cylinder
z_min = -0.02;  % "floor" constraint

    % The objective function.
    c = [];
    ceq = [];
    bigD = [];
    for j = 1:length(q(:,1))
        
        D = getD_gravity(q(j,:));
        bigD = vertcat(bigD, D);
        
        p = forwart_kinematics_youbot(q);
        c1 = q(j,:) - q_max;            % maximum q limit
        c2 = q_min - q(j,:);            % minimum q limit
        c5 = (sqrt(p(1)^2 + p(2)^2) - R);
        c6 = z_min - p(3);
        c = horzcat(c, [c1 c2 c5 c6]);
    end
    
    %% Compute criteria
    cnd = cond(bigD);
end


function p = forwart_kinematics_youbot(q)
    % FK for KUKA youBot
    %   DH parameters
    alpha = [pi/2, 0, 0, pi/2, 0];
    a = [0.033, 0.155, 0.135, 0, 0];
    d = [0.147, 0, 0, 0, 0.1136];
    offset = [169.0, 65.0 + 90, -146.0, 102.5 + 90, 167.5] * pi/180;

    H = eye(4, 4);
    for j = 1:5
        th = offset - q;
        %TODO: Check this matrix
        A = [
            cos(th(j)),     -cos(alpha(j)) * sin(th(j)),    sin(alpha(j)) * sin(th(j)),     a(j) * cos(th(j));
            sin(th(j)),     cos(alpha(j)) * cos(th(j)),     -sin(alpha(j)) * cos(th(j)),    a(j) * sin(th(j));
            0,              sin(alpha(j)),                  cos(alpha(j)),                  d(j);
            0,              0,                              0,                              1
        ];
        H = H * A;
    end
    p = H(1:3, 4);
end


% 
% 
% 
% cnd = [];
% bigD = [];
% 
% for i = 1:100
%     q_0 = [
%         rand() * 5.7;
%         rand() * 2.5;
%         rand() * 4.9 - 4.9;
%         rand() * 3.3;
%         rand() * 5.5
%     ]';
% 
%     bigD = vertcat(bigD, getD_gravity(q_0));
% 
%     cnd(i) = cond(bigD);
% end
% 
% plot(2:10, cnd(2:10))




