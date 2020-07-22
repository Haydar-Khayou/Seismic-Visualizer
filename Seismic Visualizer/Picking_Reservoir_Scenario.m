function Picking_Reservoir_Scenario(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%
Minerals = handles.RES_Scenario_Library.RowName;     % Save the Rows(Scenarios)
Properties = handles.RES_Scenario_Library.ColumnName; % Save the Columns(Properties)
Data= handles.RES_Scenario_Library.Data;        % Save The Table Data
Picked= Data(:,1);     % The minerals that have been chosen by the user
Picked= cell2mat(Picked);  % convert it to matrix
Picked= logical(Picked);   % Convert it to logical
Chosen_Scenarios= handles.RES_Scenario_Library.RowName(Picked);   % The List of Chosen Minerals

Scenario_List_Density= [ ];    % Create Empty Density List
Scenario_List_K_Modulus= [ ]; % Create Empty Pvelocity List
Scenario_List_Mu_Modulus= [ ]; % Create Empty Svelocity List
Picked= double(Picked);  % Convert Picked Variable to Double

% Determine the Picked Minerals and their min/max Densities
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
            handles.RES_Scenario_Library_Panel.Visible='On';
            return;
        end
        
        % Check if Values are positive
        if ~prod(cell2mat(Data(iter, 2:7))>=0)
            msgbox('Values must be Positive!', 'Error', 'Error');
            handles.RES_Scenario_Library_Panel.Visible='On';
            return;
        end
        
        % Check if Values have been picked properly
        if (minDensity > maxDensity) || (minK_Modulus > maxK_Modulus) || (minMu_Modulus > maxMu_Modulus)
            msgbox('Max Values must be larger than Min Values!', 'Error', 'Error');
            handles.RES_Scenario_Library_Panel.Visible='On';
            return;
        end
        
        % if everything is Ok then Save min/max Densities in Md Variable
        Md=[minDensity maxDensity];
        Scenario_List_Density= [Scenario_List_Density;Md];     % add md to the previous Md as a new Row
        
        % Save min/max K_Modulus in K Variable
        K=[minK_Modulus maxK_Modulus];
        Scenario_List_K_Modulus= [Scenario_List_K_Modulus;K];     % add K to the previous K as a new Row
        
        % Save min/max Mu_Modulus in Mu Variable
        Mu=[minMu_Modulus maxMu_Modulus];
        Scenario_List_Mu_Modulus= [Scenario_List_Mu_Modulus;Mu];     % add Mu to the previous Mu as a new Row
    end
end
%% Save Data && attach it to the figure

format bank

setappdata(handles.Model_fig, 'RES_Scenario', Chosen_Scenarios);

setappdata(handles.Model_fig, 'RES_Scenario_List_Density', Scenario_List_Density);
setappdata(handles.Model_fig, 'RES_Scenario_List_K_Modulus', Scenario_List_K_Modulus);
setappdata(handles.Model_fig, 'RES_Scenario_List_Mu_Modulus', Scenario_List_Mu_Modulus);
% Show chosen scenarios on figure
handles.RES_FirstScenario_Text.String= '';
handles.RES_SecondScenario_Text.String= '';
handles.RES_ThirdScenario_Text.String= '';

if ~isempty(Chosen_Scenarios)
    handles.Res_ScenariosListPanel.Visible='On';
    handles.RES_FirstScenario_Text.String= Chosen_Scenarios(1);
    if length(Chosen_Scenarios)==2
        handles.RES_SecondScenario_Text.String= Chosen_Scenarios(2);
    end
    if length(Chosen_Scenarios)==3
        handles.RES_SecondScenario_Text.String= Chosen_Scenarios(2);
        handles.RES_ThirdScenario_Text.String= Chosen_Scenarios(3);
    end
elseif isempty(Chosen_Scenarios)
    handles.Res_ScenariosListPanel.Visible='Off';
end    
    % Show chosen scenarios on General figure
handles.General_RES_FirstScenario_Text.String= '';
handles.General_RES_SecondScenario_Text.String= '';
handles.General_RES_ThirdScenario_Text.String= '';

if ~isempty(Chosen_Scenarios)
    handles.General_Res_ScenariosListPanel.Visible='On';
    handles.General_RES_FirstScenario_Text.String= Chosen_Scenarios(1);
    if length(Chosen_Scenarios)==2
        handles.General_RES_SecondScenario_Text.String= Chosen_Scenarios(2);
    end
    if length(Chosen_Scenarios)==3
        handles.General_RES_SecondScenario_Text.String= Chosen_Scenarios(2);
        handles.General_RES_ThirdScenario_Text.String= Chosen_Scenarios(3);
    end
elseif isempty(Chosen_Scenarios)
    handles.General_Res_ScenariosListPanel.Visible='Off';
end