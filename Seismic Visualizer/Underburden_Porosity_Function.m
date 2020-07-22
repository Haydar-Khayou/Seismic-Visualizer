function Underburden_Porosity_Function(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
% This function is to Pick points interactively

%%  Orders

global Data
StepLine= Data.StepLine;
step= Data.step;
Xaxis= Data.X_axis;
Yaxis= Data.Yaxis_Extra;
MODEL= getappdata(handles.Model_fig, 'MODEL');
c= ['Entity' handles.Entity_Number_Text.String];
First_Column= MODEL.(genvarname(c)).First_Column;
Last_Column= MODEL.(genvarname(c)).Last_Column;

position= get(handles.axes2 ,'CurrentPoint'); % Get the Position of cursor (X Y Coordinates)
xPOS= (position(1,1));        % X Coor

xPOS1= (xPOS)-(rem((xPOS), StepLine));  % Fix Positions of X Coor
xPOS2= xPOS1+Data.StepLine;
if xPOS2-xPOS<xPOS-xPOS1
    xPOS= xPOS2;
else
    xPOS= xPOS1;
end

xSample= ((xPOS-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
xSample= max(xSample, First_Column);
xSample= min(xSample, Last_Column);
xPOS= ((xSample-1)*StepLine)+min(Xaxis);

yPOS=(position(1,2));        % Y Coor
yPOS1=(yPOS)-(rem((yPOS),step));  % Fix Positions of Y Coor
yPOS2=yPOS1+step;
if yPOS2-yPOS<yPOS-yPOS1
    yPOS=yPOS2;
else
    yPOS=yPOS1;
end

ySample= round(((yPOS-min(Yaxis))/step)+1, 0);

%% Edit and save Values
Entity_Num= handles.Entity_Number_Text.String;
if handles.UB_PorLeftCoor.Value
    UB_Left_PorPoint= [xPOS yPOS];    % Coordinates of Left Porosity Point
    UB_Right_PorPoint= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]);
    
    % Adjust xPOS
    if length(UB_Right_PorPoint)
        UB_Left_PorPoint(1)= min(UB_Left_PorPoint(1), UB_Right_PorPoint(1));
    end
    
    % Adjust yPOS
    if MODEL.(genvarname(c)).Matrix(ySample, xSample)==0
        true_y_Values= find(MODEL.(genvarname(c)).Matrix(:, xSample)==1);
        if ySample<min(true_y_Values)
            ySample=min(true_y_Values);
        elseif ySample>max(true_y_Values)
            ySample=max(true_y_Values);
        end
        UB_Left_PorPoint(2)= ((ySample-1)*step)+min(Yaxis);
    end
    
    setappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num], UB_Left_PorPoint);   % Save Left Porosity Point in figure
    
    UB_Left_MidZone = ((UB_Left_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    UB_Left_MidZone = max(UB_Left_MidZone(1), First_Column);
    UB_Left_MidZone = min(UB_Left_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['UB_Left_MidZone' 'Entity' Entity_Num], UB_Left_MidZone); % Save Column number
elseif handles.UB_PorRightCoor.Value
    UB_Right_PorPoint=[xPOS yPOS];   % Coordinates of Right Porosity Point
    UB_Left_PorPoint= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);
    
    % Adjust xPOS
    if length(UB_Left_PorPoint)
        UB_Right_PorPoint(1)= max(UB_Right_PorPoint(1), UB_Left_PorPoint(1));
    end
    
    % Adjust yPOS
    if MODEL.(genvarname(c)).Matrix(ySample, xSample)==0
        true_y_Values= find(MODEL.(genvarname(c)).Matrix(:, xSample)==1);
        if ySample<min(true_y_Values)
            ySample=min(true_y_Values);
        elseif ySample>max(true_y_Values)
            ySample=max(true_y_Values);
        end
        UB_Right_PorPoint(2)= ((ySample-1)*step)+min(Yaxis);
    end
    
    setappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num], UB_Right_PorPoint); % Save Right Porosity Point in figure
    
    UB_Right_MidZone = ((UB_Right_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    UB_Right_MidZone = max(UB_Right_MidZone(1), First_Column);
    UB_Right_MidZone = min(UB_Right_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['UB_Right_MidZone' 'Entity' Entity_Num], UB_Right_MidZone); % Save Column number
end


%% Draw the Points
cla(handles.axes2);             % Clear the axes2
Model_Plotter(handles)          % Plot the Entity
UB_Left_PorPoint= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);   % bring Value of UB_Left_PorPoint from figure
UB_Right_PorPoint= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]); % bring Value of UB_Right_PorPoint from figure

if size(UB_Left_PorPoint,2)==0    % in the firt pick we have Either Left or Right so we have to fill it for the plotting
    UB_Left_PorPoint= UB_Right_PorPoint;
    setappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num], UB_Left_PorPoint);
    
    UB_Left_MidZone = ((UB_Left_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    UB_Left_MidZone = max(UB_Left_MidZone(1), First_Column);
    UB_Left_MidZone = min(UB_Left_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['UB_Left_MidZone' 'Entity' Entity_Num], UB_Left_MidZone); % Save Column number    
end
if size(UB_Right_PorPoint,2)==0
    UB_Right_PorPoint= UB_Left_PorPoint;
    setappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num], UB_Right_PorPoint);
    
    UB_Right_MidZone = ((UB_Right_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    UB_Right_MidZone = max(UB_Right_MidZone(1), First_Column);
    UB_Right_MidZone = min(UB_Right_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['UB_Right_MidZone' 'Entity' Entity_Num], UB_Right_MidZone); % Save Column number    
end

x=[UB_Left_PorPoint(1) UB_Right_PorPoint(1)];
y=[UB_Left_PorPoint(2) UB_Right_PorPoint(2)];


hax=handles.axes2;
hold(hax, 'on');
scatter(hax, UB_Left_PorPoint(1), UB_Left_PorPoint(2), 'k','filled','s'); % Plot UB_Right_PorPoint
scatter(hax, UB_Right_PorPoint(1), UB_Right_PorPoint(2), 'k','filled','s'); % Plot UB_Right_PorPoint
plot(hax, x, y, 'k');   % Plot UB_Left_PorPoint
hold(hax, 'off');

handles.UB_PorMidValue_FirstCol.String= num2str(UB_Left_PorPoint(1));
handles.UB_PorMidValue_LastCol.String= num2str(UB_Right_PorPoint(1));

