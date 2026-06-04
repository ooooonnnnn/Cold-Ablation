classdef GCodeReaderMode < handle
    %both an enumeration of states and a factory of GCodeCommand

    enumeration
        undefined, 
        linearReposition, linearOperation,
        arcCw, arcCcw
    end

    methods (Static)
        function command = GetCommand(mode)
            arguments
                mode (1,1) GCodeReaderMode
            end

            switch mode
                case GCodeReaderMode.linearReposition
                    command = GCodeLinear;
                    
                case GCodeReaderMode.linearOperation
                    command = GCodeLinear;
                    
                case {GCodeReaderMode.arcCw,...
                        GCodeReaderMode.arcCcw}
                    command = GCodeArc;
                    command.clockwise = mode == GCodeReaderMode.arcCw;
                    
                otherwise
                    error(['Unsupported mode: ' char(string(mode))])
            end

            if mode == GCodeReaderMode.linearReposition
                command.targetPosition("S") = 0;
            else
                command.targetPosition("S") = 1;
            end

        end
    end
end