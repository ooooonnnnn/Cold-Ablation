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
    axis_names = {'X', 'Y', 'Z'};

    keep = true(size(lines));

    i = 1;
    while i <= numel(lines)
        if ~isG0(strtrim(lines(i)))
            i = i + 1;
            continue
        end

        coords = [nan nan nan];
        coords(1) = extractCoord(lines(i), 'X');
        coords(2) = extractCoord(lines(i), 'Y');
        coords(3) = extractCoord(lines(i), 'Z');
        run_start = i;
        run_end   = i;
        j = i + 1;
        while j <= numel(lines) && isG0(strtrim(lines(j)))
            for ax = 1:numel(axis_names)
                coord_value = extractCoord(lines(j), axis_names{ax});
                if ~isnan(coord_value)
                    coords(ax) = coord_value;
                end
            end
            run_end = j;
            j = j + 1;
        end

        if run_end == run_start
            i = i + 1;
            continue
        end

        last_line = ['G0 '];
        if ~isnan(coords(1)) 
            last_line = [last_line 'X' num2str(coords(1)) ' ']; end
        if ~isnan(coords(2)) 
            last_line = [last_line 'Y' num2str(coords(2)) ' ']; end
        if ~isnan(coords(3)) 
            last_line = [last_line 'Z' num2str(coords(3)) ' ']; end

        lines(run_end) = string(last_line);

        keep(run_start : run_end - 1) = false;

        i = run_end + 1;

        % if isG0(strtrim(lines(i)))
        %     run_start = i;
        %     run_end   = i;
        %     j = i + 1;
        %     while j <= numel(lines) && isG0(strtrim(lines(j)))
        %         run_end = j;
        %         j = j + 1;
        %     end
        % 
        %     % Suppress every line in the run except the last
        %     if run_end > run_start
        %         keep(run_start : run_end - 1) = false;
        %     end
        % 
        %     i = run_end + 1;
        % else
        %     i = i + 1;
        % end
    end

    lines = lines(keep);
end