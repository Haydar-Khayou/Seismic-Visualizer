function BAT(handles, UserData)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of science
%           Author: Haydar Khayou
%
%% Variables to optimize
% 1- RES matrix Min density= MaRho(1);
% 1- RES matrix Max density= MaRho(2);
% 2- RES matrix Min p-wave velocity= K_Modulus(1);
% 2- RES matrix Max p-wave velocity= K_Modulus(2);
% 3- RES matrix Min s-wave velocity= Mu_Modulus(1);
% 3- RES matrix Max s-wave velocity= Mu_Modulus(2);
% 4- RES Fluid type= FluidsNames;
% 5- RES SW Min= MinSW;
% 5- RES SW Max= MaxSW;
% 6- OB matrix Min density= MaRho(1);
% 6- OB matrix Max density= MaRho(2);
% 7- OB matrix Min p-wave velocity= K_Modulus(1);
% 7- OB matrix Max p-wave velocity= K_Modulus(2);
% 8- OB matrix Min s-wave velocity= Mu_Modulus(1);
% 8- OB matrix Max s-wave velocity= Mu_Modulus(2);
% 9- OB Fluid type= FluidsNames;
% 10- OB SW Min= MinSW;
% 10- OB SW Max= MaxSW;
% 11- UB matrix Min density= MaRho(1);
% 11- UB matrix Max density= MaRho(2);
% 12- UB matrix Min p-wave velocity= K_Modulus(1);
% 12- UB matrix Max p-wave velocity= K_Modulus(2);
% 13- UB matrix Min s-wave velocity= Mu_Modulus(1);
% 13- UB matrix Max s-wave velocity= Mu_Modulus(2);
% 14- UB Fluid type= FluidsNames;
% 15- UB SW Min= MinSW;
% 15- UB SW Max= MaxSW;
% 16- Frequency of wavelet MIN
% 16- Frequency of wavelet Max
% 17- Porosity for each entity, dependes on the number of entities and the
% type of porosity that the user have chosen


%% Variables
global MODEL ModelBounds NumberofEntities
global Bats bBats gBat
global NRMSE NP Min_Freq Max_Freq loudness alpha init_emission_rate gamma iteration 
global Car_Monitor_Num Clas_Monitor_Num Bas_Monitor_Num
global T Init_Vel

Bats= '';
bBats= '';
gBat= '';

% Get The MODEL
MODEL= getappdata(handles.Model_fig, 'MODEL');

% Get the number of Entities we have
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities');

% Upper and Lower Bounds of the variables exist in ModelBounds Variable
ModelBounds= getappdata(handles.Model_fig, 'ModelBounds');

% What number does each Scenario have?
Carbonate_Scenario_Num= ModelBounds.Carbonate_Scenario_Num;
Clastics_Scenario_Num= ModelBounds.Clastics_Scenario_Num;
Basalt_Scenario_Num= ModelBounds.Basalt_Scenario_Num;

global Data NEL SeisAmp_Max Obs
SeisAmp_Max= Data.SeisAmp_Max;      % Get The highest amplitude
Obs= Data.Cleaned_Section;          % Observed Data is the Seismic horizons(trimmed from the full section)
NEL= numel(Obs);                    % number of cells of Seis/synth matrix

%% if you want to enable parallel computation using GPU alongside CPU
% % if ~isempty(Carbonate_Scenario_Num)
% %     ModelBounds.Frequency= gpuArray(ModelBounds.Frequency);
% %     ModelBounds.Carbonate_Scenario.Matrix.RES= gpuArray(ModelBounds.Carbonate_Scenario.Matrix.RES);
% %     ModelBounds.Carbonate_Scenario.Matrix.OB.bounds= gpuArray(ModelBounds.Carbonate_Scenario.Matrix.OB.bounds);
% %     ModelBounds.Carbonate_Scenario.Matrix.UB.bounds= gpuArray(ModelBounds.Carbonate_Scenario.Matrix.UB.bounds);
% % end
% % if ~isempty(Clastics_Scenario_Num)
% %     ModelBounds.Frequency= gpuArray(ModelBounds.Frequency);
% %     ModelBounds.Clastics_Scenario.Matrix.RES= gpuArray(ModelBounds.Clastics_Scenario.Matrix.RES);
% %     ModelBounds.Clastics_Scenario.Matrix.OB.bounds= gpuArray(ModelBounds.Clastics_Scenario.Matrix.OB.bounds);
% %     ModelBounds.Clastics_Scenario.Matrix.UB.bounds= gpuArray(ModelBounds.Clastics_Scenario.Matrix.UB.bounds);
% % end
% % if ~isempty(Basalt_Scenario_Num)
% %     ModelBounds.Frequency= gpuArray(ModelBounds.Frequency);
% %     ModelBounds.Basalt_Scenario.Matrix.RES= gpuArray(ModelBounds.Basalt_Scenario.Matrix.RES);
% %     ModelBounds.Basalt_Scenario.Matrix.OB.bounds= gpuArray(ModelBounds.Basalt_Scenario.Matrix.OB.bounds);
% %     ModelBounds.Basalt_Scenario.Matrix.UB.bounds= gpuArray(ModelBounds.Basalt_Scenario.Matrix.UB.bounds);
% % end

%% Objective Function (NRMSE)
% The Objective function to optimize(minimize) is NRMSE

NRMSE= @(x) 100*sqrt(sum(sum((Obs - x).^2))/NEL)/(max(max(Obs)) - min(min(Obs)));

%% Algorithm Coefficients

T= UserData.Answers(1);   % Number of iterations

% Number of Bats
NP= UserData.Answers(2);

