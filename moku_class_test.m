%% set up device
moku_control = MokuControl();

%% get g code path
tool_path = gCodeReader("g codes/simplePart.NC", 0.1, 0.1, 1, 0);

%% set path in moku
moku_control.set_path(tool_path / 6 / 10);
moku_control.set_time(5);
moku_control.load_waveform_to_device();

%% trigger
moku_control.trigger();