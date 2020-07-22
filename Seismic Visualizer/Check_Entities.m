function Check_Entities(handles)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of Science
%           Author: Haydar Khayou

%% Get Data
global Coor Coor_Trim Coor_Trim_clean Sec_Size      % Load Data

%% Do some magic
Horizons_grid= true(Sec_Size);         % Make ones matrix with the Section size
Horizons_grid= double(Horizons_grid);  % change class into double
for iter=1:size(Coor_Trim, 1)           % in our ones matrix, Detect the Horizons picked and assign them with value 0
    Horizons_grid(Coor_Trim(iter, 2), Coor_Trim(iter, 1))= 0;
end

Split_Horizons_Set= bwconncomp(Horizons_grid, 6);   % Seperate the matrix into matrices based on Horizons

for Num_Entity=1:Split_Horizons_Set.NumObjects
    Temp_Mat= false(size(Horizons_grid));         % first: create zeros matrix with same size
    Temp_Mat(Split_Horizons_Set.PixelIdxList{Num_Entity})= 1; % make the values of the matrix(Num_Entity Coordinates)=1
    Temp_Mat= Temp_Mat.';       % transpose the matrix
    Temp_Mat= [Temp_Mat, false((size(Temp_Mat, 1)), 1)]; % add Coloumn to the end of the matrix
    Temp_Mat= Temp_Mat.';       % transpose the matrix so it turn back to its original state
    c= find(Temp_Mat==1);         % give me the coordinates of cells=1
    Final_Entities_Matrix= Temp_Mat;    % Create matrix Final_Entities_Matrix=Temp_Mat
    Final_Entities_Matrix(c+1)= 1;      % streatch down the cells=1, because each layer = layer picked from above + Horizon coordinates
    
    
    Entities{Num_Entity}= Final_Entities_Matrix;  % we have new edited matrix
    
    [m, n]= find(Entities{Num_Entity}==1);         % give the coordinates(Rows, Columns) of cells =1
    
    First_Row= min(m);    % First Row contains cell = 1
    Last_Row= max(m);     % Last Row contains cell = 1
    First_Column= min(n); % First Column contains cell = 1
    Last_Column= max(n);  % Last Column contains cell = 1
    
    
    % in seperating layers,we may have a problem that the cell in the cross of
    % two adjacent layers will be empty or cell=0 instead of cell=1, thats
    % because the stretching process occurs in the vertical dimension not
    % laterally, so in this case we have to stretch the layer to right or
    % left
    % in the next 2 loops I am telling the tool to give the value 1 to each
    % cell that is = 0, if the previous cell(previous row) has the value 0 from
    % the original matrix, this is how I detect the Cross Cell in the matrix
    
    
    for m = 2:size(Entities{Num_Entity}, 1)-1
        for n = 1:size(Entities{Num_Entity},2)-1
            if Entities{Num_Entity}(m, n) == 1 && Entities{Num_Entity}(m+1, n+1) == 0 && Horizons_grid(m, n+1) == 0  && Horizons_grid(m-1,n+1)==0 && n==Last_Column
                Entities{Num_Entity}(m, n+1)=1;
            end
        end
    end
    
    
    for m = 2:size(Entities{Num_Entity},1)-1
        for n = 2:size(Entities{Num_Entity},2)-1
            if Entities{Num_Entity}(m, n) == 1 && Entities{Num_Entity}(m+1, n-1) == 0 && Horizons_grid(m, n-1) == 0  && Horizons_grid(m-1,n-1)==0 && n==First_Column
                Entities{Num_Entity}(m, n-1)=1;
            end
        end
    end
    
    
    %%%%
    %% here to fix the Cells in the first/last rows
    %  it is similar to the previous procedure but here the case is the first
    %  row contains cell=1 is the first row of the matrix and the same thing
    %  for the last row
    for n = 1:size(Entities{Num_Entity},2)
        if Entities{Num_Entity}(1, n) == 0 && Entities{Num_Entity}(2, n) == 1
            Entities{Num_Entity}(1, n)=1;
        end
    end
    
    
    for n = 1:size(Entities{Num_Entity},2)
        if Entities{Num_Entity}(end, n) == 0 && Entities{Num_Entity}(end-1, n) == 1
            Entities{Num_Entity}(end, n)=1;
        end
    end
    %%%%%%%
end

%% Filling gapes (this case when the user picks Two or more Vertical Sequential cells)

% Make a matrix Containing all the Entites in order to see where we have
% gapes that not filled after the previous procedures
if Split_Horizons_Set.NumObjects<=1
    msgbox({'There is only one Entity. In order to model there must be at least two Entities!';'Check the gapes!'},'Warning')
    return
end
cum_Mu = Entities{1};
for Num_Entity=2:Split_Horizons_Set.NumObjects
    cum_Mu = cum_Mu+Entities{Num_Entity};
    full_Final_Entities = cum_Mu;   % Here we have the Matrix after addition all Sub matrices
end

% Fill the Gapes in the Sub Matrices
for Num_Entity=1:Split_Horizons_Set.NumObjects
    for m = 2:size(Entities{Num_Entity},1)-1
        for n = 1:size(Entities{Num_Entity},2)-1
            if Entities{Num_Entity}(m, n)==1 && Entities{Num_Entity}(m, n+1)==0 && full_Final_Entities(m, n+1)==0
                Entities{Num_Entity}(m, n+1)=1;
                full_Final_Entities(m, n+1)=1;
            end
        end
    end
end

if handles.Check_Entities.Value
    save('Entities_Temp.mat', 'Split_Horizons_Set', 'Entities');
    Ent_Fig    
elseif handles.Model.Value
    global Data_Trim
    % create coordinates matrix of only the AOI(area of interset)
    Horizons_grid_remove= true(Sec_Size);  % Make ones matrix with the Section size
    for iter=1:size(Coor_Trim_clean, 1)     % in our ones matrix, Detect the Horizons picked and assign them with value 0
        Horizons_grid_remove(Coor_Trim_clean(iter, 2), Coor_Trim_clean(iter, 1))= 0;
    end
    
    % The full Data
    Data= Data_Trim;
    
    % The section of AOI
    Cleaned_Section= Data.ExportSection .* Horizons_grid_remove;
    
    Data.Cleaned_Section= Cleaned_Section;
    Data.Horizons_grid_remove= Horizons_grid_remove;
    
    % Max amplitude
    mi= abs(min(min(Cleaned_Section)));
    ma= abs(max(max(Cleaned_Section)));
    
    SeisAmp_Max= max(mi, ma);
    Data.SeisAmp_Max= SeisAmp_Max;
    Yaxis= Data.Y_axis;       % the vertical axis(time)
    extra_Value= Yaxis(end)+Data.step;   % in Entities the Y-axis is larger than section Y-axis by sampleInterval
    % because (Layers= number of RC's + 1) so we have to add value to
    % Y-axis of the entities plot
    Yaxis_Extra= [Yaxis extra_Value];
    Data.Yaxis_Extra= Yaxis_Extra;
    save('Axes.mat', 'Data');
    save('Coordinates.mat', 'Coor', 'Coor_Trim', 'Sec_Size');  % Load Data
    Model
end


