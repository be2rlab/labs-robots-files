fileID = fopen('data_raw.txt','r');        
formatSpec = '%f';
sizeA = [21 Inf];
A = fscanf(fileID, formatSpec, sizeA);

fileID = fopen('vels.txt','r');        
formatSpec = '%f';
sizeA = [31 Inf];
Araw = fscanf(fileID, formatSpec, sizeA);

bigD = [];
bigTau = [];
t = [];
parfor i = 1:length(A(1,:))
    if mod(i, 20) == 0
        q = A(1:5, i);
        dq = A(6:10, i);
        ddq = A(11:15, i);
        D = getD(q, dq, ddq);
        bigD = vertcat(bigD, D); 
        bigTau = vertcat(bigTau, A(16:20,i));
        t = vertcat(t, A(21,i));
    end
end
disp(cond(bigD));

chi = lsqr(bigD, bigTau, 1e-20, 1000);
taus = bigD * chi;


taus1 = reshape(taus, [5,length(taus)/5]);
bigTau1 = reshape(bigTau, [5,length(taus)/5]);
t1 = t;

taus2 = reshape(taus, [5,length(taus)/5]);
bigTau2 = reshape(bigTau, [5,length(taus)/5]);
t2 = t;

for i = 1:5
    subplot(2,5,i)
    plot(t1, bigTau1(i,:), 'g', t1, taus1(i,:), 'k')    
    subplot(2,5,i+5)
    plot(t1, bigTau1(i,:), 'r', t2, bigTau2(i,:), 'g', t2, taus2(i,:), 'k')    
end





% figure
% for i = 1:5 
%     subplot(5,1,i)
%     p = plot(A(21,:), A(15+i,:), 'k', A(21,:),taus(i,:), 'r');
%     
% end



% figure(3)
for i = 1:5
    t = A(21,:);
    ddq = A(10+i, :);
%     t = Araw(31,:);
%     ddq = Araw(20+1,:);
    ddqi = cumtrapz(t, ddq);
    ddqii = cumtrapz(t, ddqi);

    subplot(4,5,i)
    plot(A(21,:), A(i,:), 'k', Araw(31,:), Araw(15+i,:), 'm', t, ddqii, 'g--')
    
    subplot(4,5,i+5)
    plot(A(21,:), A(5+i,:), 'k', Araw(31,:), Araw(20+i,:), 'm', t, ddqi, 'g--')

    subplot(4,5,i+10)
    plot(A(21,:), A(10+i,:), 'k', Araw(31,:), Araw(25+i,:), 'm')

    subplot(4,5,i+15)
    plot(A(21,:), A(15+i,:) - taus(i,:), 'y', A(21,:), A(15+i,:), 'k', A(21,:), taus(i,:), 'r');
end


