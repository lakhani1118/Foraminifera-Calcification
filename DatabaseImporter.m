clearvars
data=importdata("Core top dataset.xlsx");
Latitudes=data.data(:,3);
Longitudes=data.data(:,4);
Gruberwhite=data.data(:,18);
Tsacculifer=data.data(:,22);
Ndutertrei=data.data(:,26);
Gtumida=data.data(:,30);
Pobliquiloculata=data.data(:,34);
TimeConstraint=data.data(:,9);
WaterDepth=data.data(:,5);
save('Data/ImportedData.mat')