function lines = g1_z_to_g0(lines)
% G1_Z_TO_G0  Convert any G1 move that changes the Z axis into a G0.
%
%   LINES = g1_z_to_g0(LINES)
%
%   LINES is a cell array of strings (one G-code line per cell).
%   G1 lines that carry a Z word with a value different from the current
%   Z position are rewritten as G0.  All other lines are passed through
%   unchanged.
%
%   Example:
%     lines = read_nc('complex_pocket.nc');
%     lines = g1_z_to_g0(lines);

    current_z = NaN;

    for i = 1:numel(lines)
        line = strtrim(lines(i));

        if isempty(line) || isComment(line)
            continue
        end

        z_val = extractCoord(upper(line), 'Z');

        if startsWith(line, 'G1', 'IgnoreCase', true)
            if ~isnan(z_val) && (isnan(current_z) || z_val ~= current_z)
                lines(i) = regexprep(lines(i), 'G1 ', 'G0 ', 'ignorecase');
            end
        end

        % Update tracked Z for any motion command that carries a Z word
        if startsWith(line, {'G0','G1','G2','G3'}, 'IgnoreCase', true) && ~isnan(z_val)
            current_z = z_val;
        end
    end
end