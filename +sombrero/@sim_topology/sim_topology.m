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

classdef sim_topology
% Enumeration class SIM_TOPOLOGY provides a set of members corresponding
% to the different topologies.
%
%   Different topologies can be chosen for the simulation boundary box,
%   which corresponds to choosing different boundary values for the
%   boundary box. [IMPORTANT: THIS FEATURE IS NOT YET IMPLEMENTED]
    
    enumeration
        cylinder_h      % A cylinder with the top edge glued to the bottom edge. 
        cylinder_v      % A cylinder with the left edge glued to the right edge.
        moebius_strip_h % A moebius strip with the top edge glued to the bottom edge.
        moebius_strip_v % A moebius strip with the left edge glued to the right edge.
        plane           % A plane.
        torus           % A torus.
    end
end
