function [Th,fractionalBandwidth]=vf105(FIELD_PARAMS);
% function [Th,fractionalBandwidth]=vf105(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% VF10-5 for use by fieldprms3d_arfi.m
% 
% Mark 06/11/07

disp('Transducer: VF10-5 (GFP setup)');
no_elements_y=1;
width=.2e-3;
kerf=0.02e-3;
pitch = width + kerf;
height=5e-3;
% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
% lens focus
Rfocus=20e-3;
% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=1;
% define the transducer handle
Th = xdc_focused_multirow (no_elements,width,no_elements_y,height, ...
    kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);
% define the fractional bandwidth
% Gianmarco's is very broadband, so I will artifcially put
% it at 2.0
fractionalBandwidth = 2.0;
centerFrequency = X.XXe6;
