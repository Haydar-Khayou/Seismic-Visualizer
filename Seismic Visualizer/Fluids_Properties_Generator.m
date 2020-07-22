function Fluids_Properties_Generator(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Note: In this Function we generate proprties of probable fluids for each Entity so that they
%        are ready to be used immediately by the algorithm.

%% Parameters
MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities'); % Get total number of entities

T= MODEL.EnvironmentalProperties.Temperature_Matrix;  % Celsious Degree.
P= MODEL.EnvironmentalProperties.Pressure_Matrix;     % MPa  where: 1 atmosphere= 0.101325 MPa.

%%% Create Major Fluids Properties Matrices(Sum of Entities Fluids' Properties)

% Create Brine Salinity Matrix for the whole section
% The loops for creating Entities' fluid properties are because each Entity
% could have its own fluid parameters.
S= 0;
for Num_Entity=1:NumberofEntities
    N= num2str(Num_Entity);         % Convert Entity Number to String
    c= ['Entity' N];                % Create string variable named c, Contains Entity+its number
    S_Temp= MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.Brine_Salinity .* MODEL.(genvarname(c)).Matrix;
    S= S + S_Temp;                 % Salinity in (ppm)
end
S= S/100000;    % Salinity in weight fraction

% Create GOR Matrix for the whole section
GOR= 0;
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    GOR_Temp= MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GOR .* MODEL.(genvarname(c)).Matrix;
    GOR= GOR + GOR_Temp;           % gas to oil ratio in (litre/litre).
end

% Create Oil Density Matrix for the whole section
rho_o= 0;
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    rho_o_Temp= MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.OilAPIGravity .* MODEL.(genvarname(c)).Matrix;
    rho_o= rho_o + rho_o_Temp;     % density of oil (API) is the reference density of oil measured at 15.6 C and atmospheric pressure.
end
rho_o = 141.5./(rho_o+131.5);      % density of oil in g/cm3 (from API)

% Create specific gravity of gas Matrix for the whole section
S_G_gas= 0;
for Num_Entity=1:NumberofEntities
    N= num2str(Num_Entity);              % Convert Entity Number to String
    c= ['Entity' N];                     % Create string variable named c, Contains Entity+its number
    S_G_gas_Temp= MODEL.(genvarname(c)).Geology.FluidContent.FluidProperties.GasAPIGravity .* MODEL.(genvarname(c)).Matrix;
    S_G_gas= S_G_gas + S_G_gas_Temp;     % specific gravity of gas in(API)
end


%% Calculation of initial fluids

%%% Initial fluids means the direct not derived(substituted) properties of fluids

% 1-First Step is Calculating Brine Properties(Density, p-wave velocity, Bulk modulus)

% The Properties calculated here are MATRICES which means a grid of nodes
% of properties because T and P are distribution matrices that have the
% same size as the Seismic section(to be modelled)
% Note: Brine may have a salinity from 0% (Freshwater) to fully saturated
% solution, so Fresh water is brine.

%%%%%%%%%%%%%%%%%%% Density Of Brine (g/cm3)*********************
%%% Fresh Water Density (Rho_W) in (g/cm3)
Rho_Fwater = 1 + 10^-6 .*(-80.*T - 3.3.*T.^2 + 0.00175.*T.^3 + 489.*P - 2.*T.*P + 0.016.*T.^2.*P - 1.3.*10.^-5 .*T.^3 .*P - 0.333.*P.^2 - 0.002.*T.*P.^2);


%%% Brine Density (Rho_Brine) in (g/cm3) varies with salinity
Rho_Brine = Rho_Fwater + 0.668.*S + 0.44.*S.^2 + 10.^-6 .*S.*(300.*P - 2400.*P.*S + T.*(80 + 3.*T - 3300.*S - 13.*P + 47.*P.*S));


%%%%%%%%%%%%%%%%%%% Velocity Of Brine (m/S)*********************
%%% Preparing Coefficients
w(1,1) = 1402.85;                   w(1,3) = 3.437*10^(-3);
w(2,1) = 4.871;                     w(2,3) = 1.739*10^(-4);
w(3,1) = -0.04783;                  w(3,3) = -2.135*10^(-6);
w(4,1) = 1.487*10^(-4);             w(4,3) = -1.455*10^(-8);
w(5,1) = -2.197*10^(-7);            w(5,3) = 5.230*10^(-11);
w(1,2) = 1.524;                     w(1,4) = -1.197*10^(-5);
w(2,2) = -0.0111;                   w(2,4) = -1.628*10^(-6);
w(3,2) = 2.747*10^(-4);             w(3,4) = 1.237*10^(-8);
w(4,2) = -6.503*10^(-7);            w(4,4) = 1.327*10^(-10);
w(5,2) = 7.987*10^(-10);            w(5,4) = -4.614*10^(-13);



sum = 0;
for i=1:5
    for j=1:4
        sum = sum+w(i,j).*T.^(i-1).*P.^(j-1);
    end
end
v_Fwater= sum;      % velocity of Fresh water in (m/s)


% Velocity of Brine
v1 = 1170-9.6.*T + 0.055.*T.^2 - 8.5.*10.^-5.* T.^3 + 2.6.*P -0.0029.*T.*P -0.0476.*P.^2;
v_Brine = v_Fwater + S.*v1 + S.^1.5 .*(780-10.*P+0.16.*P.^2)-1820.*S.^2; % in (m/s)

%%%%%%%%%%%%%%%%%%% Bulk Modulus Of Brine in (GPa)*********************
K_Brine= Rho_Brine.*v_Brine.^2.* 10^-6;       % bulk modulus in (GPa)

%%%%%%%%%%%%%%%%%%% Bulk Modulus Of Fresh Water in (GPa)*********************
K_Fwater= Rho_Fwater.*v_Fwater.^2.* 10^-6;    % bulk modulus in (GPa)


% 2- Second Step is Calculating Oil Properties(Density, Velocity, Bulk modulus)
% These properties are essential in Gassman's substitution in order to recalculate
% Bulk density and velocity of a saturated rock in case we change the saturation
% to a fluid other than brine

% formation volume factor
B0 = 0.972+0.00038.*(2.495.*GOR.*sqrt(S_G_gas./rho_o)+T+17.8).^1.175;

% saturation density
rho_s = (rho_o+0.0012.*GOR.*S_G_gas)./B0;

% pseudo density
rho_ps = rho_o./((1+0.001.*GOR).*B0);


r1 = rho_s+(0.00277.*P -1.71*10^-7.*P.^3).* (rho_s-1.15).^2 + 3.49 * 10^-4 .*P;

% Oil density
Rho_Oil = r1./(0.972+3.81*10^-4 .*(T+17.78).^1.175);    % in (g/cm3)

% Oil velocity
v_Oil = 2096.*sqrt(rho_ps./(2.6-rho_ps))-3.7.*T +4.64 .*P + 0.0115 .*(sqrt(18.33./rho_ps-16.97)-1).*T.*P;  % in m/s

% Oil Bulk Modulus
K_Oil= Rho_Oil.* v_Oil.^2 .*10^-6;     % in (GPa)


% 3- Third Step is Calculating Gas Properties(Density, Bulk modulus)

R= 8.314;      % gas constant

Ta= T+273.15;    % Celsius to absolute Temperature
Ppr= P./(4.892-0.4048*S_G_gas);      % pseudo reduced pressure
Tpr= Ta./(94.72+170.75*S_G_gas);     % pseudo reduced temperature



E1 = exp(((-Ppr.^1.2)./Tpr).*(0.45+8.*(0.56-(1./Tpr)).^2));
E = 0.109.*(3.85-Tpr).^2.*E1;
Z1 = 0.03+0.00527.*(3.5-Tpr).^3;
Z = Z1.*Ppr+0.642.*Tpr-0.007.*Tpr.^4-0.52+E;   % compressibility factor

% Gas density
Rho_Gas = (28.8.*S_G_gas.*P)./(Z.*R.*Ta);    % in (g/cm3)


dz_dp = Z1+0.109.*((3.85-Tpr).^2).*E1.*(-1.2.*Ppr.^0.2./Tpr.*(0.45+8.*(0.56-1./Tpr).^2));
yo = 0.85+5.6./(Ppr+2)+27.1./(Ppr+3.5).^2-8.7.*exp(-0.65.*(Ppr+1));


% Gas Bulk Modulus
K_Gas = P.*yo./1000.*1.0./(1-Ppr./Z.*dz_dp);    % in (GPa)


% 4- fourth Step is Calculating Air Properties(Density, Bulk modulus)
Air_Density= 0.012;   % in (g/cm3)  you can choose another value
Air_BulkModulus= 1.2*10^-5;     % in GPa

Rho_Air= Air_Density* ones(size(K_Gas));   % Create Air_Rho Matrix
K_Air= Air_BulkModulus* ones(size(K_Gas));   % Create K_Rho Matrix

%% Save to MODEL

% Delete the previous savings
MODEL.Fluids_Properties_Matrices= '';
MODEL= rmfield(MODEL, 'Fluids_Properties_Matrices');


%%% remove any Previous savings
MODEL.OB= '';
MODEL= rmfield(MODEL, 'OB');
MODEL.Super_RES= '';
MODEL= rmfield(MODEL, 'Super_RES');
MODEL.Total_RES= '';
MODEL= rmfield(MODEL, 'Total_RES');
MODEL.UB= '';
MODEL= rmfield(MODEL, 'UB');

%%% Save RES, OB, UB Matrices
Total_RES_Matrix= 0;
RES_Matrix= 0;
OB_Matrix= 0;
UB_Matrix= 0;
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
            Total_RES_Matrix= Total_RES_Matrix + MODEL.(genvarname(c)).Matrix;
            MODEL.Total_RES.Matrix= Total_RES_Matrix;
            %%% Total_RES.Matrix is important for Matrix initialization
    end
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
        if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
            RES_Matrix= RES_Matrix + MODEL.(genvarname(c)).Matrix;
            MODEL.Super_RES.Matrix= RES_Matrix;
        end
    end
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
        OB_Matrix= OB_Matrix + MODEL.(genvarname(c)).Matrix;
        MODEL.OB.Matrix= OB_Matrix;
    end
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
        UB_Matrix= UB_Matrix + MODEL.(genvarname(c)).Matrix;
        MODEL.UB.Matrix= UB_Matrix;
    end
end


%% Extraction
% Extract all Fluid properties for each Entity and save them so that they are ready to be used


%%%%% The Next loop is for RES Independent Entities
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
        if MODEL.(genvarname(c)).Geology.FluidContent.Independent
            %%% Save Brine Properties matrix because it is essential for each Entity
            MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Brine.Rho= Rho_Brine.*MODEL.(genvarname(c)).Matrix;
            MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Brine.velocity= v_Brine.*MODEL.(genvarname(c)).Matrix;
            MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Brine.K= K_Brine.*MODEL.(genvarname(c)).Matrix;
            
            %%% Check what Fluids each Entity have
            Oil1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Oil'));
            Oil2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Oil'));
            Oil3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Oil'));
            Oil= [Oil1; Oil2; Oil3];
            
            Fw1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Fresh Water'));
            Fw2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Fresh Water'));
            Fw3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Fresh Water'));
            Fw= [Fw1; Fw2; Fw3];
            
            Gas1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Gas'));
            Gas2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Gas'));
            Gas3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Gas'));
            Gas= [Gas1; Gas2; Gas3];
            
            Air1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Air'));
            Air2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Air'));
            Air3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Air'));
            Air= [Air1; Air2; Air3];
            
            %%% Save Fluids properties Matrices
            if ~isempty(Oil)
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Oil.Rho= Rho_Oil.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Oil.velocity= v_Oil.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Oil.K= K_Oil.*MODEL.(genvarname(c)).Matrix;
            end
            
            if ~isempty(Fw)
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Fwater.Rho= Rho_Fwater.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Fwater.velocity= v_Fwater.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Fwater.K= K_Fwater.*MODEL.(genvarname(c)).Matrix;
            end
            
            if ~isempty(Gas)
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Gas.Rho= Rho_Gas.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Gas.K= K_Gas.*MODEL.(genvarname(c)).Matrix;
            end
            
            if ~isempty(Air)
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Air.Rho= Rho_Air.*MODEL.(genvarname(c)).Matrix;
                MODEL.(genvarname(c)).Geology.FluidContent.Fluids_Properties_Matrices.Air.K= K_Air.*MODEL.(genvarname(c)).Matrix;
            end
        end
    end
end



%%%%% The Next loop is for SuperRES Entities
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    RESCON= 0;
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'RES')
        if MODEL.(genvarname(c)).Geology.FluidContent.Independent== 0
            %%% Check what Fluids each Entity have
            Oil1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Oil'));
            Oil2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Oil'));
            Oil3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Oil'));
            Oil= [Oil1; Oil2; Oil3];
            
            Fw1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Fresh Water'));
            Fw2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Fresh Water'));
            Fw3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Fresh Water'));
            Fw= [Fw1; Fw2; Fw3];
            
            Gas1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Gas'));
            Gas2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Gas'));
            Gas3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Gas'));
            Gas= [Gas1; Gas2; Gas3];
            
            Air1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Air'));
            Air2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Air'));
            Air3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Air'));
            Air= [Air1; Air2; Air3];
            
            %%% Save Fluids properties Matrices
            %%% Save Brine Properties matrix because it is essential for each Entity
            MODEL.Super_RES.Fluids_Properties_Matrices.Brine.Rho= Rho_Brine.*RES_Matrix;
            MODEL.Super_RES.Fluids_Properties_Matrices.Brine.velocity= v_Brine.*RES_Matrix;
            MODEL.Super_RES.Fluids_Properties_Matrices.Brine.K= K_Brine.*RES_Matrix;
            
            if ~isempty(Oil)
                MODEL.Super_RES.Fluids_Properties_Matrices.Oil.Rho= Rho_Oil.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Oil.velocity= v_Oil.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Oil.K= K_Oil.*RES_Matrix;
            end
            
            if ~isempty(Fw)
                MODEL.Super_RES.Fluids_Properties_Matrices.Fwater.Rho= Rho_Fwater.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Fwater.velocity= v_Fwater.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Fwater.K= K_Fwater.*RES_Matrix;
            end
            
            if ~isempty(Gas)
                MODEL.Super_RES.Fluids_Properties_Matrices.Gas.Rho= Rho_Gas.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Gas.K= K_Gas.*RES_Matrix;
            end
            
            if ~isempty(Air)
                MODEL.Super_RES.Fluids_Properties_Matrices.Air.Rho= Rho_Air.*RES_Matrix;
                MODEL.Super_RES.Fluids_Properties_Matrices.Air.K= K_Air.*RES_Matrix;
            end
            RESCON= 1;
        end
        
    end
    if RESCON
        break;
    end
end



%%%%% The Next loop is for OB Entities
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    OBCON= 0;
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'OB')
        %%% Check what Fluids each Entity have
        Oil1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Oil'));
        Oil2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Oil'));
        Oil3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Oil'));
        Oil= [Oil1; Oil2; Oil3];
        
        Fw1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Fresh Water'));
        Fw2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Fresh Water'));
        Fw3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Fresh Water'));
        Fw= [Fw1; Fw2; Fw3];
        
        Gas1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Gas'));
        Gas2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Gas'));
        Gas3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Gas'));
        Gas= [Gas1; Gas2; Gas3];
        
        Air1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Air'));
        Air2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Air'));
        Air3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Air'));
        Air= [Air1; Air2; Air3];
        
        %%% Save Fluids properties Matrices
        %%% Save Brine Properties matrix because it is essential for each Entity
        MODEL.OB.Fluids_Properties_Matrices.Brine.Rho= Rho_Brine.*OB_Matrix;
        MODEL.OB.Fluids_Properties_Matrices.Brine.velocity= v_Brine.*OB_Matrix;
        MODEL.OB.Fluids_Properties_Matrices.Brine.K= K_Brine.*OB_Matrix;
        
        if ~isempty(Oil)
            MODEL.OB.Fluids_Properties_Matrices.Oil.Rho= Rho_Oil.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Oil.velocity= v_Oil.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Oil.K= K_Oil.*OB_Matrix;
        end
        
        if ~isempty(Fw)
            MODEL.OB.Fluids_Properties_Matrices.Fwater.Rho= Rho_Fwater.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Fwater.velocity= v_Fwater.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Fwater.K= K_Fwater.*OB_Matrix;
        end
        
        if ~isempty(Gas)
            MODEL.OB.Fluids_Properties_Matrices.Gas.Rho= Rho_Gas.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Gas.K= K_Gas.*OB_Matrix;
        end
        
        if ~isempty(Air)
            MODEL.OB.Fluids_Properties_Matrices.Air.Rho= Rho_Air.*OB_Matrix;
            MODEL.OB.Fluids_Properties_Matrices.Air.K= K_Air.*OB_Matrix;
        end
        OBCON= 1;
    end
    if OBCON
        break;
    end
