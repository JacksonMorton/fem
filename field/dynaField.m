function [intensity,FIELD_PARAMS] = dynaField(FIELD_PARAMS, numWorkers)
% allocate number of workers
currentWorkers = matlabpool('size');
isPoolOpen = (currentWorkers > 0);
if (isPoolOpen)
    matlabpool close;
end

maximumNumWorkers = feature('numCores'));

if (nargin == 2)
    if (numWorkers <= maximumNumWorkers)
        matlabpool('open', numWorkers);
    else
        error('Invalid number of workers. Maximum is %i.', maximumNumWorkers)
    end
else
    matlabpool('open', maximumNumWorkers);
end

% set attenuation
Freq_att=FIELD_PARAMS.alpha*100/1e6; % FIELD_PARAMS in dB/cm/MHz
att_f0=exciteFreq;
att=Freq_att*att_f0; % set non freq. dep. to be centered here
set_field('att',att);
set_field('Freq_att',Freq_att);
set_field('att_f0',att_f0);
set_field('use_att',1);
 
% compute Ispta at each location for a single tx pulse
% optimizing by computing only relevant nodes... will assume others are zero
StartTime = fix(clock);
% disp(sprintf('Start Time: %i:%2.0i',StartTime(4),StartTime(5)));
Time = datestr(StartTime, 'HH:MM:SS PM');
disp(sprintf('Start Time: %s', Time))
tic;

spmd
    % separate the matrices such that each core gets a roughly equal number
    % of measurement points to perform calculations on.
    % also, distributes matrices based on columns, rather than rows.
    codistPoints = codistributed(FIELD_PARAMS.measurementPoints, codistributor('1d', 1));
    pointsSize = size(FIELD_PARAMS.measurementPoints);
    
    
    FIELD_PARAMS.measurementPoints = getLocalPart(codistPoints);
    [intensityCodist,FIELD_PARAMS]=dynaField(FIELD_PARAMS);
    
    % combine all the separate matrices again.
    intensityDist = codistributed.build(intensityCodist, codistributor1d(2, codistributor1d.unsetPartition, [1 pointsSize(1)]));
end
intensity = gather(intensityDist);
matlabpool close
