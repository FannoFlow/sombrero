classdef sim_model
% The class SIM_MODEL encapsulates the data needed to run crowd
% simulations.
%
%   A SIM_MODEL object is required to run crowd simulations. Once the
%   object has been put together, the run_simulation method can be run to
%   obtain a SIM_DATA object.
    
    properties

        %------------------------------------------------------------------
        % Properties related to simulation length and discretization
        %------------------------------------------------------------------

        steps    = 200 % The number of time steps in the simulation.
        substeps = 10  % The number of integration steps that is carried out per time step.

        %------------------------------------------------------------------
        % Properties related to simulation geometry
        %------------------------------------------------------------------

        simulation_box = sim_rectangle(0.0, 0.0, 50.0, 50.0) % The rectangle in which the simulation takes place.
        boundary_conditions = sim_topology.plane % A topology that defines the boundary conditions of the simulation box.

        %------------------------------------------------------------------
        % Properties related to agents (SPPs)
        %------------------------------------------------------------------

        number_of_agents = 0  % The number of agents in the simulation.
        positions        = [] % The initial positions of the agents.
        radii            = [] % The radii of the agents.
        targets          = [] % The target destinations of the agents.
        prefered_speeds  = [] % The preferred speeds of the agents.

        %------------------------------------------------------------------
        % Walls
        %------------------------------------------------------------------

        number_of_walls = 0  % The number of walls in the simulation.
        walls           = [] % The coordinates of the endpoints of each wall (a row corresponds to an endpoint, two rows to a wall).

        %------------------------------------------------------------------
        % Simulation "force-model" coefficients
        %------------------------------------------------------------------

        
        epsilon = 25.0 % Parameter pertaining to repulsion due to physical interactions.
        kappa   =  0.0 % Parameter pertaining to friction.
        mu      =  1.0 % Parameter pertaining to acceleration toward target destinations.
        sigma   =  1.0 % Parameter pertaining to the size of random movements.

        %------------------------------------------------------------------
        % Information propagation models
        %------------------------------------------------------------------

        pressure_threshold   = Inf   % The minimum pressure at which agents become informed (along with their neighbors).
        trigger_informed_at  = 60    % The time step at which the agent that is experiencing the most pressure becomes informed (along with its neighbors).
        freeze_after_trigger = false % If true, the agents stop moving after the first agent becomes informed.
        info_models          = []    % The information models used, in the form of a vector of sim_info_model objects.
        behavioral_responses = []    % The behavioral responses of each agent.

    end
    methods

        function obj = add_agents(obj, positions, radii, targets,...
                                  prefered_speeds, behavioral_responses)
            % Adds agents at their initial positions to the model.

            [n, w] = size(positions);

            % FIX SO THAT BOTH ROW AND COLUMN VECTORS ARE VALID!!!
            validateattributes(positions, {'numeric'}, {'size', [n, 2]});
            validateattributes(radii, {'numeric'},...
                               {'positive', 'numel', n});
            validateattributes(targets, {'numeric'}, {'size', [n, 2]});
            validateattributes(prefered_speeds, {'numeric'},...
                               {'nonnegative', 'numel', n});
            validateattributes(behavioral_responses, {'sim_response'},...
                               {'vector', 'numel', n});

            obj.number_of_agents = obj.number_of_agents + n;
            obj.positions = [obj.positions; positions];
            obj.radii = [obj.radii; radii];
            obj.targets = [obj.targets; targets];
            obj.prefered_speeds = [obj.prefered_speeds; prefered_speeds(:)];
            obj.behavioral_responses = [obj.behavioral_responses; behavioral_responses(:)];
        end

        function obj = add_walls(obj, number_of_walls, walls)
            % Adds walls to the model.
            obj.number_of_walls = obj.number_of_walls + number_of_walls;
            obj.walls = [obj.walls; walls];
        end

        function obj = add_info_models(obj, info_models)
            % Adds information models to the model.
            %   See also SIM_INFO_MODEL.
            validateattributes(info_models, {'sim_info_model'}, {'vector'});
            obj.info_models = [obj.info_models; info_models(:)];
        end

        data = run_simulation(obj)

    end
    methods (Static)

        [dist, dir] = distance_to_wall(p, wall)

    end

end
