function [Th,impulseResponse] = big_low_freq(FIELD_PARAMS)
% function [Th,impulseResponse] = big_low_freq(FIELD_PARAMS)
% 
% Create 'Th' transducer handle and define the fractional bandwidth and impulse
% response for the big, low-freq array for use by dynaField.m.  These parameters came from
% parametersBigArray.m that Jeremy wrote.
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-07-26

disp('Big, Low-Freq Array');

%%%%%%%%%%%%%%%%%%%
% DEFINE TRANSDUCER
%%%%%%%%%%%%%%%%%%%
no_elements_x = 192;
no_elements_y = 1;
kerf_x = 0.025e-3;
kerf_y = 0.025e-3;
pitch_x = 0.44e-3;
width = pitch_x - kerf_x;
pitch_y = 2.525e-3;
height = 2.5e-2;
no_sub_x = 5;
no_sub_y = 25

% ensure odd number of y subdivisions
if (mod(no_sub_y,2)==0 & no_sub_y>1)
	no_sub_y = no_sub_y + 1;
end
	
radius = 7e-2;                 % radius of curvature of aperture [m]
elevfoc = 100e-2;	       % lens focus (effectively removed in this case)
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
