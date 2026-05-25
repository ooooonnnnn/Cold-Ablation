classdef (Abstract) GCodeCommand < handle
    %base class for G Code Commands

    methods (Abstract)
        movement = GetMovement(obj, deltaTime, initialAxisPos);
        %dictionary<GCodeAxisName, values> = GetMovement(obj, deltaTime, dictionary<GCodeAxisName, initialValue>)
        %deltaTime: time resolution
        %
        %returns vectors that describe the movement: a dictionary of 
        % GCodeAxisName and numeric vectors, for example: GCodeAxisName.x -> 
        % x, GCodeAxisName.y -> y
    end
end