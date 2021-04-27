addpath('..')
load('MARGO_raw_data.mat')
load('../Make d18O field/d18O_paper.mat')
d18O=d18O1;
clear d18O1
list={'Gruberwhite','Tsacculifer'};
Time=[1,2,3,4,5];%Chronozones for analysis
for i=1:2
    data=eval(string(list(i)));
    Tropics=abs(Latitudes)<30;
    data=data(Tropics);Latitude_set=Latitudes(Tropics);Longitude_set=Longitudes(Tropics);Chronozone=Age(Tropics);
    [Depthset,R2,RMS,ad,cleanLatitude,cleanLongitude]=Global_depth_analysis(data,Latitude_set,Longitude_set,d18O,Chronozone,Time);
    [A,I]=max(R2);
    best_depths_R2(i)=Depthset(I);
    best_R2(i)=A;
    [A,I]=min(RMS);
    best_depths_RMS(i)=Depthset(I);
    best_RMS(i)=A;
end