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

function plot_agents(ax, positions, radii, dir, fill_colors, edge_colors)
% Plots discs representing agents in the current axes.
%
%   Circular discs representing agents are plotted in the axes ax. Lines
%   from the center to the edge of each disc are drawn to show the
%   direction of a vetor quantity (such as velocity).
%
%   See also PLOT_ALL

    [n, ~] = size(positions);
    
    % For each agent:
    for k = 1 : n
        
        % Circular discs can be plotted as rectangles with curvature set to
        % [1, 1].
        rectangle(ax,                                                  ...
                  'Position',                                          ...
                  [positions(k,:) - radii(k), 2*radii(k), 2*radii(k)], ...
                  'Curvature', [1, 1],                                 ...
                  'FaceColor', fill_colors(k, :),                      ...
                  'EdgeColor', edge_colors(k, :)                          );
        dir_norm = norm(dir(k,:));
        
        % Draw lines to indicate direction of a vector quantity.
        if dir_norm ~= 0
            v = dir(k,:) / (2 * dir_norm);
            plot(ax,                                        ...    
                 [positions(k, 1), positions(k, 1) + v(1)], ...
                 [positions(k, 2), positions(k, 2) + v(2)], ...
                 'Color', [0,0,0]                              );
        end
    end
end
