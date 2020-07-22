function PSO_Particles_Variables_Modifier(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of science
%           Author: Haydar Khayou
%
%% Intro:
%   In this Function we change the variables values according the the G-PSO
%   algoritm and repeat the process until a certain criterium is met like a
%   certain number of iterations or when the NRMSE reaches a determined
%   value or when the velocity of one particles reaches a value, etc..

%% Variables
global Data MODEL ModelBounds NumberofEntities
global Particles bParticles gparticle Polarity
global NRMSE SeisAmp_Max i NP W C1 C2 Car_Num Clas_Num Bas_Num iteration

% What number does each Scenario have?
Carbonate_Scenario_Num= ModelBounds.Carbonate_Scenario_Num;
Clastics_Scenario_Num= ModelBounds.Clastics_Scenario_Num;
Basalt_Scenario_Num= ModelBounds.Basalt_Scenario_Num;

%% Modifying Particles' positions


if ~isempty(Carbonate_Scenario_Num)      % if there is Carbonate Scenario then do the following
    %% Frequency Position %%%
    Particles.Carbonate_particle(i).Frequency.Velocity= W*Particles.Carbonate_particle(i).Frequency.Velocity...
        +C1*rand(1, 1).*(bParticles.Carbonate(i).Frequency.Value - Particles.Carbonate_particle(i).Frequency.Value)...
        +C2*rand(1, 1).*(gparticle.Scenarios(Car_Num).Frequency.Value - Particles.Carbonate_particle(i).Frequency.Value);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    %%% Check whether the previous position is at either bound
    CarFreq= Particles.Carbonate_particle(i).Frequency.Value;
    FalUp= CarFreq>= ub;
    FalDown= CarFreq<= lb;
    
    %%% new Frequency = previous Frequency + Frequency new Velocity
    CarFreq= CarFreq + Particles.Carbonate_particle(i).Frequency.Velocity;
    CrossUp= CarFreq >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        CarFreq= ub;
    end
    reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
    if reflectUp
        CarFreq= ub - rand.*(ub - lb); % randomely choose values for them
    end
    
    CrossDown= CarFreq <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        CarFreq= lb;
    end
    reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
    if reflectDown
        CarFreq= lb + rand.*(ub - lb); % randomely choose values for them
    end
    
    %%% the new Position
    Particles.Carbonate_particle(i).Frequency.Value= CarFreq;
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'RES')   % RES Matrix is Carbonate
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Matrix.RES.Values_Velocity= W*Particles.Carbonate_particle(i).pos.Matrix.RES.Values_Velocity...
            +C1*rand(1, 3).*(bParticles.Carbonate(i).pos.Matrix.RES.Values - Particles.Carbonate_particle(i).pos.Matrix.RES.Values)...
            +C2*rand(1, 3).*(gparticle.Scenarios(Car_Num).pos.Matrix.RES.Values - Particles.Carbonate_particle(i).pos.Matrix.RES.Values);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        RESmatValues= Particles.Carbonate_particle(i).pos.Matrix.RES.Values;
        FalUp= RESmatValues>= ub;
        FalDown= RESmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        RESmatValues= RESmatValues + Particles.Carbonate_particle(i).pos.Matrix.RES.Values_Velocity;
        CrossUp= RESmatValues >= ub;   % get the coordinates of Crossing Up elements
        RESmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        RESmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= RESmatValues <= lb;   % get the coordinates Crossing Down elements
        RESmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        RESmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(RES Matrix Name)
        Particles.Carbonate_particle(i).pos.Matrix.RES.Values= RESmatValues;
        
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Matrix.OB.name_Velocity= W*Particles.Carbonate_particle(i).pos.Matrix.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Matrix.OB.name_number - Particles.Carbonate_particle(i).pos.Matrix.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Matrix.OB.name_number - Particles.Carbonate_particle(i).pos.Matrix.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxOBMatNumber= length(ModelBounds.Carbonate_Scenario.Matrix.OB);
        
        %%% Check whether the previous position is at either bound
        OBMat= Particles.Carbonate_particle(i).pos.Matrix.OB.name_number;
        FalUp= OBMat>= MaxOBMatNumber;
        FalDown= OBMat<= 1;
        
        %%% new name = previous name + name Velocity
        OBMat= OBMat + Particles.Carbonate_particle(i).pos.Matrix.OB.name_Velocity;
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OBMat= MaxOBMatNumber - rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OBMat= 1 + rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Matrix Name)
        OBMat= round(OBMat);
        Particles.Carbonate_particle(i).pos.Matrix.OB.name_number= OBMat;  % Matrix Number
        Particles.Carbonate_particle(i).pos.Matrix.OB.name= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= W*Particles.Carbonate_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +C1*rand(1, 3).*(bParticles.Carbonate(i).pos.Matrix.OB.Values(OBMat, :) - Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Car_Num).pos.Matrix.OB.Values(OBMat, :) - Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        OBmatValues= Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, :);
        FalUp= OBmatValues>= ub;
        FalDown= OBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        OBmatValues= OBmatValues + Particles.Carbonate_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        OBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        OBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(OB Matrix Name)
        Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Matrix.UB.name_Velocity= W*Particles.Carbonate_particle(i).pos.Matrix.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Matrix.UB.name_number - Particles.Carbonate_particle(i).pos.Matrix.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Matrix.UB.name_number - Particles.Carbonate_particle(i).pos.Matrix.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxUBMatNumber= length(ModelBounds.Carbonate_Scenario.Matrix.UB);
        
        %%% Check whether the previous position is at either bound
        UBMat= Particles.Carbonate_particle(i).pos.Matrix.UB.name_number;
        FalUp= UBMat>= MaxUBMatNumber;
        FalDown= UBMat<= 1;
        
        %%% new name = previous name + name Velocity
        UBMat= UBMat + Particles.Carbonate_particle(i).pos.Matrix.UB.name_Velocity;
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UBMat= MaxUBMatNumber - rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UBMat= 1 + rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Matrix Name)
        UBMat= round(UBMat);
        Particles.Carbonate_particle(i).pos.Matrix.UB.name_number= UBMat;  % Matrix Number
        Particles.Carbonate_particle(i).pos.Matrix.UB.name= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= W*Particles.Carbonate_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +C1*rand(1, 3).*(bParticles.Carbonate(i).pos.Matrix.UB.Values(UBMat, :) - Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Car_Num).pos.Matrix.UB.Values(UBMat, :) - Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        UBmatValues= Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, :);
        FalUp= UBmatValues>= ub;
        FalDown= UBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        UBmatValues= UBmatValues + Particles.Carbonate_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        UBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        UBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(UB Matrix Name)
        Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Super_RES')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_Velocity= W*Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_Velocity...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Fluid.Super_RES.name_number - Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Fluid.Super_RES.name_number - Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_Super_RES_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.Super_RES);
        
        %%% Check whether the previous position is at either bound
        Super_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number;
        FalUp= Super_RES_Fluid>= Max_Super_RES_FluidNumber;
        FalDown= Super_RES_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        Super_RES_Fluid= Super_RES_Fluid + Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_Velocity;
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            Super_RES_Fluid= Max_Super_RES_FluidNumber - rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            Super_RES_Fluid= 1 + rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            %%% Choose name Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= W*Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Max_Ind_RES_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            %%% Check whether the previous position is at either bound
            Ind_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;
            FalUp= Ind_RES_Fluid>= Max_Ind_RES_FluidNumber;
            FalDown= Ind_RES_Fluid<= 1;
            
            %%% new name = previous name + name Velocity
            Ind_RES_Fluid= Ind_RES_Fluid + Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber - rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
            if reflectDown
                Ind_RES_Fluid= 1 + rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'OB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Fluid.OB.name_Velocity= W*Particles.Carbonate_particle(i).pos.Fluid.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Fluid.OB.name_number - Particles.Carbonate_particle(i).pos.Fluid.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Fluid.OB.name_number - Particles.Carbonate_particle(i).pos.Fluid.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_OB_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.OB);
        
        %%% Check whether the previous position is at either bound
        OB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.OB.name_number;
        FalUp= OB_Fluid>= Max_OB_FluidNumber;
        FalDown= OB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        OB_Fluid= OB_Fluid + Particles.Carbonate_particle(i).pos.Fluid.OB.name_Velocity;
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OB_Fluid= Max_OB_FluidNumber - rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OB_Fluid= 1 + rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Particles.Carbonate_particle(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Particles.Carbonate_particle(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate_particle.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate_particle.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'UB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Carbonate_particle(i).pos.Fluid.UB.name_Velocity= W*Particles.Carbonate_particle(i).pos.Fluid.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.Fluid.UB.name_number - Particles.Carbonate_particle(i).pos.Fluid.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.Fluid.UB.name_number - Particles.Carbonate_particle(i).pos.Fluid.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_UB_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.UB);
        
        %%% Check whether the previous position is at either bound
        UB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.UB.name_number;
        FalUp= UB_Fluid>= Max_UB_FluidNumber;
        FalDown= UB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        UB_Fluid= UB_Fluid + Particles.Carbonate_particle(i).pos.Fluid.UB.name_Velocity;
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UB_Fluid= Max_UB_FluidNumber - rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UB_Fluid= 1 + rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Particles.Carbonate_particle(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name;
        Particles.Carbonate_particle(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate_particle.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate_particle.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Super_RES')
        Super_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        Particles.Carbonate_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= W*Particles.Carbonate_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Carbonate_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Carbonate_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        Super_RES_SW= Particles.Carbonate_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);
        FalUp= Super_RES_SW>= ub;
        FalDown= Super_RES_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        Super_RES_SW= Super_RES_SW + Particles.Carbonate_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            Super_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            Super_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Carbonate_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= W*Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
            lb= ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
            
            %%% Check whether the previous position is at either bound
            Ind_RES_SW= Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);
            FalUp= Ind_RES_SW>= ub;
            FalDown= Ind_RES_SW<= lb;
            
            %%% new Pos = previous Pos + Pos Velocity
            Ind_RES_SW= Ind_RES_SW + Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
            if reflectUp
                Ind_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
            if reflectDown
                Ind_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'OB')
        OB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
        Particles.Carbonate_particle(i).pos.SW.OB.Velocity(OB_Fluid)= W*Particles.Carbonate_particle(i).pos.SW.OB.Velocity(OB_Fluid)...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.SW.OB.Value(OB_Fluid) - Particles.Carbonate_particle(i).pos.SW.OB.Value(OB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.SW.OB.Value(OB_Fluid) - Particles.Carbonate_particle(i).pos.SW.OB.Value(OB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        OB_SW= Particles.Carbonate_particle(i).pos.SW.OB.Value(OB_Fluid);
        FalUp= OB_SW>= ub;
        FalDown= OB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        OB_SW= OB_SW + Particles.Carbonate_particle(i).pos.SW.OB.Velocity(OB_Fluid);
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            OB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            OB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Carbonate_particle(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'UB')
        UB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
        Particles.Carbonate_particle(i).pos.SW.UB.Velocity(UB_Fluid)= W*Particles.Carbonate_particle(i).pos.SW.UB.Velocity(UB_Fluid)...
            +C1*rand(1,1).*(bParticles.Carbonate(i).pos.SW.UB.Value(UB_Fluid) - Particles.Carbonate_particle(i).pos.SW.UB.Value(UB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.SW.UB.Value(UB_Fluid) - Particles.Carbonate_particle(i).pos.SW.UB.Value(UB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Carbonate_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        UB_SW= Particles.Carbonate_particle(i).pos.SW.UB.Value(UB_Fluid);
        FalUp= UB_SW>= ub;
        FalDown= UB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        UB_SW= UB_SW + Particles.Carbonate_particle(i).pos.SW.UB.Velocity(UB_Fluid);
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            UB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            UB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Carbonate_particle(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 1
            %%%% Choose Values Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at either bound
            POR_Value= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Porvalue;
            FalUp= POR_Value>= ub;
            FalDown= POR_Value<= lb;
            
            %%% new name = previous name + name Velocity
            POR_Value= POR_Value + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Velocity;
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                POR_Value= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                POR_Value= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound

            %%% Check whether the previous position is at eiter bound
            Left_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at either bound
            Left_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Left_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue;
            FalUp= Mid_Left_Porvalue>= ub;
            FalDown= Mid_Left_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Left_Porvalue_Velocity
            Mid_Left_Porvalue= Mid_Left_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;

            %%%%% Mid_Right Porosity Value %%%%%
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Right_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue;
            FalUp= Mid_Right_Porvalue>= ub;
            FalDown= Mid_Right_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Right_Porvalue_Velocity
            Mid_Right_Porvalue= Mid_Right_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;            
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
    end
    
    % % here we save the final Porosity matrix, Make it Comment with large size Data, Make it Comment with large size Data
    Particles.Carbonate_particle(i).pos.POR.FullMatrix= Phi;
    %%% at this stage we finish picking values for MODEL initialization
    %% Rho and Vp for saturated rock
    % We want to calculate Bulk Rho, Bulk Vp for Super_RES, Ind_RES, OB, UB
    % with Brine as saturation fluid, then if the chosen fluid is not
    % Brine we do Gassman's substitutions
    % Note: BulkRho= MaRho(1-Phi) + FlRho*Phi   The Volumetric average equation
    
    % BulkVp = There are three empirical folrmulaions to calculate Bulk Vp
    % 1- RHG Formula: Bulk_Vp= ((1-Phi).^2 * Vp_Matrix) + (Phi * Brine_Vp)
    % 2- WGG Formula: Bulk_Vp= 1./(((1-Phi)./Vp_Matrix)+(Phi./Brine_Vp))
    % 3- GGG Formula: Bulk_Vp= 0.3048.*(BulkRho/0.23)
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Super_RES
    MaRho= Particles.Carbonate_particle(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Particles.Carbonate_particle(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Particles.Carbonate_particle(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Particles.Carbonate_particle(i).pos.Fluid, 'Super_RES')
        BRRho= Carbonate_particle.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Carbonate_particle.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);  % in g/cc
        BulkRho_Super_RES= TempRho .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_Super_RES_RHG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_Super_RES_WGG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_Super_RES_GGG= TempVp .* MODEL.Super_RES.Matrix ;  % extract Super_RES coordinates
        
        if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
            tempVs= 0*(BulkVp_Super_RES_RHG).^2 + 0.58321.*(BulkVp_Super_RES_RHG) - 0.07775; % in Km/s
            BulkVs_Super_RES_RHG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_RHG.^2 - 4/3 .* BulkVs_Super_RES_RHG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Carbonate_particle.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Carbonate_particle.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Particles.Carbonate_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_Super_RES= rho_sat .* MODEL.Super_RES.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkRho_Super_RES(~coor)= 0;
            BulkRho_Super_RES= double(BulkRho_Super_RES);
            BulkRho_Super_RES= real(BulkRho_Super_RES);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_RHG(~coor)= 0;
            BulkVp_Super_RES_RHG= double(BulkVp_Super_RES_RHG);
            BulkVp_Super_RES_RHG= real(BulkVp_Super_RES_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
            tempVs= 0*(BulkVp_Super_RES_WGG).^2 + 0.58321.*(BulkVp_Super_RES_WGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_WGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_WGG.^2 - 4/3 .* BulkVs_Super_RES_WGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_WGG(~coor)= 0;
            BulkVp_Super_RES_WGG= double(BulkVp_Super_RES_WGG);
            BulkVp_Super_RES_WGG= real(BulkVp_Super_RES_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
            tempVs= 0*(BulkVp_Super_RES_GGG).^2 + 0.58321.*(BulkVp_Super_RES_GGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_GGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_GGG.^2 - 4/3 .* BulkVs_Super_RES_GGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_GGG(~coor)= 0;
            BulkVp_Super_RES_GGG= double(BulkVp_Super_RES_GGG);
            BulkVp_Super_RES_GGG= real(BulkVp_Super_RES_GGG);
            
        end
        %%% end of gassmans substitution
        
        BulkRho_RES= BulkRho_Super_RES;
        BulkVp_RES_RHG= BulkVp_Super_RES_RHG;
        BulkVp_RES_WGG= BulkVp_Super_RES_WGG;
        BulkVp_RES_GGG= BulkVp_Super_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Ind_RES Fluids
    if isfield(Particles.Carbonate_particle(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Particles.Carbonate_particle(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
            TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
            BulkRho_Ind_RES= TempRho.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % RHG Formula
            TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
            BulkVp_Ind_RES_RHG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % WGG Formula
            TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
            BulkVp_Ind_RES_WGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % GGG Formula
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: ft/s = 0.0003048 * km/s
            BulkVp_Ind_RES_GGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
                %% Start of gassmans substitution
                %%%%%%%%%%%%%%%% RHG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_RHG).^2 + 0.58321.*(BulkVp_Ind_RES_RHG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_RHG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_RHG.^2 - 4/3 .* BulkVs_Ind_RES_RHG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_RHG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                rho_hyc= Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Carbonate_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
                tsh= 1 - tsw;     % Hydrocarbon Saturation
                k_fl = 1./(tsw./k_brine + tsh./k_hyc);
                rho_fl = tsw.*BRRho + tsh.*rho_hyc;
                rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
                
                %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
                BulkRho_Ind_RES= rho_sat .* MODEL.(genvarname(ind_Entities{iter})).Matrix;    % The Bulk Density after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkRho_Ind_RES(~coor)= 0;
                BulkRho_Ind_RES= double(BulkRho_Ind_RES);
                BulkRho_Ind_RES= real(BulkRho_Ind_RES);
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_RHG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_RHG(~coor)= 0;
                BulkVp_Ind_RES_RHG= double(BulkVp_Ind_RES_RHG);
                BulkVp_Ind_RES_RHG= real(BulkVp_Ind_RES_RHG);
                
                %%%%%%%%%%%%%%%% WGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_WGG).^2 + 0.58321.*(BulkVp_Ind_RES_WGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_WGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_WGG.^2 - 4/3 .* BulkVs_Ind_RES_WGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_WGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_WGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_WGG(~coor)= 0;
                BulkVp_Ind_RES_WGG= double(BulkVp_Ind_RES_WGG);
                BulkVp_Ind_RES_WGG= real(BulkVp_Ind_RES_WGG);
                
                %%%%%%%%%%%%%%%% GGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in carbonates(we are now in Carbonate Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_GGG).^2 + 0.58321.*(BulkVp_Ind_RES_GGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_GGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_GGG.^2 - 4/3 .* BulkVs_Ind_RES_GGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_GGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_GGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_GGG(~coor)= 0;
                BulkVp_Ind_RES_GGG= double(BulkVp_Ind_RES_GGG);
                BulkVp_Ind_RES_GGG= real(BulkVp_Ind_RES_GGG);
                
            end
            %%% end of gassmans substitution
            BulkRho_Total_Ind_RES= BulkRho_Total_Ind_RES + BulkRho_Ind_RES;
            
            BulkVp_Total_Ind_RES_RHG= BulkVp_Total_Ind_RES_RHG + BulkVp_Ind_RES_RHG;
            BulkVp_Total_Ind_RES_WGG= BulkVp_Total_Ind_RES_WGG + BulkVp_Ind_RES_WGG;
            BulkVp_Total_Ind_RES_GGG= BulkVp_Total_Ind_RES_GGG + BulkVp_Ind_RES_GGG;
        end
        
        if isfield(Particles.Carbonate_particle(i).pos.Fluid, 'Super_RES')
            BulkRho_RES= BulkRho_RES + BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_RES_RHG + BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_RES_WGG + BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_RES_GGG + BulkVp_Total_Ind_RES_GGG;
        else
            BulkRho_RES= BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_Total_Ind_RES_GGG;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% OB
    if isfield(Particles.Carbonate_particle(i).pos.Matrix, 'OB')
        MaRho= Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Particles.Carbonate_particle(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Carbonate_particle.pos.Fluid.OB.Values{1, 1};
        BRVp= Carbonate_particle.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_OB= TempRho .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_OB_RHG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_OB_WGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_OB_GGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_RHG).^2 +  0.76969.*(BulkVp_OB_RHG) - 0.86735;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_RHG=  BulkVp_OB_RHG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_RHG.^2 - 4/3 .* BulkVs_OB_RHG.^2);
            g = BulkRho_OB.* BulkVs_OB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Carbonate_particle.pos.Fluid.OB.Values{2, 1};
            k_hyc= Carbonate_particle.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Particles.Carbonate_particle(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_OB= rho_sat .* MODEL.OB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkRho_OB(~coor)= 0;
            BulkRho_OB= double(BulkRho_OB);
            BulkRho_OB= real(BulkRho_OB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_RHG(~coor)= 0;
            BulkVp_OB_RHG= double(BulkVp_OB_RHG);
            BulkVp_OB_RHG= real(BulkVp_OB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_WGG).^2 +  0.76969.*(BulkVp_OB_WGG) - 0.86735;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_WGG=  BulkVp_OB_WGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_WGG.^2 - 4/3 .* BulkVs_OB_WGG.^2);
            g = BulkRho_OB.* BulkVs_OB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_WGG(~coor)= 0;
            BulkVp_OB_WGG= double(BulkVp_OB_WGG);
            BulkVp_OB_WGG= real(BulkVp_OB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_GGG).^2 +  0.76969.*(BulkVp_OB_GGG) - 0.86735;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_GGG=  BulkVp_OB_GGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_GGG.^2 - 4/3 .* BulkVs_OB_GGG.^2);
            g = BulkRho_OB.* BulkVs_OB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_GGG(~coor)= 0;
            BulkVp_OB_GGG= double(BulkVp_OB_GGG);
            BulkVp_OB_GGG= real(BulkVp_OB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% UB
    if isfield(Particles.Carbonate_particle(i).pos.Matrix, 'UB')
        MaRho= Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Particles.Carbonate_particle(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Carbonate_particle.pos.Fluid.UB.Values{1, 1};
        BRVp= Carbonate_particle.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_UB= TempRho .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_UB_RHG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_UB_WGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_UB_GGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_RHG).^2 +  0.76969.*(BulkVp_UB_RHG) - 0.86735;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_RHG= BulkVp_UB_RHG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_RHG.^2 - 4/3 .* BulkVs_UB_RHG.^2);
            g = BulkRho_UB.* BulkVs_UB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Carbonate_particle.pos.Fluid.UB.Values{2, 1};
            k_hyc= Carbonate_particle.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Particles.Carbonate_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Particles.Carbonate_particle(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_UB= rho_sat .* MODEL.UB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkRho_UB(~coor)= 0;
            BulkRho_UB= double(BulkRho_UB);
            BulkRho_UB= real(BulkRho_UB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_RHG(~coor)= 0;
            BulkVp_UB_RHG= double(BulkVp_UB_RHG);
            BulkVp_UB_RHG= real(BulkVp_UB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_WGG).^2 +  0.76969.*(BulkVp_UB_WGG) - 0.86735;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_WGG= BulkVp_UB_WGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_WGG.^2 - 4/3 .* BulkVs_UB_WGG.^2);
            g = BulkRho_UB.* BulkVs_UB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_WGG(~coor)= 0;
            BulkVp_UB_WGG= double(BulkVp_UB_WGG);
            BulkVp_UB_WGG= real(BulkVp_UB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Carbonate_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_GGG).^2 +  0.76969.*(BulkVp_UB_GGG) - 0.86735;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_GGG= BulkVp_UB_GGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_GGG.^2 - 4/3 .* BulkVs_UB_GGG.^2);
            g = BulkRho_UB.* BulkVs_UB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_GGG(~coor)= 0;
            BulkVp_UB_GGG= double(BulkVp_UB_GGG);
            BulkVp_UB_GGG= real(BulkVp_UB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%% Gather Bulk Rho, Bulk Vp Matrices
    if isfield(Particles.Carbonate_particle(i).pos.Matrix, 'OB') && isfield(Particles.Carbonate_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Particles.Carbonate_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Carbonate_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Particles.Carbonate_particle(i).pos.Matrix, 'OB') && isfield(Particles.Carbonate_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Particles.Carbonate_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Carbonate_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%% Create AI matrix %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% RHG %%%%
    AI_Matrix_1_RHG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_RHG;
    AI_Matrix_2_RHG= AI_Matrix_1_RHG;
    AI_Matrix_1_RHG(end, :)= [];
    AI_Matrix_2_RHG(1, :)= [];
    
    %%%%% WGG %%%%
    AI_Matrix_1_WGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_WGG;
    AI_Matrix_2_WGG= AI_Matrix_1_WGG;
    AI_Matrix_1_WGG(end, :)= [];
    AI_Matrix_2_WGG(1, :)= [];
    
    %%%%% GGG %%%%
    AI_Matrix_1_GGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_GGG;
    AI_Matrix_2_GGG= AI_Matrix_1_GGG;
    AI_Matrix_1_GGG(end, :)= [];
    AI_Matrix_2_GGG(1, :)= [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Creating RCs %%%%%%%%%%%%%%%%%%%%%%%%%
    Z1_RHG= AI_Matrix_1_RHG;
    Z2_RHG= AI_Matrix_2_RHG;
    RC_Matrix_RHG= (Z2_RHG-Z1_RHG)./(Z2_RHG+Z1_RHG);
    
    Z1_WGG= AI_Matrix_1_WGG;
    Z2_WGG= AI_Matrix_2_WGG;
    RC_Matrix_WGG= (Z2_WGG-Z1_WGG)./(Z2_WGG+Z1_WGG);
    
    Z1_GGG= AI_Matrix_1_GGG;
    Z2_GGG= AI_Matrix_2_GGG;
    RC_Matrix_GGG= (Z2_GGG-Z1_GGG)./(Z2_GGG+Z1_GGG);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Wavelet %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Sampling_Interval= str2double(handles.Sampling_Interval.String)/1000;    % Sampling Interval in Sec
    NumberOfSamples= 10/Sampling_Interval;
    NumberOfSamples= round(NumberOfSamples,0);
    if mod(NumberOfSamples, 2)==0
        NumberOfSamples= NumberOfSamples+1;
    end
    Frequency= Particles.Carbonate_particle(i).Frequency.Value;
    t0= 0;   %% Peak must be in the middle to make the wavelet symmetric
    [rw, ~] = Edited_ricker(Frequency, NumberOfSamples, Sampling_Interval, t0);
    
    Wavelet= Polarity.*rw;
    
    %%%%%%%%%%%%%%%%% Convolution %%%%%%%%%%%%%%%%%%%%%%
    %%% RHG
    Synthetic_RHG= conv2(Wavelet, 1,RC_Matrix_RHG);
    S1= size(Synthetic_RHG, 1);
    S2= size(RC_Matrix_RHG, 1);
    dif= (S1 - S2)/2;
    Synthetic_RHG(1:dif, :)= [];
    Synthetic_RHG(S2+1:end, :)= [];
    Synthetic_RHG = Synthetic_RHG .* Data.Horizons_grid_remove;
    
    %%% WGG
    Synthetic_WGG= conv2(Wavelet, 1,RC_Matrix_WGG);
    S1= size(Synthetic_WGG, 1);
    S2= size(RC_Matrix_WGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_WGG(1:dif, :)= [];
    Synthetic_WGG(S2+1:end, :)= [];
    Synthetic_WGG = Synthetic_WGG .* Data.Horizons_grid_remove;
    
    %%% GGG
    Synthetic_GGG= conv2(Wavelet, 1,RC_Matrix_GGG);
    S1= size(Synthetic_GGG, 1);
    S2= size(RC_Matrix_GGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_GGG(1:dif, :)= [];
    Synthetic_GGG(S2+1:end, :)= [];
    Synthetic_GGG = Synthetic_GGG .* Data.Horizons_grid_remove;
    
    %%%%%%%%%%%%%%%%% Scaling %%%%%%%%%%%%%%%%%%%%%%
    % Scaling, by making the max value(absolute)in Synth= max Seismic
    
    %%% RHG
    SynthAmp_Max_RHG= max(abs(Synthetic_RHG(:)));
    Synthetic_RHG= Synthetic_RHG.* SeisAmp_Max/SynthAmp_Max_RHG;
    
    Synthetic_RHG(isnan(Synthetic_RHG))= 999;
    
    %%% WGG
    SynthAmp_Max_WGG= max(abs(Synthetic_WGG(:)));
    Synthetic_WGG= Synthetic_WGG.* SeisAmp_Max/SynthAmp_Max_WGG;
    
    Synthetic_WGG(isnan(Synthetic_WGG))= 999;
    
    %%% GGG
    SynthAmp_Max_GGG= max(abs(Synthetic_GGG(:)));
    Synthetic_GGG= Synthetic_GGG.* SeisAmp_Max/SynthAmp_Max_GGG;
    
    Synthetic_GGG(isnan(Synthetic_GGG))= 999;
    
    %% Evaluating of Synthetic Section %%%%%%%%%%%%%%%%%%%
    % in this process we will use Normalized Root Mean Square Error(NRMSE) to
    % determine the misfit between Seismic section and synthetic section
    % note that the normalization used in this NRMSE is the classical one,
    % which means NRMSE= RMSE/max(Observed)-min(Observed); so the root
    % mean sqaure error is divided by the range of observed data in order
    % to express NRMSE in percentage terms.
    % there are other ways to normalize RMSE like the HH-RMSE in which the
    % RMSE is divided by the product of Observed data with estimated data
    % and it is given as follows:
    % HH= sum((Obs - Est).^2)/sum(Obs .* Est);
    % there are different normalization methods you can use.
    
    %%% Calculation
    
    
    
    
    %%% RHG
    RHG_Cost= NRMSE(Synthetic_RHG);
    
    final= RHG_Cost;
    type= 1;   % which means RHG
    Synthetic= Synthetic_RHG;
    Velocity_Model= BulkVp_Total_Matrix_RHG;
    
    %%% WGG
    WGG_Cost= NRMSE(Synthetic_WGG);
    if final > WGG_Cost
        final= WGG_Cost;
        type= 2;   % which means WGG
        Synthetic= Synthetic_WGG;
        Velocity_Model= BulkVp_Total_Matrix_WGG;
    end
    
    %%% GGG
    GGG_Cost= NRMSE(Synthetic_GGG);
    if final > GGG_Cost
        final= GGG_Cost;
        type= 3;   % which means GGG
        Synthetic= Synthetic_GGG;
        Velocity_Model= BulkVp_Total_Matrix_GGG;
    end
    
    Particles.Carbonate_particle(i).final_cost= final;
    Particles.Carbonate_particle(i).VpEq= type;  % velocity formula with least misfit
    Particles.Carbonate_particle(i).Scenario= 1;   % 1 means Carbonate
    Particles.Carbonate_particle(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Particles.Carbonate_particle(i).Velocity_Model= Velocity_Model;
    Particles.Carbonate_particle(i).Synthetic= Synthetic;
    Particles.Carbonate_particle(i).iteration= iteration;
end



if ~isempty(Clastics_Scenario_Num)      % if there is Clastics Scenario then do the following
    %% Frequency Position %%%
    Particles.Clastics_particle(i).Frequency.Velocity= W*Particles.Clastics_particle(i).Frequency.Velocity...
        +C1*rand(1, 1).*(bParticles.Clastics(i).Frequency.Value - Particles.Clastics_particle(i).Frequency.Value)...
        +C2*rand(1, 1).*(gparticle.Scenarios(Clas_Num).Frequency.Value - Particles.Clastics_particle(i).Frequency.Value);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    %%% Check whether the previous position is at either bound
    ClasFreq= Particles.Clastics_particle(i).Frequency.Value;
    FalUp= ClasFreq>= ub;
    FalDown= ClasFreq<= lb;
    
    %%% new name = previous name + name Velocity
    ClasFreq= ClasFreq + Particles.Clastics_particle(i).Frequency.Velocity;
    CrossUp= ClasFreq >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        ClasFreq= ub;
    end
    reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
    if reflectUp
        ClasFreq= ub - rand.*(ub - lb); % randomely choose values for them
    end
    
    CrossDown= ClasFreq <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        ClasFreq= lb;
    end
    reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
    if reflectDown
        ClasFreq= lb + rand.*(ub - lb); % randomely choose values for them
    end
    
    %%% the new Position
    Particles.Clastics_particle(i).Frequency.Value= ClasFreq;
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'RES')   % RES Matrix is Clastics
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Matrix.RES.Values_Velocity= W*Particles.Clastics_particle(i).pos.Matrix.RES.Values_Velocity...
            +C1*rand(1, 3).*(bParticles.Clastics(i).pos.Matrix.RES.Values - Particles.Clastics_particle(i).pos.Matrix.RES.Values)...
            +C2*rand(1, 3).*(gparticle.Scenarios(Clas_Num).pos.Matrix.RES.Values - Particles.Clastics_particle(i).pos.Matrix.RES.Values);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        RESmatValues= Particles.Clastics_particle(i).pos.Matrix.RES.Values;
        FalUp= RESmatValues>= ub;
        FalDown= RESmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        RESmatValues= RESmatValues + Particles.Clastics_particle(i).pos.Matrix.RES.Values_Velocity;
        CrossUp= RESmatValues >= ub;   % get the coordinates of Crossing Up elements
        RESmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        RESmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= RESmatValues <= lb;   % get the coordinates Crossing Down elements
        RESmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        RESmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(RES Matrix Name)
        Particles.Clastics_particle(i).pos.Matrix.RES.Values= RESmatValues;
        
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Matrix.OB.name_Velocity= W*Particles.Clastics_particle(i).pos.Matrix.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.Matrix.OB.name_number - Particles.Clastics_particle(i).pos.Matrix.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Matrix.OB.name_number - Particles.Clastics_particle(i).pos.Matrix.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxOBMatNumber= length(ModelBounds.Clastics_Scenario.Matrix.OB);
        
        %%% Check whether the previous position is at either bound
        OBMat= Particles.Clastics_particle(i).pos.Matrix.OB.name_number;
        FalUp= OBMat>= MaxOBMatNumber;
        FalDown= OBMat<= 1;
        
        %%% new name = previous name + name Velocity
        OBMat= OBMat + Particles.Clastics_particle(i).pos.Matrix.OB.name_Velocity;
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OBMat= MaxOBMatNumber - rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OBMat= 1 + rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Matrix Name)
        OBMat= round(OBMat);
        Particles.Clastics_particle(i).pos.Matrix.OB.name_number= OBMat;  % Matrix Number
        Particles.Clastics_particle(i).pos.Matrix.OB.name= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= W*Particles.Clastics_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +C1*rand(1, 3).*(bParticles.Clastics(i).pos.Matrix.OB.Values(OBMat, :) - Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Clas_Num).pos.Matrix.OB.Values(OBMat, :) - Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        OBmatValues= Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, :);
        FalUp= OBmatValues>= ub;
        FalDown= OBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        OBmatValues= OBmatValues + Particles.Clastics_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        OBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        OBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(OB Matrix Name)
        Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Matrix.UB.name_Velocity= W*Particles.Clastics_particle(i).pos.Matrix.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.Matrix.UB.name_number - Particles.Clastics_particle(i).pos.Matrix.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Matrix.UB.name_number - Particles.Clastics_particle(i).pos.Matrix.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxUBMatNumber= length(ModelBounds.Clastics_Scenario.Matrix.UB);
        
        %%% Check whether the previous position is at either bound
        UBMat= Particles.Clastics_particle(i).pos.Matrix.UB.name_number;
        FalUp= UBMat>= MaxUBMatNumber;
        FalDown= UBMat<= 1;
        
        %%% new name = previous name + name Velocity
        UBMat= UBMat + Particles.Clastics_particle(i).pos.Matrix.UB.name_Velocity;
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UBMat= MaxUBMatNumber - rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UBMat= 1 + rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Matrix Name)
        UBMat= round(UBMat);
        Particles.Clastics_particle(i).pos.Matrix.UB.name_number= UBMat;  % Matrix Number
        Particles.Clastics_particle(i).pos.Matrix.UB.name= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= W*Particles.Clastics_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +C1*rand(1, 3).*(bParticles.Clastics(i).pos.Matrix.UB.Values(UBMat, :) - Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Clas_Num).pos.Matrix.UB.Values(UBMat, :) - Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        UBmatValues= Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, :);
        FalUp= UBmatValues>= ub;
        FalDown= UBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        UBmatValues= UBmatValues + Particles.Clastics_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        UBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        UBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(UB Matrix Name)
        Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Super_RES')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_Velocity= W*Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_Velocity...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.Fluid.Super_RES.name_number - Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Fluid.Super_RES.name_number - Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_Super_RES_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.Super_RES);
        
        %%% Check whether the previous position is at either bound
        Super_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number;
        FalUp= Super_RES_Fluid>= Max_Super_RES_FluidNumber;
        FalDown= Super_RES_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        Super_RES_Fluid= Super_RES_Fluid + Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_Velocity;
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            Super_RES_Fluid= Max_Super_RES_FluidNumber - rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            Super_RES_Fluid= 1 + rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            %%% Choose name Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= W*Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Max_Ind_RES_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            %%% Check whether the previous position is at either bound
            Ind_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;
            FalUp= Ind_RES_Fluid>= Max_Ind_RES_FluidNumber;
            FalDown= Ind_RES_Fluid<= 1;
            
            %%% new name = previous name + name Velocity
            Ind_RES_Fluid= Ind_RES_Fluid + Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber - rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
            if reflectDown
                Ind_RES_Fluid= 1 + rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'OB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Fluid.OB.name_Velocity= W*Particles.Clastics_particle(i).pos.Fluid.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.Fluid.OB.name_number - Particles.Clastics_particle(i).pos.Fluid.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Fluid.OB.name_number - Particles.Clastics_particle(i).pos.Fluid.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_OB_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.OB);
        
        %%% Check whether the previous position is at either bound
        OB_Fluid= Particles.Clastics_particle(i).pos.Fluid.OB.name_number;
        FalUp= OB_Fluid>= Max_OB_FluidNumber;
        FalDown= OB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        OB_Fluid= OB_Fluid + Particles.Clastics_particle(i).pos.Fluid.OB.name_Velocity;
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OB_Fluid= Max_OB_FluidNumber - rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OB_Fluid= 1 + rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Particles.Clastics_particle(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Particles.Clastics_particle(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics_particle.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics_particle.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'UB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Clastics_particle(i).pos.Fluid.UB.name_Velocity= W*Particles.Clastics_particle(i).pos.Fluid.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.Fluid.UB.name_number - Particles.Clastics_particle(i).pos.Fluid.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.Fluid.UB.name_number - Particles.Clastics_particle(i).pos.Fluid.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_UB_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.UB);
        
        %%% Check whether the previous position is at either bound
        UB_Fluid= Particles.Clastics_particle(i).pos.Fluid.UB.name_number;
        FalUp= UB_Fluid>= Max_UB_FluidNumber;
        FalDown= UB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        UB_Fluid= UB_Fluid + Particles.Clastics_particle(i).pos.Fluid.UB.name_Velocity;
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UB_Fluid= Max_UB_FluidNumber - rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UB_Fluid= 1 + rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Particles.Clastics_particle(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name;
        Particles.Clastics_particle(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics_particle.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics_particle.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Super_RES')
        Super_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        Particles.Clastics_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= W*Particles.Clastics_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Clastics_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Clastics_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        Super_RES_SW= Particles.Clastics_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);
        FalUp= Super_RES_SW>= ub;
        FalDown= Super_RES_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        Super_RES_SW= Super_RES_SW + Particles.Clastics_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            Super_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            Super_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Clastics_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= W*Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
            lb= ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
            
            %%% Check whether the previous position is at either bound
            Ind_RES_SW= Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);
            FalUp= Ind_RES_SW>= ub;
            FalDown= Ind_RES_SW<= lb;
            
            %%% new Pos = previous Pos + Pos Velocity
            Ind_RES_SW= Ind_RES_SW + Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
            if reflectUp
                Ind_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
            if reflectDown
                Ind_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'OB')
        OB_Fluid= Particles.Clastics_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
        Particles.Clastics_particle(i).pos.SW.OB.Velocity(OB_Fluid)= W*Particles.Clastics_particle(i).pos.SW.OB.Velocity(OB_Fluid)...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.SW.OB.Value(OB_Fluid) - Particles.Clastics_particle(i).pos.SW.OB.Value(OB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.SW.OB.Value(OB_Fluid) - Particles.Clastics_particle(i).pos.SW.OB.Value(OB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        OB_SW= Particles.Clastics_particle(i).pos.SW.OB.Value(OB_Fluid);
        FalUp= OB_SW>= ub;
        FalDown= OB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        OB_SW= OB_SW + Particles.Clastics_particle(i).pos.SW.OB.Velocity(OB_Fluid);
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            OB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            OB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Clastics_particle(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'UB')
        UB_Fluid= Particles.Clastics_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
        Particles.Clastics_particle(i).pos.SW.UB.Velocity(UB_Fluid)= W*Particles.Clastics_particle(i).pos.SW.UB.Velocity(UB_Fluid)...
            +C1*rand(1,1).*(bParticles.Clastics(i).pos.SW.UB.Value(UB_Fluid) - Particles.Clastics_particle(i).pos.SW.UB.Value(UB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.SW.UB.Value(UB_Fluid) - Particles.Clastics_particle(i).pos.SW.UB.Value(UB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Clastics_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        UB_SW= Particles.Clastics_particle(i).pos.SW.UB.Value(UB_Fluid);
        FalUp= UB_SW>= ub;
        FalDown= UB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        UB_SW= UB_SW + Particles.Clastics_particle(i).pos.SW.UB.Velocity(UB_Fluid);
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            UB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            UB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Clastics_particle(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 1
            %%%% Choose Values Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            POR_Value= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Porvalue;
            FalUp= POR_Value>= ub;
            FalDown= POR_Value<= lb;
            
            %%% new name = previous name + name Velocity
            POR_Value= POR_Value + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Velocity;
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                POR_Value= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                POR_Value= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            Left_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            Left_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Left_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue;
            FalUp= Mid_Left_Porvalue>= ub;
            FalDown= Mid_Left_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Left_Porvalue_Velocity
            Mid_Left_Porvalue= Mid_Left_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
			
			
			
            %%%%% Mid_Right Porosity Value %%%%%
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Right_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue;
            FalUp= Mid_Right_Porvalue>= ub;
            FalDown= Mid_Right_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Right_Porvalue_Velocity
            Mid_Right_Porvalue= Mid_Right_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;			
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
    end
    
    % % here we save the final Porosity matrix, Make it Comment with large size Data, Make it Comment with large size Data
    Particles.Clastics_particle(i).pos.POR.FullMatrix= Phi;
    %%% at this stage we finish picking values for MODEL initialization
    %% Rho and Vp for saturated rock
    % We want to calculate Bulk Rho, Bulk Vp for Super_RES, Ind_RES, OB, UB
    % with Brine as saturation fluid, then if the chosen fluid is not
    % Brine we do Gassman's substitutions
    % Note: BulkRho= MaRho(1-Phi) + FlRho*Phi   The Volumetric average equation
    
    % BulkVp = There are three empirical folrmulaions to calculate Bulk Vp
    % 1- RHG Formula: Bulk_Vp= ((1-Phi).^2 * Vp_Matrix) + (Phi * Brine_Vp)
    % 2- WGG Formula: Bulk_Vp= 1./(((1-Phi)./Vp_Matrix)+(Phi./Brine_Vp))
    % 3- GGG Formula: Bulk_Vp= 0.3048.*(BulkRho/0.23)
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Super_RES
    MaRho= Particles.Clastics_particle(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Particles.Clastics_particle(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Particles.Clastics_particle(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Particles.Clastics_particle(i).pos.Fluid, 'Super_RES')
        BRRho= Clastics_particle.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Clastics_particle.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);  % in g/cc
        BulkRho_Super_RES= TempRho .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_Super_RES_RHG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_Super_RES_WGG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_Super_RES_GGG= TempVp .* MODEL.Super_RES.Matrix ;  % extract Super_RES coordinates
        
        if ~strcmp(Particles.Clastics_particle(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Particles.Clastics_particle(i).pos.Fluid.Super_RES.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
            tempVs= 0*(BulkVp_Super_RES_RHG).^2 + 0.80416.*(BulkVp_Super_RES_RHG) - 0.85588; % in Km/s
            BulkVs_Super_RES_RHG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_RHG.^2 - 4/3 .* BulkVs_Super_RES_RHG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Clastics_particle.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Clastics_particle.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Particles.Clastics_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_Super_RES= rho_sat .* MODEL.Super_RES.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkRho_Super_RES(~coor)= 0;
            BulkRho_Super_RES= double(BulkRho_Super_RES);
            BulkRho_Super_RES= real(BulkRho_Super_RES);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_RHG(~coor)= 0;
            BulkVp_Super_RES_RHG= double(BulkVp_Super_RES_RHG);
            BulkVp_Super_RES_RHG= real(BulkVp_Super_RES_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
            tempVs= 0*(BulkVp_Super_RES_WGG).^2 + 0.58321.*(BulkVp_Super_RES_WGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_WGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_WGG.^2 - 4/3 .* BulkVs_Super_RES_WGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_WGG(~coor)= 0;
            BulkVp_Super_RES_WGG= double(BulkVp_Super_RES_WGG);
            BulkVp_Super_RES_WGG= real(BulkVp_Super_RES_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
            tempVs= 0*(BulkVp_Super_RES_GGG).^2 + 0.58321.*(BulkVp_Super_RES_GGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_GGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_GGG.^2 - 4/3 .* BulkVs_Super_RES_GGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_GGG(~coor)= 0;
            BulkVp_Super_RES_GGG= double(BulkVp_Super_RES_GGG);
            BulkVp_Super_RES_GGG= real(BulkVp_Super_RES_GGG);
            
        end
        %%% end of gassmans substitution
        
        BulkRho_RES= BulkRho_Super_RES;
        BulkVp_RES_RHG= BulkVp_Super_RES_RHG;
        BulkVp_RES_WGG= BulkVp_Super_RES_WGG;
        BulkVp_RES_GGG= BulkVp_Super_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Ind_RES Fluids
    if isfield(Particles.Clastics_particle(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Particles.Clastics_particle(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
            TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
            BulkRho_Ind_RES= TempRho.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % RHG Formula
            TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
            BulkVp_Ind_RES_RHG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % WGG Formula
            TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
            BulkVp_Ind_RES_WGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % GGG Formula
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: ft/s = 0.0003048 * km/s
            BulkVp_Ind_RES_GGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            if ~strcmp(Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
                %% Start of gassmans substitution
                %%%%%%%%%%%%%%%% RHG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_RHG).^2 + 0.58321.*(BulkVp_Ind_RES_RHG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_RHG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_RHG.^2 - 4/3 .* BulkVs_Ind_RES_RHG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_RHG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                rho_hyc= Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Clastics_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
                tsh= 1 - tsw;     % Hydrocarbon Saturation
                k_fl = 1./(tsw./k_brine + tsh./k_hyc);
                rho_fl = tsw.*BRRho + tsh.*rho_hyc;
                rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
                
                %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
                BulkRho_Ind_RES= rho_sat .* MODEL.(genvarname(ind_Entities{iter})).Matrix;    % The Bulk Density after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkRho_Ind_RES(~coor)= 0;
                BulkRho_Ind_RES= double(BulkRho_Ind_RES);
                BulkRho_Ind_RES= real(BulkRho_Ind_RES);
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_RHG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_RHG(~coor)= 0;
                BulkVp_Ind_RES_RHG= double(BulkVp_Ind_RES_RHG);
                BulkVp_Ind_RES_RHG= real(BulkVp_Ind_RES_RHG);
                
                %%%%%%%%%%%%%%%% WGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_WGG).^2 + 0.58321.*(BulkVp_Ind_RES_WGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_WGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_WGG.^2 - 4/3 .* BulkVs_Ind_RES_WGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_WGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_WGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_WGG(~coor)= 0;
                BulkVp_Ind_RES_WGG= double(BulkVp_Ind_RES_WGG);
                BulkVp_Ind_RES_WGG= real(BulkVp_Ind_RES_WGG);
                
                %%%%%%%%%%%%%%%% GGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Clasticss(we are now in Clastics Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_GGG).^2 + 0.58321.*(BulkVp_Ind_RES_GGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_GGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_GGG.^2 - 4/3 .* BulkVs_Ind_RES_GGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_GGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_GGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_GGG(~coor)= 0;
                BulkVp_Ind_RES_GGG= double(BulkVp_Ind_RES_GGG);
                BulkVp_Ind_RES_GGG= real(BulkVp_Ind_RES_GGG);
                
            end
            %%% end of gassmans substitution
            BulkRho_Total_Ind_RES= BulkRho_Total_Ind_RES + BulkRho_Ind_RES;
            
            BulkVp_Total_Ind_RES_RHG= BulkVp_Total_Ind_RES_RHG + BulkVp_Ind_RES_RHG;
            BulkVp_Total_Ind_RES_WGG= BulkVp_Total_Ind_RES_WGG + BulkVp_Ind_RES_WGG;
            BulkVp_Total_Ind_RES_GGG= BulkVp_Total_Ind_RES_GGG + BulkVp_Ind_RES_GGG;
        end
        
        if isfield(Particles.Clastics_particle(i).pos.Fluid, 'Super_RES')
            BulkRho_RES= BulkRho_RES + BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_RES_RHG + BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_RES_WGG + BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_RES_GGG + BulkVp_Total_Ind_RES_GGG;
        else
            BulkRho_RES= BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_Total_Ind_RES_GGG;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% OB
    if isfield(Particles.Clastics_particle(i).pos.Matrix, 'OB')
        MaRho= Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Particles.Clastics_particle(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Clastics_particle.pos.Fluid.OB.Values{1, 1};
        BRVp= Clastics_particle.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_OB= TempRho .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_OB_RHG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_OB_WGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_OB_GGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        if ~strcmp(Particles.Clastics_particle(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Particles.Clastics_particle(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_RHG).^2 +  0.76969.*(BulkVp_OB_RHG) - 0.86735;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_RHG=  BulkVp_OB_RHG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_RHG.^2 - 4/3 .* BulkVs_OB_RHG.^2);
            g = BulkRho_OB.* BulkVs_OB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Clastics_particle.pos.Fluid.OB.Values{2, 1};
            k_hyc= Clastics_particle.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Particles.Clastics_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Particles.Clastics_particle(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_OB= rho_sat .* MODEL.OB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkRho_OB(~coor)= 0;
            BulkRho_OB= double(BulkRho_OB);
            BulkRho_OB= real(BulkRho_OB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_RHG(~coor)= 0;
            BulkVp_OB_RHG= double(BulkVp_OB_RHG);
            BulkVp_OB_RHG= real(BulkVp_OB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_WGG).^2 +  0.76969.*(BulkVp_OB_WGG) - 0.86735;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_WGG=  BulkVp_OB_WGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_WGG.^2 - 4/3 .* BulkVs_OB_WGG.^2);
            g = BulkRho_OB.* BulkVs_OB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_WGG(~coor)= 0;
            BulkVp_OB_WGG= double(BulkVp_OB_WGG);
            BulkVp_OB_WGG= real(BulkVp_OB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_GGG).^2 +  0.76969.*(BulkVp_OB_GGG) - 0.86735;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_GGG=  BulkVp_OB_GGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_GGG.^2 - 4/3 .* BulkVs_OB_GGG.^2);
            g = BulkRho_OB.* BulkVs_OB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_GGG(~coor)= 0;
            BulkVp_OB_GGG= double(BulkVp_OB_GGG);
            BulkVp_OB_GGG= real(BulkVp_OB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% UB
    if isfield(Particles.Clastics_particle(i).pos.Matrix, 'UB')
        MaRho= Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Particles.Clastics_particle(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Clastics_particle.pos.Fluid.UB.Values{1, 1};
        BRVp= Clastics_particle.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_UB= TempRho .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_UB_RHG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_UB_WGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_UB_GGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        if ~strcmp(Particles.Clastics_particle(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Particles.Clastics_particle(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_RHG).^2 +  0.76969.*(BulkVp_UB_RHG) - 0.86735;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_RHG= BulkVp_UB_RHG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_RHG.^2 - 4/3 .* BulkVs_UB_RHG.^2);
            g = BulkRho_UB.* BulkVs_UB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Clastics_particle.pos.Fluid.UB.Values{2, 1};
            k_hyc= Clastics_particle.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Particles.Clastics_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Particles.Clastics_particle(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_UB= rho_sat .* MODEL.UB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkRho_UB(~coor)= 0;
            BulkRho_UB= double(BulkRho_UB);
            BulkRho_UB= real(BulkRho_UB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_RHG(~coor)= 0;
            BulkVp_UB_RHG= double(BulkVp_UB_RHG);
            BulkVp_UB_RHG= real(BulkVp_UB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_WGG).^2 +  0.76969.*(BulkVp_UB_WGG) - 0.86735;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_WGG= BulkVp_UB_WGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_WGG.^2 - 4/3 .* BulkVs_UB_WGG.^2);
            g = BulkRho_UB.* BulkVs_UB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_WGG(~coor)= 0;
            BulkVp_UB_WGG= double(BulkVp_UB_WGG);
            BulkVp_UB_WGG= real(BulkVp_UB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Clastics_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_GGG).^2 +  0.76969.*(BulkVp_UB_GGG) - 0.86735;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_GGG= BulkVp_UB_GGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_GGG.^2 - 4/3 .* BulkVs_UB_GGG.^2);
            g = BulkRho_UB.* BulkVs_UB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_GGG(~coor)= 0;
            BulkVp_UB_GGG= double(BulkVp_UB_GGG);
            BulkVp_UB_GGG= real(BulkVp_UB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%% Gather Bulk Rho, Bulk Vp Matrices
    if isfield(Particles.Clastics_particle(i).pos.Matrix, 'OB') && isfield(Particles.Clastics_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Particles.Clastics_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Clastics_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Particles.Clastics_particle(i).pos.Matrix, 'OB') && isfield(Particles.Clastics_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Particles.Clastics_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Clastics_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%% Create AI matrix %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% RHG %%%%
    AI_Matrix_1_RHG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_RHG;
    AI_Matrix_2_RHG= AI_Matrix_1_RHG;
    AI_Matrix_1_RHG(end, :)= [];
    AI_Matrix_2_RHG(1, :)= [];
    
    %%%%% WGG %%%%
    AI_Matrix_1_WGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_WGG;
    AI_Matrix_2_WGG= AI_Matrix_1_WGG;
    AI_Matrix_1_WGG(end, :)= [];
    AI_Matrix_2_WGG(1, :)= [];
    
    %%%%% GGG %%%%
    AI_Matrix_1_GGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_GGG;
    AI_Matrix_2_GGG= AI_Matrix_1_GGG;
    AI_Matrix_1_GGG(end, :)= [];
    AI_Matrix_2_GGG(1, :)= [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Creating RCs %%%%%%%%%%%%%%%%%%%%%%%%%
    Z1_RHG= AI_Matrix_1_RHG;
    Z2_RHG= AI_Matrix_2_RHG;
    RC_Matrix_RHG= (Z2_RHG-Z1_RHG)./(Z2_RHG+Z1_RHG);
    
    Z1_WGG= AI_Matrix_1_WGG;
    Z2_WGG= AI_Matrix_2_WGG;
    RC_Matrix_WGG= (Z2_WGG-Z1_WGG)./(Z2_WGG+Z1_WGG);
    
    Z1_GGG= AI_Matrix_1_GGG;
    Z2_GGG= AI_Matrix_2_GGG;
    RC_Matrix_GGG= (Z2_GGG-Z1_GGG)./(Z2_GGG+Z1_GGG);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Wavelet %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Sampling_Interval= str2double(handles.Sampling_Interval.String)/1000;    % Sampling Interval in Sec
    NumberOfSamples= 10/Sampling_Interval;
    NumberOfSamples= round(NumberOfSamples,0);
    if mod(NumberOfSamples, 2)==0
        NumberOfSamples= NumberOfSamples+1;
    end
    Frequency= Particles.Clastics_particle(i).Frequency.Value;
    t0= 0;   %% Peak must be in the middle to make the wavelet symmetric
    [rw, ~] = Edited_ricker(Frequency, NumberOfSamples, Sampling_Interval, t0);
    
    Wavelet= Polarity.*rw;
    
    %%%%%%%%%%%%%%%%% Convolution %%%%%%%%%%%%%%%%%%%%%%
    %%% RHG
    Synthetic_RHG= conv2(Wavelet, 1,RC_Matrix_RHG);
    S1= size(Synthetic_RHG, 1);
    S2= size(RC_Matrix_RHG, 1);
    dif= (S1 - S2)/2;
    Synthetic_RHG(1:dif, :)= [];
    Synthetic_RHG(S2+1:end, :)= [];
    Synthetic_RHG = Synthetic_RHG .* Data.Horizons_grid_remove;
    
    %%% WGG
    Synthetic_WGG= conv2(Wavelet, 1,RC_Matrix_WGG);
    S1= size(Synthetic_WGG, 1);
    S2= size(RC_Matrix_WGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_WGG(1:dif, :)= [];
    Synthetic_WGG(S2+1:end, :)= [];
    Synthetic_WGG = Synthetic_WGG .* Data.Horizons_grid_remove;
    
    %%% GGG
    Synthetic_GGG= conv2(Wavelet, 1,RC_Matrix_GGG);
    S1= size(Synthetic_GGG, 1);
    S2= size(RC_Matrix_GGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_GGG(1:dif, :)= [];
    Synthetic_GGG(S2+1:end, :)= [];
    Synthetic_GGG = Synthetic_GGG .* Data.Horizons_grid_remove;
    
    %%%%%%%%%%%%%%%%% Scaling %%%%%%%%%%%%%%%%%%%%%%
    % Scaling, by making the max value(absolute)in Synth= max Seismic
    
    %%% RHG
    SynthAmp_Max_RHG= max(abs(Synthetic_RHG(:)));
    Synthetic_RHG= Synthetic_RHG.* SeisAmp_Max/SynthAmp_Max_RHG;
    
    Synthetic_RHG(isnan(Synthetic_RHG))= 999;
    
    %%% WGG
    SynthAmp_Max_WGG= max(abs(Synthetic_WGG(:)));
    Synthetic_WGG= Synthetic_WGG.* SeisAmp_Max/SynthAmp_Max_WGG;
    
    Synthetic_WGG(isnan(Synthetic_WGG))= 999;
    
    %%% GGG
    SynthAmp_Max_GGG= max(abs(Synthetic_GGG(:)));
    Synthetic_GGG= Synthetic_GGG.* SeisAmp_Max/SynthAmp_Max_GGG;
    
    Synthetic_GGG(isnan(Synthetic_GGG))= 999;
    
    %% Evaluating of Synthetic Section %%%%%%%%%%%%%%%%%%%
    % in this process we will use Normalized Root Mean Square Error(NRMSE) to
    % determine the misfit between Seismic section and synthetic section
    % note that the normalization used in this NRMSE is the classical one,
    % which means NRMSE= RMSE/max(Observed)-min(Observed); so the root
    % mean sqaure error is divided by the range of observed data in order
    % to express NRMSE in percentage terms.
    % there are other ways to normalize RMSE like the HH-RMSE in which the
    % RMSE is divided by the product of Observed data with estimated data
    % and it is given as follows:
    % HH= sum((Obs - Est).^2)/sum(Obs .* Est);
    % there are different normalization methods you can use.
    
    %%% Calculation
    
    
    
    
    %%% RHG
    RHG_Cost= NRMSE(Synthetic_RHG);
    final= RHG_Cost;
    type= 1;   % which means RHG
    Synthetic= Synthetic_RHG;
    Velocity_Model= BulkVp_Total_Matrix_RHG;
    
    %%% WGG
    WGG_Cost= NRMSE(Synthetic_WGG);
    if final > WGG_Cost
        final= WGG_Cost;
        type= 2;   % which means WGG
        Synthetic= Synthetic_WGG;
        Velocity_Model= BulkVp_Total_Matrix_WGG;
    end
    
    %%% GGG
    GGG_Cost= NRMSE(Synthetic_GGG);
    if final > GGG_Cost
        final= GGG_Cost;
        type= 3;   % which means GGG
        Synthetic= Synthetic_GGG;
        Velocity_Model= BulkVp_Total_Matrix_GGG;
    end
    
    Particles.Clastics_particle(i).final_cost= final;
    Particles.Clastics_particle(i).VpEq= type;  % velocity formula with least misfit
    Particles.Clastics_particle(i).Scenario= 2;   % 2 means Clastics
    Particles.Clastics_particle(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Particles.Clastics_particle(i).Velocity_Model= Velocity_Model;
    Particles.Clastics_particle(i).Synthetic= Synthetic;
    Particles.Clastics_particle(i).iteration= iteration;
end



if ~isempty(Basalt_Scenario_Num)      % if there is Basalt Scenario then do the following
    %% Frequency Position %%%
    Particles.Basalt_particle(i).Frequency.Velocity= W*Particles.Basalt_particle(i).Frequency.Velocity...
        +C1*rand(1, 1).*(bParticles.Basalt(i).Frequency.Value - Particles.Basalt_particle(i).Frequency.Value)...
        +C2*rand(1, 1).*(gparticle.Scenarios(Bas_Num).Frequency.Value - Particles.Basalt_particle(i).Frequency.Value);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    %%% Check whether the previous position is at either bound
    BasFreq= Particles.Basalt_particle(i).Frequency.Value;
    FalUp= BasFreq>= ub;
    FalDown= BasFreq<= lb;
    
    %%% new name = previous name + name Velocity
    BasFreq= BasFreq + Particles.Basalt_particle(i).Frequency.Velocity;
    CrossUp= BasFreq >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        BasFreq= ub;
    end
    reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
    if reflectUp
        BasFreq= ub - rand.*(ub - lb); % randomely choose values for them
    end
    
    CrossDown= BasFreq <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        BasFreq= lb;
    end
    reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
    if reflectDown
        BasFreq= lb + rand.*(ub - lb); % randomely choose values for them
    end
    
    %%% the new Position
    Particles.Basalt_particle(i).Frequency.Value= BasFreq;
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'RES')   % RES Matrix is Basalt
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Matrix.RES.Values_Velocity= W*Particles.Basalt_particle(i).pos.Matrix.RES.Values_Velocity...
            +C1*rand(1, 3).*(bParticles.Basalt(i).pos.Matrix.RES.Values - Particles.Basalt_particle(i).pos.Matrix.RES.Values)...
            +C2*rand(1, 3).*(gparticle.Scenarios(Bas_Num).pos.Matrix.RES.Values - Particles.Basalt_particle(i).pos.Matrix.RES.Values);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        RESmatValues= Particles.Basalt_particle(i).pos.Matrix.RES.Values;
        FalUp= RESmatValues>= ub;
        FalDown= RESmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        RESmatValues= RESmatValues + Particles.Basalt_particle(i).pos.Matrix.RES.Values_Velocity;
        CrossUp= RESmatValues >= ub;   % get the coordinates of Crossing Up elements
        RESmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        RESmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= RESmatValues <= lb;   % get the coordinates Crossing Down elements
        RESmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        RESmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(RES Matrix Name)
        Particles.Basalt_particle(i).pos.Matrix.RES.Values= RESmatValues;
        
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Matrix.OB.name_Velocity= W*Particles.Basalt_particle(i).pos.Matrix.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.Matrix.OB.name_number - Particles.Basalt_particle(i).pos.Matrix.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Matrix.OB.name_number - Particles.Basalt_particle(i).pos.Matrix.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxOBMatNumber= length(ModelBounds.Basalt_Scenario.Matrix.OB);
        
        %%% Check whether the previous position is at either bound
        OBMat= Particles.Basalt_particle(i).pos.Matrix.OB.name_number;
        FalUp= OBMat>= MaxOBMatNumber;
        FalDown= OBMat<= 1;
        
        %%% new name = previous name + name Velocity
        OBMat= OBMat + Particles.Basalt_particle(i).pos.Matrix.OB.name_Velocity;
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OBMat= MaxOBMatNumber - rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OBMat= 1 + rand.*(MaxOBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Matrix Name)
        OBMat= round(OBMat);
        Particles.Basalt_particle(i).pos.Matrix.OB.name_number= OBMat;  % Matrix Number
        Particles.Basalt_particle(i).pos.Matrix.OB.name= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= W*Particles.Basalt_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +C1*rand(1, 3).*(bParticles.Basalt(i).pos.Matrix.OB.Values(OBMat, :) - Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Bas_Num).pos.Matrix.OB.Values(OBMat, :) - Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        OBmatValues= Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, :);
        FalUp= OBmatValues>= ub;
        FalDown= OBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        OBmatValues= OBmatValues + Particles.Basalt_particle(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        OBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        OBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(OB Matrix Name)
        Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Matrix.UB.name_Velocity= W*Particles.Basalt_particle(i).pos.Matrix.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.Matrix.UB.name_number - Particles.Basalt_particle(i).pos.Matrix.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Matrix.UB.name_number - Particles.Basalt_particle(i).pos.Matrix.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MaxUBMatNumber= length(ModelBounds.Basalt_Scenario.Matrix.UB);
        
        %%% Check whether the previous position is at either bound
        UBMat= Particles.Basalt_particle(i).pos.Matrix.UB.name_number;
        FalUp= UBMat>= MaxUBMatNumber;
        FalDown= UBMat<= 1;
        
        %%% new name = previous name + name Velocity
        UBMat= UBMat + Particles.Basalt_particle(i).pos.Matrix.UB.name_Velocity;
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UBMat= MaxUBMatNumber - rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UBMat= 1 + rand.*(MaxUBMatNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Matrix Name)
        UBMat= round(UBMat);
        Particles.Basalt_particle(i).pos.Matrix.UB.name_number= UBMat;  % Matrix Number
        Particles.Basalt_particle(i).pos.Matrix.UB.name= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= W*Particles.Basalt_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +C1*rand(1, 3).*(bParticles.Basalt(i).pos.Matrix.UB.Values(UBMat, :) - Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, :))...
            +C2*rand(1, 3).*(gparticle.Scenarios(Bas_Num).pos.Matrix.UB.Values(UBMat, :) - Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, :));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%% Check whether the previous position is at either bound
        UBmatValues= Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, :);
        FalUp= UBmatValues>= ub;
        FalDown= UBmatValues<= lb;
        
        %%% new name = previous name + name Velocity
        UBmatValues= UBmatValues + Particles.Basalt_particle(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        UBmatValues(reflectUp)= ub(reflectUp) - rand.*(ub(reflectUp) - lb(reflectUp)); % randomely choose values for them
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        UBmatValues(reflectDown)= lb(reflectDown) + rand.*(ub(reflectDown) - lb(reflectDown)); % randomely choose values for them
        
        %%% the new Position(UB Matrix Name)
        Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Super_RES')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_Velocity= W*Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_Velocity...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.Fluid.Super_RES.name_number - Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Fluid.Super_RES.name_number - Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_Super_RES_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.Super_RES);
        
        %%% Check whether the previous position is at either bound
        Super_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number;
        FalUp= Super_RES_Fluid>= Max_Super_RES_FluidNumber;
        FalDown= Super_RES_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        Super_RES_Fluid= Super_RES_Fluid + Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_Velocity;
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            Super_RES_Fluid= Max_Super_RES_FluidNumber - rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            Super_RES_Fluid= 1 + rand.*(Max_Super_RES_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt_particle.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            %%% Choose name Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= W*Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Max_Ind_RES_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            %%% Check whether the previous position is at either bound
            Ind_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;
            FalUp= Ind_RES_Fluid>= Max_Ind_RES_FluidNumber;
            FalDown= Ind_RES_Fluid<= 1;
            
            %%% new name = previous name + name Velocity
            Ind_RES_Fluid= Ind_RES_Fluid + Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber - rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
            if reflectDown
                Ind_RES_Fluid= 1 + rand.*(Max_Ind_RES_FluidNumber - 1); % randomely choose values for them
            end
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'OB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Fluid.OB.name_Velocity= W*Particles.Basalt_particle(i).pos.Fluid.OB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.Fluid.OB.name_number - Particles.Basalt_particle(i).pos.Fluid.OB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Fluid.OB.name_number - Particles.Basalt_particle(i).pos.Fluid.OB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_OB_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.OB);
        
        %%% Check whether the previous position is at either bound
        OB_Fluid= Particles.Basalt_particle(i).pos.Fluid.OB.name_number;
        FalUp= OB_Fluid>= Max_OB_FluidNumber;
        FalDown= OB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        OB_Fluid= OB_Fluid + Particles.Basalt_particle(i).pos.Fluid.OB.name_Velocity;
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            OB_Fluid= Max_OB_FluidNumber - rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            OB_Fluid= 1 + rand.*(Max_OB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Particles.Basalt_particle(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Particles.Basalt_particle(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt_particle.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt_particle.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'UB')
        %%% Choose name Velocity %%%%%%%%%%
        Particles.Basalt_particle(i).pos.Fluid.UB.name_Velocity= W*Particles.Basalt_particle(i).pos.Fluid.UB.name_Velocity...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.Fluid.UB.name_number - Particles.Basalt_particle(i).pos.Fluid.UB.name_number)...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.Fluid.UB.name_number - Particles.Basalt_particle(i).pos.Fluid.UB.name_number);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Max_UB_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.UB);
        
        %%% Check whether the previous position is at either bound
        UB_Fluid= Particles.Basalt_particle(i).pos.Fluid.UB.name_number;
        FalUp= UB_Fluid>= Max_UB_FluidNumber;
        FalDown= UB_Fluid<= 1;
        
        %%% new name = previous name + name Velocity
        UB_Fluid= UB_Fluid + Particles.Basalt_particle(i).pos.Fluid.UB.name_Velocity;
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
        if reflectUp
            UB_Fluid= Max_UB_FluidNumber - rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and they were already equal to the bounds
        if reflectDown
            UB_Fluid= 1 + rand.*(Max_UB_FluidNumber - 1); % randomely choose values for them
        end
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Particles.Basalt_particle(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name;
        Particles.Basalt_particle(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt_particle.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt_particle.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Super_RES')
        Super_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        Particles.Basalt_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= W*Particles.Basalt_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Basalt_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid) - Particles.Basalt_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        Super_RES_SW= Particles.Basalt_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);
        FalUp= Super_RES_SW>= ub;
        FalDown= Super_RES_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        Super_RES_SW= Super_RES_SW + Particles.Basalt_particle(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            Super_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            Super_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Basalt_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= W*Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
            lb= ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
            
            %%% Check whether the previous position is at either bound
            Ind_RES_SW= Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);
            FalUp= Ind_RES_SW>= ub;
            FalDown= Ind_RES_SW<= lb;
            
            %%% new Pos = previous Pos + Pos Velocity
            Ind_RES_SW= Ind_RES_SW + Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
            if reflectUp
                Ind_RES_SW= ub - rand.*(ub - lb); % randomely choose values for them
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
            if reflectDown
                Ind_RES_SW= lb + rand.*(ub - lb); % randomely choose values for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'OB')
        OB_Fluid= Particles.Basalt_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
        Particles.Basalt_particle(i).pos.SW.OB.Velocity(OB_Fluid)= W*Particles.Basalt_particle(i).pos.SW.OB.Velocity(OB_Fluid)...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.SW.OB.Value(OB_Fluid) - Particles.Basalt_particle(i).pos.SW.OB.Value(OB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.SW.OB.Value(OB_Fluid) - Particles.Basalt_particle(i).pos.SW.OB.Value(OB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        OB_SW= Particles.Basalt_particle(i).pos.SW.OB.Value(OB_Fluid);
        FalUp= OB_SW>= ub;
        FalDown= OB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        OB_SW= OB_SW + Particles.Basalt_particle(i).pos.SW.OB.Velocity(OB_Fluid);
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            OB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            OB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Basalt_particle(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'UB')
        UB_Fluid= Particles.Basalt_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
        Particles.Basalt_particle(i).pos.SW.UB.Velocity(UB_Fluid)= W*Particles.Basalt_particle(i).pos.SW.UB.Velocity(UB_Fluid)...
            +C1*rand(1,1).*(bParticles.Basalt(i).pos.SW.UB.Value(UB_Fluid) - Particles.Basalt_particle(i).pos.SW.UB.Value(UB_Fluid))...
            +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.SW.UB.Value(UB_Fluid) - Particles.Basalt_particle(i).pos.SW.UB.Value(UB_Fluid));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ub= ModelBounds.Basalt_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        %%% Check whether the previous position is at either bound
        UB_SW= Particles.Basalt_particle(i).pos.SW.UB.Value(UB_Fluid);
        FalUp= UB_SW>= ub;
        FalDown= UB_SW<= lb;
        
        %%% new Pos = previous Pos + Pos Velocity
        UB_SW= UB_SW + Particles.Basalt_particle(i).pos.SW.UB.Velocity(UB_Fluid);
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and the were already equal to the bounds
        if reflectUp
            UB_SW= ub - rand.*(ub - lb); % randomely choose values for them
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        reflectDown= logical(FalDown .* CrossDown); % the variables that cross the low bounds and the were already equal to the bounds
        if reflectDown
            UB_SW= lb + rand.*(ub - lb); % randomely choose values for them
        end
        
        %%% the new Position
        Particles.Basalt_particle(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 1
            %%%% Choose Values Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            POR_Value= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Porvalue;
            FalUp= POR_Value>= ub;
            FalDown= POR_Value<= lb;
            
            %%% new name = previous name + name Velocity
            POR_Value= POR_Value + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Velocity;
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                POR_Value= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                POR_Value= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            Left_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            %%% Check whether the previous position is at eiter bound
            Left_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue;
            FalUp= Left_Porvalue>= ub;
            FalDown= Left_Porvalue<= lb;
            
            %%% new name = previous name + name Left_Porvalue_Velocity
            Left_Porvalue= Left_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Left_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue;
            FalUp= Mid_Left_Porvalue>= ub;
            FalDown= Mid_Left_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Left_Porvalue_Velocity
            Mid_Left_Porvalue= Mid_Left_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Left_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Left_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
			
			
			
            %%%%% Mid_Right Porosity Value %%%%%
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Mid_Right_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue;
            FalUp= Mid_Right_Porvalue>= ub;
            FalDown= Mid_Right_Porvalue<= lb;
            
            %%% new name = previous name + name Mid_Right_Porvalue_Velocity
            Mid_Right_Porvalue= Mid_Right_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Mid_Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Mid_Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;			
            
            %%%%% Right Porosity Value %%%%%
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= W*Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +C1*rand(1,1).*(bParticles.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue)...
                +C2*rand(1,1).*(gparticle.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue - Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            %%% Check whether the previous position is at eiter bound
            Right_Porvalue= Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue;
            FalUp= Right_Porvalue>= ub;
            FalDown= Right_Porvalue<= lb;
            
            %%% new name = previous name + name Right_Porvalue_Velocity
            Right_Porvalue= Right_Porvalue + Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            reflectUp= logical(FalUp .* CrossUp);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectUp
                Right_Porvalue= ub - rand.*(ub - lb); % randomely choose value for them
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            reflectDown= logical(FalDown .* CrossDown);   % the variables that cross the high bounds and they were already equal to the bounds
            if reflectDown
                Right_Porvalue= lb + rand.*(ub - lb); % randomely choose value for them
            end
            
            %%% the new Position
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
    end
    
    % % here we save the final Porosity matrix, Make it Comment with large size Data, Make it Comment with large size Data
    Particles.Basalt_particle(i).pos.POR.FullMatrix= Phi;
    %%% at this stage we finish picking values for MODEL initialization
    %% Rho and Vp for saturated rock
    % We want to calculate Bulk Rho, Bulk Vp for Super_RES, Ind_RES, OB, UB
    % with Brine as saturation fluid, then if the chosen fluid is not
    % Brine we do Gassman's substitutions
    % Note: BulkRho= MaRho(1-Phi) + FlRho*Phi   The Volumetric average equation
    
    % BulkVp = There are three empirical folrmulaions to calculate Bulk Vp
    % 1- RHG Formula: Bulk_Vp= ((1-Phi).^2 * Vp_Matrix) + (Phi * Brine_Vp)
    % 2- WGG Formula: Bulk_Vp= 1./(((1-Phi)./Vp_Matrix)+(Phi./Brine_Vp))
    % 3- GGG Formula: Bulk_Vp= 0.3048.*(BulkRho/0.23)
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Super_RES
    MaRho= Particles.Basalt_particle(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Particles.Basalt_particle(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Particles.Basalt_particle(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Particles.Basalt_particle(i).pos.Fluid, 'Super_RES')
        BRRho= Basalt_particle.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Basalt_particle.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);  % in g/cc
        BulkRho_Super_RES= TempRho .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_Super_RES_RHG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_Super_RES_WGG= TempVp .* MODEL.Super_RES.Matrix;  % extract Super_RES coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_Super_RES_GGG= TempVp .* MODEL.Super_RES.Matrix ;  % extract Super_RES coordinates
        
        if ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Super_RES.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
            tempVs= BulkVp_Super_RES_RHG ./ 1.7; % in Km/s
            BulkVs_Super_RES_RHG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_RHG.^2 - 4/3 .* BulkVs_Super_RES_RHG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Basalt_particle.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Basalt_particle.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Particles.Basalt_particle(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_Super_RES= rho_sat .* MODEL.Super_RES.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkRho_Super_RES(~coor)= 0;
            BulkRho_Super_RES= double(BulkRho_Super_RES);
            BulkRho_Super_RES= real(BulkRho_Super_RES);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_RHG(~coor)= 0;
            BulkVp_Super_RES_RHG= double(BulkVp_Super_RES_RHG);
            BulkVp_Super_RES_RHG= real(BulkVp_Super_RES_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
            tempVs= 0*(BulkVp_Super_RES_WGG).^2 + 0.58321.*(BulkVp_Super_RES_WGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_WGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_WGG.^2 - 4/3 .* BulkVs_Super_RES_WGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_WGG(~coor)= 0;
            BulkVp_Super_RES_WGG= double(BulkVp_Super_RES_WGG);
            BulkVp_Super_RES_WGG= real(BulkVp_Super_RES_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
            tempVs= 0*(BulkVp_Super_RES_GGG).^2 + 0.58321.*(BulkVp_Super_RES_GGG) - 0.07775; % in Km/s
            BulkVs_Super_RES_GGG= tempVs .* MODEL.Super_RES.Matrix;       % in km/s
            
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_Super_RES.*(BulkVp_Super_RES_GGG.^2 - 4/3 .* BulkVs_Super_RES_GGG.^2);
            g = BulkRho_Super_RES.* BulkVs_Super_RES_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_Super_RES_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.Super_RES.Matrix);
            BulkVp_Super_RES_GGG(~coor)= 0;
            BulkVp_Super_RES_GGG= double(BulkVp_Super_RES_GGG);
            BulkVp_Super_RES_GGG= real(BulkVp_Super_RES_GGG);
            
        end
        %%% end of gassmans substitution
        
        BulkRho_RES= BulkRho_Super_RES;
        BulkVp_RES_RHG= BulkVp_Super_RES_RHG;
        BulkVp_RES_WGG= BulkVp_Super_RES_WGG;
        BulkVp_RES_GGG= BulkVp_Super_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Ind_RES Fluids
    if isfield(Particles.Basalt_particle(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Particles.Basalt_particle(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
            TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
            BulkRho_Ind_RES= TempRho.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % RHG Formula
            TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
            BulkVp_Ind_RES_RHG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % WGG Formula
            TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
            BulkVp_Ind_RES_WGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            % GGG Formula
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: ft/s = 0.0003048 * km/s
            BulkVp_Ind_RES_GGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            if ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
                %% Start of gassmans substitution
                %%%%%%%%%%%%%%%% RHG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_RHG).^2 + 0.58321.*(BulkVp_Ind_RES_RHG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_RHG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_RHG.^2 - 4/3 .* BulkVs_Ind_RES_RHG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_RHG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                rho_hyc= Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Basalt_particle.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
                tsh= 1 - tsw;     % Hydrocarbon Saturation
                k_fl = 1./(tsw./k_brine + tsh./k_hyc);
                rho_fl = tsw.*BRRho + tsh.*rho_hyc;
                rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
                
                %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
                BulkRho_Ind_RES= rho_sat .* MODEL.(genvarname(ind_Entities{iter})).Matrix;    % The Bulk Density after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkRho_Ind_RES(~coor)= 0;
                BulkRho_Ind_RES= double(BulkRho_Ind_RES);
                BulkRho_Ind_RES= real(BulkRho_Ind_RES);
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_RHG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_RHG(~coor)= 0;
                BulkVp_Ind_RES_RHG= double(BulkVp_Ind_RES_RHG);
                BulkVp_Ind_RES_RHG= real(BulkVp_Ind_RES_RHG);
                
                %%%%%%%%%%%%%%%% WGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_WGG).^2 + 0.58321.*(BulkVp_Ind_RES_WGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_WGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_WGG.^2 - 4/3 .* BulkVs_Ind_RES_WGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_WGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_WGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_WGG(~coor)= 0;
                BulkVp_Ind_RES_WGG= double(BulkVp_Ind_RES_WGG);
                BulkVp_Ind_RES_WGG= real(BulkVp_Ind_RES_WGG);
                
                %%%%%%%%%%%%%%%% GGG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
                tempVs= 0*(BulkVp_Ind_RES_GGG).^2 + 0.58321.*(BulkVp_Ind_RES_GGG) - 0.07775;  % in Km/m
                BulkVs_Ind_RES_GGG= tempVs .* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % in m/s
                
                k_matrix= K_Modulus; % bulk modulus in (GPa);
                
                % initial Fluid Properties
                k_brine= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K;
                k_fl= k_brine;
                % initial Saturated Rock Properties
                k_sat= BulkRho_Ind_RES.*(BulkVp_Ind_RES_GGG.^2 - 4/3 .* BulkVs_Ind_RES_GGG.^2);
                g = BulkRho_Ind_RES.* BulkVs_Ind_RES_GGG.^2;     % GPa (held constant)
                
                % Porous frame Properties
                k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
                k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
                k_frame = (k1./k2); % GPa (held constant)
                k_frame(isnan(k_frame))= 999;
                
                % Output Fluid Moduli
                % it has been already calculated from RHG
                
                % Output Bulk Density
                % it has been already calculated from RHG
                
                %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
                k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
                k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
                
                
                %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
                vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
                
                BulkVp_Ind_RES_GGG= vp_sat;  % The Bulk Vp after substitution
                coor= logical(MODEL.(genvarname(ind_Entities{iter})).Matrix);
                BulkVp_Ind_RES_GGG(~coor)= 0;
                BulkVp_Ind_RES_GGG= double(BulkVp_Ind_RES_GGG);
                BulkVp_Ind_RES_GGG= real(BulkVp_Ind_RES_GGG);
                
            end
            %%% end of gassmans substitution
            BulkRho_Total_Ind_RES= BulkRho_Total_Ind_RES + BulkRho_Ind_RES;
            
            BulkVp_Total_Ind_RES_RHG= BulkVp_Total_Ind_RES_RHG + BulkVp_Ind_RES_RHG;
            BulkVp_Total_Ind_RES_WGG= BulkVp_Total_Ind_RES_WGG + BulkVp_Ind_RES_WGG;
            BulkVp_Total_Ind_RES_GGG= BulkVp_Total_Ind_RES_GGG + BulkVp_Ind_RES_GGG;
        end
        
        if isfield(Particles.Basalt_particle(i).pos.Fluid, 'Super_RES')
            BulkRho_RES= BulkRho_RES + BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_RES_RHG + BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_RES_WGG + BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_RES_GGG + BulkVp_Total_Ind_RES_GGG;
        else
            BulkRho_RES= BulkRho_Total_Ind_RES;
            BulkVp_RES_RHG= BulkVp_Total_Ind_RES_RHG;
            BulkVp_RES_WGG= BulkVp_Total_Ind_RES_WGG;
            BulkVp_RES_GGG= BulkVp_Total_Ind_RES_GGG;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% OB
    if isfield(Particles.Basalt_particle(i).pos.Matrix, 'OB')
        MaRho= Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Particles.Basalt_particle(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Basalt_particle.pos.Fluid.OB.Values{1, 1};
        BRVp= Basalt_particle.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_OB= TempRho .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_OB_RHG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_OB_WGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_OB_GGG= TempVp .* MODEL.OB.Matrix;  % extract OB coordinates
        
        if ~strcmp(Particles.Basalt_particle(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Particles.Basalt_particle(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_RHG).^2 +  0.76969.*(BulkVp_OB_RHG) - 0.86735;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_RHG=  BulkVp_OB_RHG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_RHG.^2 - 4/3 .* BulkVs_OB_RHG.^2);
            g = BulkRho_OB.* BulkVs_OB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Basalt_particle.pos.Fluid.OB.Values{2, 1};
            k_hyc= Basalt_particle.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Particles.Basalt_particle(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Particles.Basalt_particle(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_OB= rho_sat .* MODEL.OB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkRho_OB(~coor)= 0;
            BulkRho_OB= double(BulkRho_OB);
            BulkRho_OB= real(BulkRho_OB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_RHG(~coor)= 0;
            BulkVp_OB_RHG= double(BulkVp_OB_RHG);
            BulkVp_OB_RHG= real(BulkVp_OB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_WGG).^2 +  0.76969.*(BulkVp_OB_WGG) - 0.86735;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_WGG=  BulkVp_OB_WGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_WGG.^2 - 4/3 .* BulkVs_OB_WGG.^2);
            g = BulkRho_OB.* BulkVs_OB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_WGG(~coor)= 0;
            BulkVp_OB_WGG= double(BulkVp_OB_WGG);
            BulkVp_OB_WGG= real(BulkVp_OB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.OB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_OB_GGG).^2 +  0.76969.*(BulkVp_OB_GGG) - 0.86735;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % ink m/s
            else
                BulkVs_OB_GGG=  BulkVp_OB_GGG ./ 1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.OB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_OB.*(BulkVp_OB_GGG.^2 - 4/3 .* BulkVs_OB_GGG.^2);
            g = BulkRho_OB.* BulkVs_OB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_OB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.OB.Matrix);
            BulkVp_OB_GGG(~coor)= 0;
            BulkVp_OB_GGG= double(BulkVp_OB_GGG);
            BulkVp_OB_GGG= real(BulkVp_OB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%% UB
    if isfield(Particles.Basalt_particle(i).pos.Matrix, 'UB')
        MaRho= Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Particles.Basalt_particle(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Basalt_particle.pos.Fluid.UB.Values{1, 1};
        BRVp= Basalt_particle.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
        TempRho= (MaRho .* (1 - Phi)) + (BRRho .* Phi);
        BulkRho_UB= TempRho .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % RHG Formula
        TempVp= (MaVp .* (1 - Phi).^2) + (BRVp .* Phi);
        BulkVp_UB_RHG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % WGG Formula
        TempVp= 1./(((1-Phi)./MaVp)+(Phi./BRVp));
        BulkVp_UB_WGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        % GGG Formula
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: ft/s = 0.0003048 * km/s
        BulkVp_UB_GGG= TempVp .* MODEL.UB.Matrix;  % extract UB coordinates
        
        if ~strcmp(Particles.Basalt_particle(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Particles.Basalt_particle(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_RHG).^2 +  0.76969.*(BulkVp_UB_RHG) - 0.86735;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_RHG= BulkVp_UB_RHG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_RHG.^2 - 4/3 .* BulkVs_UB_RHG.^2);
            g = BulkRho_UB.* BulkVs_UB_RHG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            rho_hyc= Basalt_particle.pos.Fluid.UB.Values{2, 1};
            k_hyc= Basalt_particle.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Particles.Basalt_particle(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Particles.Basalt_particle(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
            tsh= 1 - tsw;     % Hydrocarbon Saturation
            k_fl = 1./(tsw./k_brine + tsh./k_hyc);
            rho_fl = tsw.*BRRho + tsh.*rho_hyc;
            rho_sat = Phi.*rho_fl+(1-Phi).*MaRho; % gm/cc
            
            %%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%
            BulkRho_UB= rho_sat .* MODEL.UB.Matrix;    % The Bulk Density after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkRho_UB(~coor)= 0;
            BulkRho_UB= double(BulkRho_UB);
            BulkRho_UB= real(BulkRho_UB);
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_RHG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_RHG(~coor)= 0;
            BulkVp_UB_RHG= double(BulkVp_UB_RHG);
            BulkVp_UB_RHG= real(BulkVp_UB_RHG);
            
            %%%%%%%%%%%%%%%% WGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_WGG).^2 +  0.76969.*(BulkVp_UB_WGG) - 0.86735;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_WGG= BulkVp_UB_WGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_WGG.^2 - 4/3 .* BulkVs_UB_WGG.^2);
            g = BulkRho_UB.* BulkVs_UB_WGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_WGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_WGG(~coor)= 0;
            BulkVp_UB_WGG= double(BulkVp_UB_WGG);
            BulkVp_UB_WGG= real(BulkVp_UB_WGG);
            
            %%%%%%%%%%%%%%%% GGG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Particles.Basalt_particle(i).pos.Matrix.UB.name{1,1}, 'Shale')
                tempVs= 0*(BulkVp_UB_GGG).^2 +  0.76969.*(BulkVp_UB_GGG) - 0.86735;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            else
                BulkVs_UB_GGG= BulkVp_UB_GGG/1.7;
            end
            k_matrix= K_Modulus; % bulk modulus in (GPa);
            
            % initial Fluid Properties
            k_brine= MODEL.UB.Fluids_Properties_Matrices.Brine.K;
            k_fl= k_brine;
            % initial Saturated Rock Properties
            k_sat= BulkRho_UB.*(BulkVp_UB_GGG.^2 - 4/3 .* BulkVs_UB_GGG.^2);
            g = BulkRho_UB.* BulkVs_UB_GGG.^2;     % GPa (held constant)
            
            % Porous frame Properties
            k1 = k_sat.*(Phi.*k_matrix./k_fl+1-Phi)-k_matrix;
            k2 = Phi.*k_matrix./k_fl+k_sat./k_matrix-1-Phi;
            k_frame = (k1./k2); % GPa (held constant)
            k_frame(isnan(k_frame))= 999;
            
            % Output Fluid Moduli
            % it has been already calculated from RHG
            
            % Output Bulk Density
            % it has been already calculated from RHG
            
            %%%%%%%%%%%%%%%%% Saturated Bulk Modulus %%%%%%%%%%%%%%%%%%%%%%
            k1 = Phi./k_fl+(1-Phi)./k_matrix-k_frame  ./(k_matrix.*k_matrix);
            k_sat_new = k_frame + ((1-k_frame./k_matrix).^2)./k1;
            
            
            %%%%%%%%%%%%%%%%% p-wave Velocity of saturated rock %%%%%%%%%%%%%%%%%%%%%%
            vp_sat = sqrt((k_sat_new+g.*4/3)./rho_sat);  % km/s
            
            BulkVp_UB_GGG= vp_sat;  % The Bulk Vp after substitution
            coor= logical(MODEL.UB.Matrix);
            BulkVp_UB_GGG(~coor)= 0;
            BulkVp_UB_GGG= double(BulkVp_UB_GGG);
            BulkVp_UB_GGG= real(BulkVp_UB_GGG);
            
        end
        %%% end of gassmans substitution
        
    end
    
    %%%% Gather Bulk Rho, Bulk Vp Matrices
    if isfield(Particles.Basalt_particle(i).pos.Matrix, 'OB') && isfield(Particles.Basalt_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Particles.Basalt_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Basalt_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Particles.Basalt_particle(i).pos.Matrix, 'OB') && isfield(Particles.Basalt_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Particles.Basalt_particle(i).pos.Matrix, 'OB') && ~isfield(Particles.Basalt_particle(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%% Create AI matrix %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% RHG %%%%
    AI_Matrix_1_RHG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_RHG;
    AI_Matrix_2_RHG= AI_Matrix_1_RHG;
    AI_Matrix_1_RHG(end, :)= [];
    AI_Matrix_2_RHG(1, :)= [];
    
    %%%%% WGG %%%%
    AI_Matrix_1_WGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_WGG;
    AI_Matrix_2_WGG= AI_Matrix_1_WGG;
    AI_Matrix_1_WGG(end, :)= [];
    AI_Matrix_2_WGG(1, :)= [];
    
    %%%%% GGG %%%%
    AI_Matrix_1_GGG= BulkRho_Total_Matrix .* BulkVp_Total_Matrix_GGG;
    AI_Matrix_2_GGG= AI_Matrix_1_GGG;
    AI_Matrix_1_GGG(end, :)= [];
    AI_Matrix_2_GGG(1, :)= [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Creating RCs %%%%%%%%%%%%%%%%%%%%%%%%%
    Z1_RHG= AI_Matrix_1_RHG;
    Z2_RHG= AI_Matrix_2_RHG;
    RC_Matrix_RHG= (Z2_RHG-Z1_RHG)./(Z2_RHG+Z1_RHG);
    
    Z1_WGG= AI_Matrix_1_WGG;
    Z2_WGG= AI_Matrix_2_WGG;
    RC_Matrix_WGG= (Z2_WGG-Z1_WGG)./(Z2_WGG+Z1_WGG);
    
    Z1_GGG= AI_Matrix_1_GGG;
    Z2_GGG= AI_Matrix_2_GGG;
    RC_Matrix_GGG= (Z2_GGG-Z1_GGG)./(Z2_GGG+Z1_GGG);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Wavelet %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Sampling_Interval= str2double(handles.Sampling_Interval.String)/1000;    % Sampling Interval in Sec
    NumberOfSamples= 10/Sampling_Interval;
    NumberOfSamples= round(NumberOfSamples,0);
    if mod(NumberOfSamples, 2)==0
        NumberOfSamples= NumberOfSamples+1;
    end
    Frequency= Particles.Basalt_particle(i).Frequency.Value;
    t0= 0;   %% Peak must be in the middle to make the wavelet symmetric
    [rw, ~] = Edited_ricker(Frequency, NumberOfSamples, Sampling_Interval, t0);
    
    Wavelet= Polarity.*rw;
    
    %%%%%%%%%%%%%%%%% Convolution %%%%%%%%%%%%%%%%%%%%%%
    %%% RHG
    Synthetic_RHG= conv2(Wavelet, 1,RC_Matrix_RHG);
    S1= size(Synthetic_RHG, 1);
    S2= size(RC_Matrix_RHG, 1);
    dif= (S1 - S2)/2;
    Synthetic_RHG(1:dif, :)= [];
    Synthetic_RHG(S2+1:end, :)= [];
    Synthetic_RHG = Synthetic_RHG .* Data.Horizons_grid_remove;
    
    %%% WGG
    Synthetic_WGG= conv2(Wavelet, 1,RC_Matrix_WGG);
    S1= size(Synthetic_WGG, 1);
    S2= size(RC_Matrix_WGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_WGG(1:dif, :)= [];
    Synthetic_WGG(S2+1:end, :)= [];
    Synthetic_WGG = Synthetic_WGG .* Data.Horizons_grid_remove;
    
    %%% GGG
    Synthetic_GGG= conv2(Wavelet, 1,RC_Matrix_GGG);
    S1= size(Synthetic_GGG, 1);
    S2= size(RC_Matrix_GGG, 1);
    dif= (S1 - S2)/2;
    Synthetic_GGG(1:dif, :)= [];
    Synthetic_GGG(S2+1:end, :)= [];
    Synthetic_GGG = Synthetic_GGG .* Data.Horizons_grid_remove;
    
    %%%%%%%%%%%%%%%%% Scaling %%%%%%%%%%%%%%%%%%%%%%
    % Scaling, by making the max value(absolute)in Synth= max Seismic
    
    %%% RHG
    SynthAmp_Max_RHG= max(abs(Synthetic_RHG(:)));
    Synthetic_RHG= Synthetic_RHG.* SeisAmp_Max/SynthAmp_Max_RHG;
    
    Synthetic_RHG(isnan(Synthetic_RHG))= 999;
    
    %%% WGG
    SynthAmp_Max_WGG= max(abs(Synthetic_WGG(:)));
    Synthetic_WGG= Synthetic_WGG.* SeisAmp_Max/SynthAmp_Max_WGG;
    
    Synthetic_WGG(isnan(Synthetic_WGG))= 999;
    
    %%% GGG
    SynthAmp_Max_GGG= max(abs(Synthetic_GGG(:)));
    Synthetic_GGG= Synthetic_GGG.* SeisAmp_Max/SynthAmp_Max_GGG;
    
    Synthetic_GGG(isnan(Synthetic_GGG))= 999;
    
    %% Evaluating of Synthetic Section %%%%%%%%%%%%%%%%%%%
    % in this process we will use Normalized Root Mean Square Error(NRMSE) to
    % determine the misfit between Seismic section and synthetic section
    % note that the normalization used in this NRMSE is the classical one,
    % which means NRMSE= RMSE/max(Observed)-min(Observed); so the root
    % mean sqaure error is divided by the range of observed data in order
    % to express NRMSE in percentage terms.
    % there are other ways to normalize RMSE like the HH-RMSE in which the
    % RMSE is divided by the product of Observed data with estimated data
    % and it is given as follows:
    % HH= sum((Obs - Est).^2)/sum(Obs .* Est);
    % there are different normalization methods you can use.
    
    
    
    %%% RHG
    RHG_Cost= NRMSE(Synthetic_RHG);
    final= RHG_Cost;
    type= 1;   % which means RHG
    Synthetic= Synthetic_RHG;
    Velocity_Model= BulkVp_Total_Matrix_RHG;
    
    %%% WGG
    WGG_Cost= NRMSE(Synthetic_WGG);
    if final > WGG_Cost
        final= WGG_Cost;
        type= 2;   % which means WGG
        Synthetic= Synthetic_WGG;
        Velocity_Model= BulkVp_Total_Matrix_WGG;
    end
    
    %%% GGG

    GGG_Cost= NRMSE(Synthetic_GGG);
    if final > GGG_Cost
        final= GGG_Cost;
        type= 3;   % which means GGG
        Synthetic= Synthetic_GGG;
        Velocity_Model= BulkVp_Total_Matrix_GGG;
    end
    
    Particles.Basalt_particle(i).final_cost= final;
    Particles.Basalt_particle(i).VpEq= type;  % velocity formula with least misfit
    Particles.Basalt_particle(i).Scenario= 3;   % 3 means Basalt
    Particles.Basalt_particle(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Particles.Basalt_particle(i).Velocity_Model= Velocity_Model;
    Particles.Basalt_particle(i).Synthetic= Synthetic;
    Particles.Basalt_particle(i).iteration= iteration;
end
%% Classification
% Carbonate
if ~isempty(Car_Num)
    if Particles.Carbonate_particle(i).final_cost < bParticles.Carbonate(i).final_cost
        bParticles.Carbonate(i)= Particles.Carbonate_particle(i);
    end
end

% Clastics
if ~isempty(Clas_Num)
    if Particles.Clastics_particle(i).final_cost < bParticles.Clastics(i).final_cost
        bParticles.Clastics(i)= Particles.Clastics_particle(i);
    end
end

% Basalt
if ~isempty(Bas_Num)
    if Particles.Basalt_particle(i).final_cost < bParticles.Basalt(i).final_cost
        bParticles.Basalt(i)= Particles.Basalt_particle(i);
    end
end

%% Redo the function for NP times
if i<NP
    i= i+1;
    PSO_Particles_Variables_Modifier(handles)
end