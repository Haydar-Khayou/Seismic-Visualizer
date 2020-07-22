function varargout = Seismic_inversion(varargin)
% SEISMIC_INVERSION MATLAB code for Seismic_inversion.fig
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%      SEISMIC_INVERSION('Property','Value',...) creates a new SEISMIC_INVERSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Seismic_inversion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Seismic_inversion_OpeningFcn via varargin.
%
%      *See GUI Picking_Mode_Panel on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Seismic_inversion

% Last Modified by GUIDE v2.5 23-Nov-2019 22:24:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Seismic_inversion_OpeningFcn, ...
    'gui_OutputFcn',  @Seismic_inversion_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Seismic_inversion is made visible.
function Seismic_inversion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Seismic_inversion (see VARARGIN)

% Choose default command line output for Seismic_inversion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Seismic_inversion wait for user response (see UIRESUME)
% uiwait(handles.inv_fig);



% --- Outputs from this function are returned to the command line.
function varargout = Seismic_inversion_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

Check_Data= dir('Data.mat');   % Check whether there is data
if ~isempty(Check_Data)
    load('Data.mat');              % Load Seismic Data
    global Data_Orig               % 'Data_Orig' is a copy of Data we don't work on, it is kept in case of reset to default.
    global Data_Trim               % 'Data_Trim' is the copy we work on.
    global Basic_info
    global Sec_Size
    Data_Orig= Data;
    Data_Trim= Data;
    Basic_info= Data.Basic_info_Vis;
    Sec_Size= size(Data.ExportSection);
    
    global  XCoor YCoor Coor Coor_Trim Coor_clean Coor_Trim_clean XCoor_clean YCoor_clean
    
    XCoor= [];   % XCoor is the x coordinates vector, it is set to [] at the beginning of picking
    YCoor= [];   % YCoor is the y coordinates vector, it is set to [] at the beginning of picking
    
    Coor= [];    % Empty Coor Matrix
    Coor_Trim= [];
    Coor_clean= [];   % empty Coor Matrix
    Coor_Trim_clean= [];
    XCoor_clean= [];
    YCoor_clean= [];
    Seismic_inversion_first_Time_Plotter(handles)
    Inspect_Coordinates_ClickedCallback(hObject, eventdata, handles)
% % %     delete('Data.mat');           % delete from disk
else
    uiwait(errordlg('Open Seismic Visualizer to get data from.', 'Error'));
    close;
end




