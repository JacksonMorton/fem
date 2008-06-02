function [Th,fractionalBandwidth,centerFrequency]=tu15l8w(FIELD_PARAMS);
% function [Th,fractionalBandwidth,centerFrequency]=tu15l8w(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% transurethral 15L8W for use by fieldprms3d_arfi.m
% 
% Mark 06/02/08

disp('Transducer: 15L8W');
no_elements_y=1;
pitch = 200e-3;
kerf=0.025e-3;
width=pitch-kerf;
height=4.0e-3;
% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
% lens focus
Rfocus=15.0e-3;
% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=2;
% define the transducer handle
Th = xdc_focused_multirow (no_elements,width,no_elements_y,height, ...
    kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);
% define the fractional bandwidth
fractionalBandwidth = 0.95;
centerFrequency = 10.6e6;
