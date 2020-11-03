classdef IntegerDelay < matlab.System

    properties
        N = 1
    end

    % Public, non-tunable properties
    properties(Nontunable)
        InitialOutput = 0
    end

    properties(DiscreteState)
        Buffer
    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods
        % Constructor
        function obj = IntegerDelay(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj, ~)
            % Perform one-time calculations, such as computing constants
            obj.Buffer = ones(1, obj.N) * obj.InitialOutput;
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = obj.Buffer(end);
            obj.Buffer = [u obj.Buffer(1:end-1)];
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Advanced functions
        function validateInputsImpl(obj,u)
            % Validate inputs to the step method at initialization
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
        end

        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function processTunedPropertiesImpl(obj)
            % Perform actions when tunable properties change
            % between calls to the System object
        end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change
            % between calls to the System object
            flag = false;
        end

        function flag = isInactivePropertyImpl(obj,prop)
            % Return false if property is visible based on object 
            % configuration, for the command line and System block dialog
            flag = false;
        end
    end
end
