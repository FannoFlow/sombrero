classdef sim_movie
    % The class SIM_MOVIE contains static methods that are used to export
    % crowd simulation data to movie format.
    
    methods (Static)

        frames = make_movie(sm, sd, sps, xres, yres, fps, secs_per_step, mtitle)
        
        export_avi(frames, fps)
        
    end
end
