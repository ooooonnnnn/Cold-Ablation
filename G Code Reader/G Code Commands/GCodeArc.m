classdef GCodeArc < GCodeCommand
    properties
        clockwise (1,1) logical = true;
    end

    methods
        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            startPos = initialAxisPos(["X", "Y"]);

            endPos = nan(size(startPos));
            keys = ["X" ,"Y"];
            keysExist = isKey(obj.targetPosition, keys);
            endPos(keysExist) = obj.targetPosition(keys(keysExist));
            endPos(isnan(endPos)) = startPos(isnan(endPos));

            [radius, center] = obj.CalculateCenterRadius( ...
                startPos, endPos);

            % order angles according to arc direction
            angles = [angle2d(startPos - center(1,:)), angle2d(endPos - center(1,:));
                      angle2d(startPos - center(2,:)), angle2d(endPos - center(2,:))];
            
            for i = 1:2
                if obj.clockwise && (angles(i,2) > angles(i,1))
                    angles(i,2) = angles(i,2) - 2*pi;
                elseif ~obj.clockwise && (angles(i,2) < angles(i,1))
                    angles(i,2) = angles(i,2) + 2*pi;
                end
            end

            isMinorArc = abs(angles(:,2) - angles(:,1)) <= pi;

            % identify minor and major arcs
            if isKey(obj.targetPosition, "R")
                isDesiredMinArc = sign(obj.targetPosition("R")) > 0;

                angles = angles(isMinorArc & isDesiredMinArc, :);
                center = center(isMinorArc & isDesiredMinArc, :);
            end
            angles = angles(1,:);
            center = center(1,:);
            
            angleDelta = abs(diff(angles));
            angularVel = obj.feedrate / radius;
            time = deltaTime:deltaTime:angleDelta/angularVel;
            numPoints = length(time);
            movementAngles = linspace(angles(1), angles(2), numPoints);
            
            x = center(1) + radius*cos(movementAngles);
            y = center(2) + radius*sin(movementAngles);
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

    methods (Access = private)
        function [radius, center] = CalculateCenterRadius(obj, startPos, endPos)
            center1 = startPos;
            center2 = [nan nan];
            radius = nan;
            
            keys = ["I", "J"];
            if any(isKey(obj.targetPosition, keys))
                
                keysExist = isKey(obj.targetPosition, keys);

                center1(keysExist) = center1(keysExist) ...
                    + obj.targetPosition(keys(keysExist));
                center2 = center1;

                radius = norm(startPos - center1);

            else
                radius = abs(obj.targetPosition("R"));
                start2end = norm(startPos - endPos);
                if start2end > radius*2
                    error("radius too small for arc movement")
                end
                middle = (startPos + endPos)/2;
                height = sqrt(radius^2 - (start2end^2)/4);
                perpendicularDir = [startPos(2) - endPos(2), ...
                    endPos(1) - startPos(1)]/start2end;

                center1 = middle + height * perpendicularDir;
                center2 = middle - height * perpendicularDir;
            end

            center = [center1; center2];
        end
    end
end