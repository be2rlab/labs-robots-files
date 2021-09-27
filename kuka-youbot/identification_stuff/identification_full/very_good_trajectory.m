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
        q_max = [5.8   2.6  -0.03   3.4   5.6];
        q_min = [0.03   0.03  -5   0.03   0.13];
        dq_max = [2 1.5 3 3 3.5];
        ddq_max = [1.4 1.4 2 2.5 2.5];
        %   Cartesian space
        R = 0.1;    % radius of the cylinder around manipulator
        h = 0.25;    % hight of the cylinder
        z_min = -0.02;  % "floor" constraint
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
                this.T= 60.0;
                this.nf = 5;
                this.dt = 0.1;
            end
            this.f0 = 1 / this.T;
            this.w0 = 2 * pi * this.f0;
            
            this.t = 0:this.dt:this.T;
            this.n = length(this.t);
        end
        
        function theta = rungs(this)
            % cond = ~31
            theta_0 = [
                5.532896209044273   2.714742585011139  -5.172376862459261   3.134137883262083   5.634327323224040
                -0.874050077669249   1.233356201019922  -0.377118602400134   1.418048149323342  -1.298991250903981
                -1.090821276825003   0.162924938202791  -1.006612136208710  -0.434557366965356  -1.471401953360984
                0.642446609497155   0.062785664015046   0.447610593982212   0.548238787597933  -0.527636554596449
                0.040865176657126  -0.112197831032224   0.496117744496875   0.098095980865888   0.169657158629220
                -0.078443934803063  -0.306902404687304   0.336503374016954  -0.256996128254582   0.012554604641967
                0.019112787235964  -0.088724092934700  -0.127985502312330   0.135781996695520   0.071312625114176
                -0.047827206615964  -0.034503057911390  -0.013983820571016  -0.103965988452860  -0.105308142348627
                -0.054106836190747   0.044955964095490   0.005709522267217  -0.063010667899747   0.042849157683326
                -0.076517357826589   0.069711128048605   0.074073110685500   0.065953533512340  -0.012260304388348
                0.052861801278310   0.036373348135205   0.073186551993161  -0.087401931714144   0.068514327836946
            ];
%             opts = optimoptions(@fmincon, 'Algorithm','sqp', 'Display','iter','UseParallel', true, 'MaxFunctionEvaluations',150000, 'MaxIterations', 3000);
            opts = optimoptions(@fmincon, 'Algorithm','interior-point', 'Display','iter','UseParallel', true, 'MaxFunctionEvaluations',500000, 'MaxIterations', 5000);
            problem = createOptimProblem('fmincon','objective',@this.objfun,'x0',theta_0,'nonlcon',@this.constr,'options',opts);
%             problem = createOptimProblem('fmincon','objective',@(x)0,'x0',theta_0,'nonlcon',@this.constr,'options',opts);

            ms = MultiStart('FunctionTolerance',2e-3,'UseParallel',true);
            gs = GlobalSearch(ms);

%             gs = GlobalSearch;
            [theta, f] = run(gs, problem);
            disp(theta);
            disp(f);
            
             this.plot_trajectory(theta);
        end
        
        function theta = run(this)
%             a0 = [q_max(1)-q_min(1)    q_max(2)-q_min(2)   q_max(3)-q_min(3)   q_max(4)-q_min(4)   q_max(5)-q_min(5)];
            % cond = ~31 Run on manipulator
            theta_0 = [
               5.793967012375577   2.581259883309473  -5.848550947031585   3.289749008309455   5.192705575195015
               0.321943911368054  -0.326233197980345  -0.153091575724563   1.863400415940263  -1.665798046872587
              -1.133035129520956   0.985463775157897  -1.948480537140734  -0.034520488891306  -0.686791259080594
               1.091778061682040  -0.231489691332760   0.333249868259229   0.110760243377397  -0.099764716068035
              -0.113664405573988  -0.310611304169263   0.444374893380780  -0.001324148970973   0.274698038028977
              -0.010542782368367  -0.056260966218253   0.166728962336444  -0.430627640552204  -0.000091178336994
              -0.028691207368119   0.042984816330886  -0.116819093591486   0.009122307002503   0.225647022322327
              -0.029181055299833  -0.148204300635701   0.112560089194585  -0.030392168934422   0.075504848354089
               0.030669798158624   0.004797892394422  -0.087119024602833   0.012358086026998  -0.104809111456099
               0.022233057458456   0.007359641050307   0.057742460796260   0.090261975553105   0.034306328705916
               0.035636579370007  -0.079112707726557   0.030625462336029   0.042038055479805   0.022988354878708                
            ];
            rng default
            theta_0 = rand(11,5) * 4 - 2;
            %             options = optimoptions('fmincon', 'Display','iter','UseParallel',true,'MaxFunctionEvaluations',150000, 'MaxIterations', 3000, 'Algorithm','interior-point');
            options = optimoptions('fmincon', 'UseParallel',true,'MaxFunctionEvaluations',150000, 'MaxIterations', 3000, 'Algorithm','interior-point');

            %             tic
%             [theta,fval,exitflag,output] = fmincon(@this.objfun, theta_0, [],[],[],[],[],[], @this.constr, options);
%             [theta,fval,exitflag,output] = fmincon(@(x)0, theta_0, [],[],[],[],[],[], @this.constr, options);
            %             toc

%             save('theta');
            this.plot_trajectory(theta);
            
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
                c4 = abs(ddq) - this.ddq_max;
                c = horzcat(c, [c1, c2, c3, c4]);   % vector `[1, 15]`
                %   Cartesian space
                %       Compute position of EE
                p = this.forwart_kinematics_youbot(q);
%                 %       xy -- space (vertical cylinder)
                c5 = (sqrt(p(1)^2 + p(2)^2) - this.R);
%                 c5 = 0;
%                 if (p(3) >= this.z_min) && (p(3) <= this.h)
%                     c5 = sqrt(p(1)^2 + p(2)^2) - this.R;
%                 end
%                 %       "floor" plane
                 c6 = this.z_min - p(3);
                c = horzcat(c, [c5, c6]);
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
            d = [0.147, 0, 0, 0, 0.218];
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
            figure;
            for i = 1:length(Q(1,:))
                subplot(5,3,(i-1) * 3 + 1);
                p = plot(this.t, Q(:,i), 'k', this.t, ones(length(this.t),1) * this.q_max(i), 'r', this.t, ones(length(this.t),1) * this.q_min(i), 'g');
                grid on;
                sy = ylabel('$q, [rad]$','interpreter','latex');
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex');
                end
                
                subplot(5,3,(i-1) * 3 + 2);
                plot(this.t, dQ(:,i), 'k', this.t, ones(length(this.t),1) * this.dq_max(i), 'r', this.t, -ones(length(this.t),1) * this.dq_max(i), 'g');
                grid on;
                sy = ylabel('$\dot{q}, [rad]$','interpreter','latex');
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex');
                end
                
                subplot(5,3,(i-1) * 3 + 3);
                plot(this.t, ddQ(:,i), 'k', this.t, ones(length(this.t),1) * this.ddq_max(i), 'r', this.t, -ones(length(this.t),1) * this.ddq_max(i), 'g');
                grid on;
                sy = ylabel('$\ddot{q}, [rad]$','interpreter','latex');
                if i == length(Q(1,:))
                    sx = xlabel('$t, [sec]$','interpreter','latex');
                end
            end
        end
    end
end
