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
    [Depthset,R2,RMS,ad,cleanLatitude,cleanLongitude]=Global_ACD_analysis(data,Latitude_set,Longitude_set,d18O,Chronozone,Time);
    [A,I]=max(R2);
    best_depths_R2(i)=Depthset(I);
    best_R2(i)=A;
    [A,I]=min(RMS);
    best_depths_RMS(i)=Depthset(I);
    best_RMS(i)=A;
    actual=ad(1,:);
    expected=ad(2,:);
    if Holocene
        save(strcat('Data/',string(list(i)),'_Global_ACD_Holocene.mat'),'cleanLatitude','cleanLongitude','actual','expected','Time')
    else
        save(strcat('Data/',string(list(i)),'_Global_ACD.mat'),'cleanLatitude','cleanLongitude','actual','expected','Time')
    end
end
if Holocene
    save('Data/Best_ACD_Holocene.mat','best_depths_R2','best_R2','best_depths_RMS','best_RMS','list','Time')
else
    save('Data/Best_ACD.mat','best_depths_R2','best_R2','best_depths_RMS','best_RMS','list','Time')
end
disp(best_depths_RMS)
disp(best_RMS)