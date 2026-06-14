function lines = collapseG0s(lines)
% COLLAPSE_G0S  Replace each run of consecutive G0 lines with its last line.
%
%   LINES = collapse_g0s(LINES)
%
%   LINES is an array of strings (one G-code line per cell).
%   When two or more G0 rapid-move lines appear back-to-back, only the
%   final one (the actual destination) is kept; the earlier ones are
%   removed.  Comments, blank lines, and all other commands break a run
%   and are always preserved.
%
%   Example:
%     lines = read_nc('complex_pocket.nc');
%     lines = collapse_g0s(lines);

    keep = true(size(lines));

    i = 1;
    while i <= numel(lines)
        if isG0(strtrim(lines(i)))
            run_start = i;
            run_end   = i;
            j = i + 1;
            while j <= numel(lines) && isG0(strtrim(lines(j)))
                run_end = j;
                j = j + 1;
            end

            % Suppress every line in the run except the last
            if run_end > run_start
                keep(run_start : run_end - 1) = false;
            end

            i = run_end + 1;
        else
            i = i + 1;
        end
    end

    lines = lines(keep);
end