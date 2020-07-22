function varargout = Seismic_Visualizer(varargin)
% SEISMIC_VISUALIZER MATLAB code for Seismic_Visualizer.fig
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%      SEISMIC_VISUALIZER, by itself, creates a new SEISMIC_VISUALIZER or raises the existing
%      singleton*.
%
%      H = SEISMIC_VISUALIZER returns the handle to a new SEISMIC_VISUALIZER or the handle to
%      the existing singleton*.
%
%      SEISMIC_VISUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEISMIC_VISUALIZER.M with the given input arguments.
%
%      SEISMIC_VISUALIZER('Property','Value',...) creates a new SEISMIC_VISUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Seismic_Visualizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Seismic_Visualizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Seismic_Visualizer

% Last Modified by GUIDE v2.5 25-Nov-2019 00:40:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Seismic_Visualizer_OpeningFcn, ...
    'gui_OutputFcn',  @Seismic_Visualizer_OutputFcn, ...
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


% --- Executes just before Seismic_Visualizer is made visible.
function Seismic_Visualizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Seismic_Visualizer (see VARARGIN)

% Choose default command line output for Seismic_Visualizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Seismic_Visualizer wait for user response (see UIRESUME)
% uiwait(handles.Seismic_Visualizer);


if strcmp(handles.Distance_Axis.State, 'on')
    handles.Trace_Number_Static.String= 'Distance:';
else
    handles.Trace_Number_Static.String= 'Trace:';
end


% --- Outputs from this function are returned to the command line.
function varargout = Seismic_Visualizer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
setappdata(handles.Seismic_Visualizer, 'SaveButton', 0)    % This logical variable for exporting slices to 'Seismic inverion' tool
load('InfoFromSeg.mat', 'InfoFromSeg');  % 'InfoFromSeg' variable shows whether 'Seismic Visualiser' is opened
if ~InfoFromSeg                          %  by the user or by 'SegyHeaders' tool. It's a Logical variable
    about_Callback(hObject, eventdata, handles)   % If 0 then the user has opened the tool. Go to the welcome/help function (about_Callback)
    clear global
else
    Open_Callback(hObject, eventdata, handles)    % If 1 then we've got information (from 'SegyHeaders' tool) to deal with.
end





% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_as_Callback(hObject, eventdata, handles)
% hObject    handle to Save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('InfoFromSeg.mat', 'InfoFromSeg');     % 'InfoFromSeg' variable shows whether 'Seismic Visualiser' is opened 
                                            %  by the user or by 'SegyHeaders' tool. it's a Logical variable
if ~InfoFromSeg                             %  If 0 then do the following
    [fname, pname]= uigetfile({'*.segy';'*.sgy'}, 'Load file from');  % Open a get interface. Allow only segy/sgy file to select.
    if length(pname)>1 && length(fname)>1                             % Make sure the user has selected a file.
        file= [pname, fname];                                         % Create the full name.
        save('filename.mat', 'file');                                 % Save the file name to be used later.
        
        %%% calculate the size of the file and decide whether to warn the
        %%% user
        file_info= dir(file);
        file_size= file_info.bytes/1000000;
        if file_size>500
            file_size= num2str(file_info.bytes/1000000);
            uiwait(helpdlg({['- The size of your file is: ', file_size,' Mb.']...
                ;'- It may take several minutes to load.'}, 'Warning'));
%         else
%             file_size= num2str(file_info.bytes/1000000);
%             uiwait(helpdlg(['The size if your file is: ', file_size,' Mb.'], 'Warning'));
        end
        SegyHeaders                                                   % Open 'SegyHeaders' figure.
    end
