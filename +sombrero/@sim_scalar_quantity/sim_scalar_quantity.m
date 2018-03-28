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

classdef sim_scalar_quantity < uint32
% Enumeration class SIM_SCALAR_QUANTITY provides a set of members
% corresponding to the different vector quantities that we associate
% to agents in crowd simulations.
%
%   This enumeration class exists to make it easy to specify which scalar
%   quantities that we are interested in when working with data collected
%   from crowd simulations. For example, when plotting simulations, we
%   might be interested in plotting the number of informed neighbors of
%   agents in addition to their positions. To convey this type of
%   information, we use a SIM_SCALAR_QUANTITY object.
    
    enumeration
        none               (1) % No scalar quantity (in practice, zero).
        informed           (2) % Informed or not.
        neighbors          (3) % The number of neighbors.
        informed_neighbors (4) % The number of informed neighbors.
        pressure           (5) % The pressure experienced.
        speed              (6) % The speed.
    end
end
