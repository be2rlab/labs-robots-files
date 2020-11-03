J = 33e-6;
B = 37e-6;
m = 0.1;
c = 0.1;
g = 0.01;

a0 = g * (J + B);
a1 = c * B;
a2 = J * c + m * B;
a3 = J * m;

% a0 = m;
% a1 = c;
% a2 = g;



k1 = 1;
k2 = 2;

sigma = 30;
mu = 5;

G = [
    0   1;
    -k1 -k2
];

d = [0 1]';
h = [1 0]';


% h = 0.003
% Kp = diag([2    80  1   1   1]);
% Kv = diag([0.5  1   1   1   1]);
% sim('vs_cc_setup')