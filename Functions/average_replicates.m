function [cleanlatitude,cleanlongitude,cleandata]=average_replicates(Latitudes,Longitudes,data)
resolution=0.01;
grid_Lat=round(min(Latitudes),1):resolution:round(max(Latitudes),1);
grid_Lon=round(min(Longitudes),1):resolution:round(max(Longitudes),1);
output_indices=[1];
for i=2:length(Latitudes)
    a=Latitudes(i);
    b=Longitudes(i);
    unique=1;
    s=size(output_indices);
    for j=1:s(1)
        if Latitudes(output_indices(j,1))-a>resolution*10
            
        else
            [~,I1]=min(abs(grid_Lat-Latitudes(output_indices(j,1))));
            [~,I2]=min(abs(grid_Lon-Longitudes(output_indices(j,1))));
            [~,I3]=min(abs(grid_Lat-a));
            [~,I4]=min(abs(grid_Lon-b));
            if and(and(I1==I3,I2==I4),unique==1)
                tmp=find(output_indices(j,:));
                output_indices(j,length(tmp)+1)=i;
                unique=0;
            end
        end
    end
    if unique
        output_indices(s(1)+1,1)=i;
    end
end
s=size(output_indices);
for i=1:s(1)
    a=find(output_indices(i,:));
    [~,I1]=min(abs(grid_Lat-Latitudes(output_indices(i,a(1)))));
    cleanlatitude(i)=grid_Lat(I1);
    [~,I2]=min(abs(grid_Lon-Longitudes(output_indices(i,a(1)))));
    cleanlongitude(i)=grid_Lon(I2);
    cleandata(i)=mean(data(output_indices(i,a)));
end
end