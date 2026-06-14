%isequal(GCodeReaderMode.undefined, GCodeReaderMode.arcCcw)

%%

clear
clc
commands = GCode2Commands("g codes files\complex pocket.nc");
[time, movements] = Commands2Path( ...
    1e-3, commands, ...
    "X", 0, "Y", 0, "Z", 0, "S", 0);

%%

x = cell2mat(movements("X"));
y = cell2mat(movements("Y"));
z = cell2mat(movements("Z"));
s = cell2mat(movements("S"));
%%

laserOn = s >= 0.5;
laserOff = ~laserOn;

figure(1)
clf
axes
hold on
plot3(x(laserOn), y(laserOn), z(laserOn), 'r.')

plot3(x(laserOff), y(laserOff), z(laserOff), 'k.')

