%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:5
    f = figure(i);
    hold on;
        plot(ws1.q_e.Time, ws1.q_e.Data(:,i));
        plot(ws2.q_e.Time, ws2.q_e.Data(:,i));
        plot(ws3.q_e.Time, ws3.q_e.Data(:,i));
        plot(ws4.q_e.Time, ws4.q_e.Data(:,i));
        for j = 1:4
            f.Children.Children(j).LineWidth = 2;
        end
        
        f.Children.Box = 'on';
      
%         lines = ["$\tilde{q}_1$","$\tilde{q}_2$","$\tilde{q}_3$","$\tilde{q}_4$","$\tilde{q}_5$"];
        lines = ["PD+gravity (nominal)","PD+gravity (estimated)","Computed-torque","Time-delay"];
        legend(lines, 'Interpreter', 'latex');
        f.Children(1).FontSize = 16;
        
        %         f.Children(i).YLabel.String = "";
        f.Children(2).FontSize = 16;
        f.Children(2).Title.String = "";
        
        f.Children(2).XLabel.String = "t, sec";
        f.Children(2).XLabel.FontSize = 20;
                
        grid();
        
%         indexOfInterest = (x5 < 0.8) & (x5 >0.6); % range of t near perturbation
%         plot(x5(indexOfInterest), y6(indexOfInterest));

        hold off;
        pause();
        g = gcf(); g.Renderer = 'Painters';
        saveasCustom(f, g, "j" + string(i));
        close(f);
end

% 
% 
% controller_title = "pd";
% plotCustom_v3(ws1, controller_title, 1);
% 
% controller_title = "pdg";
% plotCustom_v3(ws2, controller_title, 1);
% 
% controller_title = "ctorque";
% plotCustom_v3(ws3, controller_title, 1);
% 
% controller_title = "tdc";
% plotCustom_v3(ws4, controller_title, 1);
% 
% 
% for i = 1:5
%     f = figure(i);
%     s = subplot(3,1,1);
%         hold on;
%         plot(ws1.q_e.Time, ws1.q_e.Data(:,i));
%         plot(ws2.q_e.Time, ws2.q_e.Data(:,i));
%         plot(ws3.q_e.Time, ws3.q_e.Data(:,i));
%         plot(ws4.q_e.Time, ws4.q_e.Data(:,i));
%         grid();
%         hold off;
%     s = subplot(3,1,2);
%         hold on;
%         plot(ws1.dq_e.Time, ws1.q_e.Data(:,i));
%         plot(ws2.dq_e.Time, ws2.q_e.Data(:,i));
%         plot(ws3.dq_e.Time, ws3.q_e.Data(:,i));
%         plot(ws4.dq_e.Time, ws4.q_e.Data(:,i));
%         grid();
%         hold off;
%     s = subplot(3,1,3);
%         hold on;
%         plot(ws1.tau.Time, ws1.tau.Data(:,i));
%         plot(ws2.tau.Time, ws2.tau.Data(:,i));
%         plot(ws3.tau.Time, ws3.tau.Data(:,i));
%         plot(ws4.tau.Time, ws4.tau.Data(:,i));
%         grid();
%         hold off;
% end
% 
% 
% %% Labmda plot
% hold on;
% plot(ws1.lambda.Time, ws1.lambda.Data);
% plot(ws2.lambda.Time, ws2.lambda.Data);
% plot(ws3.lambda.Time, ws3.lambda.Data);
% plot(ws4.lambda.Time, ws4.lambda.Data);
% hold off;
% 


hold on;

Pe = [];
for i = 1:length(ws1.p_e.Time)
    Pe(i) = max(ws1.p_e.Data(1, 1, i));
end
plot(ws1.p_e.Time, Pe);

Pe = [];
for i = 1:length(ws2.p_e.Time)
    Pe(i) = max(ws2.p_e.Data(1, 1, i));
end
plot(ws2.p_e.Time, Pe);

Pe = [];
for i = 1:length(ws3.p_e.Time)
    Pe(i) = max(ws3.p_e.Data(1, 1, i));
end
plot(ws3.p_e.Time, Pe);
Pe = [];
for i = 1:length(ws4.p_e.Time)
    Pe(i) = max(ws4.p_e.Data(1, 1, i));
end
plot(ws4.p_e.Time, Pe);
hold off;

grid();

f = figure(1);
f.Children.Box = 'on';

%         lines = ["$\tilde{q}_1$","$\tilde{q}_2$","$\tilde{q}_3$","$\tilde{q}_4$","$\tilde{q}_5$"];
lines = ["PD+gravity (nominal)","PD+gravity (estimated)","Computed-torque","Time-delay"];
legend(lines, 'Interpreter', 'latex');
f.Children(1).FontSize = 16;

for j = 1:4
    f.Children(2).Children(j).LineWidth = 2;
end


%         f.Children(i).YLabel.String = "";
f.Children(2).FontSize = 16;
f.Children(2).Title.String = "";

f.Children(2).XLabel.String = "t, sec";
f.Children(2).XLabel.FontSize = 20;

f.Children(2).YLabel.Interpreter = "latex";
f.Children(2).YLabel.String = "$||e_p||_{\infty}$";
f.Children(2).YLabel.FontSize = 30;


%         indexOfInterest = (x5 < 0.8) & (x5 >0.6); % range of t near perturbation
%         plot(x5(indexOfInterest), y6(indexOfInterest));

hold off;
pause();
g = gcf(); g.Renderer = 'Painters';
saveasCustom(f, g, "e_p");
close(f);

x = [];
y = [];
alpha = 0;
i = 1;
h = 5;
while alpha < 2 * pi
    x(i) = h * floor(100 * cos(alpha) / h + 0.5);
    y(i) = h * floor(100 * sin(alpha) / h + 0.5);
    alpha = alpha + 0.001;
    i = i + 1;
end
plot(x,y);
    


% 
% for i = 1:5
%     f = figure(i+5);
%     s = subplot(2,1,1);
%         hold on;
%         plot(ws1.p_e.Time, ws1.p_e.Data(:,i));
%         plot(ws2.q_e.Time, ws2.q_e.Data(:,i));
%         plot(ws3.q_e.Time, ws3.q_e.Data(:,i));
%         plot(ws4.q_e.Time, ws4.q_e.Data(:,i));
%         grid();
%         hold off;
%     s = subplot(2,1,2);
%         hold on;
%         plot(ws1.dq_e.Time, ws1.q_e.Data(:,i));
%         plot(ws2.dq_e.Time, ws2.q_e.Data(:,i));
%         plot(ws3.dq_e.Time, ws3.q_e.Data(:,i));
%         plot(ws4.dq_e.Time, ws4.q_e.Data(:,i));
%         grid();
%         hold off;
% end
% 
% 
