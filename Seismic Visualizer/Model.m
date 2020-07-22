function varargout = Model(varargin)
% MODEL_FIG MATLAB code for Model_fig.fig
%      MODEL_FIG, by itself, creates a new MODEL_FIG or raises the existing
%      singleton*.
%
%      H = MODEL_FIG returns the handle to a new MODEL_FIG or the handle to
%      the existing singleton*.
%
%      MODEL_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_FIG.M with the given input arguments.
%
%      MODEL_FIG('Property','Value',...) creates a new MODEL_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Model_fig

% Last Modified by GUIDE v2.5 30-Apr-2020 12:34:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Model_OpeningFcn, ...
    'gui_OutputFcn',  @Model_OutputFcn, ...
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


% --- Executes just before Model_fig is made visible.
function Model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Model_fig (see VARARGIN)

% Choose default command line output for Model_fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Model_fig wait for user response (see UIRESUME)
% uiwait(handles.Model_fig);
set(handles.Model_fig , 'Pointer', 'arrow');
Ncolumns= 7;
Nrows= 3;
% set(handles.RES_Scenario_Library,'Data',cell(Nrows, Ncolumns));
handles.RES_Scenario_Library.Data(end, :)= [];


% --- Outputs from this function are returned to the command line.
function varargout = Model_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
Model_Plotter_FirstTime(handles)
handles.OB_Porosity_ThreeValues.Value= 1;
handles.RES_Porosity_ThreeValues.Value= 1;
handles.UB_Porosity_ThreeValues.Value= 1;



% --- Executes on button press in Next_Entity_Button.
function Next_Entity_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Next_Entity_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.OB_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.OB_PorRightCoor.Value=0;
handles.OB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.OB_PorLeftCoor.Value=0;
handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.RES_PorRightCoor.Value=0;
handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.RES_PorLeftCoor.Value=0;
handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.UB_PorRightCoor.Value=0;
handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.UB_PorLeftCoor.Value=0;

Model_Plotter(handles)

Entity_Num= handles.Entity_Number_Text.String;
handles.OB_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num]);
handles.OB_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.OB_PorMidValue_FirstCol.String) || ~isempty(handles.OB_PorMidValue_LastCol.String)
    handles.OB_Porosity_ThreeValues.Value= 1;
    OB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end
handles.RES_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num]);
handles.RES_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.RES_PorMidValue_FirstCol.String) || ~isempty(handles.RES_PorMidValue_LastCol.String)
    handles.RES_Porosity_ThreeValues.Value= 1;
    RES_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end

handles.UB_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);
handles.UB_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.UB_PorMidValue_FirstCol.String) || ~isempty(handles.UB_PorMidValue_LastCol.String)
    handles.UB_Porosity_ThreeValues.Value= 1;
    UB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end









% --- Executes on button press in Previous_Entity_Button.
function Previous_Entity_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Previous_Entity_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.OB_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.OB_PorRightCoor.Value=0;
handles.OB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.OB_PorLeftCoor.Value=0;
handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.RES_PorRightCoor.Value=0;
handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.RES_PorLeftCoor.Value=0;
handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
handles.UB_PorRightCoor.Value=0;
handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
handles.UB_PorLeftCoor.Value=0;

Model_Plotter(handles)

Entity_Num= handles.Entity_Number_Text.String;
handles.OB_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num]);
handles.OB_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.OB_PorMidValue_FirstCol.String) || ~isempty(handles.OB_PorMidValue_LastCol.String)
    handles.OB_Porosity_ThreeValues.Value= 1;
    OB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end
handles.RES_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num]);
handles.RES_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.RES_PorMidValue_FirstCol.String) || ~isempty(handles.RES_PorMidValue_LastCol.String)
    handles.RES_Porosity_ThreeValues.Value= 1;
    RES_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end
handles.UB_PorMidValue_FirstCol.String= getappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num]);
handles.UB_PorMidValue_LastCol.String= getappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num]);
if ~isempty(handles.UB_PorMidValue_FirstCol.String) || ~isempty(handles.UB_PorMidValue_LastCol.String)
    handles.UB_Porosity_ThreeValues.Value= 1;
    UB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
end








% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_as_Callback(hObject, eventdata, handles)
% hObject    handle to Save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Save the Current Window of the figure (its Dimensions will be determined to include Figure Margins)

% the Save window and Formats as which the image will be saved
[fname, pname]=uiputfile({'*.bmp','Bitmap file (*.bmp)';...
    '*.jpg','JPEG image (*.jpg)';...
    '*.png','Portable Network Graphics file (*.png)';...
    '*.tif','TIFF image (*.tif)'},'Save file as', ['Entity',handles.Entity_Number_Text.String]);

if fname
    savefile=[pname, fname];
    ax = handles.axes2;  % Get axis Then determine the positions and expand them as follows
    ax.Units = 'pixels';
    pos = ax.Position;
    marg = 60;
    rect = [-0.95*marg, -0.03*marg, pos(3)+1.9*marg, pos(4)+1.18*marg];
    F = getframe(ax, rect);   % getframe order take PrintScreen of the figure due to Rec dimensions
    imwrite(F.cdata, savefile)   % Save the figure
    ax.Units = 'normalized';
end


% --- Executes on button press in Show_Full_Entities.
function Show_Full_Entities_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Full_Entities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Model_Plotter(handles)



% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close



function Min_Matrix_Density_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Matrix_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Matrix_Density_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Matrix_Density_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_Matrix_Density_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Matrix_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_Porosity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Porosity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Porosity_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Porosity_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_Porosity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Porosity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Matrix_Density_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Matrix_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Matrix_Density_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Matrix_Density_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_Matrix_Density_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Matrix_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Porosity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Porosity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Porosity_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Porosity_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_Porosity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Porosity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_maVp_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_maVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_maVp_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_maVp_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_maVp_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_maVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_maVp_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_maVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_maVp_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_maVp_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_maVp_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_maVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_maVs_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_maVs_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_maVs_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_maVs_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_maVs_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_maVs_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_maVs_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_maVs_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_maVs_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_maVs_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_maVs_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_maVs_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_Fluid_Density_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_Fluid_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_Fluid_Density_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_Fluid_Density_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_Fluid_Density_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_Fluid_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Fluid_Density_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Fluid_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Fluid_Density_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_Fluid_Density_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_Fluid_Density_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Fluid_Density_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_fVp_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Min_fVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_fVp_Text as text
%        str2double(get(hObject,'String')) returns contents of Min_fVp_Text as a double


% --- Executes during object creation, after setting all properties.
function Min_fVp_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_fVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_fVp_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Max_fVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_fVp_Text as text
%        str2double(get(hObject,'String')) returns contents of Max_fVp_Text as a double


% --- Executes during object creation, after setting all properties.
function Max_fVp_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_fVp_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Brine_Salinity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Brine_Salinity_Text as text
%        str2double(get(hObject,'String')) returns contents of Brine_Salinity_Text as a double


% --- Executes during object creation, after setting all properties.
function Brine_Salinity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Oil_API_Gravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Oil_API_Gravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Oil_API_Gravity_Text as text
%        str2double(get(hObject,'String')) returns contents of Oil_API_Gravity_Text as a double


% --- Executes during object creation, after setting all properties.
function Oil_API_Gravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oil_API_Gravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gas_API_Gravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Gas_API_Gravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gas_API_Gravity_Text as text
%        str2double(get(hObject,'String')) returns contents of Gas_API_Gravity_Text as a double


% --- Executes during object creation, after setting all properties.
function Gas_API_Gravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gas_API_Gravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Temperature_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Temperature_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Temperature_Text as text
%        str2double(get(hObject,'String')) returns contents of Temperature_Text as a double


% --- Executes during object creation, after setting all properties.
function Temperature_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temperature_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Temperature_Gradient_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Temperature_Gradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Temperature_Gradient_Text as text
%        str2double(get(hObject,'String')) returns contents of Temperature_Gradient_Text as a double


% --- Executes during object creation, after setting all properties.
function Temperature_Gradient_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temperature_Gradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Entity_Type_Menu.
function Entity_Type_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Entity_Type_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Entity_Type_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Entity_Type_Menu


% fix Overburden Buttons' values
handles.OB_Carbonate_OpenFluidsButton.Value=0;
handles.OB_Clastic_OpenFluidsButton.Value=0;
handles.OB_Basalt_OpenFluidsButton.Value=0;
handles.OB_Carbonate_OpenMineralogyButton.Value=0;
handles.OB_Clastic_OpenMineralogyButton.Value=0;
handles.OB_Basalt_OpenMineralogyButton.Value=0;

% fix Overburden Buttons' Colors
handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];

handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];


% fix Reservoir Buttons' values
handles.RES_Scenario_OpenMineralogyButton.Value=0;

handles.RES_Carbonate_OpenFluidsButton.Value=0;
handles.RES_Clastic_OpenFluidsButton.Value=0;
handles.RES_Basalt_OpenFluidsButton.Value=0;

% fix Reservoir Buttons' Colors
handles.RES_Scenario_OpenMineralogyButton.BackgroundColor=[1 1 1];

handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];

% fix Underburden Buttons' values
handles.UB_Carbonate_OpenFluidsButton.Value=0;
handles.UB_Clastic_OpenFluidsButton.Value=0;
handles.UB_Basalt_OpenFluidsButton.Value=0;
handles.UB_Carbonate_OpenMineralogyButton.Value=0;
handles.UB_Clastic_OpenMineralogyButton.Value=0;
handles.UB_Basalt_OpenMineralogyButton.Value=0;

% fix Underburden Buttons' Colors
handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];

handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];

% Hide Fluids Library
handles.Fluids_Library_Panel.Visible='Off';

% Hide Mineralogy Library
handles.Mineralogy_Library_Panel.Visible='Off';

% Hide Scenarios Library
handles.RES_Scenario_Library_Panel.Visible='Off';

Model_Plotter(handles)  % plot the Entity

if handles.Entity_Type_Menu.Value==1
    handles.OB_Menu.Visible='On';
    handles.RES_Menu.Visible='Off';
    handles.UB_Menu.Visible='Off';
    
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorRightCoor.Value=0;
    
    handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorLeftCoor.Value=0;
    
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorRightCoor.Value=0;
    
    handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorLeftCoor.Value=0;
elseif handles.Entity_Type_Menu.Value==2
    handles.RES_Menu.Visible='On';
    handles.OB_Menu.Visible='Off';
    handles.UB_Menu.Visible='Off';
    
elseif handles.Entity_Type_Menu.Value==3
    handles.UB_Menu.Visible='On';
    handles.OB_Menu.Visible='Off';
    handles.RES_Menu.Visible='Off';
    
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorRightCoor.Value=0;
    
    handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorLeftCoor.Value=0;
    
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorRightCoor.Value=0;
    
    handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorLeftCoor.Value=0;
end


% --- Executes during object creation, after setting all properties.
function Entity_Type_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Entity_Type_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CarbonateScenario_Overburden_Shale_Check.
function CarbonateScenario_Overburden_Shale_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Shale_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Shale_Check


% --- Executes on button press in CarbonateScenario_Overburden_Dolomite_Check.
function CarbonateScenario_Overburden_Dolomite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Dolomite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Dolomite_Check


% --- Executes on button press in CarbonateScenario_Overburden_Anhydrite_Check.
function CarbonateScenario_Overburden_Anhydrite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Anhydrite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Anhydrite_Check



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_Porosity_MinValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_Porosity_MinValue_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_Porosity_MinValue_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_Porosity_MinValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_Porosity_MaxValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_Porosity_MaxValue_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_Porosity_MaxValue_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_Porosity_MaxValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CarbonateScenario_Overburden_Brine_Check.
function CarbonateScenario_Overburden_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Brine_Check


% --- Executes on button press in CarbonateScenario_Overburden_Oil_Check.
function CarbonateScenario_Overburden_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Oil_Check


% --- Executes on button press in CarbonateScenario_Overburden_Gas_Check.
function CarbonateScenario_Overburden_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Gas_Check


% --- Executes on button press in CarbonateScenario_Overburden_FreshWater_Check.
function CarbonateScenario_Overburden_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_FreshWater_Check


