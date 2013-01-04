function [Th,impulseResponse]=er7bl(FIELD_PARAMS);
% function [Th,impulseResponse]=er7bl(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% Longitudinal array of the ER7B for use by dynaField.m; also define the impulse response
%
% Stephen 12/13/12

disp('Transducer: ER7BL');

no_elements_y=1;
width=.4e-3;
kerf=0.03e-3;
pitch = width + kerf;
height=5e-3;

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);

% lens focus
Rfocus=30.0e-3;

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=1;

% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 1.04;
centerFrequency = 5.16e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
