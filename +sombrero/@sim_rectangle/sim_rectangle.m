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
        % Constructs a SIM_RECTANGLE object.
            obj.x = x;
            obj.y = y;
            obj.w = w;
            obj.h = h;
        end
    end
end