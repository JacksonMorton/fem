function [Th,impulseResponse]=drug_piston(FIELD_PARAMS);
% function [Th,impulseResponse]=drug_piston(FIELD_PARAMS);
%
% create 'Th' transducer handle and define the fractional bandwidth for the
% drug delivery piston (NIH) for use by dynaField.m; also define the impulse
% response
%
% Mark 06/20/07

disp('Transducer: Drug Delivery Piston (NIH)');

% piston focus and radius
focus=40.0e-3;
radius=25.0e-3;

% mathematical element size
ele_size=1.0e-3;

% define the transducer handle
Th = xdc_concave(radius,focus,ele_size);

% define the fractional bandwidth & center frequency 
fractionalBandwidth = 1.0;
centerFrequency = 1.0e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