% --- Executes on button press in CarbonateScenario_Overburden_Air_Check.
function CarbonateScenario_Overburden_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Air_Check


% --- Executes on button press in ClasticScenario_Overburden_Brine_Check.
function ClasticScenario_Overburden_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Brine_Check


% --- Executes on button press in ClasticScenario_Overburden_Oil_Check.
function ClasticScenario_Overburden_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Oil_Check


% --- Executes on button press in ClasticScenario_Overburden_Gas_Check.
function ClasticScenario_Overburden_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Gas_Check


% --- Executes on button press in ClasticScenario_Overburden_FreshWater_Check.
function ClasticScenario_Overburden_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_FreshWater_Check


% --- Executes on button press in ClasticScenario_Overburden_Air_Check.
function ClasticScenario_Overburden_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Air_Check


% --- Executes on button press in BasaltScenario_Overburden_Brine_Check.
function BasaltScenario_Overburden_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Brine_Check


% --- Executes on button press in BasaltScenario_Overburden_Oil_Check.
function BasaltScenario_Overburden_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Oil_Check


% --- Executes on button press in BasaltScenario_Overburden_Gas_Check.
function BasaltScenario_Overburden_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Gas_Check


% --- Executes on button press in BasaltScenario_Overburden_FreshWater_Check.
function BasaltScenario_Overburden_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_FreshWater_Check


% --- Executes on button press in BasaltScenario_Overburden_Air_Check.
function BasaltScenario_Overburden_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Air_Check


% --- Executes on button press in CarbonateScenario_Overburden_Basalt_Check.
function CarbonateScenario_Overburden_Basalt_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Overburden_Basalt_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Overburden_Basalt_Check


% --- Executes on button press in ClasticScenario_Overburden_Shale_Check.
function ClasticScenario_Overburden_Shale_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Shale_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Shale_Check


% --- Executes on button press in ClasticScenario_Overburden_Dolomite_Check.
function ClasticScenario_Overburden_Dolomite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Dolomite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Dolomite_Check


% --- Executes on button press in ClasticScenario_Overburden_Anhydrite_Check.
function ClasticScenario_Overburden_Anhydrite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Anhydrite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Anhydrite_Check


% --- Executes on button press in ClasticScenario_Overburden_Basalt_Check.
function ClasticScenario_Overburden_Basalt_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Overburden_Basalt_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Overburden_Basalt_Check


% --- Executes on button press in BasaltScenario_Overburden_Shale_Check.
function BasaltScenario_Overburden_Shale_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Shale_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Shale_Check


% --- Executes on button press in BasaltScenario_Overburden_Dolomite_Check.
function BasaltScenario_Overburden_Dolomite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Dolomite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Dolomite_Check


% --- Executes on button press in BasaltScenario_Overburden_Anhydrite_Check.
function BasaltScenario_Overburden_Anhydrite_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Anhydrite_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Anhydrite_Check


% --- Executes on button press in BasaltScenario_Overburden_Basalt_Check.
function BasaltScenario_Overburden_Basalt_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Overburden_Basalt_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Overburden_Basalt_Check



function OB_Brine_Salinity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_Brine_Salinity_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_Brine_Salinity_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_Brine_Salinity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_OilAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_OilAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_OilAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_OilAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_GasAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_GasAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_GasAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_GasAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_GOR_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_GOR_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_GOR_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_GOR_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox85.
function checkbox85_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox85


% --- Executes on button press in checkbox86.
function checkbox86_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox86


% --- Executes on button press in checkbox87.
function checkbox87_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox87


% --- Executes on button press in checkbox88.
function checkbox88_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox88


% --- Executes on button press in checkbox89.
function checkbox89_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox89


% --- Executes on button press in checkbox90.
function checkbox90_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox90


% --- Executes on button press in checkbox91.
function checkbox91_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox91


% --- Executes on button press in checkbox92.
function checkbox92_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox92


% --- Executes on button press in checkbox93.
function checkbox93_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox93


% --- Executes on button press in checkbox94.
function checkbox94_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox94


% --- Executes on button press in checkbox95.
function checkbox95_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox95


% --- Executes on button press in checkbox96.
function checkbox96_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox96


% --- Executes on button press in CarbonateScenario_Reservoir_Brine_Check.
function CarbonateScenario_Reservoir_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Reservoir_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Reservoir_Brine_Check


% --- Executes on button press in CarbonateScenario_Reservoir_Oil_Check.
function CarbonateScenario_Reservoir_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Reservoir_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Reservoir_Oil_Check


% --- Executes on button press in CarbonateScenario_Reservoir_Gas_Check.
function CarbonateScenario_Reservoir_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Reservoir_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Reservoir_Gas_Check


% --- Executes on button press in CarbonateScenario_Reservoir_FreshWater_Check.
function CarbonateScenario_Reservoir_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Reservoir_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Reservoir_FreshWater_Check


% --- Executes on button press in CarbonateScenario_Reservoir_Air_Check.
function CarbonateScenario_Reservoir_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to CarbonateScenario_Reservoir_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CarbonateScenario_Reservoir_Air_Check


% --- Executes on button press in ClasticScenario_Reservoir_Brine_Check.
function ClasticScenario_Reservoir_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Reservoir_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Reservoir_Brine_Check


% --- Executes on button press in ClasticScenario_Reservoir_Oil_Check.
function ClasticScenario_Reservoir_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Reservoir_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Reservoir_Oil_Check


% --- Executes on button press in ClasticScenario_Reservoir_Gas_Check.
function ClasticScenario_Reservoir_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Reservoir_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Reservoir_Gas_Check


% --- Executes on button press in ClasticScenario_Reservoir_FreshWater_Check.
function ClasticScenario_Reservoir_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Reservoir_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Reservoir_FreshWater_Check


% --- Executes on button press in ClasticScenario_Reservoir_Air_Check.
function ClasticScenario_Reservoir_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to ClasticScenario_Reservoir_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClasticScenario_Reservoir_Air_Check


% --- Executes on button press in BasaltScenario_Reservoir_Brine_Check.
function BasaltScenario_Reservoir_Brine_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Reservoir_Brine_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Reservoir_Brine_Check


% --- Executes on button press in BasaltScenario_Reservoir_Oil_Check.
function BasaltScenario_Reservoir_Oil_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Reservoir_Oil_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Reservoir_Oil_Check


% --- Executes on button press in BasaltScenario_Reservoir_Gas_Check.
function BasaltScenario_Reservoir_Gas_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Reservoir_Gas_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Reservoir_Gas_Check


% --- Executes on button press in BasaltScenario_Reservoir_FreshWater_Check.
function BasaltScenario_Reservoir_FreshWater_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Reservoir_FreshWater_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Reservoir_FreshWater_Check


% --- Executes on button press in BasaltScenario_Reservoir_Air_Check.
function BasaltScenario_Reservoir_Air_Check_Callback(hObject, eventdata, handles)
% hObject    handle to BasaltScenario_Reservoir_Air_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BasaltScenario_Reservoir_Air_Check



function RES_Brine_Salinity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_Brine_Salinity_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_Brine_Salinity_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_Brine_Salinity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_OilAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_OilAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_OilAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_OilAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_GasAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_GasAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_GasAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_GasAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_GOR_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_GOR_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_GOR_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_GOR_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_Porosity_MinValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_Porosity_MinValue_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_Porosity_MinValue_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_Porosity_MinValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_Porosity_MaxValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_Porosity_MaxValue_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_Porosity_MaxValue_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_Porosity_MaxValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Help_Porosity.
function Help_Porosity_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Porosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = dialog('Position',[500 300 550 300],'Name','Help');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 30 500 300],...
    'String',{'                                                 Porosity function ',''...
    ,'Each enitity has its own porosity function.','',...
    '1- if you choose single value then the same porosity value will be assigned to the entire entity.',...
    '','2- if you choose two values, the first one will be the left boundary of the entity and the second value will be the right boundary.'...
    '','3- if you choose three values, then there is an extra point located in the middle of the entity.'...
    '','4- Max Range determines the maximum extent between Max Por and Min Por in the Entity.'},...
    'ForegroundColor','b',...
    'FontSize',12,...
    'HorizontalAlignment','left');

