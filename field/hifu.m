function [Th,impulseResponse]=hifu(FIELD_PARAMS);
% function [Th,impulseResponse]=hifu(FIELD_PARAMS);
%
% Create 'Th' transducer handle and define the impulse response for Mile's HIFU
% probe.  Sam provided this definition
% 
% Mark Palmeri
% mlp6@duke.edu
% 2013-07-31

disp('Transducer: HIFU');

R = 64/2/1000;
Rfocal = 63.2/1000;
ele_size = 1/1000;

Th = xdc_concave(R,Rfocal,ele_size);

% Get aperture info.
data = xdc_get(Th,'rect');

% Set mathematical element apodization to get annulus.
element_no = 1; % Only one element in the piston.
holeR = 38.1/2/1000; % Annulus radius.
apo = double(data(8,:).^2 + data(9,:).^2 > holeR^2); % set elements
                                                     % inside hole = 0.
ele_apodization(Th,element_no,apo);



% % Plot the aperture.
% data = xdc_get(Th,'rect');
% figure
% hold on
% for I=1:size(data,2)
% 	x = [data(11,I) data(20,I); data(14,I) data(17,I)]*1000;
% 	y = [data(12,I) data(21,I); data(15,I) data(18,I)]*1000;
% 	z = [data(13,I) data(22,I); data(16,I) data(19,I)]*1000;
% 	c = data(5,I)*ones(2,2);
% 	surf(x,y,z,c)
% end

% Hc = colorbar;
% view(3);
% xlabel('x (mm)');
% ylabel('y (mm)');
% zlabel('z (mm)');
% grid
% axis image
% hold off


% define the fractional bandwidth
fractionalBandwidth = 0.6;
centerFrequency = 1.1e6;

% compute and load the experimentally-measured impulse response
[impulseResponse]=defineImpResp(fractionalBandwidth,centerFrequency,FIELD_PARAMS);
