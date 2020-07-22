function Delete_Single_Point(hObject, eventdata, handles)
% This tool is part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
% This is to delete Points individulally

%%  Orders

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

global Data_Trim Coor XCoor YCoor X_Trim Y_Trim Coor_Trim Sec_Size
Data = Data_Trim;

% XCoor    Get the Updated Coordinates of X
% YCoor    Get the Updated Coordinates of Y
position = get(gca ,'CurrentPoint'); % Get the Position of cursor
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

xPOS = round(xPOS);   % xPos is the Trace Number, it is integer
yPOS = round(yPOS, 8); % we want a precision of 5 decimal digits no more

% disp([xPOS yPOS])


if length(XCoor)    % make sure XCoor is not empty matrix
    if strcmp(eventdata.Key, 'delete')     % if the 'delete' Key pressed
        
        x = Coor(:,1)==xPOS;        % find where first Column of Coor=xPOS
        y = Coor(:,2)==yPOS;        % find where second Column of Coor=yPOS
        bb = x.*y;                  % multiply x and y
        bb=logical(bb);             % make bb Logical variable(to be used in Coor(bb',:))
        if sum(bb)   % if sum(bb)>0 that means the point to be deleted is existed in Coor
            Coor(bb',:)=[];     % empty the Row of Coor matrix(point Coordinates)  (bb'=> make bb Row)
        end
    else
        return       % if other key than 'delete' key is pressed do nothing
    end
    
    XCoor= Coor(:, 1)';      % Save the Coordinates
    YCoor= Coor(:, 2)';
    Coor= [XCoor' YCoor'];          % Coor matrix consists of two columna Xcoor and YCoor
    X_Trim= ((Coor(:, 1)- min(Data.X_axis))/Data.StepLine)+1; % Point Xcoor of Trimmed Matrix
    Y_Trim= ((Coor(:, 2)- min(Data.Y_axis))/Data.step)+1;  % Point Ycoor of Trimmed Matrix
    X_Trim= max(1, round(X_Trim, 0));
    X_Trim= min(X_Trim, size(Data.ExportSection, 2));    
    Y_Trim= max(1, round(Y_Trim, 0));
    Y_Trim= min(Y_Trim, size(Data.ExportSection, 1));
    Coor_Trim= [X_Trim Y_Trim];      % Coordinates matrix of Trimmed Section
    Sec_Size= size(Data.ExportSection);
    cla(handles.axes3);  % Clear Axis
    Seismic_inversion_Plotter(handles)    % Redraw the Section with Points(if there are points)
    % Put the view
    handles.axes3.XAxis.Limits= Screen_Xaxis;
    handles.axes3.YAxis.Limits= Screen_Yaxis;
end