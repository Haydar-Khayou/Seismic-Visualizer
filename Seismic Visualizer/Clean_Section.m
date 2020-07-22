function Clean_Section(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
% This is to delete Points individulally

%%  Orders
global Data_Orig Data_Trim XCoor_clean YCoor_clean Coor_clean Coor_Trim_clean Sec_Size X_Trim_clean Y_Trim_clean

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;


cla(handles.axes3);  % Clear Axis
Seismic_inversion_Plotter(handles)   % Redraw the Section with Points(if there are points)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;


Data= Data_Orig; % Get the ORIGINAL Data structure
% Data_Trim     Get Data_Trim structure
% XCoor_clean   Get the last Updated Coordinates of X
% YCoor_clean   Get the last Updated Coordinates of Y

position = get(gca, 'CurrentPoint'); % Get the Position of cursor (X Y Coordinates)
initial_xPOS= (position(1,1));        % Get x coordinates of cursor from the figure
if strcmp(handles.Distance_Axis.State, 'on')
    xPOS= ((initial_xPOS/Data.Trace_Offset)*Data.StepLine)+min(Data.X_axis);
else
    xPOS= initial_xPOS;
end

xPOS1= (xPOS)-(rem((xPOS), Data.StepLine));  % Fix Positions of X Coor
xPOS2= xPOS1+Data.StepLine;
if xPOS2-xPOS<xPOS-xPOS1
    xPOS= xPOS2;
else
    xPOS= xPOS1;
end


yPOS=(position(1,2));        % Y Coor
yPOS1=(yPOS)-(rem((yPOS),Data.step));  % Fix Positions of Y Coor
yPOS2=yPOS1+Data.step;
if yPOS2-yPOS<yPOS-yPOS1
    yPOS=yPOS2;
else
    yPOS=yPOS1;
end

if strcmp(eventdata.Modifier, 'shift') && strcmp(eventdata.Character, 'A')
    yPOS=Data_Trim.Y_axis(1):Data.step:yPOS;
elseif strcmp(eventdata.Modifier, 'shift') && strcmp(eventdata.Character, 'Z')
    yPOS=yPOS:Data.step:Data_Trim.Y_axis(end)+Data.step;
elseif strcmp(eventdata.Modifier, 'shift') && strcmp(eventdata.Character, 'S')
    yPOS=yPOS;
end

for yPOS=yPOS
    %%  Dont get a point if it is already existed
    
    xPOS = round(xPOS);   % xPos is the Trace Number, it is integer
    yPOS = round(yPOS,5); % we want a precision of 5 decimal digits no more
    
    x = (XCoor_clean==xPOS);       % x is a logical vector (1 or 0)
    y = (YCoor_clean==yPOS);       % y is a logical vector (1 or 0)
    bb = x.*y;               % bb is a logical vector (1 or 0)if there is
    % a previous point with same coordinates we get value 1 in bb vector
    
    % if sum(bb)>0 that means there is a point with the same coordinates as the
    % current point
    if ~sum(bb)
        XCoor_clean=[XCoor_clean xPOS];    % Add the new X-Coor to the X Coor matrix
        YCoor_clean=[YCoor_clean yPOS];    % Add the new Y-Coor to the Y Coor matrix
    end
    
    
    Coor_clean=[XCoor_clean' YCoor_clean'];          % Coor matrix consists of two columns XCoor_clean and YCoor_clean
    X_Trim_clean = ((Coor_clean(:,1)- min(Data_Trim.X_axis))/Data_Trim.StepLine)+1; % Point XCoor_clean of Trimmed Matrix
    Y_Trim_clean = ((Coor_clean(:,2)- min(Data_Trim.Y_axis))/Data_Trim.step)+1;  % Point YCoor_clean of Trimmed Matrix
    X_Trim_clean = max(1, round(X_Trim_clean,0));
    X_Trim_clean= min(X_Trim_clean, size(Data_Trim.ExportSection, 2));
    Y_Trim_clean = max(1, round(Y_Trim_clean,0));
    Y_Trim_clean= min(Y_Trim_clean, size(Data_Trim.ExportSection, 1));
    Coor_Trim_clean=[X_Trim_clean Y_Trim_clean];      % Coordinates matrix of Trimmed Section
    Sec_Size = size(Data_Trim.ExportSection);
    
end

% Draw the Points

hax=handles.axes3;
hold(hax, 'on');
%% choose colors of picked points based on Colormap(just to make things easy to see)
Color_map = getappdata(handles.inv_fig, 'popupValue');
if Color_map==1
    scatter(hax, XCoor_clean, YCoor_clean, 'K','filled','s');
elseif Color_map==2||Color_map==3
    scatter(hax, XCoor_clean, YCoor_clean, 'g','filled','s');
elseif Color_map==4
    scatter(hax, XCoor_clean, YCoor_clean, 'c','filled','s');
elseif Color_map==5
    scatter(hax, XCoor_clean, YCoor_clean, 'y','filled','s');
end
hold(hax, 'off');