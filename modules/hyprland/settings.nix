{ ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show combi -combi-modes \"window,drun\" -modes combi";
      "$screenShotRegion" = "hyprshot -m region --clipboard-only";

      exec-once = [
        "waybar & hyprpaper"
        # "hyprpm reload -n"
      ];

      decoration = {
        rounding = 0;
        # active_opacity = 0.90;
        # inactive_opacity = 0.90;
        # fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };

        shadow = {
          enabled = true;

          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
      };
      
      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "fade_curve, 0, 0.55, 0.45, 1"
        ];

        animation = [
          # name, enable, speed, curve, style

          # Windows
          "windowsIn,   0, 4, easeOutCubic,  popin 20%" # window open
          "windowsOut,  0, 4, fluent_decel,  popin 80%" # window close.
          "windowsMove, 1, 2, fluent_decel, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn,      1, 6,   fade_curve" # fade in (open) -> layers and windows
          "fadeOut,     1, 5,   fade_curve" # fade out (close) -> layers and windows
          "fadeSwitch,  0, 1,   easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow,  1, 10,  easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim,     1, 4,   fluent_decel" # the easing of the dimming of inactive windows
          # "border,      1, 2.7, easeOutCirc"  # for animating the border's color switch speed
          # "borderangle, 1, 30,  fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces,  1, 4,   easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
      };

      # dwindle and master layouts are disabled when using hy3
      # dwindle = {
      #   pseudotile = true;
      #   preserve_split = true;
      # };
      #
      # master = {
      #   new_status = "master";
      # };

      misc = {
        force_default_wallpaper = 0;  # Disable Hyprland's default wallpaper
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";

        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      device = [
        {
          name = "logitech-usb-receiver-mouse";
          accel_profile = "flat";
          sensitivity = 0;
          natural_scroll = true;
        }
        {
          name = "logitech-usb-receiver-1";
          accel_profile = "flat";
          sensitivity = 0;
          natural_scroll = true;
        }
      ];

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod CTRL, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, M, fullscreen, 0"  # Toggle fullscreen (mono layout)
        "CTRL, SPACE, exec, $menu"
        "CTRL SHIFT, 4, exec, $screenShotRegion"
        # "$mainMod, P, pseudo, "  # Not needed with hy3
        # "$mainMod, J, togglesplit, "  # Not needed with hy3
        # Movement handled by hy3 plugin keybindings
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, mouse:274, movewindow"
      ];

      # windowrule
      windowrule = [
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(File Upload)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,class:^(DBeaver)$"
        "float,class:^(dbeaver)$"
        "float,class:^(Slack)$"
        "float,class:^(slack)$"
        "float,class:^(Alacritty)$"
        "float,class:^(alacritty)$"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      monitor = [
        "DP-3, 2560x1440@144,0x0,1"
        "HDMI-A-1, 2560x1440@144,2560x0,1"
      ];

      # No gaps when only
      workspace = [
        "1, monitor:DP-3"
        "2, monitor:HDMI-A-1"
      ];

    };
  };
}