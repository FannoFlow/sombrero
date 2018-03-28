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

function [dist, dir] = distanceToWall(p, wall)
% Computes the distance and direction from a point to a wall.
%    A wall is represented by a straight line segment in the form of a 2x2
%    matrix where each row contains the coordinate of an endpoint. This
%    method computes the shortest distance from the point p to the wall l,
%    as well as the unit vector pointing from p to l along the direction
%    corresponding to this distance.

    % After performing a translation to get things set up the way we want
    % them, we compute the orthogonal projection of p onto the wall.
    u = wall(2,:) - wall(1,:);
    q = p - wall(1,:);
    c = sum(q .* u) / sum(u .* u);
    
    % We distinguish between three different cases:
    
    % 1: The projection lies outside l, and is closest to its 1st endpoint.
    %    This means that the closest point to p on l is the 1st endpoint.
    if c < 0
        dist = norm(q);
        dir = q / dist;
        
    % 2: The projection lies outside l, and is closest to its 2nd endpoint.
    %    This means that the closest point to p on l is the 2nd endpoint.
    elseif c > 1
        q = p - wall(2, :);
        dist = norm(q);
        dir = q / dist;
        
    % 1: The projection lies on l.
    %    This means that the closest point to p on l is p's projection.
    else
        proj = c * u;
        v = q - proj;
        dist = norm(v);
        dir = v / dist;
    end

end
