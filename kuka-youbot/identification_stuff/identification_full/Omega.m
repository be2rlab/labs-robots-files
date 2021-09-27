function [cnd, c, ceq] = Omega(theta)

%% trajectory setup
T_MAX = 2;         % total time
nf = 5;             % qty harmonics
T = 2;
w0 = 2 * pi / T;    % base frequency
dt = 0.01;

% Constraints

cylinder_R = 0.1;
cylinder_z = 0.3;
z_min = 0;

j1 = pi * (169. + 169.) / 180.;
j2 = pi * (90. + 65.) / 180.;
j3 = pi * (146. + 151.) / 180.;
j4 = pi * (102.5 + 102.5) / 180.;
j5 = pi * (167.5 + 167.5) / 180.;
q_max = [j1 j2 -0.016 j4 j5];
q_min = [0.025 0.025 -j3 0.025 0.12];
dq_max = [1.57 1.57 1.57 1.57 1.57];
ddq_max = [1 1 1 1 1];

    %% GENERATE TRAJECTORY USING FURIER SEREAS
    ts = [];
    q = [];
    dq = [];
    ddq = [];
    c = [];
    ceq = [];
    
    i = 1;
    for t = 0:dt:T_MAX
        omega = zeros(3, 2 * nf);
        for k = 1:(2 * nf)
            if mod(k, 2) == 0
                omega(1, k) = cos(k * w0 * t);
                omega(2, k) = -sin(k * w0 * t);
                omega(3, k) = -cos(k * w0 * t);
            else
                omega(1, k) = sin(k * w0 * t);
                omega(2, k) = cos(k * w0 * t);
                omega(3, k) = -sin(k * w0 * t);
            end
        end
        qt = omega * theta;
        ts(i) = t;
        q(i, 1:5) = qt(1, 1:5);
        dq(i, 1:5) = qt(2, 1:5);
        ddq(i, 1:5) = qt(3, 1:5);
        
        %% Compute constraints
        global yb;
        yy = yb;
        T = yy.fkine(qt(1,:));
        [~, p] = tr2rt(T);   % FOR FIRST CONFIGURATION ONLY
        
        % Cartesian space.
        %   xy -- space (vertical cylinder with h = cylinder_z)
        c1 = 0;
        if p(3) <= cylinder_z
            c1 = cylinder_R - sqrt(p(1)^2 + p(2)^2);
        end
        % z -- bound
        c2 = z_min - p(3);
        
        % Joint space
        % q -- min, max
        c3 = qt(1, 1:5) - q_max;
        c4 = qt(1, 1:5) - q_min;
        % dq, ddq -- max
        c5 = qt(2, 1:5) - dq_max;
        % c6 = qt(3, 1:5) - dq_max;

        % dq(0) = 0
        ceq1 = zeros(5,1);
        if t == 0
            ceq1 = qt(2, 1:5)';
        end
               
        c = vertcat(c, [c1;c2;c3';c4';c5']);
        ceq = vertcat(ceq, ceq1);
        i = i + 1;
    end

    %% Compute criteria
    bigD = getD(q(1,:), dq(1,:), ddq(1,:));
    parfor i = 2:length(q(:,1))
        D = getD(q(i,:), dq(i,:), ddq(i,:));
        bigD = vertcat(bigD, D);
    end
    cnd = cond(bigD);   % minimize it!

end

