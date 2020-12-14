
% open a waitbar
UCP_struct.fig_hdl = waitbar(0, '');

% hide the progress bar and resize it
UCP_struct.Axes_hdl = findobj(UCP_struct.fig_hdl,'Type','Axes');
set(UCP_struct.Axes_hdl, 'Visible','off' );
set(UCP_struct.Axes_hdl, 'units','normalized' );
set(UCP_struct.Axes_hdl, 'position', [0.05    0.05    0.9    0.05] );

%set the size of the main window
screen_size = get(0,'ScreenSize');
set(UCP_struct.fig_hdl, 'Tag', 'a2hbc' );
set(UCP_struct.fig_hdl, 'Resize', 'on' );
set(UCP_struct.fig_hdl, 'Name', 'Control Panel' );
set(UCP_struct.fig_hdl, 'position', [screen_size(3)*0.005 screen_size(4)*0.045 screen_size(3)*0.18 screen_size(4)*0.25] );

UCP_struct.HBC_Controls = uipanel(UCP_struct.fig_hdl, ...
                        'Title', 'Classifier controls', ... 
                        'FontSize', 10,...
                        'Position', [0.0335    0.22    0.9497    0.73]);

UCP_struct.Run_button = uicontrol('style','pushbutton', ...
          'Parent', UCP_struct.HBC_Controls, ...
          'Enable', 'off', ...
          'string', 'Run!', ...
          'FontName','Arial', ...
          'FontSize',10, ...
          'FontWeight','Bold', ...
          'ForegroundColor',[1 0 0], ...
          'units','normalized', ...
          'position', [ 0.783    0.042    0.193    0.119 ], ...
          'callback',@RunNow);

% Operation mode control      
UCP_struct.op_mode_label = uicontrol(  'style','text', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', 'Operation Mode', ...
            'units','normalized', ...
            'position',[ 0.022 0.483 0.22 0.122]);
      
UCP_struct.op_mode = uicontrol(  'style','popupmenu', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', char(cKnownModesOfOperation), ...
            'Value', find( strcmpi(cKnownModesOfOperation, op_mode) ), ...                        
            'units','normalized', ...
            'callback', @OpModeSelect, ...
            'position',[ 0.265 0.479 0.3 0.116 ]);

% Cluster size control      
UCP_struct.SliderLabel = uicontrol(  'style','text', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', [ num2str(CantClusters) ' Clusters' ], ...
            'units','normalized', ...
            'position',[ 0.021 0.218 0.213 0.07]);
      
UCP_struct.CantClusters = uicontrol(  'style','slider', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'Min', 2, ...
            'Value', CantClusters, ...
            'Max', 20, ...
            'SliderStep', [0.05 0.3], ...
            'units','normalized', ...
            'position',[ 0.263 0.214 0.298 0.09], ...
            'callback', @SliderFunc);

% Repetition times control      
UCP_struct.SliderLabel2 = uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'string', [ num2str(iter_times) ' repetition' ], ...
            'units','normalized', ...
            'position',[ 0.021 0.074 0.213 0.07]);
      
UCP_struct.iter_times = uicontrol(  'style','slider', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Min', 1, ...
            'Value', iter_times, ...
            'Max', 10, ...
            'SliderStep', [0.11 0.33], ...
            'units','normalized', ...
            'position',[ 0.263 0.07 0.298 0.09], ...
            'callback', @SliderFunc2);

% Cluster majority control      
UCP_struct.SliderLabel3 = uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'string', ['Cluster majority ' num2str(cluster_presence) ' %'], ...
            'units','normalized', ...
            'position',[ 0.021 0.345 0.213 0.125]);
      
UCP_struct.cluster_presence = uicontrol( ...
            'Enable', 'off', ...
            'style','slider', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Min', 1, ...
            'Value', cluster_presence, ...
            'Max', 100, ...
            'SliderStep', [0.05 0.2], ...
            'units','normalized', ...
            'position',[ 0.263 0.358 0.298 0.09], ...
            'callback', @SliderFunc3);

        
% Class filter and labeling

UCP_struct.labelings_text = uicontrol(  'style','text', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', 'Labeling', ...
            'units','normalized', ...
            'position',[ 0.598 0.483 0.22 0.122]);

aux_idx = find( strcmpi(cKnownLabelings, class_labeling) );

UCP_struct.KnownLabelings = cKnownLabelings;

