function Seismic_Plotter(handles)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of Science
%           Author: Haydar Khayou

%% Get Data
global Seis_orig_Data             % Load Seismic Data
global Basic_info_Vis             % Load 'Basic_info_Vis' variable
global isOnlyInline isOnlyXline   % Values to check whether data is 2D or 3D
load('Seis_maps.mat')             % Load Colormaps

%% Get_InLine/CrossLine info

% Get the number of the row titled inline_no
inline_Row= Basic_info_Vis.inline_Row;

% Get the number of the row titled xline_no
xline_Row= Basic_info_Vis.xline_Row;

% inline slices start from number
first_inline= Basic_info_Vis.first_inline;

% inline slices end at number
last_inline= Basic_info_Vis.last_inline;

% xline slices start from number
first_xline= Basic_info_Vis.first_xline;

% xline slices end at number
last_xline= Basic_info_Vis.last_xline;

% inline step
inline_step= Basic_info_Vis.inline_step;

% xline step
xline_step= Basic_info_Vis.xline_step;

%% find Trace First Time Row in headers.info

% Trace_start_time
Trace_start_time= Basic_info_Vis.Trace_start_time;

%% find X-Y coordinates Row in Seis_orig_Datta.headers_info

% the number of the row titled X_Coor_Row
X_Coor_Row= Basic_info_Vis.X_Coor_Row;

% the number of the row titled Y_Coor_Row
Y_Coor_Row= Basic_info_Vis.Y_Coor_Row;


%% get the color range limits
% Here we make sure that the color range is within the Amplitude range.
min_Color= str2double(handles.Min_Amplitude_Text.String);
max_Color= str2double(handles.Max_Amplitude_Text.String);
if isnan(min_Color)
    handles.Min_Amplitude_Text.String= num2str(Basic_info_Vis.min_color_Range);
    min_Color= Basic_info_Vis.min_color_Range;
elseif isnan(max_Color)
    handles.Max_Amplitude_Text.String= num2str(Basic_info_Vis.max_color_Range);
    max_Color= Basic_info_Vis.max_color_Range;
end
if min_Color==max_Color
    max_Color= min_Color+(Basic_info_Vis.max_color_Range/100);
    handles.Min_Amplitude_Text.String= num2str(min_Color);
    handles.Min_amp_Slider.Value= min_Color;
    handles.Max_Amplitude_Text.String= num2str(max_Color);
    handles.Max_amp_Slider.Value= max_Color;
end

min_Color= max(min_Color, Basic_info_Vis.min_color_Range);
if min_Color > Basic_info_Vis.max_color_Range
    min_Color= Basic_info_Vis.max_color_Range - (Basic_info_Vis.max_color_Range/100);
end
handles.Min_Amplitude_Text.String= num2str(min_Color);
handles.Min_amp_Slider.Value= min_Color;

max_Color= min(max_Color, Basic_info_Vis.max_color_Range);
handles.Max_Amplitude_Text.String= num2str(max_Color);
handles.Max_amp_Slider.Value= max_Color;


if min_Color>max_Color
    max_Color= min_Color+(Basic_info_Vis.max_color_Range/100);
    handles.Min_Amplitude_Text.String= num2str(min_Color);
    handles.Min_amp_Slider.Value= min_Color;
    handles.Max_Amplitude_Text.String= num2str(max_Color);
    handles.Max_amp_Slider.Value= max_Color;
end

color_range= [min_Color max_Color];

