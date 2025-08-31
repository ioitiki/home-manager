{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hy3.packages.${pkgs.system}.hy3 ];

    settings = {
      # Set hy3 as the default layout
      general.layout = "hy3";

      # hy3 plugin configuration
      plugin.hy3 = {
        # Removes gaps when only one window is open
        no_gaps_when_only = 1;
        
        # Node collapse policy
        # 0 - never
        # 1 - no_gaps_when_only
        # 2 - always
        node_collapse_policy = 2;
        
        # Group window inset
        group_inset = 10;
        
        # Whether to place the first window in a group when it's created
        tab_first_window = false;

        # Tab bar configuration
        tabs = {
          height = 22;
          padding = 6;
          from_top = false;
          radius = 6;
          border_width = 2;
          render_text = true;
          text_center = true;
          text_font = "Sans";
          text_height = 8;
          text_padding = 3;
          
          # Tab colors
          "col.active" = "rgba(33ccff40)";
          "col.active.border" = "rgba(33ccffee)";
          "col.active.text" = "rgba(ffffffff)";
          "col.focused" = "rgba(60606040)";
          "col.focused.border" = "rgba(808080ee)";
          "col.focused.text" = "rgba(ffffffff)";
          "col.inactive" = "rgba(30303020)";
          "col.inactive.border" = "rgba(606060aa)";
          "col.inactive.text" = "rgba(ffffffff)";
          "col.urgent" = "rgba(ff223340)";
          "col.urgent.border" = "rgba(ff2233ee)";
          "col.urgent.text" = "rgba(ffffffff)";
          "col.locked" = "rgba(90903340)";
          "col.locked.border" = "rgba(909033ee)";
          "col.locked.text" = "rgba(ffffffff)";
          
          blur = true;
          opacity = 1.0;
        };

        # Autotiling configuration
        autotile = {
          enable = false;
          ephemeral_groups = true;
          trigger_width = 0;
          trigger_height = 0;
          workspaces = "all";
        };
      };

      # hy3-specific keybindings
      bind = [
        # Movement
        "$mainMod, h, hy3:movefocus, l"
        "$mainMod, j, hy3:movefocus, d"
        "$mainMod, k, hy3:movefocus, u"
        "$mainMod, l, hy3:movefocus, r"
        
        # Window movement
        "$mainMod SHIFT, h, hy3:movewindow, l, once"
        "$mainMod SHIFT, j, hy3:movewindow, d, once"
        "$mainMod SHIFT, k, hy3:movewindow, u, once"
        "$mainMod SHIFT, l, hy3:movewindow, r, once"
        
        # Window movement (visible)
        "$mainMod CTRL, h, hy3:movewindow, l, visible"
        "$mainMod CTRL, j, hy3:movewindow, d, visible"
        "$mainMod CTRL, k, hy3:movewindow, u, visible"
        "$mainMod CTRL, l, hy3:movewindow, r, visible"
        
        # Focus parent/child
        "$mainMod, a, hy3:focusparent"
        "$mainMod, d, hy3:focuschild"
        
        # Resizing
        "$mainMod, equal, hy3:resizeactive, exact, 100, 0"
        "$mainMod, minus, hy3:resizeactive, exact, -100, 0"
        "$mainMod SHIFT, equal, hy3:resizeactive, exact, 0, 100"
        "$mainMod SHIFT, minus, hy3:resizeactive, exact, 0, -100"
        
        # Tab group management
        "$mainMod, g, hy3:makegroup, h, force_ephemeral"
        "$mainMod, v, hy3:makegroup, v, force_ephemeral"
        "$mainMod, t, hy3:makegroup, tab"
        "$mainMod SHIFT, t, hy3:makegroup, opposite"
        "$mainMod CTRL, t, hy3:changegroup, toggletab"
        
        # Tab switching
        "$mainMod, bracketleft, hy3:changegroup, b"
        "$mainMod, bracketright, hy3:changegroup, f"
        
        # Splits
        "$mainMod, s, hy3:changefocus, raise"
        "$mainMod SHIFT, s, hy3:changefocus, lower"
        
        # Window control
        "$mainMod, w, hy3:killactive"
        "$mainMod, f, fullscreen, 1"
        "$mainMod SHIFT, f, fullscreen, 0"
        
        # Expand/collapse
        "$mainMod, e, hy3:expand, expand"
        "$mainMod SHIFT, e, hy3:expand, base"
      ];
    };
  };
}
