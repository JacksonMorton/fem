function [Th,impulseResponse] = big_low_freq_ele15mm(FIELD_PARAMS)
% function [Th,impulseResponse] = big_low_freq_ele15mm(FIELD_PARAMS)
% 
% Create 'Th' transducer handle and define the fractional bandwidth and impulse
% response for the big, low-freq array for use by dynaField.m.  These parameters came from
% parametersBigArray.m that Jeremy wrote.
%
% This is a modified version of big_low_freq.m that has 15 mm tall elements
% instead of 25 mm, and twice the pitch.
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-08-07

disp('Big, Low-Freq Array (15 mm ele)');

%%%%%%%%%%%%%%%%%%%
% DEFINE TRANSDUCER
%%%%%%%%%%%%%%%%%%%
no_elements_x = floor(192/2);
no_elements_y = 1;
kerf_x = 0.025e-3;
kerf_y = 0.025e-3;
pitch_x = 2*0.44e-3;
width = pitch_x - kerf_x;
pitch_y = 2.525e-3;
height = 1.5e-2;
no_sub_x = 5;
no_sub_y = 15

% ensure odd number of y subdivisions
if (mod(no_sub_y,2)==0 & no_sub_y>1)
	no_sub_y = no_sub_y + 1;
end
	
radius = 7e-2;                 % radius of curvature of aperture [m]
elevfoc = 15e-2;	       % lens focus
R_lens = 52.54e-3;             % Lens Radius of Curvature
lens_edge = .305e-3;           % lens edge thickness
lens_width_curv = 10.195e-3;   % width of curvature on lens

tx_el_x = min(round(FIELD_PARAMS.focus(3)/(pitch_x*FIELD_PARAMS.Fnum)),no_elements_x); % #tx elements
tx_el_y = no_elements_y;

% Create Transmitting Transducer
Th = xdc_convex_focused_array(tx_el_x,width,height,kerf_x,radius,elevfoc,no_sub_x,no_sub_y,FIELD_PARAMS.focus);

% compute the impulse response
centerFrequency = 1.75e6; 
fractionalBandwidth = 0.8;
[impulseResponse] = defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
