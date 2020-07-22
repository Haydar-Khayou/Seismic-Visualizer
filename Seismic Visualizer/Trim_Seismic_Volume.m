function Trim_Seismic_Volume(handles)
% This tool is part of Seismic Visualizer
%
%
%           Damascus University - Faculty of Science
%           Author: Haydar Khayou

%% Get Data
global Seis_orig_Data Basic_info_Vis

%% Warning message
uiwait(helpdlg({'- Volume Resize may take a while especially if the data is large.'...
               ,'- Resize inline and xline is much more faster than resize time'}, 'Warning'));

%% Get Data from the user
prompt= {'Inline From:', 'Inline To:', 'Xline From:', 'Xline To:', 'Time From:', 'Time To:'};
dlg_title= 'Volume Dimensions';
def1= num2str(Basic_info_Vis.first_inline);
def2= num2str(Basic_info_Vis.last_inline);
def3= num2str(Basic_info_Vis.first_xline);
def4= num2str(Basic_info_Vis.last_xline);
def5= num2str(min(Basic_info_Vis.Yaxis_inline));
def6= num2str(max(Basic_info_Vis.Yaxis_inline));
defaultans= {def1, def2, def3, def4, def5, def6};

Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50], defaultans);
if isempty(Answers)
    return
end

con1= sum(isnan(str2double(Answers)));
con2= str2double(Answers{1})>str2double(Answers{2})...
    || str2double(Answers{1})<Basic_info_Vis.first_inline || str2double(Answers{2})>Basic_info_Vis.last_inline;
con22= str2double(Answers{2})<str2double(Answers{1})+Basic_info_Vis.inline_step;
con3= str2double(Answers{3})>str2double(Answers{4})...
    || str2double(Answers{3})<Basic_info_Vis.first_xline || str2double(Answers{4})>Basic_info_Vis.last_xline;
con33= str2double(Answers{4})<str2double(Answers{3})+Basic_info_Vis.xline_step;
con4= str2double(Answers{5})>str2double(Answers{6})...
    || str2double(Answers{5})<Basic_info_Vis.Trace_start_time || str2double(Answers{6})>(Seis_orig_Data.last + Basic_info_Vis.Trace_start_time);
%% Check the user inputs
while con1 || con2 || con22 || con3 || con33 || con4
    if con1
        uiwait(errordlg('Values cannot be empty or non-numeric', 'Error'));
    end
    if con2
        uiwait(errordlg('Check inline values', 'Error'));
    end
    if con22
        uiwait(errordlg(['"Inline to" must be at least larger than "inline from" by inline step= ', num2str(Basic_info_Vis.inline_step)] , 'Error'));
    end
    if con3
        uiwait(errordlg('Check xline values', 'Error'));
    end
    if con33
        uiwait(errordlg(['"xline to" must be at least larger than "xline from" by xline step= ', num2str(Basic_info_Vis.xline_step)] , 'Error'));
    end
    Answers= inputdlg(prompt, dlg_title, [1 50; 1 50; 1 50; 1 50; 1 50; 1 50], defaultans);
    if isempty(Answers)
        return
    end
    con1= sum(isnan(str2double(Answers)));
    con2= str2double(Answers{1})>str2double(Answers{2})...
        || str2double(Answers{1})<Basic_info_Vis.first_inline || str2double(Answers{2})>Basic_info_Vis.last_inline;
    con22= str2double(Answers{2})<str2double(Answers{1})+Basic_info_Vis.inline_step;
    con3= str2double(Answers{3})>str2double(Answers{4})...
        || str2double(Answers{3})<Basic_info_Vis.first_xline || str2double(Answers{4})>Basic_info_Vis.last_xline;
    con33= str2double(Answers{4})<str2double(Answers{3})+Basic_info_Vis.xline_step;
    con4= str2double(Answers{5})>str2double(Answers{6})...
        || str2double(Answers{5})<Basic_info_Vis.Trace_start_time || str2double(Answers{6})>(Seis_orig_Data.last + Basic_info_Vis.Trace_start_time);
    
    if isempty(Answers)
        return
    end
end

%% Cut Inline & Xline

inline_Row= Basic_info_Vis.inline_Row;             % inline row number in headers
Min_inline_From_User= str2double(Answers{1});  % Get start inline from User
Max_inline_From_User= str2double(Answers{2});  % Get end inline from User


xline_Row= Basic_info_Vis.xline_Row;               % xline row number in headers
Min_xline_From_User= str2double(Answers{3});   % Get start xline from User
Max_xline_From_User= str2double(Answers{4});   % Get end xline from User


% Go to the volume and detect the wanted traces
Extent= find(Seis_orig_Data.headers(inline_Row, :)>=Min_inline_From_User...
    & Seis_orig_Data.headers(inline_Row, :)<= Max_inline_From_User...
    & Seis_orig_Data.headers(xline_Row, :)>=Min_xline_From_User...
    & Seis_orig_Data.headers(xline_Row, :)<=Max_xline_From_User);


% Cut the traces that are not within the extent
Seis_orig_Data.headers= Seis_orig_Data.headers(:, Extent);
Seis_orig_Data.traces= Seis_orig_Data.traces(:, Extent);

%% Cut Time
Trace_start_time= Seis_orig_Data.first + Basic_info_Vis.Trace_start_time;

Min_Time_User= str2double(Answers{5}) - Trace_start_time;  % Get start Time from User
Max_Time_User= str2double(Answers{6}) - Trace_start_time;  % Get end Time from User

Min_Time_User= Min_Time_User - rem(Min_Time_User, Seis_orig_Data.step);
Max_Time_User= Max_Time_User - rem(Max_Time_User, Seis_orig_Data.step);

Min_Time_corr= (((Min_Time_User)/Seis_orig_Data.step)+1);
Max_Time_corr= ((Max_Time_User)/Seis_orig_Data.step)+1;

% Go to the volume and detect the traces
Seis_orig_Data.traces= Seis_orig_Data.traces(int32(Min_Time_corr):int32(Max_Time_corr), :);

%% We do some math here to put the right values for 'Seis_orig_Data.first' and 'Seis_orig_Data.last'

Min_Time_User= str2double(Answers{5}) - Basic_info_Vis.Trace_start_time;    % Get start Time from User
Max_Time_User= str2double(Answers{6}) - Basic_info_Vis.Trace_start_time;    % Get end Time from User

Min_Time_User= Min_Time_User - rem(Min_Time_User, Seis_orig_Data.step);
Max_Time_User= Max_Time_User - rem(Max_Time_User, Seis_orig_Data.step);

Seis_orig_Data.first= Min_Time_User;
Seis_orig_Data.last= Max_Time_User ;

First_Time_Seismic_Plotter(handles)
Seismic_Plotter(handles)
