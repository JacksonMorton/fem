function [Th, impulseResponse] = p42(FIELD_PARAMS);
% Based on /nefs/dpb6/cardiac/Verasonics/MatlabSimulator/computeTrans.m
% (parameters)
%
% Based on Mark's ph41.m code 
%
% Ocean 09/14/2011

disp('Transducer: P4-2')
no_elements_y = 1;
width = .2950e-3; % meters
kerf =   0.02e-3 ; % guess (based on ph41.m)
pitch = width + kerf;
height = 13.5e-3; % guess (based on ph41.m) 

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);

% lens focus
Rfocus= 70.0e-1; % guess (based on ph41.m)

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_y=height/width;
no_sub_x=1;

% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,height,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 0.93; % guess (based on ph41.m)
centerFrequency = 2.5e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);


