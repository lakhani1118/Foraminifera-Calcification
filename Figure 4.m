load('Data/Local_TP.mat')
TP(TP==0)=NaN;TP(TP==-900)=NaN;TP(TP==-999)=NaN;
TP1=TP;StoredLat1=StoredLat;StoredLong1=StoredLong;
load('Data/Local_TP_Holocene.mat')
TP(TP==0)=NaN;TP(TP==-900)=NaN;TP(TP==-999)=NaN;
italics_list={'G. ruber (white)','T. sacculifer','G. tumida','N. dutertrei','P. obliquiloculata'};
depth=linspace(0,300,10000);
load('Data/Best_TP_Holocene.mat','best_TP_RMS')
best_TP_RMS_Holocene=best_TP_RMS/100;
load('Data/Best_TP.mat','best_TP_RMS')
best_TP_RMS_all=best_TP_RMS/100;
s=size(best_TP_RMS);
edges=linspace(0,1,20);
figure()
for i=1:s(2)
    subplot(1,s(2),i)
    hold on
    a=TP1(i,:);
    b=a(~isnan(a));
    h=histogram(b,'FaceColor','#D95319','BinEdges',edges,'orientation','horizontal','HandleVisibility','off');
    
    a1=TP(i,:);
    b1=a1(~isnan(a1));
    h1=histogram(b1,'FaceColor','#0072BD','BinEdges',edges,'orientation','horizontal','HandleVisibility','off');
    
    plot(xlim,best_TP_RMS_all(i)*[1,1],'--','LineWidth',3,'Color','#D95319')
    plot(xlim,best_TP_RMS_Holocene(i)*[1,1],'--','LineWidth',3,'Color','#0072BD')
    plot(xlim,mean(b)*[1,1],':','LineWidth',3,'Color','#D95319')
    %disp([mean(b),std(b)]) %All
    plot(xlim,mean(b1)*[1,1],':','LineWidth',3,'Color','#0072BD')
    %disp([mean(b1),std(b1)]) %Holocene
    disp(quantile(b1,[0.025, 0.975]))
    
    ax = gca;
    ylim([0,1])
    %title(strcat('\it{',char(italics_list(i)),'} (n=',string(length(b)),',',string(length(b1)),')'),'FontSize',18)
    title(strcat('\it{',char(italics_list(i)),'}'),'FontSize',18)
    set(gca,'XTick',[])
    if i==1
        ylabel('Thermocline Position (TP)','FontSize',20)
        yl=get(gca,'YLabel');
        ylFontSize=get(yl,'FontSize');
        yAX=get(gca,'YAxis');
        set(yAX,'FontSize', 20)
    else
        set(gca,'YTick',[])
    end
    if i==3
        xlabel('Counts','FontSize',24)
    end
    if i==5
        %legend('Global TP','Holocene Global TP','Mean Local TP','Holocene Mean Local TP','Location','SouthEast','FontSize',15)
    end
end