UCP_struct.labelings = uicontrol(  'style','popupmenu', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', char(cKnownLabelings), ...
            'Value', aux_idx, ...                        
            'callback', @UpdateClasses, ...
            'units','normalized', ...
            'position',[ 0.8 0.479 0.2 0.116 ]);

UCP_struct.class_filter_text = uicontrol(  'style','text', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', 'Classes of Interest', ...
            'units','normalized', ...
            'position',[ 0.598 0.35 0.4 0.122]);

UCP_struct.typical_lablists = typical_lablists;
        
[~, aux_val] = intersect(typical_lablists{aux_idx}, class_filter );

UCP_struct.class_filter = uicontrol('style','listbox', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'Enable', 'off', ...
            'string', char(typical_lablists{aux_idx}), ...
            'Value', aux_val, ...
            'units','normalized', ...
            'position', [ 0.65 0.21 0.33 0.2], ...
            'Max', 2 );
        
%move to user interface window.        
% Close examples control
uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'string', 'Close examples', ...
            'units','normalized', ...
 'Visible','off', ...
            'position',[ 0.598 0.332 0.155 0.125]);

        
UCP_struct.CantSamplesClose = uicontrol(  'style','edit', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', '10', ...
            'Tag', num2str(CantSamplesClose), ...
            'callback', @CheckNumeric, ...
            'units','normalized', ...
 'Visible','off', ...
            'position',[ 0.795 0.353 0.116 0.092]);
        
% Distant examples control
uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'string', 'Distant examples', ...
            'units','normalized', ...
 'Visible','off', ...
            'position',[ 0.589 0.192 0.169 0.125]);

UCP_struct.CantSamplesFar = uicontrol(  'style','edit', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', num2str(CantSamplesFar), ...
            'Tag', '10', ...
            'callback', @CheckNumeric, ...
            'units','normalized', ...
 'Visible','off', ...
            'position',[ 0.791 0.22 0.116 0.093]);

% Recording control
uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', 'Recording', ...
            'callback', @PathCheck, ...
            'units','normalized', ...
            'position',[ 0.008 0.898 0.164 0.067]);

if( isempty(recording_name) )
    rec_str = '';
else
    rec_str = recording_name;
end

UCP_struct.recording_name = uicontrol(  'style','edit', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', rec_str, ...
            'Tag', rec_str, ...
            'callback', @RecordingCheck, ...
            'units','normalized', ...
            'position',[ 0.184 0.885 0.34 0.093 ]);

UCP_struct.Browse_button = uicontrol(  'style','pushbutton', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', 'Browse', ...
            'callback', @BrowseRecording, ...
            'units','normalized', ...
            'position',[ 0.535 0.886 0.158 0.093 ]);

if( isempty(recording_format) )
    rec_fmt = 'AHA';
else
    rec_fmt = recording_format;
end

        
% Recording format control
uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', 'Format', ...
            'units','normalized', ...
            'position',[ 0.72 0.907 0.114 0.059 ]);

UCP_struct.recording_fmt = uicontrol(  'style','popupmenu', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'string', char(cKnownFormats), ...
            'Value', find( strcmpi(cKnownFormats, rec_fmt) ), ...                        
            'units','normalized', ...
            'position',[ 0.848 0.865 0.139 0.116 ]);
        
if( isempty(tmp_path) )
    tmp_path_str = [fileparts(mfilename('fullpath')) filesep];
else
    tmp_path_str = tmp_path;
end
        
% Temporal path control
uicontrol(  'style','text', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', 'Temporal path', ...
            'callback', @PathCheck, ...
            'units','normalized', ...
            'position',[ 0.002 0.72 0.167 0.118]);
        
UCP_struct.tmp_path = uicontrol(  'style','edit', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', tmp_path_str, ...
            'Tag', tmp_path_str, ...
            'callback', @PathCheck, ...
            'units','normalized', ...
            'position',[ 0.182 0.737 0.631 0.093 ]);
        
UCP_struct.Tmp_path_button = uicontrol(  'style','pushbutton', ...
            'Enable', 'off', ...
            'Parent', UCP_struct.HBC_Controls, ...
            'String', 'Browse', ...
            'callback', @BrowseTMPpath, ...
            'units','normalized', ...
            'position',[ 0.824 0.738 0.158 0.093 ]);
        
set(UCP_struct.fig_hdl , 'User', UCP_struct );


