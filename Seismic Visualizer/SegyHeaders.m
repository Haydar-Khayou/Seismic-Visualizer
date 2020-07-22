function varargout = SegyHeaders(varargin)
% SEGYHEADERS MATLAB code for SegyHeaders.fig
%      SEGYHEADERS, by itself, creates a new SEGYHEADERS or raises the existing
%      singleton*.
%
%      H = SEGYHEADERS returns the handle to a new SEGYHEADERS or the handle to
%      the existing singleton*.
%
%      SEGYHEADERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGYHEADERS.M with the given input arguments.
%
%      SEGYHEADERS('Property','Value',...) creates a new SEGYHEADERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SegyHeaders_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SegyHeaders_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SegyHeaders

% Last Modified by GUIDE v2.5 18-Nov-2019 20:04:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SegyHeaders_OpeningFcn, ...
    'gui_OutputFcn',  @SegyHeaders_OutputFcn, ...
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


% --- Executes just before SegyHeaders is made visible.
function SegyHeaders_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SegyHeaders (see VARARGIN)

% Choose default command line output for SegyHeaders
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SegyHeaders wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%
load('filename.mat');                         % Get the segy file's full name.
Segy_Headers= show_segy_header(file);         % Read Segy file headers and save it as a char variable.
Segy_Headers= string(Segy_Headers);           % Convert it to a string variable.
handles.SegyHeadersText.String= Segy_Headers; % Show Headers on the 'SegyHeaders' figure.
SegyInfo= [];                                 % Create a structure variable(empty it if it existed from a previous work) to save the Segy Headers information.
save('SegyInfo.mat', 'SegyInfo');             % Save the structure variable.


% --- Outputs from this function are returned to the command line.
function varargout = SegyHeaders_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on selection change in SegyHeadersText.
function SegyHeadersText_Callback(hObject, eventdata, handles)
% hObject    handle to SegyHeadersText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SegyHeadersText contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SegyHeadersText


% --- Executes during object creation, after setting all properties.
function SegyHeadersText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SegyHeadersText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Inline_Header_From_Callback(hObject, eventdata, handles)
% hObject    handle to Inline_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Inline_Header_From as text
%        str2double(get(hObject,'String')) returns contents of Inline_Header_From as a double

Inline_Header_From= handles.Inline_Header_From.String;      % Get it from figure
Inline_Header_From= str2double(Inline_Header_From);         % Convert it to double.
if ~isnan(Inline_Header_From)                               % if it's a number
    if Inline_Header_From~=round(Inline_Header_From)        % if it isn't an integer then
        errordlg('Value must be integer', 'Unvalid Entry');  % open errdlg and
        handles.Inline_Header_From.String= '5';             % reset box value to default.
    end
elseif isnan(Inline_Header_From)                            % if it isn't a number then
    errordlg('Value must be numeric', 'Unvalid Entry');      % open errdlg and
    handles.Inline_Header_From.String= '5';                 % reset box value to default.
end

