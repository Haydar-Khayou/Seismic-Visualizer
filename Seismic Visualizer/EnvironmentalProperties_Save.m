function EnvironmentalProperties_Save(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%

%% Preparing

% get Main Overburden p-wave velocity
Main_Overburden_PVelocity= handles.MainOverburden_pVelocity.String;   % in (m/s)

% check the value
if isempty(Main_Overburden_PVelocity)
    msgbox('Enter a Main Overburden p-wave Velocity!', 'Error', 'Error');
    return;
end

Main_Overburden_PVelocity= str2double(handles.MainOverburden_pVelocity.String);

if  isnan(Main_Overburden_PVelocity)
    msgbox('Make sure to choose a proper value for Main Overburden p-wave Velocity', 'Error', 'Error');
    return;
end

% get Surface Temperature (in Celsious)
Surface_Temperature= handles.SurfaceTemperature_Text.String;

% check the value
if isempty(Surface_Temperature)
    msgbox('Enter a Surface Temperature!', 'Error', 'Error');
    return;
end

Surface_Temperature= str2double(handles.SurfaceTemperature_Text.String);

if  isnan(Surface_Temperature)
    msgbox('Make sure to choose a proper value for Surface Temperature', 'Error', 'Error');
    return;
end



% get Temperature Gradient  in (C/km)
Temperature_Gradient= handles.TemperatureGradient_Text.String;

% check the value
if isempty(Temperature_Gradient)
    msgbox('Enter a Temperature Gradient!', 'Error', 'Error');
    return;
end

Temperature_Gradient= str2double(handles.TemperatureGradient_Text.String);

if  isnan(Temperature_Gradient)
    msgbox('Make sure to choose a proper value for Temperature Gradient', 'Error', 'Error');
    return;
end


% get Surface Pressure in (MPa)
Surface_Pressure= handles.SurfacePressure_Text.String;

% check the value
if isempty(Surface_Pressure)
    msgbox('Enter a Surface Pressure!', 'Error', 'Error');
    return;
end

Surface_Pressure= str2double(handles.SurfacePressure_Text.String);

if  isnan(Surface_Pressure)
    msgbox('Make sure to choose a proper value for Surface Pressure', 'Error', 'Error');
    return;
end


% get Pressure Gradient in (MPa/km)
Pressure_Gradient= handles.PressureGradient_Text.String;

% check the value
if isempty(Pressure_Gradient)
    msgbox('Enter a Pressure Gradient!', 'Error', 'Error');
    return;
end

Pressure_Gradient= str2double(handles.PressureGradient_Text.String);

if  isnan(Pressure_Gradient)
    msgbox('Make sure to choose a proper value for Pressure Gradient', 'Error', 'Error');
    return;
end

%% Creating Depth-Temperature-Pressure matrices

MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
global Data
Yaxis= Data.Yaxis_Extra;


% Convert Time Axis from milliSeconds to Seconds
Yaxis_Seconds= Yaxis/1000;


% Convert Time Axis to Depth Axis (Seconds to meters)
Depth_Axis= (Yaxis_Seconds * Main_Overburden_PVelocity)/2;  % divided by 2 because Time is TWT

% Make the Depth vector vertical
Depth_Axis= Depth_Axis';

% We already know the number of rows, so we only need the number of columns
Col= size(MODEL.Entity1.Matrix, 2);

% create Depth matrix by repeating the depth Axis 'Col' times
Depth_Matrix= repmat(Depth_Axis, 1, Col);



%%%% Temperature
% Convert Temperature Gradient from C/km to C/m
Temperature_Gradient_meters= Temperature_Gradient/1000;

% Generate the Temperature Matrix
Temperature_Matrix= (Depth_Matrix.* Temperature_Gradient_meters) + Surface_Temperature;



%%%% Pressure
% Convert Pressure Gradient from MPa/km to MPa/m
Pressure_Gradient_meters= Pressure_Gradient/1000;

% Generate Pressure Matrix
Pressure_Matrix= (Depth_Matrix.* Pressure_Gradient_meters) + Surface_Pressure;


%% Saving

% Delete the previous savings
MODEL.EnvironmentalProperties= '';
MODEL= rmfield(MODEL, 'EnvironmentalProperties');

% Save the new entries
MODEL.EnvironmentalProperties.Main_Overburden_PVelocity= Main_Overburden_PVelocity;
MODEL.EnvironmentalProperties.Surface_Temperature= Surface_Temperature;
MODEL.EnvironmentalProperties.Temperature_Gradient= Temperature_Gradient;
MODEL.EnvironmentalProperties.Surface_Pressure= Surface_Pressure;
MODEL.EnvironmentalProperties.Pressure_Gradient= Pressure_Gradient;
MODEL.EnvironmentalProperties.Depth_Matrix= Depth_Matrix;

MODEL.EnvironmentalProperties.Temperature_Matrix= Temperature_Matrix;
MODEL.EnvironmentalProperties.Pressure_Matrix= Pressure_Matrix;

% Attach the MODEL to the figure
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
msgbox('Environmental Properities have been saved successfully', 'Success');
