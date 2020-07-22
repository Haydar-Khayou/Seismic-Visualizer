function Model_Plotter_FirstTime(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%
global Data Coor Coor_Trim Sec_Size
load('Coordinates.mat', 'Coor', 'Coor_Trim', 'Sec_Size');  % Load Data
load('Axes.mat');   % Load Data of the Seismic Section
% delete('Coordinates.mat');
% delete('Axes.mat');
Horizons_grid= true(Sec_Size);  % Make ones matrix with the Section size
Horizons_grid= double(Horizons_grid);  % change class into double
for iter=1:size(Coor_Trim, 1)     % in our ones matrix, Detect the Horizons picked and assign them with value 0
    Horizons_grid(Coor_Trim(iter, 2), Coor_Trim(iter, 1))= 0;
end

Split_Horizons_Set= bwconncomp(Horizons_grid, 6);   % Seperate te matrix into matrices based on Horizons

for Num_Entity=1:Split_Horizons_Set.NumObjects
    Temp_Mat= false(size(Horizons_grid));         % first: create zeros matrix with same size
    Temp_Mat(Split_Horizons_Set.PixelIdxList{Num_Entity})= 1; % make the values of the matrix(Num_Entity Coordinates)=1
    Temp_Mat= Temp_Mat.';       % transpose the matrix
    Temp_Mat= [Temp_Mat , false((size(Temp_Mat,1)),1)]; % add Coloumn to the end of the matrix
    Temp_Mat= Temp_Mat.';       % transpose the matrix so it turn back to its initial state
    c=find(Temp_Mat==1);         % give me the coordinates of cells=1
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
    % because the streatching process occurs in the vertical dimension not
    % laterally, so in these cases we have to streatch the layer to rigt or
    % left
    % in the next 2 loops I am telling the tool to give the value 1 to each
    % cell that is = 0, if the previous cell(previous row) has the value 0 from
    % the original matrix, this is how I detect the Cross Cell in the matrix
    
    
    for m = 2:size(Entities{Num_Entity},1)-1
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


%% Model Structure Generation

%   Create Model Structure Variable to Store Entities features
for Num_Entity=1:Split_Horizons_Set.NumObjects
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Creat string variable named c, Contains Entity+its number
    MODEL.(genvarname(c)).Matrix= Entities{Num_Entity};  % store The Entity matrix Variable, genvarname(c): means to generate variable name.
    
    
    [m, n]= find(Entities{Num_Entity}==1);         % give the coordinates(Rows, Columns) of cells =1
    First_Row = min(m);    % First Row contains cell = 1
    Last_Row = max(m);     % Last Row contains cell = 1
    First_Column = min(n); % First Column contains cell = 1
    Last_Column = max(n);  % Last Column contains cell = 1
    
    MODEL.(genvarname(c)).First_Row= First_Row;
    MODEL.(genvarname(c)).Last_Row= Last_Row;
    MODEL.(genvarname(c)).First_Column= First_Column;
    MODEL.(genvarname(c)).Last_Column= Last_Column;
    
    % evantually we have a structure variable named Model Contains The
    % whole information to be used in the Modelling process
end

%% Attach MODEl to figure
setappdata(handles.Model_fig, 'MODEL', MODEL);
% attach the number of entities in the figure
setappdata(handles.Model_fig, 'NumberofEntities' , Split_Horizons_Set.NumObjects);
setappdata(handles.Model_fig, 'Horizons_grid', Horizons_grid);
handles.Sampling_Interval.String= Data.step;
handles.Sampling_Time.String= Data.step;
Wavelet_Plotter(handles)

Model_Plotter(handles)