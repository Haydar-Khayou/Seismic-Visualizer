function BAT_Main_Loop(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% variables
global i T iteration alpha gBat bBats Bats Car_Num Clas_Num Bas_Num
global Car_Monitor_Num Clas_Monitor_Num Bas_Monitor_Num emission_rate init_emission_rate gamma loudness

%% main loop
% in this section we start the optimization process by regenerating
% particles by changing Bats' velocities and choosing the best local, global results.

tic
loudness= alpha*loudness;
emission_rate= init_emission_rate*(1-exp(-gamma*iteration));
i= 1;
BAT_Variables_Modifier(handles)

% Carbonate
if ~isempty(Car_Num)
    [~, index]= min([bBats.Carbonate.final_cost]);
    gBat.Scenarios(Car_Num)= bBats.Carbonate(index);
    gBat.Scenarios(Car_Num).loudness= loudness;
    gBat.Scenarios(Car_Num).emission_rate= emission_rate;
    if gBat.Scenarios(Car_Num).final_cost < gBat.Global.Car(end).final_cost
        gBat.Global.Car(end+1)= gBat.Scenarios(Car_Num);
    end
    % Save average misfit of particles
    gBat.Global.Car_avr_Bats(end+1)= mean([Bats.Carbonate.final_cost]);
    
    % Save average misfit of bparticles
    gBat.Global.Car_avr_bBats(end+1)= mean([bBats.Carbonate.final_cost]);

    % Save Best misfit each iteration
    gBat.Global.Car_ObjFun(end+1)= gBat.Scenarios(Car_Num).final_cost;
end

% Clastics
if ~isempty(Clas_Num)
    [~, index]= min([bBats.Clastics.final_cost]);
    gBat.Scenarios(Clas_Num)= bBats.Clastics(index);
    gBat.Scenarios(Clas_Num).loudness= loudness;
    gBat.Scenarios(Clas_Num).emission_rate= emission_rate;    
    if gBat.Scenarios(Clas_Num).final_cost < gBat.Global.Clas(end).final_cost
        gBat.Global.Clas(end+1)= gBat.Scenarios(Clas_Num);
    end
    % Save average misfit of particles
    gBat.Global.Clas_avr_Bats(end+1)= mean([Bats.Clastics.final_cost]);
    
    % Save average misfit of bparticles
    gBat.Global.Clas_avr_bBats(end+1)= mean([bBats.Clastics.final_cost]);
    
    % Save Best misfit each iteration
    gBat.Global.Clas_ObjFun(end+1)= gBat.Scenarios(Clas_Num).final_cost;
   
end

% Basalt
if ~isempty(Bas_Num)
    [~, index]= min([bBats.Basalt.final_cost]);
    gBat.Scenarios(Bas_Num)= bBats.Basalt(index);
    gBat.Scenarios(Bas_Num).loudness= loudness;
    gBat.Scenarios(Bas_Num).emission_rate= emission_rate;    
    if gBat.Scenarios(Bas_Num).final_cost < gBat.Global.Bas(end).final_cost
        gBat.Global.Bas(end+1)= gBat.Scenarios(Bas_Num);
    end
    % Save average misfit of particles
    gBat.Global.Bas_avr_Bats(end+1)= mean([Bats.Basalt.final_cost]);
    
    % Save average misfit of bparticles
    gBat.Global.Bas_avr_bBats(end+1)= mean([bBats.Basalt.final_cost]);
    
    % Save Best misfit each iteration
    gBat.Global.Bas_ObjFun(end+1)= gBat.Scenarios(Bas_Num).final_cost;
    
end

%% Save Monitoring Bats

if ~isempty(Car_Num)
    gBat.Monitoring_Bats(iteration).Carbonate= Bats.Carbonate(Car_Monitor_Num);
end
if ~isempty(Clas_Num)
    gBat.Monitoring_Bats(iteration).Clastics= Bats.Clastics(Clas_Monitor_Num);
end
if ~isempty(Bas_Num)
    gBat.Monitoring_Bats(iteration).Basalt= Bats.Basalt(Bas_Monitor_Num);
end


iteration

toc
% Redo the function for T times

if iteration<T
    iteration= iteration+1;
    BAT_Main_Loop(handles)
end
