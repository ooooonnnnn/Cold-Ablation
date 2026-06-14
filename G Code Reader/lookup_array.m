function values = lookup_array(dict, keys, fallback)
    arguments
        dict (1,1) dictionary
        keys (1,:)
        fallback (1,:) = [];
    end

    useFallback = ~isempty(fallback);

    if useFallback && length(fallback) ~= length(keys)
        error("number of fallbacks doesn't equal the number of keys")
    end

    values = [];
    for i = 1:length(keys)
        if useFallback
            values = [values lookup(dict, keys(i), FallbackValue=fallback(i))];
        else
            values = [values lookup(dict, keys(i))];
        end
    end
end