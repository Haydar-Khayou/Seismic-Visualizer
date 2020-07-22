function Visualizer_Inspect_Coordinates(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%      This function is to Show Cell information on the figure
%%   Orders

global Basic_info_Vis Seis_orig_Data
if ~handles.X_IN_Toggle.Value      % get Inline Slice
    global in_traces
    traces= Seis_orig_Data.traces(:, in_traces);
    StepLine= Basic_info_Vis.xline_step;
    X_axis= Basic_info_Vis.Xaxis_inline;
else
    global x_traces
    traces= Seis_orig_Data.traces(:, x_traces);
    StepLine= Basic_info_Vis.inline_step;
    X_axis= Basic_info_Vis.Xaxis_xline;
end



% % % % % % Data= Data_Orig;           % Get the ORIGINAL Data structure
position= get(handles.axes1, 'CurrentPoint'); % Get the Position of cursor (X Y Coordinates)

initial_xPOS= (position(1,1));        % Get x coordinates of cursor from the figure
if strcmp(handles.Distance_Axis.State, 'on')
    xPOS= ((initial_xPOS/Seis_orig_Data.Trace_Offset)*StepLine)+min(X_axis);
else
    xPOS= initial_xPOS;
end
xPOS1= (xPOS)-(rem((xPOS), StepLine));  % Fix Positions of Y Coor
xPOS2= xPOS1+StepLine;
if xPOS2-xPOS<xPOS-xPOS1
    xPOS= xPOS2;
else
    xPOS= xPOS1;
end



yPOS= (position(1,2));        % Y Coor
yPOS1= (yPOS)-(rem((yPOS), Seis_orig_Data.step));  % Fix Positions of Y Coor
yPOS2= yPOS1+Seis_orig_Data.step;
if yPOS2-yPOS<yPOS-yPOS1
    yPOS= yPOS2;
else
    yPOS= yPOS1;
end


% we only want the coordinates in the axes, not in the entire figure so we make
% the next condition
if initial_xPOS >= min(handles.axes1.XLim) && initial_xPOS <= max(handles.axes1.XLim) && yPOS >= min(handles.axes1.YLim) && yPOS <= max(handles.axes1.YLim)
    
    % Change Pointer to Crosshair
    if strcmp(handles.Zoom_In.State, 'off') && strcmp(handles.Zoom_Out.State, 'off') && strcmp(handles.Hand.State, 'off')
        set(handles.Seismic_Visualizer , 'Pointer', 'crosshair');
    end
    
    xSample= ((xPOS - min(X_axis))/StepLine)+1;         % xSample in Data_Orig matrix
    ySample= ((yPOS - min(Basic_info_Vis.Yaxis_xline))/Seis_orig_Data.step)+1;            % ySample in Data_Orig matrix
    ySample= int16(ySample);
    ySample_Amp= (traces(ySample, xSample));    % get the Amplitude of the point
    if strcmp(handles.Distance_Axis.State, 'on')
        handles.Trace_Number_Static.String= 'Distance:';
        handles.Trace_Number_Text.String = num2str(round(initial_xPOS, 2));       % Show result on the figure
    else
        handles.Trace_Number_Static.String= 'Trace:';
        handles.Trace_Number_Text.String = num2str(xPOS);       % Show result on the figure
    end
    handles.Time_Text.String = num2str(yPOS);
    handles.Amplitude_Text.String = num2str(ySample_Amp);
else          %% if Coordinates out of our axei, empty the Headers
    
    % Change Pointer to arrow
    set(handles.Seismic_Visualizer, 'Pointer', 'arrow');
    
    handles.Trace_Number_Text.String = '';
    handles.Time_Text.String= '';
    handles.Amplitude_Text.String= '';
end