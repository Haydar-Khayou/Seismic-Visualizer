function Model_Plotter(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Plotting
global Data
Xaxis= Data.X_axis;
Yaxis= Data.Yaxis_Extra;
MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
Horizons_grid= getappdata(handles.Model_fig, 'Horizons_grid');
NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities'); % get how many entities we have


if handles.Show_Full_Entities.Value  % When Press Show_Full_Entities Button
    Yaxis(end)= [];  % in Horizon Grid Y-axis is the same as in Seismic Section(actually it is a seismic section)
    % So we delete the extra_Value we've added earlier in Function Check_Entities
    
    imagesc(handles.axes2, Xaxis, Yaxis, Horizons_grid);
    title('Grid of Horizons', 'Color', 'r', 'FontSize', 18);
    xlabel(handles.axes2, 'Trace number');
    ylabel(handles.axes2, 'Time(ms)');
    set(handles.axes2, 'XAxisLocation', 'top');
    colormap(parula)
    handles.Show_Full_Entities.BackgroundColor= [.1 .9 .1];
else
    
    if handles.Next_Entity_Button.Value   % When Press Next Button
        Entity_Num= str2double(handles.Entity_Number_Text.String) +1;
        Entity_Num= min(Entity_Num, NumberofEntities);   % don't Cross the maximum number of entities
        Entity_Num= max(Entity_Num, 1);   % There is no Entity Number less than 1
        handles.Entity_Number_Text.String= num2str(Entity_Num);
    elseif handles.Previous_Entity_Button.Value  % When Press Previous Button
        Entity_Num= str2double(handles.Entity_Number_Text.String) -1;
        Entity_Num= min(Entity_Num, NumberofEntities);   % don't Cross the maximum number of entities
        Entity_Num= max(Entity_Num, 1);   % There is no Entity Number less than 1
        handles.Entity_Number_Text.String= num2str(Entity_Num);
    else
        Entity_Num= str2double(handles.Entity_Number_Text.String);  % The first time the Entity to be plotted is Entity Number 1
        handles.Entity_Number_Text.String= num2str(Entity_Num);  % Store Entity Number in this Object
    end
    
    N= num2str(Entity_Num);       % Convert Entity Number to String
    c= ['Entity' N];                % Create string variable named c, Contains Entity+its number
    Entity= MODEL.(genvarname(c)).Matrix;
    Entity_Plot_Obj= imagesc(handles.axes2, Xaxis, Yaxis, Entity);
    handles.Entity_Plot_Obj= Entity_Plot_Obj;   % The image is saved as Object in 'handles' structures
    guidata(handles.Model_fig, handles);
    colormap(parula)
    
    if isfield(MODEL.(genvarname(c)), 'Geology')
        handles.Type_Text.Visible= 'On';
        handles.Entity_Type_Show.String= MODEL.(genvarname(c)).Geology.Type;
    else
        handles.Type_Text.Visible= 'Off';
        handles.Entity_Type_Show.String='';
    end
    
    
    Entity_Num= handles.Entity_Number_Text.String;
    % if Reservoir
    if handles.Entity_Type_Menu.Value==2
        RES_Left_PorPoint= getappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num]);   % bring Value of RES_Left_PorPoint from figure
        RES_Right_PorPoint= getappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num]); % bring Value of RES_Right_PorPoint from figure
        if size(RES_Left_PorPoint, 2) || size(RES_Right_PorPoint, 2)
            if size(RES_Left_PorPoint, 2)==0    % in the first pick we have Either Left or Right so we have to fill it for the plotting
                RES_Left_PorPoint= RES_Right_PorPoint;
            end
            if size(RES_Right_PorPoint, 2)==0
                RES_Right_PorPoint= RES_Left_PorPoint;
            end
            x= [RES_Left_PorPoint(1) RES_Right_PorPoint(1)];
            y= [RES_Left_PorPoint(2) RES_Right_PorPoint(2)];
            hax= handles.axes2;
            hold(hax, 'on');
            scatter(hax, RES_Left_PorPoint(1), RES_Left_PorPoint(2), 'k', 'filled', 's'); % Plot RES_Right_PorPoint
            scatter(hax, RES_Right_PorPoint(1), RES_Right_PorPoint(2), 'k', 'filled', 's'); % Plot RES_Right_PorPoint
            plot(hax, x, y, 'k');   % Plot RES_Left_PorPoint
            hold(hax, 'off');
        end
        
        if handles.RES_PorRightCoor.Value || handles.RES_PorLeftCoor.Value
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
        else
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', '');
        end
        
        % if Underburden
    elseif handles.Entity_Type_Menu.Value==3
        UB_Left_PorPoint= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);   % bring Value of UB_Left_PorPoint from figure
        UB_Right_PorPoint= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]); % bring Value of UB_Right_PorPoint from figure
        if size(UB_Left_PorPoint,2) || size(UB_Right_PorPoint,2)
            if size(UB_Left_PorPoint,2)==0    % in the firt pick we have Either Left or Right so we have to fill it for the plotting
                UB_Left_PorPoint= UB_Right_PorPoint;
            end
            if size(UB_Right_PorPoint,2)==0
                UB_Right_PorPoint= UB_Left_PorPoint;
            end
            x= [UB_Left_PorPoint(1) UB_Right_PorPoint(1)];
            y= [UB_Left_PorPoint(2) UB_Right_PorPoint(2)];
            hax= handles.axes2;
            hold(hax, 'on');
            scatter(hax, UB_Left_PorPoint(1), UB_Left_PorPoint(2), 'k', 'filled', 's'); % Plot UB_Right_PorPoint
            scatter(hax, UB_Right_PorPoint(1), UB_Right_PorPoint(2), 'k', 'filled', 's'); % Plot UB_Right_PorPoint
            plot(hax, x, y, 'k');   % Plot UB_Left_PorPoint
            hold(hax, 'off');
        end
        
        if handles.UB_PorRightCoor.Value || handles.UB_PorLeftCoor.Value
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
        else
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', '');
        end
    elseif handles.Entity_Type_Menu.Value==1
        OB_Left_PorPoint= getappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num]);   % bring Value of OB_Left_PorPoint from figure
        OB_Right_PorPoint= getappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num]); % bring Value of OB_Right_PorPoint from figure
        if size(OB_Left_PorPoint, 2) || size(OB_Right_PorPoint,2)
            if size(OB_Left_PorPoint, 2)==0    % in the firt pick we have Either Left or Right so we have to fill it for the plotting
                OB_Left_PorPoint= OB_Right_PorPoint;
            end
            if size(OB_Right_PorPoint, 2)==0
                OB_Right_PorPoint= OB_Left_PorPoint;
            end
            x= [OB_Left_PorPoint(1) OB_Right_PorPoint(1)];
            y= [OB_Left_PorPoint(2) OB_Right_PorPoint(2)];
            hax= handles.axes2;
            hold(hax, 'on');
            scatter(hax, OB_Left_PorPoint(1), OB_Left_PorPoint(2), 'k', 'filled', 's'); % Plot OB_Right_PorPoint
            scatter(hax, OB_Right_PorPoint(1), OB_Right_PorPoint(2), 'k', 'filled', 's'); % Plot OB_Right_PorPoint
            plot(hax, x, y, 'k');   % Plot OB_Left_PorPoint
            hold(hax, 'off');
        end
        
        if handles.OB_PorRightCoor.Value || handles.OB_PorLeftCoor.Value
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
        else
            set(handles.Entity_Plot_Obj , 'ButtonDownFcn', '');
        end
    end
    
    title(['Entity Number : ' num2str(Entity_Num)], 'Color', 'r', 'FontSize', 18)
    xlabel(handles.axes2, 'Trace number');
    ylabel(handles.axes2, 'Time(ms)');
    set(handles.axes2, 'XAxisLocation', 'top');
    handles.Show_Full_Entities.BackgroundColor= [.94 .94 .94];
