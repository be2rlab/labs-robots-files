
%% Plot q, dq, e
f = create_figure(1);

%  Plot q
s = subplot(2, 2, 1); s.Position = [0.07, s.Position(2), 0.4 0.4];
plotCustom(s, ws.q_d, "q^{*}", ':', 'k', 0);
plotCustom(s, ws.q, "q", '-', '', 5);

s = subplot(2, 2, 2); s.Position = [0.55, s.Position(2), 0.4 0.4];
plotCustom(s, ws.q_e, "\tilde{q}", '-', '', 0);

% Plot dq
s = subplot(2, 2, 3); s.Position = [0.07, s.Position(2)-0.01, 0.4 0.4];
plotCustom(s, ws.dq_d, "\dot{q}^{*}", ':', 'k', 0);
plotCustom(s, ws.dq, "\dot{q}", '-', '', 5);

s = subplot(2, 2, 4); s.Position = [0.55, s.Position(2)-0.01, 0.4 0.4];
plotCustom(s, ws.dq_e, "\tilde{\dot{q}}", '-', '', 0);

% save files
saveasCustom(f, gcf, controller_title + "_state");
close(f);


%% Plot q_e, tau
f = create_figure(2);

s = subplot(3, 1, 1); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.q_e, "\tilde{q}", '-', ' ', 0);

s = subplot(3, 1, 2); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.dq_e, "\tilde{\dot{q}}", '-', ' ', 0);

s = subplot(3, 1, 3); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.tau, "\tau", '-', ' ', 0);

% save files
saveasCustom(f, gcf, controller_title + "_tau");
close(f);


%% Plot lambda stuff
f = create_figure(3);

s = subplot(3, 1, 1); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.p_e, "e", '-', ' ', 0);


s = subplot(3, 1, 2); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.norm_e, "||e||^{\infty}", '-', ' ', 0);

s = subplot(3, 1, 3); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.lambda, "\lambda", '-', ' ', 0);

% s = subplot(3, 1, 3); s.Position = [0.07    s.Position(2)    0.9    0.22];
% plotCustom(s, v_c, "v^c", '-', ' ', 0);

% save files
saveasCustom(f, gcf, controller_title + "_lambda");
close(f);


%% Plot cond numbers
f = create_figure(4);

s = subplot(3, 1, 1); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.condM, "cond(M)", '-', ' ', 0);

s = subplot(3, 1, 2); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.condJi, "cond(J_i)", '-', ' ', 0);

s = subplot(3, 1, 3); s.Position = [0.07    s.Position(2)    0.9    0.22];
plotCustom(s, ws.condJe, "cond(J_e)", '-', ' ', 0);

% save files
saveasCustom(f, gcf, controller_title + "_cond");
close(f);
