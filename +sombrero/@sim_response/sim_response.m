%--------------------------------------------------------------------------
% Sombrero is a software for simulating information transfer in
% high-density crowds.
%
% Copyright (C) 2018 Olle Eriksson
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% This file is part of Sombrero.
%
% Sombrero is free software: you can redistribute it and/or modify it under
% the terms of the GNU Lesser General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.
%
% Sombrero is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
% License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with Sombrero. If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

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