btn = uicontrol('Parent',d,...
    'Position',[230 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');




% --- Executes on button press in RES_Porosity_SingleValue.
function RES_Porosity_SingleValue_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_SingleValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Porosity_SingleValue
if handles.RES_Porosity_SingleValue.Value
    handles.text101.Visible='Off';
    handles.RES_PorTwoValue_Menu.Visible='Off';
    handles.text102.Visible='Off';
    
    handles.text103.Visible='Off';
    handles.RES_PorThreeValueLeft_Menu.Visible='Off';
    handles.RES_PorThreeValueRight_Menu.Visible='Off';
    handles.text106.Visible='Off';
    handles.RES_PorMidPointTable.Visible='Off';
    handles.text104.Visible='Off';
    handles.text300.Visible='Off';
    handles.ResPor_Max_Range.Visible='Off';
    
    
    handles.RES_PorLeftCoor.Value=0;
    handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorRightCoor.Value=0;
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.RES_PorMidValue_FirstCol.String= '';
    handles.RES_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    
    set(handles.axes2, 'ButtonDownFcn', '');
end

% --- Executes on button press in RES_Porosity_TwoValues.
function RES_Porosity_TwoValues_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_TwoValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Porosity_TwoValues
if handles.RES_Porosity_TwoValues.Value
    handles.text101.Visible='On';
    handles.RES_PorTwoValue_Menu.Visible='On';
    handles.text102.Visible='On';
    
    handles.text103.Visible='Off';
    handles.RES_PorThreeValueLeft_Menu.Visible='Off';
    handles.RES_PorThreeValueRight_Menu.Visible='Off';
    handles.text106.Visible='Off';
    handles.RES_PorMidPointTable.Visible='Off';
    handles.text104.Visible='Off';
    handles.text300.Visible='On';
    handles.ResPor_Max_Range.Visible='On';
    
    handles.RES_PorLeftCoor.Value=0;
    handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorRightCoor.Value=0;
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['RES_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['RES_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.RES_PorMidValue_FirstCol.String= '';
    handles.RES_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    set(handles.axes2, 'ButtonDownFcn', '');
end

% --- Executes on button press in RES_Porosity_ThreeValues.
function RES_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Porosity_ThreeValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Porosity_ThreeValues
if handles.RES_Porosity_ThreeValues.Value
    handles.text101.Visible='Off';
    handles.RES_PorTwoValue_Menu.Visible='Off';
    handles.text102.Visible='Off';
    handles.text300.Visible='On';
    handles.ResPor_Max_Range.Visible='On';
    
    handles.text103.Visible='On';
    handles.RES_PorThreeValueLeft_Menu.Visible='On';
    handles.RES_PorThreeValueRight_Menu.Visible='On';
    handles.text106.Visible='On';
    handles.RES_PorMidPointTable.Visible='On';
    handles.text104.Visible='On';
end



% --- Executes on selection change in RES_PorTwoValue_Menu.
function RES_PorTwoValue_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorTwoValue_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RES_PorTwoValue_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RES_PorTwoValue_Menu


% --- Executes during object creation, after setting all properties.
function RES_PorTwoValue_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_PorTwoValue_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RES_PorThreeValueLeft_Menu.
function RES_PorThreeValueLeft_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorThreeValueLeft_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RES_PorThreeValueLeft_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RES_PorThreeValueLeft_Menu


% --- Executes during object creation, after setting all properties.
function RES_PorThreeValueLeft_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_PorThreeValueLeft_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RES_PorThreeValueRight_Menu.
function RES_PorThreeValueRight_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorThreeValueRight_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RES_PorThreeValueRight_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RES_PorThreeValueRight_Menu


% --- Executes during object creation, after setting all properties.
function RES_PorThreeValueRight_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_PorThreeValueRight_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PorMidValue_FirstCol_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorMidValue_FirstCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_PorMidValue_FirstCol as text
%        str2double(get(hObject,'String')) returns contents of RES_PorMidValue_FirstCol as a double


% --- Executes during object creation, after setting all properties.
function RES_PorMidValue_FirstCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_PorMidValue_FirstCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PorMidValue_LastCol_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorMidValue_LastCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_PorMidValue_LastCol as text
%        str2double(get(hObject,'String')) returns contents of RES_PorMidValue_LastCol as a double


% --- Executes during object creation, after setting all properties.
function RES_PorMidValue_LastCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_PorMidValue_LastCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RES_PorLeftCoor.
function RES_PorLeftCoor_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorLeftCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_PorLeftCoor
if handles.Show_Full_Entities.Value
    handles.RES_PorLeftCoor.Value= 0;
    return;
end

if handles.RES_PorLeftCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.RES_PorLeftCoor.BackgroundColor=[0 1 0];
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorRightCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
elseif handles.RES_PorLeftCoor.Value==0
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.RES_PorLeftCoor.BackgroundColor=[0.9 0.9 0.9];
end


% --- Executes on button press in RES_PorRightCoor.
function RES_PorRightCoor_Callback(hObject, eventdata, handles)
% hObject    handle to RES_PorRightCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_PorRightCoor
if handles.Show_Full_Entities.Value
    handles.RES_PorRightCoor.Value= 0;
    return;
end
if handles.RES_PorRightCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.RES_PorRightCoor.BackgroundColor=[0 1 0];
    handles.RES_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.RES_PorLeftCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
else
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.RES_PorRightCoor.BackgroundColor=[.9 .9 .9];
end


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Entity_Type_Menu.Value==1
    Overburden_Porosity_Function(hObject, eventdata, handles)
elseif handles.Entity_Type_Menu.Value==2
    Reservoir_Porosity_Function(hObject, eventdata, handles)
elseif handles.Entity_Type_Menu.Value==3
    Underburden_Porosity_Function(hObject, eventdata, handles)
end



% --- Executes on button press in OB_Carbonate_OpenMineralogyButton.
function OB_Carbonate_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Carbonate_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.OB_Carbonate_OpenMineralogyButton.Value
    handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.OB_Clastic_OpenMineralogyButton.Value=0;
    handles.OB_Basalt_OpenMineralogyButton.Value=0;
    
    handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in OB_Clastic_OpenMineralogyButton.
function OB_Clastic_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Clastic_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.OB_Clastic_OpenMineralogyButton.Value
    handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.OB_Carbonate_OpenMineralogyButton.Value=0;
    handles.OB_Basalt_OpenMineralogyButton.Value=0;
    
    handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
end

% --- Executes on button press in OB_Basalt_OpenMineralogyButton.
function OB_Basalt_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Basalt_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.OB_Basalt_OpenMineralogyButton.Value
    handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.OB_Carbonate_OpenMineralogyButton.Value=0;
    handles.OB_Clastic_OpenMineralogyButton.Value=0;
    
    handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in MineralogyLibrary_SaveButton.
function MineralogyLibrary_SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to MineralogyLibrary_SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hide Mineralogy Library
handles.Mineralogy_Library_Panel.Visible='Off';
if handles.MainParametersList.Value== 1
    if handles.Entity_Type_Menu.Value== 1
        handles.OB_Mineralogy_List.Visible='Off';
        handles.OB_Carbonate_ShowMineralogyList.Value=0;
        handles.OB_Clastic_ShowMineralogyList.Value=0;
        handles.OB_Basalt_ShowMineralogyList.Value=0;
        
        Picking_Overburden_Lithology(handles)
        
        if strcmp(handles.Mineralogy_Library_Panel.Visible, 'off')
            % Set Buttons' colors to white
            handles.OB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
            handles.OB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
            handles.OB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
            
            % set Buttons' Values to zero
            handles.OB_Carbonate_OpenMineralogyButton.Value=0;
            handles.OB_Clastic_OpenMineralogyButton.Value=0;
            handles.OB_Basalt_OpenMineralogyButton.Value=0;
            
        end
    elseif handles.Entity_Type_Menu.Value== 3
        handles.UB_Mineralogy_List.Visible='Off';
        handles.UB_Carbonate_ShowMineralogyList.Value=0;
        handles.UB_Clastic_ShowMineralogyList.Value=0;
        handles.UB_Basalt_ShowMineralogyList.Value=0;
        
        Picking_Underburden_Lithology(handles)
        
        if strcmp(handles.Mineralogy_Library_Panel.Visible, 'off')
            % Set Buttons' colors to white
            handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
            handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
            handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
            
            % set Buttons' Values to zero
            handles.UB_Carbonate_OpenMineralogyButton.Value=0;
            handles.UB_Clastic_OpenMineralogyButton.Value=0;
            handles.UB_Basalt_OpenMineralogyButton.Value=0;
        end
    end
    
    
elseif handles.MainParametersList.Value== 2
    
    
end



% --- Executes on button press in Add_Mineral_Button.
function Add_Mineral_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Mineral_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add New Mineral To the Library
Mineral= handles.New_Mineral_Text.String;
handles.Mineralogy_Library.RowName(length(handles.Mineralogy_Library.RowName)+1)={Mineral}; % Name of Row(Mineral)
handles.Mineralogy_Library.Data{length(handles.Mineralogy_Library.RowName),1}=false; % Assign Values=0 to the whole new Row

function New_Mineral_Text_Callback(hObject, eventdata, handles)
% hObject    handle to New_Mineral_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Mineral_Text as text
%        str2double(get(hObject,'String')) returns contents of New_Mineral_Text as a double


% --- Executes during object creation, after setting all properties.
function New_Mineral_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Mineral_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save_MineralogyLibrary_Button.
function Save_MineralogyLibrary_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_MineralogyLibrary_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, pname]= uiputfile('Mineralogy Library.mat', 'Save file as');

if fname
    Mineralogy_Library= handles.Mineralogy_Library;
    savefile=[pname, fname];
    save(savefile, 'Mineralogy_Library')
end

% --- Executes on button press in Load_MineralogyLibrary_Button.
function Load_MineralogyLibrary_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_MineralogyLibrary_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname, pname]= uigetfile('*.mat', 'Load file from');
if length(pname)>1&&length(fname)>1
    loadfile= [pname, fname];
    load(loadfile, 'Mineralogy_Library');
    delete(handles.Mineralogy_Library);
    handles.Mineralogy_Library= Mineralogy_Library;
    guidata(handles.Model_fig, handles);
    handles.Mineralogy_Library_Panel.Visible= 'On';
    handles.Mineralogy_Library.Parent= handles.Mineralogy_Library_Panel;
end


% --- Executes on selection change in OB_Mineralogy_List.
function OB_Mineralogy_List_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Mineralogy_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OB_Mineralogy_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OB_Mineralogy_List


% --- Executes during object creation, after setting all properties.
function OB_Mineralogy_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_Mineralogy_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OB_Carbonate_ShowMineralogyList.
function OB_Carbonate_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Carbonate_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Carbonate_ShowMineralogyList
if handles.OB_Carbonate_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['OB_Carbonate_Minerals' 'Entity' Entity_Num]);
    handles.OB_Mineralogy_List.Value=1;
    handles.OB_Mineralogy_List.String=Minerals;
    handles.OB_Mineralogy_List.Visible='On';
    handles.OB_Clastic_ShowMineralogyList.Value=0;
    handles.OB_Basalt_ShowMineralogyList.Value=0;
else
    handles.OB_Mineralogy_List.String='';
    handles.OB_Mineralogy_List.Visible='Off';
end




% --- Executes on button press in OB_Clastic_ShowMineralogyList.
function OB_Clastic_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Clastic_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Clastic_ShowMineralogyList
if handles.OB_Clastic_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['OB_Clastics_Minerals' 'Entity' Entity_Num]);
    handles.OB_Mineralogy_List.Value=1;
    handles.OB_Mineralogy_List.String=Minerals;
    handles.OB_Mineralogy_List.Visible='On';
    handles.OB_Carbonate_ShowMineralogyList.Value=0;
    handles.OB_Basalt_ShowMineralogyList.Value=0;
else
    handles.OB_Mineralogy_List.String='';
    handles.OB_Mineralogy_List.Visible='Off';
end


% --- Executes on button press in OB_Basalt_ShowMineralogyList.
function OB_Basalt_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Basalt_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Basalt_ShowMineralogyList
if handles.OB_Basalt_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['OB_Basalt_Minerals' 'Entity' Entity_Num]);
    handles.OB_Mineralogy_List.Value=1;
    handles.OB_Mineralogy_List.String=Minerals;
    handles.OB_Mineralogy_List.Visible='On';
    handles.OB_Carbonate_ShowMineralogyList.Value=0;
    handles.OB_Clastic_ShowMineralogyList.Value=0;
else
    handles.OB_Mineralogy_List.String='';
    handles.OB_Mineralogy_List.Visible='Off';
end


% --- Executes on button press in OB_Carbonate_OpenFluidsButton.
function OB_Carbonate_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Carbonate_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Carbonate_OpenFluidsButton

if handles.OB_Carbonate_OpenFluidsButton.Value
    handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Overburden Buttons' values
    handles.OB_Clastic_OpenFluidsButton.Value=0;
    handles.OB_Basalt_OpenFluidsButton.Value=0;
    
    % fix Overburden Buttons' Colors
    handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in OB_Clastic_OpenFluidsButton.
function OB_Clastic_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Clastic_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Clastic_OpenFluidsButton
if handles.OB_Clastic_OpenFluidsButton.Value
    handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Overburden Buttons' values
    handles.OB_Carbonate_OpenFluidsButton.Value=0;
    handles.OB_Basalt_OpenFluidsButton.Value=0;
    
    % fix Overburden Buttons' Colors
    handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
end




% --- Executes on button press in OB_Basalt_OpenFluidsButton.
function OB_Basalt_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Basalt_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Basalt_OpenFluidsButton
if handles.OB_Basalt_OpenFluidsButton.Value
    handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Overburden Buttons' values
    handles.OB_Carbonate_OpenFluidsButton.Value=0;
    handles.OB_Clastic_OpenFluidsButton.Value=0;
    
    % fix Overburden Buttons' Colors
    handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in OB_Carbonate_ShowFluidsList.
function OB_Carbonate_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Carbonate_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Carbonate_ShowFluidsList
if handles.OB_Carbonate_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['OB_Carbonate_Fluids' 'Entity' Entity_Num]);
    handles.OB_Fluids_List.Value=1;
    handles.OB_Fluids_List.String= Fluids;
    handles.OB_Fluids_List.Visible='On';
    handles.OB_Clastic_ShowFluidsList.Value=0;
    handles.OB_Basalt_ShowFluidsList.Value=0;
else
    handles.OB_Fluids_List.String='';
    handles.OB_Fluids_List.Visible='Off';
end



% --- Executes on button press in OB_Clastic_ShowFluidsList.
function OB_Clastic_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Clastic_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Clastic_ShowFluidsList
if handles.OB_Clastic_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['OB_Clastics_Fluids' 'Entity' Entity_Num]);
    handles.OB_Fluids_List.Value=1;
    handles.OB_Fluids_List.String= Fluids;
    handles.OB_Fluids_List.Visible='On';
    handles.OB_Carbonate_ShowFluidsList.Value=0;
    handles.OB_Basalt_ShowFluidsList.Value=0;
else
    handles.OB_Fluids_List.String='';
    handles.OB_Fluids_List.Visible='Off';
end




% --- Executes on button press in OB_Basalt_ShowFluidsList.
function OB_Basalt_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Basalt_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Basalt_ShowFluidsList
if handles.OB_Basalt_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['OB_Basalt_Fluids' 'Entity' Entity_Num]);
    handles.OB_Fluids_List.Value=1;
    handles.OB_Fluids_List.String= Fluids;
    handles.OB_Fluids_List.Visible='On';
    handles.OB_Carbonate_ShowFluidsList.Value=0;
    handles.OB_Clastic_ShowFluidsList.Value=0;
else
    handles.OB_Fluids_List.String='';
    handles.OB_Fluids_List.Visible='Off';
end


% --- Executes on selection change in OB_Fluids_List.
function OB_Fluids_List_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OB_Fluids_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OB_Fluids_List


