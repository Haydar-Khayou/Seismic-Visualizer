function First_Time_Seismic_Plotter(handles)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of Science
%           Author: Haydar Khayou

%% Get Data
global Seis_orig_Data                   % Load Seismic Data
global isOnlyInline isOnlyXline         % Values to check whether data is 2D or 3D
load('Orig_Seis_maps.mat');             % Load Colormaps

%% Get_InLine/XLine info

%  The variables in this section are saved in the structure variable 'Basic_info_Vis'.
global Basic_info_Vis
Basic_info_Vis= [];

% Get the number of the row titled inline_no
inline_Row= find(strcmp('iline_no', Seis_orig_Data.header_info(:, 1)));
Basic_info_Vis.inline_Row= inline_Row;

% Get the number of the row titled xline_no
xline_Row= find(strcmp('xline_no', Seis_orig_Data.header_info(:, 1)));
Basic_info_Vis.xline_Row= xline_Row;

% inline slices start from number
first_inline= min(Seis_orig_Data.headers(inline_Row, :));
Basic_info_Vis.first_inline= first_inline;

% inline slices end at number
last_inline= max(Seis_orig_Data.headers(inline_Row, :));
Basic_info_Vis.last_inline= last_inline;

% xline slices start from number
first_xline= min(Seis_orig_Data.headers(xline_Row, :));
Basic_info_Vis.first_xline= first_xline;

% xline slices end at number
last_xline= max(Seis_orig_Data.headers(xline_Row, :));
Basic_info_Vis.last_xline= last_xline;

% Get the number of inline slices
inline_slices_no= sum(first_xline==Seis_orig_Data.headers(xline_Row, :));

% Get the number of xline slices
xline_slices_no= sum(first_inline==Seis_orig_Data.headers(inline_Row, :));

% inline step
inline_step= (last_inline-first_inline)/(inline_slices_no-1);
Basic_info_Vis.inline_step= inline_step;

% xline step
xline_step= (last_xline-first_xline)/(xline_slices_no-1);
Basic_info_Vis.xline_step= xline_step;

%% find Trace First Time row in headers.info

% Get the number of the row titled Trace_start_time
Trace_start_time_Row= find(strcmp('Trace_start_time', Seis_orig_Data.header_info(:, 1)));
Basic_info_Vis.Trace_start_time_Row= Trace_start_time_Row;

Trace_start_time= Seis_orig_Data.headers(Trace_start_time_Row, 1);  % we've chosen Column 1 because they all have the same value
Basic_info_Vis.Trace_start_time= Trace_start_time;

%% find X-Y coordinates row in Seis_orig_Data.headers_info

% Get the number of the row titled X_Coor_Row
X_Coor_Row= find(strcmp('sou_x', Seis_orig_Data.header_info(:, 1)));
Basic_info_Vis.X_Coor_Row= X_Coor_Row;

% Get the number of the row titled Y_Coor_Row
Y_Coor_Row= find(strcmp('sou_y', Seis_orig_Data.header_info(:, 1)));
Basic_info_Vis.Y_Coor_Row= Y_Coor_Row;

%% First Time Plotting
%% inline_plotting

inline_number= first_inline;                % choose the inline slice number to plot
in_traces= find(Seis_orig_Data.headers(inline_Row, :)==inline_number);     % the traces to plot

% prepare X-Y axes

% Xaxis for inline slices
Xaxis_inline= first_xline:xline_step:last_xline;            % the horizontal axis
Basic_info_Vis.Xaxis_inline= Xaxis_inline;

% Xaxis for xline slices
Xaxis_xline= first_inline:inline_step:last_inline;          % the horizontal axis
Basic_info_Vis.Xaxis_xline= Xaxis_xline;

% Yaxis for inline slices
Yaxis_inline= Seis_orig_Data.first:Seis_orig_Data.step:Seis_orig_Data.last;       % the vertical axis(time)
Time_shift= Trace_start_time - Seis_orig_Data.first;
Yaxis_inline= Yaxis_inline + Time_shift;     % shift Time line by 'first time' value which is the lag in time between shot and record
Basic_info_Vis.Yaxis_inline= Yaxis_inline;

