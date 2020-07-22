function Seismic_inversion_Plotter(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou


%% Get Data
cla(handles.axes3);
global Basic_info
global Data_Trim            % 'Data_Trim' is the copy we work on.
Data= Data_Trim;
load('Seis_maps_for_inv.mat');

%% Section_plotting

% prepare X-Y axes
Xaxis= Data.X_axis;       % the horizontal axis
Yaxis= Data.Y_axis;       % the vertical axis(time)

%% imaging the matrix

%% get the color range limits
% Here we make sure that the color range is within the Amplitude range.
min_Color= str2double(handles.Min_Amplitude_Text.String);
max_Color= str2double(handles.Max_Amplitude_Text.String);
if isnan(min_Color)
    handles.Min_Amplitude_Text.String= num2str(Basic_info.min_color_Range);
    min_Color= Basic_info.min_color_Range;
elseif isnan(max_Color)
    handles.Max_Amplitude_Text.String= num2str(Basic_info.max_color_Range);
    max_Color= Basic_info.max_color_Range;
end
if min_Color==max_Color
    max_Color= min_Color+(Basic_info.max_color_Range/100);
    handles.Min_Amplitude_Text.String= num2str(min_Color);
    handles.Min_amp_Slider.Value= min_Color;
    handles.Max_Amplitude_Text.String= num2str(max_Color);
    handles.Max_amp_Slider.Value= max_Color;
end

min_Color= max(min_Color, Basic_info.min_color_Range);
if min_Color > Basic_info.max_color_Range
    min_Color= Basic_info.max_color_Range - (Basic_info.max_color_Range/100);
end
handles.Min_Amplitude_Text.String= num2str(min_Color);
handles.Min_amp_Slider.Value= min_Color;

max_Color= min(max_Color, Basic_info.max_color_Range);
handles.Max_Amplitude_Text.String= num2str(max_Color);
handles.Max_amp_Slider.Value= max_Color;


if min_Color>max_Color
    max_Color= min_Color+(Basic_info.max_color_Range/100);
    handles.Min_Amplitude_Text.String= num2str(min_Color);
    handles.Min_amp_Slider.Value= min_Color;
    handles.Max_Amplitude_Text.String= num2str(max_Color);
    handles.Max_amp_Slider.Value= max_Color;
end


color_range=[min_Color max_Color];



% Plot the matrix and adjust Xaxis(The horizontal axis) so that it is
% Distance or Trace and based on whether the user pressed the Distance
% Button.
if  strcmp(handles.Distance_Axis.State, 'on')
    % Distance X Axis which is the axis that shows distance and not the traces number
    Dis_X_axis = (Xaxis - min(Xaxis))/Data.StepLine;
    Dis_X_axis = Dis_X_axis*Data.Trace_Offset;
    Seis_Sec_Obj = imagesc(handles.axes3, Dis_X_axis, Yaxis, Data.ExportSection, color_range);       % flip then image matrix
    handles.axes3.XColor= 'b';
else
    Seis_Sec_Obj = imagesc(handles.axes3, Xaxis, Yaxis, Data.ExportSection, color_range);       % flip then image matrix
end


% Get The Picks and plot them on the Seismic Section
global XCoor YCoor XCoor_clean YCoor_clean

% XCoor           Get the Updated Coordinates of X
% YCoor           Get the Updated Coordinates of Y
% XCoor_clean     Get the Updated Coordinates of X_clean
% YCoor_clean     Get the Updated Coordinates of Y_clean

if strcmp(handles.Distance_Axis.State, 'off')      % when the horizontal axis is Distance we don't show picks
    hax=handles.axes3;
    hold(hax, 'on');
    
    Color_map = getappdata(handles.inv_fig, 'popupValue');
    if Color_map==1
        scatter(hax, XCoor, YCoor, 'g','filled','s');
        scatter(hax, XCoor_clean, YCoor_clean, 'K','filled','s');
    elseif Color_map==2|Color_map==3
        scatter(hax, XCoor, YCoor, 'K','filled','s');
        scatter(hax, XCoor_clean, YCoor_clean, 'g','filled','s');
    elseif Color_map==4
        scatter(hax, XCoor, YCoor, 'y','filled','s');
        scatter(hax, XCoor_clean, YCoor_clean, 'c','filled','s');
    elseif Color_map==5
        scatter(hax, XCoor, YCoor, 'c','filled','s');
        scatter(hax, XCoor_clean, YCoor_clean, 'y','filled','s');
    end
    
    hold(hax, 'off');
end

handles.Seis_Sec_Obj= Seis_Sec_Obj;   % The image is saved as Object in 'handles' structures
guidata(handles.inv_fig, handles);

%% Plot the axes
axis_im=handles.axes3;
axis_im.XAxisLocation= 'top';
if strcmp(handles.Distance_Axis.State, 'on')
    if Data.type
        title(handles.axes3,['InLine Slice: ', num2str(Data.Slice_number)],'color','r');
    else
        title(handles.axes3,['CrossLine Slice: ', num2str(Data.Slice_number)],'color','r');
    end
    xlabel(handles.axes3, 'Distance (m)');
else
    if Data.type
        title(handles.axes3,['InLine Slice: ', num2str(Data.Slice_number)],'color','r');
        xlabel(handles.axes3,'CrossLine number');
    else
        title(handles.axes3,['CrossLine Slice: ', num2str(Data.Slice_number)],'color','r');
        xlabel(handles.axes3,'Inline number');
    end
    
end
ylabel(handles.axes3,['Time ','(',Data.units,')']);

if handles.Grid_On.Value==1
    grid(handles.axes3, 'on');
else
    grid(handles.axes3, 'off');
end
if strcmp(handles.Color_Bar_Menue.State,'on')
    c_bar= colorbar(handles.axes3);                % Save the current colorbar
    c_bar.Location='southoutside';
    c_bar.Position=[0.7276    0.0727    0.2272    0.0347];
else
    colorbar(handles.axes3,'off');
end



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