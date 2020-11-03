function [cnd, c, ceq] = Omega_parallel(theta)

    %% trajectory setup
    T = 25;
    nf = 5;             % qty harmonics
    f = 1/T;            % freq
    w0 = 2 * pi * f;    % base frequency
    dt = 0.1;          % 

    q_max = [5.899212871740834   2.705260340591211  -0.016000000000000   3.577924966588375   5.846852994181003];
    q_min = [0.025000000000000   0.025000000000000  -5.183627878423159   0.025000000000000   0.120000000000000];
    dq_max = [1.57 1.57 1.57 1.57 1.57];

    %% GENERATE TRAJECTORY USING FURIER SEREAS
    len = T / dt+1;
   
    c = [];
    ceq = [];
    bigD = [];

    tt = (0:dt:T);
    parfor i = 1:len
        t = tt(i);
        omega = zeros(3, 2 * nf + 1);
        omega(1,1) = 0.5;
        for k = 2:(2 * nf + 1)
            if mod(k, 2) == 0
                omega(1, k) = cos(k * w0 * t);
                omega(2, k) = -k * w0 * sin(k * w0 * t);
                omega(3, k) = -(k * w0)^2 * cos(k * w0 * t);
            else
                omega(1, k) = sin(k * w0 * t);
                omega(2, k) = k * w0 * cos(k * w0 * t);
                omega(3, k) = -(k * w0)^2 * sin(k * w0 * t);
            end
        end
        qt = omega * theta;

        c3 = qt(1, :) - q_max;
        c4 = q_min - qt(1, :);
        c5 = qt(2, 1:5) - dq_max;
        c = vertcat(c, [c3, c4, c5]');
 
        D = getD(qt(1,:), qt(2,:), qt(3,:));
        bigD = vertcat(bigD, D);
    end
    c = c';
    c = c(:);

    
    cnd = cond(bigD);   % minimize it!
end

