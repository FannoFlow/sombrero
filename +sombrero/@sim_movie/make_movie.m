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

function frames = make_movie(sm, sd, sps, hres, vres, fps, secs_per_step, mtitle)
% Makes a movie from a crowd simulation.
%
%   MAKE_MOVIE uses getframe to save a crowd simulation as a movie. A
%   sim_model object sm along with a corresponding sim_data object sd and a
%   sim_plot_style object sps provides the data needed to render each frame
%   of the movie (via plot_all). A resolution and a frame rate must be
%   specified, as well as the number of seconds in the movie that
%   corresponds to a time step in the simulation, and a title.
%
%   See also PLOT_ALL EXPORT_AVI GETFRAME

    % The total number of frames.
    nfs = sm.steps * fps * secs_per_step;
    
    % This struct is by makemovie
    frames(nfs) = struct('cdata', [], 'colormap', []);
    fig = figure;
    ax = axes;
    
    % Render each frame of the movie:
    for i = 1 : nfs
        t = i * sm.steps / nfs;
        fig.Position = [0, 0, hres, vres];
        sim_gui.plot_all(ax, sm, sd, sps, t);
        title(mtitle);
        frames(i) = getframe(fig);
    end
    
    close(fig);
end
