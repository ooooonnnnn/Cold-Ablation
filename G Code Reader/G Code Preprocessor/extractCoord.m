function val = extractCoord(line, letter)
% EXTRACT_COORD  Extract the numeric value of an axis word from a G-code line.
%
%   VAL = extract_coord(LINE, LETTER)
%
%   Searches LINE (uppercase) for the axis word LETTER (e.g. 'X', 'Y', 'Z')
%   and returns its value as a double.  Returns NaN if LETTER is not present.
%
%   Example:
%     extract_coord('G1 X1.23 Y-4.5 Z0.1', 'Z')  % returns 0.1
%     extract_coord('G3 X1.0 Y2.0 I0.5 J0.5', 'Z') % returns NaN

    tok = regexp(line, [letter '([-+]?\d*\.?\d+)'], 'tokens', 'once');
    if isempty(tok)
        val = NaN;
    else
        val = str2double(tok{1});
    end
end