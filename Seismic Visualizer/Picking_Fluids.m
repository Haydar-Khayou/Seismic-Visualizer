function Picking_Fluids(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%
Fluids = handles.Fluids_Library.RowName;     % Save the Rows(Fluids)
Properties = handles.Fluids_Library.ColumnName; % Save the Columns(Properties)
Data= handles.Fluids_Library.Data;        % Save The Table Data
Picked= Data(:,1);     % The Fluids that have been chosen by the user
Picked= cell2mat(Picked);  % convert it to List
Picked= logical(Picked);   % Convert it to logical
Chosen_Fluids= handles.Fluids_Library.RowName(Picked);   % The List of Chosen Fluids

%% Save Data && attach it to the figure

Entity_Num= handles.Entity_Number_Text.String;
format bank

% if Overburden
if handles.OB_Carbonate_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['OB_Carbonate_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.OB_Carbonate_ShowFluidsList.Visible='On';
    else
        handles.OB_Carbonate_ShowFluidsList.Visible='Off';
    end
    
elseif handles.OB_Clastic_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['OB_Clastics_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.OB_Clastic_ShowFluidsList.Visible='On';
    else
        handles.OB_Clastic_ShowFluidsList.Visible='Off';
    end
    
elseif handles.OB_Basalt_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['OB_Basalt_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.OB_Basalt_ShowFluidsList.Visible='On';
    else
        handles.OB_Basalt_ShowFluidsList.Visible='Off';
    end
    
    % if Reservoir
elseif handles.RES_Carbonate_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['RES_Carbonate_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.RES_Carbonate_ShowFluidsList.Visible='On';
    else
        handles.RES_Carbonate_ShowFluidsList.Visible='Off';
    end
    
elseif handles.RES_Clastic_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['RES_Clastics_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.RES_Clastic_ShowFluidsList.Visible='On';
    else
        handles.RES_Clastic_ShowFluidsList.Visible='Off';
    end
    
elseif handles.RES_Basalt_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['RES_Basalt_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.RES_Basalt_ShowFluidsList.Visible='On';
    else
        handles.RES_Basalt_ShowFluidsList.Visible='Off';
    end
    
    % if Underburden
elseif handles.UB_Carbonate_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['UB_Carbonate_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.UB_Carbonate_ShowFluidsList.Visible='On';
    else
        handles.UB_Carbonate_ShowFluidsList.Visible='Off';
    end
    
elseif handles.UB_Clastic_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['UB_Clastics_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.UB_Clastic_ShowFluidsList.Visible='On';
    else
        handles.UB_Clastic_ShowFluidsList.Visible='Off';
    end
    
elseif handles.UB_Basalt_OpenFluidsButton.Value
    setappdata(handles.Model_fig, ['UB_Basalt_Fluids' 'Entity' Entity_Num], Chosen_Fluids);
    if ~isempty(Chosen_Fluids)
        handles.UB_Basalt_ShowFluidsList.Visible='On';
    else
        handles.UB_Basalt_ShowFluidsList.Visible='Off';
    end
end