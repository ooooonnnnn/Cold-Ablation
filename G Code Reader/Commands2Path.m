function varargout = Commands2Path(commands)
    %takes an array of GCodeCommand and returns position vectors for all
    %relevant axes (GCodeAxisName) and a time vector

    arguments
        commands (1,:) GCodeCommand
    end

    commands(1).GetMovement()
end