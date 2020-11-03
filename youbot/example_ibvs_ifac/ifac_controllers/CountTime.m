classdef CountTime < matlab.System
    % Counts Hits and Time
    
    properties(Nontunable)
        SampleTime = 1.4; % Sample Time
        OffsetTime = 0.2; % Offset Time
        TickTime = 0.1;
        SampleTimeTypeProp (1, 1) {mustBeMember(SampleTimeTypeProp, ...
            ["Discrete","FixedInMinorStep","Controllable",...
            "Inherited","InheritedNotControllable",...
            "InheritedErrorConstant"])} = "Discrete"
    end
    
    properties(DiscreteState)
        Count
    end
    
    methods(Access = protected)
        function sts = getSampleTimeImpl(obj)
            switch char(obj.SampleTimeTypeProp)
                case 'Inherited'
                    sts = createSampleTime(obj,'Type','Inherited');
                case 'InheritedNotControllable'
                    sts = createSampleTime(obj,'Type','Inherited',...
                        'AlternatePropagation','Controllable');
                case 'InheritedErrorConstant'
                    sts = createSampleTime(obj,'Type','Inherited',...
                        'ErrorOnPropagation','Constant');
                case 'FixedInMinorStep'
                    sts = createSampleTime(obj,'Type','Fixed In Minor Step');
                case 'Discrete'
                    sts = createSampleTime(obj,'Type','Discrete',...
                      'SampleTime',obj.SampleTime, ...
                      'OffsetTime',obj.OffsetTime);
                case 'Controllable'
                    sts = createSampleTime(obj,'Type','Controllable',...
                        'TickTime',obj.TickTime);
            end
        end
        
        function [Count, Time, SampleTime] = stepImpl(obj,u)
            Count = obj.Count + u;
            obj.Count = Count;
            Time = getCurrentTime(obj);
            sts = getSampleTime(obj);
            if strcmp(sts.Type,'Controllable')
               setNumTicksUntilNextHit(obj,obj.Count);
            end
            SampleTime = sts.SampleTime;
        end
        
        function setupImpl(obj)
            obj.Count = 0;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.Count = 0;
        end
        
        function flag = isInactivePropertyImpl(obj,prop)
            flag = false;
            switch char(obj.SampleTimeTypeProp)
                case {'Inherited', ...
                        'InheritedNotControllable', ...
                        'FixedInMinorStep'}
                    if any(strcmp(prop,{'SampleTime','OffsetTime','TickTime'}))
                        flag = true;
                    end
                case 'Discrete'
                    if any(strcmp(prop,{'TickTime'}))
                        flag = true;
                    end
                case 'Controllable'
                    if any(strcmp(prop,{'SampleTime','OffsetTime'}))
                        flag = true;
                    end
            end
        end
    end
end