%% Script Initialize
clear
channels = [1,2];

%% Setup device
% This should be done after setting a proxy
awg = MokuArbitraryWaveformGenerator('localhost:8090',  force_connect = true);

%% burst modulation: this gives one-shot waves
for ch = channels
    awg.burst_modulate(ch, 'Manual', 'NCycle', 'burst_cycles', 100);
    % awg.set_output_termination(ch, 'HiZ');
end

%% Define data
% time_settings = [
% TimeData("31.25Ms", 31.25e6, 65536)
% ];

%%%%%%%%%% Test Command
%% Create time axis
time_config = time_settings(1);
total_time = 1;

% time = 0:time_config.delta_time:total_time;
time = linspace(0,1);

% validate time axis
% if (numel(time) > time_config.max_samples || ...
%         total_time > time_config.max_time)
%     error(['Time vector too long, max: ' num2str(time_config.max_time) 's'])
% end

v1 = sin(time * 2 * pi);
v2 = cos(time * 2 * pi);

% figure(1);
%plot(time,v);

% sample rate out of {Auto, 125Ms, 62.5Ms, 31.25Ms}
sample_rate = 'Auto';
lut_data = v1;
frequency = 1e0;
amplitude = 1;
awg.generate_waveform(1, sample_rate, v1, frequency, amplitude);
awg.generate_waveform(2, sample_rate, v2, frequency*1.1, amplitude);

%% trigger
for ch = channels
    % awg.burst_modulate(ch, 'Manual', 'NCycle', 'burst_cycles', 100);
    awg.enable_output(ch, 'enable', true);
end

awg.manual_trigger;

%% stop

for ch = channels
    % awg.burst_modulate(ch, 'Manual', 'NCycle', 'burst_cycles', 1);
    awg.enable_output(ch, 'enable', false);
end

