%% Script Initialize
channels = [1,2];

%% Setup device
% This should be done after setting a proxy
awg = MokuArbitraryWaveformGenerator('localhost:8090',  force_connect = true);

% burst modulation: this gives one-shot waves
for ch = channels
    awg.burst_modulate(ch, 'Manual', 'Start');
end

%% Test Command
%create waveform
t = linspace(0,0.2e-3);
v = sin(t * 2 * pi * 1e6);

figure(1);
plot(t,v);

channel = 1;
sample_rate = 'Auto';
lut_data = v;
frequency = 1;
amplitude = 1;
awg.generate_waveform(channel, sample_rate, lut_data, frequency, amplitude)

awg.manual_trigger;