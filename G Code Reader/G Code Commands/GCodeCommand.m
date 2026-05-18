classdef (Abstract) GCodeCommand < handle
    %base class for G Code Commands

    methods (Abstract)
        varargout = GetMovement(obj, lastPosition, deltaTime);
        %returns vectors that describe the movement: a list of pairs of 
        % GCodeAxisName and numeric vectors, for example: GCodeAxisName.x, 
        % x, GCodeAxisName.y, y
    end

end