function RES_Geology_Save(hObject, eventdata, handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Preparation
MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities'); % Get total number of entities
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
N= num2str(Entity_Num);       % Convert Entity Number to String
c= ['Entity' N];                % Create string variable named c, Contains Entity+its number

%% Save Entity Type
MODEL.(genvarname(c)).Geology.Type= 'RES';

if handles.Independent_RES_Entity.Value==0
    MODEL.(genvarname(c)).Geology.FluidContent.Independent= 0;
end

%% Save Mineralogy Parameters
% Get Minerals Parmeters for Reservoir
Chosen_Scenarios= getappdata(handles.Model_fig, 'RES_Scenario');
Scenario_List_Density= getappdata(handles.Model_fig, 'RES_Scenario_List_Density');  % in Kg/m3
Scenario_List_P_Velocity= getappdata(handles.Model_fig, 'RES_Scenario_List_K_Modulus');
Scenario_List_S_Velocity= getappdata(handles.Model_fig, 'RES_Scenario_List_Mu_Modulus');
% Save them in The MODEL structure
MODEL.(genvarname(c)).Geology.Mineralogy.MineralsNames= Chosen_Scenarios;
MODEL.(genvarname(c)).Geology.Mineralogy.MaRho= Scenario_List_Density;
MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus= Scenario_List_P_Velocity;
MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus= Scenario_List_S_Velocity;

%% Save Fluid Content Parameters

% Get Fluids Parameters for Reservoir(Carbonate Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['RES_Carbonate_Fluids' 'Entity' Entity_Num]);

%%% if the Entity is independent
if handles.Independent_RES_Entity.Value
    Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
    N = num2str(Entity_Num);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    
    MODEL.(genvarname(c)).Geology.FluidContent.Independent=  1;
    MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames= Chosen_Fluids;    
else
    %%% if it is part of the RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        
        if isfield(MODEL.(genvarname(c)), 'Geology')
            if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
                if isfield(MODEL.(genvarname(c)).Geology.FluidContent, 'Independent')
                    if MODEL.(genvarname(c)).Geology.FluidContent.Independent==0
                        % Save Parameters to MODEL
                        MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames= Chosen_Fluids;
                    end
                end
            end
        end
    end
end

% Get Fluids Parameters for Reservoir(Clastics Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['RES_Clastics_Fluids' 'Entity' Entity_Num]);

%%% if the Entity is independent
if handles.Independent_RES_Entity.Value
    Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
    N = num2str(Entity_Num);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    
    MODEL.(genvarname(c)).Geology.FluidContent.Independent=  1;
    MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames= Chosen_Fluids;    
else
    %%% if it is part of the RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        
        if isfield(MODEL.(genvarname(c)), 'Geology')
            if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
                if isfield(MODEL.(genvarname(c)).Geology.FluidContent, 'Independent')
                    if MODEL.(genvarname(c)).Geology.FluidContent.Independent==0
                        % Save Parameters to MODEL
                        MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames= Chosen_Fluids;
                    end
                end
            end
        end
    end
end



% Get Fluids Parameters for Reservoir(Basalt Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['RES_Basalt_Fluids' 'Entity' Entity_Num]);

%%% if the Entity is independent
if handles.Independent_RES_Entity.Value
    Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
    N = num2str(Entity_Num);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    
    MODEL.(genvarname(c)).Geology.FluidContent.Independent=  1;
    MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames= Chosen_Fluids;
else
    %%% if it is part of the RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        
        if isfield(MODEL.(genvarname(c)), 'Geology')
            if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
                if isfield(MODEL.(genvarname(c)).Geology.FluidContent, 'Independent')
                    if MODEL.(genvarname(c)).Geology.FluidContent.Independent==0
                        % Save Parameters to MODEL
                        MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames= Chosen_Fluids;
                    end
                end
            end
        end
    end
end



% Save Fluids Properties
RES_Brine_Salinity= str2double(handles.RES_Brine_Salinity_Text.String);
RES_OilAPIGravity= str2double(handles.RES_OilAPIGravity_Text.String);
RES_GasAPIGravity= str2double(handles.RES_GasAPIGravity_Text.String);
RES_GOR= str2double(handles.RES_GOR_Text.String);
MinSW= str2double(handles.RES_MinSW_Text.String);
MaxSW= str2double(handles.RES_MaxSW_Text.String);

%%% if the Entity is independent
if handles.Independent_RES_Entity.Value
    Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
    N = num2str(Entity_Num);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    % Save Fluids Properties as Distributions
    MODEL.(genvarname(c)).Geology.FluidContent.Independent= 1;
    MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.Brine_Salinity= RES_Brine_Salinity.*MODEL.(genvarname(c)).Matrix;
    MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.OilAPIGravity= RES_OilAPIGravity.*MODEL.(genvarname(c)).Matrix;
    MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GasAPIGravity= RES_GasAPIGravity.*MODEL.(genvarname(c)).Matrix;
    MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GOR= RES_GOR.*MODEL.(genvarname(c)).Matrix;
    MODEL.(genvarname(c)).Geology.FluidContent.MinSW= MinSW;
    MODEL.(genvarname(c)).Geology.FluidContent.MaxSW= MaxSW;
else
    %%% if it is part of the RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        
        if isfield(MODEL.(genvarname(c)), 'Geology')
            if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
                if isfield(MODEL.(genvarname(c)).Geology.FluidContent, 'Independent')
                    if MODEL.(genvarname(c)).Geology.FluidContent.Independent==0
                        % Save Fluids Properties as Distributions
                        MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.Brine_Salinity= RES_Brine_Salinity;
                        MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.OilAPIGravity= RES_OilAPIGravity;
                        MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GasAPIGravity= RES_GasAPIGravity;
                        MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GOR= RES_GOR;
                        MODEL.(genvarname(c)).Geology.FluidContent.MinSW= MinSW;
                        MODEL.(genvarname(c)).Geology.FluidContent.MaxSW= MaxSW;
                    end
                end
            end
        end
    end
end


%% Save Porosity
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
N = num2str(Entity_Num);       % Convert Entity Number to String
c=['Entity' N];                % Create string variable named c, Contains Entity+its number


% Get Porosity Limits
Min_Porosity= str2double(handles.RES_Porosity_MinValue_Text.String);
Max_Porosity= str2double(handles.RES_Porosity_MaxValue_Text.String);
% Save Porosity Limits to MODEL
MODEL.(genvarname(c)).Geology.Porosity.Limits= [Min_Porosity Max_Porosity];

if handles.RES_Porosity_SingleValue.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 1;  % 1 refers to single Porosity Value
    
elseif handles.RES_Porosity_TwoValues.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 2; % 2 refers to Two Porosity Value
    
    Max_Range= str2double(handles.ResPor_Max_Range.String);
    MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range= Max_Range;
    
elseif handles.RES_Porosity_ThreeValues.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 3; % 3 refers to Three Porosity Value
    % Get Middle area Coordinates(Vertical Coordinates)
    RES_Left_PorPoint= getappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num]);
    RES_Right_PorPoint= getappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num]);
    RES_Left_MidZone= getappdata(handles.Model_fig, ['RES_Left_MidZone' 'Entity' Entity_Num]); 
    RES_Right_MidZone= getappdata(handles.Model_fig, ['RES_Right_MidZone' 'Entity' Entity_Num]);
    % Save Parameters to MODEL
    MODEL.(genvarname(c)).Geology.Porosity.Left_PorPoint= RES_Left_PorPoint;
    MODEL.(genvarname(c)).Geology.Porosity.Right_PorPoint= RES_Right_PorPoint;
    MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone= RES_Left_MidZone;
    MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone= RES_Right_MidZone;
    
    Max_Range= str2double(handles.ResPor_Max_Range.String);
    MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range= Max_Range;    
