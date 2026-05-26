classdef GCodeReaderMode < handle
    %both an enumeration of states and a factory of GCodeCommand

    enumeration
        linearReposition, linearOperation
    end

    methods
        function command = GetCommand(obj, mode)
            arguments
                obj 
                mode (1,1) GCodeReaderMode
            end

            switch mode
                case GCodeReaderMode.linearReposition
                    command = GCodeLinear;
                    command.targetPosition("s") = 0;
                case GCodeReaderMode.linearOperation
                    command = GCodeLinear;
                    command.targetPosition("s") = 1;
                otherwise
                    error(['Unsupported mode: ' string(mode)])
            end
        end
    end
end