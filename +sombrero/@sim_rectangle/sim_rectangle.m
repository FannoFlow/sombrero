classdef sim_rectangle
% The class SIM_TOPOLOGY implements a rectangle.
%
%   This class implements a rectangle in the plane as a point (x, y),
%   representing the lower left corner of the rectangle, and a width w and
%   a height h.
    
    properties
        x, y, w, h
    end
    methods
        function obj = sim_rectangle(x, y, w, h)
            obj.x = x;
            obj.y = y;
            obj.w = w;
            obj.h = h;
        end
    end
end