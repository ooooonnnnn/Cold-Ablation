%preprocessGCode('g codes files\complex pocket.nc');


%%

clear
clc
commands = GCode2Commands("g codes files\complex pocket_preprocessed.nc");
% commands = GCode2Commands("g codes files\cone 2mm 2mm_preprocessed.nc");
% commands = GCode2Commands("g codes files\complex pocket.nc");
[time, movements] = Commands2Path( ...
    1e-3, commands, ...
    "X", 0, "Y", 0, "Z", 0, "S", 0);

%%

x = cell2mat(movements("X"));
y = cell2mat(movements("Y"));
z = cell2mat(movements("Z"));
s = cell2mat(movements("S"));
%% draw path with and without laser

laserOn = s >= 0.5;
laserOff = ~laserOn;

figure(1)
clf
axes
hold on
plot3(x(laserOn), y(laserOn), z(laserOn), 'r.')

plot3(x(laserOff), y(laserOff), z(laserOff), 'k.')

%% run along the path
step = 10;

i = 1;
pointer = scatter3(x(i), y(i), z(i), ...
    'cyan', 'filled');
while i <= numel(x)
    i = i + step;
    pointer.XData = x(i);
    pointer.YData = y(i);
    pointer.ZData = z(i);
    pause
    drawnow
end