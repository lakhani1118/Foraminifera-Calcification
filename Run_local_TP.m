clearvars
addpath('Functions')
Holocene=1; %Make Local_Percents_Holocene.mat
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
TP=ones(size(StoredDepths))*NaN;
it_list={'{\it G. ruber} (white)','{\it T. sacculifer}','{\it G. tumida}','{\it N. dutertrei}','{\it P. obliquiloculata}'};
p=0;
frac_list=0.1:0.01:1;frac_list=frac_list';
for i=1:length(it_list)
    data=StoredDepths(i,:);lon=StoredLong(i,:);lat=StoredLat(i,:);
    data(data==-900)=nan;data(data==-999)=nan;
    a=isnan(data);
    data(a)=[];lon(a)=[];lat(a)=[];
    ranges=ones(length(lat),1).*5;
    for k=1:length(data)
        [~,I1]=min(abs(lonvec-lon(k)));
        [~,I2]=min(abs(latvec-lat(k)));
        range=5;
        data3=Temps(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        X3sub=X3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        Y3sub=Y3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        Z3sub=Z3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
        profile=interp3(X3sub,Y3sub,Z3sub,data3,lat(k),lon(k),[0,data(k),1000],'linear');
        profile=squeeze(profile);
        nearland=[];
        alph=nan;
        if sum(isnan(profile))==0
            alph=1-(profile(1)-profile(2))/(profile(1)-profile(3));
        elseif profile(1)==profile(2)
            alph=1;
        elseif and(isnan(profile(3)),~isnan(profile(1)))
            depth_profile=squeeze(TP_data_tot(I1,I2,:));
            depth_profile(end)=0;a=isnan(depth_profile);
            frac_list2=frac_list(~a);depth_profile(a)=[];
            depth_profile=depth_profile+linspace(1,length(depth_profile),length(depth_profile))'.*.00001;
            if data(k)>max(depth_profile)
                alph=min(frac_list2)-0.01;
            else
                alph=interp1(depth_profile,frac_list2,data(k));
            end
        end
        if data(k)==0
            alph=1;
        end
        while isnan(alph)
            disp(range)
            range=ranges(i)+1;
            data3=Temps(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
            X3sub=X3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
            Y3sub=Y3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
            Z3sub=Z3(mindata(I1-range):maxdata(I1+range,1440),mindata(I2-range):maxdata(I2+range,674),:);
            profile=interp3(X3sub,Y3sub,Z3sub,data3,lat(k),lon(k),z,'linear');
            s=size(data3);
            for m=1:s(1)
                for n=1:s(2)
                    I3=I1-range+m-1;
                    I4=I2-range+m-1;
                    depth_profile=squeeze(TP_data_tot(I3,I4,:));
                    depth_profile(end)=0;depth_profile(isnan(depth_profile))=9999;
                    depth_profile=depth_profile+linspace(1,length(depth_profile),length(depth_profile))'.*.00001;
                    alph=interp1(depth_profile,frac_list,data(k));
                    if ~isnan(alph)
                        nearland=[nearland,alph];
                    end
                end
            end
            ranges(i)=range;
            if ~isempty(nearland)
                alph=mean(nearland);
            end
        end
        TP(i,k)=alph;
    end
end
if Holocene
    save('Data/Local_TP_Holocene.mat','it_list','StoredLat','StoredLong','TP')
else
    save('Data/Local_TP.mat','it_list','StoredLat','StoredLong','TP')
end