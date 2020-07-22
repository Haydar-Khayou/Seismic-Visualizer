global NumberofEntities
global Car_Num Clas_Num Bas_Num ModelBounds
Number_of_Scenarios= max([Car_Num Clas_Num Bas_Num]);
Ratio= 30/100;


%% Average NRMSE
Car_length= round(length(gparticle.Global.Car_ObjFun)*Ratio);
Clas_length= round(length(gparticle.Global.Clas_ObjFun)*Ratio);
Bas_length= round(length(gparticle.Global.Bas_ObjFun)*Ratio);

Car_NRMSE_Final= mean(gparticle.Global.Car_ObjFun(end - Car_length:end));
Clas_NRMSE_Final= mean(gparticle.Global.Clas_ObjFun(end - Clas_length:end));
Bas_NRMSE_Final= mean(gparticle.Global.Bas_ObjFun(end - Bas_length:end));

%% Average particles NRMSE

Car_length= round(length(gparticle.Global.Car_avr_particles)*Ratio);
Clas_length= round(length(gparticle.Global.Clas_avr_particles)*Ratio);
Bas_length= round(length(gparticle.Global.Bas_avr_particles)*Ratio);

Car_Particles_Final= mean(gparticle.Global.Car_avr_particles(end - Car_length:end));
Clas_Particles_Final= mean(gparticle.Global.Clas_avr_particles(end - Clas_length:end));
Bas_Particles_Final= mean(gparticle.Global.Bas_avr_particles(end - Bas_length:end));

%% Average bparticles NRMSE

Car_length= round(length(gparticle.Global.Car_avr_particles)*Ratio);
Clas_length= round(length(gparticle.Global.Clas_avr_particles)*Ratio);
Bas_length= round(length(gparticle.Global.Bas_avr_particles)*Ratio);

Car_bParticles_Final= mean(gparticle.Global.Car_avr_bparticles(end - Car_length:end));
Clas_bParticles_Final= mean(gparticle.Global.Clas_avr_bparticles(end - Clas_length:end));
Bas_bParticles_Final= mean(gparticle.Global.Bas_avr_bparticles(end - Bas_length:end));


%% Results

Res= [Car_NRMSE_Final, Clas_NRMSE_Final, Bas_NRMSE_Final;
      Car_bParticles_Final, Clas_bParticles_Final, Bas_bParticles_Final;
      Car_Particles_Final, Clas_Particles_Final, Bas_Particles_Final];


c= categorical({'Average NRMSE','Average bparticles NRMSE','Average particles NRMSE'});   
c= reordercats(c,{'Average NRMSE' 'Average bBats NRMSE' 'Average Bats NRMSE'});
figure; h= bar(c, Res);
title('Average Error for scenarios');
ylabel('NRMSE %')
legend({'Carbonates', 'Clastics', 'Basalt'})   
ddd= gca;
ddd.FontSize= 24;
ddd.XAxis.FontSize= 18;
h(1).FaceColor= 'b';
h(2).FaceColor= 'r';
h(3).FaceColor= 'y';

%% Velocity Models hist
VelProb= [gparticle.Global.Car.VpEq gparticle.Global.Clas.VpEq gparticle.Global.Bas.VpEq];
RHG= sum(VelProb==1);
WGG= sum(VelProb==2);
GGG= sum(VelProb==3);
VelRow= [RHG WGG GGG];
c = categorical({'RHG', 'WGG', 'GGG'});
figure;bar(c, VelRow, 0.5)
title('Velocity Equations Histogram')
ylabel('Occurrences')
ddd= gca;
ddd.FontSize= 24;

%% Frequency
FreqCar= gparticle.Global.Car(1).Frequency.Value;
for it=2:length(gparticle.Global.Car)
    FreqCar= [FreqCar gparticle.Global.Car(it).Frequency.Value];
end
FreqClas= gparticle.Global.Clas(1).Frequency.Value;
for it=2:length(gparticle.Global.Clas)
    FreqClas= [FreqClas gparticle.Global.Clas(it).Frequency.Value];