% --- Executes during object creation, after setting all properties.
function OB_Fluids_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_FluidLibrary_Button.
function Load_FluidLibrary_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_FluidLibrary_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname, pname]=uigetfile('*.mat','Load file from');
if length(pname)>1&&length(fname)>1
    loadfile=[pname, fname];
    load(loadfile, 'Fluids_Library');
    delete(handles.Fluids_Library);
    handles.Fluids_Library= Fluids_Library;
    guidata(handles.Model_fig, handles);
    handles.Fluids_Library_Panel.Visible='On';
    handles.Fluids_Library.Parent= handles.Fluids_Library_Panel;
end



% --- Executes on button press in Save_FluidLibrary_Button.
function Save_FluidLibrary_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_FluidLibrary_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, pname]=uiputfile('Fluids Library.mat','Save file as');

if fname
    
    Fluids_Library= handles.Fluids_Library;
    savefile=[pname, fname];
    save(savefile, 'Fluids_Library')
    
end



function New_Fluid_Text_Callback(hObject, eventdata, handles)
% hObject    handle to New_Fluid_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of New_Fluid_Text as text
%        str2double(get(hObject,'String')) returns contents of New_Fluid_Text as a double


% --- Executes during object creation, after setting all properties.
function New_Fluid_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to New_Fluid_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Add_Fluid_Button.
function Add_Fluid_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Fluid_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add New Fluid To the Library
Fluid= handles.New_Fluid_Text.String;
handles.Fluids_Library.RowName(length(handles.Fluids_Library.RowName)+1)={Fluid}; % Name of Row(Fluid)
handles.Fluids_Library.Data{length(handles.Fluids_Library.RowName),1}=false; % Assign Values=0 to the whole new Row


% --- Executes on button press in FluidsLibrary_SaveButton.
function FluidsLibrary_SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to FluidsLibrary_SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hide Fluid Library
handles.Fluids_Library_Panel.Visible='Off';
handles.OB_Fluids_List.Visible='Off';
handles.OB_Carbonate_ShowFluidsList.Value=0;
handles.OB_Clastic_ShowFluidsList.Value=0;
handles.OB_Basalt_ShowFluidsList.Value=0;
handles.UB_Fluids_List.Visible='Off';
handles.UB_Carbonate_ShowFluidsList.Value=0;
handles.UB_Clastic_ShowFluidsList.Value=0;
handles.UB_Basalt_ShowFluidsList.Value=0;
handles.RES_Fluids_List.Visible='Off';
handles.RES_Carbonate_ShowFluidsList.Value=0;
handles.RES_Clastic_ShowFluidsList.Value=0;
handles.RES_Basalt_ShowFluidsList.Value=0;

Picking_Fluids(handles)

if strcmp(handles.Fluids_Library_Panel.Visible, 'off')
    % Set Buttons' colors to white
    handles.OB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.OB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.OB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
    
    % set Buttons' Values to zero
    handles.OB_Carbonate_OpenFluidsButton.Value=0;
    handles.OB_Clastic_OpenFluidsButton.Value=0;
    handles.OB_Basalt_OpenFluidsButton.Value=0;
    handles.RES_Carbonate_OpenFluidsButton.Value=0;
    handles.RES_Clastic_OpenFluidsButton.Value=0;
    handles.RES_Basalt_OpenFluidsButton.Value=0;
    handles.UB_Carbonate_OpenFluidsButton.Value=0;
    handles.UB_Clastic_OpenFluidsButton.Value=0;
    handles.UB_Basalt_OpenFluidsButton.Value=0;
end


% --- Executes on button press in RES_Carbonate_OpenFluidsButton.
function RES_Carbonate_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Carbonate_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Carbonate_OpenFluidsButton

if handles.RES_Carbonate_OpenFluidsButton.Value
    handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    % fix Reservoir Buttons' values
    handles.RES_Clastic_OpenFluidsButton.Value=0;
    handles.RES_Basalt_OpenFluidsButton.Value=0;
    
    % fix Reservoir Buttons' Colors
    handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
end



% --- Executes on button press in RES_Clastic_OpenFluidsButton.
function RES_Clastic_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Clastic_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Clastic_OpenFluidsButton
if handles.RES_Clastic_OpenFluidsButton.Value
    handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Reservoir Buttons' values
    handles.RES_Carbonate_OpenFluidsButton.Value=0;
    handles.RES_Basalt_OpenFluidsButton.Value=0;
    
    % fix Reservoir Buttons' Colors
    handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
end



% --- Executes on button press in RES_Basalt_OpenFluidsButton.
function RES_Basalt_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Basalt_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Basalt_OpenFluidsButton
if handles.RES_Basalt_OpenFluidsButton.Value
    handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Reservoir Buttons' values
    handles.RES_Carbonate_OpenFluidsButton.Value=0;
    handles.RES_Clastic_OpenFluidsButton.Value=0;
    
    % fix Reservoir Buttons' Colors
    handles.RES_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.RES_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.RES_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
end



% --- Executes on button press in RES_Carbonate_ShowFluidsList.
function RES_Carbonate_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Carbonate_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Carbonate_ShowFluidsList
if handles.RES_Carbonate_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['RES_Carbonate_Fluids' 'Entity' Entity_Num]);
    handles.RES_Fluids_List.Value=1;
    handles.RES_Fluids_List.String= Fluids;
    handles.RES_Fluids_List.Visible='On';
    handles.RES_Clastic_ShowFluidsList.Value=0;
    handles.RES_Basalt_ShowFluidsList.Value=0;
else
    handles.RES_Fluids_List.String='';
    handles.RES_Fluids_List.Visible='Off';
end



% --- Executes on button press in RES_Clastic_ShowFluidsList.
function RES_Clastic_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Clastic_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Clastic_ShowFluidsList
if handles.RES_Clastic_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['RES_Clastics_Fluids' 'Entity' Entity_Num]);
    handles.RES_Fluids_List.Value=1;
    handles.RES_Fluids_List.String= Fluids;
    handles.RES_Fluids_List.Visible='On';
    handles.RES_Carbonate_ShowFluidsList.Value=0;
    handles.RES_Basalt_ShowFluidsList.Value=0;
else
    handles.RES_Fluids_List.String='';
    handles.RES_Fluids_List.Visible='Off';
end



% --- Executes on button press in RES_Basalt_ShowFluidsList.
function RES_Basalt_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Basalt_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Basalt_ShowFluidsList
if handles.RES_Basalt_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['RES_Basalt_Fluids' 'Entity' Entity_Num]);
    handles.RES_Fluids_List.Value=1;
    handles.RES_Fluids_List.String= Fluids;
    handles.RES_Fluids_List.Visible='On';
    handles.RES_Carbonate_ShowFluidsList.Value=0;
    handles.RES_Clastic_ShowFluidsList.Value=0;
else
    handles.RES_Fluids_List.String='';
    handles.RES_Fluids_List.Visible='Off';
end



% --- Executes on selection change in RES_Fluids_List.
function RES_Fluids_List_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RES_Fluids_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RES_Fluids_List


% --- Executes during object creation, after setting all properties.
function RES_Fluids_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RES_Scenario_OpenMineralogyButton.
function RES_Scenario_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to RES_Scenario_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RES_Scenario_OpenMineralogyButton
if handles.RES_Scenario_OpenMineralogyButton.Value
    handles.RES_Scenario_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.RES_Scenario_Library_Panel.Visible='On';
else
    handles.RES_Scenario_Library_Panel.Visible='Off';
    handles.RES_Scenario_OpenMineralogyButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in Reservoir_Scenario_SaveButton.
function Reservoir_Scenario_SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to Reservoir_Scenario_SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hide Mineralogy Library

choice = questdlg('Choosing Reservoir Scenarios will reset all Entities Properties!', ...
    'Warning', ...
    'Save','Cancel','Cancel');
% Handle response
switch choice
    case 'Save'
        NumberofEntities= getappdata(handles.Model_fig, 'NumberofEntities'); % get how many entities we have
        MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
        for iter=1:NumberofEntities
            c=['Entity' num2str(iter)];                % Create string variable named c, Contains Entity+its number
            MODEL.(genvarname(c)).Geology='';
            MODEL.(genvarname(c))= rmfield(MODEL.(genvarname(c)), 'Geology');
        end
        setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
        
        handles.RES_Scenario_Library_Panel.Visible='Off';
        
        Picking_Reservoir_Scenario(handles)
        Model_Plotter(handles)
        if strcmp(handles.RES_Scenario_Library_Panel.Visible, 'off')
            % Set Buttons' colors to white
            handles.RES_Scenario_OpenMineralogyButton.BackgroundColor=[1 1 1];
            
            % set Buttons' Values to zero
            handles.RES_Scenario_OpenMineralogyButton.Value=0;
        end
    case 'Cancel'
        handles.RES_Scenario_Library_Panel.Visible='Off';
        % Set Buttons' colors to white
        handles.RES_Scenario_OpenMineralogyButton.BackgroundColor=[1 1 1];
        
        % set Buttons' Values to zero
        handles.RES_Scenario_OpenMineralogyButton.Value=0;
        return;
end




function edit84_Callback(hObject, eventdata, handles)
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit84 as text
%        str2double(get(hObject,'String')) returns contents of edit84 as a double


% --- Executes during object creation, after setting all properties.
function edit84_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit85_Callback(hObject, eventdata, handles)
% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit85 as text
%        str2double(get(hObject,'String')) returns contents of edit85 as a double


% --- Executes during object creation, after setting all properties.
function edit85_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_Brine_Salinity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_Brine_Salinity_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_Brine_Salinity_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_Brine_Salinity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Brine_Salinity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_OilAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_OilAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_OilAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_OilAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_OilAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_GasAPIGravity_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_GasAPIGravity_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_GasAPIGravity_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_GasAPIGravity_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_GasAPIGravity_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_GOR_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_GOR_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_GOR_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_GOR_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_GOR_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UB_Carbonate_OpenFluidsButton.
function UB_Carbonate_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Carbonate_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Carbonate_OpenFluidsButton
if handles.UB_Carbonate_OpenFluidsButton.Value
    handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Underburden Buttons' values
    handles.UB_Clastic_OpenFluidsButton.Value=0;
    handles.UB_Basalt_OpenFluidsButton.Value=0;
    
    % fix Underburden Buttons' Colors
    handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in UB_Clastic_OpenFluidsButton.
function UB_Clastic_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Clastic_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Clastic_OpenFluidsButton
if handles.UB_Clastic_OpenFluidsButton.Value
    handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Underburden Buttons' values
    handles.UB_Carbonate_OpenFluidsButton.Value=0;
    handles.UB_Basalt_OpenFluidsButton.Value=0;
    
    % fix Underburden Buttons' Colors
    handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in UB_Basalt_OpenFluidsButton.
function UB_Basalt_OpenFluidsButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Basalt_OpenFluidsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Basalt_OpenFluidsButton
if handles.UB_Basalt_OpenFluidsButton.Value
    handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[0 1 0];
    handles.Fluids_Library_Panel.Visible='On';
    
    % fix Underburden Buttons' values
    handles.UB_Carbonate_OpenFluidsButton.Value=0;
    handles.UB_Clastic_OpenFluidsButton.Value=0;
    
    % fix Underburden Buttons' Colors
    handles.UB_Clastic_OpenFluidsButton.BackgroundColor=[1 1 1];
    handles.UB_Carbonate_OpenFluidsButton.BackgroundColor=[1 1 1];
else
    handles.Fluids_Library_Panel.Visible='Off';
    handles.UB_Basalt_OpenFluidsButton.BackgroundColor=[1 1 1];
end



% --- Executes on selection change in UB_Fluids_List.
function UB_Fluids_List_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UB_Fluids_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UB_Fluids_List


% --- Executes during object creation, after setting all properties.
function UB_Fluids_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Fluids_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UB_Carbonate_ShowFluidsList.
function UB_Carbonate_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Carbonate_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Carbonate_ShowFluidsList
if handles.UB_Carbonate_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['UB_Carbonate_Fluids' 'Entity' Entity_Num]);
    handles.UB_Fluids_List.Value=1;
    handles.UB_Fluids_List.String= Fluids;
    handles.UB_Fluids_List.Visible='On';
    handles.UB_Clastic_ShowFluidsList.Value=0;
    handles.UB_Basalt_ShowFluidsList.Value=0;
