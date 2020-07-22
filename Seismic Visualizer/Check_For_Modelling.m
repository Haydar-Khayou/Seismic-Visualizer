function Check_For_Modelling(hObject, eventdata, handles, UserData)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% get Data

MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities'); % Get total number of entities

%% Check Geologic Parameters
for Num_Entity=1:NumberofEntities
    N = num2str(Num_Entity);       % Convert Entity Number to String
    c=['Entity' N];                % Create string variable named c, Contains Entity+its number
    if ~isfield(MODEL.(genvarname(c)), 'Geology')
        msgbox(['Geologic Parameters are not saved for Entity Number ' N], 'Error', 'Error');
        return;
    end
end

%% Check Environmental Parameters
if ~isfield(MODEL, 'EnvironmentalProperties')
    msgbox('Environmental Properties Missed!', 'Error', 'Error');
    return;
end

%% Check Seismic Parameters
if ~isfield(MODEL, 'SeismicProperties')
    msgbox('Seismic Properties Missed!', 'Error', 'Error');
    return;
end

%% if everything is ok

% Generate Fluids Properties matrices
Fluids_Properties_Generator(handles)

% Initiaalize the bounds of the MODEL
Create_Bounds(handles)

Optimization_Algorithm= UserData.Algoritm;   % Determine which algorithm to use

if Optimization_Algorithm==1
    PSO(handles, UserData)
elseif Optimization_Algorithm==2
    BAT(handles, UserData)
end
% The first time Model creation








