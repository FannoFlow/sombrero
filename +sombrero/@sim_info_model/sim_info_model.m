classdef (Abstract) sim_info_model < matlab.mixin.Heterogeneous
% The abstract class SIM_INFO_MODEL provides an interface for different
% information transfer models.
%
%   The purpose of this software is to simulate verbal information transfer
%   in high-density crowds. Agents in the crowd are assumed to be either
%   informed (1) or uninformed (0). At each time step, uninformed
%   individuals may become informed by their already informed neighbors,
%   as information is assumed to flow from informed to uninformed
%   individuals that are close to each other in the crowd. The abstract
%   class SIM_INFO_MODEL provides and interface for different models of
%   verbal information transfer that can run alongside spatial crowd
%   simulations.
%
%   Classes that inherit SIM_INFO_MODEL also encapsulate the data obtained
%   from running simulations of information transfer models. Each
%   SIM_INFO_MODEL object corresponds to a time step in a simulation, and
%   keeps track of which agents where informed at that point in time. The
%   next_step method takes an adjacency matrix adj_matrix (representing
%   physical contact between agents in the crowd) and an angle matrix
%   ang_matrix (representing how far toward the periphery of each agent's
%   field of view we find its neighbors), and returns a new SIM_INFO_MODEL
%   object containing the state of information transfer at the next time
%   step.
%
%   See also SIM_INFO_THRESHOLD SIM_INFO_DOSE SIM_MODEL

    properties
        
        tag = "sim_info_model" % A tag that identifies the model. Must be unique for each model.
        
        number_of_agents % The number of agents in the crowd.
        
        visual_fields = [] % A column vector with the visual field angle for each agent.

        informed_agents = [] % A column vector. Is set to 1 if the corresponding agent is informed, otherwise 0.
        
    end
    methods (Abstract)
        
        next_step(obj, adj_matrix, ang_matrix) % Returns 
        
    end
    methods
        
        function obj = set_visual_fields(obj, vfs)
        % Sets the visual field of every actor.
            
            validateattributes(vfs, ...
                               {'numeric'}, ...
                               {'vector', 'real', 'nonnegative', 'numel', obj.number_of_agents});
            
            obj.visual_fields = vfs(:);
            
        end
        
        function obj = make_informed(obj, ids)
        % Makes the agents corresponding to the indexes in ids informed.
        % Used to initiate information transfer.
            obj.informed_agents(ids) = 1;
        end
        
        function ratio = informed_ratio(obj)
        % Returns the ratio of informed to uninformed agents.
            ratio = sum(obj.informed_agents) / obj.number_of_agents;
        end
        
    end
end
