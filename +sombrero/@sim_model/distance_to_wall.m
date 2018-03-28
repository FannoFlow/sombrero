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
