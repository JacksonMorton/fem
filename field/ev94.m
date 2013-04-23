function [Th,impulseResponse]=ev94(FIELD_PARAMS);
% function [Th,impulseResponse]=ev94(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% EV9-4 for use by dynaField.m; also define the impulse response
%
% Based on Liang's emailed parameters
%
% Mark 12/27/08

disp('Transducer: EV9-4');

kerf = 0.0162e-3;
pitch = 0.162e-3;
width = pitch - kerf;
height = 6*1e-3;

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
if(no_elements > 128),
    no_elements = 128;
end;

% lens focus
Rfocus=30.0e-3;
Rconvex=12.98/1000;

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=2*height/width;
no_sub_x=2;

% define the transducer handle
Th = xdc_convex_focused_array(no_elements,width,height,kerf,Rconvex,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 0.75;
centerFrequency = 6.5e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
