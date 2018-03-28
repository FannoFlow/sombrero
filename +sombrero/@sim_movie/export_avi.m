function export_avi(frames, fps)
% Export frames as an AVI movie.
%
%   EXPORT_AVI exports a movie created with make_movie as an AVI file.
%
%   See also MAKE_MOVIE

    % Show Save as dialog, then save as AVI file
    [filename, path, ~] = uiputfile({'*.avi'}, 'Save as');
    if ischar(filename)
        vw = VideoWriter([path, filename]);
        vw.FrameRate = fps;
        vw.Quality = 75;
        open(vw);
        writeVideo(vw, frames);
        close(vw);
    end
end
