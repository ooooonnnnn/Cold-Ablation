%% Script Initialize
clear
channels = [1,2];

%% Setup device
% This should be done after setting a proxy
awg = MokuArbitraryWaveformGenerator('localhost:8090',  force_connect = true);
%% Create time axis
total_time = 1;
num_points = 1000;
num_reps = 1;

max_allowed_points = 65536;

time = linspace(0,total_time, num_points);

% calculate frequency
frequency = 1 / total_time;

% validate time axis
% if (numel(time) > time_config.max_samples || ...
%         total_time > time_config.max_time)
%     error(['Time vector too long, max: ' num2str(time_config.max_time) 's'])
% end

%% define functions
t = time / 10 / total_time;
vx = sin(100 * t * 2 * pi);
vy = sin(1.1 * 100 * t * 2 * pi);

%% heart shape
% t = time / total_time * 2 * pi;
% vx = -16*sin(t).^3;
% vy = -1 * (13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - 1*cos(4*t));

%% plot

figure(1);
tiledlayout('flow');

nexttile
plot(time, vx)
title("X voltage");

nexttile
plot(time, vy);
title("Y voltage");

nexttile([2,2])
plot(-vx,-vy)
title("shape");
%plot(time,v);

%% Load shapes
% sample rate out of {Auto, 125Ms, 62.5Ms, 31.25Ms}
sample_rate = 'Auto';
amplitude = 1;
awg.generate_waveform(1, sample_rate, vx, frequency, amplitude);
awg.generate_waveform(2, sample_rate, vy, frequency, amplitude);
awg.sync_phase();

%% trigger
for ch = channels
    awg.burst_modulate(ch, 'Manual', 'NCycle', 'burst_cycles', num_reps);
    awg.enable_output(ch, 'enable', true);
end

awg.manual_trigger;

%% stop

for ch = channels
    % awg.burst_modulate(ch, 'Manual', 'NCycle', 'burst_cycles', 1);
    awg.enable_output(ch, 'enable', false);
end

