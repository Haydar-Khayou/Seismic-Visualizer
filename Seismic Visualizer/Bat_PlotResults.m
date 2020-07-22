%% Plotting
%% Synthetic

load('Seis_maps.mat');
global Data Coor Coor_Trim Sec_Size iteration
Xaxis= Data.X_axis;
Yaxis= Data.Yaxis_Extra;
Obs= Data.Cleaned_Section;    % Observed Data is the Seismic Section
Total_Obs= Data.ExportSection;

NEL= numel(Obs);    % number of cells of Seis/synth matrix


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Carbonates
AOI_Synthetic= gBat.Global.Car(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Carbonates Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Car(end).final_cost,3) ' %']});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

Car_Dev= abs((Obs - AOI_Synthetic))/(max(max(abs((Obs - AOI_Synthetic)))));
figure;imagesc(Xaxis, Yaxis, Car_Dev, [0 1]);
title('Carbonates Synthetic Normalized Error');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(flipud(gray));
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Misfit(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

Obs= Data.Cleaned_Section;    % Observed Data is the Seismic Section
Total_Obs= Data.ExportSection;
NEL= numel(Obs);    % number of cells of Seis/synth matrix
ress= ~Data.Horizons_grid_remove;
rest_Seis= Total_Obs .* ress;
Total_Synthetic= gBat.Global.Car(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Carbonates Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Car(end).final_cost,3) ' %']});colormap(Red_blue_map);
xlabel('Trace Number');
ylabel('Time(ms)');
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

%% Clas
AOI_Synthetic= gBat.Global.Clas(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Clastics Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Clas(end).final_cost,3) ' %']});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

Clas_Dev= abs((Obs - AOI_Synthetic))/(max(max(abs((Obs - AOI_Synthetic)))));
figure;imagesc(Xaxis, Yaxis, Clas_Dev, [0 1]);
t= title('Clastic Synthetic Normalized Error');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(flipud(gray));
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Misfit(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

Obs= Data.Cleaned_Section;    % Observed Data is the Seismic Section
Total_Obs= Data.ExportSection;
NEL= numel(Obs);    % number of cells of Seis/synth matrix
ress= ~Data.Horizons_grid_remove;
rest_Seis= Total_Obs .* ress;
Total_Synthetic= gBat.Global.Clas(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Clastics Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Clas(end).final_cost,3) ' %']});colormap(Red_blue_map);
xlabel('Trace Number');
ylabel('Time(ms)');
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

%% Bas
AOI_Synthetic= gBat.Global.Bas(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Basalt Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Bas(end).final_cost,3) ' %']});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

