classdef sim_gui
% The class SIM_GUI organizes a few static methods that are used to run a
% GUI for viewing and exporting crowd simulation data.
%
%   The class SIM_GUI contains the method launch, which launches a GUI
%   application for viewing crowd simulation data. It also contains the
%   supporting methods plot_all and plot_agents. These methods can also be
%   used on their own to plot crowd simulations.
    
    methods (Static)
        
        launch(sm, sd, sps)
        
        plot_all(hplot, sm, sd, sps, step)
        
        plot_agents(x, r, vector_values, fill_colors, edge_colors)
        
    end
end
