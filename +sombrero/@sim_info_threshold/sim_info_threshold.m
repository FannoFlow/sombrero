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

classdef sim_info_threshold < sim_info_model
% The class SIM_INFO_THRESHOLD implements a threshold model of information
% transfer.
%
%   The class SIM_INFO_THRESHOLD implements a model of information transfer
%   that works as follows: at each time step, an uninformed agent becomes
%   informed if it has enough informed neighbors. The concept of "enough"
%   is implemented as a threshold, called the influence threshold, for each
%   agent.
%
%   See also SIM_INFO_MODEL SIM_INFO_DOSE SIM_MODEL

    properties
        
        influence_threshold = [] % Vector containing the influence thresholds of the agents.
        
    end
    methods
        
        function obj = sim_info_threshold(tag, number_of_agents, influence_threshold)
        % Constructs a SIM_INFO_THRESHOLD object.
            
            validateattributes(tag, {'string'}, {'size', [1, 1]});
            
            validateattributes(number_of_agents,...
                               {'numeric'},...
                               {'scalar', 'integer', 'nonnegative'});
            
            validateattributes(influence_threshold,...
                               {'numeric'}, ...
                               {'vector', 'real', 'numel', number_of_agents});

            obj.tag                 = tag;
            obj.number_of_agents    = number_of_agents;
            obj.visual_fields       = zeros(number_of_agents, 1) + 2 * pi;
            obj.informed_agents     = zeros(number_of_agents, 1);
            obj.influence_threshold = influence_threshold(:);
        end
        
        function obj = next_step(obj, adj_matrix, ang_matrix)
        % Returns a SIM_INFO_THRESHOLD object representing the next time
        % step in the simulation.

            % Since agents are not neighbors of themselves, we make the
            % elements on the diagonal of the adjacency matrix 0.
            adj_matrix(1:obj.number_of_agents + 1:end) = 0;
            
            % Remove neighbors that are outside of the field of view.
            adj_matrix = adj_matrix .* (2 * ang_matrix <= obj.visual_fields)';
            
            % Compute logical index of agents that have enough informed
            % neighbors inside their field of view to become informed
            % themselves...
            ids = sum(adj_matrix .* obj.informed_agents) >= obj.influence_threshold';
            
            % and make them informed.
            obj.informed_agents(ids) = 1;
        end
        
    end
end