%%
if ~handles.X_IN_Toggle.Value      % Plot Inline Slices
    
    %% inline_plotting
    if handles.handle_xLine.Value==1
        handles.Text_Line.String= handles.handle_InLine.String;
    end
    Seis_Data_inline= Seis_orig_Data.traces;    % get the traces matrix
    
    
    % get information from "Check_Text_Line"
    Check_Text_Line= str2double(handles.Text_Line.String);
    if isnan(Check_Text_Line)
        msgbox('Wrong Entry');
        handles.Text_Line.String= num2str(first_inline);
        Check_Text_Line= first_inline;
    end
    
    Check_Text_Line= Check_Text_Line-rem(Check_Text_Line, inline_step);
    Check_Text_Line= min(Check_Text_Line, last_inline);
    Check_Text_Line= max(Check_Text_Line, first_inline);
    
    handles.Text_Line.String= num2str(Check_Text_Line);
    inline_number= Check_Text_Line;
    global in_traces
    in_traces= find(Seis_orig_Data.headers(inline_Row,:)== inline_number);     % the traces to be plotted
    
    % prepare X-Y axes
    
    Xaxis_inline= Basic_info_Vis.Xaxis_inline;       % the horizontal axis
    Yaxis_inline= Basic_info_Vis.Yaxis_inline;       % the vertical axis(time)
    
    %% Coordinates of first trace and last trace
    
    First_Trace= min(in_traces);
    Last_Trace= max(in_traces);
    
    First_Trace_XCoor = Seis_orig_Data.headers(X_Coor_Row, First_Trace);
    First_Trace_YCoor = Seis_orig_Data.headers(Y_Coor_Row, First_Trace);
    
    Last_Trace_XCoor = Seis_orig_Data.headers(X_Coor_Row, Last_Trace);
    Last_Trace_YCoor = Seis_orig_Data.headers(Y_Coor_Row, Last_Trace);
    
    % Calculate Degree from north
    Delta_Latitude = abs(Last_Trace_YCoor - First_Trace_YCoor); % Delta Y
    Delta_Longitude = abs(Last_Trace_XCoor - First_Trace_XCoor);   % Delta X
    
    Trace_Offset = sqrt((Delta_Latitude.^2)+(Delta_Longitude).^2)/(length(in_traces)-1); % Calculate Offset
    Seis_orig_Data.Trace_Offset= Trace_Offset;
    Degree = atan2d(Delta_Longitude, Delta_Latitude);
    
    
    if First_Trace_YCoor <= Last_Trace_YCoor
        Left_Latitude='S';
        Right_Latitude='N';
    elseif First_Trace_YCoor >= Last_Trace_YCoor
        Left_Latitude='N';
        Right_Latitude='S';
    elseif First_Trace_YCoor == Last_Trace_YCoor
        Left_Latitude='';
        Right_Latitude='';
    end
    
    
    if First_Trace_XCoor <= Last_Trace_XCoor
        Left_Longitude= 'W';
        Right_Longitude= 'E';
    elseif First_Trace_XCoor >= Last_Trace_XCoor
        Left_Longitude= 'E';
        Right_Longitude= 'W';
    elseif First_Trace_XCoor == Last_Trace_XCoor
        Left_Longitude='';
        Right_Longitude='';
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
    
    %% Imaging the matrix
    cla(handles.axes1);               % Clear Axis
    if  strcmp(handles.Distance_Axis.State, 'on')
        % Distance X Axis which is the axis that shows distance and not the traces number
        Dis_X_axis = (Xaxis_inline - min(Xaxis_inline))/xline_step;
        Dis_X_axis = Dis_X_axis*Trace_Offset;
        imagesc(handles.axes1, Dis_X_axis, Yaxis_inline, Seis_Data_inline(:,in_traces), color_range);        % image matrix
        handles.axes1.XColor= 'b';
    else
        imagesc(handles.axes1, Xaxis_inline, Yaxis_inline, Seis_Data_inline(:,in_traces), color_range);      % image matrix
