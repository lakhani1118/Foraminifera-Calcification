load('Data/Local_ACD.mat')
StoredDepths(StoredDepths==-900)=NaN;StoredDepths(StoredDepths==-999)=NaN;%StoredDepths(StoredDepths==0)=NaN;
StoredDepths1=StoredDepths;StoredLat1=StoredLat;StoredLong1=StoredLong;
load('Data/Local_ACD_Holocene.mat')
StoredDepths(StoredDepths==-900)=NaN;StoredDepths(StoredDepths==-999)=NaN;%StoredDepths(StoredDepths==0)=NaN;
italics_list={'G. ruber (white)','T. sacculifer','G. tumida','N. dutertrei','P. obliquiloculata'};
depth=linspace(0,300,10000);
load('Data/Best_ACD.mat','best_depths_RMS')
best_depths_RMS_all=best_depths_RMS;
load('Data/Best_ACD_Holocene.mat','best_depths_RMS')
best_depths_RMS_Holocene=best_depths_RMS;
s=size(best_depths_RMS_Holocene);
edges=linspace(0,400,20);
figure()
for i=1:s(2)
    subplot(1,s(2),i)
    hold on
    a=StoredDepths1(i,:);
    b=a(~isnan(a));
    h=histogram(b,'FaceColor','#D95319','BinEdges',edges,'orientation','horizontal','HandleVisibility','off');
    
    a1=StoredDepths(i,:);
    b1=a1(~isnan(a1));
    h1=histogram(b1,'FaceColor','#0072BD','BinEdges',edges,'orientation','horizontal','HandleVisibility','off');
    
    plot(xlim,best_depths_RMS_all(i)*[1,1],'--','LineWidth',3,'Color','#D95319')
    plot(xlim,best_depths_RMS_Holocene(i)*[1,1],'--','LineWidth',3,'Color','#0072BD')
    plot(xlim,mean(b)*[1,1],':','LineWidth',3,'Color','#D95319')
    disp([mean(b),std(b)]) %All
    plot(xlim,mean(b1)*[1,1],':','LineWidth',3,'Color','#0072BD')
    %disp([mean(b1),std(b1)]) %Holocene
    
    ax = gca;
    ax.YDir = 'reverse';
    ylim([0,400])
    %title(strcat('\it{',char(italics_list(i)),'} (n=',string(length(b)),',',string(length(b1)),')'),'FontSize',18)
    title(strcat('\it{',char(italics_list(i)),'}'),'FontSize',18)
    set(gca,'XTick',[])
    if i==1
        ylabel('Depth (m)','FontSize',20)
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
        %legend('Global Depth','Holocene Global Depth','Mean Local Depth','Holocene Mean Local Depth','Location','SouthEast','FontSize',15)
    end
end