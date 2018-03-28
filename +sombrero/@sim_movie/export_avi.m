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
