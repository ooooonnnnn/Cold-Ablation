classdef GCodeLinear < GCodeCommand
    methods
        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            %get start position
            startPosition = initialAxisPos( ...
                [GCodeAxisName.X, GCodeAxisName.Y, GCodeAxisName.Z]);

            endPosition = lookup_array( ...
                obj.targetPosition, ["X", "Y" ,"Z"], startPosition);
            %calculate time
            distance = norm(endPosition - startPosition);
            time = deltaTime:deltaTime:(distance / obj.feedrate);
            numPoints = length(time);

            %calculate points
            x = linspace(startPosition(1), endPosition(1), numPoints);
            y = linspace(startPosition(2), endPosition(2), numPoints);
            z = linspace(startPosition(3), endPosition(3), numPoints);
            s = linspace(obj.targetPosition("S"), obj.targetPosition("S"), numPoints);

            x = x(2:end);
            y = y(2:end);
            z = z(2:end);
            s = s(2:end);

            %return path
            paths = dictionary(GCodeAxisName.X, {x}, ...
                GCodeAxisName.Y, {y}, ...
                "Z", {z}, ...
                GCodeAxisName.S, {s});
        end
    end
end