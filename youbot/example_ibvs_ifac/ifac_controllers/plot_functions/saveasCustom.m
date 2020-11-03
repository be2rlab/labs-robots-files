function saveasCustom(f, g, title)
    mkdir('plots/eps')
    mkdir('plots/fig')    
    mkdir('plots/pdf')
    
    
    saveas(g,'plots/eps/'+ string(title) +'.eps','epsc');
    saveas(g,'plots/'+ string(title) +'.png');
    saveas(g,'plots/fig/'+ string(title) +'.fig');
    
%     f.PaperType = 'A4'; 
    %     f.PaperOrientation = 'landscape';
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,'PaperPosition', [0 0 screenposition(3:4)],'PaperSize', [screenposition(3:4)]);
    print(f,'plots/pdf/'+ string(title) +'.pdf','-dpdf', '-fillpage', '-r0');

end    