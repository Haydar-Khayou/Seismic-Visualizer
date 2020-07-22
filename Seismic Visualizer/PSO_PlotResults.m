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
%% carbonates
AOI_Synthetic= gparticle.Global.Car(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Carbonates Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Car(end).final_cost,3) ' %']});
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
figure;imagesc(Xaxis, Yaxis, Car_Dev);
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
Total_Synthetic= gparticle.Global.Car(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Carbonates Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Car(end).final_cost,3) ' %']});colormap(Red_blue_map);
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
AOI_Synthetic= gparticle.Global.Clas(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Clastics Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Clas(end).final_cost,3) ' %']});
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
figure;imagesc(Xaxis, Yaxis, Clas_Dev);
title('Clastic Synthetic Normalized Error');
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
Total_Synthetic= gparticle.Global.Clas(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Clastics Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Clas(end).final_cost,3) ' %']});colormap(Red_blue_map);
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

%% Bas
AOI_Synthetic= gparticle.Global.Bas(end).Synthetic .* Data.Horizons_grid_remove;
mi= abs(min(min(AOI_Synthetic)));
ma= abs(max(max(AOI_Synthetic)));
RR= min(mi, ma);

figure;imagesc(Xaxis, Yaxis, AOI_Synthetic, [-RR RR]);
title({'Basalt Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Bas(end).final_cost,3) ' %']});
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
figure;imagesc(Xaxis, Yaxis, Bas_Dev);
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
Total_Synthetic= gparticle.Global.Bas(end).Synthetic + rest_Seis;


mi= abs(min(min(Total_Synthetic)));
ma= abs(max(max(Total_Synthetic)));
RR= min(mi, ma);
figure;imagesc(Xaxis, Yaxis, Total_Synthetic, [-RR RR]);
title({'Basalt Synthetic Section', ['NRMSE= ' num2str(gparticle.Global.Bas(end).final_cost,3) ' %']});colormap(Red_blue_map);
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
figure; imagesc(Xaxis, Yaxis, gparticle.Global.Car(end).Bulk_Density_Model);
title({'Bulk Density model for Carbonates'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
colorbar
cc=colorbar;
cc.Label.String='Bulk Density g/cc';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Clas(end).Bulk_Density_Model);
title({'Bulk Density model for Clastics'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Bulk Density g/cc';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Bas(end).Bulk_Density_Model);
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
figure; imagesc(Xaxis, Yaxis, gparticle.Global.Car(end).Velocity_Model);
title({'Velocity Model for Carbonates'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
colorbar
cc=colorbar;
cc.Label.String='Velocity  Km/s';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Clas(end).Velocity_Model);
title({'Velocity Model for Clastics'});
xlabel('Trace Number');
ylabel('Time(ms)');
colormap(jet(1000))
cc=colorbar;
cc.Label.String='Velocity  Km/s';
ddd= gca;
ddd.FontSize= 28;

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Bas(end).Velocity_Model);
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
figure; imagesc(Xaxis, Yaxis, gparticle.Global.Car(end).pos.POR.FullMatrix, [0 1]);
itt= num2str(gparticle.Global.Car(end).iteration);
err= gparticle.Global.Car(end).final_cost;
porEq= gparticle.Global.Car(end).VpEq;
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

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Clas(end).pos.POR.FullMatrix,[0 1]);
itt= num2str(gparticle.Global.Clas(end).iteration);
err= gparticle.Global.Clas(end).final_cost;
porEq= gparticle.Global.Clas(end).VpEq;
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

figure; imagesc(Xaxis, Yaxis, gparticle.Global.Bas(end).pos.POR.FullMatrix, [0 1]);
itt= num2str(gparticle.Global.Bas(end).iteration);
err= gparticle.Global.Bas(end).final_cost;
porEq= gparticle.Global.Bas(end).VpEq;
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

%% Average particles Cost

figure;plot(1:length(gparticle.Global.Car_avr_particles),gparticle.Global.Car_avr_particles, 'LineWidth', 2)
hold on 
plot(1:length(gparticle.Global.Clas_avr_particles),gparticle.Global.Clas_avr_particles, 'LineWidth', 2);
plot(1:length(gparticle.Global.Bas_avr_particles),gparticle.Global.Bas_avr_particles, 'LineWidth', 2);
title('Average Error for particles');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonates', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 30;

%% Average bparticles Cost

figure;plot(1:length(gparticle.Global.Car_avr_bparticles), gparticle.Global.Car_avr_bparticles, 'LineWidth', 2)
hold on 
plot(1:length(gparticle.Global.Clas_avr_bparticles), gparticle.Global.Clas_avr_bparticles, 'LineWidth', 2);
plot(1:length(gparticle.Global.Bas_avr_bparticles), gparticle.Global.Bas_avr_bparticles, 'LineWidth', 2);
title('Average Error for bparticles');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonates', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 30;

%% plot global best for scenarios
cx= [gparticle.Global.Car_ObjFun];
figure; plot(1:length(gparticle.Global.Car_ObjFun), cx(1:end), 'LineWidth', 2)
hold on
cx= [gparticle.Global.Clas_ObjFun];
plot(1:length(gparticle.Global.Clas_ObjFun), cx(1:end), 'LineWidth', 2);
cx= [gparticle.Global.Bas_ObjFun];
plot(1:length(gparticle.Global.Bas_ObjFun), cx(1:end), 'LineWidth', 2)
title('Global Best Error');
xlabel('Iteration');
ylabel('NRMSE %');
legend('Carbonate', 'Clastics', 'Basalt');
grid
ddd= gca;
ddd.FontSize= 30;