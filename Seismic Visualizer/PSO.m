function PSO(handles, UserData)
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
global Particles bParticles gparticle
global NRMSE NP W minW alpha C1 C2 iteration 
global Car_Monitor_Num Clas_Monitor_Num Bas_Monitor_Num
global T Init_Vel

Particles= '';
bParticles= '';
gparticle= '';

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

%% Update Position Coefficients
%%%%% Lower values of: W, C1, C2 speed up convergence, higher values encourage mmore exploring of the search space

% First Parametr is W which must decrease in each iteration in order to
% decrease the search space so we end up with a single solution or a very
% narrow area of the search space.
% There are many ways to decrease the value of W, the most two known ones
% are as follows:
% In the first approach the value of W keeps decreasing infinitely:
% W= MaxW;
% alpha= 0.1;
% for iter=1:T
% "CODE";
% W= W*(1 - alpha);
% end

% In the second approach the value of W starts from MaxW and end at MinW and decrease by alpha in each iteration:
% W= VALUE1;
% MinW= VALUE2;
% alpha= ((W - MinW)/(T+1))
% for iter=1:T
% "CODE";
%   if W>MinW
%     W= W - alpha;
%   end
% end

T= UserData.Answers(1);   % Number of iterations

NP= UserData.Answers(2);  % Number of Particles

W= UserData.Answers(3);          % inetria usually between 0.8 and 1.2

% alpha= 0.01;     % How much the value of W decreases

minW= UserData.Answers(4);


alpha= ((W - minW)/(T));      % a percentage to determine how much the W decreases in each iteration
                                % the decrease in W is important to end up with a single solution

%%%%%%% Cognitive coefficient C1  %%%%%%%%
% • Acts as the particle’s memory, causing it to
% return to its individual best regions of the search space.
% • C1 limits the size of the step the particle takes toward its individual best
% • must be 0<=C1<=2
% • Cognitive coefficient C1 usually close to 2.
C1= UserData.Answers(5);     % Cognitive coefficient C1

%%%%%%% Social coefficient C2  %%%%%%%%
% • Causes the particle to move to the best regions the swarm has found so
% • must be 0<=C2<=2
% • usually C2 close to 2
% • C2 limits the size of the step the particle takes toward the global best g
C2= UserData.Answers(6);     % Social coefficient C2


%% Initial Veloity
Init_Vel= UserData.Answers(7);      % Initial velocity for particles;

%% Preparation of Particles
empty.pos= [];                     % pos is position of the particles contains the values of unknowns.
empty.final_cost= [];              % The error of the current position.
empty.VpEq= [];                    % The best-performance velocity equation.
empty.Scenario= [];                % Carbonate, clastics, or basaltic.
empty.Bulk_Density_Model= [];      % The bulk density model
empty.Velocity_Model= [];          % The velocity model
empty.Synthetic= [];               % The synthetic section
empty.Frequency= [];               % The frequency
empty.iteration= [];               % the number of iteration

%%% Initiate a struct variable called Particles to store info
if ~isempty(Carbonate_Scenario_Num)
    Particles.Carbonate_particle= repmat(empty, NP, 1);
end
if ~isempty(Clastics_Scenario_Num)
    Particles.Clastics_particle= repmat(empty, NP, 1);
end
if ~isempty(Basalt_Scenario_Num)
    Particles.Basalt_particle= repmat(empty, NP, 1);
end

%% First time picking variables(randomly)
% in this section we initiate the searching particles with random values
% within the search space. We save the particles under the struct variable
% named 'Particles'. We then initiate another struct variable 'named'
% 'bparticles' which contains the best LOCAL position of each particle so
% far.
global i
i= 1;    % i is Particle_Num. We Choose it equal to 1 for the first time
% initializing of particles in the next function "Particles_Creator"
tic
PSO_Particles_Creator(handles)   % This function creates the Particles for the first time.

%% Classification
global Car_Num Clas_Num Bas_Num
Car_Num= ModelBounds.Carbonate_Scenario_Num;
Clas_Num= ModelBounds.Clastics_Scenario_Num;
Bas_Num= ModelBounds.Basalt_Scenario_Num;

% Carbonate
if ~isempty(Car_Num)
    bParticles.Carbonate= Particles.Carbonate_particle;                 % Because we still have only one value of each particle
    [~, index]= sort([Particles.Carbonate_particle.final_cost]);        % Sort solutions in order
    gparticle.Scenarios(Car_Num)= Particles.Carbonate_particle(index(1));  % The global best solution so far.
    gparticle.Global.Car(1)= Particles.Carbonate_particle(index(1));       % The global best solution so far.
    gparticle.Global.Car_avr_particles= mean([Particles.Carbonate_particle.final_cost]); % save the average cost of particles.
    gparticle.Global.Car_avr_bparticles= mean([bParticles.Carbonate.final_cost]); % save the average of bparticles
    gparticle.Global.Car_ObjFun(1)= gparticle.Scenarios(Car_Num).final_cost; % save the objfunc so far 
end

% Clastics
if ~isempty(Clas_Num)
    bParticles.Clastics= Particles.Clastics_particle;
    [~, index]= sort([Particles.Clastics_particle.final_cost]);
    gparticle.Scenarios(Clas_Num)= Particles.Clastics_particle(index(1));
    gparticle.Global.Clas(1)= Particles.Clastics_particle(index(1));
    gparticle.Global.Clas_avr_particles= mean([Particles.Clastics_particle.final_cost]);
    gparticle.Global.Clas_avr_bparticles= mean([bParticles.Clastics.final_cost]);
    gparticle.Global.Clas_ObjFun(1)= gparticle.Scenarios(Clas_Num).final_cost;       
end

% Basalt
if ~isempty(Bas_Num)
    bParticles.Basalt= Particles.Basalt_particle;
    [~, index]= sort([Particles.Basalt_particle.final_cost]);
    gparticle.Scenarios(Bas_Num)= Particles.Basalt_particle(index(1));
    gparticle.Global.Bas(1)= Particles.Basalt_particle(index(1));
    gparticle.Global.Bas_avr_particles= mean([Particles.Basalt_particle.final_cost]);
    gparticle.Global.Bas_avr_bparticles= mean([bParticles.Basalt.final_cost]);
    gparticle.Global.Bas_ObjFun(1)= gparticle.Scenarios(Bas_Num).final_cost;         
end

%% Monitoring Performance
% Choose random particles from "Particles" structure and save them along
% the iterations. These will be used to measure the algorithm performance

if ~isempty(ModelBounds.Carbonate_Scenario_Num)
    Car_Monitor_Num= randi([1 NP], 1);
    gparticle.Monitoring_Particles(1).Carbonate= Particles.Carbonate_particle(randi([1 NP], 1));
end
if ~isempty(ModelBounds.Clastics_Scenario_Num)
    Clas_Monitor_Num= randi([1 NP], 1);
    gparticle.Monitoring_Particles(1).Clastics= Particles.Clastics_particle(randi([1 NP], 1));
end
if ~isempty(ModelBounds.Basalt_Scenario_Num)
    Bas_Monitor_Num= randi([1 NP], 1);
    gparticle.Monitoring_Particles(1).Basalt= Particles.Basalt_particle(randi([1 NP], 1));
end


toc
%% main loop


iteration= 2;

PSO_Main_Loop(handles)


x=1;
save('Simulation_KA40_240iter_normal.mat', 'Data', 'MODEL', 'ModelBounds', 'gparticle');