% % %         hold(handles.axes1, 'on');
% % %         Temp_traces= Seis_Data_inline(:,in_traces)/max(max(Seis_Data_inline(:,in_traces)));
% % %         traces= Temp_traces + Xaxis_inline;
% % %         plot(handles.axes1, traces(:, 1:end), Yaxis_inline, 'k');
% % %         Temp2_traces= Temp_traces;
% % %         Temp2_traces(find(Temp2_traces<0))= 0;
% % %         Temp2_traces= Temp2_traces + Xaxis_inline;
% % %         fill(handles.axes1, Temp2_traces(:, 1:end), Yaxis_inline, 'r');
% % %         hold(handles.axes1, 'on');
    end
    axis_im=handles.axes1;
    axis_im.XAxisLocation= 'top';
    title(handles.axes1,['InLine Slice: ', num2str(inline_number),],'color','r');
    if  strcmp(handles.Distance_Axis.State, 'on')
        xlabel(handles.axes1,'Distance (m)');
    else
        xlabel(handles.axes1,'CrossLine number');
    end
    
    ylabel(handles.axes1,['Time ','(',Seis_orig_Data.units,')']);
    
    if handles.Grid_On.Value==1
        grid(handles.axes1, 'on');
    else
        grid(handles.axes1, 'off');
    end
    
    handles.handle_InLine.String= num2str(inline_number);
    handles.handle_InLine.Value=1;
    handles.handle_xLine.Value=0;
    
    if getappdata(handles.Seismic_Visualizer, 'SaveButton')
        % data to export
        Data.Basic_info_Vis= Basic_info_Vis;
        Data.ExportSection= Seis_Data_inline(:, in_traces);
        Data.X_axis= Xaxis_inline;
        Data.Y_axis= Yaxis_inline;
        Data.step= Seis_orig_Data.step;
        Data.first_Time= Trace_start_time;
        Data.StepLine= xline_step;
        Data.Sec_Coor.Left_Latitude= Left_Latitude;
        Data.Sec_Coor.Left_Longitude= Left_Longitude;
        Data.Sec_Coor.Right_Latitude= Right_Latitude;
        Data.Sec_Coor.Right_Longitude= Right_Longitude;
        Data.Trace_Offset= Trace_Offset;
        Data.Degree= Degree;
        Data.Lines= [first_xline last_xline];
        Data.type= 1;
        Data.units= Seis_orig_Data.units;
        Data.FlipColorbar= ~handles.FlipColorbar.Value;
        Data.Slice_number= inline_number;
        Data.min_Amp= Basic_info_Vis.min_color_Range;
        Data.max_Amp= Basic_info_Vis.max_color_Range;
        Data.Amp_Val= Basic_info_Vis.Amp_Val;
        Data.colormap= getappdata(handles.Seismic_Visualizer, 'popupValue');
        if isOnlyInline||isOnlyXline
            Data.type= '2D';
        else
            Data.type= '3D';
        end
        save('Data.mat', 'Data');
    end
    