else
    InfoFromSeg= 0;                           % InfoFromSeg= 0 so that it's back to it's original value
    save('InfoFromSeg.mat', 'InfoFromSeg');
    load('filename.mat', 'file');             % The segy file full name
    load('SegyInfo.mat', 'SegyInfo');         % 'SegyInfo' variable contains data from 'SegyHeaders' figure,
    
    %% get info from user
    % we use the info to determine the headers and the Seismic volume deminsions.
    Arg1= {'Headers'...
        ,{'iline_no', SegyInfo.Inline_Header_From, SegyInfo.Inline_Header_Cells, 'n/a', 'in-line'}...
        ,{'xline_no', SegyInfo.Xline_Header_From, SegyInfo.Xline_Header_Cells, 'n/a', 'x-line'}...
        ,{'Trace_start_time', SegyInfo.Trace_Start_Time_Header_From, SegyInfo.Trace_Start_Time_Header_Cells, 'n/a', 'Trace_start_time'}...
        ,{'sou_x', SegyInfo.Xcoor_Header_From, SegyInfo.Xcoor_Header_Cells,  'n/a', 'X coordinate of source'}...
        ,{'sou_y', SegyInfo.Ycoor_Header_From, SegyInfo.Ycoor_Header_Cells,  'n/a', 'Y coordinate of source'}};
    Arg2= {'traces', [SegyInfo.Inline_Extent_From , ' <= iline_no ',  '&& ' , SegyInfo.Inline_Extent_To, ' >= iline_no' ,...
        ' && ' , SegyInfo.Xline_Extent_From, ' <= xline_no',  ' && ' , SegyInfo.Xline_Extent_To, ' >= xline_no']};
    Arg3= {'times', [SegyInfo.Time_Range_From, SegyInfo.Time_Range_To]};
    
    
    %% Create Datastore
    % Create Datastore for our Seismic Data, Datastore is the function by
    % which we read Large data from the disc without copying it to the memory
    MyReadFunc= @(file) read_segy_file(file, Arg1, Arg2, Arg3);   % Create handle function with arguments
    SeisDataStore= fileDatastore(file, 'ReadFcn', MyReadFunc);    % Create the datastore file
    
    %%% Show waitbar
    h = waitbar(0,'Please wait...', 'Name', 'Loading');
    steps = 1000;
    for step = 1:steps
        % computations take place here
        waitbar(step / steps)
    end
    %%%
    
    
    global Seis_orig_Data                   % Here is the most important variable 'Seis_orig_Data' which contains the Seismic data.
    global isOnlyInline isOnlyXline         % Values to check whether data is 2D or 3D
    tic
    Seis_orig_Data= read(SeisDataStore);    % Read the Seismic data from the Segy file
    toc
    close(h)
    global Seis_orig_Data_Spare             % Save one copy of the data(not to work on)
    Seis_orig_Data_Spare= Seis_orig_Data;
    cla(handles.axes1);                            % prepare axes 1
    cla(handles.axes2);                            % prepare axes 2
    First_Time_Seismic_Plotter(handles)
    if (isOnlyInline||isOnlyXline)    % if Data is 2D
        close Seismic_Visualizer;
        return;
    end
    c_bar= colorbar(handles.axes1);                % Save the current colorbar
    c_bar.Location= 'southoutside';
    c_bar.Position= [0.7276 0.0727 0.2272 0.0347];
    grid(handles.axes1, 'on');
    handles.Tool_Bar.Visible= 'on';
    handles.Grid_On.Visible= 'on';
    handles.axes1.Visible= 'on';
    handles.axes2.Visible= 'on';
    handles.Survey_Table.Visible= 'on';
    handles.Input_Table.Visible= 'on';
    handles.Co_RangTable.Visible= 'on';
    handles.Edit_Menu.Visible= 'on';
    handles.Get_Section.Visible= 'on';
end

% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct a questdlg with Two options
choice = questdlg('Do you want to close?', ...
    'Close', ...
    'Yes','Cancel','Cancel');
% Handle response
switch choice
    case 'Yes'
        close
end


