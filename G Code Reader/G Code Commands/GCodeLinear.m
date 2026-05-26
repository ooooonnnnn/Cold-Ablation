classdef GCodeLinear < GCodeCommand
    methods
        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            %get start position
            startPosition = initialAxisPos([GCodeAxisName.x, GCodeAxisName.y]);

            %get end position
            endPosition = [nan, nan];
            if isKey(obj.targetPosition, "x")
                endPosition(1) = obj.targetPosition("x");
            end
            if isKey(obj.targetPosition, "y")
                endPosition(2) = obj.targetPosition("y");
            end
            
            nanInds = isnan(endPosition);
            endPosition(nanInds) = startPosition(nanInds);
            
            %calculate time
            distance = norm(endPosition - startPosition);
            time = deltaTime:deltaTime:(distance / obj.feedrate);
            numPoints = length(time);

            %calculate points
            x = linspace(startPosition(1), endPosition(1), numPoints);
            y = linspace(startPosition(2), endPosition(2), numPoints);
            s = linspace(obj.targetPosition("s"), obj.targetPosition("s"), numPoints);
            x = x(2:end);
            y = y(2:end);
            s = s(2:end);

            %return path
            paths = dictionary(GCodeAxisName.x, {x}, ...
                GCodeAxisName.y, {y}, ...
                GCodeAxisName.s, {s});
        end
    end
end