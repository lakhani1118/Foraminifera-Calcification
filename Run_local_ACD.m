clearvars
addpath('Functions')
load('WOA_04_salt.mat');
load('WOA_04_temp.mat');
z=Depths;
load('Make d18O field/d18O_paper.mat')
d18O=d18O1;
clear d18O1
load('Data/ImportedData.mat');
Holocene=1; %Make Local_ACD_Holocene.mat
[X3,Y3,Z3]=meshgrid(latvec,lonvec,z);
list={'Gruberwhite','Tsacculifer','Gtumida','Ndutertrei','Pobliquiloculata'};
larg=0;
tic
for j=1:length(list)
    dat=eval(char(list(j)));
    Tropics=abs(Latitudes)<30;
    dat=dat(Tropics);Lats=Latitudes(Tropics);Lons=Longitudes(Tropics);Chronozone=TimeConstraint(Tropics);
    if Holocene
        [cleand18O,cleanLatitude,cleanLongitude,cleanTime]=clean_data_time(dat,Lats,Lons,Chronozone,[1,2,3,4]);
    else
        [cleand18O,cleanLatitude,cleanLongitude,cleanTime]=clean_data_time(dat,Lats,Lons,Chronozone,[1,2,3,4,5,6]);
    end
    if length(cleand18O)>larg
        larg=length(cleand18O);
    end
end
StoredDepths=ones(length(list),larg)*-999;
StoredLong=ones(length(list),larg)*-999;
StoredLat=ones(length(list),larg)*-999;
Storedd18O=ones(length(list),larg)*-999;
toc

for j=1:length(list)
    clear InferredDepth profile endvalue
    dat=eval(char(list(j)));
    Tropics=abs(Latitudes)<30;
    dat=dat(Tropics);Lats=Latitudes(Tropics);Lons=Longitudes(Tropics);Chronozone=TimeConstraint(Tropics);
    if Holocene
        [cleand18O,cleanLatitude,cleanLongitude,cleanTime]=clean_data_time(dat,Lats,Lons,Chronozone,[1,2,3,4]);
    else
        [cleand18O,cleanLatitude,cleanLongitude,cleanTime]=clean_data_time(dat,Lats,Lons,Chronozone,[1,2,3,4,5,6]);
    end
    ranges=ones(length(cleanLatitude),1).*4;
    for i=1:length(cleanLatitude)
        a=cleanLatitude(i);
        b=cleanLongitude(i);
        [A,Ilat]=min(abs(latvec-a));
        [A,Ilon]=min(abs(lonvec-b));
        range=4;
        nearland=[];
        data3=d18O(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
        X3sub=X3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
        Y3sub=Y3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
        Z3sub=Z3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
        profile=interp3(X3sub,Y3sub,Z3sub,data3,cleanLatitude(i),cleanLongitude(i),z,'linear');
        profile=squeeze(profile);
        endvalue=min(find(isnan(profile)));
        profile=profile(1:endvalue-1);
        alph=nan;
        if length(profile)>2
            zsub=z(1:endvalue-1);
            adder=1:length(profile);
            profile=profile(:)+.000000001.*adder(:);
            alph=interp1(profile,zsub,cleand18O(i));
            if isnan(alph)
                [ma,Imax]=max(profile);mi=min(profile);
                if cleand18O(i)<mi
                    alph=0;
                    nearland=alph;
                elseif cleand18O(i)>ma
                    alph=zsub(Imax);
                    nearland=alph;
                end
            else
                nearland=alph;
            end
        end
        
        while isempty(nearland)
            range=ranges(i)+1;
            data3=d18O(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
            X3sub=X3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
            Y3sub=Y3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
            Z3sub=Z3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),:);
            s=size(data3);
            for m=1:s(1)
                for n=1:s(2)
                    data2=squeeze(data3(m,n,:));
                    Z2=squeeze(Z3sub(m,n,:));
                    pos=isnan(data2);
                    data2(pos)=[];Z2(pos)=[];
                    if and(length(data2)>2,sort(data2)==data2)
                        if cleand18O(i)<min(data2)
                            nearland=[nearland, 0];
                        else
                            expectedDepth=interp1(data2,Z2,cleand18O(i));
                            if ~isnan(expectedDepth)
                                nearland=[nearland, expectedDepth];
                            end
                        end
                    end
                end
            end
            ranges(i)=range;
        end
        
        InferredDepth(i)=mean(nearland);
   end
    disp(length(InferredDepth))
    SpeciesLength(j)=length(InferredDepth);
    while length(InferredDepth)<larg
        InferredDepth=[InferredDepth NaN];
        cleanLatitude=[cleanLatitude NaN];
        cleanLongitude=[cleanLongitude NaN];
        cleand18O=[cleand18O NaN];
    end
    StoredDepths(j,:)=InferredDepth;
    StoredLong(j,:)=cleanLongitude;
    StoredLat(j,:)=cleanLatitude;
    Storedd18O(j,:)=cleand18O;
    SpeciesDepth(j)=nanmean(InferredDepth);
    SpeciesSTD(j)=nanstd(InferredDepth);
end
toc
if Holocene
    save('Data/Local_ACD_Holocene.mat','StoredDepths','StoredLat','StoredLong','Storedd18O','list')
else
    save('Data/Local_ACD.mat','StoredDepths','StoredLat','StoredLong','Storedd18O','list')
end