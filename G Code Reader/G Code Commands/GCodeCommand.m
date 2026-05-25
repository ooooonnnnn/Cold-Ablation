classdef (Abstract) GCodeCommand < handle
    %base class for G Code Commands

    methods (Abstract)
        varargout = GetMovement(obj, deltaTime, varargin);
        %{time, <GCodeAxisName, values>, ...} = GetMovement(obj, deltaTime, <GCodeAxisName, initialValue>, ...)
        %deltaTime: time resolution
        %
        %returns vectors that describe the movement: a list of pairs of 
        % GCodeAxisName and numeric vectors, for example: GCodeAxisName.x, 
        % x, GCodeAxisName.y, y
    end

    methods (Access = protected)
        function initVals = GetValuesFromNameValuePairs(obj, axisNames, varargin)
            
            initVals = [];
            
            for name = axisNames
                found = false;
                for i = 1:length(varargin)
                    if varargin{i} == name
                        found = true;
                        initVals(length(initVals) + 1) = varargin{i+1};
                    end
                    if found
                        break
                    end
                end

                if ~found
                    error("g code command was not given the required initial axis values")
                end
            end
        end
    end

end