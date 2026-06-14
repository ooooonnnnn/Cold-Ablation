function preprocessGCode(filepath)
    lines = readlines(filepath);

    %% change Z axis G1's to G0's
    

    %% collapse consecutive G0's
    lines = collapseG0s(lines);

    %% create new file
    [location, name, extention] = fileparts(filepath);
    new_filepath = [char(location) '/' char(name) '_preprocessed' char(extention)];
    writelines(lines, new_filepath);
end