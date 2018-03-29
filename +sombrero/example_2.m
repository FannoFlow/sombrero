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

function [sm, sd, sps] = example_2
% This function sets up and runs a crowd simulation in which agents try to
% escape from a crowd crush.

    % The simulation box. It's lower left corner is at (0, 0) and it's
    % width is 25 and it's height is 25.
    box = sim_rectangle(0, 0, 25, 25);

    % The number of agents. Agents are refered to as agent 1, 2, 3 etc.
    n = 500;
    
    % The starting positions of the agents are given as an n x 2 matrix.
    % Agent i's starting position is positions(i, :);
    positions = [box.w * rand(n, 1), box.h * rand(n, 1)];
    
    % The radii of the agents. Agent i's radius is radii(i).
    radii = 0.35 + 0.3 * rand(n, 1);

    % The target destinations of the agents. Agent i's target destination
    % is target_destination(i, :).
    target_destinations = repmat([box.w / 2, box.h + 5], n, 1);
    
    % The prefered speeds of the agents. Agent i's prefered speed is
    % prefered_speeds(i).
    prefered_speeds = 0.75 + 0.75 * rand(1, n);
    
    % The behavioral responses of the agents. Agent i's behavioral response
    % in behavioral_response(i). We want to model a scenario in which
    % people try to get away from a crowd crush, so we set the behavioral
    % response of every agent to reverse. This means that agents will try
    % to move away from their target destination once they become informed
    % about the crowd crush.
    behavioral_responses = repmat(sim_response.reverse, n, 1);
    
    % The number of walls.
    w = 3;

    % A wall is modeled as a straight line segment, and is represented by a
    % 2 x 2 matrix with the rows representing the endpoints.
    left_wall  = [0    , 0    ; 0    , box.h];
    right_wall = [box.w, 0    ; box.w, box.h];
    top_wall   = [0    , box.h; box.w, box.h];
    
    % We want to create a information transfer model to model how
    % information about the crowd crush propagates through the crowd. We
    % use the threshold model, implemented as sim_info_threshold, for this
    % example.
    % For this, we need an influence thresholds for each agent.
    influence_thresholds = randi(5, n, 1);
    
    % We also need to pick a name for the information transfer model.
    info_model_name = "Mixed influence thresholds U(1,5)";
    
    % We need to pass the name, the number of agents and the vector with
    % the influence thresholds to the constructor of sim_info_threshold.
    info_model = sim_info_threshold(info_model_name, ...
                                    n,               ...
                                    influence_thresholds);

    % We create a sim_model that will be used to run a crowd simulation.
    sm = sim_model;
    
    % We set the simulation box property of sm to match our box above.
    sm.simulation_box = box;
    
    % We populate the sm with our agents.
    sm = sm.add_agents(positions,           ...
                       radii,               ...
                       target_destinations, ...
                       prefered_speeds,     ...
                       behavioral_responses     );

    % We add the walls to sm.
    sm = sm.add_walls(w, [left_wall  ; ...
                          right_wall ; ...
                          top_wall         ] );

    % We add the information transfer model to sm.
    sm = sm.add_info_models(info_model);
    
    sm.pressure_threshold = 55;

    % We run a simulation of our model sm for 100 time steps using the
    % run_simulation method. This method returns a sim_data object that
    % contains data obtained from the simulation.
    sd = sm.run_simulation(50);
    
    % A sim_plot_style object is needed to plot the simulation data sd.
    % Passing sm to the constructor of sim_plot_style makes sure that we
    % get decent zoom settings right away.
    sps = sim_plot_style(sm);
    
end
