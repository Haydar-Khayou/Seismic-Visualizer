function Manual_Trim_Seismic_Section(handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Get Data
global Data_Orig Data_Trim
Data= Data_Orig;   % Get the initial Data
Sample_Interval= Data.step;

%% Get Y-Axis Limits
Trace_Axis_First= str2double(handles.Min_Trace_Text.String);
Trace_Axis_Last= str2double(handles.Max_Trace_Text.String);

if Trace_Axis_First>Trace_Axis_Last
    errordlg('First Trace must be smaller than second Trace', 'Wrong entry', 'modal');
    return
end
%% Prepare X-Axis Limits
Trace_Axis_First= round(Trace_Axis_First);  % make it integer
Trace_Axis_First= Trace_Axis_First-rem(Trace_Axis_First, Data.StepLine);

Trace_Axis_First= max(Trace_Axis_First, min(Data.X_axis));  % Adjust min X-Axis

Trace_Axis_Last= round(Trace_Axis_Last);  % make it integer
Trace_Axis_Last= Trace_Axis_Last-rem(Trace_Axis_Last,Data.StepLine);

Trace_Axis_Last= min(Trace_Axis_Last, max(Data.X_axis));  % Adjust max X-Axis

%% Get X-Axis Limits
Time_Axis_First= str2double(handles.Min_Time_Text.String);
Time_Axis_Last= str2double(handles.Max_Time_Text.String);

if Time_Axis_First>Time_Axis_Last
    errordlg('First Time must be smaller than second Time', 'Wrong entry', 'modal');
    return
end

%% Prepare Y-Axis Limits
% approximate Time-Min to the closest value

Time_Axis_First= Time_Axis_First - rem(Time_Axis_First, Sample_Interval);


Time_Axis_First= max(Time_Axis_First, min(Data.Y_axis));  % Adjust min Y-Axis

Y_Sample_First= ((Time_Axis_First - min(Data.Y_axis))/Sample_Interval)+1;
Y_Sample_First= round(Y_Sample_First);

% approximate Time-Max to the closest value

Time_Axis_Last= Time_Axis_Last - rem(Time_Axis_Last, Sample_Interval);

Time_Axis_Last= min(Time_Axis_Last, max(Data.Y_axis));    % Adjust max Y-Axis

Y_Sample_Last= ((Time_Axis_Last - min(Data.Y_axis))/Sample_Interval)+1;
Y_Sample_Last= round(Y_Sample_Last);
Trace_Axis_First_corr= find(Data.X_axis==Trace_Axis_First);
Trace_Axis_Last_corr= min((find(Data.X_axis==Trace_Axis_Last)), max(size(Data.ExportSection, 2)));
Samples_coor= round((Data.Y_axis - Data.first_Time)/Sample_Interval)+1;        % Convert Time Axis to sample Axis to detect the coor
Y_Sample_First_corr= find(Samples_coor==Y_Sample_First);
Y_Sample_Last_corr= find(Samples_coor==Y_Sample_Last);
Data.X_axis= Trace_Axis_First:Data.StepLine:Trace_Axis_Last;
Data.Y_axis= Time_Axis_First:Sample_Interval:Time_Axis_Last ;
Data.ExportSection= Data.ExportSection(Y_Sample_First_corr:Y_Sample_Last_corr, Trace_Axis_First_corr:Trace_Axis_Last_corr);
Data_Trim= Data;
handles.Min_Trace_Text.String= num2str(Trace_Axis_First);
handles.Max_Trace_Text.String= num2str(Trace_Axis_Last);
handles.Min_Time_Text.String= num2str(Time_Axis_First);
handles.Max_Time_Text.String= num2str(Time_Axis_Last);
%% Prepare X Y for picked data
global XCoor
if ~isempty(XCoor)
    % Delete the picked points out of the section
    global YCoor X_Trim Y_Trim Sec_Size Coor Coor_Trim
    del_1= find(XCoor<Trace_Axis_First);
    del_2= find(XCoor>Trace_Axis_Last);
    del_3= find(YCoor<Time_Axis_First);
    del_4= find(YCoor>Time_Axis_Last);
    
    XCoor([del_1 del_2 del_3 del_4])= [];
    YCoor([del_1 del_2 del_3 del_4])= [];
    
    Coor= [XCoor' YCoor'];          % Coor matrix consists of two columns Xcoor and YCoor
    X_Trim = ((Coor(:,1)- min(Data_Trim.X_axis))/Data_Trim.StepLine)+1; % Point Xcoor of Trimmed Matrix
    Y_Trim = ((Coor(:,2)- min(Data_Trim.Y_axis))/Data_Trim.step)+1;  % Point Ycoor of Trimmed Matrix
    X_Trim = max(1, round(X_Trim,0));
    Y_Trim = max(1, round(Y_Trim,0));
    X_Trim = min(X_Trim,  size(Data_Trim.ExportSection, 2));
    Y_Trim = min(Y_Trim,  size(Data_Trim.ExportSection, 1));
    Coor_Trim=[X_Trim Y_Trim];      % Coordinates matrix of Trimmed Section
    Sec_Size = size(Data_Trim.ExportSection);
end
Seismic_inversion_Plotter(handles)
