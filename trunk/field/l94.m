function [Th, impulseResponse]=l94(FIELD_PARAMS)
% function [Th,impulseResponse]=l94(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the fractional bandwidth for the
% 9L4.
% 
% Josh Doherty 11/05/10

% I had to call the probe 'l94' because matlab is mean

disp('Transducer: 9L4');
kerf = 25e-6;                 % Kerf width between elements [m]
pitch = 0.0201/100;           % Pitch bewteeen elements [m]
width = pitch-kerf;           % Element width [m]

% define # of elements based on F/#
no_elements=(FIELD_PARAMS.focus(3)/FIELD_PARAMS.Fnum)/pitch;
no_elements = floor(no_elements);

% Account for lens focus and number of active elements based on focal depth
if FIELD_PARAMS.focus(3) < 25/1000
    Rfocus = 20/1000;
    no_elements_y=1;
    heights = [4]/1000;   % Array element heights [m]
else
    Rfocus = 40/1000;
    no_elements_y=3;
    heights = [2.5,4,2.5]/1000;   % Array element heights [m]
end

% mathematically sub-dice elements to make them ~1 lambda dimensions
no_sub_x = 1;                       % Number of sub-divisions in x-direction
no_sub_y = max(heights)/width;      % Number of sub-divisions in y-direction

% define the transducer handle
Th = xdc_focused_multirow(no_elements,width,no_elements_y,heights,kerf,kerf,Rfocus,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% define the fractionalBandwidth and centerFrequency 
bandwidth = 3.6e6;      % From probe file (/common/electromechanical table)
centerFrequency = 6.5e6;    % From probe file (/bmode/bgain table)
fractionalBandwidth = bandwidth/centerFrequency;

% compute and load the impulse response
[impulseResponse] = defineImpResp(fractionalBandwidth, centerFrequency, FIELD_PARAMS);
