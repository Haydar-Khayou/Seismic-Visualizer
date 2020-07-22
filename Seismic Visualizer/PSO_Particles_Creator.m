function PSO_Particles_Creator(handles)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of science
%           Author: Haydar Khayou
%
%% First time picking variables(randomly)
% in this function we initiate the searching particles with random values
% within the search space. We save the particles under the struct variable
% named 'Particles', we then initiate another struct variable 'named'
% 'bparticles' which contains the best LOCAL position of each particle so
% far.

%% variables
global Data MODEL ModelBounds NumberofEntities
global Particles
global NRMSE SeisAmp_Max i NP Polarity Init_Vel
if MODEL.SeismicProperties.Polarity==1
    Polarity= 1;
else
    Polarity= -1;
end
% What number does each Scenario have?
Carbonate_Scenario_Num= ModelBounds.Carbonate_Scenario_Num;
Clastics_Scenario_Num= ModelBounds.Clastics_Scenario_Num;
Basalt_Scenario_Num= ModelBounds.Basalt_Scenario_Num;

%% Creating particles

if ~isempty(Carbonate_Scenario_Num)      % if there is Carbonate Scenario then do the following
    %%% Pick Frequency
    Particles.Carbonate_particle(i).Frequency.Velocity= Init_Vel;       % Velocity is 0 in the first iteration. 
                                                                 % Note: Velocity determines Particles Vitality
                                                                 
    % Choose random value for Frequency bcz it's the first iteration                          
    Particles.Carbonate_particle(i).Frequency.Value= ModelBounds.Frequency(1)+ rand.*(ModelBounds.Frequency(2)-ModelBounds.Frequency(1));
    %%%%%%%%%%%
    
    %%% Pick Matrix: In Matrix we will choose: 
    %%%              RES: 1. Values(Rho, K, Mu)  2. Velocities of Values.    Note: No name in RES because scenario is Determined.               
    %%%               OB: 1. Name    2. Velocity of Name  3. Values of each name(Rho, K, Mu)  4. Velocities of Values 
    %%%               UB: 1. Name    2. Velocity of Name  3. Values of each name(Rho, K, Mu)  4. Velocities of Values     
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'RES')   % RES Matrix is Carbonate
        Particles.Carbonate_particle(i).pos.Matrix.RES.name= 'Carbonate';  
        %%% "pos" in "Carbonate_particle(i).pos" means position 
        
        %%% Initialize optimization variables
        Particles.Carbonate_particle(i).pos.Matrix.RES.Values_Velocity= Init_Vel*ones(1, 3);  % Optimization particle Velocity
        Particles.Carbonate_particle(i).pos.Matrix.RES.Values= ModelBounds.Carbonate_Scenario.Matrix.RES(1,:)+ rand(1, 3).*(ModelBounds.Carbonate_Scenario.Matrix.RES(2,:)-ModelBounds.Carbonate_Scenario.Matrix.RES(1,:));
        %%% Note: pos.Matrix.RES.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        OBMat= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Matrix.OB)-1));     % pick a random Mineral number
        Particles.Carbonate_particle(i).pos.Matrix.OB.name_number= OBMat;
        Particles.Carbonate_particle(i).pos.Matrix.OB.name= ModelBounds.Carbonate_Scenario.Matrix.OB(OBMat).name;
        
        %%% Initialize optimization variables
        Particles.Carbonate_particle(i).pos.Matrix.OB.name_Velocity= Init_Vel; % Velocity of name. Because the algorithm changes OB Mineralogy as it goes through iterations
        Particles.Carbonate_particle(i).pos.Matrix.OB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Carbonate_Scenario.Matrix.OB), 3);  % Optimization particle Velocity
        
        for ttt= 1:length(ModelBounds.Carbonate_Scenario.Matrix.OB)  % Choose random values for all probable OB Mineralogy(Rho, K, Mu)
            Particles.Carbonate_particle(i).pos.Matrix.OB.Values(ttt, 1:3)= ModelBounds.Carbonate_Scenario.Matrix.OB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Carbonate_Scenario.Matrix.OB(ttt).bounds(2,:)-ModelBounds.Carbonate_Scenario.Matrix.OB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.OB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Carbonate_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        UBMat= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Matrix.UB)-1));     % pick a random Mineral number
        Particles.Carbonate_particle(i).pos.Matrix.UB.name_number= UBMat;
        Particles.Carbonate_particle(i).pos.Matrix.UB.name= ModelBounds.Carbonate_Scenario.Matrix.UB(UBMat).name;
        
        %%% Initialize optimization variables
        Particles.Carbonate_particle(i).pos.Matrix.UB.name_Velocity= Init_Vel; % Velocity of name. Because the algorithm changes UB Mineralogy as it goes through iterations
        Particles.Carbonate_particle(i).pos.Matrix.UB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Carbonate_Scenario.Matrix.UB), 3);  % Optimization particle Velocity(Values)
        
        for ttt= 1:length(ModelBounds.Carbonate_Scenario.Matrix.UB)  % Choose random values for all probable UB Mineralogy(Rho, K, Mu)
            Particles.Carbonate_particle(i).pos.Matrix.UB.Values(ttt, 1:3)= ModelBounds.Carbonate_Scenario.Matrix.UB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Carbonate_Scenario.Matrix.UB(ttt).bounds(2,:)-ModelBounds.Carbonate_Scenario.Matrix.UB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.UB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    
    %%% Pick Fluids
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Super_RES')    % pick a random Super_RES Fluid then pick Matrices of variables
        Super_RESFL= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Fluid.Super_RES)-1));
        Flname= ModelBounds.Carbonate_Scenario.Fluid.Super_RES{Super_RESFL};
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_number= Super_RESFL;
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name= Flname;
        Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name_Velocity= Init_Vel;       % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Ind_RES')    % pick a random Ind RES Fluid then pick Matrices of variables
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_RESFL= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})))-1));
            Flname= ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_RESFL};
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_RESFL;
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Init_Vel;
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
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'OB')    % pick a random OB Fluid then pick Matrices of variables
        OBFL= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Fluid.OB)-1));
        Flname= ModelBounds.Carbonate_Scenario.Fluid.OB{OBFL};
        Particles.Carbonate_particle(i).pos.Fluid.OB.name_number= OBFL;
        Particles.Carbonate_particle(i).pos.Fluid.OB.name= Flname;
        Particles.Carbonate_particle(i).pos.Fluid.OB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'UB')    % pick a random UB Fluid then pick Matrices of variables
        UBFL= round(1+rand*(length(ModelBounds.Carbonate_Scenario.Fluid.UB)-1));
        Flname= ModelBounds.Carbonate_Scenario.Fluid.UB{UBFL};
        Particles.Carbonate_particle(i).pos.Fluid.UB.name_number= UBFL;
        Particles.Carbonate_particle(i).pos.Fluid.UB.name= Flname;
        Particles.Carbonate_particle(i).pos.Fluid.UB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    %%%%%%%%%%%
    
    %%% Pick SW
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Super_RES')
        SupRESflnum= length(ModelBounds.Carbonate_Scenario.Fluid.Super_RES);
        Particles.Carbonate_particle(i).pos.SW.Super_RES.Velocity= Init_Vel*ones(SupRESflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Carbonate_Scenario.SW.Super_RES(1)+ rand(SupRESflnum, 1).*(ModelBounds.Carbonate_Scenario.SW.Super_RES(2)-ModelBounds.Carbonate_Scenario.SW.Super_RES(1));
        Particles.Carbonate_particle(i).pos.SW.Super_RES.Value= TempSW./100;   % SW in fraction   % SW in fraction
    end
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'Ind_RES')    % pick a random Ind RES SWs
        ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            IndRESfl= length(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity= Init_Vel*ones(IndRESfl ,1);  % Optimization particle Velocity
            TempSW= ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1)+ rand(IndRESfl ,1).*(ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2)-ModelBounds.Carbonate_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1));
            Particles.Carbonate_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value= TempSW./100;   % SW in fraction
        end
    end
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'OB')    % pick a random OB SW
        OBflnum= length(ModelBounds.Carbonate_Scenario.Fluid.OB);
        Particles.Carbonate_particle(i).pos.SW.OB.Velocity= Init_Vel*ones(OBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Carbonate_Scenario.SW.OB(1)+ rand(OBflnum, 1).*(ModelBounds.Carbonate_Scenario.SW.OB(2)-ModelBounds.Carbonate_Scenario.SW.OB(1));
        Particles.Carbonate_particle(i).pos.SW.OB.Value= TempSW./100;   % SW in fraction
    end
    if isfield(ModelBounds.Carbonate_Scenario.SW, 'UB')    % pick a random UB SW
        UBflnum= length(ModelBounds.Carbonate_Scenario.Fluid.UB);
        Particles.Carbonate_particle(i).pos.SW.UB.Velocity= Init_Vel*ones(UBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Carbonate_Scenario.SW.UB(1)+ rand(UBflnum, 1).*(ModelBounds.Carbonate_Scenario.SW.UB(2)-ModelBounds.Carbonate_Scenario.SW.UB(1));
        Particles.Carbonate_particle(i).pos.SW.UB.Value= TempSW./100;   % SW in fraction
    end
    %%%%%%%%%%%
    
    %%% Pick Porosity
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPOR= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(1)/100;
        MaxPOR= ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Bounds(2)/100;
        if ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 1
            Porvalue= MinPOR+rand*(MaxPOR - MinPOR);
            PorMatrix= Porvalue*MODEL.(genvarname(c)).Matrix;
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Type= 1;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Porvalue= Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Velocity= Init_Vel;
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 2
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Type= 2;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;
            
        elseif ModelBounds.Carbonate_Scenario.POR.(genvarname(c)).Type== 3
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            Mid_Left_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Left Porosity Value
            Mid_Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Right Porosity Value
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Type= 3;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_MidZone= Left_MidZone;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_MidZone= Right_MidZone;
            
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Init_Vel;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Init_Vel;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Carbonate_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;
            
        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
        % % here we save the final Porosity matrix. "Make it Comment with large size Data".
        Particles.Carbonate_particle(i).pos.POR.FullMatrix= Phi;
    end
    
    %%% at this stage we finish picking values for MODEL initialization
    %% Rho and Vp for saturated rock
    % We want to calculate Bulk Rho, Bulk Vp for Super_RES, Ind_RES, OB, UB
    % with Brine as saturation fluid, then if the chosen fluid is not
    % Brine we do Gassman's substitutions
    % Note: BulkRho= MaRho(1-Phi) + FlRho*Phi   The Volumetric average equation
    
    % BulkVp= There are three empirical folrmulaions to calculate Bulk Vp
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
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: km/s = 0.0003048 * ft/s
        BulkVp_Super_RES_GGG= TempVp .* MODEL.Super_RES.Matrix ;  % extract Super_RES coordinates
        
        if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Super_RES.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in carbonates(we are now in Carbonate Scenario)
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
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: km/s = 0.0003048 * ft/s
            BulkVp_Ind_RES_GGG= TempVp.* MODEL.(genvarname(ind_Entities{iter})).Matrix;  % extract current Ind_RES coordinates
            
            if ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Brine') && ~strcmp(Particles.Carbonate_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name, 'Fresh Water')
                %% Start of gassmans substitution
                %%%%%%%%%%%%%%%% RHG
                %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
                % the next empirical formula is valid in carbonates(we are now in Carbonate Scenario)
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
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: km/s = 0.0003048 * ft/s
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
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: km/s = 0.0003048 * ft/s
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
    NumberOfSamples= 10/Sampling_Interval; % should be odd number
    NumberOfSamples= round(NumberOfSamples, 0);
    if mod(NumberOfSamples, 2)==0
        NumberOfSamples= NumberOfSamples+1;
    end
    Frequency= Particles.Carbonate_particle(i).Frequency.Value;
    t0= 0;   %% Peak must be in the middle to make the wavelet symmetric
    [rw, ~] = Edited_ricker(Frequency, NumberOfSamples, Sampling_Interval, t0);
    
    Wavelet= Polarity.*rw;
    
    %%%%%%%%%%%%%%%%% Convolution %%%%%%%%%%%%%%%%%%%%%%
    %%% RHG
    Synthetic_RHG= conv2(Wavelet, 1, RC_Matrix_RHG);
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
    Particles.Carbonate_particle(i).iteration= 1;
end

if ~isempty(Clastics_Scenario_Num)      % if there is Clastics Scenario then do the following
    %%% Pick Frequency
    Particles.Clastics_particle(i).Frequency.Velocity= Init_Vel;
    Particles.Clastics_particle(i).Frequency.Value= ModelBounds.Frequency(1)+ rand.*(ModelBounds.Frequency(2)-ModelBounds.Frequency(1));
    %%%%%%%%%%%
    
    %%% Pick Matrix
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'RES')   % RES Matrix is Clastics
        Particles.Clastics_particle(i).pos.Matrix.RES.name= 'Clastics';
        %%% Note: pos.Matrix.RES.Values= [MaRho K_Modulus Mu_Modulus];
        
        %%% Initialize optimization variables
        Particles.Clastics_particle(i).pos.Matrix.RES.Values_Velocity= Init_Vel*ones(1, 3);  % Optimization particle Velocity(Values)
        Particles.Clastics_particle(i).pos.Matrix.RES.Values= zeros(1, 3);
        
        Particles.Clastics_particle(i).pos.Matrix.RES.Values= ModelBounds.Clastics_Scenario.Matrix.RES(1,:)+ rand(1, 3).*(ModelBounds.Clastics_Scenario.Matrix.RES(2,:)-ModelBounds.Clastics_Scenario.Matrix.RES(1,:));
        %%% Note: pos.Matrix.RES.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        OBMat= round(1+rand*(length(ModelBounds.Clastics_Scenario.Matrix.OB)-1));     % pick a random Mineral number
        Particles.Clastics_particle(i).pos.Matrix.OB.name_number= OBMat;
        Particles.Clastics_particle(i).pos.Matrix.OB.name= ModelBounds.Clastics_Scenario.Matrix.OB(OBMat).name;
        
        %%% Initialize optimization variables
        Particles.Clastics_particle(i).pos.Matrix.OB.name_Velocity= Init_Vel;
        Particles.Clastics_particle(i).pos.Matrix.OB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Clastics_Scenario.Matrix.OB), 3);  % Optimization particle Velocity(Values)
        
        for ttt= 1:length(ModelBounds.Clastics_Scenario.Matrix.OB)
            Particles.Clastics_particle(i).pos.Matrix.OB.Values(ttt, 1:3)= ModelBounds.Clastics_Scenario.Matrix.OB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Clastics_Scenario.Matrix.OB(ttt).bounds(2,:)-ModelBounds.Clastics_Scenario.Matrix.OB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.OB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Clastics_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        UBMat= round(1+rand*(length(ModelBounds.Clastics_Scenario.Matrix.UB)-1));     % pick a random Mineral number
        Particles.Clastics_particle(i).pos.Matrix.UB.name_number= UBMat;
        Particles.Clastics_particle(i).pos.Matrix.UB.name= ModelBounds.Clastics_Scenario.Matrix.UB(UBMat).name;
        
        %%% Initialize optimization variables
        Particles.Clastics_particle(i).pos.Matrix.UB.name_Velocity= Init_Vel;
        Particles.Clastics_particle(i).pos.Matrix.UB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Clastics_Scenario.Matrix.UB), 3);  % Optimization particle Velocity(Values)
        
        for ttt= 1:length(ModelBounds.Clastics_Scenario.Matrix.UB)
            Particles.Clastics_particle(i).pos.Matrix.UB.Values(ttt, 1:3)= ModelBounds.Clastics_Scenario.Matrix.UB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Clastics_Scenario.Matrix.UB(ttt).bounds(2,:)-ModelBounds.Clastics_Scenario.Matrix.UB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.UB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    
    
    %%% Pick Fluids
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Super_RES')    % pick a random Super_RES Fluid then pick Matrices of variables
        Super_RESFL= round(1+rand*(length(ModelBounds.Clastics_Scenario.Fluid.Super_RES)-1));
        Flname= ModelBounds.Clastics_Scenario.Fluid.Super_RES{Super_RESFL};
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_number= Super_RESFL;
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name= Flname;
        Particles.Clastics_particle(i).pos.Fluid.Super_RES.name_Velocity= Init_Vel;       % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Ind_RES')    % pick a random Ind RES Fluid then pick Matrices of variables
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_RESFL= round(1+rand*(length(ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})))-1));
            Flname= ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_RESFL};
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_RESFL;
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            Particles.Clastics_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Init_Vel;
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
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'OB')    % pick a random OB Fluid then pick Matrices of variables
        OBFL= round(1+rand*(length(ModelBounds.Clastics_Scenario.Fluid.OB)-1));
        Flname= ModelBounds.Clastics_Scenario.Fluid.OB{OBFL};
        Particles.Clastics_particle(i).pos.Fluid.OB.name_number= OBFL;
        Particles.Clastics_particle(i).pos.Fluid.OB.name= Flname;
        Particles.Clastics_particle(i).pos.Fluid.OB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Clastics_Scenario.Fluid, 'UB')    % pick a random UB Fluid then pick Matrices of variables
        UBFL= round(1+rand*(length(ModelBounds.Clastics_Scenario.Fluid.UB)-1));
        Flname= ModelBounds.Clastics_Scenario.Fluid.UB{UBFL};
        Particles.Clastics_particle(i).pos.Fluid.UB.name_number= UBFL;
        Particles.Clastics_particle(i).pos.Fluid.UB.name= Flname;
        Particles.Clastics_particle(i).pos.Fluid.UB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    %%%%%%%%%%%
    
    %%% Pick SW
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Super_RES')
        SupRESflnum= length(ModelBounds.Clastics_Scenario.Fluid.Super_RES);
        Particles.Clastics_particle(i).pos.SW.Super_RES.Velocity= Init_Vel*ones(SupRESflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Clastics_Scenario.SW.Super_RES(1)+ rand(SupRESflnum, 1).*(ModelBounds.Clastics_Scenario.SW.Super_RES(2)-ModelBounds.Clastics_Scenario.SW.Super_RES(1));
        Particles.Clastics_particle(i).pos.SW.Super_RES.Value= TempSW./100;   % SW in fraction   % SW in fraction
    end
    if isfield(ModelBounds.Clastics_Scenario.SW, 'Ind_RES')    % pick a random Ind RES SWs
        ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            IndRESfl= length(ModelBounds.Clastics_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity= Init_Vel*ones(IndRESfl ,1);  % Optimization particle Velocity
            TempSW= ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1)+ rand(IndRESfl ,1).*(ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2)-ModelBounds.Clastics_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1));
            Particles.Clastics_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value= TempSW./100;   % SW in fraction
        end
    end
    if isfield(ModelBounds.Clastics_Scenario.SW, 'OB')    % pick a random OB SW
        OBflnum= length(ModelBounds.Clastics_Scenario.Fluid.OB);
        Particles.Clastics_particle(i).pos.SW.OB.Velocity= Init_Vel*ones(OBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Clastics_Scenario.SW.OB(1)+ rand(OBflnum, 1).*(ModelBounds.Clastics_Scenario.SW.OB(2)-ModelBounds.Clastics_Scenario.SW.OB(1));
        Particles.Clastics_particle(i).pos.SW.OB.Value= TempSW./100;   % SW in fraction
    end
    if isfield(ModelBounds.Clastics_Scenario.SW, 'UB')    % pick a random UB SW
        UBflnum= length(ModelBounds.Clastics_Scenario.Fluid.UB);
        Particles.Clastics_particle(i).pos.SW.UB.Velocity= Init_Vel*ones(UBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Clastics_Scenario.SW.UB(1)+ rand(UBflnum, 1).*(ModelBounds.Clastics_Scenario.SW.UB(2)-ModelBounds.Clastics_Scenario.SW.UB(1));
        Particles.Clastics_particle(i).pos.SW.UB.Value= TempSW./100;   % SW in fraction
    end
    %%%%%%%%%%%
    
    %%% Pick Porosity
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPOR= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(1)/100;
        MaxPOR= ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Bounds(2)/100;
        if ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 1
            Porvalue= MinPOR+rand*(MaxPOR - MinPOR);
            PorMatrix= Porvalue*MODEL.(genvarname(c)).Matrix;
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Type= 1;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Porvalue= Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Velocity= Init_Vel;
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 2
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Type= 2;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;
            
        elseif ModelBounds.Clastics_Scenario.POR.(genvarname(c)).Type== 3
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            Mid_Left_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Left Porosity Value
            Mid_Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Right Porosity Value
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Type= 3;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_MidZone= Left_MidZone;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_MidZone= Right_MidZone;
            
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Init_Vel;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Init_Vel;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Clastics_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;

        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
        % % here we save the final Porosity matrix. "Make it Comment with large size Data"
        Particles.Clastics_particle(i).pos.POR.FullMatrix= Phi;
    end
    
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
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: km/s = 0.0003048 * ft/s
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
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: km/s = 0.0003048 * ft/s
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
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: km/s = 0.0003048 * ft/s
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
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: km/s = 0.0003048 * ft/s
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
    Particles.Clastics_particle(i).iteration= 1;
end

if ~isempty(Basalt_Scenario_Num)      % if there is Basalt Scenario then do the following
    %%% Pick Frequency
    Particles.Basalt_particle(i).Frequency.Velocity= Init_Vel;
    Particles.Basalt_particle(i).Frequency.Value= ModelBounds.Frequency(1)+ rand.*(ModelBounds.Frequency(2)-ModelBounds.Frequency(1));
    %%%%%%%%%%%
    
    %%% Pick Matrix
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'RES')   % RES Matrix is Basalt
        Particles.Basalt_particle(i).pos.Matrix.RES.name= 'Basalt';
        %%% Note: pos.Matrix.RES.Values= [MaRho K_Modulus Mu_Modulus];
        
        %%% Initialize optimization variables
        Particles.Basalt_particle(i).pos.Matrix.RES.Values_Velocity= Init_Vel*ones(1, 3);  % Optimization particle Velocity(Values)
        Particles.Basalt_particle(i).pos.Matrix.RES.Values= zeros(1, 3);
        
        Particles.Basalt_particle(i).pos.Matrix.RES.Values= ModelBounds.Basalt_Scenario.Matrix.RES(1,:)+ rand(1, 3).*(ModelBounds.Basalt_Scenario.Matrix.RES(2,:)-ModelBounds.Basalt_Scenario.Matrix.RES(1,:));
        %%% Note: pos.Matrix.RES.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'OB')    % pick a random OB Mineralogy then pick values of variables
        OBMat= round(1+rand*(length(ModelBounds.Basalt_Scenario.Matrix.OB)-1));     % pick a random Mineral number
        Particles.Basalt_particle(i).pos.Matrix.OB.name_number= OBMat;
        Particles.Basalt_particle(i).pos.Matrix.OB.name= ModelBounds.Basalt_Scenario.Matrix.OB(OBMat).name;
        
        %%% Initialize optimization variables
        Particles.Basalt_particle(i).pos.Matrix.OB.name_Velocity= Init_Vel;
        Particles.Basalt_particle(i).pos.Matrix.OB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Basalt_Scenario.Matrix.OB), 3);  % Optimization particle Velocity(Values)
        
        for ttt= 1:length(ModelBounds.Basalt_Scenario.Matrix.OB)
            Particles.Basalt_particle(i).pos.Matrix.OB.Values(ttt, 1:3)= ModelBounds.Basalt_Scenario.Matrix.OB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Basalt_Scenario.Matrix.OB(ttt).bounds(2,:)-ModelBounds.Basalt_Scenario.Matrix.OB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.OB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    if isfield(ModelBounds.Basalt_Scenario.Matrix, 'UB')    % pick a random UB Mineralogy then pick values of variables
        UBMat= round(1+rand*(length(ModelBounds.Basalt_Scenario.Matrix.UB)-1));     % pick a random Mineral number
        Particles.Basalt_particle(i).pos.Matrix.UB.name_number= UBMat;
        Particles.Basalt_particle(i).pos.Matrix.UB.name= ModelBounds.Basalt_Scenario.Matrix.UB(UBMat).name;
        
        %%% Initialize optimization variables
        Particles.Basalt_particle(i).pos.Matrix.UB.name_Velocity= Init_Vel;
        Particles.Basalt_particle(i).pos.Matrix.UB.Values_Velocity= Init_Vel*ones(length(ModelBounds.Basalt_Scenario.Matrix.UB), 3);  % Optimization particle Velocity(Values)
        
        for ttt= 1:length(ModelBounds.Basalt_Scenario.Matrix.UB)
            Particles.Basalt_particle(i).pos.Matrix.UB.Values(ttt, 1:3)= ModelBounds.Basalt_Scenario.Matrix.UB(ttt).bounds(1,:)+ rand(1, 3).*(ModelBounds.Basalt_Scenario.Matrix.UB(ttt).bounds(2,:)-ModelBounds.Basalt_Scenario.Matrix.UB(ttt).bounds(1,:));
        end
        %%% Note: pos.Matrix.UB.Values= [MaRho K_Modulus Mu_Modulus];
    end
    %%%%%%%%%%%
    
    %%% Pick Fluids
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Super_RES')    % pick a random Super_RES Fluid then pick Matrices of variables
        Super_RESFL= round(1+rand*(length(ModelBounds.Basalt_Scenario.Fluid.Super_RES)-1));
        Flname= ModelBounds.Basalt_Scenario.Fluid.Super_RES{Super_RESFL};
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_number= Super_RESFL;
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name= Flname;
        Particles.Basalt_particle(i).pos.Fluid.Super_RES.name_Velocity= Init_Vel;       % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Ind_RES')    % pick a random Ind RES Fluid then pick Matrices of variables
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.Fluid.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            Ind_RES_RESFL= round(1+rand*(length(ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})))-1));
            Flname= ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})){Ind_RES_RESFL};
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_number= Ind_RES_RESFL;
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name= Flname;
            Particles.Basalt_particle(i).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name_Velocity= Init_Vel;
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
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'OB')    % pick a random OB Fluid then pick Matrices of variables
        OBFL= round(1+rand*(length(ModelBounds.Basalt_Scenario.Fluid.OB)-1));
        Flname= ModelBounds.Basalt_Scenario.Fluid.OB{OBFL};
        Particles.Basalt_particle(i).pos.Fluid.OB.name_number= OBFL;
        Particles.Basalt_particle(i).pos.Fluid.OB.name= Flname;
        Particles.Basalt_particle(i).pos.Fluid.OB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    
    if isfield(ModelBounds.Basalt_Scenario.Fluid, 'UB')    % pick a random UB Fluid then pick Matrices of variables
        UBFL= round(1+rand*(length(ModelBounds.Basalt_Scenario.Fluid.UB)-1));
        Flname= ModelBounds.Basalt_Scenario.Fluid.UB{UBFL};
        Particles.Basalt_particle(i).pos.Fluid.UB.name_number= UBFL;
        Particles.Basalt_particle(i).pos.Fluid.UB.name= Flname;
        Particles.Basalt_particle(i).pos.Fluid.UB.name_Velocity= Init_Vel;  % Optimization particle Velocity
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
    %%%%%%%%%%%
    
    %%% Pick SW
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Super_RES')
        SupRESflnum= length(ModelBounds.Basalt_Scenario.Fluid.Super_RES);
        Particles.Basalt_particle(i).pos.SW.Super_RES.Velocity= Init_Vel*ones(SupRESflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Basalt_Scenario.SW.Super_RES(1)+ rand(SupRESflnum, 1).*(ModelBounds.Basalt_Scenario.SW.Super_RES(2)-ModelBounds.Basalt_Scenario.SW.Super_RES(1));
        Particles.Basalt_particle(i).pos.SW.Super_RES.Value= TempSW./100;   % SW in fraction   % SW in fraction
    end
    if isfield(ModelBounds.Basalt_Scenario.SW, 'Ind_RES')    % pick a random Ind RES SWs
        ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.SW.Ind_RES); % Names of independent Entites
        ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
        for iter=1:ind_Entities_Number
            IndRESfl= length(ModelBounds.Basalt_Scenario.Fluid.Ind_RES.(genvarname(ind_Entities{iter})));
            Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Velocity= Init_Vel*ones(IndRESfl ,1);  % Optimization particle Velocity
            TempSW= ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1)+ rand(IndRESfl ,1).*(ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(2)-ModelBounds.Basalt_Scenario.SW.Ind_RES.(genvarname(ind_Entities{iter}))(1));
            Particles.Basalt_particle(i).pos.SW.Ind_RES.(genvarname(ind_Entities{iter})).Value= TempSW./100;   % SW in fraction
        end
    end
    if isfield(ModelBounds.Basalt_Scenario.SW, 'OB')    % pick a random OB SW
        OBflnum= length(ModelBounds.Basalt_Scenario.Fluid.OB);
        Particles.Basalt_particle(i).pos.SW.OB.Velocity= Init_Vel*ones(OBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Basalt_Scenario.SW.OB(1)+ rand(OBflnum, 1).*(ModelBounds.Basalt_Scenario.SW.OB(2)-ModelBounds.Basalt_Scenario.SW.OB(1));
        Particles.Basalt_particle(i).pos.SW.OB.Value= TempSW./100;   % SW in fraction
    end
    if isfield(ModelBounds.Basalt_Scenario.SW, 'UB')    % pick a random UB SW
        UBflnum= length(ModelBounds.Basalt_Scenario.Fluid.UB);
        Particles.Basalt_particle(i).pos.SW.UB.Velocity= Init_Vel*ones(UBflnum, 1);      % Optimization particle Velocity
        TempSW= ModelBounds.Basalt_Scenario.SW.UB(1)+ rand(UBflnum, 1).*(ModelBounds.Basalt_Scenario.SW.UB(2)-ModelBounds.Basalt_Scenario.SW.UB(1));
        Particles.Basalt_particle(i).pos.SW.UB.Value= TempSW./100;   % SW in fraction
    end
    %%%%%%%%%%%
    
    %%% Pick Porosity
    Phi= 0;
    for Num_Entity=1:NumberofEntities
        N = num2str(Num_Entity);       % Convert Entity Number to String
        c=['Entity' N];                % Create string variable named c, Contains Entity+its number
        MinPOR= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(1)/100;
        MaxPOR= ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Bounds(2)/100;
        if ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 1
            Porvalue= MinPOR+rand*(MaxPOR - MinPOR);
            PorMatrix= Porvalue*MODEL.(genvarname(c)).Matrix;
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Type= 1;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Porvalue= Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Velocity= Init_Vel;
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 2
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            
            PorROW= linspace(Left_Porvalue, Right_Porvalue, (RightCol - LeftCol) +1);  % Create Prorosity distribution Row
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix ,2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Type= 2;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;
            
        elseif ModelBounds.Basalt_Scenario.POR.(genvarname(c)).Type== 3
            LeftCol= MODEL.(genvarname(c)).First_Column;
            RightCol= MODEL.(genvarname(c)).Last_Column;
            
            Left_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Left_MidZone;
            Right_MidZone= MODEL.(genvarname(c)).Geology.Porosity.Right_MidZone;
            
            Max_Range= MODEL.(genvarname(c)).Geology.Porosity.PorMax_Range/100;
            Left_Porvalue= MinPOR+rand*(MaxPOR - MinPOR);  % pick Left Porosity Value
            Mid_Left_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Left Porosity Value
            Mid_Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Middle-Right Porosity Value
            Right_Porvalue= max(MinPOR, Left_Porvalue-Max_Range) + rand*(min(MaxPOR, Left_Porvalue+Max_Range) - max(MinPOR, Left_Porvalue-Max_Range));  % pick Right Porosity Value
            
            
            PorROW_left= linspace(Left_Porvalue, Mid_Left_Porvalue, (Left_MidZone - LeftCol) + 1);  % Create Prorosity distribution Left wing
            PorROW_Mid= linspace(Mid_Left_Porvalue, Mid_Right_Porvalue, (Right_MidZone - Left_MidZone) +1);    % Create Prorosity distribution Middle Area
            PorROW_Right= linspace(Mid_Right_Porvalue, Right_Porvalue, (RightCol - Right_MidZone) + 1);  % Create Prorosity distribution Right wing
            
            PorROW= [PorROW_left(1:end-1) PorROW_Mid PorROW_Right(2:end)];
            FullRow= zeros(1, size(MODEL.(genvarname(c)).Matrix, 2));
            FullRow(1, LeftCol:RightCol)= PorROW;   % Create Full Row of POR distribution
            
            PorMatrix= FullRow .* (MODEL.(genvarname(c)).Matrix); % Create Full Matrix of POR distribution
            
            % We don't want to save the whole matrix, just save the
            % Parameters to initialize it (it takes a big space to save it all)
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Type= 3;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).LeftCol= LeftCol;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).RightCol= RightCol;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_MidZone= Left_MidZone;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_MidZone= Right_MidZone;
            
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue= Left_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Left_Porvalue_Velocity= Init_Vel;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue= Mid_Left_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Left_Porvalue_Velocity= Init_Vel;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue= Mid_Right_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Mid_Right_Porvalue_Velocity= Init_Vel;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue= Right_Porvalue;
            Particles.Basalt_particle(i).pos.POR.(genvarname(c)).Right_Porvalue_Velocity= Init_Vel;

        end
        Phi= Phi + PorMatrix; % This matrix is essential for Bulk Rho and Vp calculation
        % % here we save the final Porosity matrix, Make it Comment with large size Data, Make it Comment with large size Data
        Particles.Basalt_particle(i).pos.POR.FullMatrix= Phi;
    end
    
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
        TempVp= 0.0003048.*(BulkRho_Super_RES/0.23).^4;      % in km/s note: km/s = 0.0003048 * ft/s
        BulkVp_Super_RES_GGG= TempVp .* MODEL.Super_RES.Matrix ;  % extract Super_RES coordinates
        
        if ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Super_RES.name, 'Brine') && ~strcmp(Particles.Basalt_particle(i).pos.Fluid.Super_RES.name, 'Fresh Water')
            %% Start of gassmans substitution
            %%%%%%%%%%%%%%%% RHG
            %%% derive Bulk Vs From Bulk Vp, it is essential for Calculation
            % the next empirical formula is valid in Basalts(we are now in Basalt Scenarion)
            tempVs= BulkVp_Super_RES_RHG ./ 1.7 ; % in Km/s
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
            TempVp= 0.0003048.*(BulkRho_Ind_RES/0.23).^4;     % in km/s note: km/s = 0.0003048 * ft/s
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
        TempVp= 0.0003048.*(BulkRho_OB/0.23).^4;         % in km/s note: km/s = 0.0003048 * ft/s
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
        TempVp= 0.0003048.*(BulkRho_UB/0.23).^4;          % in km/s note: km/s = 0.0003048 * ft/s
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
    
    Particles.Basalt_particle(i).final_cost= final;
    Particles.Basalt_particle(i).VpEq= type;  % velocity formula with least misfit
    Particles.Basalt_particle(i).Scenario= 3;   % 3 means Basalt
    Particles.Basalt_particle(i).Bulk_Density_Model= BulkRho_Total_Matrix;
    Particles.Basalt_particle(i).Velocity_Model= Velocity_Model;
    Particles.Basalt_particle(i).Synthetic= Synthetic;
    Particles.Basalt_particle(i).iteration= 1;
end
%%%%% End of creating particles

%% Redo the function for NP times
if i<NP
    i= i+1;
    PSO_Particles_Creator(handles)
end