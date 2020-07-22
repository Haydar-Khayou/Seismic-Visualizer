function Seismic_inversion_first_Time_Plotter(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou

%% Get Data

global Data_Orig            % 'Data_Orig' is a copy of Data we don't work on, it is kept in case of reset to default.
global Data_Trim
Data_Trim= Data_Orig;

load('Seis_maps.mat');                                              % Load Colormaps
save('Seis_maps_for_inv.mat','Seismic_map','Red_blue_map','Red_blue_Light_map','Red_black_map','Grey');

% Get the flip color info
if Data_Orig.FlipColorbar
    handles.FlipColorbar.String= 'Flip Colorbar';
    handles.FlipColorbar.Value= 0;
else
    handles.FlipColorbar.String= 'Flip Colorbar';
    handles.FlipColorbar.Value= 1;
end

%% Section_plotting

% prepare X-Y axes

Xaxis= Data_Orig.X_axis;       % the horizontal axis
Yaxis= Data_Orig.Y_axis;       % the vertical axis(time)


% Prepare figure objects
Amp_Val= Data_Orig.Amp_Val;
handles.Min_amp_Slider.Min= Data_Orig.min_Amp;
handles.Min_amp_Slider.Max= Data_Orig.max_Amp;
handles.Min_amp_Slider.Value= -Amp_Val;
handles.Min_Amplitude_Text.String= num2str(-Amp_Val);

handles.Max_amp_Slider.Min= Data_Orig.min_Amp;
handles.Max_amp_Slider.Max= Data_Orig.max_Amp;
handles.Max_amp_Slider.Value= Amp_Val;
handles.Max_Amplitude_Text.String= num2str(Amp_Val);


color_range= [-Amp_Val Amp_Val];

% image the matrix and save it under the name 'Seis_Sec_Obj'
Seis_Sec_Obj= imagesc(handles.axes3, Xaxis, Yaxis, Data_Orig.ExportSection, color_range);

% Save the image as Object in 'handles' structure
handles.Seis_Sec_Obj= Seis_Sec_Obj;
guidata(handles.inv_fig, handles);

% Prepare the axes
axis_im= handles.axes3;
axis_im.XAxisLocation= 'top';
if Data_Orig.type      % Get the type of Seismic section- Inline or Xline.
    title(handles.axes3,['InLine Slice: ', num2str(Data_Orig.Slice_number)],'color','r');
    xlabel(handles.axes3,'CrossLine number');
else
    title(handles.axes3,['CrossLine Slice: ', num2str(Data_Orig.Slice_number)],'color','r');
    xlabel(handles.axes3,'Inline number');
end
ylabel(handles.axes3,['Time ','(',Data_Orig.units,')']);
if handles.Grid_On.Value==1
    grid(handles.axes3, 'on');
else
    grid(handles.axes3, 'off');
end

hax=handles.axes3;
hold(hax, 'on');

% Put the colormap
switch Data_Orig.colormap
    case 1
        colormap(handles.axes3, Seismic_map);
        setappdata(handles.inv_fig, 'popupValue', 1);
    case 2
        colormap(handles.axes3, Red_blue_map);
        setappdata(handles.inv_fig, 'popupValue', 2);
    case 3
        colormap(handles.axes3, Red_blue_Light_map);
        setappdata(handles.inv_fig, 'popupValue', 3);
    case 4
        colormap(handles.axes3, Red_black_map);
        setappdata(handles.inv_fig, 'popupValue', 4);
    case 5
        colormap(handles.axes3, Grey);
        setappdata(handles.inv_fig, 'popupValue', 5);
end

hold(hax, 'off');

% Prepare the colorbar
if strcmp(handles.Color_Bar_Menue.State, 'on')
    c_bar= colorbar(handles.axes3);                % Save the current colorbar
    c_bar.Location= 'southoutside';
    c_bar.Position= [0.7276    0.0727    0.2272    0.0347];
else
    colorbar(handles.axes3, 'off');
end

%% Show info on Figure
handles.Min_Trace_Text.String= num2str(Data_Orig.Lines(1,1));
handles.Max_Trace_Text.String= num2str(Data_Orig.Lines(1,2));
handles.Min_Time_Text.String= num2str(min(Data_Orig.Y_axis));
handles.Max_Time_Text.String= num2str(max(Data_Orig.Y_axis));

%% Show Dirceions
handles.Left_Latitude.String = Data_Orig.Sec_Coor.Left_Latitude;
handles.Left_Longitude.String = Data_Orig.Sec_Coor.Left_Longitude;
handles.Right_Latitude.String = Data_Orig.Sec_Coor.Right_Latitude;
handles.Right_Longitude.String = Data_Orig.Sec_Coor.Right_Longitude;
handles.Degree.String = [num2str(Data_Orig.Degree, 2), char(176)];

%% See the Picking Button and decide what to do due to its Value
if handles.Start_Picking.Value
    % Set ButtonDownFcn of the image as below
    set(handles.Seis_Sec_Obj , 'ButtonDownFcn', @(hObject,eventdata)Seismic_inversion('axes3_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
    set(handles.inv_fig , 'WindowKeyPressFcn', @(hObject,eventdata)Seismic_inversion('inv_fig_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));
    handles.Start_Picking.String='Picking Mode is ON';
else
    set(handles.Seis_Sec_Obj , 'ButtonDownFcn', ' ');
    set(handles.inv_fig , 'WindowKeyPressFcn', ' ');
    handles.Start_Picking.String='Picking Mode is OFF';
end