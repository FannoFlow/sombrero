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

function launch(sm, sd, sps)
% Launches a GUI application for viewing crowd simulation data.
%
%   Launches a GUI application for viewing a crowd simulation given by
%   a sim_model object sm along with a corresponding sim_data object sd. A
%   sim_plot_style object sps governs how data is displayed.
%
%   See also SIM_MODEL SIM_DATA SIM_PLOT_STYLE

    % The struct hs holds the GUI components.
    hs = add_components;
    
    reset_zoom;
    makeplot;
    resize_fig;
    
    % The add_components turns off the visibility of the figure window. Now
    % that we are done creating GUI components and plotting data, we turn
    % the visibility back on.
    hs.figure.Visible = 'On';
    
    function hs = add_components
    % Creates GUI components and returns handles to them in the struct hs.
    
        % Turn off the visibility of the figure window while we create GUI
        % components.
        hs.figure = figure('Visible', 'off');
        hs.figure.Name = 'Sombrero';
        
        % We need axes to plot crowd simulation data in:
        hs.axes            = axes;
        hs.axes.Box        = 'on';
        hs.axes.FontName   = 'Helvetica';
        hs.axes.FontSize   = 10;
        hs.axes.TickDir    = 'out';
        hs.axes.TickLength = [0.01, 0.01];
        hs.axes.XMinorTick = 'on';
        hs.axes.YMinorTick = 'on';
        hs.axes.XColor     = [0.3, 0.3, 0.3];
        hs.axes.YColor     = [0.3, 0.3, 0.3];
        rect               = sps.zoom_box;
        hs.axes.XTick      = rect.x : rect.w / 5 : rect.x + rect.w;
        hs.axes.YTick      = rect.y : rect.h / 5 : rect.y + rect.w;
        hs.axes.LineWidth  = 1;
        addlistener(hs.axes, 'XLim', 'PostSet', @(src, evt) x_lim_listener);
        addlistener(hs.axes, 'YLim', 'PostSet', @(src, evt) y_lim_listener);
        
        hs.panel       = uipanel;
        hs.panel.Title = 'Main';
        
        % A slider to act as a "playback bar":
        hs.slider            = uicontrol(hs.panel);
        hs.slider.Style      = 'slider';
        hs.slider.Min        = 0;
        hs.slider.Max        = numel(sd.time) - 1;
        hs.slider.Value      = 0;
        hs.slider.SliderStep = [0.2 / (hs.slider.Max - hs.slider.Min), ...
                                10 / (hs.slider.Max - hs.slider.Min)];
        hs.slider.Units      = 'pixels';
        hs.slider.Position   = [10, 30, 200, 20];
        
        hs.slidertext             = uicontrol(hs.panel);
        hs.slidertext.Style       = 'text';
        hs.slidertext.FontName    = hs.axes.FontName;
        hs.slidertext.FontWeight  = 'bold';
        stext_width               = hs.slidertext.Position(3);
        hs.slidertext.Position(1) = 10 + (200 - stext_width) / 2;
        hs.slidertext.Position(2) = 50;
        
        % Show agents checkbox:
        hs.agent_box            = uicontrol(hs.panel);
        hs.agent_box.Style      = 'checkbox';
        hs.agent_box.FontName   = hs.axes.FontName;
        hs.agent_box.FontWeight = 'bold';
        hs.agent_box.String     = 'Show agents';
        hs.agent_box.Position   = [10, 5, 100, 20];
        hs.agent_box.Min        = 0;
        hs.agent_box.Max        = 1;
        hs.agent_box.Value      = 1;
        hs.agent_box.Callback   = @(obj, event) makeplot;
        
        % Show contact network checkbox:
        hs.graph_box            = uicontrol(hs.panel);
        hs.graph_box.Style      = 'checkbox';
        hs.graph_box.FontName   = hs.axes.FontName;
        hs.graph_box.FontWeight = 'bold';
        hs.graph_box.String     = 'Show network';
        hs.graph_box.Position   = [110, 5, 100, 20];
        hs.graph_box.Min        = 0;
        hs.graph_box.Max        = 1;
        hs.graph_box.Value      = 0;
        hs.graph_box.Callback   = @(obj, event) makeplot;
        
        % A drop-down list for choosing an information model:
        [~, n_options] = size(sd.information);
        options        = cell(1, n_options + 1);
        options{1, 1}  = "none";
        
        for i = 1 : n_options
            options{1, i + 1} = sd.information{1, i}.tag;
        end
        
        hs.info_model_popup          = uicontrol(hs.panel);
        hs.info_model_popup.Style    = 'popup';
        hs.info_model_popup.String   = options;
        hs.info_model_popup.Position = [330, 55, 150, 20];
        hs.info_model_popup.Callback = @(obj, event) makeplot;
        
        hs.info_model_text                     = uicontrol(hs.panel);
        hs.info_model_text.Style               = 'text';
        hs.info_model_text.FontName            = hs.axes.FontName;
        hs.info_model_text.FontWeight          = 'bold';
        hs.info_model_text.HorizontalAlignment = 'right';
        hs.info_model_text.String              = 'Info transfer model: ';
        hs.info_model_text.Position            = [220, 52, 110, 20];
        
        % A drop-down list for choosing a scalar quantity:
        [hs.scalar_quantities, options]   = enumeration('sim_scalar_quantity');
        hs.scalar_quantity_popup          = uicontrol(hs.panel);
        hs.scalar_quantity_popup.Style    = 'popup';
        hs.scalar_quantity_popup.String   = options;
        hs.scalar_quantity_popup.Position = [330, 30, 150, 20];
        hs.scalar_quantity_popup.Callback = @(obj, event) makeplot;
        
        hs.scalar_quantity_text                     = uicontrol(hs.panel);
        hs.scalar_quantity_text.Style               = 'text';
        hs.scalar_quantity_text.FontName            = hs.axes.FontName;
        hs.scalar_quantity_text.FontWeight          = 'bold';
        hs.scalar_quantity_text.HorizontalAlignment = 'right';
        hs.scalar_quantity_text.String              = 'Scalar quantity: ';
        hs.scalar_quantity_text.Position            = [220, 27, 110, 20];
        
        % A drop-down list for choosing a vector quantity:
        [hs.vector_quantities, options]   = enumeration('sim_vector_quantity');
        hs.vector_quantity_popup          = uicontrol(hs.panel);
        hs.vector_quantity_popup.Style    = 'popup';
        hs.vector_quantity_popup.String   = options;
        hs.vector_quantity_popup.Position = [330, 5, 150, 20];
        hs.vector_quantity_popup.Callback = @(obj, event) makeplot;
        
        hs.vector_quantity_text                     = uicontrol(hs.panel);
        hs.vector_quantity_text.Style               = 'text';
        hs.vector_quantity_text.FontName            = hs.axes.FontName;
        hs.vector_quantity_text.FontWeight          = 'bold';
        hs.vector_quantity_text.HorizontalAlignment = 'right';
        hs.vector_quantity_text.String              = 'Vector quantity: ';
        hs.vector_quantity_text.Position            = [220, 2, 110, 20];
        
        % Button to accommodate the extents of all visible objects:
        hs.zoom_extents_button          = uicontrol(hs.panel);
        hs.zoom_extents_button.Style    = 'pushbutton';
        hs.zoom_extents_button.String   = 'Zoom extents';
        hs.zoom_extents_button.Position = [490, 55, 100, 20];
        hs.zoom_extents_button.Callback = @(obj, event) zoom_extents;
        
        % Button to reset the zoom level to the accommodate the simulation
        % box:
        hs.reset_zoom_button          = uicontrol(hs.panel);
        hs.reset_zoom_button.Style    = 'pushbutton';
        hs.reset_zoom_button.String   = 'Reset zoom';
        hs.reset_zoom_button.Position = [490, 30, 100, 20];
        hs.reset_zoom_button.Callback = @(obj, event) reset_zoom;
        
        % Button to launch the AVI movie export dialog:
        hs.movie_button          = uicontrol(hs.panel);
        hs.movie_button.Style    = 'pushbutton';
        hs.movie_button.String   = 'Export as AVI';
        hs.movie_button.Position = [490, 5, 100, 20];
        hs.movie_button.Callback = @(obj, event) export_movie;
        
        % When the playback bar changes value, we need to update the plot.
        addlistener(hs.slider, ...
            'ContinuousValueChange', ...
            @(obj, event) makeplot);
        
        % When the figure window is resized, we need to reposition the GUI
        % components.
        hs.figure.SizeChangedFcn = @(obj, event) resize_fig;
        
    end
    
    function makeplot
    % Plot data to hs.axes. The time t is the value of the playback bar.
        t = hs.slider.Value;
        sps.show_agents          = hs.agent_box.Value;
        sps.show_contact_network = hs.graph_box.Value;
        sps.current_info_model   = hs.info_model_popup.String{hs.info_model_popup.Value};
        sps.scalar_fill_quantity = hs.scalar_quantities(hs.scalar_quantity_popup.Value);
        sps.vector_quantity      = hs.vector_quantities(hs.vector_quantity_popup.Value);
        hs.slidertext.String     = ['t=', num2str(t, '%.1f')];

        sim_gui.plot_all(hs.axes, sm, sd, sps, t);
        drawnow;
    end

    function x_lim_listener
    % When XLim changes, we store the new value in sps so that it can be
    % used in the plot_all method.
        xl = hs.axes.XLim;
        sps.zoom_box.x = xl(1);
        sps.zoom_box.w = xl(2) - xl(1);
    end

    function y_lim_listener
    % When YLim changes, we store the new value in sps so that it can be
    % used in the plot_all method.
        yl = hs.axes.YLim;
        sps.zoom_box.y = yl(1);
        sps.zoom_box.h = yl(2) - yl(1);
    end

    function reset_zoom
    % Resets the zoom level to the accommodate the simulation box.
        sps.zoom_box   = sm.simulation_box;
        view(hs.axes, 0, 90);
        axis(hs.axes, 'equal');
        makeplot();
        
    end

    function zoom_extents
    % Sets the zoom level so that all agents fit inside the axes.
        t = hs.slider.Value;
        sps.zoom_box = sd.get_extents(sm.radii, t);
        view(hs.axes, 0, 90);
        axis(hs.axes, 'equal');
        makeplot();
    end

    function export_movie
    % Open dialog box with options for exporting an AVI movie.
        prompt = {'Enter title:',                 ...
                  'Enter horizontal resolution:', ...
                  'Enter vertical resolution;',   ...
                  'Enter fps:',                   ...
                  'Enter simulation steps per second:'};
        
        dlg_title     = 'Export Movie';
        num_lines     = 1;
        default_ans   = {'', '1280', '720', '30', '0.2'};
        
        % Create dialog box and collect user input.
        answer        = inputdlg(prompt, dlg_title, num_lines, default_ans);
        
        % If answer is empty then the user cancelled the dialog box.
        if ~isempty(answer)
        
            mtitle        = answer{1};
            hres          = str2num(answer{2});
            vres          = str2num(answer{3});
            fps           = str2num(answer{4});
            secs_per_step = str2num(answer{5});
        
            frames = sim_movie.make_movie(sm, sd, sps,          ...
                                          hres, vres, fps,      ...
                                          secs_per_step, mtitle    );
    
            sim_movie.export_avi(frames, fps);
        end
    end

    function resize_fig()
    % Whenever the figure window is resized, the GUI components need to be
    % repositioned. This function does just that.
    
        hs.figure.Units = 'pixels';
        hs.axes.Units   = 'pixels';
        
        width  = hs.figure.Position(3);
        height = hs.figure.Position(4);
        
        h_padding      = 80;
        top_padding    = 15;
        bottom_padding = 150;
        
        hs.axes.Position = ...
            [h_padding,                            ...
             bottom_padding,                       ...
             width - 2 * h_padding,                ...
             height - top_padding - bottom_padding    ];
        
        % Reset to default units.
        hs.axes.Units = 'normalized';
        
        hs.panel.Units       = 'pixels';
        panel_width          = 600;
        panel_height         = 100;
        panel_top_padding    = 40;
        panel_bottom_padding = 20;
        hs.panel.Position    = ...
            [(width - panel_width) / 2, ...
             panel_bottom_padding,      ...
             panel_width,               ...
             bottom_padding - panel_bottom_padding - panel_top_padding];
        
        % Reset to default units.
        hs.panel.Units = 'normalized';
        
    end
end
