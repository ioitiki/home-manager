{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3 ];

    settings = {
      # Set hy3 as the default layout
      general.layout = "hy3";

      # hy3 plugin configuration
      plugin.hy3 = {
        # Removes gaps when only one window is open
        no_gaps_when_only = 0;

        # Node collapse policy
        # 0 - never
        # 1 - no_gaps_when_only
        # 2 - always
        node_collapse_policy = 0;

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
        # Only enable on workspace 10 (vertical monitor)
        autotile = {
          enable = true;
          ephemeral_groups = true;
          # Split vertically when width < 1200 (vertical monitor is 1080 wide)
          trigger_width = 1200;
          trigger_height = 0;
          workspaces = "10";
        };
      };

      # # hy3-specific keybindings
      bind = [
        "$mainMod, down, hy3:movewindow, down"
        "$mainMod, up, hy3:movewindow, up"
        "$mainMod, left, hy3:movewindow, left"
        "$mainMod, right, hy3:movewindow, right"
        "ALT SHIFT, left, hy3:movewindow, left"
        "ALT SHIFT, right, hy3:movewindow, right"

        # Window movement
        "$mainMod SHIFT, left, movewindow, mon:l"
        "$mainMod SHIFT, right, movewindow, mon:r"
        "$mainMod, j, hy3:movefocus, left"
        "$mainMod, k, hy3:movefocus, right"
        # Toggle split orientation (h=horizontal/columns, v=vertical/stacked)
        "$mainMod, backslash, hy3:changegroup, toggletab"
        "$mainMod SHIFT, backslash, hy3:changegroup, opposite"
      ];
    };
  };
}