end
FreqBas= gparticle.Global.Bas(1).Frequency.Value;
for it=2:length(gparticle.Global.Bas)
    FreqBas= [FreqBas gparticle.Global.Bas(it).Frequency.Value];
end
Freq= [FreqCar FreqClas FreqBas];
figure;hist(Freq, 30);
title('Frequency Histogram')
xlabel('Frequency (Hz)')
ylabel('Occurrences')
ddd= gca;
ddd.FontSize= 24;

%% Fluid
Ratio= 30/100;
Plot_Cells= Number_of_Scenarios*NumberofEntities;
if isfield(ModelBounds.Carbonate_Scenario.Fluid, 'Ind_RES')
    ind_Entities= fieldnames(ModelBounds.Carbonate_Scenario.Fluid.Ind_RES); % Names of independent Entites
    ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
    figure;
    for iter=1:ind_Entities_Number
        xx= {gparticle.Global.Car(1).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name};
        from= round(length(gparticle.Global.Car)*Ratio);
        for it=(length(gparticle.Global.Car) - from):length(gparticle.Global.Car)
            xx= [xx gparticle.Global.Car(it).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name];
        end
        c= categorical(xx);   
        subplot(1, ind_Entities_Number, iter);     
        histogram(c, 'BarWidth', 0.5)
        title([(genvarname(ind_Entities{iter}))]);
        if iter==1
           ylabel('Occurrences'); 
        end
        ddd= gca;
        ddd.FontSize= 20;
        ddd.XAxis.FontSize= 14;
    end
end

if isfield(ModelBounds.Clastics_Scenario.Fluid, 'Ind_RES')
    ind_Entities= fieldnames(ModelBounds.Clastics_Scenario.Fluid.Ind_RES); % Names of independent Entites
    ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
    figure; 
    for iter=1:ind_Entities_Number
        from= round(length(gparticle.Global.Clas)*Ratio);
        for it=(length(gparticle.Global.Clas) - from):length(gparticle.Global.Clas)
            xx= [xx gparticle.Global.Clas(it).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name];
        end
        c= categorical(xx);
        subplot(1, ind_Entities_Number, iter);
        histogram(c, 'BarWidth', 0.5)
        title([(genvarname(ind_Entities{iter}))]);
        if iter==1
            ylabel('Occurrences');
        end
        ddd= gca;
        ddd.FontSize= 20;
        ddd.XAxis.FontSize= 14;
    end
end

if isfield(ModelBounds.Basalt_Scenario.Fluid, 'Ind_RES')
    ind_Entities= fieldnames(ModelBounds.Basalt_Scenario.Fluid.Ind_RES); % Names of independent Entites
    ind_Entities_Number= length(ind_Entities);    % Number of independent Entities
    figure; 
    for iter=1:ind_Entities_Number
        from= round(length(gparticle.Global.Bas)*Ratio);
        for it=(length(gparticle.Global.Bas) - from):length(gparticle.Global.Bas)
            xx= [xx gparticle.Global.Bas(it).pos.Fluid.Ind_RES.(genvarname(ind_Entities{iter})).name];
        end
        c= categorical(xx);
        subplot(1, ind_Entities_Number, iter);
        histogram(c, 'BarWidth', 0.5)
        title([(genvarname(ind_Entities{iter}))]);
        if iter==1
            ylabel('Occurrences');
        end
        ddd= gca;
        ddd.FontSize= 20;
        ddd.XAxis.FontSize= 14;
    end
end

%% Water saturation
xx= gparticle.Global.Car(1).pos.SW.Ind_RES.Entity3.Value(4);
for it=2:length(gparticle.Global.Car)
    xx= [xx gparticle.Global.Car(it).pos.SW.Ind_RES.Entity3.Value(4)];
end
figure; histogram(xx, 30);
title('Entity 3');
xlabel('Occurences');
ylabel('SW%');