function is = isComment(line)
arguments
    line (1,:) char
end

if isempty(line)
    is = true;
    warning("Checked if empty line is comment, returned true")
    return
end

is = any(strcmp(line(1), {';', ':', '%'}));
end