% --- Executes on button press in Grid_On.
function Grid_On_Callback(hObject, eventdata, handles)
% hObject    handle to Grid_On (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Grid_On
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch handles.Grid_On.Value
    case 1
        grid(handles.axes1, 'on');                            % grid the Axis
    otherwise
        grid(handles.axes1, 'off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function Color_Bar_Menue_OnCallback(hObject, eventdata, handles)
% hObject    handle to Color_Bar_Menue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c_bar= colorbar(handles.axes1);                % Save the current colorbar
c_bar.Location='southoutside';
c_bar.Position=[0.7276    0.0727    0.2272    0.0347];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Color_Bar_Menue_OffCallback(hObject, eventdata, handles)
% hObject    handle to Color_Bar_Menue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorbar(handles.axes1,'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes on button press in Next_Button.
function Next_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Next_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Basic_info_Vis
if ~handles.X_IN_Toggle.Value    % if Toggle button is on Inline direction
    StepLine= Basic_info_Vis.inline_step;
elseif handles.X_IN_Toggle.Value
    StepLine= Basic_info_Vis.xline_step;
end

Steps = str2double(handles.Step_Menu.String);
Step = Steps(handles.Step_Menu.Value);

handles.Text_Line.String= num2str(str2double(handles.Text_Line.String) + (Step*StepLine));
Seismic_Plotter(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in Previuos_Button.
function Previuos_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Previuos_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Basic_info_Vis
if ~handles.X_IN_Toggle.Value    % if Toggle button is on Inline direction
    StepLine= Basic_info_Vis.inline_step;
elseif handles.X_IN_Toggle.Value
    StepLine= Basic_info_Vis.xline_step;
end
Steps = str2double(handles.Step_Menu.String);
Step = Steps(handles.Step_Menu.Value);

handles.Text_Line.String= num2str(str2double(handles.Text_Line.String)-(Step*StepLine));
Seismic_Plotter(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function Text_Line_Callback(hObject, eventdata, handles)
% hObject    handle to Text_Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Text_Line as text
%        str2double(get(hObject,'String')) returns contents of Text_Line as a double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Seismic_Plotter(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function Text_Line_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Text_Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in X_IN_Toggle.
function X_IN_Toggle_Callback(hObject, eventdata, handles)
% hObject    handle to X_IN_Toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of X_IN_Toggle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if handles.X_IN_Toggle.Value
    handles.X_IN_Toggle.String= 'Xline';
elseif ~handles.X_IN_Toggle.Value
    handles.X_IN_Toggle.String= 'Inline';
end
Seismic_Plotter(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in Step_Menu.
function Step_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Step_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Step_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Step_Menu


% --- Executes during object creation, after setting all properties.
function Step_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Step_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
global Basic_info_Vis
if str2double(handles.Min_Amplitude_Text.String)< Basic_info_Vis.min_color_Range
    handles.Min_Amplitude_Text.String = num2str(Basic_info_Vis.min_color_Range);
end
handles.Min_amp_Slider.Value= str2double(handles.Min_Amplitude_Text.String);
Seismic_Plotter(handles)

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



function Max_Amplitude_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Amplitude_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Amplitude_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Amplitude_Text as a double
handles.Max_amp_Slider.Value= str2double(handles.Max_Amplitude_Text.String);
Seismic_Plotter(handles)

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




% --- Executes on slider movement.
function Max_amp_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Max_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Max_Amplitude_Text.String= num2str(handles.Max_amp_Slider.Value);
Seismic_Plotter(handles);

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
global Basic_info_Vis
if handles.Min_amp_Slider.Value==handles.Max_amp_Slider.Max
    handles.Min_amp_Slider.Value= handles.Min_amp_Slider.Value-(Basic_info_Vis.max_color_Range/100);
end
handles.Min_Amplitude_Text.String= num2str(handles.Min_amp_Slider.Value);
Seismic_Plotter(handles);

% --- Executes during object creation, after setting all properties.
function Min_amp_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_amp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light Grey background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Get_Section.
function Get_Section_Callback(hObject, eventdata, handles)
% hObject    handle to Get_Section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.Seismic_Visualizer, 'SaveButton', 1)
Seismic_Plotter(handles)



% --------------------------------------------------------------------
function Colormap_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


d = dialog('Position',[300 300 250 150],'Name','Select One');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String','Select Colormap');

popup = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 100 25],...
    'String',{'Seismic';'Red Blue';'Light(Red Blue)';'Red Black';'Grey'},...
    'UserData',handles,...
    'Callback',{@popup_callback});

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');
popup.Value= getappdata(handles.Seismic_Visualizer, 'popupValue');


% Wait for d to close before running to completion
uiwait(d);

function popup_callback(popup,event)
handles= popup.UserData;
idx = popup.Value;
popup_items = popup.String;
choice = char(popup_items(idx,:));
load('Seis_maps.mat')
switch choice
    case 'Seismic'
        colormap(handles.axes1, Seismic_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 1);
    case 'Red Blue'
        colormap(handles.axes1,Red_blue_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 2);
    case 'Light(Red Blue)'
        colormap(handles.axes1,Red_blue_Light_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 3);
    case 'Red Black'
        colormap(handles.axes1,Red_black_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 4);
    case 'Grey'
        colormap(handles.axes1,Grey);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 5);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% --- Executes on button press in FlipColorbar.
function FlipColorbar_Callback(hObject, eventdata, handles)
% hObject    handle to FlipColorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Seis_maps.mat');
Seismic_map= flipud(Seismic_map);
Red_blue_map= flipud(Red_blue_map);
Red_blue_Light_map= flipud(Red_blue_Light_map);
Red_black_map= flipud(Red_black_map);
Grey= flipud(Grey);
save('Seis_maps.mat','Seismic_map','Red_blue_map','Red_blue_Light_map','Red_black_map','Grey')
col= getappdata(handles.Seismic_Visualizer, 'popupValue');
switch col
    case 1
        colormap(handles.axes1,Seismic_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 1);
    case 2
        colormap(handles.axes1,Red_blue_map)
        setappdata(handles.Seismic_Visualizer, 'popupValue', 2);
    case 3
        colormap(handles.axes1,Red_blue_Light_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 3);
    case 4
        colormap(handles.axes1,Red_black_map);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 4);
    case 5
        colormap(handles.axes1,Grey);
        setappdata(handles.Seismic_Visualizer, 'popupValue', 5);
end
if handles.FlipColorbar.Value
    handles.FlipColorbar.String= 'Flip Colorbar';
else
    handles.FlipColorbar.String= 'Flip Colorbar';
end


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
% about function opens immediately after the user opens 'Seismic
% Visualizer', it shows information about the author.

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


% --------------------------------------------------------------------
function Distance_Axis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Distance_Axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.Distance_Axis.State, 'on')
    handles.Trace_Number_Static.String= 'Distance: ';
else
    handles.Trace_Number_Static.String= 'Trace: ';
end
Seismic_Plotter(handles)


% --------------------------------------------------------------------
function Visualizer_Inspect_Coordinates_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Visualizer_Inspect_Coordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.Visualizer_Inspect_Coordinates.State, 'on')
    set(handles.Seismic_Visualizer , 'WindowButtonMotionFcn', @(hObject,eventdata)Seismic_Visualizer('Seismic_Visualizer_WindowButtonMotionFcn',hObject,eventdata,guidata(hObject)));
    handles.Cell_Information.Visible = 'On';    % Show the panel of Headers
else
    set(handles.Seismic_Visualizer , 'WindowButtonMotionFcn', ' ');
    handles.Cell_Information.Visible = 'Off';   % Hide the panel of Headers
end


% --- Executes on mouse motion over figure - except title and menu.
function Seismic_Visualizer_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Seismic_Visualizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.Visualizer_Inspect_Coordinates.State, 'on')
    Visualizer_Inspect_Coordinates(hObject, eventdata, handles)
end


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Resize_Callback(hObject, eventdata, handles)
% hObject    handle to Resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Trim_Seismic_Volume(handles)


% --------------------------------------------------------------------
function Full_Volume_Callback(hObject, eventdata, handles)
% hObject    handle to Full_Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Seis_orig_Data Seis_orig_Data_Spare
Seis_orig_Data= Seis_orig_Data_Spare;

First_Time_Seismic_Plotter(handles)
