function plot_agents(positions, radii, dir, fill_colors, edge_colors)
% Plots discs representing agents in the current axes.
%
%   Circular discs representing agents are plotted in the current axes.
%   Lines from the center to the edge of each disc are drawn to show
%   the direction of a vetor quantity (such as velocity).
%
%   See also PLOT_ALL

    [n, ~] = size(positions);
    
    % For each agent:
    for k = 1 : n
        
        % Circular discs can be plotted as rectangles with curvature set to
        % [1, 1].
        rectangle('Position',                                          ...
                  [positions(k,:) - radii(k), 2*radii(k), 2*radii(k)], ...
                  'Curvature', [1, 1],                                 ...
                  'FaceColor', fill_colors(k, :),                      ...
                  'EdgeColor', edge_colors(k, :)                          );
        dir_norm = norm(dir(k,:));
        
        % Draw lines to indicate direction of a vector quantity.
        if dir_norm ~= 0
            v = dir(k,:) / (2 * dir_norm);
            plot([positions(k, 1), positions(k, 1) + v(1)], ...
                 [positions(k, 2), positions(k, 2) + v(2)], ...
                 'Color', [0,0,0]                              );
        end
    end
end
