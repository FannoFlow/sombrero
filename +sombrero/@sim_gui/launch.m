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
        hs.axes = axes;
        hs.axes.Box = 'on';
        hs.axes.FontName = 'Helvetica';
        hs.axes.FontSize = 10;
        hs.axes.TickDir = 'out';
        hs.axes.TickLength = [0.01, 0.01];
        hs.axes.XMinorTick = 'on';
        hs.axes.YMinorTick = 'on';
        hs.axes.XColor = [0.3, 0.3, 0.3];
        hs.axes.YColor = [0.3, 0.3, 0.3];
        rect = sm.simulation_box;
        hs.axes.XTick = rect.x : rect.w / 5 : rect.x + rect.w;
        hs.axes.YTick = rect.y : rect.h / 5 : rect.y + rect.w;
        hs.axes.LineWidth = 1;
        
        hs.panel = uipanel;
        hs.panel.Title = 'Main';
        
        % A slider to act as a "playback bar":
        hs.slider = uicontrol(hs.panel);
        hs.slider.Style = 'slider';
        hs.slider.Min = 0;
        hs.slider.Max = sm.steps;
        hs.slider.Value = 0;
        hs.slider.SliderStep = [0.2 / (hs.slider.Max - hs.slider.Min), ...
                                10 / (hs.slider.Max - hs.slider.Min)];
        hs.slider.Units = 'pixels';
        hs.slider.Position = [10, 30, 200, 20];
        
        hs.slidertext = uicontrol(hs.panel);
        hs.slidertext.Style = 'text';
        hs.slidertext.FontName = hs.axes.FontName;
        %hs.slidertext.FontSize = hs.axes.FontSize;
        stext_width = hs.slidertext.Position(3);
        hs.slidertext.Position(1) = 10 + (200 - stext_width) / 2;
        hs.slidertext.Position(2) = 50;
        
        % A drop-down list for choosing an information model:
        [~, n_options] = size(sd.information);
        options = cell(1, n_options + 1);
        options{1, 1} = "none";
        for i = 1 : n_options
            options{1, i + 1} = sd.information{1, i}.tag;
        end
        hs.info_model_popup = uicontrol(hs.panel);
        hs.info_model_popup.Style = 'popup';
        hs.info_model_popup.String = options;
        hs.info_model_popup.Position = [220, 55, 100, 20];
        hs.info_model_popup.Callback = @(obj, event) makeplot;
        
        % A drop-down list for choosing a scalar quantity to show:
        [hs.scalar_quantities, options] = enumeration('sim_scalar_quantity');
        hs.scalar_quantity_popup = uicontrol(hs.panel);
        hs.scalar_quantity_popup.Style = 'popup';
        hs.scalar_quantity_popup.String = options;
        hs.scalar_quantity_popup.Position = [220, 30, 100, 20];
        hs.scalar_quantity_popup.Callback = @(obj, event) makeplot;
        
        % A drop-down list for choosing a vector quantity:
        [hs.vector_quantities, options] = enumeration('sim_vector_quantity');
        hs.vector_quantity_popup = uicontrol(hs.panel);
        hs.vector_quantity_popup.Style = 'popup';
        hs.vector_quantity_popup.String = options;
        hs.vector_quantity_popup.Position = [220, 5, 100, 20];
        hs.vector_quantity_popup.Callback = @(obj, event) makeplot;
        
        % A button to launch AVI movie export dialog:
        hs.movie_button = uicontrol(hs.panel);
        hs.movie_button.Style = 'pushbutton';
        hs.movie_button.String = 'Export as AVI';
        hs.movie_button.Position = [320, 5, 100, 20];
        hs.movie_button.Callback = @(obj, event) export_movie;
        
        % When the playback bar changes value, we need to update the plot.
        addlistener(hs.slider, ...
            'ContinuousValueChange', ...
            @(obj, event) makeplot);
        
        % When the figure window is resized, we need to reposition the GUI
        % components.
        hs.figure.SizeChangedFcn = @(obj, event) resize_fig;
    end
    
    function makeplot()
        % Plot data to hs.axes. The time t is the value of the playback
        % bar.
        t = hs.slider.Value;

        sps.current_info_model   =  hs.info_model_popup.String{hs.info_model_popup.Value};
        sps.scalar_fill_quantity =  hs.scalar_quantities(hs.scalar_quantity_popup.Value);
        sps.vector_quantity      =  hs.vector_quantities(hs.vector_quantity_popup.Value);
        hs.slidertext.String     = ['t=', num2str(t, '%.1f')];

        sim_gui.plot_all(hs.axes, sm, sd, sps, t);
        drawnow;
    end

    function export_movie
    % Open dialog box with options for exporting an AVI movie.
        prompt = {'Enter title:', ...
                  'Enter horizontal resolution:', ...
                  'Enter vertical resolution;', ...
                  'Enter fps:', ...
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
        hs.axes.Units = 'pixels';
        
        width = hs.figure.Position(3);
        height = hs.figure.Position(4);
        
        h_padding = 15;
        top_padding = 15;
        bottom_padding = 150;
        
        
        hs.axes.Position = ...
            [h_padding,                           ...
            bottom_padding,                       ...
            width - 2 * h_padding,                ...
            height - top_padding - bottom_padding    ];
        
        % Reset to default units.
        hs.axes.Units = 'normalized';
        
        hs.panel.Units = 'pixels';
        panel_width = 600;
        panel_height = 100;
        panel_top_padding = 40;
        panel_bottom_padding = 20;
        hs.panel.Position = ...
            [(width - panel_width) / 2,                               ...
            panel_bottom_padding,                                     ...
            panel_width,                                              ...
            bottom_padding - panel_bottom_padding - panel_top_padding    ];
        
        % Reset to default units.
        hs.panel.Units = 'normalized';
        
    end
end
