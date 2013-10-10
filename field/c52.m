function [Th,impulseResponse]=c52(FIELD_PARAMS);
% function [Th,impulseResponse]=c52(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the C52
% for use by dynaField.m; also define the impulse response
%
% Mark 2013-10-10


disp('Transducer: C52');

kerf=0.001e-3;
pitch = 0.4e-3;
width = pitch - kerf;
height=15.75e-3;

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);
if(no_elements > 128),
    no_elements = 128;
end;

% lens focus
Rfocus=83.0e-3;
Rconvex=38.7/1000;

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=2*height/width;
no_sub_x=2;

% define the transducer handle
Th = xdc_convex_focused_array(no_elements,width,height,kerf,Rconvex,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 0.7;
centerFrequency = 3.0e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
