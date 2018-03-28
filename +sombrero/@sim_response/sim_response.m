classdef sim_response
% Enumeration class SIM_RESPONSE provides a set of members corresponding to
% different behavioral responses to information.
%
%   When agents in a crowd become informed of an ongoing crowd crush (or a
%   similar situation) they will likely change their behavior. The
%   enumeration class SIM_RESPONSE provides a set of members that
%   correspond to different such changes of behavior in response to
%   information. We call such changes "behavioral responses", and their
%   inner workings are encapsulated in this class.
    
    enumeration
        none    % No behavioral response (a.k.a. act as if nothing happened).
        stop    % Stop trying to reach the target destination.
        reverse % Move away from the target destination.
    end
    methods
        function u = get_move_dir(obj, v)
            % Returns a modified move direcion.
            %   See also RUN_SIMULATION
            if obj == sim_response.stop
                u = 0 * v;
            elseif obj == sim_response.reverse
                u = -v;
            else
                u = v;
            end
        end
        
        function u = get_gaze_dir(obj, v)
            % Returns a modified gaze direcion.
            %   See also RUN_SIMULATION
            if obj == sim_response.reverse
                u = -v;
            else
                u = v;
            end
        end
        
        function s = to_string(obj)
            % Returns a string with the name of the behavioral response.
            if obj == sim_response.stop
                s = 'stop';
            elseif obj == sim_response.reverse
                s = 'reverse direction';
            else
                s = 'none';
            end
        end
    end
end
