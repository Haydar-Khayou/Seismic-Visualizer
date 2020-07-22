function SeismicProperties_Save(hObject, eventdata, handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%

%% Preparing

% get MinFrequency
MinFrequency= handles.MinFrequency_Text.String;

% check the value
if isempty(MinFrequency)
    msgbox('Enter a Minimum Frequency!', 'Error', 'Error');
    return;
end

MinFrequency= str2double(handles.MinFrequency_Text.String);

if  isnan(MinFrequency)
    msgbox('Make sure to choose a proper value for Minimum Frequency', 'Error', 'Error');
    return;
end

% get Max Frequency
MaxFrequency= handles.MaxFrequency_Text.String;

% check the value
if isempty(MaxFrequency)
    msgbox('Enter a Maximum Frequency!', 'Error', 'Error');
    return;
end

MaxFrequency= str2double(handles.MaxFrequency_Text.String);

if  isnan(MaxFrequency)
    msgbox('Make sure to choose a proper value for Maximum Frequency', 'Error', 'Error');
    return;
end

if MaxFrequency < MinFrequency
    msgbox('Maximum Frequency must be larger than Minimum Frequency', 'Error', 'Error');
    return;
end


%% Saving
MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL

% Delete the previous savings
MODEL.SeismicProperties='';
MODEL= rmfield(MODEL, 'SeismicProperties');

% Save the new entries
MODEL.SeismicProperties.MinFrequency= MinFrequency;
MODEL.SeismicProperties.MaxFrequency= MaxFrequency;
MODEL.SeismicProperties.Polarity= handles.Sies_Polarity.Value;

% Attach the MODEL to the figure
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
msgbox('Seismic Properities have been saved successfully', 'Success');


