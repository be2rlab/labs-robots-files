classdef very_good_trajectory
    % Class contains stuff for manipulator trajectory optimization in Joint space.
    %   !!!BE CAREFUL: all constraints set permanently below.
    
    properties (Access=public)
        %% Trajectory parameters
        T;          % the period or trajectory duration
        nf;         % quantity of harmonics
        dt;         % time step
        f0;         % base frequency [Hz]
        w0;         % base frequency [rad s^-1]
        
        %% Values using in optimization
        t;          % time vector '[0:dt:T]'
        n;          % quantity of points in trajectory or 'length(t)' ;)        
        
        %% Some constraints
        %   Joint space
        q_max = [5.8   2.7  -5.1   3.5   5.8];
        q_min = [0.03   0.03  -0.02   0.03   0.15];
        dq_max = [1.57 1.57 1.57 1.57 1.57];
        ddq_max = [1 1 1 1 1];
        %   Cartesian space
        R = 0.1;    % radius of the cylinder around manipulator
        h = 0.3;    % hight of the cylinder
        z_min = 0;  % "floor" constraint
    end
    
    methods (Access=public)
        function this = very_good_trajectory(varargin)
            % Construct an instance of this class
            format long
            if nargin == 3
                this.T= varargin{1};
                this.nf = varargin{2};
                this.dt = varargin{3};
            else
                this.T= 25.0;
                this.nf = 10;
                this.dt = 0.1;
            end
            this.f0 = 1 / this.T;
            this.w0 = 2 * pi * this.f0;
            
            this.t = 0:this.dt:this.T;
            this.n = length(this.t);
        end
        
        function theta = run(this)
%             a0 = [q_max(1)-q_min(1)    q_max(2)-q_min(2)   q_max(3)-q_min(3)   q_max(4)-q_min(4)   q_max(5)-q_min(5)];
            theta_0 = [
                6.014507999658107   2.717844136021814   0.571708496762112   4.937639375942945   5.875649127077028
                0.328443866754366   0.601663689951177   0.012944301138930   0.015640798995326   0.105074940073599
                0.040226058684411  -0.163749926812920  -0.016547213695594  -0.289727341267771  -0.082712110638739
                -0.166168514086318  -0.168656873037376  -0.112493937786726  -0.335985625763251   0.242398418634507
                0.128235989282235  -0.303244599565333  -0.095657161342600   0.131657143586947   0.132278232134614
                0.228452273219671   0.044533156502971   0.144120072224300   0.401435143918384  -0.009819192307558
                -0.032960654516744   0.317750607983787   0.267787740513585   0.253633255036299   0.276477635445163
                0.262016387824313   0.137951455910991  -0.048058207891430  -0.117866388028647  -0.495140565021261
                0.169866006002317  -0.123960956864650   0.152132392028783   0.234841591198653  -0.025472214603307
                0.119361486591292  -0.058769776004137   0.077506797813364   0.165489444450511  -0.108852637524322
                -0.384153413438768   0.259611932750101   0.281439128670884   0.204717398500338   0.227949287561003
            ]*10;
        
            theta_0 = [
                5.925260275707219   2.959720679903285  -5.261765915816745   3.550721367212768   6.122469703060093
                0.445726336502872   0.712936960911515  -0.126082047096245   0.299098089176665  -1.450456185704788
                -0.532558421450480  -0.087130276808436  -0.415800484436875  -0.193967224844152  -0.323886597254093
                -0.036147565980039  -0.008150229676166  -0.885024847581940  -0.601384796106885  -0.423382613973607
                0.198336449395625   0.111582337646144  -0.178958931832993  -0.269221226189068   0.107893264088271
                0.181280109781310  -0.327995482345877   0.059660360831262   0.359696593044088  -0.119122754461175
                -0.026458328944177   0.087096828254104   0.057716925526326  -0.243982914707818   0.195983533394569
                0.257713734557345   0.160243598328711  -0.051797943647113   0.115669580087537  -0.165177901819552
                0.057313732437110  -0.247121794117293  -0.050386370138904   0.159758567398534  -0.024895742257296
                0.240922706210564   0.006111803414790   0.034788389795843   0.023307769997343  -0.070437238550058
                -0.216034530415415   0.120977288470574   0.176265288265676  -0.025067935304975  -0.065137571957453  
            ];
        
            options = optimoptions('fmincon', 'Display','iter','UseParallel',true,'MaxFunctionEvaluations',3000, 'MaxIterations', 1000, 'Algorithm','interior-point');

            tic
            [theta,fval,exitflag,output] = fmincon(@this.objfun, theta_0, [],[],[],[],[],[], @this.constr, options);
            toc
            
            this.plot_trajectory(theta);
            %save('theta');            
        end

        function cnd = objfun(this, theta)
            cnd = this.condOmega(theta);
        end

        function [c, ceq] = constr(this, theta)
            [~, c, ceq] = this.condOmega(theta);
        end
        
        %#ok<*PROPLC>
        %#ok<*PFBNS>
        function [cnd, c, ceq] = condOmega(this, theta)
            % The objective function.
            %   Try to minimize `cond(\Omega(q, dq, ddq))`
            c = [];
            ceq = [];
            bigD = [];
            
            %% Generate trajectory + constraints to each point
            t = this.t;
            parfor i = 1:this.n     % for each trajectory point
                ti = t(i);
                [q, dq, ddq] = this.getQi(theta, ti);

                D = getD(q, dq, ddq);
                bigD = vertcat(bigD, D);

                %% Nonlinear constraints in form `c(theta) <= 0`
                %   Joint space
                c1 = q - this.q_max;            % maximum q limit
                c2 = this.q_min - q;            % minimum q limit
                c3 = abs(dq) - this.dq_max;     % maximum `abs(dq)` limit
                c = horzcat(c, [c1, c2, c3]);   % vector `[1, 15]`