Bas_Dev= abs((Obs - AOI_Synthetic))/(max(max(abs((Obs - AOI_Synthetic)))));
figure;imagesc(Xaxis, Yaxis, Bas_Dev, [0 1]);
title('Basalt Synthetic Normalized Error');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(flipud(gray));
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Misfit(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

Obs= Data.Cleaned_Section;    % Observed Data is the Seismic Section
Total_Obs= Data.ExportSection;
NEL= numel(Obs);    % number of cells of Seis/synth matrix
ress= ~Data.Horizons_grid_remove;
rest_Seis= Total_Obs .* ress;
Total_Synthetic= gBat.Global.Bas(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Basalt Synthetic Section', ['NRMSE= ' num2str(gBat.Global.Bas(end).final_cost,3) ' %']});colormap(Red_blue_map);
xlabel('Trace Number');
ylabel('Time(ms)');
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

mi= abs(min(min(Obs)));
ma= abs(max(max(Obs)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Obs, [-RR RR]);
title('Seismic Section');
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(Red_blue_map);
cc= colorbar;
cc.Label.String='Amplitude';
ddd= gca;
ddd.FontSize= 28;

%% Bulk Density
figure; imagesc(Xaxis, Yaxis, gBat.Global.Car(end).Bulk_Density_Model);
title({'Bulk Density model for Carbonates'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
colorbar
cc=colorbar;
cc.Label.String='Bulk Density g/cc';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Clas(end).Bulk_Density_Model);
title({'Bulk Density model for Clastics'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Bulk Density g/cc';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Bas(end).Bulk_Density_Model);
title({'Bulk Density model for Basalt'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Bulk Density g/cc';
ddd= gca;
ddd.FontSize= 28;

%%%%%%%%%%%%%%

%% Velocity
figure; imagesc(Xaxis, Yaxis, gBat.Global.Car(end).Velocity_Model);
title({'Velocity Model for Carbonates'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
colorbar
cc=colorbar;
cc.Label.String='Velocity  Km/s';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Clas(end).Velocity_Model);
title({'Velocity Model for Clastics'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Velocity  Km/s';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Bas(end).Velocity_Model);
title({'Velocity Model for Basalt'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Velocity  Km/s';
ddd= gca;
ddd.FontSize= 28;

%%%%%%%%%%%%%%

% % %% Histogram
% % 
% % figure;hist(Leftpor)
% % xlabel('Porosity(P.U)');
% % ylabel('Number of Occurences');
% % figure;scatter(1:iteration, Leftpor)
% % xlabel('Iterations');
% % ylabel('Porosity(P.U)');
% % 
% % figure;hist(Rightpor)
% % xlabel('Porosity(P.U)');
% % ylabel('Number of Occurences');
% % figure;scatter(1:iteration, Rightpor)
% % xlabel('Iterations');
% % ylabel('Porosity(P.U)');

%% Porosity
figure; imagesc(Xaxis, Yaxis, gBat.Global.Car(end).pos.POR.FullMatrix, [0 1]);
itt= num2str(gBat.Global.Car(end).iteration);
err= gBat.Global.Car(end).final_cost;
porEq= gBat.Global.Car(end).VpEq;
if porEq==1
    porEq= 'RHG';
elseif porEq==2
    porEq= 'WGG';
elseif porEq==3
     porEq= 'GGG';
end
title({'Porosity model for Carbonates', ['Velocity Eq: ' porEq   '        NRMSE= ' num2str(err, 3) '%        Iter= ' itt]});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet)
colorbar
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Porosity(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Clas(end).pos.POR.FullMatrix,[0 1]);
itt= num2str(gBat.Global.Clas(end).iteration);
err= gBat.Global.Clas(end).final_cost;
porEq= gBat.Global.Clas(end).VpEq;
if porEq==1
    porEq= 'RHG';
elseif porEq==2
    porEq= 'WGG';
elseif porEq==3
     porEq= 'GGG';
end
title({'Porosity model for Clastics', ['Velocity Eq: ' porEq   '        NRMSE= ' num2str(err, 3) '%        Iter= ' itt]});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet)
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Porosity(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gBat.Global.Bas(end).pos.POR.FullMatrix, [0 1]);
itt= num2str(gBat.Global.Bas(end).iteration);
err= gBat.Global.Bas(end).final_cost;
porEq= gBat.Global.Bas(end).VpEq;
if porEq==1
    porEq= 'RHG';
elseif porEq==2
    porEq= 'WGG';
elseif porEq==3
     porEq= 'GGG';
end
title({'Porosity model for Basalt', ['Velocity Eq: ' porEq   '        NRMSE= ' num2str(err, 3) '%        Iter= ' itt]});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet)
cc=colorbar;
f=str2double(cc.TickLabels);
f=f*100;
f=num2str(f);
cc.TickLabels=f;
cc.Label.String='Porosity(%)';
ddd= gca;
ddd.FontSize= 28;
cc.FontSize= 12;
cc.Label.FontSize= 28;

%% Average Bats Cost

figure;plot(1:length(gBat.Global.Car_avr_Bats),gBat.Global.Car_avr_Bats, 'LineWidth', 2)
hold on 
plot(1:length(gBat.Global.Clas_avr_Bats),gBat.Global.Clas_avr_Bats, 'LineWidth', 2);
plot(1:length(gBat.Global.Bas_avr_Bats),gBat.Global.Bas_avr_Bats, 'LineWidth', 2);
title('Average Error for Bats');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonates', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 30;

%% Average bBats Cost

figure;plot(1:length(gBat.Global.Car_avr_bBats), gBat.Global.Car_avr_bBats, 'LineWidth', 2)
hold on 
plot(1:length(gBat.Global.Clas_avr_bBats), gBat.Global.Clas_avr_bBats, 'LineWidth', 2);
plot(1:length(gBat.Global.Bas_avr_bBats), gBat.Global.Bas_avr_bBats, 'LineWidth', 2);
title('Average Error for bBats');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonates', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 28;

%% plot global best for scenarios
cx= [gBat.Global.Car_ObjFun];
figure; plot(1:length(gBat.Global.Car_ObjFun), cx(1:end), 'LineWidth', 2)
hold on
cx= [gBat.Global.Clas_ObjFun];
plot(1:length(gBat.Global.Clas_ObjFun), cx(1:end), 'LineWidth', 2);
cx= [gBat.Global.Bas_ObjFun];
plot(1:length(gBat.Global.Bas_ObjFun), cx(1:end), 'LineWidth', 2)
title('Global Best Error');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonates', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 30;