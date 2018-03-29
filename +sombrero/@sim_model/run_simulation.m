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

function data = run_simulation(obj, varargin)
% Runs a simulation using the given parameters and initial conditions.
%
%   This method runs a crowd simulation. The initial conditions of the
%   simulation are specified in the object. A velocity Verlet integration
%   scheme is used for computing the trajectories of the agents. Verbal
%   information transfer takes place at each time step. A sim_data object
%   is returned once the simulation is finished.
%
%   RUN_SIMULATION runs a simulation for obj.steps time steps.
%
%   RUN_SIMULATION(steps) runs a simulation for steps time steps.
%
%   See also SIM_DATA

    steps = obj.steps;
    if nargin > 1
        if nargin > 2
            error('Too many input arguments.');
        end
        validateattributes(varargin{1}, ...
                           {'numeric'}, ...
                           {'scalar', 'integer', 'nonnegative'} );
        steps = varargin{1};
    end

    % total_substeps is the total number of integration substeps that is to
    % be performed. Each integration substep is of length delta_t.
    total_substeps = steps * obj.substeps;
    delta_t = 1 / obj.substeps;
    
    n = obj.number_of_agents;
    r = obj.radii;

    n_walls = obj.number_of_walls;
    walls = obj.walls;

    % Matrices to temporarily store positions, accelerations, velocites
    % etc. during integration substeps. We use x0 to hold the positions
    % from the previous substep, and we use x1 to hold the positions that
    % we compute for the current substep etc. At the end of each substep,
    % we let x0 = x1 etc.
    % 
    x0 = obj.positions;
    x1 = zeros(n,2);
    a0 = zeros(n,2);
    a1 = zeros(n,2);
    v0 = zeros(n,2);
    v1 = zeros(n,2);
    
    approx_v1       = zeros(n,2);
    gaze_directions = zeros(2, n);
    move_directions = zeros(2, n);

    pressure = zeros(n, 1);

    % The adjacency matrix of the agent contact network.
    adj = double((x0(:,1) - x0(:,1)').^2 + (x0(:,2) - x0(:,2)').^2 < (r + r').^2);

    % The angle between the vector from agent k to its target, and the
    % vector from k to l, is stored in ang(k, l) whenever k and l are
    % adjacent.
    ang = zeros(n, n);

    % Preallocate space for the simulation data.
    simd.time          = 0 : steps;
    simd.positions     = zeros(obj.number_of_agents, 2, steps + 1);
    simd.velocities    = zeros(obj.number_of_agents, 2, steps + 1);
    simd.accelerations = zeros(obj.number_of_agents, 2, steps + 1);
    simd.directions    = zeros(obj.number_of_agents, 2, steps + 1);
    simd.pressure      = zeros(n, steps + 1);
    simd.adjacency     = cell(steps + 1, 1);
    simd.information   = cell(steps + 1, numel(obj.info_models));

    % Store data from initial time step.
    simd.positions (:, :, 1) = x0;
    simd.velocities(:, :, 1) = v0;
    simd.directions(:, :, 1) = (obj.targets - x0) ./ sqrt(sum((obj.targets - x0)'.^2 ))';
    simd.adjacency{1}        = sparse(adj);
    for j = 1 : numel(obj.info_models)
        simd.information{1, j} = obj.info_models(j);
    end

    current_step = 1;
    freeze_spatial = false;

    for j = 1 : total_substeps

        % The spatial simulation will run as long as freeze_spatial is true
        if freeze_spatial == false

            % Reset temporary variables.
            pressure(:) = 0;
            adj(:) = 0;
            adj(1 : n + 1 : numel(adj)) = 1;
            ang(:) = 0;

            % Calculate new positions using velocity Verlet integration.
            x1 = x0 + (v0 * delta_t) + 0.5 * a0 * delta_t^2;

            % We will need an approximation of the velocities at the next
            % time step, so we compute it here.
            approx_v1 = v0 + a0 * delta_t;

            % Gaze directions are set to point toward each agent's target
            % destination, and are then modified for the informed agents
            % according their respective behavioral response. Move
            % directions are treated similarly.
            gaze_directions = (obj.targets - x1) ./ sqrt(sum((obj.targets - x1)'.^2 ))';
            move_directions = gaze_directions;
            for k = 1 : n
                if ~isempty(simd.information) ...
                   && simd.information{current_step, 1}.informed_agents(k) == 1
                    gaze_directions(k, :) = obj.behavioral_responses(k).get_gaze_dir(gaze_directions(k, :));
                    move_directions(k, :) = obj.behavioral_responses(k).get_move_dir(move_directions(k, :));
                end
            end

            % We need to compute the acceleration of each agent at its new
            % position.

            % First, we add random acceleration.
            a1 = mvnrnd(zeros(2,1), obj.sigma * eye(2), n);

            % Then, for each agent k:
            for k = 1 : n
                
                % Just to make things a bit more neat.
                x = x1(k,:);

                % We need to compute the acceleration toward the target
                % destination.
                u = move_directions(k, :);
                w = gaze_directions(k, :);
                a1(k,:) = a1(k,:) + obj.mu * (obj.prefered_speeds(k) * u - approx_v1(k,:));

                % We need to compute physical interaction forces between
                % agent k and its adjacent agents.
                sq_dists = sum((x1 - repmat(x, n, 1)).^2, 2);
                
                % We only check pairs of agents that we have not already
                % checked.
                for l = k + 1 : n
                    
                    % If agents k and l collide.
                    if sq_dists(l) < (r(k) + r(l))^2
                        
                        % Update the adjacency matrix.
                        adj(k,l) = 1;
                        adj(l,k) = 1;
                        
                        % Let norm_vec be a unit vector pointing from
                        % agent l to k, and let d be the distance from
                        % agent l to k.
                        norm_vec = (x - x1(l,:));
                        dist = norm(norm_vec);
                        norm_vec = norm_vec / dist;

                        % Compute the angle between u and -norm_vec. If
                        % agent k is looking along v, then this angle
                        % describes how far to the side of k's center of
                        % gaze we find l.
                        ang(k, l) = real(acos(dot(w, -norm_vec)));
                        
                        % We also compute where aget k is in l's field of
                        % view. Here w_ is the normal vector from l toward
                        % its target destination.
                        w_ = gaze_directions(l, :);
                        ang(l, k) = real(acos(dot(w_, norm_vec)));
                        
                        % We also need a vector that is tangent to
                        % norm_vec. Let tang_vec be a such vector.
                        tang_vec = fliplr(norm_vec) .* [-1, 1];
                        
                        % Let delta_v_tang be the speed of agent l relative
                        % to the speed of agent k along tang_vec.
                        delta_v_tang = dot(approx_v1(l,:) - approx_v1(k,:), tang_vec);
                        
                        % Calculate the accelerations resulting from the
                        % collision (both repuslion and friction) and
                        % modify the accelerations of agents k and l
                        % accordingly.
                        norm_acc = obj.epsilon * (1.0 - dist / (r(k) + r(l)))^1.5 * norm_vec;
                        tang_acc = obj.kappa * (1.0 - dist / (r(k) + r(l)))^1.5 * delta_v_tang * tang_vec;
                        a1(k,:) = a1(k,:) + (norm_acc + tang_acc);
                        a1(l,:) = a1(l,:) - (norm_acc + tang_acc);
                        
                        % Modify the pressure experienced by agents k and l
                        % so that it takes the collision between k and l
                        % into account.
                        pressure(k) = pressure(k) + norm(norm_acc) / (2 * r(k));
                        pressure(l) = pressure(l) + norm(norm_acc) / (2 * r(l));
                        
                    end
                end

                % We need to compute physical interaction forces between
                % agent k and the walls.
                
                % For each wall l:
                for l = 1 : 2 : 2*n_walls
                    
                    % Let dist be the distance from agent k to wall l, and
                    % let norm_vec be a unit vector pointing from k towards
                    % the point on l that is closest to it.
                    [dist, norm_vec] = sim_model.distance_to_wall(x, walls(l:l+1,:));
                    
                    % If agent k collides with wall l:
                    if dist < r(k)
                        
                        % Let tang_vec be a unit vector that is tangent
                        % norm_vec.
                        tang_vec = fliplr(norm_vec) .* [-1, 1];
                        
                        % We compute the accelerations (both repulsion and
                        % friction) resulting from the collision between
                        % agent k and wall l and modify k's acceleration
                        % accordingly.
                        norm_acc = obj.epsilon * (1.0 - dist / r(k))^1.5 * norm_vec;
                        tang_acc = obj.kappa * (1.0 - dist / r(k))^1.5 * dot(approx_v1(k,:), -tang_vec) * tang_vec;
                        a1(k,:) = a1(k,:) + (norm_acc + tang_acc);
                        
                        % Modify the pressure experienced by agent k so
                        % that it takes the collision between agent k and
                        % wall l into account.
                        pressure(k) = pressure(k) + norm(norm_acc) / (2 * r(k));
                        
                    end
                end

            end

            % We have now computed the acceleration of each agent at its
            % new position. The next step is to calculate the new
            % velocity of each agent.
            v1 = v0 + 0.5 * (a0 + a1) * delta_t;
            
        end

        % If we have reached a new time step.
        if mod(j, obj.substeps) == 0
            
            current_step = j / obj.substeps + 1;

            % Copy the information models from the last time step to the
            % current time step. We will proceed to update their simulation
            % data using the spatial data for the current time step.
            simd.information(current_step, :) = simd.information(current_step - 1, :);

            % If the time step specified by trigger_informed_at is reached
            % we need to find one of the agents that are experiencing the
            % most pressure and make it and its neighbors informed. This is
            % intended to model a situation in which verbal information
            % about a crowd crush starts to spread throughout the crowd.
            if obj.trigger_informed_at == current_step - 1
                
                % Find the agents that are experiencing the most pressure
                % and make one of them, along with its neighbors, informed.
                max_i = find(pressure == max(pressure));
                
                % Each information model operate independently of the
                % others. We thus need to update each one of them.
                for l = 1 : numel(obj.info_models)
                  simd.information{current_step, l} = ...
                      simd.information{current_step, l}.make_informed(find(adj(max_i(1), :)));
                end
                if obj.freeze_after_trigger
                    freeze_spatial = true;
                end
            end
            
            % Save time by avoiding unnecessary checks when
            % pressure_threshold is Inf.
            if obj.pressure_threshold < Inf
                
                % For each agent:
                for k = 1 : n
                    
                    % If agent k is experiencing pressure that exceeds or
                    % equals pressure_threshold, we make it and its
                    % neighbors informed.
                    if pressure(k) >= obj.pressure_threshold
                        
                    % Each information model operate independently of the
                    % others. We thus need to update each one of them.
                        for l = 1 : numel(obj.info_models)
                            simd.information{current_step, l} = ...
                                simd.information{current_step, l}.make_informed(find(adj(k, :)));
                        end
                    end
                end
            end
            
            % We advance the information propagation by one time step for
            % each information model (to get to the current time step).
            for k = 1 : numel(obj.info_models)
                simd.information{current_step, k} = simd.information{current_step, k}.next_step(adj, ang);
            end

            % Simulation data is recorded.
            simd.positions(:, :, current_step) = x1;
            simd.velocities(:, :, current_step) = v1;
            simd.accelerations(:, :, current_step) = a1;
            simd.directions(:, :, current_step) = gaze_directions;
            simd.pressure(:, current_step) = pressure;
            simd.adjacency{current_step} = sparse(adj);
        end

        % To prepare for the next integration substep, we let the new
        % positions, accelerations and velocities become the old ones.
        x0 = x1;
        a0 = a1;
        v0 = v1;

    end

    % The sim_data object data is created from the struct that holds the
    % simulation data. This object provides a more sophisticated interface
    % to the data than the struct does.
    data = sim_data(simd);

end