% Yaxis for xline slices
Basic_info_Vis.Yaxis_xline= Yaxis_inline;    % Yaxis is the same for inline and xline because it's the time axis.

%% Coordinates of first trace and last trace

First_Trace= min(in_traces);
Last_Trace= max(in_traces);

First_Trace_XCoor= Seis_orig_Data.headers(X_Coor_Row, First_Trace);   % Get First Trace longitude coordinate
First_Trace_YCoor= Seis_orig_Data.headers(Y_Coor_Row, First_Trace);   % Get First Trace latitude coordinate

Last_Trace_XCoor= Seis_orig_Data.headers(X_Coor_Row, Last_Trace);     % Get Last Trace longitude coordinate
Last_Trace_YCoor= Seis_orig_Data.headers(Y_Coor_Row, Last_Trace);     % Get Last Trace latitude coordinate

% Calculate Degree from north
Delta_Latitude= abs(Last_Trace_YCoor - First_Trace_YCoor);    % Delta Y
Delta_Longitude= abs(Last_Trace_XCoor - First_Trace_XCoor);   % Delta X

Trace_Offset = sqrt((Delta_Latitude.^2)+(Delta_Longitude).^2)/(length(in_traces)-1); % Calculate Offset
Seis_orig_Data.Trace_Offset= Trace_Offset;

Degree= atan2d(Delta_Longitude, Delta_Latitude);    % Some math
if First_Trace_YCoor <= Last_Trace_YCoor
    Left_Latitude= 'S';
    Right_Latitude= 'N';
elseif First_Trace_YCoor >= Last_Trace_YCoor
    Left_Latitude= 'N';
    Right_Latitude= 'S';
elseif First_Trace_YCoor == Last_Trace_YCoor
    Left_Latitude= '';
    Right_Latitude= '';
end


if First_Trace_XCoor <= Last_Trace_XCoor
    Left_Longitude= 'W';
    Right_Longitude= 'E';
elseif First_Trace_XCoor >= Last_Trace_XCoor
    Left_Longitude= 'E';
    Right_Longitude= 'W';
elseif First_Trace_XCoor == Last_Trace_XCoor
    Left_Longitude= '';
    Right_Longitude= '';
end

if strcmp(Left_Latitude, 'N') & strcmp(Left_Longitude, 'W')
    Degree = -Degree;
end

if strcmp(Left_Latitude, 'S') & strcmp(Left_Longitude, 'E')
    Degree = -Degree;
end

if Degree==0
    Degree=[];
end


%% imaging the matrix

Min_Amp_in_Traces= min(min(Seis_orig_Data.traces));
Max_Amp_in_Traces= max(max(Seis_orig_Data.traces));
Amp_Val= min(abs(Min_Amp_in_Traces), abs(Max_Amp_in_Traces));

handles.Min_amp_Slider.Min= Min_Amp_in_Traces;                 % set objects on figure
handles.Min_amp_Slider.Max= Max_Amp_in_Traces;                 % set objects on figure
handles.Min_amp_Slider.Value= -Amp_Val;                        % set objects on figure
handles.Min_Amplitude_Text.String= num2str(-Amp_Val);          % set objects on figure

handles.Max_amp_Slider.Min= Min_Amp_in_Traces;                 % set objects on figure
handles.Max_amp_Slider.Max= Max_Amp_in_Traces;                 % set objects on figure
handles.Max_amp_Slider.Value= Amp_Val;                         % set objects on figure
handles.Max_Amplitude_Text.String= num2str(Amp_Val);           % set objects on figure

%%% Save variables to Basic_info_Vis variable
Basic_info_Vis.min_color_Range= Min_Amp_in_Traces;
Basic_info_Vis.max_color_Range= Max_Amp_in_Traces;
Basic_info_Vis.Amp_Val= Amp_Val;

