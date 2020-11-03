function f = create_figure(i)
    f = figure(i);
    f.WindowState = 'maximized'; 
    set(f,'Units','Inches'); 
    pos = get(f,'Position'); 
    set(f,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
end