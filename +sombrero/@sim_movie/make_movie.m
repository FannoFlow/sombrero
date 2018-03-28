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
