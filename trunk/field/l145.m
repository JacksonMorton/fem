function [Th,fractionalBandwidth,centerFrequency]=l145(FIELD_PARAMS);
% function [Th,fractionalBandwidth,centerFrequency]=l145(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% VF10-5 for use by fieldprms3d_arfi.m
% 
% Mark 06/11/07
addpath('/data/vr16/matlab/FieldII');
disp('Transducer: 14-L5');
no_elements_y=3;
width=.2e-3;
kerf=0.001e-3;
pitch = width + kerf;
height=[3e-3 1.5e-3 3e-3];
% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
% lens focus
Rfocus=19e-3;
% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=round(height(1)/width);
no_sub_x=1;
% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);
% define the fractional bandwidth
fractionalBandwidth = 0.45;
centerFrequency = 8e6;
