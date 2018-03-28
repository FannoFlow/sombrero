classdef sim_plot_style
    % The class SIM_PLOT_STYLE encapsulates data and methods that govern
    % how crowd simulation data is plotted.
    %
    %   The purpose of this class is to encapsulate the data and methods
    %   that specify how plots of crowd simulation data look. For example,
    %   specifications of color gradients that are associated with
    %   different scalar quantities belong in SIM_PLOT_STYLE.
    
    properties
        
        radius_scale_factor = 1 % Agents' radii are scaled by this factor before being plotted.
        
        fill_gradient = ... % Fill color gradients corresponding to scalar quantities (HSV color model).
            {struct('bottom', [0, 0, 1], 'top', [0, 0,   1]); ... % none
             struct('bottom', [0, 0, 1], 'top', [0, 0.5, 1]); ... % informed
             struct('bottom', [0, 0, 1], 'top', [1, 1,   1]); ... % neighbors
             struct('bottom', [0, 0, 1], 'top', [1, 1,   1]); ... % informed neighbors
             struct('bottom', [0, 0, 1], 'top', [0, 1,   1]); ... % pressure
             struct('bottom', [0, 0, 1], 'top', [0, 1,   1])}     % speed
        
        fill_gradient_steps = ... % The number of distinct colors in each gradient.
            [Inf; ... % none
             2;   ... % informed
             9;   ... % neighbors
             9;   ... % informed neighbors
             Inf; ... % pressure
             Inf]     % speed
        
        fill_gradient_range = ... % The values corresponding to, respectively, the bottom and the top color of each gradient.
            [0, 1;  ... % none
            0, 1;  ... % informed
            0, 9;  ... % neighbors
            0, 9;  ... % informed neighbors
            0, 40; ... % pressure
            0, 1]      % speed
        
        scalar_fill_quantity = sim_scalar_quantity.none % The scalar quantity used when plotting.
        
        vector_quantity = sim_vector_quantity.none % The vector quantity used when plotting.
        
        current_info_model = "none" % The information model used when plotting.
        
        show_graph = false % If true, the contact network graph is plotted.
        
        graph_color = [0, 0, 0] % The color of the contact network graph (HSV color model).
        
        show_time = true % If true, the time (in the simulation) is printed on the plot.
        
    end
    methods
        
        function colors = get_gradient_colors(obj, values)
            % Returns the HSV colors corresponding to a vector of values.
            validateattributes(values, {'numeric'}, {'real', 'vector'});
            gid = uint32(obj.scalar_fill_quantity);
            grad = obj.fill_gradient{gid};
            gs = obj.fill_gradient_steps(gid);
            gr = obj.fill_gradient_range(gid, :);
            values = values(:);
            r = numel(values);
            d = gr(2) - gr(1);
            if d == 0
                d = 1;
            end
            x = (min(max(values, gr(1)), gr(2)) - gr(1)) / d;
            if gs ~= Inf
                x = floor(x * gs);
                x(x >= gs) = gs - 1;
                x = x / (gs - 1);
            end
            colors = x .* grad.top + (1 - x) .* grad.bottom;
        end
        
        function cmap = get_colormap(obj)
            % Returns the colormap corresponding to scalar_fill_quantity.
            gid = uint32(obj.scalar_fill_quantity);
            gr = obj.fill_gradient_range(gid, :);
            cmap = obj.get_gradient_colors(linspace(gr(1), gr(2), 256));
        end
        
        function fgr = get_fill_gradient_range(obj)
            % Returns the gradient range corresponding to scalar_fill_quantity.
            gid = uint32(obj.scalar_fill_quantity);
            fgr = obj.fill_gradient_range(gid, :);
        end
        
        function [ticks, tick_labels] = get_colorbar_ticks(obj)
            % Returns the appropriate ticks and tick labels for the colorbar corresponding to scalar_fill_quantity.
            gid = uint32(obj.scalar_fill_quantity);
            fgr = obj.fill_gradient_range(gid, :);
            switch obj.scalar_fill_quantity
                case sim_scalar_quantity.informed
                    ticks = [0.25, 0.75];
                    tick_labels = {'Uninformed', 'Informed'};
                case sim_scalar_quantity.neighbors
                    ticks = fgr(1) + 0.5 : 1 : fgr(2) - 0.5;
                    tick_labels = cell(1, numel(ticks));
                    for i = 1 : numel(ticks)
                        tick_labels{i} = num2str(fgr(1) + i - 1);
                    end
                case sim_scalar_quantity.informed_neighbors
                    ticks = fgr(1) + 0.5 : 1 : fgr(2) - 0.5;
                    tick_labels = cell(1, numel(ticks));
                    for i = 1 : numel(ticks)
                        tick_labels{i} = num2str(fgr(1) + i - 1);
                    end
                otherwise
                    ticks = linspace(fgr(1), fgr(2), 6);
                    tick_labels = cell(1, numel(ticks));
                    for i = 1 : numel(ticks)
                        tick_labels{i} = num2str(ticks(i));
                    end
            end
        end
        
    end
end
