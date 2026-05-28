classdef GCodeReaderMode < handle
    %both an enumeration of states and a factory of GCodeCommand

    enumeration
        undefined, linearReposition, linearOperation
    end

    methods (Static)
        function command = GetCommand(mode)
            arguments
                mode (1,1) GCodeReaderMode
            end

            switch mode
                case GCodeReaderMode.linearReposition
                    command = GCodeLinear;
                    command.targetPosition("S") = 0;
                case GCodeReaderMode.linearOperation
                    command = GCodeLinear;
                    command.targetPosition("S") = 1;
                otherwise
                    error(['Unsupported mode: ' char(string(mode))])
            end
        end
    end
end