% --- Executes on button press in Grid_On.
function Grid_On_Callback(hObject, eventdata, handles)
% hObject    handle to Grid_On (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Grid_On
switch handles.Grid_On.Value
    case 1
        grid(handles.axes3, 'on');                            % grid the Axis
    otherwise
        grid(handles.axes3, 'off');
end


function Max_Amplitude_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Amplitude_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Amplitude_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Amplitude_Text as a double
handles.Max_amp_Slider.Value= str2double(handles.Max_Amplitude_Text.String);
% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;

% --- Executes during object creation, after setting all properties.
function Max_Amplitude_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Amplitude_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_Amplitude_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Amplitude_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Amplitude_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Amplitude_Text as a double

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;

% --- Executes during object creation, after setting all properties.
function Min_Amplitude_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Amplitude_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Max_amp_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Max_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Max_Amplitude_Text.String= num2str(handles.Max_amp_Slider.Value);
% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;

% --- Executes during object creation, after setting all properties.
function Max_amp_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light Grey background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Min_amp_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Min_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.Min_Amplitude_Text.String= num2str(handles.Min_amp_Slider.Value);
% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;


% --- Executes during object creation, after setting all properties.
function Min_amp_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light Grey background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --------------------------------------------------------------------
function Color_Bar_Menue_OnCallback(hObject, eventdata, handles)
% hObject    handle to Color_Bar_Menue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c_bar= colorbar(handles.axes3);                % Save the current colorbar
c_bar.Location='southoutside';
c_bar.Position=[0.7276    0.0727    0.2272    0.0347];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Color_Bar_Menue_OffCallback(hObject, eventdata, handles)
% hObject    handle to Color_Bar_Menue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorbar(handles.axes3,'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --------------------------------------------------------------------
function Color_Map_Menue_Callback(hObject, eventdata, handles)
% hObject    handle to Color_Map_Menue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with Two options
choice = questdlg('Do you want to close?', ...
    'Close', ...
    'Yes','Cancel','Cancel');
% Handle response
switch choice
    case 'Yes'
        close
end


% --- Executes on button press in GetAxis.
function GetAxis_Callback(hObject, eventdata, handles)
% hObject    handle to GetAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prepare Some Data
global XCoor YCoor Coor Coor_Trim
% XCoor= [];        % XCoor is the x coordinates vector, it is set to [] at the beginning of picking
% YCoor= [];        % YCoor is the y coordinates vector, it is set to [] at the beginning of picking
% Coor=[];          % empty Coor Matrix
% Coor_Trim= [];
Trim_Seismic_Section(handles)


% --- Executes on button press in Default_Section.
function Default_Section_Callback(hObject, eventdata, handles)
% hObject    handle to Default_Section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with Two options
set(handles.inv_fig , 'WindowButtonMotionFcn', ' ');
choice = questdlg('Do you want to get back to the Original Section(full Section)?', ...
    'Warning', ...
    'Yes', 'Cancel', 'Cancel');
% Handle response
switch choice
    case 'Yes'
        Seismic_inversion_first_Time_Plotter(handles)
end
if strcmp(handles.Inspect_Coordinates.State, 'on')
    set(handles.inv_fig , 'WindowButtonMotionFcn', @(hObject,eventdata)Seismic_inversion('inv_fig_WindowButtonMotionFcn',hObject,eventdata,guidata(hObject)));
    handles.Cell_Information.Visible= 'On';    % Show the panel of Headers
else
    set(handles.inv_fig , 'WindowButtonMotionFcn', ' ');
    handles.Cell_Information.Visible= 'Off';   % Hide the panel of Headers
end





function Min_Trace_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Trace_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Trace_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Trace_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_Trace_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Trace_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Trace_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Trace_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Trace_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Trace_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_Trace_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Trace_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_Time_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Time_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Time_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Time_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_Time_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Time_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Time_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Time_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Time_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Time_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_Time_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Time_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Cut_Section.
function Cut_Section_Callback(hObject, eventdata, handles)
% hObject    handle to Cut_Section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prepare Some Data
global XCoor YCoor Coor Coor_Trim
% XCoor= [];        % XCoor is the x coordinates vector, it is set to [] at the beginning of picking
% YCoor= [];        % YCoor is the y coordinates vector, it is set to [] at the beginning of picking
% Coor= [];          % empty Coor Matrix
% Coor_Trim= [];
Manual_Trim_Seismic_Section(handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Colormap_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global XCoor YCoor XCoor_clean YCoor_clean

% XCoor             Get the Updated Coordinates of X
% YCoor             Get the Updated Coordinates of Y
% Get The Picks and plot them on the Seismic Section
% XCoor_clean       Get the Updated Coordinates of X
% YCoor_clean       Get the Updated Coordinates of Y

d = dialog('Position',[300 300 250 150],'Name','Select One');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String','Select Colormap');

popup = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 100 25],...
    'String',{'Seismic';'Red Blue';'Light(Red Blue)';'Red Black';'Grey'},...
    'UserData',{handles, XCoor, YCoor, XCoor_clean, YCoor_clean},...
    'Callback',{@popup_callback});

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');
popup.Value= getappdata(handles.inv_fig, 'popupValue');


% Wait for d to close before running to completion
uiwait(d);

function popup_callback(popup,event)
handles= popup.UserData{1};
XCoor= popup.UserData{2};
YCoor= popup.UserData{3};
idx = popup.Value;
popup_items = popup.String;
choice = char(popup_items(idx,:));
load('Seis_maps.mat')
switch choice
    case 'Seismic'
        colormap(handles.axes3, Seismic_map);
        setappdata(handles.inv_fig, 'popupValue', 1);
    case 'Red Blue'
        colormap(handles.axes3,Red_blue_map);
        setappdata(handles.inv_fig, 'popupValue', 2);
    case 'Light(Red Blue)'
        colormap(handles.axes3,Red_blue_Light_map);
        setappdata(handles.inv_fig, 'popupValue', 3);
    case 'Red Black'
        colormap(handles.axes3,Red_black_map);
        setappdata(handles.inv_fig, 'popupValue', 4);
    case 'Grey'
        colormap(handles.axes3,Grey);
        setappdata(handles.inv_fig, 'popupValue', 5);
end

% Draw the Picking Points

hax=handles.axes3;
hold(hax, 'on');

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

% Draw the clean Points

hax=handles.axes3;
hold(hax, 'on');
XCoor_clean= popup.UserData{4};
YCoor_clean= popup.UserData{5};
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


% --- Executes on button press in FlipColorbar.
function FlipColorbar_Callback(hObject, eventdata, handles)
% hObject    handle to FlipColorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FlipColorbar
load('Seis_maps_for_inv.mat');
Seismic_map= flipud(Seismic_map);
Red_blue_map= flipud(Red_blue_map);
Red_blue_Light_map= flipud(Red_blue_Light_map);
Red_black_map= flipud(Red_black_map);
Grey= flipud(Grey);
save('Seis_maps_for_inv.mat','Seismic_map','Red_blue_map','Red_blue_Light_map','Red_black_map','Grey')
col= getappdata(handles.inv_fig, 'popupValue');
switch col
    case 1
        colormap(handles.axes3,Seismic_map);
        setappdata(handles.inv_fig, 'popupValue', 1);
    case 2
        colormap(handles.axes3,Red_blue_map)
        setappdata(handles.inv_fig, 'popupValue', 2);
    case 3
        colormap(handles.axes3,Red_blue_Light_map);
        setappdata(handles.inv_fig, 'popupValue', 3);
    case 4
        colormap(handles.axes3,Red_black_map);
        setappdata(handles.inv_fig, 'popupValue', 4);
    case 5
        colormap(handles.axes3,Grey);
        setappdata(handles.inv_fig, 'popupValue', 5);
end
if ~handles.FlipColorbar.Value
    handles.FlipColorbar.String= 'Flip Colorbar';
else
    handles.FlipColorbar.String= 'Flip Colorbar';
end


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aboutStr= {'Seismic Visualizer V1.0';''; 'This tool has been programmed by';'Haydar Khayou';'as part of a Master''s Thesis.'...
    ;'';'';'';'Damascus University';'Faculty of Science';'Department of Geology'};


d = dialog('Position',[500 200 550 400],'Name','about');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 75 500 300],...
    'String',aboutStr,...
    'ForegroundColor','k',...
    'FontSize',16,...
    'HorizontalAlignment','center');

