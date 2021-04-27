addpath('Functions')
load('WOA_04_mask.mat')
[Lon,Lat,Mask]=cycle_data(Lon',Lat',squeeze(Mask(:,:,1)),25);
%a=(Mask==1);
Holocene=0;
list={'Gruberwhite','Tsacculifer','Gtumida','Ndutertrei','Pobliquiloculata'};
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
if Holocene
    load('Data/Best_ACD_Holocene.mat')
else
    load('Data/Best_ACD.mat')
end
Spec_depth=best_depths_RMS;
cax=[-3.75,3];
width=1500;
bottom=ceil(width/5)+100;
for i=1:5
    figure('Position',[0,bottom,width,bottom])
    if Holocene
        load(strcat('Data/',list{i},'_Global_ACD_Holocene.mat'))
    else
        load(strcat('Data/',list{i},'_Global_ACD.mat'))
    end
    cleanLongitude(cleanLongitude<=25)=cleanLongitude(cleanLongitude<=25)+360;
    
    a=subplot(length(list),2,2*i-1);
    a.Position=[0.05,0.09,0.45,0.8150];
    hold on
    c=colormap('jet');
    c=flipud(c);
    c(1,:) = [0.75,0.75,0.75];
    colormap(c)
    contourf(Lon,Lat,Mask*cax(1))
    scatter(cleanLongitude,cleanLatitude,[30],expected,'filled')
    caxis(cax)
    a=colorbar;
    axis([25,24+360,-30,30])
    xticks([40, 80, 120, 160, 200, 240, 280, 320, 360]);
    xticklabels({'40\circE','80\circE','120\circE','160\circE','160\circW','120\circW','80\circW','40\circW','0'});
    yticks([-30,-15,0,15,30]);
    yticklabels({'30\circS','15\circS','0\circ','15\circN','30\circN'});
    %title(strcat(it_list{i}," Predicted \delta^{18}O, Global Depth = ",string(Spec_depth(i)),'m'),'FontSize',20)
    
    b=subplot(length(list),2,2*i);
    b.Position=[0.55,0.09,0.45,0.8150];
    hold on
    c=colormap('jet');
    c=flipud(c);
    c(1,:) = [0.75,0.75,0.75];
    colormap(c)
    contourf(Lon,Lat,Mask*cax(1))
    scatter(cleanLongitude,cleanLatitude,[30],actual,'filled')
    caxis(cax)
    a=colorbar;
    axis([25,24+360,-30,30])
    xticks([40, 80, 120, 160, 200, 240, 280, 320, 360]);
    xticklabels({'40\circE','80\circE','120\circE','160\circE','160\circW','120\circW','80\circW','40\circW','0'});
    yticks([-30,-15,0,15,30]);
    yticklabels({'30\circS','15\circS','0\circ','15\circN','30\circN'});
    %title(strcat(it_list{i},' Core data'),'FontSize',20)
end