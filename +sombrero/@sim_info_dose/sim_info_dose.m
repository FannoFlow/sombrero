classdef sim_info_dose < sim_info_model
% The class SIM_INFO_DOSE implements a so-called dose model of information
% transfer.
%
%   The class SIM_INFO_THRESHOLD implements a model of information transfer
%   that was introduced by P.S. Dodds and D.J. Watts in their 2004 article
%   A generalized model of social and biological contagion. I recommend
%   reading the article in order to get an idea of how the model works.
%   [IMPORTANT: VISUAL FIELD IS IMPLEMENTED FOR THIS INFORMATION TRANSFER
%   MODEL]
%
%   See also SIM_INFO_MODEL SIM_INFO_THRESHOLD SIM_MODEL

    properties
        
        attentiveness = [] % Vector containing each agents attentiveness value. Called exposure probability by Dodds and Watts.
        
        dose_count = [] % Matrix containing the dose counts of each agent for each time step that remains in memory.
        
        dose_threshold = [] % Vector containing the dose threshold of each agent.
        
        dose_size_dist = {} % Vector containing the nonnegative function of zero variables, called the dose size distribution, of each agent.
        
        memory = [] % Vector containing the memory of each agent.
        
    end
    methods
        
        function obj = sim_info_dose(tag, number_of_agents, attentiveness, dose_threshold, dose_size_dist, memory)
        % Constructs a SIM_INFO_DOSE object.
        
            validateattributes(tag, {'string'}, {'size', [1, 1]});
            
            validateattributes(number_of_agents, ...
                               {'numeric'}, ...
                               {'scalar', 'integer', 'nonnegative'});
            validateattributes(attentiveness, ...
                               {'numeric'}, ...
                               {'vector', 'real', 'numel', number_of_agents});
            validateattributes(dose_threshold, ...
                               {'numeric'}, ...
                               {'vector', 'real', 'numel', number_of_agents});
            validateattributes(dose_size_dist, ...
                               {'cell'}, ...
                               {'vector', 'numel', number_of_agents});
            for i = 1 : number_of_agents
                validateattributes(dose_size_dist{i}, ...
                                   {'function_handle'}, {})
            end
            validateattributes(memory, ...
                               {'numeric'}, ...
                               {'vector', 'positive', 'numel', number_of_agents});
            memory = memory(:);
            
            obj.tag = tag;
            obj.number_of_agents = number_of_agents;
            obj.visual_fields = zeros(number_of_agents, 1) + 2 * pi;
            obj.informed_agents = zeros(number_of_agents, 1);
            obj.dose_count = zeros(max([1; memory(memory < Inf)]), number_of_agents);
            obj.attentiveness = attentiveness(:);
            obj.dose_threshold = dose_threshold(:);
            obj.dose_size_dist = dose_size_dist(:);
            obj.memory = memory(:);
            
        end
        
        
        function obj = next_step(obj, adj_matrix, ang_matrix)
        % Returns a SIM_INFO_DOSE object representing the next time step in
        % the simulation.
            
            % Since agents are not neighbors of themselves, we make the
            % elements on the diagonal of the adjacency matrix 0.
            adj_matrix(1:obj.number_of_agents + 1:end) = 0;
            
            % The element at row l column k of the propagator matrix is 1
            % if agent l will expose agent k to an information dose and 0
            % otherwise.
            propagator_matrix = (adj_matrix .* obj.informed_agents) ...
                                .* obj.attentiveness' > rand(size(adj_matrix));
            
            % For each uninformed agent:
            for k = find_(~obj.informed_agents)'
                % If memory is finite, we move the previous dose counts to
                % the side to make room for a new. The oldest dose count is
                % discarded.
                if obj.memory(k) ~= Inf
                    obj.dose_count(1 : obj.memory(k), k) = [0; obj.dose_count(1 : obj.memory(k) - 1, k)];
                end
                % Agent k's dose count for the next time step is the sum of
                % the exposures it receives from already informed
                % neighbors. 
                for l = find_(propagator_matrix(:, k))'
                    obj.dose_count(1, k) = obj.dose_count(1, k) + obj.dose_size_dist{l}();
                end
            end
            
            
            % Compute logical index of agents that have high enough dose
            % count to become informed themselves...
            ids = sum(obj.dose_count, 1)' >= obj.dose_threshold;
            
            % and make them informed.
            obj.informed_agents(ids) = 1;
            
            function indices = find_(M)
            % Custom find function that returns an empty vector when M is
            % a zero matrix (instead of returning a 0x1 emty double column
            % vector). This avoids errors caused by looping over find(M)
            % when M is a zero matrix.
                indices = find(M);
                if isempty(indices)
                    indices = [];
                end
            end
            
        end
        
    end
end
