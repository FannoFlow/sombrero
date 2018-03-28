function plot_all(hplot, sm, sd, sps, t)
% Plots crowd simulation data.
%
%   This method takes an axes handle hplot, a SIM_MODEL object sm with a
%   corresponding SIM_DATA object sd, a SIM_PLOT_STYLE object sps, and a
%   time t, and plots the data from sd at time t. What data is to be
%   included in the plot, as well as how it is to be presented, is
%   specified in sps.
%
%   See also SIM_MODEL, SIM_DATA, SIM_PLOT_STYLE

    %----------------------------------------------------------------------
    % First, we collect the data that we need from sd.
    %----------------------------------------------------------------------

    % We add one since MATLAB uses 1-based indexing.
    step = floor(t) + 1;

    % The current info model index, cimi. A value of -1 indicates that
    % there is no current info model.
    cimi = -1;
    [~, n_info_models] = size(sd.information);
    for i = 1 : n_info_models
        if sps.current_info_model == sd.information{1, i}.tag
            cimi = i;
            break;
        end
    end
    
    % The appropriate color gradient is used to map the chosen scalar
    % quantity (such as pressure or speed) to a fill color for each agent.
    gradient_values = [];
    switch sps.scalar_fill_quantity
        
        case sim_scalar_quantity.pressure
            gradient_values = sd.get_pressure(t);
            
        case sim_scalar_quantity.speed
            gradient_values = sd.get_speed(t);
            
        case sim_scalar_quantity.neighbors
            gradient_values = sum(sd.adjacency{step}) - 1;
            
        case sim_scalar_quantity.informed
            gradient_values = zeros(sm.number_of_agents, 1);
            if cimi ~= -1
                gradient_values = sd.information{step, cimi}.informed_agents;
            end
            
        case sim_scalar_quantity.informed_neighbors
            gradient_values = zeros(sm.number_of_agents, 1);
            if cimi ~= -1
                gradient_values = sum(sd.adjacency{step} .* sd.information{step, i}.informed_agents) - 1;
                gradient_values(gradient_values < 0) = 0;
            end
            
        otherwise
            gradient_values = zeros(sm.number_of_agents, 1);
            
    end
    fill_colors = hsv2rgb(sps.get_gradient_colors(gradient_values));
    
    cm = colormap(hplot, hsv2rgb(sps.get_colormap));
    cb = colorbar(hplot);
    caxis(hplot, sps.get_fill_gradient_range);
    [cb_ticks, cb_tick_labels] = sps.get_colorbar_ticks;
    cb.Ticks = cb_ticks;
    cb.TickLabels = cb_tick_labels;

    % The direction of the chosen vector quantity is indicated by a line
    % for each agent.
    vector_values = [];
    switch sps.vector_quantity
        
        case sim_vector_quantity.velocity
            vector_values = sd.get_velocities(t);
            
        case sim_vector_quantity.acceleration
            vector_values = sd.get_accelerations(t);
            
        case sim_vector_quantity.direction
            vector_values = sd.get_directions(t);
            
        otherwise
            vector_values = zeros(sm.number_of_agents, 2);
            
    end
    
    %----------------------------------------------------------------------
    % Second, we plot the data.
    %----------------------------------------------------------------------
    
    axes(hplot);
    cla;
    hold on;
    
    % Plot the agents.
    x = sd.get_positions(t);
    r = sps.radius_scale_factor * sm.radii;
    edge_colors = repmat([0, 0, 0], sm.number_of_agents, 1);
    sim_gui.plot_agents(x, r, vector_values, fill_colors, edge_colors);
    
    % Plot the walls.
    walls = sm.walls;
    for k = 1 : 2 : 2 * sm.number_of_walls
        plot( [walls(k,1), walls(k+1,1)], ...
              [walls(k,2), walls(k+1,2)], ...
              'Color', 'k',               ...
              'LineWidth', 2                 );
    end
    
    % Plot the contact network.
    if sps.show_graph == false
        
        G = graph(sd.adjacency{step}, 'OmitSelfLoops');
        graph_color = hsv2rgb(sps.graph_color);
        
        u = plot(G, '.',                   ...
                 'NodeLabel', {},          ...
                 'EdgeColor', graph_color, ...
                 'NodeColor', 'k'             );
        
        u.XData = x(:,1)';
        u.YData = x(:,2)';
    end
    
    
    axis square;
    rect = sm.simulation_box;
    axis([rect.x, rect.x + rect.w, rect.y, rect.y + rect.h]);
    
    if sps.show_time == true
        text(rect.x + 0.04 * rect.w, ...
             rect.y + rect.h - 0.04 * rect.h, ....
             ['t=', num2str(t, '%.1f')] );
    
    hold off;
end
