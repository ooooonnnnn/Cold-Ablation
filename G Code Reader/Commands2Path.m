function [time, movements] = Commands2Path(deltaTime, commands, axisName, axisInitVal)
    %takes an array of GCodeCommand and returns position vectors for all
    %relevant axes (GCodeAxisName) and a time vector

    arguments
        deltaTime (1,1) double
        commands (1,:) GCodeCommand
    end

    arguments (Repeating)
        axisName (1,1) GCodeAxisName
        axisInitVal (1,1) double
    end

    axes = GCodeAxisName.empty;
    for name = axisName
        axes(length(axes) + 1) = name{1};
    end

    movements = dictionary(axes, axisInitVal);

    for command = commands
        %get last position
        lastPosDict = dictionary;
        for name = axes
            movement = cell2mat(movements(name));
            lastPosDict(name) = movement(end);
        end

        %get new move from command
        newMove = command.GetMovement(deltaTime, lastPosDict);
        affectedAxes = keys(newMove);
        numMovePoints = length(newMove(affectedAxes(1)));

        for axis = axes
            if isKey(newMove, axis)
                newPoints = newMove(axis);
            else
                newPoints = repelem(lastPosDict(axis), [numMovePoints, 1]);
            end

            movements(axis) = {[cell2mat(movements(axis)) , newPoints{1}]};
        end
    end

    %create time axis
    numTotalPoints = length(cell2mat(movements(axis)));
    time = 0:deltaTime:deltaTime * numTotalPoints;
end