else
    handles.UB_Fluids_List.String='';
    handles.UB_Fluids_List.Visible='Off';
end


% --- Executes on button press in UB_Clastic_ShowFluidsList.
function UB_Clastic_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Clastic_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Clastic_ShowFluidsList
if handles.UB_Clastic_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['UB_Clastics_Fluids' 'Entity' Entity_Num]);
    handles.UB_Fluids_List.Value=1;
    handles.UB_Fluids_List.String= Fluids;
    handles.UB_Fluids_List.Visible='On';
    handles.UB_Carbonate_ShowFluidsList.Value=0;
    handles.UB_Basalt_ShowFluidsList.Value=0;
else
    handles.UB_Fluids_List.String='';
    handles.UB_Fluids_List.Visible='Off';
end



% --- Executes on button press in UB_Basalt_ShowFluidsList.
function UB_Basalt_ShowFluidsList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Basalt_ShowFluidsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Basalt_ShowFluidsList
if handles.UB_Basalt_ShowFluidsList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Fluids= getappdata(handles.Model_fig, ['UB_Basalt_Fluids' 'Entity' Entity_Num]);
    handles.UB_Fluids_List.Value=1;
    handles.UB_Fluids_List.String= Fluids;
    handles.UB_Fluids_List.Visible='On';
    handles.UB_Carbonate_ShowFluidsList.Value=0;
    handles.UB_Clastic_ShowFluidsList.Value=0;
else
    handles.UB_Fluids_List.String='';
    handles.UB_Fluids_List.Visible='Off';
end


% --- Executes on button press in UB_Carbonate_OpenMineralogyButton.
function UB_Carbonate_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Carbonate_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Carbonate_OpenMineralogyButton
if handles.UB_Carbonate_OpenMineralogyButton.Value
    handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.UB_Clastic_OpenMineralogyButton.Value=0;
    handles.UB_Basalt_OpenMineralogyButton.Value=0;
    
    handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
end

% --- Executes on button press in UB_Clastic_OpenMineralogyButton.
function UB_Clastic_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Clastic_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Clastic_OpenMineralogyButton
if handles.UB_Clastic_OpenMineralogyButton.Value
    handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.UB_Carbonate_OpenMineralogyButton.Value=0;
    handles.UB_Basalt_OpenMineralogyButton.Value=0;
    
    handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
end


% --- Executes on button press in UB_Basalt_OpenMineralogyButton.
function UB_Basalt_OpenMineralogyButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Basalt_OpenMineralogyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Basalt_OpenMineralogyButton
if handles.UB_Basalt_OpenMineralogyButton.Value
    handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[0 1 0];
    handles.Mineralogy_Library_Panel.Visible='On';
    handles.UB_Carbonate_OpenMineralogyButton.Value=0;
    handles.UB_Clastic_OpenMineralogyButton.Value=0;
    
    handles.UB_Clastic_OpenMineralogyButton.BackgroundColor=[1 1 1];
    handles.UB_Carbonate_OpenMineralogyButton.BackgroundColor=[1 1 1];
else
    handles.Mineralogy_Library_Panel.Visible='Off';
    handles.UB_Basalt_OpenMineralogyButton.BackgroundColor=[1 1 1];
end



% --- Executes on selection change in UB_Mineralogy_List.
function UB_Mineralogy_List_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Mineralogy_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UB_Mineralogy_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UB_Mineralogy_List


% --- Executes during object creation, after setting all properties.
function UB_Mineralogy_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Mineralogy_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UB_Carbonate_ShowMineralogyList.
function UB_Carbonate_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Carbonate_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Carbonate_ShowMineralogyList
if handles.UB_Carbonate_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['UB_Carbonate_Minerals' 'Entity' Entity_Num]);
    handles.UB_Mineralogy_List.Value=1;
    handles.UB_Mineralogy_List.String=Minerals;
    handles.UB_Mineralogy_List.Visible='On';
    handles.UB_Clastic_ShowMineralogyList.Value=0;
    handles.UB_Basalt_ShowMineralogyList.Value=0;
else
    handles.UB_Mineralogy_List.String='';
    handles.UB_Mineralogy_List.Visible='Off';
end



% --- Executes on button press in UB_Clastic_ShowMineralogyList.
function UB_Clastic_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Clastic_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Clastic_ShowMineralogyList
if handles.UB_Clastic_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['UB_Clastics_Minerals' 'Entity' Entity_Num]);
    handles.UB_Mineralogy_List.Value=1;
    handles.UB_Mineralogy_List.String=Minerals;
    handles.UB_Mineralogy_List.Visible='On';
    handles.UB_Carbonate_ShowMineralogyList.Value=0;
    handles.UB_Basalt_ShowMineralogyList.Value=0;
else
    handles.UB_Mineralogy_List.String='';
    handles.UB_Mineralogy_List.Visible='Off';
end



% --- Executes on button press in UB_Basalt_ShowMineralogyList.
function UB_Basalt_ShowMineralogyList_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Basalt_ShowMineralogyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Basalt_ShowMineralogyList
if handles.UB_Basalt_ShowMineralogyList.Value
    Entity_Num= handles.Entity_Number_Text.String;
    Minerals= getappdata(handles.Model_fig, ['UB_Basalt_Minerals' 'Entity' Entity_Num]);
    handles.UB_Mineralogy_List.Value=1;
    handles.UB_Mineralogy_List.String=Minerals;
    handles.UB_Mineralogy_List.Visible='On';
    handles.UB_Carbonate_ShowMineralogyList.Value=0;
    handles.UB_Clastic_ShowMineralogyList.Value=0;
else
    handles.UB_Mineralogy_List.String='';
    handles.UB_Mineralogy_List.Visible='Off';
end



function edit90_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_Porosity_MinValue_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_Porosity_MinValue_Text as a double


% --- Executes during object creation, after setting all properties.
function edit90_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Help_Porosity.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Porosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit92_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_Porosity_MaxValue_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_Porosity_MaxValue_Text as a double


% --- Executes during object creation, after setting all properties.
function edit92_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UB_PorLeftCoor.
function UB_PorLeftCoor_Callback(hObject, eventdata, handles)
% hObject    handle to UB_PorLeftCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_PorLeftCoor
if handles.Show_Full_Entities.Value
    handles.UB_PorLeftCoor.Value= 0;
    return;
end
if handles.UB_PorLeftCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.UB_PorLeftCoor.BackgroundColor=[0 1 0];
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorRightCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
elseif handles.UB_PorLeftCoor.Value==0
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.UB_PorLeftCoor.BackgroundColor=[0.9 0.9 0.9];
end



% --- Executes on button press in UB_PorRightCoor.
function UB_PorRightCoor_Callback(hObject, eventdata, handles)
% hObject    handle to UB_PorRightCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_PorRightCoor
if handles.Show_Full_Entities.Value
    handles.UB_PorRightCoor.Value= 0;
    return;
end
if handles.UB_PorRightCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.UB_PorRightCoor.BackgroundColor=[0 1 0];
    handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorLeftCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
else
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
end



% --- Executes on selection change in UB_PorThreeValueRight_Menu.
function UB_PorThreeValueRight_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to UB_PorThreeValueRight_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UB_PorThreeValueRight_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UB_PorThreeValueRight_Menu


% --- Executes during object creation, after setting all properties.
function UB_PorThreeValueRight_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_PorThreeValueRight_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in UB_PorTwoValue_Menu.
function UB_PorTwoValue_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to UB_PorTwoValue_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UB_PorTwoValue_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UB_PorTwoValue_Menu


% --- Executes during object creation, after setting all properties.
function UB_PorTwoValue_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_PorTwoValue_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in UB_PorThreeValueLeft_Menu.
function UB_PorThreeValueLeft_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to UB_PorThreeValueLeft_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UB_PorThreeValueLeft_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UB_PorThreeValueLeft_Menu


% --- Executes during object creation, after setting all properties.
function UB_PorThreeValueLeft_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_PorThreeValueLeft_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_Porosity_MinValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_Porosity_MinValue_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_Porosity_MinValue_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_Porosity_MinValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_MinValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_Porosity_MaxValue_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_Porosity_MaxValue_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_Porosity_MaxValue_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_Porosity_MaxValue_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_MaxValue_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UB_Porosity_SingleValue.
function UB_Porosity_SingleValue_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_SingleValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Porosity_SingleValue
if handles.UB_Porosity_SingleValue.Value
    handles.text219.Visible='Off';
    handles.UB_PorTwoValue_Menu.Visible='Off';
    handles.text222.Visible='Off';
    
    handles.text223.Visible='Off';
    handles.UB_PorThreeValueLeft_Menu.Visible='Off';
    handles.UB_PorThreeValueRight_Menu.Visible='Off';
    handles.text221.Visible='Off';
    handles.UB_PorMidPointTable.Visible='Off';
    handles.text220.Visible='Off';
    handles.text301.Visible='Off';
    handles.UBPor_Max_Range.Visible='Off';    
    
    handles.UB_PorLeftCoor.Value=0;
    handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorRightCoor.Value=0;
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.UB_PorMidValue_FirstCol.String= '';
    handles.UB_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    
    set(handles.axes2, 'ButtonDownFcn', '');
end



