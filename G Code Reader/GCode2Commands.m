function commands = GCode2Commands(filepath)
    %reads a g code file in filepath and returns an array of GCodeCommand

    

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
        firstWord = words{1};
        switch
    end
end