%% View the Slice on the axis
color_range=[-Amp_Val Amp_Val];
imagesc(handles.axes1, Xaxis_inline, Yaxis_inline, Seis_orig_Data.traces(:,in_traces), color_range);
axis_im= handles.axes1;
axis_im.XAxisLocation= 'top';
title(handles.axes1,['InLine Slice: ', num2str(inline_number),],'color','r');
xlabel(handles.axes1,'CrossLine number');
ylabel(handles.axes1,['Time ','(',Seis_orig_Data.units,')']);
colormap(Seismic_map);
setappdata(handles.Seismic_Visualizer, 'popupValue', 1);
if strcmp(handles.Color_Bar_Menue.State, 'on')
    c_bar= colorbar(handles.axes1);                % Save the current colorbar
    c_bar.Location= 'southoutside';
    c_bar.Position= [0.7276    0.0727    0.2272    0.0347];
else
    colorbar(handles.axes1,'off');
end


% change the axes color
handles.axes1.Color= [0.9 0.9 0.9];

%% view useful information on figure

handles.First_inline_Text_on_fig.String= num2str(first_inline);    % Show first InLine number
handles.Last_inline_Text_on_fig.String= num2str(last_inline);      % Show last InLine number

handles.First_xline_Text_on_fig.String= num2str(first_xline);      % Show first XLine number
handles.Last_xline_Text_on_fig.String= num2str(last_xline);        % Show last XLine number

handles.handle_InLine.String= num2str(inline_number);
handles.handle_xLine.String= num2str(first_xline);
handles.Text_Line.String= num2str(first_inline);

%% Plotting the Inline-Crossline Map

%% Check if 2D-Data
% If we have 2D data then we cannot plot a map for xline/inline grid
% because xline info is missing.

% Check if in the headers in the inline row has the same values(which means we the data we have is inline Line)
isOnlyInline= prod(Seis_orig_Data.headers(inline_Row, 1)== Seis_orig_Data.headers(inline_Row, :));

% Check if in the headers in the xline row has the same values(which means we the data we have is xline Line)
isOnlyXline= prod(Seis_orig_Data.headers(xline_Row, 1)== Seis_orig_Data.headers(xline_Row, :));

if ~(isOnlyInline||isOnlyXline)   % if the data is 3D
    map_cross_in= handles.axes2;                % Choose the axes to plot on
    
    map_cross_in.XAxis.Limits= [first_inline last_inline];
    
    map_cross_in.YAxis.Limits= [first_xline last_xline];
    
    map_cross_in.ZAxis.Limits= [min(Yaxis_inline) max(Yaxis_inline)];
    cla(handles.axes2);               % Clear Axis befor plotting
    
    
    %%%% prepare x-in plates to plot on location map
    patch(handles.axes2,[str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String)],[first_xline first_xline last_xline last_xline],[min(Yaxis_inline) max(Yaxis_inline) max(Yaxis_inline) min(Yaxis_inline)],[1 0 0],'EdgeColor',[1 0 0]);
    patch(handles.axes2,[first_inline first_inline last_inline last_inline],[str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String)],[min(Yaxis_inline) max(Yaxis_inline) max(Yaxis_inline) min(Yaxis_inline)],[0.7 0.7 0.7]);
    handles.axes2.CameraPosition= 1.0e+03.*[1.7307   -4.8502   -2.6840];
    handles.axes2.Color=[.95 .95 .95];
    title(handles.axes2, 'Location', 'color', 'r');
    xlabel(handles.axes2, 'InLine');
    ylabel(handles.axes2, 'CrossLine')
    handles.axes2.Box= 'on';
    grid(handles.axes2, 'on');
    handles.handle_InLine.Value= 1;
    handles.axes2.ZAxis.Direction= 'reverse';
else
    setappdata(handles.Seismic_Visualizer, 'SaveButton', 1)
end
%% View Directions
handles.Left_Latitude.String= Left_Latitude;
handles.Left_Longitude.String= Left_Longitude;
handles.Right_Latitude.String= Right_Latitude;
handles.Right_Longitude.String= Right_Longitude;
handles.Degree.String= [num2str(Degree, 2), char(176)];
set(handles.Edit, 'Visible', 'on');
Seismic_Plotter(handles)