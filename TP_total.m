clearvars
frac_list=linspace(0.1, 1, 91);
TP_data_tot=ones(1440,674,length(frac_list));
for i=1:length(frac_list)
    frac=frac_list(i)*100;
    str=strcat('TP_',num2str(frac),'.mat');
    load(str)
    TP_data_tot(:,:,i)=TP_data;
end
save('TP_total.mat','Lat','Lon','TP_data_tot')