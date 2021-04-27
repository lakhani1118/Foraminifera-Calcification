clearvars
addpath('Functions')
load('Data/Best_TP.mat','best_TP_RMS')
Global_Percent=best_TP_RMS;
Holocene=0;
if Holocene
    load('Data/Local_ACD_Holocene.mat')
else
    load('Data/Local_ACD.mat')
end
load('Thermocline_Percent/TP_total.mat')
[~,~,TP_data_tot]=cycle_data_3D(Lon,Lat,TP_data_tot,180);
load('WOA_04_temp.mat')
z=Depths;
[X3,Y3,Z3]=meshgrid(latvec,lonvec,z);
Constant_Percent=ones(size(StoredDepths))*NaN;
newlist=[2,3,5,6,7];
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
p=0;
frac_list=1:91;frac_list=frac_list';
for i=1:5
    data=StoredDepths(i,:);lon=StoredLong(i,:);lat=StoredLat(i,:);
    a=isnan(data);
    data(a)=[];lon(a)=[];lat(a)=[];
    for k=1:length(data)
        [~,I1]=min(abs(lonvec-lon(k)));
        [~,I2]=min(abs(latvec-lat(k)));
        range=5;
        data3=Temps(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        X3sub=X3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        Y3sub=Y3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        Z3sub=Z3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        profile=interp3(X3sub,Y3sub,Z3sub,data3,lat(k),lon(k),z,'linear');
        profile=squeeze(profile);
        endvalue=find(isnan(profile),1);
        profile=profile(1:endvalue-1);
        zsub=z(1:endvalue-1);
        if length(profile)<2
            Constant_Percent(i,k)=NaN;
        else
            depth_profile=squeeze(TP_data_tot(I1,I2,:));
            depth_profile(end)=0;depth_profile(isnan(depth_profile))=9999;
            depth_profile=depth_profile+linspace(1,length(depth_profile),length(depth_profile))'.*.00001;
            alph=interp1(frac_list+9,depth_profile,Global_Percent(i));
            Constant_Percent(i,k)=alph;
            p=p+1;
        end
    end
    disp(p)
end
Constant_Percent(Constant_Percent>1000)=nan;

if Holocene
    save('Data/Constant_Percent_Holocene.mat','Constant_Percent','Global_Percent')
else
    save('Data/Constant_Percent.mat','Constant_Percent','Global_Percent')
end
