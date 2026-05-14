classdef MokuControl < handle
    properties (SetAccess = private)
        % device
        awg (1,1) %MokuArbitraryWaveformGenerator

        % waveform
        valuesX double
        valuesY double
        amplitudeX (1,1) double
        amplitudeY (1,1) double
        offsetX (1,1) double
        offsetY (1,1) double
        frequency (1,1) double
    end

    properties(Constant)
        max_allowed_points = 65536;
        sample_rate = 'Auto';
        channels = [1,2];
        max_allowed_voltage = 5;
    end

    methods
        function obj = MokuControl()
            % connect to device
            % This should be done after setting a proxy
            obj.awg = MokuArbitraryWaveformGenerator('localhost:8090',  ...
                force_connect = true);

            %setup single shot mode
            for ch = obj.channels
                obj.awg.burst_modulate(ch, 'Manual', 'NCycle', ...
                    'burst_cycles', 1);
            end
        end

        function obj = set_path(obj, path_xyz)
            path = path_xyz(:,1:2);
            path = path(1: min([obj.max_allowed_points length(path(:,1))]), ...
                :);
            
            % get amplitude and offset (Moku normalized the signal to -1:1
            % before reapplying them)
            
            min_val = min(path, [], 1);
            max_val = max(path, [], 1);

            if (any(min_val < -obj.max_allowed_voltage))
                error(['min value of voltage in one axis is too large: ' ...
                    num2str(min_val) ' < ' num2str(-obj.max_allowed_voltage)])
            end

            if (any(max_val > obj.max_allowed_voltage))
                error(['max value of voltage in one axis is too large: ' ...
                    num2str(max_val) ' > ' num2str(obj.max_allowed_voltage)])
            end

            mid_val = (min_val + max_val)/2;
            amplitude = max_val - min_val;

            obj.amplitudeX = amplitude(1);
            obj.amplitudeY = amplitude(2);
            obj.offsetX = mid_val(1);
            obj.offsetY = mid_val(2);

            % set values
            obj.valuesX = path(:,1);
            obj.valuesY = path(:,2);
        end

        function obj = load_waveform_to_device(obj)
            
            obj.awg.generate_waveform( ...
                1, ...
                obj.sample_rate, ...
                obj.valuesX, ...
                obj.frequency, ...
                obj.amplitudeX, ...
                'offset', obj.offsetX);

            obj.awg.generate_waveform( ...
                2, ...
                obj.sample_rate, ...
                obj.valuesY, ...
                obj.frequency, ...
                obj.amplitudeY, ...
                'offset', obj.offsetY);

            obj.awg.sync_phase();
        end

        function obj = set_time(obj, total_time)
            obj.frequency = 1/total_time;
        end

        function obj = trigger(obj)
            obj.awg.manual_trigger;
        end
    end
end