% --- Executes during object creation, after setting all properties.
function Inline_Header_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inline_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Inline_Header_To_Callback(hObject, eventdata, handles)
% hObject    handle to Inline_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Inline_Header_To as text
%        str2double(get(hObject,'String')) returns contents of Inline_Header_To as a double
Inline_Header_To= handles.Inline_Header_To.String;
Inline_Header_To= str2double(Inline_Header_To);
if ~isnan(Inline_Header_To)
    if Inline_Header_To~=round(Inline_Header_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Inline_Header_To.String= '8';
    end
elseif isnan(Inline_Header_To)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Inline_Header_To.String= '8';
end




% --- Executes during object creation, after setting all properties.
function Inline_Header_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inline_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function Xline_Header_From_Callback(hObject, eventdata, handles)
% hObject    handle to Xline_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xline_Header_From as text
%        str2double(get(hObject,'String')) returns contents of Xline_Header_From as a double
Xline_Header_From= handles.Xline_Header_From.String;
Xline_Header_From= str2double(Xline_Header_From);
if ~isnan(Xline_Header_From)
    if Xline_Header_From~=round(Xline_Header_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xline_Header_From.String= '21';
    end
elseif isnan(Xline_Header_From)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Xline_Header_From.String= '21';
end


% --- Executes during object creation, after setting all properties.
function Xline_Header_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xline_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xcoor_Header_From_Callback(hObject, eventdata, handles)
% hObject    handle to Xcoor_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xcoor_Header_From as text
%        str2double(get(hObject,'String')) returns contents of Xcoor_Header_From as a double
Xcoor_Header_From= handles.Xcoor_Header_From.String;
Xcoor_Header_From= str2double(Xcoor_Header_From);
if ~isnan(Xcoor_Header_From)
    if Xcoor_Header_From~=round(Xcoor_Header_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xcoor_Header_From.String= '73';
    end
elseif isnan(Xcoor_Header_From)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Xcoor_Header_From.String= '73';
end



% --- Executes during object creation, after setting all properties.
function Xcoor_Header_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xcoor_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ycoor_Header_From_Callback(hObject, eventdata, handles)
% hObject    handle to Ycoor_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ycoor_Header_From as text
%        str2double(get(hObject,'String')) returns contents of Ycoor_Header_From as a double
Ycoor_Header_From= handles.Ycoor_Header_From.String;
Ycoor_Header_From= str2double(Ycoor_Header_From);
if ~isnan(Ycoor_Header_From)
    if Ycoor_Header_From~=round(Ycoor_Header_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Ycoor_Header_From.String= '77';
    end
elseif isnan(Ycoor_Header_From)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Ycoor_Header_From.String= '77';
end




% --- Executes during object creation, after setting all properties.
function Ycoor_Header_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ycoor_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function Xline_Header_To_Callback(hObject, eventdata, handles)
% hObject    handle to Xline_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xline_Header_To as text
%        str2double(get(hObject,'String')) returns contents of Xline_Header_To as a double
Xline_Header_To= handles.Xline_Header_To.String;
Xline_Header_To= str2double(Xline_Header_To);
if ~isnan(Xline_Header_To)
    if Xline_Header_To~=round(Xline_Header_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xline_Header_To.String= '24';
    end
elseif isnan(Xline_Header_To)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Xline_Header_To.String= '24';
end



% --- Executes during object creation, after setting all properties.
function Xline_Header_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xline_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xcoor_Header_To_Callback(hObject, eventdata, handles)
% hObject    handle to Xcoor_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xcoor_Header_To as text
%        str2double(get(hObject,'String')) returns contents of Xcoor_Header_To as a double
Xcoor_Header_To= handles.Xcoor_Header_To.String;
Xcoor_Header_To= str2double(Xcoor_Header_To);
if ~isnan(Xcoor_Header_To)
    if Xcoor_Header_To~=round(Xcoor_Header_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xcoor_Header_To.String= '76';
    end
elseif isnan(Xcoor_Header_To)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Xcoor_Header_To.String= '76';
end




% --- Executes during object creation, after setting all properties.
function Xcoor_Header_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xcoor_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ycoor_Header_To_Callback(hObject, eventdata, handles)
% hObject    handle to Ycoor_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ycoor_Header_To as text
%        str2double(get(hObject,'String')) returns contents of Ycoor_Header_To as a double
Ycoor_Header_To= handles.Ycoor_Header_To.String;
Ycoor_Header_To= str2double(Ycoor_Header_To);
if ~isnan(Ycoor_Header_To)
    if Ycoor_Header_To~=round(Ycoor_Header_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Ycoor_Header_To.String= '80';
    end
elseif isnan(Ycoor_Header_To)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Ycoor_Header_To.String= '80';
end



% --- Executes during object creation, after setting all properties.
function Ycoor_Header_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ycoor_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Trace_Start_Time_Header_From_Callback(hObject, eventdata, handles)
% hObject    handle to Trace_Start_Time_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Trace_Start_Time_Header_From as text
%        str2double(get(hObject,'String')) returns contents of Trace_Start_Time_Header_From as a double
Trace_Start_Time_Header_From= handles.Trace_Start_Time_Header_From.String;
Trace_Start_Time_Header_From= str2double(Trace_Start_Time_Header_From);
if ~isnan(Trace_Start_Time_Header_From)
    if Trace_Start_Time_Header_From~=round(Trace_Start_Time_Header_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Trace_Start_Time_Header_From.String= '105';
    end
elseif isnan(Trace_Start_Time_Header_From)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Trace_Start_Time_Header_From.String= '105';
end




% --- Executes during object creation, after setting all properties.
function Trace_Start_Time_Header_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace_Start_Time_Header_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Trace_Start_Time_Header_To_Callback(hObject, eventdata, handles)
% hObject    handle to Trace_Start_Time_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Trace_Start_Time_Header_To as text
%        str2double(get(hObject,'String')) returns contents of Trace_Start_Time_Header_To as a double
Trace_Start_Time_Header_To= handles.Trace_Start_Time_Header_To.String;
Trace_Start_Time_Header_To= str2double(Trace_Start_Time_Header_To);
if ~isnan(Trace_Start_Time_Header_To)
    if Trace_Start_Time_Header_To~=round(Trace_Start_Time_Header_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Trace_Start_Time_Header_To.String= '106';
    end
elseif isnan(Trace_Start_Time_Header_To)
    errordlg('Value must be numeric', 'Unvalid Entry');
    handles.Trace_Start_Time_Header_To.String= '106';
end




% --- Executes during object creation, after setting all properties.
function Trace_Start_Time_Header_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace_Start_Time_Header_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpdlg({'- Compare the binary locations in the list with the locations in';...
         '   the text boxes.';...
    '- Edit the values in the text boxes in case of mismatch.'},...
    'Help');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpdlg({'- Determine the dimensions of the Seismic volume to be viewed:'...
    ;'  1. Enter the extent of Inline slices.'...
    ;'  2. Enter the extent of Xline slices.'...
    ;'  3. Enter the Time range.'...
    ;'  4. To view the whole volume leave the text boxes empty.'...
    ;'  5. Time Range from must be >= 0'...    
    ;''...
    ;'- Note: if the information provided is unvalid, no data will'...
    ;'            be viewed.'},...
    'Help');







function Inline_Extent_From_Callback(hObject, eventdata, handles)
% hObject    handle to Inline_Extent_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Inline_Extent_From as text
%        str2double(get(hObject,'String')) returns contents of Inline_Extent_From as a double
Inline_Extent_From= handles.Inline_Extent_From.String;
Inline_Extent_From= str2double(Inline_Extent_From);
if ~isnan(Inline_Extent_From)
    if Inline_Extent_From~=round(Inline_Extent_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Inline_Extent_From.String= '';
    end
elseif isnan(Inline_Extent_From)
    handles.Inline_Extent_From.String= '';
end



% --- Executes during object creation, after setting all properties.
function Inline_Extent_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inline_Extent_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xline_Extent_From_Callback(hObject, eventdata, handles)
% hObject    handle to Xline_Extent_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xline_Extent_From as text
%        str2double(get(hObject,'String')) returns contents of Xline_Extent_From as a double
Xline_Extent_From= handles.Xline_Extent_From.String;
Xline_Extent_From= str2double(Xline_Extent_From);
if ~isnan(Xline_Extent_From)
    if Xline_Extent_From~=round(Xline_Extent_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xline_Extent_From.String= '';
    end
elseif isnan(Xline_Extent_From)
    handles.Xline_Extent_From.String= '';
end



% --- Executes during object creation, after setting all properties.
function Xline_Extent_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xline_Extent_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Time_Range_From_Callback(hObject, eventdata, handles)
% hObject    handle to Time_Range_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_Range_From as text
%        str2double(get(hObject,'String')) returns contents of Time_Range_From as a double
Time_Range_From= handles.Time_Range_From.String;
Time_Range_From= str2double(Time_Range_From);
if ~isnan(Time_Range_From)
    if Time_Range_From~=round(Time_Range_From)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Time_Range_From.String= '';
    end
elseif isnan(Time_Range_From)
    handles.Time_Range_From.String= '';
end




% --- Executes during object creation, after setting all properties.
function Time_Range_From_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_Range_From (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Inline_Extent_To_Callback(hObject, eventdata, handles)
% hObject    handle to Inline_Extent_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Inline_Extent_To as text
%        str2double(get(hObject,'String')) returns contents of Inline_Extent_To as a double
Inline_Extent_To= handles.Inline_Extent_To.String;
Inline_Extent_To= str2double(Inline_Extent_To);
if ~isnan(Inline_Extent_To)
    if Inline_Extent_To~=round(Inline_Extent_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Inline_Extent_To.String= '';
    end
elseif isnan(Inline_Extent_To)
    handles.Inline_Extent_To.String= '';
end




% --- Executes during object creation, after setting all properties.
function Inline_Extent_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inline_Extent_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xline_Extent_To_Callback(hObject, eventdata, handles)
% hObject    handle to Xline_Extent_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xline_Extent_To as text
%        str2double(get(hObject,'String')) returns contents of Xline_Extent_To as a double
Xline_Extent_To= handles.Xline_Extent_To.String;
Xline_Extent_To= str2double(Xline_Extent_To);
if ~isnan(Xline_Extent_To)
    if Xline_Extent_To~=round(Xline_Extent_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Xline_Extent_To.String= '';
    end
elseif isnan(Xline_Extent_To)
    handles.Xline_Extent_To.String= '';
end




% --- Executes during object creation, after setting all properties.
function Xline_Extent_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xline_Extent_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Time_Range_To_Callback(hObject, eventdata, handles)
% hObject    handle to Time_Range_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_Range_To as text
%        str2double(get(hObject,'String')) returns contents of Time_Range_To as a double
Time_Range_To= handles.Time_Range_To.String;
Time_Range_To= str2double(Time_Range_To);
if ~isnan(Time_Range_To)
    if Time_Range_To~=round(Time_Range_To)
        errordlg('Value must be integer', 'Unvalid Entry');
        handles.Time_Range_To.String= '';
    end
elseif isnan(Time_Range_To)
    handles.Time_Range_To.String= '';
end




% --- Executes during object creation, after setting all properties.
function Time_Range_To_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_Range_To (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Save text boxes inputs


%% Inline_Header extent
Inline_Header_From= str2double(handles.Inline_Header_From.String);
Inline_Header_To= str2double(handles.Inline_Header_To.String);
if Inline_Header_From>Inline_Header_To
    errordlg('Inline Number from must be smaller than Inline Number to', 'Unvalid Entry');
    return
else
    Inline_Header_Cells= (Inline_Header_To - Inline_Header_From + 1);   % Cells(bytes) = (from - To)+1
    SegyInfo.Inline_Header_From= Inline_Header_From;
    SegyInfo.Inline_Header_Cells= Inline_Header_Cells;
end

%% Xline_Header extent
Xline_Header_From= str2double(handles.Xline_Header_From.String);
Xline_Header_To= str2double(handles.Xline_Header_To.String);
if Xline_Header_From>Xline_Header_To
    errordlg('Xline Number from must be smaller than Xline Number to', 'Unvalid Entry');
    return
else
    Xline_Header_Cells= (Xline_Header_To - Xline_Header_From + 1);      % Cells(bytes) = (from - To)+1
    SegyInfo.Xline_Header_From= Xline_Header_From;
    SegyInfo.Xline_Header_Cells= Xline_Header_Cells;
end

%% Xcoor_Header extent
Xcoor_Header_From= str2double(handles.Xcoor_Header_From.String);
Xcoor_Header_To= str2double(handles.Xcoor_Header_To.String);
if Xcoor_Header_From>Xcoor_Header_To
    errordlg('Xline Number from must be smaller than Xline Number to', 'Unvalid Entry');
    return
else
    Xcoor_Header_Cells= (Xcoor_Header_To - Xcoor_Header_From + 1);      % Cells(bytes) = (from - To)+1
    SegyInfo.Xcoor_Header_From= Xcoor_Header_From;
    SegyInfo.Xcoor_Header_Cells= Xcoor_Header_Cells;
end

%% Ycoor_Header extent
Ycoor_Header_From= str2double(handles.Ycoor_Header_From.String);
Ycoor_Header_To= str2double(handles.Ycoor_Header_To.String);
if Ycoor_Header_From>Ycoor_Header_To
    errordlg('Xline Number from must be smaller than Xline Number to', 'Unvalid Entry');
    return
else
    Ycoor_Header_Cells= (Ycoor_Header_To - Ycoor_Header_From + 1);      % Cells(bytes) = (from - To)+1
    SegyInfo.Ycoor_Header_From= Ycoor_Header_From;
    SegyInfo.Ycoor_Header_Cells= Ycoor_Header_Cells;
end

%% Trace_Start_Time_Header extent
Trace_Start_Time_Header_From= str2double(handles.Trace_Start_Time_Header_From.String);
Trace_Start_Time_Header_To= str2double(handles.Trace_Start_Time_Header_To.String);
if Trace_Start_Time_Header_From>Trace_Start_Time_Header_To
    errordlg('Xline Number from must be smaller than Xline Number to', 'Unvalid Entry');
    return
else
    Trace_Start_Time_Header_Cells= (Trace_Start_Time_Header_To - Trace_Start_Time_Header_From + 1);  % Cells(bytes) = (from - To)+1
    SegyInfo.Trace_Start_Time_Header_From= Trace_Start_Time_Header_From;
    SegyInfo.Trace_Start_Time_Header_Cells= Trace_Start_Time_Header_Cells;
end


%% Volume Deminsions: 

%%% Inline_Extent
Inline_Extent_From= handles.Inline_Extent_From.String;
if isempty(Inline_Extent_From)
    Inline_Extent_From= '-inf';
end

Inline_Extent_To= handles.Inline_Extent_To.String;
if isempty(Inline_Extent_To)
    Inline_Extent_To= 'inf';
end

if str2double(Inline_Extent_From) > str2double(Inline_Extent_To)
    errordlg('Inline Extent from must be smaller than Inline Extent to', 'Unvalid Entry');
    return
end

if (str2double(Inline_Extent_To) - str2double(Inline_Extent_From)) < 2
    errordlg('(Inline Extent To - Inline Extent From) must be >= 2', 'Unvalid Entry');
    return
end


%%% Xline_Extent
Xline_Extent_From= handles.Xline_Extent_From.String;
if isempty(Xline_Extent_From)
    Xline_Extent_From= '-inf';
end


Xline_Extent_To= handles.Xline_Extent_To.String;
if isempty(Xline_Extent_To)
    Xline_Extent_To= 'inf';
end

if str2double(Xline_Extent_From) > str2double(Xline_Extent_To)
    errordlg('Xline Extent from must be smaller than Xline Extent to', 'Unvalid Entry');
    return
end

if (str2double(Xline_Extent_To) - str2double(Xline_Extent_From)) < 2
    errordlg('(Xline Extent To - Xline Extent From) must be >= 2', 'Unvalid Entry');
    return
end


%%% Time Range
Time_Range_From= handles.Time_Range_From.String;
if isempty(Time_Range_From)
    Time_Range_From= '-inf';
end

Time_Range_To= handles.Time_Range_To.String;
if isempty(Time_Range_To)
    Time_Range_To= 'inf';
end

if str2double(Time_Range_From) > str2double(Time_Range_To)
    errordlg('Time Range from must be smaller than Time Range to', 'Unvalid Entry');
    return
end

if str2double(Time_Range_From) < 0
    errordlg('Start Time must be >= 0', 'Unvalid Entry');
    return
end

%% Save Data
% Here we save (valid) text boxes variables in the structure variable: 'SegyInfo'
SegyInfo.Inline_Extent_From= Inline_Extent_From;
SegyInfo.Inline_Extent_To= Inline_Extent_To;
SegyInfo.Xline_Extent_From= Xline_Extent_From;
SegyInfo.Xline_Extent_To= Xline_Extent_To;
SegyInfo.Time_Range_From= str2double(Time_Range_From);
SegyInfo.Time_Range_To= str2double(Time_Range_To);
save('SegyInfo.mat', 'SegyInfo');
InfoFromSeg= 1;                           %% InfoFromSeg is a logical variable and it tells other 
save('InfoFromSeg.mat', 'InfoFromSeg');   %% functions that there is information to deal with
Seismic_Visualizer;                       % open 'Seismic_Visualizer' figure
close(SegyHeaders);



