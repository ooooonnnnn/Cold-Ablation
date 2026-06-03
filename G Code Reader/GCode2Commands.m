function commands = GCode2Commands(filepath)
    %reads a g code file in filepath and returns an array of GCodeCommand

    currentMode = GCodeReaderMode.undefined;
    currentFeedrate = 0;
    feedrateConvert = 1/60; %conversion from mm/min or inch/min to mm/sec
    commands = {};

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
        targetAxisValues = dictionary;

        for wordCell = words

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
                        case '2'
                            currentMode = GCodeReaderMode.arcCw;
                        case '3'
                            currentMode = GCodeReaderMode.arcCcw;
                        otherwise
                            currentMode = "undefined";
                    end
                case 'F'
                    currentFeedrate = str2double(value);
                otherwise
                    targetAxisValues(code) = str2double(value);
            end
        end

        %% validate parameters
        % can't use both i/j and r 
        ijrUsed = isKey(targetAxisValues, ["I", "J", "R"]);
        if any(ijrUsed(1:2)) && ijrUsed(3)
            error("GCode line can't specify both I/J and R")
        end

        %% create command
        
        try
            newCommand = GCodeReaderMode.GetCommand(currentMode);
        catch e
            warning(e.message)
            warning(['Skipped unknown command ' cleanLine])
            continue
        end

        newCommand.targetPosition(targetAxisValues.keys) = ...
            targetAxisValues(targetAxisValues.keys);
        newCommand.feedrate = currentFeedrate * feedrateConvert;

        commands = [commands {newCommand}];
    end
end