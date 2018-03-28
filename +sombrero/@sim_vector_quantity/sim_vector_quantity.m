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

classdef sim_vector_quantity
% Enumeration class SIM_VECTOR_QUANTITY provides a set of members
% corresponding to the different vector quantities that we associate
% to agents in crowd simulations.
%
%   This enumeration class exists to make it easy to specify which vector
%   quantities that we are interested in when working with data collected
%   from crowd simulations. For example, when plotting simulations, we
%   might be interested in plotting the desired moving directions of agents
%   in addition to their positions. To convey this type of information, we
%   use a SIM_VECTOR_QUANTITY object.

    enumeration
        none         % No vector quantity (in practice, the zero vector).
        direction    % The desired moving direction.
        velocity     % The velocity.
        acceleration % The acceleration.
    end
end
