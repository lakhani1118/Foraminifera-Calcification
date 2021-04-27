function [TPset,R2,RMS,ad,cleanLatitude,cleanLongitude]=Global_TP_analysis(dat, latitude, longitude,d18O,TimeConstraint,val)
load('WOA_04_salt.mat');
load('WOA_04_temp.mat');
z=Depths;
[X3,Y3,Z3]=meshgrid(latvec,lonvec,z);
[cleand18O,cleanLatitude,cleanLongitude]=clean_data_time(dat,latitude,longitude,TimeConstraint,val);
disp(size(cleanLatitude))
meany=mean(dat);
tic;
TPset=10:1:100;
optexp=[];
optact=[];
R2=[];
RMS=[100];
ranges=ones(length(cleanLatitude),1);
for fracs=1:length(TPset)
    load_string=strcat('Thermocline_Percent/TP_',string(TPset(fracs)),'.mat');
    load(load_string)
    [newLon,newLat,TP_data]=cycle_data(Lon,Lat,TP_data,180);
    expected=[];
    actual=[];
    ilist=[];
    for i=1:length(cleanLatitude)
        a=cleanLatitude(i);
        b=cleanLongitude(i);
        [~,Ilat]=min(abs(latvec-a));
        [~,Ilon]=min(abs(lonvec-b));
        c=TP_data(Ilon,Ilat);
        [~,Idepth]=min(abs(z-c));
        range=2;
        data=d18O(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
        data2=data;
        data(data==-900)=900;
        range=3;
        data3=d18O(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
        X3sub=X3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
        Y3sub=Y3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
        Z3sub=Z3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
        if data ==data2
            expectedd18O=interp3(X3sub,Y3sub,Z3sub,data3,cleanLatitude(i),cleanLongitude(i),[c],'linear');
            expected=[expected expectedd18O];
            actual=[actual cleand18O(i)];
            ilist=[ilist i];
        else
            nearland=[];
            range=ranges(i);
            while isempty(nearland)
                range=range+1;
                data3=d18O(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
                X3sub=X3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
                Y3sub=Y3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
                Z3sub=Z3(mindata(Ilon-range):maxdata(Ilon+range,1440),mindata(Ilat-range):maxdata(Ilat+range,674),1:maxdata(Idepth+range,102));
                s=size(data3);
                for m=1:s(1)
                    for n=1:s(2)
                        data2=squeeze(data3(m,n,:));
                        Z2=squeeze(Z3sub(m,n,:));
                        if sum(isnan(data2(1:Idepth+1)))==0
                            expectedd18O=interp1(Z2,data2,c);
                            nearland=[nearland, expectedd18O];
                        end
                    end
                end
            end
            if isempty(nearland)
                disp(1)
            end
            ranges(i)=range-1;
            expected=[expected nanmean(nearland)];
            actual=[actual cleand18O(i)];
            ilist=[ilist i];
        end
    end
    good=~isnan(expected);
    aleph=corrcoef(expected(good),actual(good));
    R2(fracs)=aleph(2,1);
    RMS_val=sqrt(sum((expected(good)-actual(good)).^2)./length(actual(good))); %SSres
    if RMS_val<min(RMS)
        optact=actual;
        optexp=expected;
    end
    RMS(fracs)=RMS_val;
%     vals(j,1)=std(actual(good));
%     vals(j,2)=std(expected(good));
%     vals(j,3)=mean(expected)-mean(actual);
%     vals(j,4)=mean(abs(expected-actual));
end
actual=optact;
expected=optexp;
ad=[actual;expected];
toc;
end