function Picking_Underburden_Lithology(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%
Minerals = handles.Mineralogy_Library.RowName;     % Save the Rows(Minerals)
Properties = handles.Mineralogy_Library.ColumnName; % Save the Columns(Properties)
Data= handles.Mineralogy_Library.Data;        % Save The Table Data
Picked= Data(:,1);     % The minerals that have been chosen by the user
Picked= cell2mat(Picked);  % convert it to matrix
Picked= logical(Picked);   % Convert it to logical
Chosen_Minerals= handles.Mineralogy_Library.RowName(Picked);   % The List of Chosen Minerals

Minerals_List_Density= [ ];    % Create Empty Density List
Minerals_List_K_Modulus= [ ]; % Create Empty K_Modulus List
Minerals_List_Mu_Modulus= [ ]; % Create Empty Mu_Modulus List
Picked= double(Picked);  % Convert Picked Variable to Double

% Determine the Picked Minerals and their min/max Properties
for iter=1:length(Picked)
    if Picked(iter)==1
        format bank
        minDensity= cell2mat(Data(iter, 2));
        maxDensity= cell2mat(Data(iter, 3));
        minK_Modulus= cell2mat(Data(iter, 4));
        maxK_Modulus= cell2mat(Data(iter, 5));
        minMu_Modulus= cell2mat(Data(iter, 6));
        maxMu_Modulus= cell2mat(Data(iter, 7));
        
        % Check if There is empty or Nan Value
        if isempty(minDensity) || isempty(maxDensity) || isempty(minK_Modulus) || isempty(maxK_Modulus) || isempty(minMu_Modulus) || isempty(maxMu_Modulus) ||...
                isnan(minDensity) || isnan(maxDensity) || isnan(minK_Modulus) || isnan(maxK_Modulus) || isnan(minMu_Modulus) || isnan(maxMu_Modulus)
            msgbox({'Check Values!';'Cells can''t be Empty Or Nan'}, 'Error', 'Error');
            handles.Mineralogy_Library_Panel.Visible='On';
            return;
        end
        
        % Check if Values are positive
        if ~prod(cell2mat(Data(iter, 2:7))>=0)
            msgbox('Values must be Positive!', 'Error', 'Error');
            handles.Mineralogy_Library_Panel.Visible='On';
            return;
        end
        
        % Check if Values have been picked properly
        if (minDensity > maxDensity) || (minK_Modulus > maxK_Modulus) || (minMu_Modulus > maxMu_Modulus)
            msgbox('Max Values must be larger than Min Values!', 'Error', 'Error');
            handles.Mineralogy_Library_Panel.Visible='On';
            return;
        end
        
        % if everything is Ok then Save min/max Densities in Md Variable
        Md=[minDensity maxDensity];
        Minerals_List_Density= [Minerals_List_Density;Md];     % add md to the previous Md as a new Row
        
        % Save min/max K_Modulus in K Variable
        K=[minK_Modulus maxK_Modulus];
        Minerals_List_K_Modulus= [Minerals_List_K_Modulus;K];     % add K to the previous K as a new Row
        
        % Save min/max Mu_Modulus in Mu Variable
        Mu=[minMu_Modulus maxMu_Modulus];
        Minerals_List_Mu_Modulus= [Minerals_List_Mu_Modulus;Mu];     % add Mu to the previous Mu as a new Row
    end
end
%% Save Data && attach it to the figure

Entity_Num= handles.Entity_Number_Text.String;
format bank
if handles.UB_Carbonate_OpenMineralogyButton.Value
    setappdata(handles.Model_fig, ['UB_Carbonate_Minerals' 'Entity' Entity_Num], Chosen_Minerals);
    
    setappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_Density' 'Entity' Entity_Num], Minerals_List_Density);
    setappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_K_Modulus' 'Entity' Entity_Num], Minerals_List_K_Modulus);
    setappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_Mu_Modulus' 'Entity' Entity_Num], Minerals_List_Mu_Modulus);
    
    if ~isempty(Minerals_List_Density)
        handles.UB_Carbonate_ShowMineralogyList.Visible='On';
    else
        handles.UB_Carbonate_ShowMineralogyList.Visible='Off';
    end
elseif handles.UB_Clastic_OpenMineralogyButton.Value
    setappdata(handles.Model_fig, ['UB_Clastics_Minerals' 'Entity' Entity_Num], Chosen_Minerals);
    
    setappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_Density' 'Entity' Entity_Num], Minerals_List_Density);
    setappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_K_Modulus' 'Entity' Entity_Num], Minerals_List_K_Modulus);
    setappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_Mu_Modulus' 'Entity' Entity_Num], Minerals_List_Mu_Modulus);
    if ~isempty(Minerals_List_Density)
        handles.UB_Clastic_ShowMineralogyList.Visible='On';
    else
        handles.UB_Clastic_ShowMineralogyList.Visible='Off';
    end
elseif handles.UB_Basalt_OpenMineralogyButton.Value
    setappdata(handles.Model_fig, ['UB_Basalt_Minerals' 'Entity' Entity_Num], Chosen_Minerals);
    
    setappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_Density' 'Entity' Entity_Num], Minerals_List_Density);
    setappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_K_Modulus' 'Entity' Entity_Num], Minerals_List_K_Modulus);
    setappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_Mu_Modulus' 'Entity' Entity_Num], Minerals_List_Mu_Modulus);
    if ~isempty(Minerals_List_Density)
        handles.UB_Basalt_ShowMineralogyList.Visible='On';
    else
        handles.UB_Basalt_ShowMineralogyList.Visible='Off';
    end
end