%                 %   Cartesian space
%                 %       Compute position of EE
%                 p = this.forwart_kinematics_youbot(qi(1,:));
%                 %       xy -- space (vertical cylinder)
%                 c4 = 0;
%                 if (p(3) >= this.z_min) && (p(3) <= this.h)
%                     c4 = this.R - sqrt(p(1)^2 + p(2)^2);
%                 end
%                 %       "floor" plane
%                 c5 = this.z_min - p(3);
%                 c = horzcat(c, [c4, c5]);
            end
            
            %% Compute criteria
            cnd = cond(bigD);
        end
        
        function [q, dq, ddq] = getQi(this, theta, ti)
            nf = this.nf; 
            w0 = this.w0; 
            
            m = 2 * nf + 1;
            
            omega = zeros(3, m);
            omega(1, 1) = 0.5;
            for k = 2:m
                if mod(k, 2) == 0
                    omega(1, k) = cos(k * w0 * ti);
                    omega(2, k) = -k * w0 * sin(k * w0 * ti);
                    omega(3, k) = -(k * w0)^2 * cos(k * w0 * ti);
                else
                    omega(1, k) = sin(k * w0 * ti);
                    omega(2, k) = k * w0 * cos(k * w0 * ti);
                    omega(3, k) = -(k * w0)^2 * sin(k * w0 * ti);
                end
            end
            Q = omega * theta;
            
            q = Q(1,:);
            dq = Q(2,:);
            ddq = Q(3,:);
        end
        
        function p = forwart_kinematics_youbot(this, q)
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
        
        function plot_trajectory(this, theta)
            % Flot manipulator trajectories for `theta`
            Q = [];
            dQ = [];
            ddQ = [];
            parfor j = 1:this.n
                [q, dq, ddq] = this.getQi(theta, this.t(j));
                Q = vertcat(Q, q);
                dQ = vertcat(dQ, dq);
                ddQ = vertcat(ddQ, ddq);
            end
            
            for i = 1:length(Q(1,:))
                subplot(5,3,(i-1) * 3 + 1);
                p = plot(this.t, Q(:,i), 'k', this.t, ones(length(this.t),1) * this.q_max(i), 'r', this.t, ones(length(this.t),1) * this.q_min(i), 'g');
                grid on;
                sy = ylabel('$q, [rad]$','interpreter','latex')                
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex')
                end
                
                subplot(5,3,(i-1) * 3 + 2);
                plot(this.t, dQ(:,i), 'k', this.t, ones(length(this.t),1) * this.dq_max(i), 'r', this.t, -ones(length(this.t),1) * this.dq_max(i), 'g');
                grid on;
                sy = ylabel('$\dot{q}, [rad]$','interpreter','latex')                
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex')
                end
                
                subplot(5,3,(i-1) * 3 + 3);
                plot(this.t, ddQ(:,i), 'k', this.t, ones(length(this.t),1) * this.ddq_max(i), 'r', this.t, -ones(length(this.t),1) * this.ddq_max(i), 'g');
                grid on;
                sy = ylabel('$\ddot{q}, [rad]$','interpreter','latex')                
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex')
                end
            end
        end
    end
end
