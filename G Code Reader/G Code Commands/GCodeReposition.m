classdef GCodeReposition < GCodeCommand
    properties
        targetPosition (1,2) double
        speed (1,1) double
    end


    methods
        function obj = GCodeReposition(speed, targetPosition)
            obj.speed = speed;
            obj.targetPosition = targetPosition;
        end

        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            lastPosition = initialAxisPos([GCodeAxisName.x, GCodeAxisName.y]);

            % lastPosition = obj.GetValuesFromNameValuePairs( ...
            %     [GCodeAxisName.x, GCodeAxisName.y], initialAxisPos);

            distance = sqrt((obj.targetPosition - lastPosition).^2);
            time = deltaTime:deltaTime:(distance / obj.speed);
            numPoints = length(time);

            x = linspace(lastPosition(1), obj.targetPosition(1), numPoints);
            y = linspace(lastPosition(2), obj.targetPosition(2), numPoints);
            x = x(2:end);
            y = y(2:end);

            paths = dictionary(GCodeAxisName.x, {x}, GCodeAxisName.y, {y});
        end
    end
end