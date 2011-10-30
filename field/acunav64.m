function [Th,fractionalBandwidth,centerFrequency]=acunav64(FIELD_PARAMS);
% function [Th,fractionalBandwidth,centerFrequency]=acunav64(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the 64
% element AcuNav for use by fieldprms3d_arfi.m
%
% Mark 08/25/09

disp('Transducer: AcuNav (64 element)');
no_elements_y=1;
width=0.09e-3;
kerf=0.02e-3;
pitch = width + kerf;
height=2.5e-3;
% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
if(no_elements > 64),
    warning('The physical dimenions of this probe have been exceeded.');
end;
% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=1;
% this probe does not have a lens on it, so I'm setting Rfocus to be 10 cm
Rfocus = 0.1; % m
% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);
% define the fractional bandwidth
fractionalBandwidth = 0.5;
centerFrequency = 6.0e6;
