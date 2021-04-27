clearvars
clc
addpath('../Functions')
load('../WOA_04_temp.mat')
[Lon,Lat,Temps]=cycle_data_3D(Lon',Lat',Temps,0);
frac_list=0.1:0.01:1;

for ind=1:length(frac_list)
    frac=frac_list(ind);
    frac=0;
    disp(frac)
    TP_data=ones(length(lonvec),length(latvec)).*NaN;
    lonvec=Lon(:,1);
    latvec=Lat(1,:);
    i=300;
    j=600;
    for j=1:length(lonvec)
        for i=1:length(latvec)
            a=0;
            if isnan(Temps(j,i,1))
                TP_data(j,i)=NaN;
            else
                while 1
                    profile=Temps(mindata(j-a):maxdata(j+a,1440),mindata(i-a):maxdata(i+a,674),:);
                    b=squeeze(profile(:,:,47));
                    if sum(~isnan(b),'all')
                        break
                    end
                    a=a+1;
                end
                bottom=nanmean(b,'all');
                top=nanmean(squeeze(Temps(j,i,1:3)));
                profile=squeeze(Temps(j,i,:));
                depths=Depths(~isnan(profile));
                profile=profile(~isnan(profile));
                profile=profile+linspace(1,length(profile),length(profile))'.*.00000000000001;
                val=top-(1-frac)*(top-bottom);
                if length(profile)<10
                    TP=NaN;
                else
                    TP=interp1(profile,depths,val);
                end
                TP_data(j,i)=TP;
            end
        end
    end
    fr=round((frac+0.0001)*100,0);
    str=strcat('TP_',string(fr),'.mat');
    disp(ind)
    save(str,'Lon','Lat','TP_data')
end