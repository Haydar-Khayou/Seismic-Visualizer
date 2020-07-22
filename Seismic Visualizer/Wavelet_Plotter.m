function Wavelet_Plotter(handles)
% This tool is a part of the Seismic Visualizer
%
%
%           Damascus University - Faculty of sciences
%           Author: Haydar Khayou
%
%% Variables
Sampling_Interval= str2double(handles.Sampling_Interval.String)/1000;    % Sampling Interval in Sec
NumberOfSamples= 1/Sampling_Interval;
NumberOfSamples= round(NumberOfSamples,0);
Freqeuncy= 35;
t0= 0;

% Generate Ricker wavelet with the above parameters
[rw,t] = Edited_ricker(Freqeuncy, NumberOfSamples, Sampling_Interval, t0);

% delete the unnecessary 0 Values of the Wavelet and make sure to still
% % symmetric
t(find(rw==0))= [];
rw(find(rw==0))= [];

% Plot the Wavelet
plot(handles.Wavelet_Axes, t,rw);
title(handles.Wavelet_Axes, 'Zero-Phase Ricker Wavelet');
xlabel(handles.Wavelet_Axes, 'Time(mSec)');
ylabel(handles.Wavelet_Axes, 'Amplitude');
grid(handles.Wavelet_Axes, 'On');
