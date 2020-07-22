function Delete_Single_clean_Point(hObject, eventdata, handles)
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


global Data_Trim Coor_clean XCoor_clean YCoor_clean Coor_Trim_clean X_Trim_clean Y_Trim_clean Sec_Size
Data= Data_Trim;
% XCoor_clean      Get the Updated Coordinates of X
% YCoor_clean      Get the Updated Coordinates of Y
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


if strcmp(eventdata.Character, 'a')
    yPOS=Data.Y_axis(1):Data.step:yPOS;
elseif strcmp(eventdata.Character, 'z')
    yPOS=yPOS:Data.step:Data.Y_axis(end)+Data.step;
elseif strcmp(eventdata.Character, 's')
    yPOS=yPOS;
end


for yPOS=yPOS
    
    xPOS = round(xPOS);   % xPos is the Trace Number, it is integer
    yPOS = round(yPOS,5); % we want a precision of 5 decimal digits no more
    
    
    if length(XCoor_clean)    % make sure XCoor_clean is not empty matrix
        
        x = Coor_clean(:,1)==xPOS;        % find where first Column of Coor=xPOS
        y = Coor_clean(:,2)==yPOS;        % find where second Column of Coor=yPOS
        bb = x.*y;                  % multiply x and y
        bb=logical(bb);             % make bb Logical variable(to be used in Coor(bb',:))
        if sum(bb)   % if sum(bb)>0 that means the point to be deleted is existed aaaain Coor
            Coor_clean(bb',:)=[];     % empty the Row of Coor matrix(point Coordinates)  (bb'=> make bb Row)
        end
        
        
        XCoor_clean = Coor_clean(:,1)';      % Save the Coordinates
        YCoor_clean = Coor_clean(:,2)';
        Coor_clean=[XCoor_clean' YCoor_clean'];          % Coor matrix consists of two columna Xcoor and YCoor_clean
        X_Trim_clean = ((Coor_clean(:,1)- min(Data.X_axis))/Data.StepLine)+1; % Point XCoor_clean of Trimmed Matrix
        Y_Trim_clean = ((Coor_clean(:,2)- min(Data.Y_axis))/Data.step)+1;  % Point YCoor_clean of Trimmed Matrix
        X_Trim_clean = max(1, round(X_Trim_clean,0));
        X_Trim_clean= min(X_Trim_clean, size(Data.ExportSection, 2));
        Y_Trim_clean = max(1, round(Y_Trim_clean,0));
        Y_Trim_clean= min(Y_Trim_clean, size(Data.ExportSection, 1));
        Coor_Trim_clean=[X_Trim_clean Y_Trim_clean];      % Coordinates matrix of Trimmed Section
        Sec_Size = size(Data.ExportSection);
    end
end
cla(handles.axes3);  % Clear Axis
Seismic_inversion_Plotter(handles)    % Redraw the Section with Points(if there are points)
% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;
