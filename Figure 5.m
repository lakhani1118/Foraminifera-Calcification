%% Create x-axis data
clearvars
load('Thermocline_Percent/TP_80.mat')
latvec=Lat(1,:);
lonvec=Lon(:,1);
Holocene=0;
if Holocene
    load('Data/Local_ACD_Holocene.mat')
else
    load('Data/Local_ACD.mat')
end
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
StoredDepths(StoredDepths==-999)=NaN;StoredDepths(StoredDepths==-900)=NaN;StoredDepths(StoredDepths==0)=NaN;
StoredLong(StoredLong<0)=StoredLong(StoredLong<0)+360;
s=size(StoredDepths);
StoredTP=ones(s).*NaN; %Approximating the thermocline depth as the 0.8 TP
p=0;
for i=1:s(1)
    for j=1:s(2)
        [~,Ilon]=min(abs(lonvec-StoredLong(i,j)));
        [~,Ilat]=min(abs(latvec-StoredLat(i,j)));
        range=1;
        data=TP_data(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674));
        data2=data;
        data(data==-900)=900;
        range=2;
        data3=TP_data(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674));
        X2sub=Lat(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674));
        Y2sub=Lon(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674));
        ans=interp2(X2sub,Y2sub,data3,StoredLat(i,j),StoredLong(i,j));
        if isnan(ans)
            %p=p+1;disp(p)
        else
            StoredTP(i,j)=ans;
        end
    end

end
if Holocene
    HoloceneTP=StoredTP;
    HoloceneDepths=StoredDepths;
    save('Data/Holocene_Figure_5.mat','HoloceneTP','HoloceneDepths')
else
    AllTP=StoredTP;
    AllDepths=StoredDepths;
    save('Data/All_Figure_5.mat','AllTP','AllDepths')
end

%% Actual Figure code
addpath('Functions')
load('Data/Constant_Percent.mat')
load('Data/All_Figure_5.mat')
load('Data/Holocene_Figure_5.mat')
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
color='#0072BD';
color2='#D95319';
figure('Position',[0 0 1300 1000])
i=3;
for i=3:5
    subplot(2,2,i-2)
    hold on
%     x=HoloceneTP(i,:);
    x=AllTP(i,:);
    y=Constant_Percent(i,:);
    a=isnan(x);b=isnan(y);c=or(a,b);
    x=x(~c);y=y(~c);
    xvec=[min(x),max(x)];
    xvec=linspace(xvec(1),xvec(2),1000);
    [p2,S2]=polyfit(x,y,1);
    [yvec2,delta2]=polyval(p2,xvec,S2);
    cp=plot(xvec,yvec2,'--','LineWidth',2.5,'Color','b');%Constant Percent
    %plot(x,y,'.','MarkerSize',10,'Color',color)
    
    x=AllTP(i,:);
    y=AllDepths(i,:);
    a=isnan(x);b=isnan(y);c=or(a,b);
    x=x(~c);y=y(~c);
    xvec=[min(x),max(x)];
    xvec=linspace(xvec(1),xvec(2),1000);
    %[p1,S1]=polyfit(x,y,1);
    %[yvec1,delta1]=polyval(p1,xvec,S1);
    %plot(xvec,yvec1,'--k','LineWidth',2.5)%Best Fit
    %[A,I]=min(abs(yvec1-yvec2));
    %cd=plot(xvec,ones(size(xvec)).*mean(y),'--','LineWidth',2.5,'Color','r');%Plot red line as mean of All data
    plot(x,y,'.','MarkerSize',6,'Color',[color2],'HandleVisibility','off')
    
    x=HoloceneTP(i,:);
    y=HoloceneDepths(i,:);
    a=x<60;b=y>0;c=and(a,b);
    one=StoredLat(i,a);
    two=StoredLong(i,a);
    three=StoredDepths(i,a);
    a=isnan(x);b=isnan(y);c=or(a,b);
    x=x(~c);y=y(~c);
    [p1,S1]=polyfit(x,y,1);
    [yvec1,delta1]=polyval(p1,xvec,S1);
    plot(xvec,yvec1,'k','LineWidth',2.5)%Best Fit
    cd=plot(xvec,ones(size(xvec)).*mean(y),':','LineWidth',2.5,'Color','r'); %Plot red line as mean of Holocene data
    plot(x,y,'.','MarkerSize',10,'Color',[color],'HandleVisibility','off')
    
    set(gca,'YDir','reverse')
    xlim([0,200]);
    ylim_set=[0,0,400,300,200];
    ylimits=[0,ylim_set(i)];
    ylim(ylimits)
    y(y>=ylimits(2))=[];
    
    %title(it_list{i},'FontSize',20)
    ylabel('Local ACD (m)')
    xlabel('Thermocline Depth (m)')
    if i==4
        legend('Constant Thermocline Position','Best Fit Line','Constant Depth','Location','SouthEast')
    end
%     h=get(gca,'Children');
%     set(gca,'Children',[h(3),h(4),h(2),h(1)])
end

load('Thermocline_Percent/TP_80.mat')
[~,~,TP_data]=cycle_data(Lon,Lat,TP_data,25);
load('WOA_04_mask.mat','Mask','Lon','Lat')
[Lon,Lat,Mask]=cycle_data_3D(Lon',Lat',Mask,25);
latvec=Lat(1,:);
lonvec=Lon(:,1);
[~,I1]=min(abs(latvec+30));
[~,I2]=min(abs(latvec-30));

subplot(2,2,4)
hold on
[M,c]=contourf(Lon(:,I1:I2),Lat(:,I1:I2),TP_data(:,I1:I2),256);
c.LineStyle='none';
mi=min(TP_data(:,I1:I2),[],'all');mi=mi*0.95;
contourf(Lon(:,I1:I2),Lat(:,I1:I2),squeeze(Mask(:,I1:I2,1)).*mi)
colorbar
colormap(flipud(jet))
cmap=colormap;
cmap(1,:)=[0.75,0.75,0.75];
colormap(cmap)
axis([25,24+360,-30,30])
xticks([40, 80, 120, 160, 200, 240, 280, 320, 360]);
xticklabels({'40\circE','80\circE','120\circE','160\circE','160\circW','120\circW','80\circW','40\circW','0'});
yticks([-30,-15,0,15,30]);
yticklabels({'30\circS','15\circS','0\circ','15\circN','30\circN'});
%title('Depth of 80% Thermocline Position Map','FontSize',20)
