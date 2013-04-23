function [Th,impulseResponse]=ch62(FIELD_PARAMS);
% function [Th,impulseResponse]=ch62(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% CH6-2 for use by dynaField.m; also define the impulse response
%
% Based on Kristin's code (parameters)
%
% Mark 02/27/08

disp('Transducer: CH6-2');

kerf = 0.004e-3;
pitch = 0.314e-3;
width = pitch - kerf;
height = 12e-3;

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
if(no_elements > 192)
    no_elements = 192;
end

% lens focus
Rfocus=69e-3;
Rconvex=42/1000; %6.178/100

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=2*(height/width);
no_sub_x=2;

% define the transducer handle
Th = xdc_convex_focused_array(no_elements, width, height, ...
    kerf, Rconvex,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

fractionalBandwidth = 3/4.4;
centerFrequency = 4.44e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