btn = uicontrol('Parent',d,...
    'Position',[230 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');



% --- Executes on button press in Start_Picking.
function Start_Picking_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Picking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Start_Picking

if handles.Start_Picking.Value
    if strcmp(handles.Distance_Axis.State, 'on')
        set(handles.Distance_Axis, 'State', 'off')
    end
    handles.Start_Picking.BackgroundColor=[0 1 0];
    % Set ButtonDownFcn of the image as below
    set(handles.Seis_Sec_Obj , 'ButtonDownFcn', @(hObject,eventdata)Seismic_inversion('axes3_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
    set(handles.inv_fig , 'WindowKeyPressFcn', @(hObject,eventdata)Seismic_inversion('inv_fig_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));
    handles.Start_Picking.String='Picking Mode is ON';
    
    % Adjust Point to peak/trough Button properties
    handles.Picking_Mode_Panel.Visible='on';
    handles.Adjust_Points.Value=0;
    
    % Delete all Picks Button properties
    handles.Picking_Mode_Panel.Visible='on';
else
    set(handles.Seis_Sec_Obj , 'ButtonDownFcn', ' ');
    set(handles.inv_fig , 'WindowKeyPressFcn', ' ');
    handles.Start_Picking.String='Picking Mode is OFF';
    handles.Start_Picking.BackgroundColor=[0.9 0.9 0.9];
    
    % Adjust Point to peak/trough Button properties
    handles.Picking_Mode_Panel.Visible='off';
    handles.Adjust_Points.String='Adjust Point to Peak/Trough is OFF';
    handles.Adjust_Points.Value=0;
    handles.Adjust_Points.BackgroundColor=[0.9 0.9 0.9];
    
    % Delete all Picks Button properties
    handles.Picking_Mode_Panel.Visible='off';
end
% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;






% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Picking_Points(hObject, eventdata, handles)




% --- Executes on key press with focus on inv_fig or any of its controls.
function inv_fig_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to inv_fig (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(eventdata.Key, 'delete')     % if the 'delete' Key pressed
    Delete_Single_Point(hObject, eventdata, handles)
elseif (strcmp(eventdata.Character, 'a') | strcmp(eventdata.Character, 'z') | strcmp(eventdata.Character, 's'))    % if the 'delete' Key pressed
    Delete_Single_clean_Point(hObject, eventdata, handles)
elseif strcmp(eventdata.Modifier, 'shift') & (strcmp(eventdata.Character, 'A') | strcmp(eventdata.Character, 'Z') | strcmp(eventdata.Character, 'S'))     % if the 'Shift' Key pressed
    Clean_Section(hObject, eventdata, handles)
end



% --- Executes on button press in Delete_Picks.
function Delete_Picks_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Picks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global XCoor YCoor Coor Coor_Trim
XCoor= [];          % XCoor is the x coordinates vector, it is set to [] at the beginning of picking
YCoor= [];          % YCoor is the y coordinates vector, it is set to [] at the beginning of picking
Coor= [];            % empty Coor Matrix
Coor_Trim= [];

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;


% --- Executes on button press in Adjust_Points.
function Adjust_Points_Callback(hObject, eventdata, handles)
% hObject    handle to Adjust_Points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Adjust_Points
if handles.Adjust_Points.Value
    handles.Adjust_Points.String='Adjust Point to Peak/Trough is ON';
    handles.Adjust_Points.Value=1;
    handles.Adjust_Points.BackgroundColor=[0 1 0];
else
    handles.Adjust_Points.String='Adjust Point to Peak/Trough is OFF';
    handles.Adjust_Points.Value=0;
    handles.Adjust_Points.BackgroundColor=[0.9 0.9 0.9];
end


% --------------------------------------------------------------------
function Save_Project_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, pname]= uiputfile('Project.mat', 'Save file as');

if fname
    global Data_Orig  Data_Trim XCoor YCoor XCoor_clean YCoor_clean X_Trim Y_Trim X_Trim_clean Y_Trim_clean Sec_Size
    
    FileSave.XCoor= XCoor;   % Get the last Updated Coordinates of X
    FileSave.YCoor= YCoor;   % Get the last Updated Coordinates of Y
    FileSave.X_Trim= X_Trim;  % Get The X-Trim Coordinates
    FileSave.Y_Trim= Y_Trim;  % Get The Y-Trim Coordinates
    
    FileSave.XCoor_clean= XCoor_clean;      % Get the last Updated Coordinates of X
    FileSave.YCoor_clean= YCoor_clean;      % Get the last Updated Coordinates of Y
    FileSave.X_Trim_clean= X_Trim_clean;    % Get The X-Trim Coordinates
    FileSave.Y_Trim_clean= Y_Trim_clean;    % Get The Y-Trim Coordinates
    
    FileSave.Data= Data_Orig;      % Get Data_Orig and Save it as Orig_Data Variable
    FileSave.Project= Data_Trim;   % Get Data_Trim and Save it as Project Variable
    FileSave.Sec_Size= Sec_Size;
    savefile= [pname, fname];
    save(savefile, 'FileSave');
end


% --------------------------------------------------------------------
function load_Project_Callback(hObject, eventdata, handles)
% hObject    handle to load_Project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[fname, pname]= uigetfile('*.mat','Load file from');
if length(pname)>1&&length(fname)>1
    loadfile= [pname, fname];
    load(loadfile, 'FileSave')
    global Data_Orig  Data_Trim Basic_info XCoor YCoor XCoor_clean YCoor_clean X_Trim Y_Trim X_Trim_clean Y_Trim_clean Sec_Size Coor Coor_Trim Coor_clean Coor_Trim_clean
    XCoor= FileSave.XCoor;   % Get the last Updated Coordinates of X
    YCoor= FileSave.YCoor;   % Get the last Updated Coordinates of Y
    X_Trim= FileSave.X_Trim;  % Get The X-Trim Coordinates
    Y_Trim= FileSave.Y_Trim;  % Get The Y-Trim Coordinates
    
    XCoor_clean= FileSave.XCoor_clean;      % Get the last Updated Coordinates of X
    YCoor_clean= FileSave.YCoor_clean;      % Get the last Updated Coordinates of Y
    X_Trim_clean= FileSave.X_Trim_clean;    % Get The X-Trim Coordinates
    Y_Trim_clean= FileSave.Y_Trim_clean;    % Get The Y-Trim Coordinates
    
    Data_Orig= FileSave.Data;      % Get Data_Orig and Save it as Orig_Data Variable
    Data_Trim= FileSave.Project;   % Get Data_Trim and Save it as Project Variable
    Basic_info= FileSave.Data.Basic_info_Vis;
    Sec_Size= FileSave.Sec_Size;
    Coor= [XCoor' YCoor'];          % Coor matrix consists of two columna Xcoor and YCoor
    Coor_Trim= [X_Trim Y_Trim];      % Coordinates matrix of Trimmed Section
    Coor_clean= [XCoor_clean' YCoor_clean'];           % Coor matrix consists of two columna Xcoor and YCoor
    Coor_Trim_clean= [X_Trim_clean Y_Trim_clean];      % Coordinates matrix of Trimmed Section
    % Put the Values of Traces and Times on the figure
    handles.Min_Trace_Text.String= num2str(min(FileSave.Project.X_axis));
    handles.Max_Trace_Text.String= num2str(max(FileSave.Project.X_axis));
    handles.Min_Time_Text.String= num2str(min(FileSave.Project.Y_axis));
    handles.Max_Time_Text.String= num2str(max(FileSave.Project.Y_axis));
    
    
    handles.Cut_Section.Value=1; % we put the Value=1 in Order to Avoid Resizing in
    % Seismic_inversion_Plotter Function at Line( % Repositioning The window as it was before applying this function)
    
    % Set Distance_Axis off so that the user can see the whole data
    % including picks because picks cannot be shown when Distance axis is
    % on
    set(handles.Distance_Axis, 'State', 'off');
    
    % Prepare figure objects
    Amp_Val= Data_Orig.Amp_Val;
    handles.Min_amp_Slider.Min= Data_Orig.min_Amp;
    handles.Min_amp_Slider.Max= Data_Orig.max_Amp;
    handles.Min_amp_Slider.Value= -Amp_Val;
    handles.Min_Amplitude_Text.String= num2str(-Amp_Val);
    
    handles.Max_amp_Slider.Min= Data_Orig.min_Amp;
    handles.Max_amp_Slider.Max= Data_Orig.max_Amp;
    handles.Max_amp_Slider.Value= Amp_Val;
    handles.Max_Amplitude_Text.String= num2str(Amp_Val);
    
    % We Have the new Data so we want to draw it
    Seismic_inversion_Plotter(handles)
    
    handles.Cut_Section.Value=0; % Return to 0
end


% --------------------------------------------------------------------
function Inspect_Coordinates_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Inspect_Coordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% setup the Motion Function of the figure
if strcmp(handles.Inspect_Coordinates.State, 'on')
    set(handles.inv_fig , 'WindowButtonMotionFcn', @(hObject,eventdata)Seismic_inversion('inv_fig_WindowButtonMotionFcn',hObject,eventdata,guidata(hObject)));
    handles.Cell_Information.Visible = 'On';    % Show the panel of Headers
else
    set(handles.inv_fig , 'WindowButtonMotionFcn', ' ');
    handles.Cell_Information.Visible = 'Off';   % Hide the panel of Headers
end


% --- Executes on mouse motion over figure - except title and menu.
function inv_fig_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to inv_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inspect_Coordinates(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Distance_Axis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Distance_Axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Start_Picking.Value
    msgbox('Distance Axis cannot be enabled while picking mode is ON','Warning','modal');
    set(handles.Distance_Axis, 'State', 'Off');    
else
    if strcmp(handles.Distance_Axis.State, 'on')
        handles.Trace_Number_Static.String= 'Distance:';
    else
        handles.Trace_Number_Static.String= 'Trace:';
    end
    Seismic_inversion_Plotter(handles)
end

% --- Executes on button press in Check_Entities.
function Check_Entities_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Entities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sec_Size % Load Data
x = who('Sec_Size');   % Check if the data has been loaded
if length(x)
    Check_Entities(handles)
else
    msgbox('There is No Horizons','No data')
end


% --- Executes on button press in Model.
function Model_Callback(hObject, eventdata, handles)
% hObject    handle to Model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sec_Size % Load Data
x= who('Sec_Size');
if length(x)
    Check_Entities(handles)
else
    msgbox('There is no Horizons', 'No data')
end


% --------------------------------------------------------------------
function Export_Section_Callback(hObject, eventdata, handles)
% hObject    handle to Export_Section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save the Current Window of the figure (its Dimensions will be determined to include Figure Margins)

% the Save window and Formats as which the image will be saved
[fname, pname]=uiputfile({'*.bmp','Bitmap file (*.bmp)';...
    '*.jpg','JPEG image (*.jpg)';...
    '*.png','Portable Network Graphics file (*.png)';...
    '*.tif','TIFF image (*.tif)'},'Save file as', 'Section');


if fname
    savefile= [pname, fname];
    ax = handles.axes3;  % Get axis Then determine the positions and expand them as follows
    ax.Units = 'pixels';
    pos = ax.Position;
    marg = 55;
    rect = [-0.99*marg, -1.3*marg, pos(3)+1.9*marg, pos(4)+2.7*marg];
    F = getframe(ax, rect);   % getframe order take PrintScreen of the figure due to Rec dimensions
    imwrite(F.cdata, savefile)   % Save the figure
    ax.Units = 'normalized';
end


% --- Executes on button press in Delete_Neg_Data_Picks.
function Delete_Neg_Data_Picks_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Neg_Data_Picks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global XCoor_clean YCoor_clean Coor_clean Coor_Trim_clean
XCoor_clean= [];          % XCoor is the x coordinates vector, it is set to [] at the beginning of picking
YCoor_clean= [];          % YCoor is the y coordinates vector, it is set to [] at the beginning of picking
Coor_clean=[];            % empty Coor Matrix
Coor_Trim_clean=[];

% get current view
Screen_Xaxis= handles.axes3.XAxis.Limits;
Screen_Yaxis= handles.axes3.YAxis.Limits;

Seismic_inversion_Plotter(handles)

% Put the view
handles.axes3.XAxis.Limits= Screen_Xaxis;
handles.axes3.YAxis.Limits= Screen_Yaxis;

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox({'Make sure the cursor is cross shaped.',...
    'Pick horizons points: left click.',...
    'Delete single horizon point: delete + left click.',...
    'Pick Neglected points: Shift + s.',...
    'Delete single Neglected point: s.',...
    'Neglect the whole column from the current point up: Shift + a.',...
    'Delete Neglected column up: Move cursor + a',...
    'Neglect the whole column from the current point down: Shift + z.',...
    'Delete Neglected column down: Move cursor + z.'}, 'Help');



function Sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to Sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sensitivity as text
%        str2double(get(hObject,'String')) returns contents of Sensitivity as a double


% --- Executes during object creation, after setting all properties.
function Sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
