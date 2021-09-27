fileID = fopen('gfile_load_very_hot.txt','r');        
formatSpec = '%f';
sizeA = [11 Inf];
A = fscanf(fileID, formatSpec, sizeA);
% 
% fileID = fopen('gfile_hot.txt','r');        
% formatSpec = '%f';
% sizeAhot = [11 Inf];
% Ahot = fscanf(fileID, formatSpec, sizeA);
% 
% fileID = fopen('gfile_rand.txt','r');        
% formatSpec = '%f';
% sizeA = [11 Inf];
% Arand = fscanf(fileID, formatSpec, sizeA);

size(A)
% size(Ahot)
% size(Arand)

n = 100;

q = A(1:5, 1);
tau = A(6:10, 1);

[D, ~, ~] = getD_gravity(q);
D = [D, [1 1 1 1 1]'];
bigD = D;
bigTau = tau();

for i = 2:n
    t = A(11, i);
    q = A(1:5, i);
    tau = A(6:10, i);
    
    [D, ~, ~] = getD_gravity(q);
    D = [D, [1 1 1 1 1]'];
    bigD = vertcat(bigD, D);
    bigTau = vertcat(bigTau, tau);
    
end

x = lsqr(bigD, bigTau, 1e-10, 1000);
disp(x');

est_tau_hot = bigD * x;



t = 1:100;%A(11, :);
q = A(1:5, :);
tau = A(6:10, :);


figure;
% for i = 1:5
%     subplot(2,5,i);
%     plot(t,q(i,:), 'k.');
%     grid();
%     subplot(2,5,i+5);
% %     et = reshape(est_tau, 5,100);
%     et_hot = reshape(est_tau_hot, 5,100);
% %     et_rand = reshape(est_tau_rand, 5,100);
%     
% %     plot(t, tau(i,:), 'g', t, et(i,:), 'r', t, et_hot(i,:), 'k')%, t, et_rand(i,:), 'm');
%       plot(t, tau(i,:), 'g.',t, et_hot(i,:), 'k.')%, t, et_rand(i,:), 'm');
%       grid();
% end

% plot(t,q(1,:), '+', t,q(2,:), 'o', t,q(3,:), '*', t,q(4,:), '.', t,q(5,:), 'x');
% et_hot = reshape(est_tau_hot, 5,100);
% figure
% plot(t, tau(1,:), 'g+',t, et_hot(1,:), 'k+',t, tau(2,:), 'go',t, et_hot(2,:), 'ko',t, tau(3,:), 'g*',t, et_hot(3,:), 'k*',t, tau(4,:), 'g.',t, et_hot(4,:), 'k.', t, tau(5,:), 'gx',t, et_hot(5,:), 'kx');

subplot(2,1,1)
plot(t,q(2,:), 'o', t,q(3,:), '*', t,q(4,:), '.', t,q(5,:), 'x');
legend('Joint 2', 'Joint 3', 'Joint 4', 'Joint 5')
grid()

subplot(2,1,2)
et_hot = reshape(est_tau_hot, 5,100);
plot(t, tau(2,:), 'go',t, et_hot(2,:), 'ko',t, tau(3,:), 'g*',t, et_hot(3,:), 'k*',t, tau(4,:), 'g.',t, et_hot(4,:), 'k.', t, tau(5,:), 'gx',t, et_hot(5,:), 'kx');
grid()




















