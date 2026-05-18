classdef GCodeReposition < GCodeCommand
    properties
        targetPosition (1,2) double
        speed (1,1) double
    end


    methods
        function varargout = GetMovement(obj, lastPosition, deltaTime)
            distance = sqrt((obj.targetPosition - lastPosition).^2);
            time = 0:deltaTime:(distance / obj.speed);
            numPoints = length(time);

            x = linspace(lastPosition(1), obj.targetPosition(1), numPoints);
            y = linspace(lastPosition(2), obj.targetPosition(2), numPoints);

            varargout = {GCodeAxisName.x, x, GCodeAxisName.y, y};
        end
    end
end