clear
clc
commands = GCode2Commands("g codes files\testGCode.txt");
[time, movements] = Commands2Path(1e-2, commands, "X", 0, "Y", 0, "S", 0);

x = cell2mat(movements("X"));
y = cell2mat(movements("Y"));
s = cell2mat(movements("S"));

%%

laserOn = s >= 0.5;
laserOff = ~laserOn;

figure(1)
clf
axes
hold on
plot(x(laserOn), y(laserOn), 'r.')

plot(x(laserOff), y(laserOff), 'k.')