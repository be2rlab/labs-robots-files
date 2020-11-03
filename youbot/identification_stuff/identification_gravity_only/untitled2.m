fileID = fopen('gfile.txt','r');        
formatSpec = '%f';
sizeA = [11 Inf];
A = fscanf(fileID, formatSpec, sizeA);

fileID = fopen('gfile_hot.txt','r');        
formatSpec = '%f';
sizeAhot = [11 Inf];
Ahot = fscanf(fileID, formatSpec, sizeA);

fileID = fopen('gfile_rand.txt','r');        
formatSpec = '%f';
sizeA = [11 Inf];
Arand = fscanf(fileID, formatSpec, sizeA);

size(A)
size(Ahot)
size(Arand)

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



t = A(11, :);
q = A(1:5, :);
tau = A(6:10, :);


figure;
for i = 1:5
    subplot(2,5,i);
    plot(t,q(i,:), 'k.');
    grid();
    subplot(2,5,i+5);
%     et = reshape(est_tau, 5,100);
    et_hot = reshape(est_tau_hot, 5,100);
%     et_rand = reshape(est_tau_rand, 5,100);
    
%     plot(t, tau(i,:), 'g', t, et(i,:), 'r', t, et_hot(i,:), 'k')%, t, et_rand(i,:), 'm');
      plot(t, tau(i,:), 'g.',t, et_hot(i,:), 'k.')%, t, et_rand(i,:), 'm');
      grid();
end




for i = 1:5
    
    figure(i);
    subplot(1,2,1);
    plot(t,q(i,:), 'ko');
    grid();
      x = xlabel('Номер конфигурации');
      y = ylabel('$q$', 'Interpreter','latex');
      set(x,'FontSize',20);
      set(y,'FontSize',50);
    set(gca,'FontSize',16)
    
    subplot(1,2,2);
%     et = reshape(est_tau, 5,100);
    et_hot = reshape(est_tau_hot, 5,100);
%     et_rand = reshape(est_tau_rand, 5,100);
    
%     plot(t, tau(i,:), 'g', t, et(i,:), 'r', t, et_hot(i,:), 'k')%, t, et_rand(i,:), 'm');
      plot(t, tau(i,:), 'go',t, et_hot(i,:), 'ko')%, t, et_rand(i,:), 'm');
      grid();
      x = xlabel('Номер конфигурации');
      y = ylabel('$\tau$', 'Interpreter','latex');
      set(x,'FontSize',20);
      set(y,'FontSize',50);
      
      leg1 = legend('$\tau$','$\hat\tau$');
        set(leg1,'Interpreter','latex');
        set(leg1,'FontSize',40);
        set(gca,'FontSize',16)
end


subplot(2,2,1);
% plot(q_0.Time, q_0.Data, '--', q_g.Time, q_g.Data, q_g.Time, q_0.Data - q_g.Data, 'r', 'LineWidth',2);
plot(q_0.Time, q_0.Data + ([2, 2, -2, 2, 6.0315]'*ones(1, 50001))', 'LineWidth',2);
grid();
xlabel('$t$', 'Interpreter','latex');
ylabel('$q$', 'Interpreter','latex');
set(gca,'FontSize',20)


subplot(2,2,2);
% plot(q_0.Time, q_0.Data, '--', q_g.Time, q_g.Data, q_g.Time, q_0.Data - q_g.Data, 'r', 'LineWidth',2);
plot(q_g.Time, q_g.Data + ([2, 2, -2, 2, 6.0315]'*ones(1, 50001))', 'LineWidth',2);
grid();
x = xlabel('$t$');
set(x,'Interpreter','latex');
set(x,'FontSize',50);

ylabel('$q$', 'Interpreter','latex');
set(gca,'FontSize',20)


leg1 = legend('$q_1$','$q_2$','$q_3$','$q_4$','$q_5$');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',30);

subplot(2,2,3);
plot(tau_0.Time, tau_0.Data,'LineWidth',2);
grid();
xlabel('$t$', 'Interpreter','latex');
ylabel('$\tau$', 'Interpreter','latex');
set(gca,'FontSize',20)


subplot(2,2,4);
plot(tau_g.Time, tau_g.Data,'LineWidth',2);
grid();
xlabel('$t$', 'Interpreter','latex');
ylabel('$\tau$', 'Interpreter','latex');
set(gca,'FontSize',20)


leg2 = legend('$\tau_1$','$\tau_2$','$\tau_3$','$\tau_4$','$\tau_5$');
set(leg2,'Interpreter','latex');
set(leg2,'FontSize',30);
