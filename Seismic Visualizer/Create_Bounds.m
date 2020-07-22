function Create_Bounds(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Note:
% The aim of this Function is to only rearrange the variables in "MODEL" structure
% and add some new variables so that they are clearer for the Optimization
% process


%% Variables
% 1- RES matrix Min density= MaRho(1);
% 1- RES matrix Max density= MaRho(2);
% 2- RES matrix Min p-wave velocity= K_Modulus(1);
% 2- RES matrix Max p-wave velocity= K_Modulus(2);
% 3- RES matrix Min s-wave velocity= Mu_Modulus(1);
% 3- RES matrix Max s-wave velocity= Mu_Modulus(2);
% 4- RES Fluid type= FluidsNames;
% 5- RES SW Min= MinSW;
% 5- RES SW Max= MinSW;
% 6- OB matrix Min density= MaRho(1);
% 6- OB matrix Max density= MaRho(2);
% 7- OB matrix Min p-wave velocity= K_Modulus(1);
% 7- OB matrix Max p-wave velocity= K_Modulus(2);
% 8- OB matrix Min s-wave velocity= Mu_Modulus(1);
% 8- OB matrix Max s-wave velocity= Mu_Modulus(2);
% 9- OB Fluid type= FluidsNames;
% 10- OB SW Min= MinSW;
% 10- OB SW Max= MinSW;
% 11- UB matrix Min density= MaRho(1);
% 11- UB matrix Max density= MaRho(2);
% 12- UB matrix Min p-wave velocity= K_Modulus(1);
% 12- UB matrix Max p-wave velocity= K_Modulus(2);
% 13- UB matrix Min s-wave velocity= Mu_Modulus(1);
% 13- UB matrix Max s-wave velocity= Mu_Modulus(2);
% 14- UB Fluid type= FluidsNames;
% 15- UB SW Min= MinSW;
% 15- UB SW Max= MinSW;
% 16- Frequency of wavelet MIN
% 16- Frequency of wavelet Max
% 17- Porosity for each entity, dependes on the number of entities and the
% type of porosity that the user have chosen

%% Initialization of Bounds
MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities');

% determine how many scenarios we have
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
        Scenarios_Names= MODEL.(genvarname(c)).Geology.Mineralogy.MineralsNames;
        NumOfScenarios= length(Scenarios_Names); % Number of scenarios
        break;
    end
end

%%% Check Carbonate Scenario number
Name= strcmp(Scenarios_Names(:, 1), 'Carbonate');
Carbonate_Scenario_Num= find(Name==1);   % row Number of carbonate scenario

%%% Check Clastics Scenario number
Name= strcmp(Scenarios_Names(:, 1), 'Clastics');
Clastics_Scenario_Num= find(Name==1);    % row Number of Clastics scenario

%%% Check Basalt Scenario number
Name= strcmp(Scenarios_Names(:, 1), 'Basalt');
Basalt_Scenario_Num= find(Name==1);      % row Number of Basalt scenario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Determiniation of Scenarios Bounds
ModelBounds= '';

ModelBounds.Carbonate_Scenario_Num= Carbonate_Scenario_Num;
ModelBounds.Clastics_Scenario_Num= Clastics_Scenario_Num;
ModelBounds.Basalt_Scenario_Num= Basalt_Scenario_Num;


%%%%%%% Wavelet Frequency Bounds %%%%%%%%%
MinFreq= MODEL.SeismicProperties.MinFrequency;
MaxFreq= MODEL.SeismicProperties.MaxFrequency;
ModelBounds.Frequency= [MinFreq; MaxFreq];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Preparation of Carbonate Scenario boundaries %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(Carbonate_Scenario_Num)      % if there is Carbonate Scenario then do the following
    ModelBounds.Carbonate_Scenario= '';
    
    %%%%% RESERVOIR %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            %%% We just want Number of first RES Entity so we break once we get it
            break;
        end
    end
    % Mineralogy
    RES_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Carbonate_Scenario_Num, 1);
    RES_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Carbonate_Scenario_Num, 2);
    RES_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Carbonate_Scenario_Num, 1);
    RES_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Carbonate_Scenario_Num, 2);
    RES_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Carbonate_Scenario_Num, 1);
    RES_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Carbonate_Scenario_Num, 2);
    
    ModelBounds.Carbonate_Scenario.Matrix.RES= [RES_min_MaRho RES_min_K_Modulus RES_min_Mu_Modulus; RES_max_MaRho RES_max_K_Modulus RES_max_Mu_Modulus];
    
    % Fluids for Super RES Entity
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
                ModelBounds.Carbonate_Scenario.Fluid.Super_RES= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
                break;   % Break after saving the Fluids of Super Entity
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Fluids for Independent RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
                ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(c))= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% OVERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                OB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MaRho(Mineral, 1);
                OB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MaRho(Mineral, 2);
                OB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.K_Modulus(Mineral, 1);
                OB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.K_Modulus(Mineral, 2);
                OB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.Mu_Modulus(Mineral, 1);
                OB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Carbonate_Scenario.Matrix.OB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MineralsNames(Mineral);
                ModelBounds.Carbonate_Scenario.Matrix.OB(Mineral).bounds= [OB_min_MaRho OB_min_K_Modulus OB_min_Mu_Modulus; OB_max_MaRho OB_max_K_Modulus OB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
            ModelBounds.Carbonate_Scenario.Fluid.OB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% UNDERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                UB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MaRho(Mineral, 1);
                UB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MaRho(Mineral, 2);
                UB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.K_Modulus(Mineral, 1);
                UB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.K_Modulus(Mineral, 2);
                UB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.Mu_Modulus(Mineral, 1);
                UB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Carbonate_Scenario.Matrix.UB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Carbonate_Sceinario.MineralsNames(Mineral);
                ModelBounds.Carbonate_Scenario.Matrix.UB(Mineral).bounds=[UB_min_MaRho UB_min_K_Modulus UB_min_Mu_Modulus; UB_max_MaRho UB_max_K_Modulus UB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
            ModelBounds.Carbonate_Scenario.Fluid.UB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% POROSITY %%%%%%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(1);
        MaxPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(2);
        PorType= MODEL.(genvarname(c)).Geology.Porosity.Type;
        
        ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type= PorType;
        ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds= [MinPor; MaxPor];
        if PorType==3
            ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).MidZoneLeft= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).MidZoneRight= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% Water Saturation %%%%%%%%%
    %%% Super RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Carbonate_Scenario.SW.Super_RES= [MinSW; MaxSW];
                break;
            end
        end
    end
    
    %%% Independent RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 1
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(c))= [MinSW; MaxSW];
            end
        end
    end
    
    %%% OB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Carbonate_Scenario.SW.OB= [MinSW; MaxSW];
            break;
        end
    end
    
    %%% UB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Carbonate_Scenario.SW.UB= [MinSW; MaxSW];
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Preparation of Clastics Scenario boundaries %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(Clastics_Scenario_Num)      % if there is Clastics Scenario then do the following
    ModelBounds.Clastics_Scenario= '';
    
    %%%%% RESERVOIR %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            %%% We just want Number of first RES Entity so we break once we get it
            break;
        end
    end
    % Mineralogy
    RES_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Clastics_Scenario_Num, 1);
    RES_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Clastics_Scenario_Num, 2);
    RES_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Clastics_Scenario_Num, 1);
    RES_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Clastics_Scenario_Num, 2);
    RES_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Clastics_Scenario_Num, 1);
    RES_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Clastics_Scenario_Num, 2);
    
    ModelBounds.Clastics_Scenario.Matrix.RES=[RES_min_MaRho RES_min_K_Modulus RES_min_Mu_Modulus; RES_max_MaRho RES_max_K_Modulus RES_max_Mu_Modulus];
    
    % Fluids for Super RES Entity
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
                ModelBounds.Clastics_Scenario.Fluid.Super_RES= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
                break;   % Break after saving the Fluids of Super Entity
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Fluids for Independent RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
                ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(c))= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% OVERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                OB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MaRho(Mineral, 1);
                OB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MaRho(Mineral, 2);
                OB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.K_Modulus(Mineral, 1);
                OB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.K_Modulus(Mineral, 2);
                OB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.Mu_Modulus(Mineral, 1);
                OB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Clastics_Scenario.Matrix.OB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MineralsNames(Mineral);
                ModelBounds.Clastics_Scenario.Matrix.OB(Mineral).bounds= [OB_min_MaRho OB_min_K_Modulus OB_min_Mu_Modulus; OB_max_MaRho OB_max_K_Modulus OB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
            ModelBounds.Clastics_Scenario.Fluid.OB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% UNDERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                UB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MaRho(Mineral, 1);
                UB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MaRho(Mineral, 2);
                UB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.K_Modulus(Mineral, 1);
                UB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.K_Modulus(Mineral, 2);
                UB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.Mu_Modulus(Mineral, 1);
                UB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Clastics_Scenario.Matrix.UB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Clastics_Sceinario.MineralsNames(Mineral);
                ModelBounds.Clastics_Scenario.Matrix.UB(Mineral).bounds=[UB_min_MaRho UB_min_K_Modulus UB_min_Mu_Modulus; UB_max_MaRho UB_max_K_Modulus UB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
            ModelBounds.Clastics_Scenario.Fluid.UB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% POROSITY %%%%%%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(1);
        MaxPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(2);
        PorType= MODEL.(genvarname(c)).Geology.Porosity.Type;
        
        ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type= PorType;
        ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds= [MinPor; MaxPor];
        if PorType==3
            ModelBounds.Clastics_Scenario.POR.(genvarname(c)).MidZoneLeft= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            ModelBounds.Clastics_Scenario.POR.(genvarname(c)).MidZoneRight= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% Water Saturation %%%%%%%%%
    %%% Super RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Clastics_Scenario.SW.Super_RES= [MinSW; MaxSW];
                break;
            end
        end
    end
    
    %%% Independent RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 1
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(c))= [MinSW; MaxSW];
            end
        end
    end
    
    %%% OB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Clastics_Scenario.SW.OB= [MinSW; MaxSW];
            break;
        end
    end
    
    %%% UB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Clastics_Scenario.SW.UB= [MinSW; MaxSW];
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Preparation of Basalt Scenario boundaries %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(Basalt_Scenario_Num)      % if there is Basalt Scenario then do the following
    ModelBounds.Basalt_Scenario= '';
    
    %%%%% RESERVOIR %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            %%% We just want Number of first RES Entity so we break once we get it
            break;
        end
    end
    % Mineralogy
    RES_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Basalt_Scenario_Num, 1);
    RES_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.MaRho(Basalt_Scenario_Num, 2);
    RES_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Basalt_Scenario_Num, 1);
    RES_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.K_Modulus(Basalt_Scenario_Num, 2);
    RES_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Basalt_Scenario_Num, 1);
    RES_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Mu_Modulus(Basalt_Scenario_Num, 2);
    
    ModelBounds.Basalt_Scenario.Matrix.RES=[RES_min_MaRho RES_min_K_Modulus RES_min_Mu_Modulus; RES_max_MaRho RES_max_K_Modulus RES_max_Mu_Modulus];
    
    % Fluids for Super RES Entity
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
                ModelBounds.Basalt_Scenario.Fluid.Super_RES= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
                break;   % Break after saving the Fluids of Super Entity
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Fluids for Independent RES Entities
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent
                NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
                ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(c))= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% OVERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                OB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MaRho(Mineral, 1);
                OB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MaRho(Mineral, 2);
                OB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.K_Modulus(Mineral, 1);
                OB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.K_Modulus(Mineral, 2);
                OB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.Mu_Modulus(Mineral, 1);
                OB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Basalt_Scenario.Matrix.OB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MineralsNames(Mineral);
                ModelBounds.Basalt_Scenario.Matrix.OB(Mineral).bounds= [OB_min_MaRho OB_min_K_Modulus OB_min_Mu_Modulus; OB_max_MaRho OB_max_K_Modulus OB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
            ModelBounds.Basalt_Scenario.Fluid.OB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% UNDERBURDEN %%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            % Mineralogy
            NumOfMinerals= length(MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MineralsNames);
            for Mineral=1:NumOfMinerals
                UB_min_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MaRho(Mineral, 1);
                UB_max_MaRho= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MaRho(Mineral, 2);
                UB_min_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.K_Modulus(Mineral, 1);
                UB_max_K_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.K_Modulus(Mineral, 2);
                UB_min_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.Mu_Modulus(Mineral, 1);
                UB_max_Mu_Modulus= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.Mu_Modulus(Mineral, 2);
                
                ModelBounds.Basalt_Scenario.Matrix.UB(Mineral).name= MODEL.(genvarname(c)).Geology.Mineralogy.Basalt_Sceinario.MineralsNames(Mineral);
                ModelBounds.Basalt_Scenario.Matrix.UB(Mineral).bounds=[UB_min_MaRho UB_min_K_Modulus UB_min_Mu_Modulus; UB_max_MaRho UB_max_K_Modulus UB_max_Mu_Modulus];
            end
            
            % Fluids
            NumOfFluids= length(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
            ModelBounds.Basalt_Scenario.Fluid.UB= transpose(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames);
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% POROSITY %%%%%%%%%
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(1);
        MaxPor= MODEL.(genvarname(c)).Geology.Porosity.Limits(2);
        PorType= MODEL.(genvarname(c)).Geology.Porosity.Type;
        
        ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type= PorType;
        ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds= [MinPor; MaxPor];
        if PorType==3
            ModelBounds.Basalt_Scenario.POR.(genvarname(c)).MidZoneLeft= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            ModelBounds.Basalt_Scenario.POR.(genvarname(c)).MidZoneRight= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% Water Saturation %%%%%%%%%
    %%% Super RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Basalt_Scenario.SW.Super_RES= [MinSW; MaxSW];
                break;
            end
        end
    end
    
    %%% Independent RES
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 1
                MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
                MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
                
                ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(c))= [MinSW; MaxSW];
            end
        end
    end
    
    %%% OB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Basalt_Scenario.SW.OB= [MinSW; MaxSW];
            break;
        end
    end
    
    %%% UB
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
            MinSW= MODEL.(genvarname(c)).Geology.FluidContent.MinSW;
            MaxSW= MODEL.(genvarname(c)).Geology.FluidContent.MaxSW;
            
            ModelBounds.Basalt_Scenario.SW.UB= [MinSW; MaxSW];
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
end

setappdata(handles.Model_fig, 'ModelBounds', ModelBounds);

