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
        
        plot_all(ax, sm, sd, sps, step)
        
        plot_agents(ax, x, r, vector_values, fill_colors, edge_colors)
        
    end
end
