function result = isG0(line)
% ISG0  Return true if LINE is a G0 rapid-move command.
%
%   RESULT = isG0(LINE)
%
%   LINE should already be trimmed of leading/trailing whitespace.
%   Returns false for comments (lines starting with ';') and blank lines.

    if isempty(line) || line(1) == ';'
        result = false;
        return
    end
    result = ~isempty(regexpi(line, '^G0(\s|$)', 'once'));
end