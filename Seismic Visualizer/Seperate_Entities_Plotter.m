function Seperate_Entities_Plotter
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of Science
%           Author: Haydar Khayou

%% Get Data
global Coor_Trim_clean Sec_Size          % Load Data
Horizons_grid= true(Sec_Size);           % Make ones matrix with the Section size
load('Entities_Temp.mat');

%% Plotting
for Num_Entity=1:Split_Horizons_Set.NumObjects
    Horizons_grid_cleand= Horizons_grid;
    for iter=1:size(Coor_Trim_clean, 1)     % in our ones matrix, Detect the Horizons picked and assign them with value 0
        Horizons_grid_cleand(Coor_Trim_clean(iter, 2), Coor_Trim_clean(iter, 1))= 2;
    end
    subplot(1, Split_Horizons_Set.NumObjects+2, 1);imagesc(Horizons_grid_cleand);
    axis image
    hax= gca;
    set(hax.XAxis, 'Visible', 'off');
    set(hax.YAxis, 'Visible', 'off');
    subplot(1, Split_Horizons_Set.NumObjects+2, Num_Entity+1);imagesc(Entities{Num_Entity});
    axis image
    hax=gca;
    title(hax, Num_Entity);
    set(hax.XAxis, 'Visible', 'off');
    set(hax.YAxis, 'Visible', 'off');
end

cum_Mu= Entities{1};
for Num_Entity=2:Split_Horizons_Set.NumObjects
    cum_Mu= cum_Mu+Entities{Num_Entity};
    full_Final_Entities= cum_Mu;   % Here we have the Matrix after addition all Sub matrices
end
subplot(1, Split_Horizons_Set.NumObjects+2, Num_Entity+2);imagesc(full_Final_Entities);
axis image
hax= gca;
set(hax.XAxis, 'Visible', 'off');
set(hax.YAxis, 'Visible', 'off');

delete('Entities_Temp.mat')
