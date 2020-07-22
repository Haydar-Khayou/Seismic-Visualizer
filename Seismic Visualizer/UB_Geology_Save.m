function UB_Geology_Save(hObject, eventdata, handles)
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
N = num2str(Entity_Num);       % Convert Entity Number to String
c=['Entity' N];                % Create string variable named c, Contains Entity+its number

%%%%%  make sure that at least one reservoir entity has been saved
P=0;
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    it=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(it)), 'Geology')
        if strcmp(MODEL.(genvarname(it)).Geology.Type, 'RES')
            P=1;
            break;
        end
    end
end

if ~P
    msgbox('You have to save at least one Reservoir entity before saving underburden entities', 'Error', 'Error');
    return;
end
%%%%%

%% Save Entity Type
MODEL.(genvarname(c)).Geology.Type= 'UB';

%% Save Minerals Parameters
% Get Minerals Parmeters for Overburden(Carbonate Sceinario)
Chosen_Minerals= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals' 'Entity' Entity_Num]);
Minerals_List_Density= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_Density' 'Entity' Entity_Num]);  % in Kg/m3
Minerals_List_K_Modulus= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_K_Modulus' 'Entity' Entity_Num]);
Minerals_List_Mu_Modulus= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals_List_Mu_Modulus' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MineralsNames= Chosen_Minerals;
            MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MaRho= Minerals_List_Density;
            MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.K_Modulus= Minerals_List_K_Modulus;
            MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.Mu_Modulus= Minerals_List_Mu_Modulus;
        end
    end
end

% Get Minerals Parameters for Overburden(Clastics Sceinario)
Chosen_Minerals= getappdata(handles.Model_fig, ['UB_Clastics_Minerals' 'Entity' Entity_Num]);
Minerals_List_Density= getappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_Density' 'Entity' Entity_Num]);  % in Kg/m3
Minerals_List_K_Modulus= getappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_K_Modulus' 'Entity' Entity_Num]);
Minerals_List_Mu_Modulus= getappdata(handles.Model_fig, ['UB_Clastics_Minerals_List_Mu_Modulus' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MineralsNames= Chosen_Minerals;
            MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MaRho= Minerals_List_Density;
            MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.K_Modulus= Minerals_List_K_Modulus;
            MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.Mu_Modulus= Minerals_List_Mu_Modulus;
        end
    end
end

% Get Minerals Parameters for Overburden(Basalt Sceinario)
Chosen_Minerals= getappdata(handles.Model_fig, ['UB_Basalt_Minerals' 'Entity' Entity_Num]);
Minerals_List_Density= getappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_Density' 'Entity' Entity_Num]);  % in Kg/m3
Minerals_List_K_Modulus= getappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_K_Modulus' 'Entity' Entity_Num]);
Minerals_List_Mu_Modulus= getappdata(handles.Model_fig, ['UB_Basalt_Minerals_List_Mu_Modulus' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MineralsNames= Chosen_Minerals;
            MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MaRho= Minerals_List_Density;
            MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.K_Modulus= Minerals_List_K_Modulus;
            MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.Mu_Modulus= Minerals_List_Mu_Modulus;
        end
    end
end


%% Save Fluid Content Parameters
% Get Fluids Parmeters for Overburden(Carbonate Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['UB_Carbonate_Fluids' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames= Chosen_Fluids;
        end
    end
end


% Get Fluids Parameters for Overburden(Clastics Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['UB_Clastics_Fluids' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames= Chosen_Fluids;
        end
    end
end


% Get Fluids Parameters for Overburden(Basalt Sceinario)
Chosen_Fluids= getappdata(handles.Model_fig, ['UB_Basalt_Fluids' 'Entity' Entity_Num]);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Parameters to MODEL
            MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames= Chosen_Fluids;
        end
    end
end


% Save Fluids Properties
UB_Brine_Salinity= str2double(handles.UB_Brine_Salinity_Text.String);
UB_OilAPIGravity= str2double(handles.UB_OilAPIGravity_Text.String);
UB_GasAPIGravity= str2double(handles.UB_GasAPIGravity_Text.String);
UB_GOR= str2double(handles.UB_GOR_Text.String);
MinSW= str2double(handles.UB_MinSW_Text.String);
MaxSW= str2double(handles.UB_MaxSW_Text.String);

for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if isfield(MODEL.(genvarname(c)), 'Geology')
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Save Fluids Properties as Distributions
            MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.Brine_Salinity= UB_Brine_Salinity;
            MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.OilAPIGravity= UB_OilAPIGravity;
            MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GasAPIGravity= UB_GasAPIGravity;
            MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GOR= UB_GOR;
            MODEL.(genvarname(c)).Geology.FluidContent.MinSW= MinSW;
            MODEL.(genvarname(c)).Geology.FluidContent.MaxSW= MaxSW;
        end
    end
end

%% Save Porosity
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
N = num2str(Entity_Num);       % Convert Entity Number to String
c=['Entity' N];                % Create string variable named c, Contains Entity+its number


% Get Porosity Limits
Min_Porosity= str2double(handles.UB_Porosity_MinValue_Text.String);
Max_Porosity= str2double(handles.UB_Porosity_MaxValue_Text.String);
% Save Porosity Limits to MODEL
MODEL.(genvarname(c)).Geology.Porosity.Limits= [Min_Porosity Max_Porosity];

if handles.UB_Porosity_SingleValue.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 1;  % 1 refers to single Porosity Value
    
elseif handles.UB_Porosity_TwoValues.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 2; % 2 refers to Two Porosity Value

    Max_Range= str2double(handles.UBPor_Max_Range.String);
    MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range= Max_Range;     
    
elseif handles.UB_Porosity_ThreeValues.Value
    MODEL.(genvarname(c)).Geology.Porosity.Type= 3; % 3 refers to Three Porosity Value
    % Get Middle area Coordinates(Vertical Coordinates)
    UB_Left_PorPoint= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);
    UB_Right_PorPoint= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]);
    UB_Left_MidZone= getappdata(handles.Model_fig, ['UB_Left_MidZone' 'Entity' Entity_Num]); 
    UB_Right_MidZone= getappdata(handles.Model_fig, ['UB_Right_MidZone' 'Entity' Entity_Num]);
    % Save Parameters to MODEL
    MODEL.(genvarname(c)).Geology.Porosity.Left_PorPoint= UB_Left_PorPoint;
    MODEL.(genvarname(c)).Geology.Porosity.Right_PorPoint= UB_Right_PorPoint;
    MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone= UB_Left_MidZone;
    MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone= UB_Right_MidZone;
    
    Max_Range= str2double(handles.UBPor_Max_Range.String);
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
setappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num], '');  % empty Left Porosity Value
setappdata(handles.Model_fig, ['RES_Right_MidZone' 'Entity' Entity_Num], ''); % empty Right Porosity Value
setappdata(handles.Model_fig, ['RES_Left_MidZone' 'Entity' Entity_Num], '');  % empty Left Porosity Value
handles.RES_PorMidValue_FirstCol.String= '';
handles.RES_PorMidValue_LastCol.String= '';
Model_Plotter(handles)  % plot the Entity


msgbox({'Properities have been saved successfully','',...
    'Note:','- Minerals and Fluids properties will be saved to all Underburden Entities.'...
    ,'- Water saturation range will be saved to all Underburden Entities.'...
    ,'- Porosity is independent for each entity.'}, 'Success');
