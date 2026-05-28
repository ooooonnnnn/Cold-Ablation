function commands = GCode2Commands(filepath)
    %reads a g code file in filepath and returns an array of GCodeCommand

    currentMode = GCodeReaderMode.undefined;
    currentFeedrate = 0;
    commands = [];

    raw_gcode_file = fopen(filepath);

    while ~feof(raw_gcode_file)
        currentLine = fgetl(raw_gcode_file);
        
        % skip non-command lines
        if currentLine(1) == "%" || currentLine(1) == ":"
            continue
        end
        
        %% remove comments
        %remove () comments
        cleanLine = regexprep(currentLine, '\([^)]*\)', '');
        %remove ; comments
        cleanLine = regexprep(cleanLine, ';.*', '');
        %trim
        cleanLine = strtrim(cleanLine);
        %replace double whitespace with single 
        cleanLine = regexprep(cleanLine, '\s+', ' ');

        %skip empty line
        if isempty(cleanLine)
            continue
        end

        %%
        words = strsplit(cleanLine, ' ');

        for wordCell = words
            targetAxisValues = dictionary;

            word = wordCell{1};
            code = word(1);
            value = word(2:end);

            switch code
                case 'N'
                    continue
                case 'G'
                    switch value
                        case '0'
                            currentMode = GCodeReaderMode.linearReposition;
                        case '1'
                            currentMode = GCodeReaderMode.linearOperation;
                        otherwise
                            currentMode = "undefined";
                    end
                case 'F'
                    currentFeedrate = str2double(value);
                otherwise
                    targetAxisValues(code) = str2double(value);
            end

            try
                newCommand = GCodeReaderMode.GetCommand(currentMode);
            catch e
                continue
            end

            newCommand.targetPosition = targetAxisValues;
            newCommand.feedrate = currentFeedrate;

            commands = [commands newCommand];
        end
    end
end