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
