function [Th,impulseResponse]=l124(FIELD_PARAMS);
% function [Th,impulseResponse]=l124(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% 12L4 for use by dynaField.m; also define the impulse response
%
% Stephen 08/16/13

disp('Transducer: 12L4');

no_elements_y=1;
width=.232e-3;
kerf=0.035e-3;
pitch = width + kerf;
height=7e-3;

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
no_elements = min(no_elements, 192);

% lens focus
Rfocus=25.0e-3;

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=1;

% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 76.8;
centerFrequency = 7.12e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
