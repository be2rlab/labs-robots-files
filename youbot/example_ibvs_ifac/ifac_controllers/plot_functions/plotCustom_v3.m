function plotCustom_v3(ws, controller_title, leg)
    f = figure(1);
    f.OuterPosition(3:4) = [670, 1000];

    hold on;
    subplot(3,1,1);
    plot(ws.q_e);
    lines = ["$joint_1$","$joint_2$","$joint_3$","$joint_4$","$joint_5$"];
    legend(lines);
    
    
    legend()
    subplot(3,1,2);
    plot(ws.dq_e);
    subplot(3,1,3);
    plot(ws.tau);
%     subplot(3,1,3);
%     
%     plot(ws.norm_e);
%     subplot(5,1,5);
%     plot(ws.lambda);
    hold off;
    
    
    name = ["$\tilde{q}, rad$","$\tilde{\dot{q}}, rad$","$\tau, N \cdot m$","$||e||_{\infty}, px$","$\lambda$"];
    k = 1;
    for i = 1:length(f.Children)
        if f.Children(i).Type ~= "legend"
            f.Children(i).XGrid = 'on';
            f.Children(i).YGrid = 'on';
    %         f.Children(i).XMinorGrid = 'on';
    %         f.Children(i).YMinorGrid = 'on';
    %         f.Children(i).MinorGridLineStyle = ':';       

            f.Children(i).LineWidth = 1;
            for j = 1:length(f.Children(i).Children)
                f.Children(i).Children(j).LineWidth = 1;
            end

            f.Children(i).FontSize = 14;
            f.Children(i).Title.String = '';

            f.Children(i).XLabel.Interpreter = 'latex';
            f.Children(i).YLabel.Interpreter = 'latex';

            f.Children(i).YLabel.String = name(4-k);
            k = k + 1;
            
            f.Children(i).YLabel.FontSize = 20;

%             f.Children(i).Position(4) = 0.15;
%             f.Children(i).YLabel.Position(1) = -0.45;

            if i == 1
                f.Children(i).XLabel.String = 't, sec';
                f.Children(i).XLabel.FontSize = 20;
            else
                f.Children(i).XTickLabel = [];
                f.Children(i).XLabel.String = '';
            end
        else
            if leg
                f.Children(i).Orientation = 'horizontal';
            end
            f.Children(i).Interpreter = "latex";
        end
    end
    
    pause();
    
    g = gcf();
    g.Renderer = 'Painters';
    saveasCustom(f, g, controller_title);
    close(f);

end
