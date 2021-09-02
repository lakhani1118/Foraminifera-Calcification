clearvars
addpath('Functions')
Holocene=1;
if Holocene
    load('Data/Local_ACD_Holocene.mat')
else
    load('Data/Local_ACD.mat')
end
load('WOA_04_mask.mat')
[Lon,Lat,Mask]=cycle_data(Lon',Lat',squeeze(Mask(:,:,1)),25);
list={'Gruberwhite','Tsacculifer','Gtumida','Ndutertrei','Pobliquiloculata'};
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
width=800;
bottom=ceil(width/2);
for i=1:length(it_list)
    figure('Position',[0,bottom-100,width,bottom])
    hold on
    Depths=StoredDepths(i,:);
    Depths(Depths==-900)=NaN;Depths(Depths==-999)=NaN;
    Lati=StoredLat(i,:);
    Long=StoredLong(i,:);
    Long(Long<=25)=Long(Long<=25)+360;
    me=nanmean(Depths);stdev=nanstd(Depths);
    Depths(Depths>me+3*stdev)=NaN;
    Depths(Depths<me-3*stdev)=NaN;
    disp(quantile(Depths,[0.025, 0.975]))
    cax=[-1,max(Depths)];
    contourf(Lon,Lat,Mask*cax(1))
    c=colormap('jet');
    c=flipud(c);
    c(1,:) = [0.75,0.75,0.75];
    colorbar
    scatter(Long,Lati,[30],Depths,'filled')
    colormap(c)
    caxis(cax)
    axis([25,24+360,-30,30])
    xticks([40, 80, 120, 160, 200, 240, 280, 320, 360]);
    xticklabels({'40\circE','80\circE','120\circE','160\circE','160\circW','120\circW','80\circW','40\circW','0'});
    yticks([-30,-15,0,15,30]);
    yticklabels({'30\circS','15\circS','0\circ','15\circN','30\circN'});
    %title(strcat(it_list{i},' Local Depths'),'FontSize',20)
end