end


%% Fixing Buttons and tables values
if handles.Entity_Type_Menu.Value==1
    
    handles.OB_Mineralogy_List.String= '';
    handles.OB_Mineralogy_List.Visible= 'Off';
    
    handles.OB_Fluids_List.String= '';
    handles.OB_Fluids_List.Visible= 'Off';
    
    
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['OB_Carbonate_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.OB_Carbonate_ShowMineralogyList.Value= 0;
        handles.OB_Carbonate_ShowMineralogyList.Visible= 'Off';
    else
        handles.OB_Carbonate_ShowMineralogyList.Value= 0;
        handles.OB_Carbonate_ShowMineralogyList.Visible= 'On';
    end
    
    Minerals= getappdata(handles.Model_fig, ['OB_Clastics_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.OB_Clastic_ShowMineralogyList.Value= 0;
        handles.OB_Clastic_ShowMineralogyList.Visible= 'Off';
    else
        handles.OB_Clastic_ShowMineralogyList.Value= 0;
        handles.OB_Clastic_ShowMineralogyList.Visible= 'On';
    end
    
    Minerals= getappdata(handles.Model_fig, ['OB_Basalt_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.OB_Basalt_ShowMineralogyList.Value= 0;
        handles.OB_Basalt_ShowMineralogyList.Visible= 'Off';
    else
        handles.OB_Basalt_ShowMineralogyList.Value= 0;
        handles.OB_Basalt_ShowMineralogyList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['OB_Carbonate_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.OB_Carbonate_ShowFluidsList.Value= 0;
        handles.OB_Carbonate_ShowFluidsList.Visible= 'Off';
    else
        handles.OB_Carbonate_ShowFluidsList.Value= 0;
        handles.OB_Carbonate_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['OB_Clastics_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.OB_Clastic_ShowFluidsList.Value= 0;
        handles.OB_Clastic_ShowFluidsList.Visible= 'Off';
    else
        handles.OB_Clastic_ShowFluidsList.Value= 0;
        handles.OB_Clastic_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['OB_Basalt_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.OB_Basalt_ShowFluidsList.Value= 0;
        handles.OB_Basalt_ShowFluidsList.Visible= 'Off';
    else
        handles.OB_Basalt_ShowFluidsList.Value= 0;
        handles.OB_Basalt_ShowFluidsList.Visible= 'On';
    end
    
    
    
    
elseif handles.Entity_Type_Menu.Value==2
    
    handles.RES_Fluids_List.String= '';
    handles.RES_Fluids_List.Visible= 'Off';
    
    
    
    Entity_Num= handles.Entity_Number_Text.String;
    
    Fluids= getappdata(handles.Model_fig, ['RES_Carbonate_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.RES_Carbonate_ShowFluidsList.Value= 0;
        handles.RES_Carbonate_ShowFluidsList.Visible= 'Off';
    else
        handles.RES_Carbonate_ShowFluidsList.Value= 0;
        handles.RES_Carbonate_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['RES_Clastics_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.RES_Clastic_ShowFluidsList.Value= 0;
        handles.RES_Clastic_ShowFluidsList.Visible= 'Off';
    else
        handles.RES_Clastic_ShowFluidsList.Value= 0;
        handles.RES_Clastic_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['RES_Basalt_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.RES_Basalt_ShowFluidsList.Value= 0;
        handles.RES_Basalt_ShowFluidsList.Visible= 'Off';
    else
        handles.RES_Basalt_ShowFluidsList.Value= 0;
        handles.RES_Basalt_ShowFluidsList.Visible= 'On';
    end
    
    
elseif handles.Entity_Type_Menu.Value==3
    handles.UB_Mineralogy_List.String= '';
    handles.UB_Mineralogy_List.Visible= 'Off';
    
    handles.UB_Fluids_List.String= '';
    handles.UB_Fluids_List.Visible= 'Off';
    
    
    
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.UB_Carbonate_ShowMineralogyList.Value= 0;
        handles.UB_Carbonate_ShowMineralogyList.Visible= 'Off';
    else
        handles.UB_Carbonate_ShowMineralogyList.Value= 0;
        handles.UB_Carbonate_ShowMineralogyList.Visible= 'On';
    end
    
    Minerals= getappdata(handles.Model_fig, ['UB_Clastics_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.UB_Calstic_ShowMineralogyList.Value= 0;
        handles.UB_Clastic_ShowMineralogyList.Visible= 'Off';
    else
        handles.UB_Calstic_ShowMineralogyList.Value= 0;
        handles.UB_Clastic_ShowMineralogyList.Visible= 'On';
    end
    
    Minerals= getappdata(handles.Model_fig, ['UB_Basalt_Minerals' 'Entity' Entity_Num]);
    if isempty(Minerals)
        handles.UB_Basalt_ShowMineralogyList.Value= 0;
        handles.UB_Basalt_ShowMineralogyList.Visible= 'Off';
    else
        handles.UB_Basalt_ShowMineralogyList.Value= 0;
        handles.UB_Basalt_ShowMineralogyList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['UB_Carbonate_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.UB_Carbonate_ShowFluidsList.Value= 0;
        handles.UB_Carbonate_ShowFluidsList.Visible= 'Off';
    else
        handles.UB_Carbonate_ShowFluidsList.Value= 0;
        handles.UB_Carbonate_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['UB_Clastics_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.UB_Clastic_ShowFluidsList.Value= 0;
        handles.UB_Clastic_ShowFluidsList.Visible= 'Off';
    else
        handles.UB_Clastic_ShowFluidsList.Value= 0;
        handles.UB_Clastic_ShowFluidsList.Visible= 'On';
    end
    
    Fluids= getappdata(handles.Model_fig, ['UB_Basalt_Fluids' 'Entity' Entity_Num]);
    if isempty(Fluids)
        handles.UB_Basalt_ShowFluidsList.Value= 0;
        handles.UB_Basalt_ShowFluidsList.Visible= 'Off';
    else
        handles.UB_Basalt_ShowFluidsList.Value= 0;
        handles.UB_Basalt_ShowFluidsList.Visible= 'On';
    end
end