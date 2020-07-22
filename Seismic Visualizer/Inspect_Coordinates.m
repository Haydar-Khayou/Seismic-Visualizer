function Inspect_Coordinates(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%      This function is to Show Cell information on the figure
%%   Orders

global Data_Orig
Data= Data_Orig;           % Get the ORIGINAL Data structure
position= get(handles.axes3, 'CurrentPoint'); % Get the Position of cursor (X Y Coordinates)

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



yPOS= (position(1,2));        % Y Coor
yPOS1= (yPOS)-(rem((yPOS), Data.step));  % Fix Positions of Y Coor
yPOS2= yPOS1+Data.step;
if yPOS2-yPOS<yPOS-yPOS1
    yPOS= yPOS2;
else
    yPOS= yPOS1;
end


% we only want the coordinates in the axes, not in the entire figure so we make
% the next condition
if initial_xPOS >= min(handles.axes3.XLim) && initial_xPOS <= max(handles.axes3.XLim) && yPOS >= min(handles.axes3.YLim) && yPOS <= max(handles.axes3.YLim)
    
    % Change Pointer to Crosshair
    if strcmp(handles.Zoom_In.State, 'off') && strcmp(handles.Zoom_Out.State, 'off') && strcmp(handles.Hand.State, 'off')
        set(handles.inv_fig , 'Pointer', 'crosshair');
    end
    
    xSample= ((xPOS - min(Data.Lines))/Data.StepLine)+1;         % xSample in Data_Orig matrix
    ySample= ((yPOS - min(Data.Y_axis))/Data.step)+1;            % ySample in Data_Orig matrix
    ySample= int16(ySample);
    ySample_Amp= (Data.ExportSection(ySample, xSample));    % get the Amplitude of the point
    if strcmp(handles.Distance_Axis.State, 'on')
        handles.Trace_Number_Static.String= 'Distance: ';
        handles.Trace_Number_Text.String = num2str(round(initial_xPOS, 2));       % Show result on the figure
    else
        handles.Trace_Number_Static.String= 'Trace: ';
        handles.Trace_Number_Text.String = num2str(xPOS);       % Show result on the figure
    end
    handles.Time_Text.String = num2str(yPOS);
    handles.Amplitude_Text.String = num2str(ySample_Amp);
else          %% if Coordinates out of our axei, empty the Headers
    
    % Change Pointer to arrow
    set(handles.inv_fig, 'Pointer', 'arrow');
    
    handles.Trace_Number_Text.String = '';
    handles.Time_Text.String= '';
    handles.Amplitude_Text.String= '';
end