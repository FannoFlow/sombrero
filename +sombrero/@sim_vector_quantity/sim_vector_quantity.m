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
