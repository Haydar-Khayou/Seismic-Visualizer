function PSO_Main_Loop(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% variables
global i T iteration W minW alpha gparticle bParticles Particles Car_Num Clas_Num Bas_Num
global Car_Monitor_Num Clas_Monitor_Num Bas_Monitor_Num 
%% main loop
% in this section we start the optimization process by regenerating
% particles by changing Particles' velocities and choosing the best local, global results.

tic
i= 1;
PSO_Particles_Variables_Modifier(handles)

%% Save Global particle
% In choosing the global best there are two approaches:
%   1. Choose the global best depending on NRMSE value: global=
%      min(bParticle.cost) which is the regular way. This way we focuse on
%      the overall matching neglecting the cell-to-cell matching.
%   2. Extract a matrix containing the least absolute error from all
%      bparticles, and create a porosity matrix according
%      to the least-error cells. This way we focus on the
%      details rather than the overall matching. This way is perfect for
%      full porosity inversion.


% Carbonate
if ~isempty(Car_Num)
    [~, index]= min([bParticles.Carbonate.final_cost]);
    gparticle.Scenarios(Car_Num)= bParticles.Carbonate(index);
    if gparticle.Scenarios(Car_Num).final_cost < gparticle.Global.Car(end).final_cost
        gparticle.Global.Car(end+1)= gparticle.Scenarios(Car_Num);
    end
    % Save average misfit of particles
    gparticle.Global.Car_avr_particles(end+1)= mean([Particles.Carbonate_particle.final_cost]);
    
    % Save average misfit of bparticles
    gparticle.Global.Car_avr_bparticles(end+1)= mean([bParticles.Carbonate.final_cost]);

    % Save Best misfit each iteration
    gparticle.Global.Car_ObjFun(end+1)= gparticle.Scenarios(Car_Num).final_cost;
end

% Clastics
if ~isempty(Clas_Num)
    [~, index]= min([bParticles.Clastics.final_cost]);
    gparticle.Scenarios(Clas_Num)= bParticles.Clastics(index);
    if gparticle.Scenarios(Clas_Num).final_cost < gparticle.Global.Clas(end).final_cost
        gparticle.Global.Clas(end+1)= gparticle.Scenarios(Clas_Num);
    end
    % Save average misfit of particles
    gparticle.Global.Clas_avr_particles(end+1)= mean([Particles.Clastics_particle.final_cost]);
    
    % Save average misfit of bparticles
    gparticle.Global.Clas_avr_bparticles(end+1)= mean([bParticles.Clastics.final_cost]);
    
    % Save Best misfit each iteration
    gparticle.Global.Clas_ObjFun(end+1)= gparticle.Scenarios(Clas_Num).final_cost;
   
end

% Basalt
if ~isempty(Bas_Num)
    [~, index]= min([bParticles.Basalt.final_cost]);
    gparticle.Scenarios(Bas_Num)= bParticles.Basalt(index);
    if gparticle.Scenarios(Bas_Num).final_cost < gparticle.Global.Bas(end).final_cost
        gparticle.Global.Bas(end+1)= gparticle.Scenarios(Bas_Num);
    end
    % Save average misfit of particles
    gparticle.Global.Bas_avr_particles(end+1)= mean([Particles.Basalt_particle.final_cost]);
    
    % Save average misfit of bparticles
    gparticle.Global.Bas_avr_bparticles(end+1)= mean([bParticles.Basalt.final_cost]);
    
    % Save Best misfit each iteration
    gparticle.Global.Bas_ObjFun(end+1)= gparticle.Scenarios(Bas_Num).final_cost;
    
end

%% Save Monitoring Particles

if ~isempty(Car_Num)
    gparticle.Monitoring_Particles(iteration).Carbonate= Particles.Carbonate_particle(Car_Monitor_Num);
end
if ~isempty(Clas_Num)
    gparticle.Monitoring_Particles(iteration).Clastics= Particles.Clastics_particle(Clas_Monitor_Num);
end
if ~isempty(Bas_Num)
    gparticle.Monitoring_Particles(iteration).Basalt= Particles.Basalt_particle(Bas_Monitor_Num);
end



W
iteration

toc
% Redo the function for T times

if iteration<T
    if W>minW
        W= W - alpha;
    end
    iteration= iteration+1;
    PSO_Main_Loop(handles)
end
