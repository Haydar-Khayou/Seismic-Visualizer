function BAT_Variables_Modifier(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of science
%           Author: Haydar Khayou
%
%% Intro:
%   In this Function we change the variables values according the the BAT
%   algoritm and repeat the process until a certain criterium is met like a
%   certain number of iterations or when the NRMSE reaches a determined
%   value or when the velocity of one particles reaches a value, etc..

%% Variables
global Data MODEL ModelBounds NumberofEntities
global Bats bBats gBat Polarity loudness emission_rate
global NRMSE SeisAmp_Max i NP Min_Freq Max_Freq Car_Num Clas_Num Bas_Num iteration

% What number does each Scenario have?
Carbonate_Scenario_Num= ModelBounds.Carbonate_Scenario_Num;
Clastics_Scenario_Num= ModelBounds.Clastics_Scenario_Num;
Basalt_Scenario_Num= ModelBounds.Basalt_Scenario_Num;

%% Modifying Particles' positions


if ~isempty(Carbonate_Scenario_Num)      % if there is Carbonate Scenario then do the following
    Bats.Carbonate(i).loudness= loudness;
    Bats.Carbonate(i).emission_rate= emission_rate;
    
    %% Frequency Position %%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    
    Bats.Carbonate(i).Frequency.Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
    
    Bats.Carbonate(i).Frequency.Velocity= Bats.Carbonate(i).Frequency.Velocity...
        +(Bats.Carbonate(i).Frequency.Value - gBat.Scenarios(Car_Num).Frequency.Value)...
        .*Bats.Carbonate(i).Frequency.Pulse_Frequency;
    
    %%% the new Position
    Bats.Carbonate(i).Frequency.Value= Bats.Carbonate(i).Frequency.Value + Bats.Carbonate(i).Frequency.Velocity;
    
    % Check a switching condition
    if rand<emission_rate
        eps= ub-lb;
        Bats.Carbonate(i).Frequency.Value= gBat.Scenarios(Car_Num).Frequency.Value + eps.*randn*loudness;
    end
    
    % Handling Boundries
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Check whether the previous position is at either bound
    CrossUp= Bats.Carbonate(i).Frequency.Value >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Carbonate(i).Frequency.Value= ub;
    end
    
    CrossDown= Bats.Carbonate(i).Frequency.Value <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Carbonate(i).Frequency.Value= lb;
    end
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'RES')   % RES Matrix is Carbonate
        ub= ModelBounds.Carbonate_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.RES.Values_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand(1, 3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.RES.Values_Velocity= Bats.Carbonate(i).pos.Matrix.RES.Values_Velocity...
            +(Bats.Carbonate(i).pos.Matrix.RES.Values - gBat.Scenarios(Car_Num).pos.Matrix.RES.Values)...
            .*Bats.Carbonate(i).pos.Matrix.RES.Values_Pulse_Frequency;
        
        %%%% New position %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.RES.Values= Bats.Carbonate(i).pos.Matrix.RES.Values + Bats.Carbonate(i).pos.Matrix.RES.Values_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Bats.Carbonate(i).pos.Matrix.RES.Values= gBat.Scenarios(Car_Num).pos.Matrix.RES.Values + eps.*randn(1, 3)*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Bats.Carbonate(i).pos.Matrix.RES.Values >= ub;   % get the coordinates of Crossing Up elements
        Bats.Carbonate(i).pos.Matrix.RES.Values(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= Bats.Carbonate(i).pos.Matrix.RES.Values <= lb;   % get the coordinates Crossing Down elements
        Bats.Carbonate(i).pos.Matrix.RES.Values(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        MaxOBMatNumber= length(ModelBounds.Carbonate_Scenario.Matrix.OB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.OB.name_Velocity= Bats.Carbonate(i).pos.Matrix.OB.name_Velocity...
            +(Bats.Carbonate(i).pos.Matrix.OB.name_number - gBat.Scenarios(Car_Num).pos.Matrix.OB.name_number)...
            .*Bats.Carbonate(i).pos.Matrix.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OBMat= Bats.Carbonate(i).pos.Matrix.OB.name_number + Bats.Carbonate(i).pos.Matrix.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxOBMatNumber;
            OBMat= gBat.Scenarios(Car_Num).pos.Matrix.OB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        
        OBMat= round(OBMat);
        Bats.Carbonate(i).pos.Matrix.OB.name_number= OBMat;
        Bats.Carbonate(i).pos.Matrix.OB.name= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= Bats.Carbonate(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +(Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, :) - gBat.Scenarios(Car_Num).pos.Matrix.OB.Values(OBMat, :))...
            .*Bats.Carbonate(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :);
        
        %%% New Position %%%
        OBmatValues= Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, :) + Bats.Carbonate(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OBmatValues= gBat.Scenarios(Car_Num).pos.Matrix.OB.Values(OBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(OB Matrix Name)
        Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        MaxUBMatNumber= length(ModelBounds.Carbonate_Scenario.Matrix.UB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.UB.name_Velocity= Bats.Carbonate(i).pos.Matrix.UB.name_Velocity...
            +(Bats.Carbonate(i).pos.Matrix.UB.name_number - gBat.Scenarios(Car_Num).pos.Matrix.UB.name_number)...
            .*Bats.Carbonate(i).pos.Matrix.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UBMat= Bats.Carbonate(i).pos.Matrix.UB.name_number + Bats.Carbonate(i).pos.Matrix.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxUBMatNumber;
            UBMat= gBat.Scenarios(Car_Num).pos.Matrix.UB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        
        UBMat= round(UBMat);
        Bats.Carbonate(i).pos.Matrix.UB.name_number= UBMat;
        Bats.Carbonate(i).pos.Matrix.UB.name= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= Bats.Carbonate(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +(Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, :) - gBat.Scenarios(Car_Num).pos.Matrix.UB.Values(UBMat, :))...
            .*Bats.Carbonate(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :);
        
        %%% New Position %%%
        UBmatValues= Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, :) + Bats.Carbonate(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UBmatValues= gBat.Scenarios(Car_Num).pos.Matrix.UB.Values(UBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(UB Matrix Name)
        Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Super_RES')
        Max_Super_RES_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.Super_RES);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.Super_RES.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.Super_RES.name_Velocity= Bats.Carbonate(i).pos.Fluid.Super_RES.name_Velocity...
            +(Bats.Carbonate(i).pos.Fluid.Super_RES.name_number - gBat.Scenarios(Car_Num).pos.Fluid.Super_RES.name_number)...
            .*Bats.Carbonate(i).pos.Fluid.Super_RES.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        Super_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Super_RES.name_number + Bats.Carbonate(i).pos.Fluid.Super_RES.name_Velocity;
        
        if rand<emission_rate
            eps= Max_Super_RES_FluidNumber;
            Super_RES_Fluid= gBat.Scenarios(Car_Num).pos.Fluid.Super_RES.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Bats.Carbonate(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Bats.Carbonate(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities        
        
        for iter=1:ind_Entities_Number
            Max_Ind_RES_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            %%% Choose name Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%% Choose name Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +(Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - gBat.Scenarios(Car_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                .*Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Ind_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number + Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= Max_Ind_RES_FluidNumber;
                Ind_RES_Fluid= gBat.Scenarios(Car_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'OB')
        Max_OB_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.OB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.OB.name_Velocity= Bats.Carbonate(i).pos.Fluid.OB.name_Velocity...
            +(Bats.Carbonate(i).pos.Fluid.OB.name_number - gBat.Scenarios(Car_Num).pos.Fluid.OB.name_number)...
            .*Bats.Carbonate(i).pos.Fluid.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OB_Fluid= Bats.Carbonate(i).pos.Fluid.OB.name_number + Bats.Carbonate(i).pos.Fluid.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_OB_FluidNumber;
            OB_Fluid= gBat.Scenarios(Car_Num).pos.Fluid.OB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates Crossing UP elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Bats.Carbonate(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Bats.Carbonate(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'UB')
        Max_UB_FluidNumber= length(ModelBounds.Carbonate_Scenario.Fluid.UB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Carbonate(i).pos.Fluid.UB.name_Velocity= Bats.Carbonate(i).pos.Fluid.UB.name_Velocity...
            +(Bats.Carbonate(i).pos.Fluid.UB.name_number - gBat.Scenarios(Car_Num).pos.Fluid.UB.name_number)...
            .*Bats.Carbonate(i).pos.Fluid.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UB_Fluid= Bats.Carbonate(i).pos.Fluid.UB.name_number + Bats.Carbonate(i).pos.Fluid.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_UB_FluidNumber;
            UB_Fluid= gBat.Scenarios(Car_Num).pos.Fluid.UB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Bats.Carbonate(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Carbonate_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name
        Bats.Carbonate(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Carbonate.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Carbonate.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Super_RES')
        ub= ModelBounds.Carbonate_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        Super_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        
        Bats.Carbonate(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Carbonate(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= Bats.Carbonate(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +(Bats.Carbonate(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - gBat.Scenarios(Car_Num).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            .*Bats.Carbonate(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid);
        
        Super_RES_SW= Bats.Carbonate(i).pos.SW.Super_RES.Value(Super_RES_Fluid) + Bats.Carbonate(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Super_RES_SW= gBat.Scenarios(Car_Num).pos.SW.Super_RES.Value(Super_RES_Fluid)+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        %%% New Position
        Bats.Carbonate(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Ind_RES')
        ub= ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            
            Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +(Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - gBat.Scenarios(Car_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                .*Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid);
            
            %%% New Position %%%%%%%%%%
            Ind_RES_SW= Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) + Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Ind_RES_SW= gBat.Scenarios(Car_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)+eps*randn*loudness;
            end
            
            % Handling Boundries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'OB')
        ub= ModelBounds.Carbonate_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        OB_Fluid= Bats.Carbonate(i).pos.Fluid.OB.name_number;  % Fluid Number
        
        Bats.Carbonate(i).pos.SW.OB.Pulse_Frequency(OB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Carbonate(i).pos.SW.OB.Velocity(OB_Fluid)= Bats.Carbonate(i).pos.SW.OB.Velocity(OB_Fluid)...
            +(Bats.Carbonate(i).pos.SW.OB.Value(OB_Fluid) - gBat.Scenarios(Car_Num).pos.SW.OB.Value(OB_Fluid))...
            .*Bats.Carbonate(i).pos.SW.OB.Pulse_Frequency(OB_Fluid);
        
        %%% New Position %%%%%%%%%%
        OB_SW= Bats.Carbonate(i).pos.SW.OB.Value(OB_Fluid) + Bats.Carbonate(i).pos.SW.OB.Velocity(OB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OB_SW= gBat.Scenarios(Car_Num).pos.SW.OB.Value(OB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        %%% the new Position
        Bats.Carbonate(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'UB')
        ub= ModelBounds.Carbonate_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Carbonate_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        UB_Fluid= Bats.Carbonate(i).pos.Fluid.UB.name_number;  % Fluid Number
        
        Bats.Carbonate(i).pos.SW.UB.Pulse_Frequency(UB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Carbonate(i).pos.SW.UB.Velocity(UB_Fluid)= Bats.Carbonate(i).pos.SW.UB.Velocity(UB_Fluid)...
            +(Bats.Carbonate(i).pos.SW.UB.Value(UB_Fluid) - gBat.Scenarios(Car_Num).pos.SW.UB.Value(UB_Fluid))...
            .*Bats.Carbonate(i).pos.SW.UB.Pulse_Frequency(UB_Fluid);
        
        %%% New Position %%%%%%%%%%
        UB_SW= Bats.Carbonate(i).pos.SW.UB.Value(UB_Fluid) + Bats.Carbonate(i).pos.SW.UB.Velocity(UB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UB_SW= gBat.Scenarios(Car_Num).pos.SW.UB.Value(UB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        %%% the new Position
        Bats.Carbonate(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 1
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            POR_Value= Bats.Carbonate(i).pos.POR.(genvarname(c)).Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                POR_Value= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Right_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Mid_Left_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Left_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            
            %%%%% Mid_Right Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency;
            
            %%%% The new position
            Mid_Right_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Right_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            Right_Porvalue= Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Car_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Carbonate(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
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
    Bats.Carbonate(i).pos.POR.FullMatrix= Phi;
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
    MaRho= Bats.Carbonate(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Bats.Carbonate(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Bats.Carbonate(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Bats.Carbonate(i).pos.Fluid, 'Super_RES')
        BRRho= Carbonate.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Carbonate.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Carbonate(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Bats.Carbonate(i).pos.Fluid.Super_RES.name, 'Fresh Water')
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
            rho_hyc= Carbonate.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Carbonate.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Bats.Carbonate(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
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
    if isfield(Bats.Carbonate(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Bats.Carbonate(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
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
            
            if ~strcmp(Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
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
                rho_hyc= Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Carbonate.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Bats.Carbonate(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Bats.Carbonate(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
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
        
        if isfield(Bats.Carbonate(i).pos.Fluid, 'Super_RES')
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
    if isfield(Bats.Carbonate(i).pos.Matrix, 'OB')
        MaRho= Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Bats.Carbonate(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Carbonate.pos.Fluid.OB.Values{1, 1};
        BRVp= Carbonate.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Carbonate(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Bats.Carbonate(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            rho_hyc= Carbonate.pos.Fluid.OB.Values{2, 1};
            k_hyc= Carbonate.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Bats.Carbonate(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Bats.Carbonate(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
    if isfield(Bats.Carbonate(i).pos.Matrix, 'UB')
        MaRho= Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Bats.Carbonate(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Carbonate.pos.Fluid.UB.Values{1, 1};
        BRVp= Carbonate.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Carbonate(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Bats.Carbonate(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            rho_hyc= Carbonate.pos.Fluid.UB.Values{2, 1};
            k_hyc= Carbonate.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Bats.Carbonate(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Bats.Carbonate(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Carbonate(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
    if isfield(Bats.Carbonate(i).pos.Matrix, 'OB') && isfield(Bats.Carbonate(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Bats.Carbonate(i).pos.Matrix, 'OB') && ~isfield(Bats.Carbonate(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Bats.Carbonate(i).pos.Matrix, 'OB') && isfield(Bats.Carbonate(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Bats.Carbonate(i).pos.Matrix, 'OB') && ~isfield(Bats.Carbonate(i).pos.Matrix, 'UB')
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
    Frequency= Bats.Carbonate(i).Frequency.Value;
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
    
    Bats.Carbonate(i).final_cost= final;
    Bats.Carbonate(i).VpEq= type;  % velocity formula with least misfit
    Bats.Carbonate(i).Scenario= 1;   % 1 means Carbonate
    Bats.Carbonate(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Bats.Carbonate(i).Velocity_Model= Velocity_Model;
    Bats.Carbonate(i).Synthetic= Synthetic;
    Bats.Carbonate(i).iteration= iteration;
end



if ~isempty(Clastics_Scenario_Num)      % if there is Clastics Scenario then do the following
    Bats.Clastics(i).loudness= loudness;
    Bats.Clastics(i).emission_rate= emission_rate;
    
    %% Frequency Position %%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    
    Bats.Clastics(i).Frequency.Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
    
    Bats.Clastics(i).Frequency.Velocity= Bats.Clastics(i).Frequency.Velocity...
        +(Bats.Clastics(i).Frequency.Value - gBat.Scenarios(Clas_Num).Frequency.Value)...
        .*Bats.Clastics(i).Frequency.Pulse_Frequency;
    
    %%% the new Position
    Bats.Clastics(i).Frequency.Value= Bats.Clastics(i).Frequency.Value + Bats.Clastics(i).Frequency.Velocity;
    
    % Check a switching condition
    if rand<emission_rate
        eps= ub-lb;
        Bats.Clastics(i).Frequency.Value= gBat.Scenarios(Clas_Num).Frequency.Value + eps.*randn*loudness;
    end
    
    % Handling Boundries
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Check whether the previous position is at either bound
    CrossUp= Bats.Clastics(i).Frequency.Value >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Clastics(i).Frequency.Value= ub;
    end
    
    CrossDown= Bats.Clastics(i).Frequency.Value <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Clastics(i).Frequency.Value= lb;
    end
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'RES')   % RES Matrix is Clastics
        ub= ModelBounds.Clastics_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.RES.Values_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand(1, 3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.RES.Values_Velocity= Bats.Clastics(i).pos.Matrix.RES.Values_Velocity...
            +(Bats.Clastics(i).pos.Matrix.RES.Values - gBat.Scenarios(Clas_Num).pos.Matrix.RES.Values)...
            .*Bats.Clastics(i).pos.Matrix.RES.Values_Pulse_Frequency;
        
        %%%% New position %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.RES.Values= Bats.Clastics(i).pos.Matrix.RES.Values + Bats.Clastics(i).pos.Matrix.RES.Values_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Bats.Clastics(i).pos.Matrix.RES.Values= gBat.Scenarios(Clas_Num).pos.Matrix.RES.Values + eps.*randn(1, 3)*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Bats.Clastics(i).pos.Matrix.RES.Values >= ub;   % get the coordinates of Crossing Up elements
        Bats.Clastics(i).pos.Matrix.RES.Values(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= Bats.Clastics(i).pos.Matrix.RES.Values <= lb;   % get the coordinates Crossing Down elements
        Bats.Clastics(i).pos.Matrix.RES.Values(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        MaxOBMatNumber= length(ModelBounds.Clastics_Scenario.Matrix.OB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.OB.name_Velocity= Bats.Clastics(i).pos.Matrix.OB.name_Velocity...
            +(Bats.Clastics(i).pos.Matrix.OB.name_number - gBat.Scenarios(Clas_Num).pos.Matrix.OB.name_number)...
            .*Bats.Clastics(i).pos.Matrix.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OBMat= Bats.Clastics(i).pos.Matrix.OB.name_number + Bats.Clastics(i).pos.Matrix.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxOBMatNumber;
            OBMat= gBat.Scenarios(Clas_Num).pos.Matrix.OB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        
        OBMat= round(OBMat);
        Bats.Clastics(i).pos.Matrix.OB.name_number= OBMat;
        Bats.Clastics(i).pos.Matrix.OB.name= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= Bats.Clastics(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +(Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, :) - gBat.Scenarios(Clas_Num).pos.Matrix.OB.Values(OBMat, :))...
            .*Bats.Clastics(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :);
        
        %%% New Position %%%
        OBmatValues= Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, :) + Bats.Clastics(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OBmatValues= gBat.Scenarios(Clas_Num).pos.Matrix.OB.Values(OBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(OB Matrix Name)
        Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        MaxUBMatNumber= length(ModelBounds.Clastics_Scenario.Matrix.UB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.UB.name_Velocity= Bats.Clastics(i).pos.Matrix.UB.name_Velocity...
            +(Bats.Clastics(i).pos.Matrix.UB.name_number - gBat.Scenarios(Clas_Num).pos.Matrix.UB.name_number)...
            .*Bats.Clastics(i).pos.Matrix.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UBMat= Bats.Clastics(i).pos.Matrix.UB.name_number + Bats.Clastics(i).pos.Matrix.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxUBMatNumber;
            UBMat= gBat.Scenarios(Clas_Num).pos.Matrix.UB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        
        UBMat= round(UBMat);
        Bats.Clastics(i).pos.Matrix.UB.name_number= UBMat;
        Bats.Clastics(i).pos.Matrix.UB.name= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= Bats.Clastics(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +(Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, :) - gBat.Scenarios(Clas_Num).pos.Matrix.UB.Values(UBMat, :))...
            .*Bats.Clastics(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :);
        
        %%% New Position %%%
        UBmatValues= Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, :) + Bats.Clastics(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UBmatValues= gBat.Scenarios(Clas_Num).pos.Matrix.UB.Values(UBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(UB Matrix Name)
        Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Super_RES')
        Max_Super_RES_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.Super_RES);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.Super_RES.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.Super_RES.name_Velocity= Bats.Clastics(i).pos.Fluid.Super_RES.name_Velocity...
            +(Bats.Clastics(i).pos.Fluid.Super_RES.name_number - gBat.Scenarios(Clas_Num).pos.Fluid.Super_RES.name_number)...
            .*Bats.Clastics(i).pos.Fluid.Super_RES.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        Super_RES_Fluid= Bats.Clastics(i).pos.Fluid.Super_RES.name_number + Bats.Clastics(i).pos.Fluid.Super_RES.name_Velocity;
        
        if rand<emission_rate
            eps= Max_Super_RES_FluidNumber;
            Super_RES_Fluid= gBat.Scenarios(Clas_Num).pos.Fluid.Super_RES.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Bats.Clastics(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Bats.Clastics(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
              
        
        for iter=1:ind_Entities_Number
            Max_Ind_RES_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            %%% Choose name Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%% Choose name Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +(Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - gBat.Scenarios(Clas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                .*Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Ind_RES_Fluid= Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number + Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= Max_Ind_RES_FluidNumber;
                Ind_RES_Fluid= gBat.Scenarios(Clas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'OB')
        Max_OB_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.OB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.OB.name_Velocity= Bats.Clastics(i).pos.Fluid.OB.name_Velocity...
            +(Bats.Clastics(i).pos.Fluid.OB.name_number - gBat.Scenarios(Clas_Num).pos.Fluid.OB.name_number)...
            .*Bats.Clastics(i).pos.Fluid.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OB_Fluid= Bats.Clastics(i).pos.Fluid.OB.name_number + Bats.Clastics(i).pos.Fluid.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_OB_FluidNumber;
            OB_Fluid= gBat.Scenarios(Clas_Num).pos.Fluid.OB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates Crossing UP elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Bats.Clastics(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Bats.Clastics(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'UB')
        Max_UB_FluidNumber= length(ModelBounds.Clastics_Scenario.Fluid.UB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Clastics(i).pos.Fluid.UB.name_Velocity= Bats.Clastics(i).pos.Fluid.UB.name_Velocity...
            +(Bats.Clastics(i).pos.Fluid.UB.name_number - gBat.Scenarios(Clas_Num).pos.Fluid.UB.name_number)...
            .*Bats.Clastics(i).pos.Fluid.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UB_Fluid= Bats.Clastics(i).pos.Fluid.UB.name_number + Bats.Clastics(i).pos.Fluid.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_UB_FluidNumber;
            UB_Fluid= gBat.Scenarios(Clas_Num).pos.Fluid.UB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Bats.Clastics(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Clastics_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name
        Bats.Clastics(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Clastics.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Clastics.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Super_RES')
        ub= ModelBounds.Clastics_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        Super_RES_Fluid= Bats.Clastics(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        
        Bats.Clastics(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Clastics(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= Bats.Clastics(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +(Bats.Clastics(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - gBat.Scenarios(Clas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            .*Bats.Clastics(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid);
        
        Super_RES_SW= Bats.Clastics(i).pos.SW.Super_RES.Value(Super_RES_Fluid) + Bats.Clastics(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Super_RES_SW= gBat.Scenarios(Clas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid)+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        %%% New Position
        Bats.Clastics(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Ind_RES')
        ub= ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            
            Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +(Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - gBat.Scenarios(Clas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                .*Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid);
            
            %%% New Position %%%%%%%%%%
            Ind_RES_SW= Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) + Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Ind_RES_SW= gBat.Scenarios(Clas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)+eps*randn*loudness;
            end
            
            % Handling Boundries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'OB')
        ub= ModelBounds.Clastics_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        OB_Fluid= Bats.Clastics(i).pos.Fluid.OB.name_number;  % Fluid Number
        
        Bats.Clastics(i).pos.SW.OB.Pulse_Frequency(OB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Clastics(i).pos.SW.OB.Velocity(OB_Fluid)= Bats.Clastics(i).pos.SW.OB.Velocity(OB_Fluid)...
            +(Bats.Clastics(i).pos.SW.OB.Value(OB_Fluid) - gBat.Scenarios(Clas_Num).pos.SW.OB.Value(OB_Fluid))...
            .*Bats.Clastics(i).pos.SW.OB.Pulse_Frequency(OB_Fluid);
        
        %%% New Position %%%%%%%%%%
        OB_SW= Bats.Clastics(i).pos.SW.OB.Value(OB_Fluid) + Bats.Clastics(i).pos.SW.OB.Velocity(OB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OB_SW= gBat.Scenarios(Clas_Num).pos.SW.OB.Value(OB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        %%% the new Position
        Bats.Clastics(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Clastics_Scenario.SW, 'UB')
        ub= ModelBounds.Clastics_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Clastics_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        UB_Fluid= Bats.Clastics(i).pos.Fluid.UB.name_number;  % Fluid Number
        
        Bats.Clastics(i).pos.SW.UB.Pulse_Frequency(UB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Clastics(i).pos.SW.UB.Velocity(UB_Fluid)= Bats.Clastics(i).pos.SW.UB.Velocity(UB_Fluid)...
            +(Bats.Clastics(i).pos.SW.UB.Value(UB_Fluid) - gBat.Scenarios(Clas_Num).pos.SW.UB.Value(UB_Fluid))...
            .*Bats.Clastics(i).pos.SW.UB.Pulse_Frequency(UB_Fluid);
        
        %%% New Position %%%%%%%%%%
        UB_SW= Bats.Clastics(i).pos.SW.UB.Value(UB_Fluid) + Bats.Clastics(i).pos.SW.UB.Velocity(UB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UB_SW= gBat.Scenarios(Clas_Num).pos.SW.UB.Value(UB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        %%% the new Position
        Bats.Clastics(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 1
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            POR_Value= Bats.Clastics(i).pos.POR.(genvarname(c)).Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                POR_Value= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Right_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Mid_Left_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Left_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            
            %%%%% Mid_Right Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency;
            
            %%%% The new position
            Mid_Right_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Right_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            Right_Porvalue= Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Clas_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Clastics(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
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
    Bats.Clastics(i).pos.POR.FullMatrix= Phi;
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
    MaRho= Bats.Clastics(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Bats.Clastics(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Bats.Clastics(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Bats.Clastics(i).pos.Fluid, 'Super_RES')
        BRRho= Clastics.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Clastics.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Clastics(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Bats.Clastics(i).pos.Fluid.Super_RES.name, 'Fresh Water')
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
            rho_hyc= Clastics.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Clastics.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Bats.Clastics(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Bats.Clastics(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
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
    if isfield(Bats.Clastics(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Bats.Clastics(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
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
            
            if ~strcmp(Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
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
                rho_hyc= Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Clastics.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Bats.Clastics(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Bats.Clastics(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
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
        
        if isfield(Bats.Clastics(i).pos.Fluid, 'Super_RES')
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
    if isfield(Bats.Clastics(i).pos.Matrix, 'OB')
        MaRho= Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Bats.Clastics(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Clastics.pos.Fluid.OB.Values{1, 1};
        BRVp= Clastics.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Clastics(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Bats.Clastics(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            rho_hyc= Clastics.pos.Fluid.OB.Values{2, 1};
            k_hyc= Clastics.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Bats.Clastics(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Bats.Clastics(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
    if isfield(Bats.Clastics(i).pos.Matrix, 'UB')
        MaRho= Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Bats.Clastics(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Clastics.pos.Fluid.UB.Values{1, 1};
        BRVp= Clastics.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Clastics(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Bats.Clastics(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            rho_hyc= Clastics.pos.Fluid.UB.Values{2, 1};
            k_hyc= Clastics.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Bats.Clastics(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Bats.Clastics(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Clastics(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
    if isfield(Bats.Clastics(i).pos.Matrix, 'OB') && isfield(Bats.Clastics(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Bats.Clastics(i).pos.Matrix, 'OB') && ~isfield(Bats.Clastics(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Bats.Clastics(i).pos.Matrix, 'OB') && isfield(Bats.Clastics(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Bats.Clastics(i).pos.Matrix, 'OB') && ~isfield(Bats.Clastics(i).pos.Matrix, 'UB')
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
    Frequency= Bats.Clastics(i).Frequency.Value;
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
    
    Bats.Clastics(i).final_cost= final;
    Bats.Clastics(i).VpEq= type;  % velocity formula with least misfit
    Bats.Clastics(i).Scenario= 2;   % 2 means Clastics
    Bats.Clastics(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Bats.Clastics(i).Velocity_Model= Velocity_Model;
    Bats.Clastics(i).Synthetic= Synthetic;
    Bats.Clastics(i).iteration= iteration;
end



if ~isempty(Basalt_Scenario_Num)      % if there is Basalt Scenario then do the following
    Bats.Basalt(i).loudness= loudness;
    Bats.Basalt(i).emission_rate= emission_rate;
    
    %% Frequency Position %%%
    ub= ModelBounds.Frequency(2,:);   % Upper Bound
    lb= ModelBounds.Frequency(1,:);   % Lower Bound
    
    
    Bats.Basalt(i).Frequency.Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
    
    Bats.Basalt(i).Frequency.Velocity= Bats.Basalt(i).Frequency.Velocity...
        +(Bats.Basalt(i).Frequency.Value - gBat.Scenarios(Bas_Num).Frequency.Value)...
        .*Bats.Basalt(i).Frequency.Pulse_Frequency;
    
    %%% the new Position
    Bats.Basalt(i).Frequency.Value= Bats.Basalt(i).Frequency.Value + Bats.Basalt(i).Frequency.Velocity;
    
    % Check a switching condition
    if rand<emission_rate
        eps= ub-lb;
        Bats.Basalt(i).Frequency.Value= gBat.Scenarios(Bas_Num).Frequency.Value + eps.*randn*loudness;
    end
    
    % Handling Boundries
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Check whether the previous position is at either bound
    CrossUp= Bats.Basalt(i).Frequency.Value >= ub;   % get the coordinates of Crossing Up elements
    if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Basalt(i).Frequency.Value= ub;
    end
    
    CrossDown= Bats.Basalt(i).Frequency.Value <= lb;   % get the coordinates Crossing Down elements
    if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
        Bats.Basalt(i).Frequency.Value= lb;
    end
    
    %% Matrix Position %%%
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'RES')   % RES Matrix is Basalt
        ub= ModelBounds.Basalt_Scenario.Matrix.RES(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.RES(1,:);   % Lower Bound
        
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.RES.Values_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand(1, 3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.RES.Values_Velocity= Bats.Basalt(i).pos.Matrix.RES.Values_Velocity...
            +(Bats.Basalt(i).pos.Matrix.RES.Values - gBat.Scenarios(Bas_Num).pos.Matrix.RES.Values)...
            .*Bats.Basalt(i).pos.Matrix.RES.Values_Pulse_Frequency;
        
        %%%% New position %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.RES.Values= Bats.Basalt(i).pos.Matrix.RES.Values + Bats.Basalt(i).pos.Matrix.RES.Values_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Bats.Basalt(i).pos.Matrix.RES.Values= gBat.Scenarios(Bas_Num).pos.Matrix.RES.Values + eps.*randn(1, 3)*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Bats.Basalt(i).pos.Matrix.RES.Values >= ub;   % get the coordinates of Crossing Up elements
        Bats.Basalt(i).pos.Matrix.RES.Values(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= Bats.Basalt(i).pos.Matrix.RES.Values <= lb;   % get the coordinates Crossing Down elements
        Bats.Basalt(i).pos.Matrix.RES.Values(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        MaxOBMatNumber= length(ModelBounds.Basalt_Scenario.Matrix.OB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.OB.name_Velocity= Bats.Basalt(i).pos.Matrix.OB.name_Velocity...
            +(Bats.Basalt(i).pos.Matrix.OB.name_number - gBat.Scenarios(Bas_Num).pos.Matrix.OB.name_number)...
            .*Bats.Basalt(i).pos.Matrix.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OBMat= Bats.Basalt(i).pos.Matrix.OB.name_number + Bats.Basalt(i).pos.Matrix.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxOBMatNumber;
            OBMat= gBat.Scenarios(Bas_Num).pos.Matrix.OB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBMat >= MaxOBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= MaxOBMatNumber;
        end
        
        CrossDown= OBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OBMat= 1;
        end
        
        OBMat= round(OBMat);
        Bats.Basalt(i).pos.Matrix.OB.name_number= OBMat;
        Bats.Basalt(i).pos.Matrix.OB.name= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.OB.Values_Velocity(OBMat, :)= Bats.Basalt(i).pos.Matrix.OB.Values_Velocity(OBMat, :)...
            +(Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, :) - gBat.Scenarios(Bas_Num).pos.Matrix.OB.Values(OBMat, :))...
            .*Bats.Basalt(i).pos.Matrix.OB.Values_Pulse_Frequency(OBMat, :);
        
        %%% New Position %%%
        OBmatValues= Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, :) + Bats.Basalt(i).pos.Matrix.OB.Values_Velocity(OBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OBmatValues= gBat.Scenarios(Bas_Num).pos.Matrix.OB.Values(OBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OBmatValues >= ub;   % get the coordinates of Crossing Up elements
        OBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= OBmatValues <= lb;   % get the coordinates Crossing Down elements
        OBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(OB Matrix Name)
        Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, :)= OBmatValues;
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        MaxUBMatNumber= length(ModelBounds.Basalt_Scenario.Matrix.UB);
        
        %%% Choose name frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.UB.name_Velocity= Bats.Basalt(i).pos.Matrix.UB.name_Velocity...
            +(Bats.Basalt(i).pos.Matrix.UB.name_number - gBat.Scenarios(Bas_Num).pos.Matrix.UB.name_number)...
            .*Bats.Basalt(i).pos.Matrix.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UBMat= Bats.Basalt(i).pos.Matrix.UB.name_number + Bats.Basalt(i).pos.Matrix.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= MaxUBMatNumber;
            UBMat= gBat.Scenarios(Bas_Num).pos.Matrix.UB.name_number+eps*randn*loudness;
        end
        
        
        %%%% Handling Boundaries %%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBMat >= MaxUBMatNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= MaxUBMatNumber;
        end
        
        CrossDown= UBMat <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UBMat= 1;
        end
        
        UBMat= round(UBMat);
        Bats.Basalt(i).pos.Matrix.UB.name_number= UBMat;
        Bats.Basalt(i).pos.Matrix.UB.name= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).name; % Matrix Name
        
        
        ub= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).bounds(2,:);   % Upper Bound
        lb= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).bounds(1,:);   % Lower Bound
        
        %%%% Choose Values frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :)= Min_Freq+(Max_Freq - Min_Freq)*rand(1 ,3);
        
        %%%% Choose Values Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Matrix.UB.Values_Velocity(UBMat, :)= Bats.Basalt(i).pos.Matrix.UB.Values_Velocity(UBMat, :)...
            +(Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, :) - gBat.Scenarios(Bas_Num).pos.Matrix.UB.Values(UBMat, :))...
            .*Bats.Basalt(i).pos.Matrix.UB.Values_Pulse_Frequency(UBMat, :);
        
        %%% New Position %%%
        UBmatValues= Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, :) + Bats.Basalt(i).pos.Matrix.UB.Values_Velocity(UBMat, :);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UBmatValues= gBat.Scenarios(Bas_Num).pos.Matrix.UB.Values(UBMat, :) + eps.*randn.*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UBmatValues >= ub;   % get the coordinates of Crossing Up elements
        UBmatValues(CrossUp)= ub(CrossUp);% the variables that cross the high bounds(Set them= high bounds)
        
        CrossDown= UBmatValues <= lb;   % get the coordinates Crossing Down elements
        UBmatValues(CrossDown)= lb(CrossDown);   % the variables that cross the high bounds(Set them= high bounds)
        
        %%% the new Position(UB Matrix Name)
        Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, :)= UBmatValues;
    end
    %%%%%%%%%%%
    
    %% Fluid Position %%%
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Super_RES')
        Max_Super_RES_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.Super_RES);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.Super_RES.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.Super_RES.name_Velocity= Bats.Basalt(i).pos.Fluid.Super_RES.name_Velocity...
            +(Bats.Basalt(i).pos.Fluid.Super_RES.name_number - gBat.Scenarios(Bas_Num).pos.Fluid.Super_RES.name_number)...
            .*Bats.Basalt(i).pos.Fluid.Super_RES.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        Super_RES_Fluid= Bats.Basalt(i).pos.Fluid.Super_RES.name_number + Bats.Basalt(i).pos.Fluid.Super_RES.name_Velocity;
        
        if rand<emission_rate
            eps= Max_Super_RES_FluidNumber;
            Super_RES_Fluid= gBat.Scenarios(Bas_Num).pos.Fluid.Super_RES.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_Fluid >= Max_Super_RES_FluidNumber;   % get the coordinates of Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= Max_Super_RES_FluidNumber;
        end
        
        CrossDown= Super_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            Super_RES_Fluid= 1;
        end
        
        %%% the new Position(Super_RES Fluid Name)
        Super_RES_Fluid= round(Super_RES_Fluid);
        Bats.Basalt(i).pos.Fluid.Super_RES.name_number= Super_RES_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.Super_RES{Super_RES_Fluid}; % Fluid Name
        Bats.Basalt(i).pos.Fluid.Super_RES.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt.pos.Fluid.Super_RES.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.Super_RES.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt.pos.Fluid.Super_RES.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        
        
        for iter=1:ind_Entities_Number
            Max_Ind_RES_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            
            
            %%% Choose name Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%% Choose name Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity...
                +(Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number - gBat.Scenarios(Bas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number)...
                .*Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Ind_RES_Fluid= Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number + Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= Max_Ind_RES_FluidNumber;
                Ind_RES_Fluid= gBat.Scenarios(Bas_Num).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_Fluid >= Max_Ind_RES_FluidNumber;   % get the coordinates of Crossing Up elements
            if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= Max_Ind_RES_FluidNumber;
            end
            
            CrossDown= Ind_RES_Fluid <= 1;   % get the coordinates Crossing Down elements
            if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
                Ind_RES_Fluid= 1;
            end
            
            %%% the new Position(Ind_RES Fluid Name)
            Ind_RES_Fluid= round(Ind_RES_Fluid);
            Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_Fluid;  % Fluid Number
            Flname= ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_Fluid}; % Fluid Name
            Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            
            if strcmp(Flname, 'Fresh Water')
                Flname= 'Fwater';
            end
            if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
                Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp};
            else
                BRRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho;
                BRVp= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity;
                
                FlRho= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
                FlK= MODEL.(genvarname(ind_Entities{iter})).Geology.FluidContent.Fluids_Properties_Matrices.(genvarname(Flname)).K;
                Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values= {BRRho, BRVp;FlRho, FlK};
            end
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'OB')
        Max_OB_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.OB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.OB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.OB.name_Velocity= Bats.Basalt(i).pos.Fluid.OB.name_Velocity...
            +(Bats.Basalt(i).pos.Fluid.OB.name_number - gBat.Scenarios(Bas_Num).pos.Fluid.OB.name_number)...
            .*Bats.Basalt(i).pos.Fluid.OB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        OB_Fluid= Bats.Basalt(i).pos.Fluid.OB.name_number + Bats.Basalt(i).pos.Fluid.OB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_OB_FluidNumber;
            OB_Fluid= gBat.Scenarios(Bas_Num).pos.Fluid.OB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_Fluid >= Max_OB_FluidNumber;   % get the coordinates Crossing UP elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= Max_OB_FluidNumber;
        end
        
        CrossDown= OB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            OB_Fluid= 1;
        end
        
        %%% the new Position(OB Fluid Name)
        OB_Fluid= round(OB_Fluid);
        Bats.Basalt(i).pos.Fluid.OB.name_number= OB_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.OB{OB_Fluid}; % Fluid Name
        Bats.Basalt(i).pos.Fluid.OB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt.pos.Fluid.OB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.OB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.OB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.OB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt.pos.Fluid.OB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'UB')
        Max_UB_FluidNumber= length(ModelBounds.Basalt_Scenario.Fluid.UB);
        
        
        %%% Choose name Frequency %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.UB.name_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        %%% Choose name Velocity %%%%%%%%%%
        Bats.Basalt(i).pos.Fluid.UB.name_Velocity= Bats.Basalt(i).pos.Fluid.UB.name_Velocity...
            +(Bats.Basalt(i).pos.Fluid.UB.name_number - gBat.Scenarios(Bas_Num).pos.Fluid.UB.name_number)...
            .*Bats.Basalt(i).pos.Fluid.UB.name_Pulse_Frequency;
        
        %%% New Position %%%%%%%%%%
        UB_Fluid= Bats.Basalt(i).pos.Fluid.UB.name_number + Bats.Basalt(i).pos.Fluid.UB.name_Velocity;
        
        % Check a switching condition
        if rand<emission_rate
            eps= Max_UB_FluidNumber;
            UB_Fluid= gBat.Scenarios(Bas_Num).pos.Fluid.UB.name_number+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_Fluid >= Max_UB_FluidNumber;   % get the coordinates Crossing Up elements
        if CrossUp  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= Max_UB_FluidNumber;
        end
        
        CrossDown= UB_Fluid <= 1;   % get the coordinates Crossing Down elements
        if CrossDown  % the variables that cross the high bounds(Set them= high bounds)
            UB_Fluid= 1;
        end
        
        %%% the new Position(UB Fluid Name)
        UB_Fluid= round(UB_Fluid);
        Bats.Basalt(i).pos.Fluid.UB.name_number= UB_Fluid;  % Fluid Number
        Flname= ModelBounds.Basalt_Scenario.Fluid.UB{UB_Fluid}; % Fluid Name
        Bats.Basalt(i).pos.Fluid.UB.name= Flname;
        if strcmp(Flname, 'Fresh Water')
            Flname= 'Fwater';
        end
        if strcmp(Flname, 'Fwater') || strcmp(Flname, 'Brine')
            BRRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).velocity;
            Basalt.pos.Fluid.UB.Values= {BRRho, BRVp};
        else
            BRRho= MODEL.UB.Fluids_Properties_Matrices.Brine.Rho;
            BRVp= MODEL.UB.Fluids_Properties_Matrices.Brine.velocity;
            
            FlRho= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).Rho;
            FlK= MODEL.UB.Fluids_Properties_Matrices.(genvarname(Flname)).K;
            Basalt.pos.Fluid.UB.Values= {BRRho, BRVp;FlRho, FlK};
        end
    end
    
    %% SW Position %%%
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Super_RES')
        ub= ModelBounds.Basalt_Scenario.SW.Super_RES(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.Super_RES(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        Super_RES_Fluid= Bats.Basalt(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
        
        Bats.Basalt(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Basalt(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)= Bats.Basalt(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid)...
            +(Bats.Basalt(i).pos.SW.Super_RES.Value(Super_RES_Fluid) - gBat.Scenarios(Bas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid))...
            .*Bats.Basalt(i).pos.SW.Super_RES.Pulse_Frequency(Super_RES_Fluid);
        
        Super_RES_SW= Bats.Basalt(i).pos.SW.Super_RES.Value(Super_RES_Fluid) + Bats.Basalt(i).pos.SW.Super_RES.Velocity(Super_RES_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            Super_RES_SW= gBat.Scenarios(Bas_Num).pos.SW.Super_RES.Value(Super_RES_Fluid)+eps*randn*loudness;
        end
        
        % Handling Boundaries
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= Super_RES_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            Super_RES_SW= ub;
        end
        
        CrossDown= Super_RES_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            Super_RES_SW= lb;
        end
        
        %%% New Position
        Bats.Basalt(i).pos.SW.Super_RES.Value(Super_RES_Fluid)= Super_RES_SW;
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Ind_RES')
        ub= ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_Fluid= Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
            
            Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)= Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid)...
                +(Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) - gBat.Scenarios(Bas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid))...
                .*Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Pulse_Frequency(Ind_RES_Fluid);
            
            %%% New Position %%%%%%%%%%
            Ind_RES_SW= Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid) + Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity(Ind_RES_Fluid);
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Ind_RES_SW= gBat.Scenarios(Bas_Num).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)+eps*randn*loudness;
            end
            
            % Handling Boundries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Ind_RES_SW >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Ind_RES_SW= ub;
            end
            
            CrossDown= Ind_RES_SW <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Ind_RES_SW= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid)= Ind_RES_SW;
        end
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'OB')
        ub= ModelBounds.Basalt_Scenario.SW.OB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.OB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        OB_Fluid= Bats.Basalt(i).pos.Fluid.OB.name_number;  % Fluid Number
        
        Bats.Basalt(i).pos.SW.OB.Pulse_Frequency(OB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Basalt(i).pos.SW.OB.Velocity(OB_Fluid)= Bats.Basalt(i).pos.SW.OB.Velocity(OB_Fluid)...
            +(Bats.Basalt(i).pos.SW.OB.Value(OB_Fluid) - gBat.Scenarios(Bas_Num).pos.SW.OB.Value(OB_Fluid))...
            .*Bats.Basalt(i).pos.SW.OB.Pulse_Frequency(OB_Fluid);
        
        %%% New Position %%%%%%%%%%
        OB_SW= Bats.Basalt(i).pos.SW.OB.Value(OB_Fluid) + Bats.Basalt(i).pos.SW.OB.Velocity(OB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            OB_SW= gBat.Scenarios(Bas_Num).pos.SW.OB.Value(OB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= OB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            OB_SW= ub;
        end
        
        CrossDown= OB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            OB_SW= lb;
        end
        
        %%% the new Position
        Bats.Basalt(i).pos.SW.OB.Value(OB_Fluid)= OB_SW;
    end
    
    if isfield(ModelBounds.Basalt_Scenario.SW, 'UB')
        ub= ModelBounds.Basalt_Scenario.SW.UB(2,:)/100;   % Upper Bound (SW in fraction)
        lb= ModelBounds.Basalt_Scenario.SW.UB(1,:)/100;   % Lower Bound (SW in fraction)
        
        
        UB_Fluid= Bats.Basalt(i).pos.Fluid.UB.name_number;  % Fluid Number
        
        Bats.Basalt(i).pos.SW.UB.Pulse_Frequency(UB_Fluid)= Min_Freq+(Max_Freq - Min_Freq)*rand;
        
        Bats.Basalt(i).pos.SW.UB.Velocity(UB_Fluid)= Bats.Basalt(i).pos.SW.UB.Velocity(UB_Fluid)...
            +(Bats.Basalt(i).pos.SW.UB.Value(UB_Fluid) - gBat.Scenarios(Bas_Num).pos.SW.UB.Value(UB_Fluid))...
            .*Bats.Basalt(i).pos.SW.UB.Pulse_Frequency(UB_Fluid);
        
        %%% New Position %%%%%%%%%%
        UB_SW= Bats.Basalt(i).pos.SW.UB.Value(UB_Fluid) + Bats.Basalt(i).pos.SW.UB.Velocity(UB_Fluid);
        
        % Check a switching condition
        if rand<emission_rate
            eps= ub-lb;
            UB_SW= gBat.Scenarios(Bas_Num).pos.SW.UB.Value(UB_Fluid)+eps*randn*loudness;
        end
        
        % Handling Position
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Check whether the previous position is at either bound
        CrossUp= UB_SW >= ub;   % get the coordinates of Crossing Up elements
        if CrossUp
            UB_SW= ub;
        end
        
        CrossDown= UB_SW <= lb;   % get the coordinates Crossing Down elements
        if CrossDown
            UB_SW= lb;
        end
        
        %%% the new Position
        Bats.Basalt(i).pos.SW.UB.Value(UB_Fluid)= UB_SW;
    end
    
    %% Porosity Position %%%
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        if ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 1
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            POR_Value= Bats.Basalt(i).pos.POR.(genvarname(c)).Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                POR_Value= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= POR_Value >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                POR_Value= ub;
            end
            
            CrossDown= POR_Value <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                POR_Value= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Porvalue= POR_Value;
            PorMatrix= POR_Value.*MODEL.(genvarname(c)).Matrix;
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 2
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Right_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
            %%% create POR Matrix
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 3
            %%%%% Left Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            
            
            %%%% Choose Values Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Left_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Left_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at either bound
            CrossUp= Left_Porvalue >= ub;   % get the coordinates Crossing Up elements
            if CrossUp
                Left_Porvalue= ub;
            end
            
            CrossDown= Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            
            %%%%% Mid_Left Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Left_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Left_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Pulse_Frequency;
            
            %%% New Position %%%%%%%%%%
            Mid_Left_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Left_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Left_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Left_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Left_Porvalue= ub;
            end
            
            CrossDown= Mid_Left_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Left_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            
            %%%%% Mid_Right Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Mid_Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Mid_Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Pulse_Frequency;
            
            %%%% The new position
            Mid_Right_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Mid_Right_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Mid_Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Mid_Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Mid_Right_Porvalue= ub;
            end
            
            CrossDown= Mid_Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Mid_Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            
            %%%%% Right Porosity Value %%%%%
            ub= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;   % Upper Bound
            lb= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;   % Lower Bound
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            ub= min(ub, Left_Porvalue+Max_Range);
            lb= max(lb, Left_Porvalue-Max_Range);
            
            
            %%%% Choose Values Right_Porvalue_Frequency %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency= Min_Freq+(Max_Freq - Min_Freq)*rand;
            
            %%%% Choose Values Right_Porvalue_Velocity %%%%%%%%%%
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity...
                +(Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue - gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue)...
                .*Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Pulse_Frequency;
            
            Right_Porvalue= Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue + Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity;
            
            % Check a switching condition
            if rand<emission_rate
                eps= ub-lb;
                Right_Porvalue= gBat.Scenarios(Bas_Num).pos.POR.(genvarname(c)).Right_Porvalue+eps*randn*loudness;
            end
            
            % Handling Boundaries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Check whether the previous position is at eiter bound
            CrossUp= Right_Porvalue >= ub;   % get the coordinates of Crossing Up elements
            if CrossUp
                Right_Porvalue= ub;
            end
            
            CrossDown= Right_Porvalue <= lb;   % get the coordinates Crossing Down elements
            if CrossDown
                Right_Porvalue= lb;
            end
            
            %%% the new Position
            Bats.Basalt(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            
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
    Bats.Basalt(i).pos.POR.FullMatrix= Phi;
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
    MaRho= Bats.Basalt(i).pos.Matrix.RES.Values(1)/1000;   % in g/cm3
    K_Modulus= Bats.Basalt(i).pos.Matrix.RES.Values(2);    % in GPa
    Mu_Modulus= Bats.Basalt(i).pos.Matrix.RES.Values(3);   % in GPa
    MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
    
    if isfield(Bats.Basalt(i).pos.Fluid, 'Super_RES')
        BRRho= Basalt.pos.Fluid.Super_RES.Values{1, 1};
        BRVp= Basalt.pos.Fluid.Super_RES.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Basalt(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Bats.Basalt(i).pos.Fluid.Super_RES.name, 'Fresh Water')
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
            rho_hyc= Basalt.pos.Fluid.Super_RES.Values{2, 1};
            k_hyc= Basalt.pos.Fluid.Super_RES.Values{2, 2};
            
            % Output Bulk Density
            Super_RES_Fluid= Bats.Basalt(i).pos.Fluid.Super_RES.name_number;  % Fluid Number
            tsw= Bats.Basalt(i).pos.SW.Super_RES.Value(Super_RES_Fluid);    % Water Saturation
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
    if isfield(Bats.Basalt(i).pos.Fluid, 'Ind_RES')
        ind_Entities= fieldnames(Bats.Basalt(i).pos.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        BulkRho_Total_Ind_RES= 0;
        BulkVp_Total_Ind_RES_RHG= 0;
        BulkVp_Total_Ind_RES_WGG= 0;
        BulkVp_Total_Ind_RES_GGG= 0;
        for iter=1:ind_Entities_Number
            BRRho= Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,1};
            BRVp= Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{1,2}/1000;  % in Km/s
            
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
            
            if ~strcmp(Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
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
                rho_hyc= Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 1};
                k_hyc= Basalt.pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).Values{2, 2};
                
                % Output Bulk Density
                Ind_RES_Fluid= Bats.Basalt(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number;  % Fluid Number
                tsw= Bats.Basalt(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value(Ind_RES_Fluid);    % Water Saturation
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
        
        if isfield(Bats.Basalt(i).pos.Fluid, 'Super_RES')
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
    if isfield(Bats.Basalt(i).pos.Matrix, 'OB')
        MaRho= Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, 1)/1000;  % in g/cm3
        K_Modulus= Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, 2);   % in GPa
        Mu_Modulus= Bats.Basalt(i).pos.Matrix.OB.Values(OBMat, 3);   % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Basalt.pos.Fluid.OB.Values{1, 1};
        BRVp= Basalt.pos.Fluid.OB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Basalt(i).pos.Fluid.OB.name, 'Brine') && ~strcmp(Bats.Basalt(i).pos.Fluid.OB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_RHG).^2 + 1.01677.*(BulkVp_OB_RHG) - 1.0349;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.58321.*(BulkVp_OB_RHG) - 0.07775;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_RHG).^2 + 0.80416.*(BulkVp_OB_RHG) - 0.85588;  % in Km/s
                BulkVs_OB_RHG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            rho_hyc= Basalt.pos.Fluid.OB.Values{2, 1};
            k_hyc= Basalt.pos.Fluid.OB.Values{2, 2};
            
            % Output Bulk Density
            OB_Fluid= Bats.Basalt(i).pos.Fluid.OB.name_number;  % Fluid Number
            tsw= Bats.Basalt(i).pos.SW.OB.Value(OB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_WGG).^2 + 1.01677.*(BulkVp_OB_WGG) - 1.0349;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.58321.*(BulkVp_OB_WGG) - 0.07775;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_WGG).^2 + 0.80416.*(BulkVp_OB_WGG) - 0.85588;  % in Km/s
                BulkVs_OB_WGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_OB_GGG).^2 + 1.01677.*(BulkVp_OB_GGG) - 1.0349;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.58321.*(BulkVp_OB_GGG) - 0.07775;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_OB_GGG).^2 + 0.80416.*(BulkVp_OB_GGG) - 0.85588;  % in Km/s
                BulkVs_OB_GGG= tempVs .* MODEL.OB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.OB.name{1,1}, 'Shale')
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
    if isfield(Bats.Basalt(i).pos.Matrix, 'UB')
        MaRho= Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, 1)/1000; % in g/cm3
        K_Modulus= Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, 2);  % in GPa
        Mu_Modulus= Bats.Basalt(i).pos.Matrix.UB.Values(UBMat, 3); % in GPa
        MaVp= sqrt((K_Modulus+Mu_Modulus.*4/3)./MaRho);  % km/s
        
        BRRho= Basalt.pos.Fluid.UB.Values{1, 1};
        BRVp= Basalt.pos.Fluid.UB.Values{1, 2}/1000; % in Km/s
        
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
        
        if ~strcmp(Bats.Basalt(i).pos.Fluid.UB.name, 'Brine') && ~strcmp(Bats.Basalt(i).pos.Fluid.UB.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            if strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_RHG).^2 + 1.01677.*(BulkVp_UB_RHG) - 1.0349;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.58321.*(BulkVp_UB_RHG) - 0.07775;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_RHG).^2 + 0.80416.*(BulkVp_UB_RHG) - 0.85588;  % in Km/s
                BulkVs_UB_RHG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            rho_hyc= Basalt.pos.Fluid.UB.Values{2, 1};
            k_hyc= Basalt.pos.Fluid.UB.Values{2, 2};
            
            % Output Bulk Density
            UB_Fluid= Bats.Basalt(i).pos.Fluid.UB.name_number;  % Fluid Number
            tsw= Bats.Basalt(i).pos.SW.UB.Value(UB_Fluid);    % Water Saturation
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
            if strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_WGG).^2 + 1.01677.*(BulkVp_UB_WGG) - 1.0349;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.58321.*(BulkVp_UB_WGG) - 0.07775;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_WGG).^2 + 0.80416.*(BulkVp_UB_WGG) - 0.85588;  % in Km/s
                BulkVs_UB_WGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
            if strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Lime Stone')
                tempVs= -0.05508.*(BulkVp_UB_GGG).^2 + 1.01677.*(BulkVp_UB_GGG) - 1.0349;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Dolomite')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.58321.*(BulkVp_UB_GGG) - 0.07775;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Sand Stone')
                tempVs= 0*(BulkVp_UB_GGG).^2 + 0.80416.*(BulkVp_UB_GGG) - 0.85588;  % in Km/s
                BulkVs_UB_GGG= tempVs .* MODEL.UB.Matrix;  % in km/s
            elseif strcmp(Bats.Basalt(i).pos.Matrix.UB.name{1,1}, 'Shale')
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
    if isfield(Bats.Basalt(i).pos.Matrix, 'OB') && isfield(Bats.Basalt(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG + BulkVp_UB_GGG;
    elseif isfield(Bats.Basalt(i).pos.Matrix, 'OB') && ~isfield(Bats.Basalt(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_OB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_OB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_OB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_OB_GGG;
    elseif ~isfield(Bats.Basalt(i).pos.Matrix, 'OB') && isfield(Bats.Basalt(i).pos.Matrix, 'UB')
        BulkRho_Total_Matrix= BulkRho_RES + BulkRho_UB;
        BulkVp_Total_Matrix_RHG= BulkVp_RES_RHG + BulkVp_UB_RHG;
        BulkVp_Total_Matrix_WGG= BulkVp_RES_WGG + BulkVp_UB_WGG;
        BulkVp_Total_Matrix_GGG= BulkVp_RES_GGG + BulkVp_UB_GGG;
    elseif ~isfield(Bats.Basalt(i).pos.Matrix, 'OB') && ~isfield(Bats.Basalt(i).pos.Matrix, 'UB')
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
    Frequency= Bats.Basalt(i).Frequency.Value;
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
    
    Bats.Basalt(i).final_cost= final;
    Bats.Basalt(i).VpEq= type;  % velocity formula with least misfit
    Bats.Basalt(i).Scenario= 3;   % 3 means Basalt
    Bats.Basalt(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Bats.Basalt(i).Velocity_Model= Velocity_Model;
    Bats.Basalt(i).Synthetic= Synthetic;
    Bats.Basalt(i).iteration= iteration;
end
%% Classification
% Carbonate
if ~isempty(Car_Num)
    if Bats.Carbonate(i).final_cost < bBats.Carbonate(i).final_cost
        bBats.Carbonate(i)= Bats.Carbonate(i);
    end
end

% Clastics
if ~isempty(Clas_Num)
    if Bats.Clastics(i).final_cost < bBats.Clastics(i).final_cost
        bBats.Clastics(i)= Bats.Clastics(i);
    end
end

% Basalt
if ~isempty(Bas_Num)
    if Bats.Basalt(i).final_cost < bBats.Basalt(i).final_cost
        bBats.Basalt(i)= Bats.Basalt(i);
    end
end

%% Redo the function for NP times
if i<NP
    i= i+1;
    BAT_Variables_Modifier(handles)
end