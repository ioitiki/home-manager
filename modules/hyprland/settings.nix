{ ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show combi -combi-modes \"window,drun\" -modes combi";
      "$windowMenu" = "rofi -show window";
      "$powerMenu" = "/home/andy/.config/rofi/power-menu.sh";
      "$screenShotRegion" = "hyprshot -m region --clipboard-only";

      exec-once = [
        "waybar & hyprpaper"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hypridle"
        "sleep 0.25; slack"
        # Launch three terminals with unique titles for manual placement
        "sleep 1; alacritty --title term-left"
        "sleep 1.1; alacritty --title term-middle"
        "sleep 1.2; alacritty --title term-right"
        # Show the special workspace containing the terminals
        "sleep 1.3; hyprctl dispatch togglespecialworkspace alacritty"
      ];

      decoration = {
        rounding = 0;
        blur.enabled = false;
        shadow.enabled = false;
      };

      cursor = {
        inactive_timeout = 1;
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
        "col.active_border" = "rgba(d4b3fcff) rgba(f0e6ffff) 45deg";
        "col.inactive_border" = "rgba(5a5d73cc)";
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
        force_default_wallpaper = 0; # Disable Hyprland's default wallpaper
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";

        kb_options = "caps:ctrl_modifier";
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
        "$mainMod, F, togglefloating,"
        "$mainMod, M, fullscreen, 0" # Toggle fullscreen (mono layout)
        # Span active window across both monitors (assumes 2× 2560x1440 at 0x0 and 2560x0)
        # Adjust numbers if your monitor layout changes
        "$mainMod, B, exec, sh -c \"if hyprctl getoption plugin:hyprbars:enabled | grep -q 'int: 1'; then hyprctl keyword plugin:hyprbars:enabled 0; else hyprctl keyword plugin:hyprbars:enabled 1; fi\""
        "CTRL, SPACE, exec, $menu"
        "ALT, TAB, exec, $windowMenu"
        "ALT, UP, exec, $windowMenu"
        "CTRL SHIFT, 4, exec, $screenShotRegion"
        "$mainMod, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"
        "$mainMod SHIFT, W, exec, hyprctl dispatch killactive"
        "$mainMod, X, exec, $powerMenu"
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
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod, S, togglespecialworkspace, slack"
        "$mainMod SHIFT, S, movetoworkspace, special:slack"
        "$mainMod, R, togglespecialworkspace, rambox"
        "$mainMod SHIFT, R, movetoworkspace, special:rambox"
        "$mainMod, D, togglespecialworkspace, dbeaver"
        "$mainMod SHIFT, D, movetoworkspace, special:dbeaver"
        "$mainMod, T, togglespecialworkspace, alacritty"
        "$mainMod SHIFT, T, movetoworkspace, special:alacritty"
        "$mainMod, minus, togglespecialworkspace, tos"
        "$mainMod SHIFT, minus, movetoworkspace, special:tos"
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
        "float,title:^(Sign in - Google Accounts - Vivaldi)$"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      windowrulev2 = [
        "workspace special:slack silent, class:^(Slack)$"
        "workspace special:slack silent, class:^(slack)$"
        # Slack: sized and centered
        "size 1884 1016, class:^(Slack)$"
        "size 1884 1016, class:^(slack)$"
        "center, class:^(Slack)$"
        "center, class:^(slack)$"
        "workspace special:rambox silent, class:^(Rambox)$"
        "workspace special:rambox silent, class:^(rambox)$"
        "workspace special:dbeaver silent, class:^(DBeaver)$"
        "workspace special:dbeaver silent, class:^(dbeaver)$"
        "workspace special:alacritty silent, class:^(Alacritty)$"
        "workspace special:alacritty silent, class:^(alacritty)$"
        # Think or Swim special workspace rules
        "workspace special:tos silent, class:^(java-lang-Thread)$"
        "size 2026 1224, class:^(java-lang-Thread)$"
        # "float, class:^(java-lang-Thread)$"
        "center, class:^(java-lang-Thread)$"
        # Manual placement for three terminal columns on 2560x1440 monitor
        # Even 15px outer/inner gaps, centered in the top third (y≈80), height 1200
        # Widths sum to 2500 (2560 - 4*15): 833, 833, 834
        "size 833 1200, class:^(Alacritty)$, title:^(term-left)$"
        "move 15 80, class:^(Alacritty)$, title:^(term-left)$"
        "size 833 1200, class:^(Alacritty)$, title:^(term-middle)$"
        "move 863 80, class:^(Alacritty)$, title:^(term-middle)$"
        "size 834 1200, class:^(Alacritty)$, title:^(term-right)$"
        "move 1711 80, class:^(Alacritty)$, title:^(term-right)$"
        "bordercolor rgba(00ff00ff), fullscreen:1" # Green border when in fullscreen/mono mode
        # "size 95% 95%, fullscreen:1" # Make fullscreen window slightly smaller to show border
        # "center, fullscreen:1" # Center the fullscreen window

         # Add these new Cursor rules:
        "center, class:^(Cursor)$, floating:1"
        "center, class:^(Cursor)$, title:^(Are you sure.*)"
        "size 400 200, class:^(Cursor)$, title:^(Are you sure.*)"
        "center, floating:1, maxsize:600 400"
      ];

      monitor = [
        "DP-3, 2560x1440@144,0x0,1"
        "HDMI-A-1, 2560x1440@144,2560x0,1"
      ];

      workspace = [
        "1, monitor:DP-3"
        "2, monitor:DP-3"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-3"
        "6, monitor:DP-3"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
      ];

    };
  };
}
