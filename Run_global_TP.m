addpath('Functions')
load('Data/ImportedData.mat')
load('Make d18O field/d18O_paper.mat','d18O1')
d18O=d18O1;
clear d18O1
Holocene=0;
if Holocene
    Time=[1,2,3,4]; 
else
    Time=[1,2,3,4,5,6];
end
list={'Gruberwhite','Tsacculifer','Gtumida','Ndutertrei','Pobliquiloculata'};
for i=1:length(list)
    data=eval(string(list(i)));
    Tropics=abs(Latitudes)<30;
    data=data(Tropics);Latitude_set=Latitudes(Tropics);Longitude_set=Longitudes(Tropics);Chronozone=TimeConstraint(Tropics);
    [TPset,R2,RMS,ad,cleanLatitude,cleanLongitude]=Global_TP_analysis(data,Latitude_set,Longitude_set,d18O,Chronozone,Time);
    [A,I]=max(R2);
    best_TP_R2(i)=TPset(I);
    best_R2(i)=A;
    figure()
%     subplot(2,1,1)
    plot(TPset,RMS)
%     subplot(2,1,2)
%     hold on
%     plot(ad(1,:),ad(2,:),'ok')
%     plot(xlim,xlim,'--k')
%     plot(ylim,ylim,'--k')
    [A,I]=min(RMS);
    best_TP_RMS(i)=TPset(I);
    best_RMS(i)=A;
    actual=ad(1,:);
    expected=ad(2,:);
    if Holocene
        save(strcat('Data/',string(list(i)),'_Global_TP_Holocene.mat'),'cleanLatitude','cleanLongitude','actual','expected','Time')
    else
        save(strcat('Data/',string(list(i)),'_Global_TP.mat'),'cleanLatitude','cleanLongitude','actual','expected','Time')
    end
end
disp(best_TP_RMS/100)
disp(best_RMS)
if Holocene
    save('Data/Best_TP_Holocene.mat','best_TP_R2','best_R2','best_TP_RMS','best_RMS','list','Time')
else
    save('Data/Best_TP.mat','best_TP_R2','best_R2','best_TP_RMS','best_RMS','list','Time')
end