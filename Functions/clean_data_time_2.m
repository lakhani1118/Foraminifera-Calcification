function [cleandata,cleanlatitude,cleanlongitude,cleanTime1]=clean_data_time_2(dat,latitude, longitude,timeConstraint,val,WaterDepth)
% Strips the NaN values from the data so that the length of the variable is
% the amount of data points
    cleandata1=[];
    cleanlatitude1=[];
    cleanlongitude1=[];
    cleanTime1=[];
    ilist=[];
    for i=1:length(dat)
        if and(and(isnan(dat(i))+isnan(latitude(i))+isnan(longitude(i))==0,find(val==timeConstraint(i))),WaterDepth(i)>500)
            cleandata1=[cleandata1,dat(i)];
            cleanlatitude1=[cleanlatitude1, latitude(i)];
            cleanlongitude1=[cleanlongitude1,longitude(i)];
            cleanTime1=[cleanTime1,timeConstraint(i)];
            ilist=[ilist i];
        end
    end
    [cleanlatitude,cleanlongitude,cleandata]=average_replicates(cleanlatitude1,cleanlongitude1,cleandata1);
    %cleanlatitude=cleanlatitude1;cleanlongitude=cleanlongitude1;cleandata=cleandata1;cleanTime=cleanTime1;
end