else
    %% crossline_plotting
    
    if handles.handle_InLine.Value==1
        handles.Text_Line.String= handles.handle_xLine.String;
    end
    
    
    Seis_Data_xline= Seis_orig_Data.traces;             % get the traces matrix
    
    % get information from "Check_Text_Line"
    Check_Text_Line= str2double(handles.Text_Line.String);
    if isnan(Check_Text_Line)
        msgbox('Wrong Entry');
        handles.Text_Line.String=num2str(first_xline);
        Check_Text_Line= first_xline;
    end
    
    Check_Text_Line= Check_Text_Line-rem(Check_Text_Line, xline_step);
    Check_Text_Line= min(Check_Text_Line, last_xline);
    Check_Text_Line= max(Check_Text_Line, first_xline);
    
    handles.Text_Line.String= num2str(Check_Text_Line);
    
    xline_number= Check_Text_Line;
    global x_traces
    x_traces= find(Seis_orig_Data.headers(xline_Row,:)== xline_number);    % the traces to be plotted
    
    
    % prepare X-Y axes
    
    Xaxis_xline= Basic_info_Vis.Xaxis_xline;          % the horizontal axis
    Yaxis_xline= Basic_info_Vis.Yaxis_xline;          % the vertical(Time) axis
    
    %% Coordinates of first trace and last trace
    
    First_Trace= min(x_traces);
    Last_Trace= max(x_traces);
    
    First_Trace_XCoor= Seis_orig_Data.headers(X_Coor_Row, First_Trace);
    First_Trace_YCoor= Seis_orig_Data.headers(Y_Coor_Row, First_Trace);
    
    Last_Trace_XCoor= Seis_orig_Data.headers(X_Coor_Row, Last_Trace);
    Last_Trace_YCoor= Seis_orig_Data.headers(Y_Coor_Row, Last_Trace);
    
    % Calculate Degree from north
    Delta_Latitude= abs(Last_Trace_YCoor - First_Trace_YCoor); % Delta Y
    Delta_Longitude= abs(Last_Trace_XCoor - First_Trace_XCoor);   % Delta X
    
    Trace_Offset= sqrt((Delta_Latitude^2)+(Delta_Longitude)^2)/(length(x_traces)-1); % Calculate Offset
    Seis_orig_Data.Trace_Offset= Trace_Offset;
    Degree= atan2d(Delta_Longitude, Delta_Latitude);
    
    if First_Trace_YCoor < Last_Trace_YCoor
        Left_Latitude='S';
        Right_Latitude='N';
    elseif First_Trace_YCoor > Last_Trace_YCoor
        Left_Latitude='N';
        Right_Latitude='S';
    elseif First_Trace_YCoor == Last_Trace_YCoor
        Left_Latitude='';
        Right_Latitude='';
    end
    
    if First_Trace_XCoor < Last_Trace_XCoor
        Left_Longitude= 'W';
        Right_Longitude= 'E';
    elseif First_Trace_XCoor > Last_Trace_XCoor
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
    
    
    %% Imaging the matrix
    cla(handles.axes1);               % Clear Axis
    %%%
    if  strcmp(handles.Distance_Axis.State, 'on')
        % Distance X Axis which is the axis that shows distance and not the traces number
        Dis_X_axis = (Xaxis_xline - min(Xaxis_xline))/inline_step;
        Dis_X_axis = Dis_X_axis*Trace_Offset;
        imagesc(handles.axes1, Dis_X_axis, Yaxis_xline, Seis_Data_xline(:, x_traces), color_range);        % image matrix
        handles.axes1.XColor= 'b';
    else
        imagesc(handles.axes1, Xaxis_xline, Yaxis_xline, Seis_Data_xline(:, x_traces), color_range);       %  image matrix
    end
    %%%
    
    axis_im= handles.axes1;
    axis_im.XAxisLocation= 'top';
    title(handles.axes1,['CrossLine Slice: ', num2str(xline_number),],'color','r');
    if  strcmp(handles.Distance_Axis.State, 'on')
        xlabel(handles.axes1,'Distance (m)');
        handles.axes3.XColor= 'b';
    else
        xlabel(handles.axes1,'InLine number');
    end
    
    ylabel(handles.axes1,'Time (ms)')
    
    if handles.Grid_On.Value==1
        grid(handles.axes1, 'on');
    else
        grid(handles.axes1, 'off');
    end
    
    handles.handle_xLine.String= num2str(xline_number);
    handles.handle_xLine.Value= 1;
    handles.handle_InLine.Value= 0;
    
    if getappdata(handles.Seismic_Visualizer, 'SaveButton')
        % data to export
        Data.Basic_info_Vis= Basic_info_Vis;
        Data.ExportSection= Seis_Data_xline(:, x_traces);
        Data.X_axis= Xaxis_xline;
        Data.Y_axis= Yaxis_xline;
        Data.first_Time= Trace_start_time;
        Data.step= Seis_orig_Data.step;
        Data.StepLine= inline_step;
        Data.Sec_Coor.Left_Latitude= Left_Latitude;
        Data.Sec_Coor.Left_Longitude= Left_Longitude;
        Data.Sec_Coor.Right_Latitude= Right_Latitude;
        Data.Sec_Coor.Right_Longitude= Right_Longitude;
        Data.Trace_Offset= Trace_Offset;
        Data.Degree= Degree;
        Data.Lines= [first_inline last_inline];
        Data.type= 0;
        Data.units= Seis_orig_Data.units;
        Data.FlipColorbar= ~handles.FlipColorbar.Value;
        Data.Slice_number= xline_number;
        Data.min_Amp= Basic_info_Vis.min_color_Range;
        Data.max_Amp= Basic_info_Vis.max_color_Range;
        Data.Amp_Val= Basic_info_Vis.Amp_Val;
        Data.colormap= getappdata(handles.Seismic_Visualizer, 'popupValue');
        save('Data.mat', 'Data');
    end
