function Overburden_Porosity_Function(hObject, eventdata, handles)
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
if handles.OB_PorLeftCoor.Value
    OB_Left_PorPoint= [xPOS yPOS];    % Coordinates of Left Porosity Point
    OB_Right_PorPoint= getappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num]);
    
    % Adjust xPOS
    if length(OB_Right_PorPoint)
        OB_Left_PorPoint(1)= min(OB_Left_PorPoint(1), OB_Right_PorPoint(1));
    end
    
    % Adjust yPOS
    if MODEL.(genvarname(c)).Matrix(ySample, xSample)==0
        true_y_Values= find(MODEL.(genvarname(c)).Matrix(:, xSample)==1);
        if ySample<min(true_y_Values)
            ySample=min(true_y_Values);
        elseif ySample>max(true_y_Values)
            ySample=max(true_y_Values);
        end
        OB_Left_PorPoint(2)= ((ySample-1)*step)+min(Yaxis);
    end
    
    setappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num], OB_Left_PorPoint);   % Save Left Porosity Point in figure
    
    OB_Left_MidZone = ((OB_Left_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    OB_Left_MidZone = max(OB_Left_MidZone(1), First_Column);
    OB_Left_MidZone = min(OB_Left_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['OB_Left_MidZone' 'Entity' Entity_Num], OB_Left_MidZone); % Save Column number
elseif handles.OB_PorRightCoor.Value
    OB_Right_PorPoint=[xPOS yPOS];   % Coordinates of Right Porosity Point
    OB_Left_PorPoint= getappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num]);
    
    % Adjust xPOS
    if length(OB_Left_PorPoint)
        OB_Right_PorPoint(1)= max(OB_Right_PorPoint(1), OB_Left_PorPoint(1));
    end
    
    % Adjust yPOS
    if MODEL.(genvarname(c)).Matrix(ySample, xSample)==0
        true_y_Values= find(MODEL.(genvarname(c)).Matrix(:, xSample)==1);
        if ySample<min(true_y_Values)
            ySample=min(true_y_Values);
        elseif ySample>max(true_y_Values)
            ySample=max(true_y_Values);
        end
        OB_Right_PorPoint(2)= ((ySample-1)*step)+min(Yaxis);
    end
    
    setappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num], OB_Right_PorPoint); % Save Right Porosity Point in figure
    
    OB_Right_MidZone = ((OB_Right_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    OB_Right_MidZone = max(OB_Right_MidZone(1), First_Column);
    OB_Right_MidZone = min(OB_Right_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['OB_Right_MidZone' 'Entity' Entity_Num], OB_Right_MidZone); % Save Column number
end


%% Draw the Points
cla(handles.axes2);             % Clear the axes2
Model_Plotter(handles)          % Plot the Entity
OB_Left_PorPoint= getappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num]);   % bring Value of OB_Left_PorPoint from figure
OB_Right_PorPoint= getappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num]); % bring Value of OB_Right_PorPoint from figure

if size(OB_Left_PorPoint,2)==0    % in the firt pick we have Either Left or Right so we have to fill it for the plotting
    OB_Left_PorPoint= OB_Right_PorPoint;
    setappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num], OB_Left_PorPoint);
    
    OB_Left_MidZone = ((OB_Left_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    OB_Left_MidZone = max(OB_Left_MidZone(1), First_Column);
    OB_Left_MidZone = min(OB_Left_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['OB_Left_MidZone' 'Entity' Entity_Num], OB_Left_MidZone); % Save Column number    
end
if size(OB_Right_PorPoint,2)==0
    OB_Right_PorPoint= OB_Left_PorPoint;
    setappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num], OB_Right_PorPoint);
    
    OB_Right_MidZone = ((OB_Right_PorPoint(1)-min(Xaxis))/StepLine)+1;  % Column Number of point in matrix
    OB_Right_MidZone = max(OB_Right_MidZone(1), First_Column);
    OB_Right_MidZone = min(OB_Right_MidZone(1), Last_Column);
    setappdata(handles.Model_fig, ['OB_Right_MidZone' 'Entity' Entity_Num], OB_Right_MidZone); % Save Column number 
end

x=[OB_Left_PorPoint(1) OB_Right_PorPoint(1)];
y=[OB_Left_PorPoint(2) OB_Right_PorPoint(2)];


hax=handles.axes2;
hold(hax, 'on');
scatter(hax, OB_Left_PorPoint(1), OB_Left_PorPoint(2), 'k','filled','s'); % Plot OB_Right_PorPoint
scatter(hax, OB_Right_PorPoint(1), OB_Right_PorPoint(2), 'k','filled','s'); % Plot OB_Right_PorPoint
plot(hax, x, y, 'k');   % Plot OB_Left_PorPoint
hold(hax, 'off');

handles.OB_PorMidValue_FirstCol.String= num2str(OB_Left_PorPoint(1));
handles.OB_PorMidValue_LastCol.String= num2str(OB_Right_PorPoint(1));

