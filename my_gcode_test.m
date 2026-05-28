clear
mode = GCodeReaderMode.linearReposition;
cm1 = mode.GetCommand(GCodeReaderMode.linearReposition);
cm2 = mode.GetCommand(GCodeReaderMode.linearOperation);

%%
cm2.feedrate = 60e3;
cm2.targetPosition(["x", "y"]) = [1000, 1000];
cm2.GetMovement(1e-3, ...
    dictionary("x", 0, "y", 0));
