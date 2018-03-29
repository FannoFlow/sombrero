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

function [sm, sd, sps] = example_1
% This function sets up and runs a crowd simulation in which 200 agents try
% to get out through a door simultaneously.

    % The simulation box. It's lower left corner is at (0, 0) and it's
    % width is 35 and it's height is 25.
    box = sim_rectangle(0, 0, 35, 25);

    % The number of agents. Agents are refered to as agent 1, 2, 3 etc.
    n = 200;
    
    % The starting positions of the agents are given as an n x 2 matrix.
    % Agent i's starting position is positions(i, :);
    positions = [box.w * rand(n, 1), box.h * rand(n, 1)];
    
    % The radii of the agents. Agent i's radius is radii(i).
    radii = repmat(0.5, n, 1);

    % The target destinations of the agents. Agent i's target destination
    % is target_destination(i, :).
    target_destinations = repmat([box.w / 2, -15], n, 1);
    
    % The prefered speeds of the agents. Agent i's prefered speed is
    % prefered_speeds(i).
    prefered_speeds = repmat(1, n, 1);
    
    % The behavioral responses of the agents. Agent i's behavioral response
    % in behavioral_response(i). In this example, we are not interested in
    % studying behavioral responses, so we set this property to none for
    % each agent.
    behavioral_responses = repmat(sim_response.none, n, 1);
    
    % The number of walls.
    w = 4;

    % A wall is modeled as a straight line segment, and is represented by a
    % 2 x 2 matrix with the rows representing the endpoints.
    left_wall         = [0               , 0; 0               , box.h];
    right_wall        = [box.w           , 0; box.w           , box.h];
    bottom_left_wall  = [0               , 0; box.w / 2 - 0.75, 0    ];
    bottom_right_wall = [box.w / 2 + 0.75, 0; box.w           , 0    ];

    % We create a sim_model that will be used to run a crowd simulation.
    sm = sim_model;
    
    % We set the simulation box property of sm to match our box above.
    sm.simulation_box = box;
    
    % We populate sm with our agents.
    sm = sm.add_agents(positions,           ...
                       radii,               ...
                       target_destinations, ...
                       prefered_speeds,     ...
                       behavioral_responses     );

    % We add the walls to sm.
    sm = sm.add_walls(w, [left_wall        ; ...
                          right_wall       ; ...
                          bottom_left_wall ; ...
                          bottom_right_wall      ] );

    % We run a simulation of our model sm for 100 time steps using the
    % run_simulation method. This method returns a sim_data object that
    % contains data obtained from the simulation.
    sd = sm.run_simulation(100);
    
    % A sim_plot_style object is needed to plot the simulation data sd.
    % Passing sm to the constructor of sim_plot_style makes sure that we
    % get decent zoom settings right away.
    sps = sim_plot_style(sm);
    
end
