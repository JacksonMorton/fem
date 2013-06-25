%vl25_b simulation parameters
load vl25b.mat;
f0=2.5e6;                                   % center frequency

band=0.30;                                  % bandwidth of the transducer



no_ele_x_emit=35;
no_ele_y_emit=35;
no_ele_x_receive=35;
no_ele_y_receive=35;
width=300e-6;
height=300e-6;
kerf_x_emit=50e-6;
kerf_y_emit=50e-6;
no_sub_x=7 ;
no_sub_y=7;
focus=[0,0,7]/100;

%---------- begin Field simulation ---------------
field_init(-1);

impulse_response=1;
xdc_impulse(emit,impulse_response);
xdc_impulse(receive,impulse_response);


%set the excitation of the emit aperture
tc=gauspuls('cutoff',f0,band,[],-40);
t=-tc:1/fs:tc;
excitation=gauspuls(t,f0,band);
xdc_excitation(emit,excitation);

enabled_transmit = vl25b_tx;
enabled_receive = vl25b_rx;

emit=xdc_2d_array(no_ele_x_emit, no_ele_y_emit, width, height, kerf_x_emit, kerf_y_emit,...
                   enabled_transmit, no_sub_x, no_sub_y, focus);

receive=xdc_2d_array(no_ele_x_receive, no_ele_y_receive, width, height, kerf_x_emit, kerf_y_emit,...
                   enabled_receive, no_sub_x, no_sub_y, focus);