end

% change the axes color
handles.axes1.Color= [0.9 0.9 0.9];

if strcmp(handles.Color_Bar_Menue.State, 'on')
    c_bar= colorbar(handles.axes1);                % Save the current colorbar
    c_bar.Location= 'southoutside';
    c_bar.Position= [0.7276    0.0727    0.2272    0.0347];
else
    colorbar(handles.axes1, 'off');
end

%% Plotting the Inline-Crossline Map

if ~(isOnlyInline||isOnlyXline)   % if the data is 3D
    
    map_cross_in= handles.axes2;                % Choose the axes to plot on
    
    map_cross_in.XAxis.Limits= [first_inline last_inline];
    
    map_cross_in.YAxis.Limits= [first_xline last_xline];
    
    
    if ~handles.X_IN_Toggle.Value
        map_cross_in.ZAxis.Limits= [min(Yaxis_inline) max(Yaxis_inline)];
    else
        map_cross_in.ZAxis.Limits= [min(Yaxis_xline) max(Yaxis_xline)];
    end
    
    cla(handles.axes2);               % Clear Axis befor plotting
    
    
    %%%% prepare x-in plates to plot on location map
    if handles.handle_InLine.Value
        patch(handles.axes2,[str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String)],[first_xline first_xline last_xline last_xline],[min(Yaxis_inline) max(Yaxis_inline) max(Yaxis_inline) min(Yaxis_inline)],[1 0 0],'EdgeColor',[1 0 0]);
        patch(handles.axes2,[first_inline first_inline last_inline last_inline],[str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String)],[min(Yaxis_inline) max(Yaxis_inline) max(Yaxis_inline) min(Yaxis_inline)],[0.7 0.7 0.7]);
    else
        patch(handles.axes2,[str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String) str2double(handles.handle_InLine.String)],[first_xline first_xline last_xline last_xline],[min(Yaxis_xline) max(Yaxis_xline) max(Yaxis_xline) min(Yaxis_xline)],[0.7 0.7 0.7]);
        patch(handles.axes2,[first_inline first_inline last_inline last_inline],[str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String) str2double(handles.handle_xLine.String)],[min(Yaxis_xline) max(Yaxis_xline) max(Yaxis_xline) min(Yaxis_xline)],[1 0 0],'EdgeColor',[1 0 0]);
    end
    handles.axes2.Color= [.95 .95 .95];
    title(handles.axes2, 'Location', 'color', 'r');
    xlabel(handles.axes2, 'InLine');
    ylabel(handles.axes2, 'CrossLine')
    handles.axes2.Box= 'on';
    grid(handles.axes2, 'on');
    handles.axes2.ZAxis.Direction= 'reverse';
end
%% View Directions
handles.Left_Latitude.String= Left_Latitude;
handles.Left_Longitude.String= Left_Longitude;
handles.Right_Latitude.String= Right_Latitude;
handles.Right_Longitude.String= Right_Longitude;
handles.Degree.String= [num2str(Degree, 2), char(176)];
if getappdata(handles.Seismic_Visualizer, 'SaveButton')
    setappdata(handles.Seismic_Visualizer, 'SaveButton', 0);
    Seismic_inversion;
end
