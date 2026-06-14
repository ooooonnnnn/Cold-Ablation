classdef GCodeArc < GCodeCommand
    properties
        clockwise (1,1) logical = true;
    end

    properties (Constant)
        radiusTolerance = 0.1; 
        %mm. allowed difference between distances of start -> center and end -> center
    end

    methods
        function paths = GetMovement(obj, deltaTime, initialAxisPos)
            startPos = initialAxisPos(["X", "Y"]);

            % endPos = nan(size(startPos));
            % keys = ["X" ,"Y"];
            % keysExist = isKey(obj.targetPosition, keys);
            % endPos(keysExist) = obj.targetPosition(keys(keysExist));
            % endPos(isnan(endPos)) = startPos(isnan(endPos));

            endPos = lookup_array( ...
                obj.targetPosition, ["X", "Y"], startPos);

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

                angles = angles(isMinorArc == isDesiredMinArc, :);
                center = center(isMinorArc == isDesiredMinArc, :);
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
            pivot1 = startPos;
            pivot2 = [nan nan];
            desiredPivot = pivot1;
            radius = nan;

            middle = (startPos + endPos)/2;
            start2end = norm(startPos - endPos);
            perpendicularDir = [startPos(2) - endPos(2), ...
                    endPos(1) - startPos(1)]/start2end;
            
            keys = ["I", "J"];
            if any(isKey(obj.targetPosition, keys))
                
                keysExist = isKey(obj.targetPosition, keys);

                desiredPivot(keysExist) = desiredPivot(keysExist) ...
                    + obj.targetPosition(keys(keysExist));

                %% check pivot point distances
                start2center = norm(startPos - desiredPivot);
                end2center = norm(endPos - desiredPivot);
                if abs(end2center - start2center) > obj.radiusTolerance
                    global COMMAND_NUM;
                    error("Pivot point has different distances from start and end points");
                end
                
                %% find ideal pivot point
                % closest point to the original pivot point, that lies on
                % the mid line between the start and end points
                pivot1 = middle...
                    + (desiredPivot - middle) * (perpendicularDir')...
                    * perpendicularDir;
                pivot2 = pivot1;

                radius = norm(startPos - pivot1);

            else
                radius = abs(obj.targetPosition("R"));
                
                if start2end / 2 > radius + obj.radiusTolerance
                    error("radius too small for arc movement")
                end
                radius = max([radius, start2end / 2]);
                
                height = sqrt(radius^2 - (start2end^2)/4);

                pivot1 = middle + height * perpendicularDir;
                pivot2 = middle - height * perpendicularDir;
            end

            center = [pivot1; pivot2];
        end
    end
end