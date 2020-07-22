function Picking_Points(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
% This function is to Pick points interactively

%%  Orders
global Data_Orig Data_Trim XCoor YCoor X_Trim Y_Trim Sec_Size Coor Coor_Trim
% XCoor Get the last Updated Coordinates of X
% YCoor Get the last Updated Coordinates of Y

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

cla(handles.axes3);  % Clear Axis
Seismic_inversion_Plotter(handles)   % Redraw the Section with Points(if there are points)
Data = Data_Orig; % Get the ORIGINAL Data structure

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;

position = get(handles.axes3, 'CurrentPoint'); % Get the Position of cursor (X Y Coordinates)

xPOS= (position(1,1));        % Get x coordinates of cursor from the figure
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


%% Fix Point Positions to the nearest Peak/Trough

if handles.Adjust_Points.Value   % if the user clicked the Button
    xSample = ((xPOS - min(Data.Lines))/Data.StepLine)+1;  % Column Number of point in matrix Orig_Data
    xSample = int16(xSample);       % change type to integer(Column Number is integer!)

    
    ySample= ((yPOS - min(Data.Y_axis))/Data.step)+1;    % Row Number of point in matrix Orig_Data
    
    ySample= int16(ySample);       % change type to integer(Row Number is integer!)
    ySample_Amp= (Data.ExportSection(ySample, xSample)); % get the Amplitude of the point
    
    Sensitivity = str2double(handles.Sensitivity.String);    % Determine the pixles above and below the current point to compare
    if isnan(Sensitivity) || Sensitivity<0
        Sensitivity= 4;
        handles.Sensitivity.String= '4';
    end

    min_ySample_Orig= ((min(Data_Trim.Y_axis) - min(Data_Orig.Y_axis))/Data.step)+1;
    max_ySample_Orig= ((max(Data_Trim.Y_axis) - min(Data_Orig.Y_axis))/Data.step)+1;
    
    Min_Y_Pixel= max(min_ySample_Orig, ySample-Sensitivity);     % First Row (pixel)
    Max_Y_Pixel= min(max_ySample_Orig, ySample+Sensitivity);     % Last Row (pixel)
    
    
    % Detect Amplitude Polarity, Then Go 4 values(cells) above and below
    % the point and detect the Peak/Trough
    if ySample_Amp>0
        new_amplitude= max(Data.ExportSection(Min_Y_Pixel:Max_Y_Pixel, xSample)); % Positive -> max
    elseif ySample_Amp<0
        new_amplitude= min(Data.ExportSection(Min_Y_Pixel:Max_Y_Pixel, xSample)); % Negative -> min
    end
    
    
    % Logical Variable of new amplitude in comparing values matrix
    shift_Coor_Logical = ((Data.ExportSection(Min_Y_Pixel:Max_Y_Pixel, xSample))==new_amplitude);
    
    
    %% determine how many cells the current point should move to get to new_amplitude
    
    % peak/trough point Coordinates in comparing values matrix
    shift_Coor= min(find((Data.ExportSection(Min_Y_Pixel:Max_Y_Pixel, xSample))==new_amplitude));
    
    % our initial point Coordinates in comparing values matrix
    Point_Coor= min(find((Data.ExportSection(Min_Y_Pixel:Max_Y_Pixel, xSample))==ySample_Amp));
    % note :there is 'min', because sometimes there are two (or more) equal values
    % so we have to choose only one value
    
    if (length(shift_Coor_Logical)==((2*Sensitivity))+1)
        shift =  shift_Coor - (Sensitivity+1);     % how many cells from our point
    elseif (shift_Coor_Logical < (2*Sensitivity))  % this condition for the first and last 4th cells(Rows) in Data_Orig
        shift =  shift_Coor - Point_Coor;
    end
    
    ySample = double(ySample);  % get back to double so the Coor matrix will be saved as double
    
    fixed_ySample = ySample + shift;  % here is the number of cells we must move
    
    
    yPOS = min(Data.Y_axis) + ((fixed_ySample-1)*Data.step); % here is the new yPOS
    
end



%%  Dont get a point if it is already existed

xPOS = round(xPOS);   % xPos is the Trace Number, it is integer
yPOS = round(yPOS,5); % we want a precision of 5 decimal digits no more

x = (XCoor==xPOS);       % x is a logical vector (1 or 0)
y = (YCoor==yPOS);       % y is a logical vector (1 or 0)
bb = x.*y;               % bb is a logical vector (1 or 0)if there is
% a previous point with same coordinates we get value 1 in bb vector

% if sum(bb)>0 that means there is a point with the same coordinates as the
% current point
if sum(bb)
    xPOS=[];  % empty xPOS
    yPOS=[];  % empty yPOS
end


disp([xPOS yPOS])
XCoor=[XCoor xPOS];    % Add the new X-Coor to the X Coor matrix
YCoor=[YCoor yPOS];    % Add the new Y-Coor to the Y Coor matrix


% Draw the Points

hax=handles.axes3;
hold(hax, 'on');

%% choose colors of picked points based on Colormap(just to make things easy to see)
Color_map = getappdata(handles.inv_fig, 'popupValue');
if Color_map==1
    scatter(hax, XCoor, YCoor, 'g','filled','s');
elseif Color_map==2||Color_map==3
    scatter(hax, XCoor, YCoor, 'K','filled','s');
elseif Color_map==4
    scatter(hax, XCoor, YCoor, 'y','filled','s');
elseif Color_map==5
    scatter(hax, XCoor, YCoor, 'c','filled','s');
end
hold(hax, 'off');

Coor= [XCoor' YCoor'];          % Coor matrix consists of two columns Xcoor and YCoor
X_Trim = ((Coor(:,1)- min(Data_Trim.X_axis))/Data_Trim.StepLine)+1; % Point Xcoor of Trimmed Matrix
Y_Trim = ((Coor(:,2)- min(Data_Trim.Y_axis))/Data_Trim.step)+1;  % Point Ycoor of Trimmed Matrix
X_Trim = max(1, round(X_Trim,0));
Y_Trim = max(1, round(Y_Trim,0));
X_Trim = min(X_Trim,  size(Data_Trim.ExportSection, 2));
Y_Trim = min(Y_Trim,  size(Data_Trim.ExportSection, 1));
Coor_Trim= [X_Trim Y_Trim];      % Coordinates matrix of Trimmed Section
Sec_Size = size(Data_Trim.ExportSection);