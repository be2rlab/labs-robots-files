function plotCustom(s, what, var, style, color, offset)
    joints = [1,2,3,4,5];

    if size(what.Data,2) == 1
        joints = [1];
    end
    
    if size(what.Data,1) == 6
        joints = [1,2,3,4,5,6];
    end
    
    ax_font_size = 25;
    ax_lines_width = 2;
    lable_font_size = 30;
    leg_font_size = 20;
    plot_line_width = 3;
    hold on
        k = 1 + offset;
        for j = joints
            if size(what.Data,1) == 8
                leg = legend( 'Interpreter', 'latex'); leg.FontSize = leg_font_size;
                p = plot(what, color);
                for i = 1:8
                    p(i).LineWidth = 2;
                    leg.String{i} = "$"+ var +"_{" + i + "}$";
                end

                title('');
                break;

            elseif size(what.Data,1) == 6
                leg = legend( 'Interpreter', 'latex'); leg.FontSize = leg_font_size;
                p = plot(what, color);
                for i = 1:6
                    p(i).LineWidth = 2;
                    leg.String{i} = "$"+ var +"_{" + i + "}$";
                end

                title('');
                break;
            elseif size(what.Data,2) == 1
                p = plot(what, color);
                p(1).LineWidth = 2.5;
                p(1).LineStyle = style;
                title('');
            else
                leg = legend( 'Interpreter', 'latex'); leg.FontSize = leg_font_size;
                p = plot(what.Time, what.Data(:, j), color);
                p.LineWidth = plot_line_width + j  * 0.;
                p.LineStyle = style;
                if j < 6
                    leg.String{k} = "$"+ var +"_{" + j + "}$";
                    k = k + 1;
                end
            end
           
        end
    hold off
    grid on; % grid minor;
    s.FontSize = ax_font_size; s.LineWidth = ax_lines_width;
    x = xlabel("$t$", 'Interpreter', 'latex'); x.FontSize = lable_font_size;
    if offset > 0
        y = ylabel("", 'Interpreter', 'latex'); y.FontSize = lable_font_size;
    else 
         y = ylabel("$"+ var +"$", 'Interpreter', 'latex'); y.FontSize = lable_font_size;
    end 
end
