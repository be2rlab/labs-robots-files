function plotPoints(ws1, ws2, ws3, ws4, ctitles1,ctitles2,ctitles3,ctitles4)
    f = figure(1);

    for k = 1:4
        if k == 1
            p = ws1.p;
            p_d = ws1.p_d;
            p_e = ws1.p_e;
            controller_title = ctitles1;
        elseif k == 2
            p = ws2.p;
            p_d = ws2.p_d;
            p_e = ws2.p_e;
            controller_title = ctitles2;
        elseif k == 3
            p = ws3.p;
            p_d = ws3.p_d;
            p_e = ws3.p_e;
            controller_title = ctitles3;
        elseif k == 4
            p = ws4.p;
            p_d = ws4.p_d;
            p_e = ws4.p_e;
            controller_title = ctitles4;
        end
            
            
            
        s = subplot(2,2,k);
        hold on
        for j = 1:4
            x = [];
            y = [];
            for i = 1:length(p.Time)
                x(i) = p.Data(1,j,i);
                y(i) = p.Data(2,j,i);
            end
            plot(x,y, 'k');
            ax = gca;
            ax.YDir = 'reverse';
            ax.XAxisLocation = 'top';
            xlim([0 1024]);
            ylim([0 1024]);

%             plot(p_d.Data(1,j,1), p_d.Data(2,j,1), 'ro')
            plot(p.Data(1,j,1), p.Data(2,j,1), 'bo')

            e = reshape(p_e.Data(:,:,length(p.Time)),2,4);
            err = e(1,j,1);
            errorbar(p_d.Data(1,j,1), p_d.Data(2,j,1), err,'horizontal')

            err = e(2,j,1);
            errorbar(p_d.Data(1,j,1), p_d.Data(2,j,1), err,'vertical')

            
            x0=100;
            y0=100;
            width=750;
            height=600;
            set(gcf,'position',[x0,y0,width,height])
        end
        s.XLabel.String = 'u, px';
        s.XLabel.FontSize = 14;

        s.YLabel.String = 'v, px';
        s.YLabel.FontSize = 14;

        

        
        grid();
        title(controller_title);
        box on;
        hold off;
    end
    
    pause();
    
    g = gcf();
    g.Renderer = 'Painters';
    controller_title = "";
    saveasCustom(f, g, controller_title + "_points");
    close(f);
    
end