end    


handles.Type_Text.Visible= 'On';
handles.Entity_Type_Show.String= MODEL.(genvarname(c)).Geology.Type;

setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL

Entity_Num= handles.Entity_Number_Text.String;
setappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num], '');  % empty Left Porosity Value
setappdata(handles.Model_fig, ['OB_Right_MidZone' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['OB_Left_MidZone' 'Entity' Entity_Num], '');  % empty Left Porosity Value
handles.OB_PorMidValue_FirstCol.String= '';
handles.OB_PorMidValue_LastCol.String= '';
setappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num], '');  % empty Left Porosity Value
setappdata(handles.Model_fig, ['UB_Right_MidZone' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['UB_Left_MidZone' 'Entity' Entity_Num], '');  % empty Left Porosity Value
handles.UB_PorMidValue_FirstCol.String= '';
handles.UB_PorMidValue_LastCol.String= '';
Model_Plotter(handles)  % plot the Entity


if handles.Independent_RES_Entity.Value
    msgbox({'Properities have been saved successfully.','',...
        'Note:','- This is an Independent Reservoir Entity.'...,=
        ,'- Mineralogy is the same for all Reservoir Entities.'...
        ,'- Fluids Content / Properties will be saved only to this Entity.'...
        ,'- Water saturation range will be saved only to this Entity.'...
        ,'- Porosity is independent for each entity.'}, 'Success');
else
    msgbox({'Properities have been saved successfully.','',...
        'Note:','- This is a Reservoir sub-Entity bleongs to the Super-Reservoir Entity.'...,
        '- Mineralogy is the same for all Reservoir Entities.',...
        '- Fluids Content / properties will be saved to all Reservoir Entities.'...
        ,'- Water saturation range will be saved to all Reservoir Entities'...
        ,'- Porosity is independent for each entity.'}, 'Success');
end
