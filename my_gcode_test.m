clc
repo1 = GCodeReposition(1, [0.5, 0.5]);
repo2 = GCodeReposition(1, [0, 0]);
[time, movement] = Commands2Path(1e-1, [repo1 ,repo2], "x", -1, "y", 0);
movement("x")
movement("y")
%%
enums = enumeration(GCodeAxisName.x);
d = dictionary(enums(1), 0);

d([GCodeAxisName.x, GCodeAxisName.y])