% --- Executes on button press in UB_Porosity_TwoValues.
function UB_Porosity_TwoValues_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_TwoValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Porosity_TwoValues
if handles.UB_Porosity_TwoValues.Value
    handles.text219.Visible='On';
    handles.UB_PorTwoValue_Menu.Visible='On';
    handles.text222.Visible='On';
    
    handles.text223.Visible='Off';
    handles.UB_PorThreeValueLeft_Menu.Visible='Off';
    handles.UB_PorThreeValueRight_Menu.Visible='Off';
    handles.text220.Visible='Off';
    handles.UB_PorMidPointTable.Visible='Off';
    handles.text221.Visible='Off';

    handles.text301.Visible='On';
    handles.UBPor_Max_Range.Visible='On';   
    
    handles.UB_PorLeftCoor.Value=0;
    handles.UB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.UB_PorRightCoor.Value=0;
    handles.UB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['UB_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['UB_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.UB_PorMidValue_FirstCol.String= '';
    handles.UB_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    set(handles.axes2, 'ButtonDownFcn', '');
end


% --- Executes on button press in UB_Porosity_ThreeValues.
function UB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
% hObject    handle to UB_Porosity_ThreeValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UB_Porosity_ThreeValues
if handles.UB_Porosity_ThreeValues.Value
    handles.text219.Visible='Off';
    handles.UB_PorTwoValue_Menu.Visible='Off';
    handles.text222.Visible='Off';

    handles.text301.Visible='On';
    handles.UBPor_Max_Range.Visible='On';  
    
    handles.text223.Visible='On';
    handles.UB_PorThreeValueLeft_Menu.Visible='On';
    handles.UB_PorThreeValueRight_Menu.Visible='On';
    handles.text220.Visible='On';
    handles.UB_PorMidPointTable.Visible='On';
    handles.text221.Visible='On';
end




% --- Executes on button press in RES_FinalSaveButton.
function RES_FinalSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RES_FinalSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
Chosen_Scenarios= getappdata(handles.Model_fig, 'RES_Scenario');
%% Check Scenarios
if isempty(Chosen_Scenarios)...
        msgbox('Choose at least one Scenario!', 'Error', 'Error');
    return;
end

%% Check Fluids
Check_Fluids='';
% Make a cell matrix contains the chosen Fluids for scenarios
if ~isempty(getappdata(handles.Model_fig, ['RES_Carbonate_Fluids' 'Entity' Entity_Num]))
    Check_Fluids= {'Carbonate'};
end
if ~isempty(getappdata(handles.Model_fig, ['RES_Clastics_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids={'Clastics'};
    else
        Check_Fluids=[Check_Fluids;'Clastics'];
    end
end
if ~isempty(getappdata(handles.Model_fig, ['RES_Basalt_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids= {'Basalt'};
    else
        Check_Fluids=[Check_Fluids;'Basalt'];
    end
end

if isempty(Check_Fluids)
    msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
    return;
end

% Delete the empty Rows of Check_Fluids cell matrix
Check_Fluids(strcmp(Check_Fluids,''))=[];

% Compare the chosen minerals with chosen Fluids for scenarios
if size(Chosen_Scenarios, 1) > size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids for ALL of the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1) < size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids ONLY for the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1)==size(Check_Fluids, 1)
    if prod(strcmp(Chosen_Scenarios, Check_Fluids))==0
        msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
        return;
    end
    
end


%% Check Fluids Properties
RES_Brine_Salinity= str2double(handles.RES_Brine_Salinity_Text.String);
RES_OilAPIGravity= str2double(handles.RES_OilAPIGravity_Text.String);
RES_GasAPIGravity= str2double(handles.RES_GasAPIGravity_Text.String);
RES_GOR= str2double(handles.RES_GOR_Text.String);
MinSW= str2double(handles.RES_MinSW_Text.String);
MaxSW= str2double(handles.RES_MaxSW_Text.String);
if isempty(RES_Brine_Salinity)||isnan(RES_Brine_Salinity)...
        ||isempty(RES_OilAPIGravity)||isnan(RES_OilAPIGravity)...
        ||isempty(RES_GasAPIGravity)||isnan(RES_GasAPIGravity)...
        ||isempty(RES_GOR)||isnan(RES_GOR)...
        ||isempty(MinSW)||isnan(MaxSW)
    msgbox('Make sure to type Fluids Properties correctly!', 'Error', 'Error');
    return;
end


if MaxSW>100
    msgbox('Saturation cannot be larger than 100%', 'Error', 'Error');
    return;
end
if MinSW<0
    msgbox('Saturation cannot be smaller than 0%', 'Error', 'Error');
    return;
end
if MaxSW<MinSW
    msgbox('Max Saturation should be larger than Min Saturation!', 'Error', 'Error');
    return;
end
%% Check Porosity
Min_Porosity= str2double(handles.RES_Porosity_MinValue_Text.String);
Max_Porosity= str2double(handles.RES_Porosity_MaxValue_Text.String);
Max_Range= str2double(handles.ResPor_Max_Range.String);

if isempty(Min_Porosity)||isnan(Min_Porosity)...
        ||isempty(Max_Porosity)||isnan(Max_Porosity)...
        msgbox('Make sure to type Porosity Min/Max Values correctly!', 'Error', 'Error');
    return;
end

if Max_Porosity>100
    msgbox('Porosity cannot be larger than 100%', 'Error', 'Error');
    return;
end
if Min_Porosity<0
    msgbox('Porosity cannot be smaller than 0%', 'Error', 'Error');
    return;
end
if Max_Porosity<Min_Porosity
    msgbox('Max porosity should be larger than Min porosity!', 'Error', 'Error');
    return;
end

if isnan(Max_Range) || Max_Range>100 || Max_Range<0
    msgbox('Max Range value is incorrect!', 'Error', 'Error');
    return;
end

RES_Left_MidZone= getappdata(handles.Model_fig, ['RES_Left_MidZone' 'Entity' Entity_Num]);
RES_Right_MidZone= getappdata(handles.Model_fig, ['RES_Right_MidZone' 'Entity' Entity_Num]);
if handles.RES_Porosity_ThreeValues.Value
    if isempty(RES_Right_MidZone) || isempty(RES_Left_MidZone)
        msgbox('Choose Left Coor and Right Coor for Middle Zone!', 'Error', 'Error');
        return;
    end
end

% if everything is fine then execute the Reservoir save function
c=['Entity' Entity_Num];                % Creat string variable named c, Contains Entity+its number
MODEL.(genvarname(c)).Geology='';
MODEL.(genvarname(c))= rmfield(MODEL.(genvarname(c)), 'Geology');
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Get The MODEL
RES_Geology_Save(hObject, eventdata, handles)



% --- Executes on button press in UB_FinalSaveButton.
function UB_FinalSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to UB_FinalSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
Chosen_Scenarios= getappdata(handles.Model_fig, 'RES_Scenario');

%% Check Scenrios
if isempty(Chosen_Scenarios)
    msgbox('Choose Reservoir Scenarios First', 'Error', 'Error');
    return;
end

%% Check Minerals
Check_Minerals='';
% Make a cell matrix contains the chosen Minerals for scenarios
if ~isempty(getappdata(handles.Model_fig, ['UB_Carbonate_Minerals' 'Entity' Entity_Num]))
    Check_Minerals= {'Carbonate'};
end
if ~isempty(getappdata(handles.Model_fig, ['UB_Clastics_Minerals' 'Entity' Entity_Num]))
    if isempty(Check_Minerals)
        Check_Minerals={'Clastics'};
    else
        Check_Minerals=[Check_Minerals;'Clastics'];
    end
end
if ~isempty(getappdata(handles.Model_fig, ['UB_Basalt_Minerals' 'Entity' Entity_Num]))
    if isempty(Check_Minerals)
        Check_Minerals= {'Basalt'};
    else
        Check_Minerals=[Check_Minerals;'Basalt'];
    end
end

if isempty(Check_Minerals)
    msgbox('Choose Probable Minerals for the chosen scenarios above!', 'Error', 'Error');
    return;
end

% Delete the empty Rows of Check_Minerals cell matrix
Check_Minerals(strcmp(Check_Minerals,''))=[];

% Compare the chosen scenarios with chosen Minerals for scenarios
if size(Chosen_Scenarios, 1) > size(Check_Minerals, 1)
    msgbox('Choose Probable Minerals for ALL of the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1) < size(Check_Minerals, 1)
    msgbox('Choose Probable Minerals ONLY for the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1)==size(Check_Minerals, 1)
    if prod(strcmp(Chosen_Scenarios, Check_Minerals))==0
        msgbox('Choose Probable Minerals for the chosen scenarios above!', 'Error', 'Error');
        return;
    end
    
end


%% Check Fluids
Check_Fluids='';
% Make a cell matrix contains the chosen Fluids for scenarios
if ~isempty(getappdata(handles.Model_fig, ['UB_Carbonate_Fluids' 'Entity' Entity_Num]))
    Check_Fluids= {'Carbonate'};
end
if ~isempty(getappdata(handles.Model_fig, ['UB_Clastics_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids={'Clastics'};
    else
        Check_Fluids=[Check_Fluids;'Clastics'];
    end
end
if ~isempty(getappdata(handles.Model_fig, ['UB_Basalt_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids= {'Basalt'};
    else
        Check_Fluids=[Check_Fluids;'Basalt'];
    end
end

if isempty(Check_Fluids)
    msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
    return;
end

% Delete the empty Rows of Check_Fluids cell matrix
Check_Fluids(strcmp(Check_Fluids,''))=[];

% Compare the chosen minerals with chosen Fluids for scenarios
if size(Chosen_Scenarios, 1) > size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids for ALL of the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1) < size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids ONLY for the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1)==size(Check_Fluids, 1)
    if prod(strcmp(Chosen_Scenarios, Check_Fluids))==0
        msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
        return;
    end
    
end


%% Check Fluids Properties
UB_Brine_Salinity= str2double(handles.UB_Brine_Salinity_Text.String);
UB_OilAPIGravity= str2double(handles.UB_OilAPIGravity_Text.String);
UB_GasAPIGravity= str2double(handles.UB_GasAPIGravity_Text.String);
UB_GOR= str2double(handles.UB_GOR_Text.String);
MinSW= str2double(handles.UB_MinSW_Text.String);
MaxSW= str2double(handles.UB_MaxSW_Text.String);
if isempty(UB_Brine_Salinity)||isnan(UB_Brine_Salinity)...
        ||isempty(UB_OilAPIGravity)||isnan(UB_OilAPIGravity)...
        ||isempty(UB_GasAPIGravity)||isnan(UB_GasAPIGravity)...
        ||isempty(UB_GOR)||isnan(UB_GOR)...
        ||isempty(MinSW)||isnan(MaxSW)
    msgbox('Make sure to type Fluids Properties correctly!', 'Error', 'Error');
    return;
end


if MaxSW>100
    msgbox('Saturation cannot be larger than 100%', 'Error', 'Error');
    return;
end
if MinSW<0
    msgbox('Saturation cannot be smaller than 0%', 'Error', 'Error');
    return;
end

if MaxSW<MinSW
    msgbox('Max Saturation should be larger than Min Saturation!', 'Error', 'Error');
    return;
end
%% Check Porosity
Min_Porosity= str2double(handles.UB_Porosity_MinValue_Text.String);
Max_Porosity= str2double(handles.UB_Porosity_MaxValue_Text.String);
Max_Range= str2double(handles.UBPor_Max_Range.String);

if isempty(Min_Porosity)||isnan(Min_Porosity)...
        ||isempty(Max_Porosity)||isnan(Max_Porosity)...
        msgbox('Make sure to type Porosity Min/Max Values correctly!', 'Error', 'Error');
    return;
end

if Max_Porosity>100
    msgbox('Porosity cannot be larger than 100%', 'Error', 'Error');
    return;
end
if Min_Porosity<0
    msgbox('Porosity cannot be smaller than 0%', 'Error', 'Error');
    return;
end
if Max_Porosity<Min_Porosity
    msgbox('Max porosity should be larger than Min porosity!', 'Error', 'Error');
    return;
end

if isnan(Max_Range) || Max_Range>100 || Max_Range<0
    msgbox('Max Range value is incorrect!', 'Error', 'Error');
    return;
end

UB_Left_MidZone= getappdata(handles.Model_fig, ['UB_Left_MidZone' 'Entity' Entity_Num]);
UB_Right_MidZone= getappdata(handles.Model_fig, ['UB_Right_MidZone' 'Entity' Entity_Num]);
if handles.UB_Porosity_ThreeValues.Value
    if isempty(UB_Left_MidZone) || isempty(UB_Right_MidZone)
        msgbox('Choose Left Coor and Right Coor for Middle Zone!', 'Error', 'Error');
        return;
    end
end


% if everything is fine then execute the Overburden save function
c=['Entity' Entity_Num];                % Creat string variable named c, Contains Entity+its number
MODEL.(genvarname(c)).Geology='';
MODEL.(genvarname(c))= rmfield(MODEL.(genvarname(c)), 'Geology');
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
UB_Geology_Save(hObject, eventdata, handles)




% --- Executes on button press in OB_FinalSaveButton.
function OB_FinalSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to OB_FinalSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MODEL= getappdata(handles.Model_fig, 'MODEL');  % Get The MODEL
Entity_Num= handles.Entity_Number_Text.String;  % Get The Number of the current Entity
Chosen_Scenarios= getappdata(handles.Model_fig, 'RES_Scenario');

%% Check Scenrios
if isempty(Chosen_Scenarios)
    msgbox('Choose Reservoir Scenarios First', 'Error', 'Error');
    return;
end

%% Check Minerals
Check_Minerals='';
% Make a cell matrix contains the chosen Minerals for scenarios

if ~isempty(getappdata(handles.Model_fig, ['OB_Carbonate_Minerals' 'Entity' Entity_Num]))
    Check_Minerals= {'Carbonate'};
end
if ~isempty(getappdata(handles.Model_fig, ['OB_Clastics_Minerals' 'Entity' Entity_Num]))
    if isempty(Check_Minerals)
        Check_Minerals={'Clastics'};
    else
        Check_Minerals=[Check_Minerals;'Clastics'];
    end
end
if ~isempty(getappdata(handles.Model_fig, ['OB_Basalt_Minerals' 'Entity' Entity_Num]))
    if isempty(Check_Minerals)
        Check_Minerals= {'Basalt'};
    else
        Check_Minerals=[Check_Minerals;'Basalt'];
    end
end

if isempty(Check_Minerals)
    msgbox('Choose Probable Minerals for the chosen scenarios above!', 'Error', 'Error');
    return;
end

% Delete the empty Rows of Check_Minerals cell matrix
Check_Minerals(strcmp(Check_Minerals,''))=[];

% Compare the chosen scenarios with chosen Minerals for scenarios
if size(Chosen_Scenarios, 1) > size(Check_Minerals, 1)
    msgbox('Choose Probable Minerals for ALL of the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1) < size(Check_Minerals, 1)
    msgbox('Choose Probable Minerals ONLY for the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1)==size(Check_Minerals, 1)
    if prod(strcmp(Chosen_Scenarios, Check_Minerals))==0
        msgbox('Choose Probable Minerals for the chosen scenarios above!', 'Error', 'Error');
        return;
    end
    
end


%% Check Fluids
Check_Fluids='';
% Make a cell matrix contains the chosen Fluids for scenarios
if ~isempty(getappdata(handles.Model_fig, ['OB_Carbonate_Fluids' 'Entity' Entity_Num]))
    Check_Fluids= {'Carbonate'};
end
if ~isempty(getappdata(handles.Model_fig, ['OB_Clastics_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids={'Clastics'};
    else
        Check_Fluids=[Check_Fluids;'Clastics'];
    end
end
if ~isempty(getappdata(handles.Model_fig, ['OB_Basalt_Fluids' 'Entity' Entity_Num]))
    if isempty(Check_Fluids)
        Check_Fluids= {'Basalt'};
    else
        Check_Fluids=[Check_Fluids;'Basalt'];
    end
end

if isempty(Check_Fluids)
    msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
    return;
end

% Delete the empty Rows of Check_Fluids cell matrix
Check_Fluids(strcmp(Check_Fluids,''))=[];

% Compare the chosen minerals with chosen Fluids for scenarios
if size(Chosen_Scenarios, 1) > size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids for ALL of the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1) < size(Check_Fluids, 1)
    msgbox('Choose Probable Fluids ONLY for the chosen scenarios above!', 'Error', 'Error');
    return;
elseif size(Chosen_Scenarios, 1)==size(Check_Fluids, 1)
    if prod(strcmp(Chosen_Scenarios, Check_Fluids))==0
        msgbox('Choose Probable Fluids for the chosen scenarios above!', 'Error', 'Error');
        return;
    end
end


%% Check Fluids Properties
OB_Brine_Salinity= str2double(handles.OB_Brine_Salinity_Text.String);
OB_OilAPIGravity= str2double(handles.OB_OilAPIGravity_Text.String);
OB_GasAPIGravity= str2double(handles.OB_GasAPIGravity_Text.String);
OB_GOR= str2double(handles.OB_GOR_Text.String);
MinSW= str2double(handles.OB_MinSW_Text.String);
MaxSW= str2double(handles.OB_MaxSW_Text.String);
if isempty(OB_Brine_Salinity)||isnan(OB_Brine_Salinity)...
        ||isempty(OB_OilAPIGravity)||isnan(OB_OilAPIGravity)...
        ||isempty(OB_GasAPIGravity)||isnan(OB_GasAPIGravity)...
        ||isempty(OB_GOR)||isnan(OB_GOR)...
        ||isempty(MinSW)||isnan(MaxSW)
    msgbox('Make sure to type Fluids Properties correctly!', 'Error', 'Error');
    return;
end


if MaxSW>100
    msgbox('Saturation cannot be larger than 100%', 'Error', 'Error');
    return;
end
if MinSW<0
    msgbox('Saturation cannot be smaller than 0%', 'Error', 'Error');
    return;
end

if MaxSW<MinSW
    msgbox('Max Saturation should be larger than Min Saturation!', 'Error', 'Error');
    return;
end

%% Check Porosity
Min_Porosity= str2double(handles.OB_Porosity_MinValue_Text.String);
Max_Porosity= str2double(handles.OB_Porosity_MaxValue_Text.String);
Max_Range= str2double(handles.OBPor_Max_Range.String);

if isempty(Min_Porosity)||isnan(Min_Porosity)...
        ||isempty(Max_Porosity)||isnan(Max_Porosity)...
        msgbox('Make sure to type Porosity Min/Max Values correctly!', 'Error', 'Error');
    return;
end

if Max_Porosity>100
    msgbox('Porosity cannot be larger than 100%', 'Error', 'Error');
    return;
end
if Min_Porosity<0
    msgbox('Porosity cannot be smaller than 0%', 'Error', 'Error');
    return;
end
if Max_Porosity<Min_Porosity
    msgbox('Max porosity should be larger than Min porosity!', 'Error', 'Error');
    return;
end

if isnan(Max_Range) || Max_Range>100 || Max_Range<0
    msgbox('Max Range value is incorrect!', 'Error', 'Error');
    return;
end

OB_Left_MidZone= getappdata(handles.Model_fig, ['OB_Left_MidZone' 'Entity' Entity_Num]);
OB_Right_MidZone= getappdata(handles.Model_fig, ['OB_Right_MidZone' 'Entity' Entity_Num]);
if handles.OB_Porosity_ThreeValues.Value
    if isempty(OB_Left_MidZone) || isempty(OB_Right_MidZone)
        msgbox('Choose Left Coor and Right Coor for Middle Zone!', 'Error', 'Error');
        return;
    end
end


% if everything is fine then execute the Overburden save function
c=['Entity' Entity_Num];                % Creat string variable named c, Contains Entity+its number
MODEL.(genvarname(c)).Geology='';
MODEL.(genvarname(c))= rmfield(MODEL.(genvarname(c)), 'Geology');
setappdata(handles.Model_fig, 'MODEL', MODEL);  % Save The MODEL
OB_Geology_Save(hObject, eventdata, handles)


% --- Executes on selection change in MainParametersList.
function MainParametersList_Callback(hObject, eventdata, handles)
% hObject    handle to MainParametersList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MainParametersList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MainParametersList
if handles.MainParametersList.Value==1
    handles.Gologic_Parameters_Table.Visible='On';
    handles.Environmental_Parameters_Table.Visible='Off';
    handles.Seismic_Parameters_Table.Visible='Off';
elseif handles.MainParametersList.Value==2
    handles.Gologic_Parameters_Table.Visible='Off';
    handles.Environmental_Parameters_Table.Visible='On';
    handles.Seismic_Parameters_Table.Visible='Off';
elseif handles.MainParametersList.Value==3
    handles.Gologic_Parameters_Table.Visible='Off';
    handles.Environmental_Parameters_Table.Visible='Off';
    handles.Seismic_Parameters_Table.Visible='On';
end









% --- Executes during object creation, after setting all properties.
function MainParametersList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainParametersList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MainOverburden_pVelocity_Callback(hObject, eventdata, handles)
% hObject    handle to MainOverburden_pVelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MainOverburden_pVelocity as text
%        str2double(get(hObject,'String')) returns contents of MainOverburden_pVelocity as a double


% --- Executes during object creation, after setting all properties.
function MainOverburden_pVelocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainOverburden_pVelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SurfaceTemperature_Text_Callback(hObject, eventdata, handles)
% hObject    handle to SurfaceTemperature_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SurfaceTemperature_Text as text
%        str2double(get(hObject,'String')) returns contents of SurfaceTemperature_Text as a double


% --- Executes during object creation, after setting all properties.
function SurfaceTemperature_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SurfaceTemperature_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TemperatureGradient_Text_Callback(hObject, eventdata, handles)
% hObject    handle to TemperatureGradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TemperatureGradient_Text as text
%        str2double(get(hObject,'String')) returns contents of TemperatureGradient_Text as a double


% --- Executes during object creation, after setting all properties.
function TemperatureGradient_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TemperatureGradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SurfacePressure_Text_Callback(hObject, eventdata, handles)
% hObject    handle to SurfacePressure_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SurfacePressure_Text as text
%        str2double(get(hObject,'String')) returns contents of SurfacePressure_Text as a double


% --- Executes during object creation, after setting all properties.
function SurfacePressure_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SurfacePressure_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PressureGradient_Text_Callback(hObject, eventdata, handles)
% hObject    handle to PressureGradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PressureGradient_Text as text
%        str2double(get(hObject,'String')) returns contents of PressureGradient_Text as a double


% --- Executes during object creation, after setting all properties.
function PressureGradient_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PressureGradient_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EnvironmentalPropertiesSaveButton.
function EnvironmentalPropertiesSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to EnvironmentalPropertiesSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

EnvironmentalProperties_Save(hObject, eventdata, handles)



function Sampling_Interval_Callback(hObject, eventdata, handles)
% hObject    handle to Sampling_Interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sampling_Interval as text
%        str2double(get(hObject,'String')) returns contents of Sampling_Interval as a double


% --- Executes during object creation, after setting all properties.
function Sampling_Interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sampling_Interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinFrequency_Text_Callback(hObject, eventdata, handles)
% hObject    handle to MinFrequency_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinFrequency_Text as text
%        str2double(get(hObject,'String')) returns contents of MinFrequency_Text as a double


% --- Executes during object creation, after setting all properties.
function MinFrequency_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinFrequency_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxFrequency_Text_Callback(hObject, eventdata, handles)
% hObject    handle to MaxFrequency_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxFrequency_Text as text
%        str2double(get(hObject,'String')) returns contents of MaxFrequency_Text as a double


% --- Executes during object creation, after setting all properties.
function MaxFrequency_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxFrequency_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SeismicPropertiesSaveButton.
function SeismicPropertiesSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SeismicPropertiesSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SeismicProperties_Save(hObject, eventdata, handles)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Start_Modelling.
function Start_Modelling_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Modelling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str= {'Particle Swarm Optimization', 'Bat Algorithm'};
[Num, v]= listdlg('PromptString','Select an algorithm:',...
    'SelectionMode','single',...
    'ListString',str);

if isempty(Num)
    return
elseif Num==1
    prompt= {'Number of Iterations:', 'Number of Particles:', 'Max Inertia:', 'Min Inertia:', 'Cognitive Coefficient:'...
        , 'Social Coefficient:', 'Initial Velocity:'};
    dlg_title= 'PSO coefficients';
    def1= num2str(240);
    def2= num2str(50);
    def3= num2str(0.9);
    def4= num2str(0.4);
    def5= num2str(2.03);
    def6= num2str(2.03);
    def7= num2str(0.01);    
    defaultans= {def1, def2, def3, def4, def5, def6, def7};
    
    Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50], defaultans);
    con1= sum(isnan(str2double(Answers)));
    con2= sum(str2double(Answers)<0);
    con3= str2double(Answers(3))<str2double(Answers(4));
    
    while con1 || con2 || con3
        if con1
            uiwait(errordlg('Values cannot be empty or non-numeric', 'Error'));
        end
        if con2
            uiwait(errordlg('Values cannot be < 0', 'Error'));
        end
        if con3
            uiwait(errordlg('Min Inertia must be <= Max Inertia', 'Error'));
        end
        Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50], Answers);
        
        if isempty(Answers)
            return
        end
        con1= sum(isnan(str2double(Answers)));
        con2= sum(str2double(Answers)<0);
        con3= str2double(Answers(3))<str2double(Answers(4));
    end
    
elseif Num==2
    prompt= {'Number of Iterations:', 'Number of Bats:', 'Max Frequency:', 'Min Frquency:', 'Max Loudness:'...
        , 'Min Loudness:', 'Max Emission Rate:', 'Initial Velocity:'};
    dlg_title= 'BA coefficients';
    def1= num2str(240);
    def2= num2str(50);
    def3= num2str(1);
    def4= num2str(0);
    def5= num2str(1);
    def6= num2str(0.01);    
    def7= num2str(0.99);
    def8= num2str(0);
    defaultans= {def1, def2, def3, def4, def5, def6, def7, def8};
    
    Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50], defaultans);
    
    if isempty(Answers)
        return
    end
    
    con1= sum(isnan(str2double(Answers)));
    con2= sum(str2double(Answers)<0);
    con3= str2double(Answers(3))<str2double(Answers(4));
    con4= str2double(Answers(5))<str2double(Answers(6));
    con5= str2double(Answers(5))>1;
    con6= str2double(Answers(6))==0;     
    con7= str2double(Answers(7))>=1;
    
    while con1 || con2 || con3 || con4 || con5 || con6 || con7
        if con1
            uiwait(errordlg('Values cannot be empty or non-numeric', 'Error'));
        end
        if con2
            uiwait(errordlg('Values cannot be < 0', 'Error'));
        end
        if con3
            uiwait(errordlg('Min Frequency must be <= Max Frequency', 'Error'));
        end
        if con4
            uiwait(errordlg('Min Loudness must be <= Max Loudness', 'Error'));
        end        
        if con5
            uiwait(errordlg('Max Loudness must be <=1', 'Error'));
        end    
        if con6
            uiwait(errordlg('Min Loudness must be >0', 'Error'));
        end 
        if con7
            uiwait(errordlg('Max Emission Rate must be <1', 'Error'));
        end         
        Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50], Answers);
        
        if isempty(Answers)
            return
        end
    con1= sum(isnan(str2double(Answers)));
    con2= sum(str2double(Answers)<0);
    con3= str2double(Answers(3))<str2double(Answers(4));
    con4= str2double(Answers(5))<str2double(Answers(6));
    con5= str2double(Answers(5))>1;
    con6= str2double(Answers(6))==0;     
    con7= str2double(Answers(7))>=1;
    end
end
if isempty(Answers)
    return
end

UserData.Algoritm= Num;
UserData.Answers= str2double(Answers);
Check_For_Modelling(hObject, eventdata, handles, UserData)


% --- Executes on button press in Independent_RES_Entity.
function Independent_RES_Entity_Callback(hObject, eventdata, handles)
% hObject    handle to Independent_RES_Entity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Independent_RES_Entity

if handles.Independent_RES_Entity.Value
    msgbox({'- Mark a reservoir Entity as Independent means it will have its own Fluid content.',...
        '- This will be applied to all Scenarios.'}, 'Note');
end


% --- Executes on button press in milli_Seconds_Depth_Button.
function milli_Seconds_Depth_Button_Callback(hObject, eventdata, handles)
% hObject    handle to milli_Seconds_Depth_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of milli_Seconds_Depth_Button


% --- Executes when entered data in editable cell(s) in Fluids_Library.
function Fluids_Library_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Fluids_Library (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function RES_MaxSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_MaxSW_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_MaxSW_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_MaxSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RES_MinSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to RES_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RES_MinSW_Text as text
%        str2double(get(hObject,'String')) returns contents of RES_MinSW_Text as a double


% --- Executes during object creation, after setting all properties.
function RES_MinSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RES_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_MaxSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_MaxSW_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_MaxSW_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_MaxSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UB_MinSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to UB_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UB_MinSW_Text as text
%        str2double(get(hObject,'String')) returns contents of UB_MinSW_Text as a double


% --- Executes during object creation, after setting all properties.
function UB_MinSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UB_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_MaxSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_MaxSW_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_MaxSW_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_MaxSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_MaxSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OB_MinSW_Text_Callback(hObject, eventdata, handles)
% hObject    handle to OB_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OB_MinSW_Text as text
%        str2double(get(hObject,'String')) returns contents of OB_MinSW_Text as a double


% --- Executes during object creation, after setting all properties.
function OB_MinSW_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OB_MinSW_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OB_PorLeftCoor.
function OB_PorLeftCoor_Callback(hObject, eventdata, handles)
% hObject    handle to OB_PorLeftCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_PorLeftCoor
if handles.Show_Full_Entities.Value
    handles.OB_PorLeftCoor.Value= 0;
    return;
end

if handles.OB_PorLeftCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.OB_PorLeftCoor.BackgroundColor=[0 1 0];
    handles.OB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    handles.OB_PorRightCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
elseif handles.OB_PorLeftCoor.Value==0
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.OB_PorLeftCoor.BackgroundColor=[0.9 0.9 0.9];
end




% --- Executes on button press in OB_PorRightCoor.
function OB_PorRightCoor_Callback(hObject, eventdata, handles)
% hObject    handle to OB_PorRightCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_PorRightCoor
if handles.Show_Full_Entities.Value
    handles.OB_PorRightCoor.Value= 0;
    return;
end
if handles.OB_PorRightCoor.Value
    % Set ButtonDownFcn of the image as below
    handles.OB_PorRightCoor.BackgroundColor=[0 1 0];
    handles.OB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.OB_PorLeftCoor.Value=0;
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', @(hObject,eventdata)Model('axes2_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
else
    set(handles.Entity_Plot_Obj , 'ButtonDownFcn', ' ');
    handles.OB_PorRightCoor.BackgroundColor=[.9 .9 .9];
end


% --- Executes on button press in OB_Porosity_SingleValue.
function OB_Porosity_SingleValue_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_SingleValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Porosity_SingleValue
if handles.OB_Porosity_SingleValue.Value
    handles.OB_PorTwoValue_Menu.Visible= 'Off';
    handles.OB_PorThreeValueLeft_Menu.Visible= 'Off';
    handles.OB_PorThreeValueRight_Menu.Visible= 'Off';
    handles.OB_PorMidPointTable.Visible= 'Off';

    handles.text302.Visible='Off';
    handles.OBPor_Max_Range.Visible='Off';    
    
    handles.OB_PorLeftCoor.Value= 0;
    handles.OB_PorLeftCoor.BackgroundColor= [.9 .9 .9];
    handles.OB_PorRightCoor.Value= 0;
    handles.OB_PorRightCoor.BackgroundColor= [.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.OB_PorMidValue_FirstCol.String= '';
    handles.OB_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    
    set(handles.axes2, 'ButtonDownFcn', '');
end


% --- Executes on button press in OB_Porosity_TwoValues.
function OB_Porosity_TwoValues_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_TwoValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Porosity_TwoValues
if handles.OB_Porosity_TwoValues.Value
    handles.OB_PorTwoValue_Menu.Visible='On';
    handles.OB_PorThreeValueLeft_Menu.Visible='Off';
    handles.OB_PorThreeValueRight_Menu.Visible='Off';
    handles.OB_PorMidPointTable.Visible='Off';

    handles.text302.Visible='On';
    handles.OBPor_Max_Range.Visible='On';    
    
    handles.OB_PorLeftCoor.Value=0;
    handles.OB_PorLeftCoor.BackgroundColor=[.9 .9 .9];
    handles.OB_PorRightCoor.Value=0;
    handles.OB_PorRightCoor.BackgroundColor=[.9 .9 .9];
    Entity_Num= handles.Entity_Number_Text.String;
    setappdata(handles.Model_fig, ['OB_Left_PorPoint' 'Entity' Entity_Num], '');
    setappdata(handles.Model_fig, ['OB_Right_PorPoint' 'Entity' Entity_Num], '');
    handles.OB_PorMidValue_FirstCol.String= '';
    handles.OB_PorMidValue_LastCol.String= '';
    cla(handles.axes2);             % Clear the axes2
    Model_Plotter(handles)          % Plot the Entity
    
    set(handles.axes2, 'ButtonDownFcn', '');
end


% --- Executes on button press in OB_Porosity_ThreeValues.
function OB_Porosity_ThreeValues_Callback(hObject, eventdata, handles)
% hObject    handle to OB_Porosity_ThreeValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OB_Porosity_ThreeValues
if handles.OB_Porosity_ThreeValues.Value
    handles.OB_PorTwoValue_Menu.Visible= 'Off';
    handles.text302.Visible='On';
    handles.OBPor_Max_Range.Visible='On';   
    
    handles.OB_PorThreeValueLeft_Menu.Visible= 'On';
    handles.OB_PorThreeValueRight_Menu.Visible= 'On';
    handles.OB_PorMidPointTable.Visible= 'On';
end




% --- Executes on button press in Help_Porosity.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Porosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in RES_Scenario_Library.
function RES_Scenario_Library_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to RES_Scenario_Library (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Table= handles.RES_Scenario_Library.Data;  % get the Table
for iter=1:size(Table, 1)
    Rows= cell2mat(Table(iter, 2:7));  % get the checked Rows
    if length(Rows)==6 && ~prod(isnan(Rows))
        rho= [Rows(1) Rows(2)]/1000;    % Get Density in g/cm3
        K= [Rows(3) Rows(4)];      % Get Bulk Modulus
        U= [Rows(5) Rows(6)];      % Get Shear Modulus
        con1= rho(1)<=rho(2) && K(1)<=K(2) && U(1)<=U(2); % Condition of arrangment
        con2= prod(Rows>=0);        % Condition of >0 elements
        d=1;
        if con1 && con2
            for i=1:2
                for j=1:2
                    for m=1:2
                        Vp(d)= sqrt((K(i)+(4./3*U(j)))./rho(m))*1000;
                        Vs(d)= sqrt((U(j))./rho(m))*1000;
                        d=d+1;
                    end
                end
            end
            handles.RES_Scenario_Library.Data(iter, 8)= {['       ' num2str(round(min(Vp))) '  -  ' num2str(round(max(Vp))) '  ']};
            handles.RES_Scenario_Library.Data(iter, 9)= {['       ' num2str(round(min(Vs))) '  -  ' num2str(round(max(Vs))) '  ']};
        else
            handles.RES_Scenario_Library.Data(iter, 8)= {''};
            handles.RES_Scenario_Library.Data(iter, 9)= {''};
        end
    else
        handles.RES_Scenario_Library.Data(iter, 8)= {''};
        handles.RES_Scenario_Library.Data(iter, 9)= {''};
    end
end


% --- Executes when entered data in editable cell(s) in Mineralogy_Library.
function Mineralogy_Library_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Mineralogy_Library (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Table= handles.Mineralogy_Library.Data;  % get the Table
for iter=1:size(Table, 1)
    Rows= cell2mat(Table(iter, 2:7));  % get the checked Rows
    if length(Rows)==6 && ~prod(isnan(Rows))
        rho= [Rows(1) Rows(2)]/1000;    % Get Density in g/cm3
        K= [Rows(3) Rows(4)];      % Get Bulk Modulus
        U= [Rows(5) Rows(6)];      % Get Shear Modulus
        con1= rho(1)<=rho(2) && K(1)<=K(2) && U(1)<=U(2); % Condition of arrangment
        con2= prod(Rows>=0);        % Condition of >0 elements
        d=1;
        if con1 && con2
            Min_Vp= sqrt((min(K)+(4./3*min(U)))./max(rho))*1000;
            Max_Vp= sqrt((max(K)+(4./3*max(U)))./min(rho))*1000;
            Min_Vs= sqrt((min(U))./max(rho))*1000;
            Max_Vs= sqrt((max(U))./min(rho))*1000;
            handles.Mineralogy_Library.Data(iter, 8)= {['       ' num2str(round(Min_Vp)) '  -  ' num2str(round(Max_Vp)) '  ']};
            handles.Mineralogy_Library.Data(iter, 9)= {['       ' num2str(round(Min_Vs)) '  -  ' num2str(round(Max_Vs)) '  ']};
        else
            handles.Mineralogy_Library.Data(iter, 8)= {''};
            handles.Mineralogy_Library.Data(iter, 9)= {''};
        end
    else
        handles.Mineralogy_Library.Data(iter, 8)= {''};
        handles.Mineralogy_Library.Data(iter, 9)= {''};
    end
end



function ResPor_Max_Range_Callback(hObject, eventdata, handles)
% hObject    handle to ResPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResPor_Max_Range as text
%        str2double(get(hObject,'String')) returns contents of ResPor_Max_Range as a double


% --- Executes during object creation, after setting all properties.
function ResPor_Max_Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UBPor_Max_Range_Callback(hObject, eventdata, handles)
% hObject    handle to UBPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UBPor_Max_Range as text
%        str2double(get(hObject,'String')) returns contents of UBPor_Max_Range as a double


% --- Executes during object creation, after setting all properties.
function UBPor_Max_Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UBPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OBPor_Max_Range_Callback(hObject, eventdata, handles)
% hObject    handle to OBPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OBPor_Max_Range as text
%        str2double(get(hObject,'String')) returns contents of OBPor_Max_Range as a double


% --- Executes during object creation, after setting all properties.
function OBPor_Max_Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OBPor_Max_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Sies_Polarity.
function Sies_Polarity_Callback(hObject, eventdata, handles)
% hObject    handle to Sies_Polarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sies_Polarity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sies_Polarity


% --- Executes during object creation, after setting all properties.
function Sies_Polarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sies_Polarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
