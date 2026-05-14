classdef TimeData < handle
    properties
        sample_rate_name (1,1) string
        sample_rate (1,1) double
        max_samples (1,1) int32
    end

    methods
        function obj = TimeData(sr_name, sr, n_samples)
            arguments
                sr_name (1,1) string
                sr (1,1) double
                n_samples (1,1) int32
            end

            obj.sample_rate_name = sr_name;
            obj.sample_rate = sr;
            obj.max_samples = n_samples;
        end

        function min_d = delta_time(obj)
            min_d = 1 / obj.sample_rate;
        end

        function max_t = max_time(obj)
            max_t = obj.delta_time * double(obj.max_samples);
        end
    end
end