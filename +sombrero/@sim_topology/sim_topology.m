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