end


%%%%% The Next loop is for UB Entities
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    UBCON= 0;
    if strcmp(MODEL.(genvarname(c)).Geology.Type, 'UB')
        %%% Check what Fluids each Entity have
        Oil1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Oil'));
        Oil2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Oil'));
        Oil3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Oil'));
        Oil= [Oil1; Oil2; Oil3];
        
        Fw1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Fresh Water'));
        Fw2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Fresh Water'));
        Fw3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Fresh Water'));
        Fw= [Fw1; Fw2; Fw3];
        
        Gas1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Gas'));
        Gas2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Gas'));
        Gas3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Gas'));
        Gas= [Gas1; Gas2; Gas3];
        
        Air1= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Carbonate_Sceinario.FluidsNames, 'Air'));
        Air2= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Clastics_Sceinario.FluidsNames, 'Air'));
        Air3= sum(strcmp(MODEL.(genvarname(c)).Geology.FluidContent.Basalt_Sceinario.FluidsNames, 'Air'));
        Air= [Air1; Air2; Air3];
        
        %%% Save Fluids properties Matrices
        %%% Save Brine Properties matrix because it is essential for each Entity
        MODEL.UB.Fluids_Properties_Matrices.Brine.Rho= Rho_Brine.*UB_Matrix;
        MODEL.UB.Fluids_Properties_Matrices.Brine.velocity= v_Brine.*UB_Matrix;
        MODEL.UB.Fluids_Properties_Matrices.Brine.K= K_Brine.*UB_Matrix;
        
        if ~isempty(Oil)
            MODEL.UB.Fluids_Properties_Matrices.Oil.Rho= Rho_Oil.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Oil.velocity= v_Oil.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Oil.K= K_Oil.*UB_Matrix;
        end
        
        if ~isempty(Fw)
            MODEL.UB.Fluids_Properties_Matrices.Fwater.Rho= Rho_Fwater.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Fwater.velocity= v_Fwater.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Fwater.K= K_Fwater.*UB_Matrix;
        end
        
        if ~isempty(Gas)
            MODEL.UB.Fluids_Properties_Matrices.Gas.Rho= Rho_Gas.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Gas.K= K_Gas.*UB_Matrix;
        end
        
        if ~isempty(Air)
            MODEL.UB.Fluids_Properties_Matrices.Air.Rho= Rho_Air.*UB_Matrix;
            MODEL.UB.Fluids_Properties_Matrices.Air.K= K_Air.*UB_Matrix;
        end
        UBCON= 1;
    end
    if UBCON
        break;
    end
end

% Attach the MODEL to the figure
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
