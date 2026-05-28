classdef GCodeLinear < GCodeCommand
    methods
        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            %get start position
            startPosition = initialAxisPos([GCodeAxisName.X, GCodeAxisName.Y]);

            %get end position
            endPosition = [nan, nan];
            if isKey(obj.targetPosition, "X")
                endPosition(1) = obj.targetPosition("X");
            end
            if isKey(obj.targetPosition, "Y")
                endPosition(2) = obj.targetPosition("Y");
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
            s = linspace(obj.targetPosition("S"), obj.targetPosition("S"), numPoints);
            x = x(2:end);
            y = y(2:end);
            s = s(2:end);

            %return path
            paths = dictionary(GCodeAxisName.X, {x}, ...
                GCodeAxisName.Y, {y}, ...
                GCodeAxisName.S, {s});
        end
    end
end