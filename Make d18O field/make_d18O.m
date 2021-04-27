clc
clearvars
load('../WOA_04_temp.mat');
load('../Legrande_Schmidt.mat')
z=Depths;
[X3,Y3,Z3]=meshgrid(latvec,lonvec,z);
[LX3,LY3,LZ3]=meshgrid(LegrandeLat,LegrandeLon,Legrandedepths);
%% 
d18OtoTemp=@(Temp,d18Osw) (d18Osw-.27)-.2*Temp+3.25;

%%
d18O1=ones(size(Temps))*-900;
for i=1:length(lonvec)
    for j=1:length(latvec) 
        %For every data location in lon, lat, and z
        %Decide which basin, and use appropriate paleotemperature
        %equation to calculate d18O
        d18Osw=interp3(LX3,LY3,LZ3,Legranded18Osw,latvec(j),lonvec(i),z);
        d18O1(i,j,:)=d18OtoTemp(Temps(i,j,:),d18Osw);
        disp(j)
    end
    disp(i)
end
d18O1(d18O1<-30)=NaN;
save('d18O_test.mat','d18O1','X3','Y3','Z3')