Max_Freq= UserData.Answers(3);   % Maximum Frequency
Min_Freq= UserData.Answers(4);   % Minimum Frequency

loudness= UserData.Answers(5);   % Initial loudness

% alpha= last Loudness^(1/last iteration)
Last_Loudness= UserData.Answers(6);
alpha= Last_Loudness^(1/T);  % loudness decreasing coefficient

init_emission_rate= 1;  % emission rate

% gamma= -log(1-(last_emission_rate/initial_emission_rate))/last iteration
last_emission_rate= UserData.Answers(7);
gamma= -log(1-(last_emission_rate/init_emission_rate))/T;   % emission rate increasing coefficient


% Initial Veloity
Init_Vel= UserData.Answers(8);      % Initial velocity for Bats;

%% Preparation of Bats
empty.pos= [];                     % pos is position of the Bats contains the values of unknowns.
empty.final_cost= [];              % The error of the current position.
empty.VpEq= [];                    % The best-performance velocity equation.
empty.Scenario= [];                % Carbonate, clastics, or basaltic.
empty.Bulk_Density_Model= [];      % The bulk density model
empty.Velocity_Model= [];          % The velocity model
empty.Synthetic= [];               % The synthetic section
empty.Frequency= [];               % The frequency
empty.iteration= [];               % the number of iteration
empty.loudness= loudness;
empty.emission_rate= init_emission_rate;

%%% Initiate a struct variable called Bats to store info
if ~isempty(Carbonate_Scenario_Num)
    Bats.Carbonate= repmat(empty, NP, 1);
end
if ~isempty(Clastics_Scenario_Num)
    Bats.Clastics= repmat(empty, NP, 1);
end
if ~isempty(Basalt_Scenario_Num)
    Bats.Basalt= repmat(empty, NP, 1);
end

%% First time picking variables(randomly)
% in this section we initiate the searching Bats with random values
% within the search space. We save the Bats under the struct variable
% named 'Bats'. We then initiate another struct variable 'named'
% 'bBats' which contains the best LOCAL position of each Bat so
% far.
global i
i= 1;    % i is Bat_Num. We Choose it equal to 1 for the first time
% initializing of Bats in the next function "Bats_Creator"
tic
BAT_Particles_Creator(handles)   % This function creates the Bats for the first time.

%% Classification
global Car_Num Clas_Num Bas_Num
Car_Num= ModelBounds.Carbonate_Scenario_Num;
Clas_Num= ModelBounds.Clastics_Scenario_Num;
Bas_Num= ModelBounds.Basalt_Scenario_Num;

% Carbonate
if ~isempty(Car_Num)
    bBats.Carbonate= Bats.Carbonate;                 % Because we still have only one value of each Bat
    [~, index]= min([bBats.Carbonate.final_cost]);        % Sort solutions in order
    gBat.Scenarios(Car_Num)= bBats.Carbonate(index);  % The global best solution so far.
    
    gBat.Global.Car(1)= gBat.Scenarios(Car_Num);       % The global best solution so far.
    gBat.Global.Car_avr_Bats= mean([Bats.Carbonate.final_cost]); % save the average cost of Bats.
    gBat.Global.Car_avr_bBats= mean([bBats.Carbonate.final_cost]); % save the average of bBats
    gBat.Global.Car_ObjFun(1)= gBat.Scenarios(Car_Num).final_cost; % save the objfunc so far
end

% Clastics
if ~isempty(Clas_Num)
    bBats.Clastics= Bats.Clastics;
    [~, index]= min([bBats.Clastics.final_cost]);
    gBat.Scenarios(Clas_Num)= bBats.Clastics(index);
    
    gBat.Global.Clas(1)= gBat.Scenarios(Clas_Num);
    gBat.Global.Clas_avr_Bats= mean([Bats.Clastics.final_cost]);
    gBat.Global.Clas_avr_bBats= mean([bBats.Clastics.final_cost]);
    gBat.Global.Clas_ObjFun(1)= gBat.Scenarios(Clas_Num).final_cost;       
end

% Basalt
if ~isempty(Bas_Num)
    bBats.Basalt= Bats.Basalt;
    [~, index]= min([bBats.Basalt.final_cost]);
    gBat.Scenarios(Bas_Num)= bBats.Basalt(index);
    
    gBat.Global.Bas(1)= gBat.Scenarios(Bas_Num);
    gBat.Global.Bas_avr_Bats= mean([Bats.Basalt.final_cost]);
    gBat.Global.Bas_avr_bBats= mean([bBats.Basalt.final_cost]);
    gBat.Global.Bas_ObjFun(1)= gBat.Scenarios(Bas_Num).final_cost;         
end

%% Monitoring Performance
% Choose random Bats from "Bats" structure and save them along
% the iterations. These will be used to measure the algorithm performance

if ~isempty(ModelBounds.Carbonate_Scenario_Num)
    Car_Monitor_Num= randi([1 NP], 1);
    gBat.Monitoring_Bats(1).Carbonate= Bats.Carbonate(randi([1 NP], 1));
end
if ~isempty(ModelBounds.Clastics_Scenario_Num)
    Clas_Monitor_Num= randi([1 NP], 1);
    gBat.Monitoring_Bats(1).Clastics= Bats.Clastics(randi([1 NP], 1));
end
if ~isempty(ModelBounds.Basalt_Scenario_Num)
    Bas_Monitor_Num= randi([1 NP], 1);
    gBat.Monitoring_Bats(1).Basalt= Bats.Basalt(randi([1 NP], 1));
end


toc
%% main loop


iteration= 2;

BAT_Main_Loop(handles)


x=1;
save('Bat_Simulation_KA30_240iter_normal.mat', 'Data', 'MODEL', 'ModelBounds', 'gBat');
