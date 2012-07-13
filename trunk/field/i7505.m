function [Th,fractionalBandwidth,centerFrequency]=i7505(FIELD_PARAMS);
% function [Th,fractionalBandwidth,centerFrequency]=i7505(FIELD_PARAMS);
%
% Mark Palmeri (mlp6)
% 2011-10-26

disp('Transducer: I7505');
no_elements_y=1;
width=0.2e-3; % not sure of this
kerf=0.02e-3;
pitch = width + kerf;
height=12.0e-3; % not sure of this
% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
% lens focus
Rfocus=10e-2; % no lens on this probe, so I'll put the elevation focus deep
% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=floor(height/width);
no_sub_x=1;
% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);
% define the fractional bandwidth
fractionalBandwidth = 0.5;
centerFrequency = 5.0e6; % this is a guess
